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

function loadCSrot(obj)
    obj.cos = math.cos(obj.rx or 0)
    obj.sin = math.sin(obj.rx or 0)
end

---------------------------------------------------------
-- SOLDIERS DATA (tu mismo)
---------------------------------------------------------
soldiers = {
    {
        actualChunk = {

            -- =========================
            -- CASAS CENTRALES
            -- =========================
            {x=0,   y=0,   w=180,h=180, ox=90,oy=90, rx=0,         pos="below"},
            {x=300, y=0,   w=180,h=180, ox=90,oy=90, rx=rad(15),   pos="below"},
            {x=-300,y=0,   w=180,h=180, ox=90,oy=90, rx=rad(-10),  pos="below"},

            -- =========================
            -- FILA SUPERIOR
            -- =========================
            {x=-400,y=-250,w=160,h=160, ox=80,oy=80, rx=0,         pos="above"},
            {x=-150,y=-250,w=160,h=160, ox=80,oy=80, rx=rad(25),   pos="above"},
            {x=150, y=-250,w=160,h=160, ox=80,oy=80, rx=0,         pos="above"},
            {x=400, y=-250,w=160,h=160, ox=80,oy=80, rx=rad(-20),  pos="above"},

            -- =========================
            -- FILA INFERIOR
            -- =========================
            {x=-400,y=250,w=160,h=160, ox=80,oy=80, rx=rad(10),    pos="below"},
            {x=-150,y=250,w=160,h=160, ox=80,oy=80, rx=0,          pos="below"},
            {x=150, y=250,w=160,h=160, ox=80,oy=80, rx=rad(-15),   pos="below"},

            -- =========================
            -- CALLE CENTRAL (obstáculos)
            -- =========================
            {x=-100,y=120,w=60,h=200, ox=30,oy=100, rx=rad(30),    pos="above"},
            {x=100, y=120,w=60,h=200, ox=30,oy=100, rx=rad(-30),   pos="above"},

            -- =========================
            -- OBJETOS PEQUEÑOS (debug fino)
            -- =========================
            {x=0,   y=300,w=80,h=120, ox=40,oy=60, rx=rad(45),     pos="above"},
            {x=200, y=330,w=80,h=120, ox=40,oy=60, rx=0,           pos="above"},
            {x=230, y=300,w=80,h=120, ox=40,oy=60, rx=0,           pos="below"},
            {x=350, y=350,w=80,h=120, ox=40,oy=60, rx=rad(10),     pos="below"},

            -- =========================
            -- PASILLOS ESTRECHOS (para romper tu sistema 😄)
            -- =========================
            {x=-50, y=-50, w=300,h=40, ox=150,oy=20, rx=rad(5),     pos="above"},
            {x=-50, y=50,  w=300,h=40, ox=150,oy=20, rx=rad(-5),    pos="above"},

            -- =========================
            -- ESQUINAS ROTADAS (stress test)
            -- =========================
            {x=-500,y=-400,w=200,h=80, ox=100,oy=40, rx=rad(35),    pos="below"},
            {x=500, y=-400,w=200,h=80, ox=100,oy=40, rx=rad(-35),   pos="below"},
            {x=-500,y=400, w=200,h=80, ox=100,oy=40, rx=rad(-25),   pos="below"},
            {x=500, y=400, w=200,h=80, ox=100,oy=40, rx=rad(25),    pos="below"},
        },
        player = true,
        controls = {
            u = false,
            d = false,
            l = false,
            r = false,
            moving = false,
            last = "r",
        },
        stats = {
            speed = 300,
        },
        anims = {},
        textures = {
            head = love.graphics.newImage("textures/soldiers/usa/base/head.png"),
            torso = love.graphics.newImage("textures/soldiers/usa/base/torso.png"),
            RIGHTforearm = love.graphics.newImage("textures/soldiers/usa/base/rigthForearm.png"),
            RIGHTarm = love.graphics.newImage("textures/soldiers/usa/base/rigthArm.png"),
            RIGHThand = {
                [1] = love.graphics.newImage("textures/soldiers/usa/base/rightHand.png"),
            },
            RIGHTforeleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/rigthForeleg.png"),
                quads = {},
            },
            RIGHTleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/rigthLeg.png"),
                quads = {},
            },
            RIGHTfoot = love.graphics.newImage("textures/soldiers/usa/base/rigthFoot.png"),
            LEFTforearm = love.graphics.newImage("textures/soldiers/usa/base/leftForearm.png"),
            LEFTarm = love.graphics.newImage("textures/soldiers/usa/base/leftArm.png"),
            LEFThand = {
                [1] = love.graphics.newImage("textures/soldiers/usa/base/leftHand.png"),
            },
            LEFTforeleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/leftForeleg.png"),
                quads = {},
            },
            LEFTleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/leftLeg.png"),
                quads = {},
            },
            LEFTfoot = love.graphics.newImage("textures/soldiers/usa/base/leftFoot.png"),
        },
        magazine = {
            actual = "first",
            first  = {
                offsetX=450,offsetY=300,damage=35,    -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                mode="auto",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                pos="first", -- first - second
                fireRate=.05,fireTime=0,
                func=function(weapon)end,
                img={
                    base=love.graphics.newImage("textures/weapons/guns/test_rifle/base.png"),
                    ammo=love.graphics.newImage("textures/weapons/guns/test_rifle/ammo.png"),
                },
                props = {
                    lever = {
                        ox = 12,
                        oy = 12,
                    }
                },
                autoFire=false,
                maxBullets=30,
                bullets=30,
                anims={
                    actual = "idle",
                    idle = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "ammo"},
                        },
                    },
                    shooting = {
                        loop = false,
                        [1] = {
                            time = .025,
                            {part = "hand", side = "L", prop = "ly", value = 69},
                            {part = "hand", side = "R", prop = "ly", value = 59},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = math.max(0, weapon.bullets - 1) end, value = 0},
                        },
                        [2] = {
                            time = .025,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                    reload = {
                        loop = false,
                        [1] = {
                            time = .25,
                            {part = "hand", side = "L", prop = "ly", value = 78},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-9)},
                        },
                        [2] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(45)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-35)},
                        },
                        [3] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 59},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(35)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-42)},
                        },
                        [4] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 25},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop= "ro", value = rad(35)},
                            {part = "hand", side = "R", prop= "ro", value = rad(-32)},
                        },
                        [5] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(55)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-10)},
                        },
                        [6] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = weapon.maxBullets end, value = 0},
                        },
                    },
                },
            },
            second = {
                offsetX=10,offsetY=304,damage=35,
                HandOffX=20,HandOffY=0,size=.035,
                mode="semi", -- auto - burst - semi
                pos="second", -- first - second
                fireRate=.5,fireTime=0,
                img={
                    base=love.graphics.newImage("textures/weapons/guns/test_pistol/base.png"),
                    ammo=love.graphics.newImage("textures/weapons/guns/test_pistol/ammo.png"),
                },
                autoFire=false,
                maxBullets=10,
                bullets=10,
                anims={
                    actual = "idle",
                    idle = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                    },
                    shooting = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 49},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = math.max(0, weapon.bullets - 1) end, value = 0},
                        },
                        [2] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                    reload = {
                        loop = false,
                        [1] = {
                            time = .1,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                        [2] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 59},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(35)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-9)},

                            {part = "inHand", side = "L", prop = "img", value = "ammo"},
                        },
                        [3] = {
                            time = .45,
                            {part = "hand", side = "L", prop = "ly", value = 15},
                            {part = "hand", side = "R", prop = "ly", value = 59},

                            {part = "hand", side = "L", prop= "ro", value = rad(35)},
                            {part = "hand", side = "R", prop= "ro", value = 0},
                        },
                        [4] = {
                            time = .10,
                            {part = "hand", side = "L", prop = "ly", value = 69},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(5)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = 10 end, value = 0},
                        },
                        [5] = {
                            time = .25,
                            {part = "hand", side = "L", prop = "ly", value = 73},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(12.5)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                        [6] = {
                            time = .3,
                            {part = "hand", side = "L", prop = "ly", value = 29},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(15)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                        [7] = {
                            time = .1,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                },
            },
        },
        parts = {
            dir = -1,
            torso = {
                x = 400, y = 300, w = 30, h = 20, rx = 0, ry = 0,
                shouldR = {x=0,y=-26}, shouldL = {x=0,y=26},
                hipR    = {x=0,y=-20}, hipL    = {x=0,y=20},
                _lastSafe = {
                    x=nil,
                    y=nil,
                    rx=nil,
                    ly=nil
                },
            },
            head  = {
                x=400, y=270, w=30, h=20, rx=0, ry=0
            },
            RIGHTforearm = {
                x = 100, y = 100, w = 30, h = 20, ro = -45, rx = 0, ry = 0, long = 40,
                arm = {
                    dist=7, x=100, y=100, w=30, h=20, ro=-45, rx=0, ry=0, long=40,
                    hand = { -- mano derecha
                        x=440, y=300, w=30, h=20, rx=0, ro=0, ly=59,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            img = "none",
                            rx  = 0,
                            sx  = .04,
                            sy  = .04,
                            ox  = 0,
                            oy  = 0,
                        }
                    }
                }
            },

            LEFTforearm = {
                x = 100, y = 100, w = 30, h = 20, ro = -45, rx = 0, ry = 0, long = 40,
                arm = {
                    dist=7, x=100, y=100, w=30, h=20, ro=-45, rx=0, ry=0, long=40,
                    hand = { -- mano izquierda
                        x=320, y=300, w=30, h=20, rx=0, ro=1, ly=69,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            img = "ammo",
                            rx  = 0,
                            sx  = .04,
                            sy  = .04,
                            ox  = 0,
                            oy  = 500,
                        }
                    }
                }
            },

            RIGHTforeleg = {
                x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                leg = {
                    dist=7,x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                    foot = { -- pie derecho
                        x=320,y=300,w=30,h=20,rx=rad(100),rl=0,ly=79,
                        stepT = 0,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                    }
                }
            },
            LEFTforeleg = {
                x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                leg = {
                    dist=7,x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                    foot = { -- pie izquierdo
                        x=320,y=300,w=30,h=20,rx=rad(80),rl=0,ly=80,
                        stepT = 0,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                    }
                }
            },
        }
    },
    {
        actualChunk = {},
        player = false,
        controls = {
            u = false,
            d = false,
            l = false,
            r = false,
            moving = false,
            last = "r",
        },
        stats = {
            speed = 300,
        },
        anims = {},
        textures = {
            head = love.graphics.newImage("textures/soldiers/usa/base/head.png"),
            torso = love.graphics.newImage("textures/soldiers/usa/base/torso.png"),
            RIGHTforearm = love.graphics.newImage("textures/soldiers/usa/base/rigthForearm.png"),
            RIGHTarm = love.graphics.newImage("textures/soldiers/usa/base/rigthArm.png"),
            RIGHThand = {
                [1] = love.graphics.newImage("textures/soldiers/usa/base/rightHand.png"),
            },
            RIGHTforeleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/rigthForeleg.png"),
                quads = {},
            },
            RIGHTleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/rigthLeg.png"),
                quads = {},
            },
            RIGHTfoot = love.graphics.newImage("textures/soldiers/usa/base/rigthFoot.png"),
            LEFTforearm = love.graphics.newImage("textures/soldiers/usa/base/leftForearm.png"),
            LEFTarm = love.graphics.newImage("textures/soldiers/usa/base/leftArm.png"),
            LEFThand = {
                [1] = love.graphics.newImage("textures/soldiers/usa/base/leftHand.png"),
            },
            LEFTforeleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/leftForeleg.png"),
                quads = {},
            },
            LEFTleg = {
                img = love.graphics.newImage("textures/soldiers/usa/base/leftLeg.png"),
                quads = {},
            },
            LEFTfoot = love.graphics.newImage("textures/soldiers/usa/base/leftFoot.png"),
        },
        magazine = {
            actual = "first",
            first  = {
                offsetX=450,offsetY=300,damage=35,    -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                mode="auto",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                pos="first", -- first - second
                fireRate=.05,fireTime=0,
                func=function(weapon)end,
                img={
                    base=love.graphics.newImage("textures/weapons/guns/test_rifle/base.png"),
                    ammo=love.graphics.newImage("textures/weapons/guns/test_rifle/ammo.png"),
                },
                props = {
                    lever = {
                        ox = 12,
                        oy = 12,
                    }
                },
                autoFire=false,
                maxBullets=30,
                bullets=30,
                anims={
                    actual = "idle",
                    idle = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "ammo"},
                        },
                    },
                    shooting = {
                        loop = false,
                        [1] = {
                            time = .025,
                            {part = "hand", side = "L", prop = "ly", value = 69},
                            {part = "hand", side = "R", prop = "ly", value = 59},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = math.max(0, weapon.bullets - 1) end, value = 0},
                        },
                        [2] = {
                            time = .025,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                    reload = {
                        loop = false,
                        [1] = {
                            time = .25,
                            {part = "hand", side = "L", prop = "ly", value = 78},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-9)},
                        },
                        [2] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(45)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-35)},
                        },
                        [3] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 59},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(35)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-42)},
                        },
                        [4] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 25},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop= "ro", value = rad(35)},
                            {part = "hand", side = "R", prop= "ro", value = rad(-32)},
                        },
                        [5] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(55)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-10)},
                        },
                        [6] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 74},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(20)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = weapon.maxBullets end, value = 0},
                        },
                    },
                },
            },
            second = {
                offsetX=10,offsetY=304,damage=35,
                HandOffX=20,HandOffY=0,size=.035,
                mode="semi", -- auto - burst - semi
                pos="second", -- first - second
                fireRate=.5,fireTime=0,
                img={
                    base=love.graphics.newImage("textures/weapons/guns/test_pistol/base.png"),
                    ammo=love.graphics.newImage("textures/weapons/guns/test_pistol/ammo.png"),
                },
                autoFire=false,
                maxBullets=10,
                bullets=10,
                anims={
                    actual = "idle",
                    idle = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                    },
                    shooting = {
                        loop = false,
                        [1] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 49},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = math.max(0, weapon.bullets - 1) end, value = 0},
                        },
                        [2] = {
                            time = .05,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                    reload = {
                        loop = false,
                        [1] = {
                            time = .1,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                        [2] = {
                            time = .15,
                            {part = "hand", side = "L", prop = "ly", value = 59},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(35)},
                            {part = "hand", side = "R", prop = "ro", value = rad(-9)},

                            {part = "inHand", side = "L", prop = "img", value = "ammo"},
                        },
                        [3] = {
                            time = .45,
                            {part = "hand", side = "L", prop = "ly", value = 15},
                            {part = "hand", side = "R", prop = "ly", value = 59},

                            {part = "hand", side = "L", prop= "ro", value = rad(35)},
                            {part = "hand", side = "R", prop= "ro", value = 0},
                        },
                        [4] = {
                            time = .10,
                            {part = "hand", side = "L", prop = "ly", value = 69},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(5)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "weapon", side = "func", prop=function(weapon)weapon.bullets = 10 end, value = 0},
                        },
                        [5] = {
                            time = .25,
                            {part = "hand", side = "L", prop = "ly", value = 73},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(12.5)},
                            {part = "hand", side = "R", prop = "ro", value = 0},

                            {part = "inHand", side = "L", prop = "img", value = "none"},
                        },
                        [6] = {
                            time = .3,
                            {part = "hand", side = "L", prop = "ly", value = 29},
                            {part = "hand", side = "R", prop = "ly", value = 69},

                            {part = "hand", side = "L", prop = "ro", value = rad(15)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                        [7] = {
                            time = .1,
                            {part = "hand", side = "L", prop = "ly", value = 79},
                            {part = "hand", side = "R", prop = "ly", value = 79},

                            {part = "hand", side = "L", prop = "ro", value = rad(37)},
                            {part = "hand", side = "R", prop = "ro", value = 0},
                        },
                    },
                },
            },
        },
        parts = {
            dir = -1,
            torso = {
                x = 400, y = 300, w = 30, h = 20, rx = 0, ry = 0,
                shouldR = {x=0,y=-26}, shouldL = {x=0,y=26},
                hipR    = {x=0,y=-20}, hipL    = {x=0,y=20},
                _lastSafe = {
                    x=nil,
                    y=nil,
                    rx=nil,
                    ly=nil
                },
            },
            head  = {
                x=400, y=270, w=30, h=20, rx=0, ry=0
            },
            RIGHTforearm = {
                x = 100, y = 100, w = 30, h = 20, ro = -45, rx = 0, ry = 0, long = 40,
                arm = {
                    dist=7, x=100, y=100, w=30, h=20, ro=-45, rx=0, ry=0, long=40,
                    hand = { -- mano derecha
                        x=440, y=300, w=30, h=20, rx=0, ro=0, ly=59,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            img = "none",
                            rx  = 0,
                            sx  = .04,
                            sy  = .04,
                            ox  = 0,
                            oy  = 0,
                        }
                    }
                }
            },

            LEFTforearm = {
                x = 100, y = 100, w = 30, h = 20, ro = -45, rx = 0, ry = 0, long = 40,
                arm = {
                    dist=7, x=100, y=100, w=30, h=20, ro=-45, rx=0, ry=0, long=40,
                    hand = { -- mano izquierda
                        x=320, y=300, w=30, h=20, rx=0, ro=1, ly=69,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            img = "ammo",
                            rx  = 0,
                            sx  = .04,
                            sy  = .04,
                            ox  = 0,
                            oy  = 500,
                        }
                    }
                }
            },

            RIGHTforeleg = {
                x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                leg = {
                    dist=7,x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                    foot = { -- pie derecho
                        x=320,y=300,w=30,h=20,rx=rad(100),rl=0,ly=79,
                        stepT = 0,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                    }
                }
            },
            LEFTforeleg = {
                x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                leg = {
                    dist=7,x=100,y=100,w=30,h=20,ro=-45,rx=0,ry=0,long=40,
                    foot = { -- pie izquierdo
                        x=320,y=300,w=30,h=20,rx=rad(80),rl=0,ly=80,
                        stepT = 0,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                    }
                }
            },
        }
    },
}

local function createLegQuads(tex)
    local quads = {}

    local w = tex:getWidth() / 6
    local h = tex:getHeight() / 2

    for row = 0, 1 do
        quads[row] = {}
        for col = 0, 5 do
            quads[row][col] = love.graphics.newQuad(
                col * w, row * h, w, h,
                tex:getWidth(), tex:getHeight()
            )
        end
    end

    return quads
end

---------------------------------------------------------
function love.load()

    for _, soldier in ipairs(soldiers) do

        local sTEX = soldier.textures

        sTEX.LEFTforeleg.quads = createLegQuads(sTEX.LEFTforeleg.img)
        sTEX.LEFTleg.quads = createLegQuads(sTEX.LEFTleg.img)
        sTEX.RIGHTforeleg.quads = createLegQuads(sTEX.RIGHTforeleg.img)
        sTEX.RIGHTleg.quads = createLegQuads(sTEX.RIGHTleg.img)

        for _, obj in ipairs(soldier.actualChunk) do
            loadCSrot(obj)

        end

    end

    soldierScripts = {
        update  = require("src.soldier_update"),
        draw    = require("src.soldier_draw"),
        anims   = require("src.soldier_anims"),
        weapons = require("src.soldier_weapon"),
    }

    soldierScripts.weapons.load()

    -- worldScripts = {
    --     terrain = require("ScriptsWorld.terrain")
    -- }
end

function love.resize(w, h)
    WindowsSIZE = (w / 1280)
    win.w = w
    win.h = h
end

function love.keypressed(key)
    local number = tonumber(key)
    if type(number) == "number" then win.s = number end
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
    collectgarbage("collect")
end

function love.draw()
    soldierScripts.draw()
    -- worldScripts.terrain(soldiers)
end