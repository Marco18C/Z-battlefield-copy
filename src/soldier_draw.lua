local noneTEX = love.graphics.newImage("textures/none.png")
local drawer = {}

--==-- UTILIDADES --==--
local lg = love.graphics
local setColor = lg.setColor
local rect = lg.rectangle
drawer.obj_IMGs = {}

function drawer.loadObjectImages(imageList)
    local obj_IMGs = {}

    for _, name in ipairs(imageList) do
        local basePath = "textures/def_obj/" .. name .. "/"

        local image = love.graphics.newImage(basePath .. "img.png")
        local particles = love.graphics.newImage(basePath .. "particles.png")

        image:setFilter("nearest", "nearest")
        particles:setFilter("nearest", "nearest")

        -- Crear los 8 quads de partículas
        local particles_Quad = {}
        local frameWidth = particles:getWidth() / 8
        local frameHeight = particles:getHeight()

        for i = 0, 7 do
            particles_Quad[i + 1] = love.graphics.newQuad(
                i * frameWidth,
                0,
                frameWidth,
                frameHeight,
                particles:getDimensions()
            )
        end

        -- Cargar info.lua
        local info = {}
        local infoPath = basePath .. "info.lua"

        if love.filesystem.getInfo(infoPath) then
            local chunk, err = love.filesystem.load(infoPath)
            if not chunk then
                error("Error cargando '" .. infoPath .. "': " .. err)
            end

            info = chunk()

            if type(info) ~= "table" then
                error("'" .. infoPath .. "' debe retornar una tabla.")
            end
        end

        obj_IMGs[name] = {
            image = image,
            particles = particles,
            particles_Quad = particles_Quad,
            width = image:getWidth(),
            height = image:getHeight(),
            info = info
        }
    end

    return obj_IMGs
end

function drawer.draw()
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
                local dooi = drawer.obj_IMGs[obj.tex]

                if obj.pos == pos then
                    if not obj.die then
                        love.graphics.draw(dooi.image, obj.x, obj.y, obj.rx, .1, .1, dooi.width / 2, dooi.height / 2)
                    else
                        obj.destro_t = obj.destro_t + (love.timer.getDelta() * 10)
                        love.graphics.draw(dooi.particles, dooi.particles_Quad[math.min(math.floor(obj.destro_t), 8)], obj.x, obj.y, obj.rx, .1, .1, dooi.width / 2, dooi.height / 2)
                    end
                    setColor(1, 0, 0, 1)
                    rect("fill", obj.x, obj.y, obj.health / 100 * 50, 4)
                    setColor(1, 1, 1, 1)
                end

            end

        end

        --=≡=≡=≡=≡=≡--=≡=≡=≡=≡=≡=--
        -- DIBUJADO -- ENTIDADES --
        --≡=≡=≡=≡=≡=--=≡=≡=≡=≡=≡=--

        win.x = -head.x + ((win.w / 2) * win.s)
        win.y = -head.y + ((win.h / 2) * win.s)

        if soldier.player then
            love.graphics.scale(1 / win.s)
            love.graphics.translate(win.x, win.y)
        end

        -- Debug
        love.graphics.print(math.deg(headR), 1, 1)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("line", Lhand.x, Lhand.y, 14)
        love.graphics.circle("line", Rhand.x, Rhand.y, 14)
        love.graphics.setColor(1, 1, 1)

        if soldier.player then drawChunk(soldier.actualChunk, "below") end

        -- 1. torso siempre al medio
        drawTorso()

        -- 2. brazos que van al frente
        drawRightArm()
        drawLeftArm()

        drawWeapon()

        -- 3. cabeza por encima de todo
        drawHead()

        if soldier.player then drawChunk(soldier.actualChunk, "above") end
        rect("fill", head.x + 50, head.y - 80, soldier.stats.health / 100 * 50, 3) 

        if soldier.player then soldierScripts.shoot.drawDebug() end

        -- Debug pivot torso
        love.graphics.setColor(1, 0, 0)
        rect("fill", torso.x, torso.y, 1, 1)
        love.graphics.setColor(1, 1, 1)
    end
end

return drawer