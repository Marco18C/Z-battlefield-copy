local gen = {
    level = {},
    CHUNK_SIZE = 512,
}

local function loadLevelInfo(mod, level)
    local path = "mod/" .. mod .. "/levels/" .. level .. "/info.lua"

    if not love.filesystem.getInfo(path) then
        error("No se encontró el archivo: " .. path)
    end

    local chunk, err = love.filesystem.load(path)
    if not chunk then
        error("Error al cargar '" .. path .. "': " .. err)
    end

    local info = chunk()

    if type(info) ~= "table" then
        error("El archivo '" .. path .. "' debe retornar una tabla.")
    end

    return info
end

function gen.load(mod, levelName)
    -- Cargar información del nivel
    local levelInfo = loadLevelInfo(mod, levelName)

    -- Cargar las imágenes de los objetos necesarios
    local draw = soldierScripts.draw
    draw.obj_IMGs = draw.loadObjectImages(levelInfo.toLoad_objects, mod)

    local level = {
        chunks = {},
        chunkSize = gen.CHUNK_SIZE
    }

    for _, obj in ipairs(levelInfo.level) do
        local img = draw.obj_IMGs[obj.tex]
        local rx = obj.rx or 0
        imI = img.info

        local object = {
            x = obj.x,
            y = obj.y,
            w = imI.w,
            h = imI.h,

            rx = rx,
            cos = cos(rx),
            sin = sin(rx),

            destro_t = 1,
            pos = imI.pos,

            ox = imI.ox,
            oy = imI.oy,

            health = imI.health,
            tex = obj.tex,
            die = false,
        }

        -- Calcular el chunk al que pertenece
        local chunkX = math.floor(object.x / level.chunkSize)
        local chunkY = math.floor(object.y / level.chunkSize)

        level.chunks[chunkY] = level.chunks[chunkY] or {}
        level.chunks[chunkY][chunkX] = level.chunks[chunkY][chunkX] or {}

        table.insert(level.chunks[chunkY][chunkX], object)
    end

    return level
end

return gen