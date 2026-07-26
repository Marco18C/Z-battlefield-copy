-- =====================================================
--  SISTEMA DE DISPAROS (RAYCAST)
-- =====================================================
-- Los disparos se disparan desde el sistema de animaciones,
-- usando el mismo mecanismo que ya existe en soldier_anims.lua:
--
--   {part = "weapon", side = "func", prop = function(weapon, ent)
--       soldierScripts.shoot.fire(ent, weapon, { ...config... })
--   end}
--
-- Esa función se ejecuta automáticamente cuando el frame de la
-- animación termina (ver soldier_anims.lua), así que basta con
-- poner esta llamada en el frame exacto donde debe salir el disparo.
--
-- config soportada en shoot.fire(unit, weapon, config) — TODO configurable,
-- con valores por defecto si no se especifican:
--   side                -> "R" o "L", mano desde la que sale el disparo (default "R")
--   offsetX, offsetY    -> posición del cañón relativa a la mano (espacio local de la mano,
--                          rotado junto con ella). offsetX = hacia adelante, offsetY = lateral.
--   rotation            -> rotación extra sumada al ángulo de la mano (dispersión / retroceso)
--   maxDistance         -> alcance máximo del raycast
--   damage              -> daño aplicado si impacta a un soldado (resultado con mínimo 0)
--   objectDamagePercent -> % (0-1) de "damage" que se aplica si impacta un objeto,
--                          ya que los objetos son proporcionalmente más resistentes
-- =====================================================

local shoot = {}

local debugEnabled = false
local traces = {}

local TRACE_LIFETIME = 0.15 -- segundos que una traza de debug permanece visible en pantalla

-- =========================
-- utilidades
-- =========================
local function getHand(unit, side)
    if side == "L" then
        return unit.parts.LEFTforearm.arm.hand
    end
    return unit.parts.RIGHTforearm.arm.hand
end

-- Intersección rayo vs caja orientada (OBB) mediante slab test.
-- ox,oy   = origen del rayo · dx,dy = dirección del rayo (vector unitario)
-- cx,cy   = centro de la caja · halfW,halfH = mitad de ancho / mitad de alto
-- cosR,sinR = coseno/seno de la rotación de la caja (mismo criterio que loadCSrot/resolveRotatedCollision)
-- maxDist = distancia máxima a considerar
-- devuelve la distancia (t) del impacto más cercano, o nil si no hay intersección
local function rayVsOrientedBox(ox, oy, dx, dy, cx, cy, halfW, halfH, cosR, sinR, maxDist)
    -- pasar el rayo al espacio local de la caja (rotación inversa, igual que en soldier_update.lua)
    local relX, relY = ox - cx, oy - cy

    local localOX =  relX * cosR + relY * sinR
    local localOY = -relX * sinR + relY * cosR

    local localDX =  dx * cosR + dy * sinR
    local localDY = -dx * sinR + dy * cosR

    local tmin, tmax = 0, maxDist

    if math.abs(localDX) < 1e-8 then
        if localOX < -halfW or localOX > halfW then return nil end
    else
        local t1 = (-halfW - localOX) / localDX
        local t2 = ( halfW - localOX) / localDX
        if t1 > t2 then t1, t2 = t2, t1 end
        if t1 > tmin then tmin = t1 end
        if t2 < tmax then tmax = t2 end
        if tmin > tmax then return nil end
    end

    if math.abs(localDY) < 1e-8 then
        if localOY < -halfH or localOY > halfH then return nil end
    else
        local t1 = (-halfH - localOY) / localDY
        local t2 = ( halfH - localOY) / localDY
        if t1 > t2 then t1, t2 = t2, t1 end
        if t1 > tmin then tmin = t1 end
        if t2 < tmax then tmax = t2 end
        if tmin > tmax then return nil end
    end

    if tmax < 0 then return nil end -- la caja queda detrás del origen del rayo

    return math.max(tmin, 0)
end

-- =========================
-- disparo principal
-- =========================
-- unit   -> el soldado que dispara (el "ent" que llega al callback de la animación)
-- weapon -> el arma actual (unit.magazine[unit.magazine.actual], ya lo recibe el callback)
-- cfg    -> tabla de configuración del disparo (ver cabecera del archivo)
function shoot.fire(unit, weapon, cfg)
    cfg = cfg or {}

    local side        = cfg.side or "R"
    local offsetX     = cfg.offsetX or 0
    local offsetY     = cfg.offsetY or 0
    local rotation    = cfg.rotation or 0
    local maxDistance = cfg.maxDistance or 2000
    local damage      = cfg.damage or weapon.damage or 0
    local objectDamagePercent = cfg.objectDamagePercent or 0.3

    local hand = getHand(unit, side)

    local handCos = math.cos(hand.rx)
    local handSin = math.sin(hand.rx)

    -- posición mundial del cañón: el offset se define en el espacio local de la mano
    -- y se rota junto con ella (así el offset sigue siendo válido sin importar hacia dónde apunte)
    local originX = hand.x + (offsetX * handCos - offsetY * handSin)
    local originY = hand.y + (offsetX * handSin + offsetY * handCos)

    -- dirección final del disparo = ángulo de la mano + rotación extra (dispersión/retroceso)
    local angle = hand.rx + rotation
    local dirX, dirY = math.cos(angle), math.sin(angle)

    local closestDist = maxDistance
    local hitType, hitTarget = nil, nil

    -- =========================
    -- contra otros soldados
    -- =========================.
    for _, other in ipairs(soldiers) do
        if other ~= unit then
            local torso = other.parts.torso
            local cosT, sinT = math.cos(torso.rx), math.sin(torso.rx)

            local t = rayVsOrientedBox(
                originX, originY, dirX, dirY,
                torso.x, torso.y, torso.w, torso.h,
                cosT, sinT, closestDist
            )

            if t then
                closestDist = t
                hitType   = "soldier"
                hitTarget = other
            end
        end
    end

    -- =========================
    -- contra objetos del mapa
    -- =========================
    for _, obj in ipairs(unit.actualChunk) do
        local cosO = obj.cos or math.cos(obj.rx or 0)
        local sinO = obj.sin or math.sin(obj.rx or 0)

        local die = obj.health < 1
        local t = rayVsOrientedBox(
            originX, originY, dirX, dirY,
            obj.x, obj.y, obj.w / 2, obj.h / 2,
            cosO, sinO, closestDist
        )

        if die then
            obj.die = true
        end

        if t and not die then
            closestDist = t
            hitType   = "object"
            hitTarget = obj
        end
    end

    -- =========================
    -- aplicar daño según qué se impactó
    -- =========================
    if hitType == "soldier" then
        hitTarget.stats.containment = true

        local currentHealth = hitTarget.stats.health or hitTarget.stats.maxHealth or 100
        hitTarget.stats.health = math.max(0, currentHealth - damage)

    elseif hitType == "object" then
        -- los objetos son porcentualmente más resistentes: solo reciben
        -- un % configurable del daño que recibiría un soldado
        local currentHealth = hitTarget.health or hitTarget.maxHealth or 100
        hitTarget.health = math.max(0, currentHealth - (damage * objectDamagePercent))
    end

    -- =========================
    -- guardar traza para el debug visual (F3)
    -- =========================
    local endX = originX + dirX * closestDist
    local endY = originY + dirY * closestDist

    traces[#traces + 1] = {
        x1 = originX, y1 = originY,
        x2 = endX,    y2 = endY,
        hit  = hitType ~= nil,
        life = TRACE_LIFETIME,
    }

    return hitType, hitTarget, closestDist
end

-- =========================
-- debug visual (tecla F3)
-- =========================
function shoot.toggleDebug()
    debugEnabled = not debugEnabled
end

function shoot.isDebugEnabled()
    return debugEnabled
end

-- llamar una vez por frame (no por soldado) para que las trazas se vayan apagando
function shoot.update(dt)
    for i = #traces, 1, -1 do
        traces[i].life = traces[i].life - dt
        if traces[i].life <= 0 then
            table.remove(traces, i)
        end
    end
end

-- dibuja las trazas activas si el debug está encendido (llamar dentro del
-- espacio de coordenadas ya transformado, ver soldier_draw.lua)
function shoot.drawDebug()
    if not debugEnabled then return end

    love.graphics.setLineWidth(2)

    for _, trace in ipairs(traces) do
        local a = math.max(0, trace.life / TRACE_LIFETIME)

        if trace.hit then
            love.graphics.setColor(1, 0.2, 0.2, a)       -- rojo: impactó algo
        else
            love.graphics.setColor(1, 0.9, 0.2, a * 0.7) -- amarillo: se perdió en el vacío
        end

        love.graphics.line(trace.x1, trace.y1, trace.x2, trace.y2)
        love.graphics.circle("fill", trace.x1, trace.y1, 3)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return shoot