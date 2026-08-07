love = love or {}
WindowsSIZE = 1
win = {
    x = 0,
    y = 0,
    s = 1,
    w = love.graphics.getWidth(),
    h = love.graphics.getHeight(),
    static = false,
}
pi = math.pi
rad = math.rad
deg = math.deg
cos, sin, atan2 = math.cos, math.sin, math.atan2
abs, sqrt, min, max = math.abs, math.sqrt, math.min, math.max
function math.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

---------------------------------------------------------
-- SOLDIERS DATA
---------------------------------------------------------

---------------------------------------------------------
function love.load()
    soldiers = {}

    gen = {
        level = {},
        src = require("src.world_gen")
    }

    soldierScripts = {
        update  = require("src.soldier_update"),
        draw    = require("src.soldier_draw"),
        anims   = require("src.soldier_anims"),
        weapons = require("src.soldier_weapon"),
        shoot   = require("src.soldier_shoot"),
        propz   = require("src.soldier_projectiles"),
    }
    soldierScripts._texture_pack_ = {
        l1 = soldierScripts.draw.loadSoldierTextures("usa", "testing"),
    }
    soldierScripts.propz.loadTextures("testing", {"bala", "ammo", "grenade", "bullet_carc"})
    soldierScripts.weapons.loadTextures("testing", {"guns/test_rifle", "guns/test_pistol", "throwable/grenade", "guns/test_sniper_rifle"})
    gen.level = gen.src.load("testing", "default_test") -- carga del nivle

    for _, soldier in ipairs(soldiers) do
        soldier.textures = soldierScripts._texture_pack_.l1
    end

    spawnSoldier({
        player = true,
        soldier = "usa",
        primary = "test_rifle",
        secondary = "test_pistol",
        x = 400,
        y = 300
    })

    spawnSoldier({
        x = 200,
        y = 300
    })

    spawnSoldier({
        x = 200,
        y = 0,
        tryer = true
    })

    soldierScripts.weapons.load()
    local debugRifle = require("mod.testing.weapons.guns.test_sniper_rifle.info")
    soldierScripts.weapons.spawnGroundWeapon(debugRifle, 500, 300, 0, "first")
end

function love.resize(w, h)
    WindowsSIZE = (w / 1280)
    win.w = w
    win.h = h
end

function love.keypressed(key)
    local number = tonumber(key)
    if type(number) == "number" then win.s = number end

    if key == "f3" then
        soldierScripts.shoot.toggleDebug()
    end

    soldierScripts.weapons.keypressed(key)
end

function love.mousepressed(x, y, key)
    soldierScripts.weapons.mousepressed(key)
end

function love.mousereleased(x, y, key)
    soldierScripts.weapons.mousereleased(key)
end

function love.update(dt)

    for _,body in ipairs(soldiers) do
        -- soldierScripts.anims(body, dt)
        soldierScripts.update(body, dt)
        soldierScripts.anims(body, dt)
        soldierScripts.weapons.updateWeapons(body, dt)
    end

    soldierScripts.propz.update(dt)
    soldierScripts.shoot.update(dt)

    collectgarbage("collect")
end

function love.draw()
    soldierScripts.draw.draw()
end