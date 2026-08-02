local soldierTemplate = require("src.soldier_template")

local function lerpAngle(a, b, t)
    local diff = (b - a + math.pi) % (math.pi * 2) - math.pi
    return a + diff * t
end

function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end

local function resolveRotatedCollision(px, py, w, h, obj)
    local hw, hh = w/2, h/2

    local ox = obj.x
    local oy = obj.y

    -- mover al espacio local
    local dx = px - ox
    local dy = py - oy

    local localX =  dx * obj.cos + dy * obj.sin
    local localY = -dx * obj.sin + dy * obj.cos

    local halfW = obj.w/2
    local halfH = obj.h/2

    -- calcular penetración
    local penX = (halfW + hw) - math.abs(localX)
    local penY = (halfH + hh) - math.abs(localY)

    if penX < penY then
        -- empujar en X local
        if localX > 0 then
            localX = halfW + hw
        else
            localX = -halfW - hw
        end
    else
        -- empujar en Y local
        if localY > 0 then
            localY = halfH + hh
        else
            localY = -halfH - hh
        end
    end

    -- volver a espacio mundo
    local worldX = ox + (localX * obj.cos - localY * obj.sin)
    local worldY = oy + (localX * obj.sin + localY * obj.cos)

    return worldX, worldY
end

local function checkCollision(cx, cy, w, h, obj)
    local hw, hh = w/2, h/2

    -- centro del jugador
    local px, py = cx, cy

    -- centro del objeto
    local ox = obj.x
    local oy = obj.y

    -- caso rápido (sin rotación)
    if not obj.rx or obj.rx == 0 then
        return (px - hw) < (ox + obj.w/2) and
               (px + hw) > (ox - obj.w/2) and
               (py - hh) < (oy + obj.h/2) and
               (py + hh) > (oy - obj.h/2)
    end

    -- =========================
    -- transformar punto al espacio del objeto
    -- =========================
    local dx = px - ox
    local dy = py - oy

    local localX =  dx * obj.cos + dy * obj.sin
    local localY = -dx * obj.sin + dy * obj.cos

    -- =========================
    -- colisión como AABB en espacio local
    -- =========================
    return math.abs(localX) <= (obj.w/2 + hw) and
           math.abs(localY) <= (obj.h/2 + hh)
end

local function updateHeadToso(soldier, dt)
    local mouseX, mouseY = love.mouse.getPosition()
    local parts = soldier.parts
    local head  = parts.head
    local torso = parts.torso
    local speed = soldier.stats.speed

    -- =====================================================
    -- CUERPO COMPLETO
    -- =====================================================
    local function moveWithCollision(soldier, dt)
        local head = soldier.parts.head
        local torso = soldier.parts.torso
        local objs = soldier.actualChunk
        local speed = soldier.stats.speed
        local ctrl = soldier.controls

        local w, h = torso.w, torso.h

        local dx, dy = 0, 0

        if ctrl.u then dy = dy - speed * dt end
        if ctrl.d then dy = dy + speed * dt end
        if ctrl.l then dx = dx - speed * dt end
        if ctrl.r then dx = dx + speed * dt end

        -- =====================
        -- MOVER EN X PRIMERO
        -- =====================
        local newX = head.x + dx

        for _, obj in ipairs(objs) do
            if not obj.die and checkCollision(newX, head.y, w, h, obj) then
                if obj.rx and obj.rx ~= 0 then
                    local rx, ry = resolveRotatedCollision(newX, head.y, w, h, obj)
                    newX = rx -- ✅ SOLO X
                else
                    if dx > 0 then
                        newX = obj.x - (obj.w/2) - w/2
                    elseif dx < 0 then
                        newX = obj.x + (obj.w/2) + w/2
                    end
                end
            end
        end

        head.x = newX

        -- =====================
        -- MOVER EN Y DESPUÉS
        -- =====================
        local newY = head.y + dy

        for _, obj in ipairs(objs) do
            if not obj.die and checkCollision(head.x, newY, w, h, obj) then
                if obj.rx and obj.rx ~= 0 then
                    local rx, ry = resolveRotatedCollision(head.x, newY, w, h, obj)
                    newY = ry -- ✅ SOLO Y
                else
                    if dy > 0 then
                        newY = obj.y - (obj.h/2) - h/2
                    elseif dy < 0 then
                        newY = obj.y + (obj.h/2) + h/2
                    end
                end
            end
        end

        head.y = newY
    end

    moveWithCollision(soldier, dt)

    -- =====================================================
    -- ACTUALIZAR CHUNKS CARGADOS
    -- =====================================================
    do
        local level = gen.level

        if level and level.chunks then
            local chunkSize = level.chunkSize

            local chunkX = math.floor(head.x / chunkSize)
            local chunkY = math.floor(head.y / chunkSize)

            if soldier.chunkX ~= chunkX or soldier.chunkY ~= chunkY then
                soldier.chunkX = chunkX
                soldier.chunkY = chunkY

                soldier.actualChunk = {}

                -- Cargar el chunk actual y los 8 vecinos
                for y = chunkY - 1, chunkY + 1 do
                    local row = level.chunks[y]
                    if row then
                        for x = chunkX - 1, chunkX + 1 do
                            local chunk = row[x]
                            if chunk then
                                for i = 1, #chunk do
                                    soldier.actualChunk[#soldier.actualChunk + 1] = chunk[i]
                                end
                            end
                        end
                    end
                end
            end
        else
            -- Si el nivel no tiene chunks, evitar errores
            soldier.actualChunk = {}
        end
    end

    -- =====================================================
    -- CABEZA → MOUSE
    -- =====================================================
    if soldier.player then
        local headR
        if win.static then
            headR = math.atan2(mouseY - head.y, mouseX - head.x)
        else
            headR = math.atan2(mouseY - win.h / 2, mouseX - win.w / 2)
        end

        head.rx = lerpAngle(head.rx, headR, 12 * dt) 
    end

    local differenceR = head.rx - torso.rx
    local limit = rad(35)

    -- =====================================================
    -- TORSO SOLO AJUSTA EXCESO
    -- =====================================================
    torso.x = head.x
    torso.y = head.y
    if math.abs(differenceR) > limit then
        local sign = differenceR > 0 and 1 or -1
        local target = head.rx - (limit * sign)
        torso.rx = lerpAngle(torso.rx, target, 16 * dt)
    end

end

-- ============== --
--  MANO DERECHA  --
-- ============== --
local function updateRightHand(soldier, arm, differenceR)
    local torso        = soldier.parts.torso
    local head         = soldier.parts.head

    local rightForearm = soldier.parts.RIGHTforearm
    local rightArm     = rightForearm.arm
    local rightHand    = rightArm.hand

    -- mano --
    rightHand.x  = (cos(head.rx + rightHand.ro) * rightHand.ly) + torso.x
    rightHand.y  = (sin(head.rx + rightHand.ro) * rightHand.ly) + torso.y
    rightHand.rx = head.rx

    -- brazo --
    rightArm.x = rightHand.x
    rightArm.y = rightHand.y

    -- anteBrazo --
    local ox = torso.shouldR.x
    local oy = torso.shouldR.y

    local cosr = math.cos(torso.rx)
    local sinr = math.sin(torso.rx)

    rightForearm.x = torso.x + (ox * cosr - oy * sinr)
    rightForearm.y = torso.y + (ox * sinr + oy * cosr)

    --=≡=≡=≡=≡=≡--
    -- rotación --
    --≡=≡=≡=≡=≡=--

    local dist2 = distance(rightForearm.x, rightForearm.y, rightHand.x, rightHand.y)

    local maxDist2 = 100 * 100
    local strengfore = maxDist2 - dist2

    local t = math.max(0, strengfore / maxDist2)

    local distX = rightForearm.x - rightHand.x
    local distY = rightForearm.y - rightHand.y
    local rot   = math.atan2(distY, distX)
    rightForearm.rx = rot - math.max(0, t * rad(80))
    rightArm.rx     = rot + math.max(0, t * rad(80))

end

-- ================ --
--  MANO IZQUIERDA  --
-- ================ --
local function updateLeftHand(soldier, arm, difference)
    local torso = soldier.parts.torso
    local head  = soldier.parts.head

    local leftForearm = soldier.parts.LEFTforearm
    local leftArm     = leftForearm.arm
    local leftHand    = leftArm.hand

    -- mano --
    local cosHead = cos(head.rx + leftHand.ro)
    local sinHead = sin(head.rx + leftHand.ro)

    leftHand.x  = cosHead * leftHand.ly + torso.x
    leftHand.y  = sinHead * leftHand.ly + torso.y
    leftHand.rx = head.rx

    -- brazo --
    leftArm.x = leftHand.x
    leftArm.y = leftHand.y

    -- antebrazo
    local ox = torso.shouldL.x
    local oy = torso.shouldL.y

    local cosr = cos(torso.rx)
    local sinr = sin(torso.rx)

    local leftshouldX = torso.x + (ox * cosr - oy * sinr)
    local leftshouldY = torso.y + (ox * sinr + oy * cosr)

    leftForearm.x = leftshouldX
    leftForearm.y = leftshouldY

    --=≡=≡=≡=≡=≡--
    -- rotación --
    --≡=≡=≡=≡=≡=--

    local distX = leftshouldX - leftHand.x
    local distY = leftshouldY - leftHand.y
    local dist2 = distX * distX + distY * distY

    local maxDist2 = 100 * 100
    local t = math.max(0, (maxDist2 - dist2) / maxDist2)

    local baseAngle = math.atan2(distY, distX)
    local offset = t * rad(80)

    leftForearm.rx = baseAngle + offset
    leftArm.rx     = baseAngle - offset
end

local function updateControls(soldier, dt)

    if soldier.player then

        if love.keyboard.isDown("w") then
            soldier.controls.u = true
        else
            soldier.controls.u = false
        end

        if love.keyboard.isDown("s") then
            soldier.controls.d = true
        else
            soldier.controls.d = false
        end

        if love.keyboard.isDown("a") then
            soldier.controls.l = true
        else
            soldier.controls.l = false
        end

        if love.keyboard.isDown("d") then
            soldier.controls.r = true
        else
            soldier.controls.r = false
        end

    elseif soldier.tryer then

        if love.keyboard.isDown("up") then
            soldier.controls.u = true
        else
            soldier.controls.u = false
        end

        if love.keyboard.isDown("down") then
            soldier.controls.d = true
        else
            soldier.controls.d = false
        end

        if love.keyboard.isDown("left") then
            soldier.controls.l = true
        else
            soldier.controls.l = false
        end

        if love.keyboard.isDown("right") then
            soldier.controls.r = true
        else
            soldier.controls.r = false
        end

    end

end

-- =================== --
--  SPAWN DEL SOLDADO  --
-- =================== --
local function deepCopy(tbl)
    if type(tbl) ~= "table" then
        return tbl
    end

    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = deepCopy(v)
    end
    return copy
end

local function setValue(tbl, path, value)
    local t = tbl
    for i = 1, #path - 1 do
        t = t[path[i]]
    end
    t[path[#path]] = value
end

function spawnSoldier(cfg)
    cfg = cfg or {}

    local s = deepCopy(soldierTemplate)

    -- Datos generales
    s.player = cfg.player or false
    s.tryer = cfg.tryer or false

    s.stats.speed = cfg.speed or s.stats.speed
    s.stats.health = cfg.health or s.stats.health
    s.stats.containment = cfg.containment or s.stats.containment

    -- Posición
    s.parts.torso.x = cfg.x or s.parts.torso.x
    s.parts.torso.y = cfg.y or s.parts.torso.y

    -- Dirección
    s.parts.dir = cfg.dir or s.parts.dir

    -- Arma equipada
    s.magazine.actual = cfg.weapon or s.magazine.actual

    -- Sobrescribir cualquier propiedad arbitraria
    if cfg.override then
        for _,v in ipairs(cfg.override) do
            setValue(s, v.path, v.value)
        end
    end

    s.textures = soldierScripts._texture_pack_.l1

    table.insert(soldiers, s)
    return s
end

return function(body, dt)
    local soldier = body

    local head = soldier.parts.head
    local torso = soldier.parts.torso

    local differenceR = head.rx - torso.rx

    updateHeadToso(soldier, dt)

    updateRightHand(soldier, soldier.parts.RIGHTforearm.arm, differenceR)
    updateLeftHand(soldier, soldier.parts.LEFTforearm.arm, differenceR)

    -- updateFeet(soldier, dt)
    -- updateLegs(soldier)

    updateControls(soldier, dt)
end