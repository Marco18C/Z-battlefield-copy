local function lerpAngle(a, b, t)
    local diff = (b - a + math.pi) % (math.pi * 2) - math.pi
    return a + diff * t
end

function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end

local function checkCollision(cx, cy, w, h, obj)
    -- convertir centro a esquina
    local x = cx - w/2
    local y = cy - h/2

    return x < obj.x + obj.w and
           x + w > obj.x and
           y < obj.y + obj.h and
           y + h > obj.y
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
        local objs = soldier.actualChunk
        local speed = soldier.stats.speed
        local ctrl = soldier.controls

        local w, h = head.w, head.h

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
            if checkCollision(newX, head.y, w, h, obj) then
                if dx > 0 then
                    -- chocando por la derecha
                    newX = obj.x - w/2
                elseif dx < 0 then
                    -- chocando por la izquierda
                    newX = obj.x + obj.w + w/2
                end
                break
            end
        end

        head.x = newX

        -- =====================
        -- MOVER EN Y DESPUÉS
        -- =====================
        local newY = head.y + dy

        for _, obj in ipairs(objs) do
            if checkCollision(head.x, newY, w, h, obj) then
                if dy > 0 then
                    -- chocando abajo
                    newY = obj.y - h/2
                elseif dy < 0 then
                    -- chocando arriba
                    newY = obj.y + obj.h + h/2
                end
                break
            end
        end

        head.y = newY
    end

    moveWithCollision(soldier, dt)

    -- =====================================================
    -- CABEZA → MOUSE
    -- =====================================================
    local headR
    if win.static then
        headR = math.atan2(mouseY - head.y, mouseX - head.x)
    else
        headR = math.atan2(mouseY - win.h / 2, mouseX - win.w / 2)
    end
    head.rx = lerpAngle(head.rx, headR, 12 * dt)

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
    rightHand.x  = (cos(head.rx) * rightHand.ly) + torso.x
    rightHand.y  = (sin(head.rx) * rightHand.ly) + torso.y
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
    local cosHead = cos(head.rx)
    local sinHead = sin(head.rx)

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
    if not soldier.player then return end
    local objs = soldier.actualChunk

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

end

return function(body, dt)
    local soldier = body

    local head = soldier.parts.head
    local torso = soldier.parts.torso

    local differenceR = head.rx - torso.rx

    updateHeadToso(soldier, dt)

    updateRightHand(soldier, soldier.parts.RIGHTforearm.arm, differenceR)
    updateLeftHand(soldier, soldier.parts.LEFTforearm.arm, differenceR)

    updateControls(soldier, dt)
end