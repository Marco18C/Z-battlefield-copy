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
            if checkCollision(head.x, newY, w, h, obj) then
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

-- =====================================================
--  SISTEMA DE PIES
-- =====================================================
-- local function updateFeet(soldier, dt)
--     local head  = soldier.parts.head
--     local torso = soldier.parts.torso
--     local ctrl  = soldier.controls
-- 
--     local rightFoot = soldier.parts.RIGHTforeleg.leg.foot
--     local leftFoot  = soldier.parts.LEFTforeleg.leg.foot
-- 
--     -- =====================
--     -- Vector de movimiento
--     -- =====================
--     local mdx, mdy = 0, 0
--     if ctrl.u then mdy = mdy - 1 end
--     if ctrl.d then mdy = mdy + 1 end
--     if ctrl.l then mdx = mdx - 1 end
--     if ctrl.r then mdx = mdx + 1 end
-- 
--     local isMoving = (mdx ~= 0 or mdy ~= 0)
-- 
--     local mvX, mvY = 0, 0
--     if isMoving then
--         local len = math.sqrt(mdx * mdx + mdy * mdy)
--         mvX, mvY = mdx / len, mdy / len
--     end
-- 
--     -- =====================
--     -- Base de orientación
--     -- =====================
--     local lookAngle = head.rx
--     local cosL =  math.cos(lookAngle)
--     local sinL =  math.sin(lookAngle)
--     -- eje perpendicular derecho respecto al look
--     local perpX = -sinL
--     local perpY =  cosL
-- 
--     -- Qué tan lateral es el movimiento respecto a donde mira (0=frente/atrás, 1=lateral puro)
--     local lateralFactor = 0
--     local forwardFactor = 0
--     if isMoving then
--         local moveAngle = math.atan2(mdy, mdx)
--         local relAngle  = moveAngle - lookAngle
--         relAngle = (relAngle + math.pi) % (math.pi * 2) - math.pi
--         lateralFactor = math.abs(math.sin(relAngle))
--         forwardFactor = math.abs(math.cos(relAngle))
--     end
-- 
--     -- =====================
--     -- Parámetros
--     -- =====================
--     local footWidth  = 24              -- separación lateral del centro
--     local lookahead  = 130              -- anticipo en dirección de movimiento
--     local stepThresh = isMoving and 6 or 20  -- umbral para disparar un paso
--     local stepDur    = 0.14            -- duración de un paso en segundos
-- 
--     -- Movimiento lateral → reducir anticipación para que los pies queden lado a lado
--     -- (lateralFactor=1 deja solo ~15% del lookahead → sin pie delante del otro)
--     local lead = lookahead + soldier.stats.speed * 0.12
--     local baseLook = lookahead
-- 
--     -- Reducir MUCHO el adelanto cuando es movimiento frontal
--     local forwardReduce = 0.55  -- qué tanto recorta al ir hacia adelante
-- 
--     -- Mantener lateral como antes (pero un poco más suave)
--     local lateralReduce = 0.65
-- 
--     local effLookahead =
--         baseLook *
--         (1 - lateralFactor * lateralReduce) *
--         (1 - forwardFactor * forwardReduce)
-- 
--     -- =====================
--     -- Posiciones ideales
--     -- =====================
--     -- Pie derecho: desplazado a la derecha del look + anticipo en dir. movimiento
--     -- Pie izquierdo: desplazado a la izquierda del look + mismo anticipo
--     local baseX = torso.x + mvX * effLookahead
--     local baseY = torso.y + mvY * effLookahead
-- 
--     local rIdealX = baseX + perpX * footWidth
--     local rIdealY = baseY + perpY * footWidth
--     local lIdealX = baseX - perpX * footWidth
--     local lIdealY = baseY - perpY * footWidth
-- 
--     -- =====================
--     -- Inicializar estado
--     -- =====================
--     if not soldier._footState then
--         rightFoot.x = rIdealX; rightFoot.y = rIdealY
--         leftFoot.x  = lIdealX; leftFoot.y  = lIdealY
-- 
--         soldier._footState = {
--             R = {
--                 x = rIdealX, y = rIdealY,
--                 stepping = false, t = 1,
--                 fromX = rIdealX, fromY = rIdealY,
--                 toX   = rIdealX, toY   = rIdealY,
--             },
--             L = {
--                 x = lIdealX, y = lIdealY,
--                 stepping = false, t = 1,
--                 fromX = lIdealX, fromY = lIdealY,
--                 toX   = lIdealX, toY   = lIdealY,
--             },
--             nextStep = "R",  -- qué pie toca dar el siguiente paso
--         }
--     end
-- 
--     local fs = soldier._footState
-- 
--     -- =====================
--     -- Disparar pasos
--     -- =====================
--     local function d2(ax, ay, bx, by)
--         local dx, dy = ax - bx, ay - by
--         return dx * dx + dy * dy
--     end
-- 
--     local thresh2 = stepThresh * stepThresh
-- 
--     -- Solo un pie da pasos a la vez → alternancia natural
--     local neitherStepping = not fs.R.stepping and not fs.L.stepping
-- 
--     if neitherStepping then
--         local rNeed = d2(fs.R.x, fs.R.y, rIdealX, rIdealY) > thresh2
--         local lNeed = d2(fs.L.x, fs.L.y, lIdealX, lIdealY) > thresh2
-- 
--         local function startStep(fst, toX, toY, nxt)
--             fst.stepping = true
--             fst.t        = 0
--             fst.fromX    = fst.x;  fst.fromY = fst.y
--             fst.toX      = toX;    fst.toY   = toY
--             fs.nextStep  = nxt
--         end
-- 
--         -- Respetar turno para lograr la alternancia; si solo uno necesita → ese pisa
--         if rNeed and (fs.nextStep == "R" or not lNeed) then
--             startStep(fs.R, rIdealX, rIdealY, "L")
--         elseif lNeed then
--             startStep(fs.L, lIdealX, lIdealY, "R")
--         end
--     end
-- 
--     -- =====================
--     -- Animar pasos (ease in-out)
--     -- =====================
--     local function animStep(fst, footPart)
--         if fst.stepping then
--             fst.t = math.min(1, fst.t + dt / stepDur)
-- 
--             local t    = fst.t
--             -- ease in-out cuadrático
--             local ease = t < 0.5
--                 and (2 * t * t)
--                 or  (1 - (-2 * t + 2)^2 * 0.5)
-- 
--             footPart.x = fst.fromX + (fst.toX - fst.fromX) * ease
--             footPart.y = fst.fromY + (fst.toY - fst.fromY) * ease
-- 
--             if fst.t >= 1 then
--                 fst.stepping = false
--                 fst.x = fst.toX;  fst.y = fst.toY
--                 footPart.x = fst.x; footPart.y = fst.y
--             end
--         else
--             footPart.x = fst.x
--             footPart.y = fst.y
--         end
--     end
-- 
--     animStep(fs.R, rightFoot)
--     animStep(fs.L, leftFoot)
-- 
--     -- =====================
--     -- Rotación de pies → siempre apuntan en la dirección del look
--     -- =====================
--     rightFoot.rx = lerpAngle(rightFoot.rx, lookAngle, 10 * dt)
--     leftFoot.rx  = lerpAngle(leftFoot.rx,  lookAngle, 10 * dt)
-- end
-- 
-- local function updateLegs(soldier)
--     local parts = soldier.parts
--     local torso = parts.torso
-- 
--     -- =========================
--     -- Calcular hips en mundo
--     -- =========================
--     local cosT = math.cos(torso.rx)
--     local sinT = math.sin(torso.rx)
-- 
--     local function getHip(offset)
--         return
--             torso.x + offset.x * cosT - offset.y * sinT,
--             torso.y + offset.x * sinT + offset.y * cosT
--     end
-- 
--     local hipRX, hipRY = getHip(torso.hipR)
--     local hipLX, hipLY = getHip(torso.hipL)
-- 
--     -- =========================
--     -- Resolver una pierna
--     -- =========================
--     local function solveLeg(foreleg, hipX, hipY)
--         local leg  = foreleg.leg
--         local foot = leg.foot
-- 
--         -- =====================
--         -- Antepierna (foreleg)
--         -- =====================
--         foreleg.x = hipX
--         foreleg.y = hipY
-- 
--         local dx1 = foot.x - hipX
--         local dy1 = foot.y - hipY
-- 
--         foreleg.rx = math.atan2(dy1, dx1)
-- 
--         -- =====================
--         -- Pierna (leg)
--         -- =====================
--         leg.x = foot.x
--         leg.y = foot.y
-- 
--         local dx2 = hipX - foot.x
--         local dy2 = hipY - foot.y
-- 
--         leg.rx = math.atan2(dy2, dx2)
--     end
-- 
--     -- =========================
--     -- Aplicar a ambas piernas
--     -- =========================
--     solveLeg(parts.RIGHTforeleg, hipRX, hipRY)
--     solveLeg(parts.LEFTforeleg,  hipLX, hipLY)
-- end

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