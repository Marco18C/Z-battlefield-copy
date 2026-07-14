local noneTEX = love.graphics.newImage("textures/none.png")
local square1 = love.graphics.newImage("textures/def_obj/1x1.png")

local function getLegFrame(hipX, hipY, footX, footY, torsoAngle)
    -- =========================
    -- Dirección (para fila)
    -- =========================
    local dx = footX - hipX
    local dy = footY - hipY

    local angle = math.atan2(dy, dx)
    local rel = angle - torsoAngle
    rel = (rel + math.pi) % (math.pi * 2) - math.pi

    -- delante / detrás
    local row = (math.cos(rel) > 0) and 0 or 1

    -- =========================
    -- DISTANCIA (para columna)
    -- =========================
    local dist = math.sqrt(dx*dx + dy*dy)

    -- ⚠️ AJUSTA ESTOS VALORES A TU RIG
    local minLen = 0    -- pierna completamente doblada
    local maxLen = 90   -- pierna completamente estirada

    -- normalizar 0–1
    local t = (dist - minLen) / (maxLen - minLen)
    print(t)
    t = math.max(0, math.min(1, t))

    -- invertir si tus sprites van al revés
    -- (izquierda = estirada, derecha = doblada)
    local col = math.floor((1 - t) * 5 + 0.5)

    return col, row
end

return function()
    local mouseX, mouseY = love.mouse.getPosition()

    for _, soldier in ipairs(soldiers) do
        local parts     = soldier.parts
        local textures  = soldier.textures

        local torso     = parts.torso
        local head      = parts.head

        -- Ángulo cabeza → mouse (en radianes)
        local headR = math.atan2(
            mouseY - head.y,
            mouseX - head.x
        )

        -- mano derecha
        local Rroar     = parts.RIGHTforearm
        local Rarm      = Rroar.arm
        local Rhand     = Rarm.hand
        local RinHand   = Rhand.inHand

        -- mano izquierda
        local Lroar     = parts.LEFTforearm
        local Larm      = Lroar.arm
        local Lhand     = Larm.hand
        local LinHand   = Lhand.inHand

        -- pierna derecha
        local Lfoleg    = parts.LEFTforeleg
        local Lleg      = Lfoleg.leg
        local Lfoot     = Lleg.foot

        -- pierna izquierda
        local Rfoleg    = parts.RIGHTforeleg
        local Rleg      = Rfoleg.leg
        local Rfoot     = Rleg.foot

        local weapon    = soldier.magazine[soldier.magazine.actual]

        local LshouldX = torso.x + torso.shouldL.x
        local LshouldY = torso.y + torso.shouldL.y

        local RshouldX = torso.x + torso.shouldR.x
        local RshouldY = torso.y + torso.shouldR.y

        local LhipX = torso.x + torso.hipL.x
        local LhipY = torso.y + torso.hipL.y

        local RhipX = torso.x + torso.hipR.x
        local RhipY = torso.y + torso.hipR.y

        local dir  = parts.dir

        local torsoTex    = textures.torso
        local headTex     = textures.head

        -- mano derecha
        local RroarTex    = textures.RIGHTforearm
        local RgarmTex    = textures.RIGHTarm
        local RhandTEX    = textures.RIGHThand
        local RwponTEX    = weapon.img[RinHand.img] or noneTEX

        -- mano izquierda
        local LroarTex    = textures.LEFTforearm
        local LgarmTex    = textures.LEFTarm
        local LhandTEX    = textures.LEFThand
        local LwponTEX    = weapon.img[LinHand.img] or noneTEX

        -- pierna derecha
        local LfolegTex   = textures.LEFTforeleg
        local LlegTex     = textures.LEFTleg
        local LfootTex    = textures.LEFTfoot

        -- pierna izquierda
        local RfolegTex   = textures.RIGHTforeleg
        local RlegTex     = textures.RIGHTleg
        local RfootTex    = textures.RIGHTfoot
        local RweaponTEX  = weapon.img

        local function drawLeftArm()
            -- antebrazo izquierdo
            love.graphics.draw(LroarTex, Lroar.x, Lroar.y, Lroar.rx, 0.1, 0.1, 500, 128)

            -- brazo izquierdo
            love.graphics.draw(LgarmTex, Larm.x, Larm.y, Larm.rx, 0.1, 0.1, 0, 128)

            -- objeto izquierda
            love.graphics.draw(LwponTEX, Lhand.x, Lhand.y, Lhand.rx + LinHand.rx, LinHand.sx, LinHand.sy, LinHand.ox, LinHand.oy)

            -- mano izquierda
            love.graphics.draw(LhandTEX[1], Lhand.x, Lhand.y, Lhand.rx, 0.11, 0.11, 64, 128)
        end

        local function drawRightArm()
            -- antebrazo derecho
            love.graphics.draw(RroarTex, Rroar.x, Rroar.y, Rroar.rx, 0.1, 0.1, 500, 128)

            -- brazo derecho
            love.graphics.draw(RgarmTex, Rarm.x, Rarm.y, Rarm.rx, 0.1, 0.1, 0, 128)

            -- objeto derecha
            love.graphics.draw(RwponTEX, Rhand.x, Rhand.y, Rhand.rx + RinHand.rx, RinHand.sx, RinHand.sy, RinHand.ox, RinHand.oy)

            -- mano derecha
            love.graphics.draw(RhandTEX[1], Rhand.x, Rhand.y, Rhand.rx, 0.11, 0.11, 64, 128)
        end

        local function drawLeftLeg()

            -- =====================
            -- PIE IZQUIERDO
            -- =====================
            love.graphics.draw(
                LfootTex,
                Lfoot.x, Lfoot.y,
                Lfoot.rx,
                0.11, 0.11,
                128, 128
            )

            -- =====================
            -- PIERNA IZQUIERDA
            -- =====================
            local colL, rowL = getLegFrame(LhipX, LhipY, Lfoot.x, Lfoot.y, torso.rx)
            local quadLegL = LlegTex.quads[rowL][colL]

            love.graphics.draw(
                LlegTex.img,
                quadLegL,
                Lleg.x, Lleg.y,
                Lleg.rx + rad(180),
                0.1, 0.1,
                128, 16
            )

            -- =====================
            -- ANTEPIERNA IZQUIERDA
            -- =====================
            local colFL, rowFL = getLegFrame(LhipX, LhipY, Lfoot.x, Lfoot.y, torso.rx)
            local quadFolegL = LfolegTex.quads[rowFL][colFL]

            love.graphics.draw(
                LfolegTex.img,
                quadFolegL,
                Lfoleg.x, Lfoleg.y,
                Lfoleg.rx + rad(180),
                0.1, 0.1,
                128, 16
            )
        end

        local function drawRightLeg()

            -- =====================
            -- PIE DERECHO
            -- =====================
            love.graphics.draw(
                RfootTex,
                Rfoot.x, Rfoot.y,
                Rfoot.rx,
                0.11, 0.11,
                128, 128
            )

            -- =====================
            -- PIERNA DERECHA
            -- =====================
            local colR, rowR = getLegFrame(RhipX, RhipY, Rfoot.x, Rfoot.y, torso.rx)
            local quadLegR = RlegTex.quads[rowR][colR]

            love.graphics.draw(
                RlegTex.img,
                quadLegR,
                Rleg.x, Rleg.y,
                Rleg.rx,
                0.1, 0.1,
                128, 16
            )

            -- =====================
            -- ANTEPIERNA DERECHA
            -- =====================
            local colFR, rowFR = getLegFrame(RhipX, RhipY, Rfoot.x, Rfoot.y, torso.rx)
            local quadFolegR = RfolegTex.quads[rowFR][colFR]

            love.graphics.draw(
                RfolegTex.img,
                quadFolegR,
                Rfoleg.x, Rfoleg.y,
                Rfoleg.rx,
                0.1, 0.1,
                128, 16
            )
        end

        local function drawTorso()
            -- torso
            love.graphics.draw(torsoTex, torso.x, torso.y, torso.rx, 0.12, 0.12, 256, 256)

        end

        local function drawHead()
            -- cabeza
            love.graphics.draw(headTex, head.x, head.y, head.rx, 0.125, 0.125, 256, 256)
        end

        local function drawWeapon()
            -- arma en mano derecha
            love.graphics.draw(
                RweaponTEX.base,
                Rhand.x, Rhand.y,
                Rhand.rx,
                weapon.size, weapon.size,
                weapon.offsetX, weapon.offsetY
            )

        end

        local function drawChunk(chunk, pos)
            for i = #chunk, 1, -1 do
                local obj = chunk[i]

                if obj.pos == pos then
                    love.graphics.draw(square1, obj.x, obj.y, obj.rx, obj.w, obj.h, .5, .5)
                end

            end

        end

        --=≡=≡=≡=≡=≡--=≡=≡=≡=≡=≡=--
        -- DIBUJADO -- ENTIDADES --
        --≡=≡=≡=≡=≡=--=≡=≡=≡=≡=≡=--

        win.x = -head.x + ((win.w / 2) * win.s)
        win.y = -head.y + ((win.h / 2) * win.s)

        love.graphics.scale(1 / win.s)
        love.graphics.translate(win.x, win.y)

        -- Debug
        love.graphics.print(math.deg(headR), 1, 1)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("line", Lhand.x, Lhand.y, 14)
        love.graphics.circle("line", Rhand.x, Rhand.y, 14)
        love.graphics.setColor(1, 1, 1)

        drawChunk(soldier.actualChunk, "below")

        -- 1. pies y piernas que van detrás
        -- drawLeftLeg()
        -- drawRightLeg()

        -- 2. torso siempre al medio
        drawTorso()

        -- 3. brazos que van al frente
        drawRightArm()
        drawLeftArm()

        drawWeapon()
        
        -- 4. cabeza por encima de todo
        drawHead()

        drawChunk(soldier.actualChunk, "above")

        -- Debug pivot torso
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", torso.x, torso.y, 1, 1)
        love.graphics.setColor(1, 1, 1)
    end
end