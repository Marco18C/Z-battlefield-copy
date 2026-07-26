return {
    toLoad_objects = {
        "basic",
        "secx",
    },
    level = {
        -- =========================
        -- PLAZA CENTRAL
        -- =========================
        {x=-180,y=-80, rx=0,         tex="basic"},
        {x=-80, y=-80, rx=rad(8),    tex="basic"},
        {x=20,  y=-80, rx=0,         tex="basic"},
        {x=120, y=-80, rx=rad(-8),   tex="basic"},

        {x=-180,y=20,  rx=0,         tex="basic"},
        {x=120, y=20,  rx=0,         tex="basic"},

        {x=-180,y=120, rx=rad(-5),   tex="basic"},
        {x=-80, y=120, rx=0,         tex="basic"},
        {x=20,  y=120, rx=rad(6),    tex="basic"},
        {x=120, y=120, rx=0,         tex="basic"},

        -- =========================
        -- EDIFICIOS LADO IZQUIERDO
        -- =========================
        {x=-500,y=-220, rx=0,         tex="secx"},
        {x=-500,y=-80,  rx=rad(12),   tex="secx"},
        {x=-500,y=60,   rx=0,         tex="secx"},
        {x=-500,y=200,  rx=rad(-10),  tex="secx"},

        -- =========================
        -- EDIFICIOS LADO DERECHO
        -- =========================
        {x=500,y=-220, rx=rad(-8),    tex="secx"},
        {x=500,y=-80,  rx=0,          tex="secx"},
        {x=500,y=60,   rx=rad(15),    tex="secx"},
        {x=500,y=200,  rx=0,          tex="secx"},

        -- =========================
        -- BARRICADAS SUPERIORES
        -- =========================
        {x=-240,y=-320, rx=rad(25),   tex="secx"},
        {x=-60, y=-320, rx=0,         tex="secx"},
        {x=120, y=-320, rx=rad(-20),  tex="secx"},
        {x=300, y=-320, rx=0,         tex="secx"},

        -- =========================
        -- BARRICADAS INFERIORES
        -- =========================
        {x=-240,y=360, rx=0,          tex="secx"},
        {x=-60, y=360, rx=rad(-15),   tex="secx"},
        {x=120, y=360, rx=0,          tex="secx"},
        {x=300, y=360, rx=rad(18),    tex="secx"},

        -- =========================
        -- OBSTÁCULOS DISPERSOS
        -- =========================
        {x=-320,y=-120, rx=rad(30),    tex="basic"},
        {x=-260,y=80,   rx=0,          tex="basic"},
        {x=260, y=-120, rx=rad(-30),   tex="basic"},
        {x=320, y=80,   rx=0,          tex="basic"},

        -- =========================
        -- ESQUINAS
        -- =========================
        {x=-620,y=-460, rx=rad(35),   tex="secx"},
        {x=620, y=-460, rx=rad(-35),  tex="secx"},
        {x=-620,y=460,  rx=rad(-25),  tex="secx"},
        {x=620, y=460,  rx=rad(25),   tex="secx"},

        -- =========================
        -- OBJETOS DE PRUEBA
        -- =========================
        {x=-60, y=-180, rx=rad(45),     tex="basic"},
        {x=80,  y=-180, rx=rad(-45),    tex="basic"},
        {x=-60, y=260,  rx=rad(20),     tex="basic"},
        {x=80,  y=260,  rx=rad(-20),    tex="basic"},
    },
}