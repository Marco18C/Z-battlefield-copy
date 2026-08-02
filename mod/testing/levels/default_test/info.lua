-- ============================================================
--  GENERADOR DE NIVEL
--  Piezas:
--    basic -> caja 1:1   80x80
--    secx  -> caja 2:1   120x80
--    wall  -> pared      160x15.6
-- ============================================================

local rad = rad or function(deg) return deg * math.pi / 180 end
-- (si tu motor ya define rad() globalmente, esta línea no hace nada raro,
--  solo evita error si no existe)

local SIZES = {
    basic = {w = 80,  h = 80},
    secx  = {w = 120, h = 80},
    wall  = {w = 160, h = 15.6},
}

local level = {}

local function addPiece(tex, x, y, rx)
    table.insert(level, {x = x, y = y, rx = rx or 0, tex = tex})
end

-- Rota un punto (dx,dy) relativo a un centro (cx,cy) por un ángulo 'ang' (radianes)
local function rotatePoint(cx, cy, dx, dy, ang)
    local ca, sa = math.cos(ang), math.sin(ang)
    local rdx = dx * ca - dy * sa
    local rdy = dx * sa + dy * ca
    return cx + rdx, cy + rdy
end

--[[
    Construye una fila de "count" paredes contiguas (sin huecos entre ellas),
    en la dirección horizontal o vertical, rotada como conjunto un ángulo
    "houseAng" respecto al centro de la casa (hcx,hcy).

    doorIndex: índice (1..count) de la pared que se omite -> deja una entrada.
               nil = fila completa, sin puertas.
]]
local function buildWallLine(hcx, hcy, houseAng, startX, startY, vertical, count, doorIndex)
    local wallLen = SIZES.wall.w -- 160
    local localRot = vertical and rad(90) or 0

    for i = 1, count do
        if i ~= doorIndex then
            local dx, dy
            if vertical then
                dx, dy = 0, wallLen * (i - 0.5)
            else
                dx, dy = wallLen * (i - 0.5), 0
            end

            local localX = (startX - hcx) + dx
            local localY = (startY - hcy) + dy
            local px, py = rotatePoint(hcx, hcy, localX, localY, houseAng)

            addPiece("wall", px, py, localRot + houseAng)
        end
    end
end

-- Devuelve el semiancho/semialto del rectángulo (width x height) ya rotado
-- 'ang' radianes -> AABB que lo contiene (para poder separar casas sin colisiones)
local function rotatedHalfExtents(width, height, ang)
    local ca, sa = math.abs(math.cos(ang)), math.abs(math.sin(ang))
    local halfW = (width * ca + height * sa) / 2
    local halfH = (width * sa + height * ca) / 2
    return halfW, halfH
end

--[[
    Construye una casa rectangular con 4 filas de paredes (arriba, abajo,
    izquierda, derecha). Cada fila tiene MÍNIMO 3 piezas "wall" pegadas
    entre sí (sin huecos), salvo en el lado con puerta.

    hWalls : nº de paredes en las filas horizontales (mínimo 3)
    vWalls : nº de paredes en las filas verticales   (mínimo 3)
    houseAng : rotación de toda la casa, en radianes
    door : {side="top"|"bottom"|"left"|"right", index=n} -> hueco de entrada
]]
local function buildHouse(cx, cy, hWalls, vWalls, houseAng, door)
    hWalls = math.max(hWalls or 3, 3)
    vWalls = math.max(vWalls or 3, 3)

    local width  = hWalls * SIZES.wall.w
    local height = vWalls * SIZES.wall.w
    local thick  = SIZES.wall.h

    local left, right = cx - width/2, cx + width/2
    local top, bottom  = cy - height/2, cy + height/2

    door = door or {}

    buildWallLine(cx, cy, houseAng, left, top + thick/2, false, hWalls,
        door.side == "top" and door.index or nil)

    buildWallLine(cx, cy, houseAng, left, bottom - thick/2, false, hWalls,
        door.side == "bottom" and door.index or nil)

    buildWallLine(cx, cy, houseAng, left + thick/2, top, true, vWalls,
        door.side == "left" and door.index or nil)

    buildWallLine(cx, cy, houseAng, right - thick/2, top, true, vWalls,
        door.side == "right" and door.index or nil)
end

-- ============================================================
--  DEFINICIÓN DE CASAS (8 casas > 7 pedidas)
--  Ya NO llevan cx,cy: la posición se calcula sola en un grid,
--  con separación garantizada según el tamaño real (ya rotado)
--  de cada casa, para que ninguna colisione con otra.
-- ============================================================

local MARGIN = 200 -- espacio libre mínimo entre casas vecinas

local houseDefs = {
    {hWalls=3, vWalls=3, ang=0,       door={side="bottom", index=2}},
    {hWalls=4, vWalls=3, ang=0,       door={side="top",    index=2}},
    {hWalls=3, vWalls=4, ang=rad(8),  door={side="left",   index=2}},
    {hWalls=3, vWalls=3, ang=0,       door={side="right",  index=2}},
    {hWalls=5, vWalls=3, ang=rad(-6), door={side="bottom", index=3}},
    {hWalls=3, vWalls=3, ang=0,       door={side="top",    index=2}},
    {hWalls=4, vWalls=4, ang=rad(15), door={side="left",   index=2}},
    {hWalls=3, vWalls=3, ang=0,       door={side="bottom", index=2}},
}

-- 1) calcular el AABB (ya rotado) de cada casa
local maxHalfW, maxHalfH = 0, 0
for _, h in ipairs(houseDefs) do
    local width  = h.hWalls * SIZES.wall.w
    local height = h.vWalls * SIZES.wall.w
    local halfW, halfH = rotatedHalfExtents(width, height, h.ang)
    h.halfW, h.halfH = halfW, halfH
    maxHalfW = math.max(maxHalfW, halfW)
    maxHalfH = math.max(maxHalfH, halfH)
end

-- 2) tamaño de celda de grid = el mayor bounding box + margen
--    (garantiza que CUALQUIER par de casas del grid quede separado)
local cellW = maxHalfW * 2 + MARGIN
local cellH = maxHalfH * 2 + MARGIN

-- 3) distribuir en un grid lo más cuadrado posible
local cols = math.ceil(math.sqrt(#houseDefs))
local rows = math.ceil(#houseDefs / cols)

local gridOriginX = -(cols - 1) / 2 * cellW
local gridOriginY = -(rows - 1) / 2 * cellH

for i, h in ipairs(houseDefs) do
    local col = (i - 1) % cols
    local row = math.floor((i - 1) / cols)
    h.cx = gridOriginX + col * cellW
    h.cy = gridOriginY + row * cellH
    buildHouse(h.cx, h.cy, h.hWalls, h.vWalls, h.ang, h.door)
end

-- ============================================================
--  COBERTURA SUELTA (cajas basic / secx dispersas)
--  Se colocan en los pasillos entre columnas/filas del grid de casas,
--  que sabemos que están libres (ahí está el MARGIN), así que nunca
--  caen encima de una pared.
-- ============================================================

local coverTex = {"basic", "secx"}
local coverIndex = 0
local function nextCoverTex()
    coverIndex = coverIndex + 1
    return coverTex[(coverIndex - 1) % #coverTex + 1]
end

-- pasillos verticales: entre cada par de columnas, para cada fila
for row = 0, rows - 1 do
    for col = 0, cols - 2 do
        local x = gridOriginX + col * cellW + cellW / 2
        local y = gridOriginY + row * cellH
        addPiece(nextCoverTex(), x, y, rad(math.random(0, 360)))
    end
end

-- pasillos horizontales: entre cada par de filas, para cada columna
for row = 0, rows - 2 do
    for col = 0, cols - 1 do
        local x = gridOriginX + col * cellW
        local y = gridOriginY + row * cellH + cellH / 2
        addPiece(nextCoverTex(), x, y, rad(math.random(0, 360)))
    end
end

-- unas pocas piezas extra en el perímetro exterior, a modo de cobertura del borde
local ringDefs = {
    {dx = -cellW,        dy = -cellH * 0.5},
    {dx = cols * cellW * 0.5, dy = 0},
    {dx = 0,             dy = rows * cellH * 0.5},
    {dx = -cols * cellW * 0.5, dy = rows * cellH * 0.5},
}
for _, r in ipairs(ringDefs) do
    addPiece(nextCoverTex(), gridOriginX + r.dx, gridOriginY + r.dy, rad(math.random(0, 360)))
end

return {
    toLoad_objects = {
        "basic",
        "secx",
        "wall",
    },
    level = level,
}