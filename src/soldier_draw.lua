return function()
    local mouseX, mouseY = love.mouse.getPosition()

    for _, soldier in ipairs(soldiers) do
        local parts     = soldier.parts
        local textures  = soldier.textures

        local torso     = parts.torso
        local head      = parts.head
        local Rroar     = parts.RIGHTforearm
        local Rarm      = Rroar.arm
        local Rhand     = Rarm.hand
        local Lroar     = parts.LEFTforearm
        local Larm      = Lroar.arm
        local Lhand     = Larm.hand
        local head      = parts.head
        local Lfoleg    = parts.LEFTforeleg
        local Lleg      = Lfoleg.leg
        local Lfoot     = Lleg.foot
        local Rfoleg    = parts.RIGHTforeleg
        local Rleg      = Rfoleg.leg
        local Rfoot     = Rleg.foot
        local weapon    = Rhand.inHand

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
        local RroarTex    = textures.RIGHTforearm
        local RgarmTex    = textures.RIGHTarm
        local RhandTEX    = textures.RIGHThand
        local LroarTex    = textures.LEFTforearm
        local LgarmTex    = textures.LEFTarm
        local LhandTEX    = textures.LEFThand
        local LfolegTex   = textures.LEFTforeleg
        local LlegTex     = textures.LEFTleg
        local LfootTex    = textures.LEFTfoot
        local RfolegTex   = textures.RIGHTforeleg
        local RlegTex     = textures.RIGHTleg
        local RfootTex    = textures.RIGHTfoot
        local RweaponTEX  = weapon.img

        -- Ángulo cabeza → mouse (en radianes)
        local headR = math.atan2(
            mouseY - head.y,
            mouseX - head.x
        )

        local function drawLeftArm()
            -- antebrazo izquierdo
            love.graphics.draw(LroarTex, Lroar.x, Lroar.y, Lroar.rx, 0.1, 0.1, 500, 128)

            -- brazo izquierdo
            love.graphics.draw(LgarmTex, Larm.x, Larm.y, Larm.rx, 0.1, 0.1, 0, 128)

            -- mano izquierda
            love.graphics.draw(LhandTEX, Lhand.x, Lhand.y, Lhand.rx, 0.11, 0.11, 128, 128)
        end

        local function drawRightArm()
            -- antebrazo derecho
            love.graphics.draw(RroarTex, Rroar.x, Rroar.y, Rroar.rx, 0.1, 0.1, 500, 128)

            -- brazo derecho
            love.graphics.draw(RgarmTex, Rarm.x, Rarm.y, Rarm.rx, 0.1, 0.1, 0, 128)

            -- mano derecha
            love.graphics.draw(RhandTEX, Rhand.x, Rhand.y, Rhand.rx, 0.11, 0.11, 128, 128)
        end

        local function drawLeftLeg()
            -- antepierna izquierda
            love.graphics.draw(LfolegTex, Lfoleg.x, Lfoleg.y, Lfoleg.rx, 0.1, 0.1, 128, 16)

            -- pierna izquierda
            love.graphics.draw(LlegTex, Lleg.x, Lleg.y, Lleg.rx, 0.1, 0.1, 128, 460)

            -- pie izquierdo
            love.graphics.draw(LfootTex, Lfoot.x, Lfoot.y, Lfoot.rl, 0.11, 0.11, 128, 128)
        end

        local function drawRightLeg()
            -- antepierna derecha
            love.graphics.draw(RfolegTex, Rfoleg.x, Rfoleg.y, Rfoleg.rx, 0.1, 0.1, 128, 16)

            -- pierna derecha
            love.graphics.draw(RlegTex, Rleg.x, Rleg.y, Rleg.rx, 0.1, 0.1, 128, 460)

            -- pie derecho
             love.graphics.draw(RfootTex, Rfoot.x, Rfoot.y, Rfoot.rl, 0.11, 0.11, 128, 128)
        end

        local function drawTorso()
            -- torso
            love.graphics.draw(torsoTex, torso.x, torso.y, torso.rx, 0.13, 0.13, 256, 256)

        end

        local function drawHead()
            -- cabeza
            love.graphics.draw(headTex, head.x, head.y, head.rx, 0.125, 0.125, 256, 256)
        end

        local function drawWeapon()
            -- arma en mano derecha
            love.graphics.draw(
                RweaponTEX,
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
                    love.graphics.rectangle("fill", obj.x, obj.y, obj.w, obj.h)
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
        drawLeftLeg()
        drawRightLeg()

        -- 2. torso siempre al medio
        drawTorso()

        -- 3. brazos y piernas que van al frente
        drawLeftArm()
        drawRightArm()

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