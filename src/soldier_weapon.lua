--[[
    Gestión de armas de los soldados.

    Responsabilidades de este módulo:
      1. Controlar el arma equipada y el disparo.
      2. Soltar y recoger armas con la tecla X.
      3. Mantener las armas del suelo en w.objs.
      4. Actualizar y dibujar las armas que están en el suelo.
]]

local w = {}

---------------------------------------------------------------------
-- Estado del módulo y configuración
---------------------------------------------------------------------

-- Soldado controlado por el jugador.
local unit

-- Lista pública de armas tiradas en el suelo.
-- Cada elemento tiene esta forma:
-- {
--     weapon = <tabla del arma>,
--     slot   = "first" | "second" | "grenade",
--     x      = posición X,
--     y      = posición Y,
--     rx     = rotación,
--     age    = tiempo desde que se soltó,
-- }
w.objs = {}

-- Texturas cargadas para las armas. Las armas solo guardan el nombre del
-- conjunto (`weapon.texture`), no objetos Image.
w.textures = {}

-- Distancia máxima a la que se puede recoger un arma.
local PICKUP_DISTANCE = 75

-- Ranuras que puede utilizar un soldado.
local WEAPON_SLOTS = {"first", "second"}

---------------------------------------------------------------------
-- Carga de texturas
---------------------------------------------------------------------

-- names contiene rutas relativas a mod/<mod>/weapons/.
-- Ejemplo: w.loadTextures("testing", {"guns/test_rifle"})
function w.loadTextures(mod, names)
    w.textures = {}

    for _, name in ipairs(names or {}) do
        local basePath = "mod/" .. mod .. "/weapons/" .. name .. "/"
        local textures = {}

        local function loadImage(file)
            local path = basePath .. file
            local ok, image = pcall(love.graphics.newImage, path)
            if ok then
                return image
            end
        end

        textures.base = loadImage("base.png")
        textures.ammo = loadImage("ammo.png")
        textures.pts = {}

        local partIndex = 1
        while true do
            local image = loadImage("part_" .. partIndex .. ".png")
            if not image then break end
            textures.pts[partIndex] = image
            partIndex = partIndex + 1
        end

        w.textures[name] = textures
    end

    return w.textures
end

---------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------

local function getSoldierPosition(soldier)
    local head = soldier.parts.head
    return head.x, head.y
end

local function addGroundWeapon(weapon, slot, x, y, rx)
    table.insert(w.objs, {
        weapon = weapon,
        slot = slot,
        x = x,
        y = y,
        rx = rx or 0,
        age = 0,
    })
end

-- Coloca un arma directamente en el suelo.
-- `weapon` es una tabla de arma (por ejemplo, la retornada por
-- src.TEST_DEBUG_RIFLE_src.lua). Devuelve el objeto creado en w.objs.
function w.spawnGroundWeapon(weapon, x, y, rx, slot)
    assert(type(weapon) == "table", "spawnGroundWeapon necesita una tabla de arma")
    assert(type(x) == "number" and type(y) == "number", "La posición del arma debe ser numérica")

    addGroundWeapon(weapon, slot or weapon.pos, x, y, rx)
    return w.objs[#w.objs]
end
local function removeGroundWeapon(object)
    for index = #w.objs, 1, -1 do
        if w.objs[index] == object then
            table.remove(w.objs, index)
            return
        end
    end
end

---------------------------------------------------------------------
-- Búsqueda de armas en el suelo
---------------------------------------------------------------------

local function findNearestGroundWeapon(soldier)
    local soldierX, soldierY = getSoldierPosition(soldier)
    local nearestObject
    local nearestDistance

    for _, object in ipairs(w.objs) do
        local dx = soldierX - object.x
        local dy = soldierY - object.y
        local distanceSquared = dx * dx + dy * dy

        if distanceSquared <= PICKUP_DISTANCE * PICKUP_DISTANCE
        and (not nearestDistance or distanceSquared < nearestDistance) then
            nearestObject = object
            nearestDistance = distanceSquared
        end
    end

    return nearestObject
end

---------------------------------------------------------------------
-- Soltar y recoger armas
---------------------------------------------------------------------

local function dropEquippedWeapon(soldier)
    local slot = soldier.magazine.actual
    local weapon = soldier.magazine[slot]

    -- No hay nada que soltar.
    if not weapon then
        return false
    end

    local soldierX, soldierY = getSoldierPosition(soldier)
    local head = soldier.parts.head
    local hand = soldier.parts.RIGHTforearm.arm.hand

    -- El arma aparece ligeramente delante del soldado.
    addGroundWeapon(
        weapon,
        slot,
        soldierX + math.cos(head.rx) * 35,
        soldierY + math.sin(head.rx) * 35,
        hand.rx or head.rx
    )

    soldier.magazine[slot] = nil

    -- Cambiar automáticamente a otra arma disponible.
    for _, candidateSlot in ipairs(WEAPON_SLOTS) do
        if soldier.magazine[candidateSlot] then
            soldier.magazine.actual = candidateSlot
            return true
        end
    end

    -- El soldado puede quedarse sin armas.
    soldier.magazine.actual = slot
    soldier.anims.actual = "idle"

    return true
end

local function pickupGroundWeapon(soldier, groundObject)
    -- El arma conserva la ranura de la que provenía.
    local slot = groundObject.slot or soldier.magazine.actual
    local currentWeapon = soldier.magazine[slot]

    -- Si la ranura está ocupada, dejar esa arma en el suelo.
    if currentWeapon then
        local soldierX, soldierY = getSoldierPosition(soldier)

        addGroundWeapon(
            currentWeapon,
            slot,
            soldierX,
            soldierY,
            soldier.parts.head.rx
        )
    end

    soldier.magazine[slot] = groundObject.weapon
    soldier.magazine.actual = slot
    soldier.anims.actual = "idle"

    removeGroundWeapon(groundObject)
end

---------------------------------------------------------------------
-- Inicialización e interacción del jugador
---------------------------------------------------------------------

function w.load()
    w.objs = {}
    unit = nil

    for _, soldier in ipairs(soldiers) do
        if soldier.player then
            unit = soldier
            return
        end
    end
end

-- La tecla X funciona como interacción contextual:
--   - recoge el arma más cercana si hay una al alcance;
--   - de lo contrario, suelta el arma equipada.
function w.keypressed(key)
    if key ~= "x" or not unit then
        return
    end

    local nearbyWeapon = findNearestGroundWeapon(unit)

    if nearbyWeapon then
        pickupGroundWeapon(unit, nearbyWeapon)
    else
        dropEquippedWeapon(unit)
    end
end

---------------------------------------------------------------------
-- Controles del arma equipada
---------------------------------------------------------------------

function w.mousepressed(key)
    if not unit or not unit.player then
        return
    end

    if key == 1 then
        local weapon = unit.magazine[unit.magazine.actual]

        if not weapon then
            return
        end

        if weapon.bullets > 0 and unit.anims.actual ~= "shooting" then
            if weapon.prepared then
                if weapon.mode == "auto" then
                    weapon.autoFire = true
                elseif weapon.mode == "semi" then
                    unit.anims.actual = "shooting"
                end
            elseif unit.anims.actual ~= "prepairing" then
                unit.anims.actual = "prepairing"
            end
        elseif unit.anims.actual == "idle" then
            unit.anims.actual = "reload"
        end

    elseif key == 4 then
        unit.magazine.actual = "first"
        unit.anims.actual = "prepairing"

    elseif key == 5 then
        unit.magazine.actual = "second"
        unit.anims.actual = "prepairing"

    elseif key == 3 then
        unit.magazine.actual = "grenade"
        unit.anims.actual = "prepairing"
    end
end

function w.mousereleased(key)
    if not unit or not unit.player then
        return
    end

    local weapon = unit.magazine[unit.magazine.actual]

    if key == 1 and weapon then
        weapon.autoFire = false
    end
end

-- Actualiza el enfriamiento y el disparo automático del arma equipada.
-- Se llama una vez por cada soldado desde main.lua.
function w.updateWeapons(soldier, dt)
    local weapon = soldier.magazine[soldier.magazine.actual]

    -- Un soldado puede no tener ningún arma equipada.
    if not weapon then
        return
    end

    weapon.fireTime = math.max(0, weapon.fireTime - dt)

    if not weapon.autoFire or weapon.fireTime > 0 then
        return
    end

    if weapon.bullets < 1 then
        soldier.anims.actual = "reload"
    elseif soldier.anims.actual ~= "shooting" then
        weapon.fireTime = weapon.fireRate
        soldier.anims.actual = "shooting"
    end
end

---------------------------------------------------------------------
-- Dibujado de armas en el suelo
---------------------------------------------------------------------

local function drawGroundWeapon(object)
    local weapon = object.weapon
    local parts = weapon.parts or {}

    local textures = w.textures[weapon.texture] or {}
    -- Las granadas utilizan la textura ammo; las armas de fuego usan base.
    local image = weapon.pos == "grenade" and textures.ammo or textures.base

    if not image then
        return
    end

    love.graphics.draw(
        image,
        object.x,
        object.y,
        object.rx or 0,
        weapon.size or 0.08,
        weapon.size or 0.08,
        weapon.offsetX or 0,
        weapon.offsetY or 0
    )

    -- Dibujar las piezas adicionales de rifles y pistolas.
    if weapon.pos == "grenade" or not parts.pts then
        return
    end

    local rotation = object.rx or 0
    local cosRotation = math.cos(rotation)
    local sinRotation = math.sin(rotation)

    for index, part in ipairs(parts.pts) do
        local info = part.info
        local offsetX = info.offX * cosRotation - info.offY * sinRotation
        local offsetY = info.offX * sinRotation + info.offY * cosRotation

        if textures.pts[index] then
            love.graphics.draw(
                textures.pts[index],
                object.x + offsetX,
                object.y + offsetY,
                rotation,
                info.offS,
                info.offS,
                weapon.offsetX or 0,
                weapon.offsetY or 0
            )
        end
    end
end

-- Dibuja todas las armas almacenadas en w.objs.
-- soldier_draw.lua se encarga de llamar esta función después de aplicar
-- la cámara del jugador.
function w.draw()
    for _, object in ipairs(w.objs) do
        drawGroundWeapon(object)
    end
end

return w
