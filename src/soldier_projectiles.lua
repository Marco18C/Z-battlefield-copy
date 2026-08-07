local prop = {}

prop.projectiles = {}
prop.textures = {}

-- ==========================================================
-- CONFIG / SUPUESTOS (ajusta según tu sistema real)
-- ==========================================================
-- Se asume gen.CHUNK_SIZE (tamaño de chunk en px) y que cada
-- chunk tiene una lista .objects con: x, y, w, h, rx, cos, sin
local CHUNK_SIZE = gen and gen.src and gen.src.CHUNK_SIZE

-- ==========================================================
-- COLISIONES, texto para que valga la pena el espacio
-- ==========================================================
-- resuelve colisiones y devuelve normales.
local function resolveRotatedCollision(px, py, w, h, obj)
    local hw, hh = w/2, h/2
    local ox, oy = obj.x, obj.y

    local dx = px - ox
    local dy = py - oy

    local cosR = obj.cos or math.cos(obj.rx or 0)
    local sinR = obj.sin or math.sin(obj.rx or 0)
    local localX =  dx * cosR + dy * sinR
    local localY = -dx * sinR + dy * cosR

    local halfW = obj.w/2
    local halfH = obj.h/2

    local penX = (halfW + hw) - math.abs(localX)
    local penY = (halfH + hh) - math.abs(localY)

    local nx, ny -- normal en espacio local del objeto

    if penX < penY then
        if localX > 0 then
            localX = halfW + hw
            nx, ny = 1, 0
        else
            localX = -halfW - hw
            nx, ny = -1, 0
        end
    else
        if localY > 0 then
            localY = halfH + hh
            nx, ny = 0, 1
        else
            localY = -halfH - hh
            nx, ny = 0, -1
        end
    end

    local worldX = ox + (localX * cosR - localY * sinR)
    local worldY = oy + (localX * sinR + localY * cosR)

    -- normal transformada a espacio mundo (para el rebote)
    local worldNX = nx * cosR - ny * sinR
    local worldNY = nx * sinR + ny * cosR

    return worldX, worldY, worldNX, worldNY
end

local function checkCollision(cx, cy, w, h, obj)
    local hw, hh = w/2, h/2
    local px, py = cx, cy
    local ox, oy = obj.x, obj.y

    if not obj.rx or obj.rx == 0 then
        return (px - hw) < (ox + obj.w/2) and
               (px + hw) > (ox - obj.w/2) and
               (py - hh) < (oy + obj.h/2) and
               (py + hh) > (oy - obj.h/2)
    end

    local dx = px - ox
    local dy = py - oy

    local cosR = obj.cos or math.cos(obj.rx or 0)
    local sinR = obj.sin or math.sin(obj.rx or 0)
    local localX =  dx * cosR + dy * sinR
    local localY = -dx * sinR + dy * cosR

    return math.abs(localX) <= (obj.w/2 + hw) and
           math.abs(localY) <= (obj.h/2 + hh)
end

-- ==========================================================
-- BÚSQUEDA DE OBJETOS EN CHUNKS CERCANOS
-- ==========================================================

local function applyTargetDamage(target, amount, soldier)
    if soldier then
        local stats = soldier.stats
        stats.health = math.max(stats.health - amount, 0)
        if stats.health < 1 then soldier.die = true end
    else
        prop.applyDamage(target, amount)
    end
end

local function getChunkObjects(cx, cy)
    local col = gen.level.chunks[cy]
    if not col then return nil end
    return col[cx]
end

local function getNearbyObjects(x, y)
    local objects = {}
    local ccx = math.floor(x / CHUNK_SIZE)
    local ccy = math.floor(y / CHUNK_SIZE)

    for dy = -1, 1 do
        for dx = -1, 1 do
            local list = getChunkObjects(ccx + dx, ccy + dy)
            if list then
                for _, obj in ipairs(list) do
                    objects[#objects + 1] = obj
                end
            end
        end
    end
    return objects
end

-- ==========================================================
-- CARGA DE TEXTURAS
-- prop.loadTextures("mimod", {"bala", "flecha", "bola_fuego"})
-- busca en mod/mimod/propz/bala.png, etc.
-- ==========================================================
function prop.loadTextures(mod, names)
    for _, name in ipairs(names) do
        local path = "mod/" .. mod .. "/propz/" .. name .. ".png"
        local ok, img = pcall(love.graphics.newImage, path)
        if ok then
            prop.textures[name] = img
        else
            print("[prop] Error al cargar textura: " .. path)
        end
    end
end

-- ==========================================================
-- DAÑO
-- ==========================================================
function prop.applyDamage(obj, amount)
    if not obj or not amount or amount == 0 then return end
    if obj.health then
        obj.health = math.max(obj.health - amount, 0)

        if obj.health < 1 then
            obj.die = true
        end
    end
end

function prop.damageInRadius(x, y, radius, damage, ignoreObj)
    local objects = getNearbyObjects(x, y)
    for _, obj in ipairs(objects) do
        if obj ~= ignoreObj and not obj.die then
            local dx = obj.x - x
            local dy = obj.y - y
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist <= radius then
                applyTargetDamage(obj, damage)
            end
        end
    end
    for _, soldier in ipairs(soldiers) do
        local torso = soldier.parts.torso
        if soldier ~= ignoreObj and not soldier.die then
            local dx, dy = torso.x - x, torso.y - y
            if math.sqrt(dx*dx + dy*dy) <= radius then -- distancia plana, no usar la otra función porque está tocada
                applyTargetDamage(torso, damage, soldier)
            end
        end
    end
end

-- ==========================================================
-- DISPARO
-- soldierScripts.propz.shoot(x, y, angle, {
--     speed = 400,
--     accel = 0,              -- aceleración en dirección del movimiento
--     w = 6, h = 6,           -- tamaño de colisión del proyectil
--     texture = "bala",       -- nombre en prop.textures
--     lifetime = 4,
--     piercing = false,       -- si sigue tras impactar (según onHit)
--
--     onHit = "damage" | "bounce" | "function",
--
--     -- para onHit = "damage"
--     damage = 10,
--     damageRadius = 0,       -- 0 = solo golpea al objeto; >0 = daño en área
--
--     -- para onHit = "bounce"
--     bounceDamage = 5,
--     bounceRestitution = 1,  -- 1 = rebote perfecto, <1 pierde energía
--     maxBounces = 3,
--
--     -- para onHit = "function"
--     onHitFunc = function(proyectil, objeto) ... end,
-- })
-- ==========================================================
function prop.shoot(x, y, angle, opts)
    opts = opts or {}

    local speed = opts.speed or 300

    local proj = {
        x = x, y = y,
        vx = math.cos(angle) * speed,
        vy = math.sin(angle) * speed,
        angle = angle,

        accel = opts.accel or 0,
        w = opts.w or 4,
        h = opts.h or 4,
        s = opts.s or .1,
        texture = opts.texture and prop.textures[opts.texture] or nil,
        life = opts.lifetime or 5,
        piercing = opts.piercing or false,

        onHit = opts.onHit or "damage",

        damage = opts.damage or 10,
        damageRadius = opts.damageRadius or 0,

        bounceDamage = opts.bounceDamage or (opts.damage or 10),
        bounceRestitution = opts.bounceRestitution or 1,
        maxBounces = opts.maxBounces or 0,
        bounces = 0,

        onHitFunc = opts.onHitFunc,

        lastHit = nil,
        owner = opts.owner,
    }

    table.insert(prop.projectiles, proj)
    return proj
end

-- variante que dispara hacia un punto (tx, ty) en vez de un angulo
function prop.shootAt(x, y, tx, ty, opts)
    local angle = math.atan2 and math.atan2(ty - y, tx - x)
        or math.atan((ty - y) / (tx - x + 1e-9))
    return prop.shoot(x, y, angle, opts)
end

-- ==========================================================
-- RESOLUCIÓN DE IMPACTO
-- devuelve true si el proyectil debe destruirse
-- ==========================================================
function prop.resolveHit(p, obj, soldier)
    if p.onHit == "damage" then
        if p.damageRadius and p.damageRadius > 0 then
            prop.damageInRadius(p.x, p.y, p.damageRadius, p.damage, p.owner)
        else
            applyTargetDamage(obj, p.damage, soldier)
        end
        return not p.piercing

    elseif p.onHit == "bounce" then
        local wx, wy, nx, ny = resolveRotatedCollision(p.x, p.y, p.w, p.h, obj)
        p.x, p.y = wx, wy

        -- reflejar velocidad respecto a la normal: v' = v - 2*(v·n)*n
        local dot = p.vx * nx + p.vy * ny
        p.vx = (p.vx - 2 * dot * nx) * p.bounceRestitution
        p.vy = (p.vy - 2 * dot * ny) * p.bounceRestitution
        p.angle = math.atan2 and math.atan2(p.vy, p.vx) or p.angle

        applyTargetDamage(obj, p.bounceDamage, soldier)

        p.bounces = p.bounces + 1
        p.lastHit = soldier or obj

        return p.bounces > p.maxBounces

    elseif p.onHit == "function" then
        if p.onHitFunc then
            p.onHitFunc(p, soldier or obj)
        end
        return not p.piercing
    end

    return true
end

-- ==========================================================
-- UPDATE
-- ==========================================================
function prop.update(dt)
    for i = #prop.projectiles, 1, -1 do
        local p = prop.projectiles[i]

        -- aceleración en dirección del movimiento actual
        if p.accel ~= 0 then
            local speed = math.sqrt(p.vx * p.vx + p.vy * p.vy)
            if speed > 0 then
                local dirx, diry = p.vx / speed, p.vy / speed
                p.vx = p.vx + dirx * p.accel * dt
                p.vy = p.vy + diry * p.accel * dt
            end
        end

        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.life = p.life - dt

        local destroy = false

        if p.life <= 0 then
            destroy = true
        else
            local objects = getNearbyObjects(p.x, p.y)
            for _, obj in ipairs(objects) do
                if not obj.die and obj ~= p.lastHit and checkCollision(p.x, p.y, p.w, p.h, obj) then
                    destroy = prop.resolveHit(p, obj)
                    break
                end
            end

            if not destroy then
                for _, soldier in ipairs(soldiers) do
                    local torso = soldier.parts.torso
                    if soldier ~= p.owner and not soldier.die and soldier ~= p.lastHit
                        and checkCollision(p.x, p.y, p.w, p.h, torso) then
                        destroy = prop.resolveHit(p, torso, soldier)
                        break
                    end
                end
            end
        end

        if destroy then
            table.remove(prop.projectiles, i)
        end
    end
end

-- ==========================================================
-- DRAW
-- ==========================================================
function prop.draw()
    for _, p in ipairs(prop.projectiles) do
        if p.texture then
            love.graphics.draw(
                p.texture, p.x, p.y, p.angle, p.s, p.s,
                p.texture:getWidth() / 2, p.texture:getHeight() / 2
            )
        else
            love.graphics.circle("fill", p.x, p.y, math.max(p.w, p.h) / 2)
        end
    end
end

return prop