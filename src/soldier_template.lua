return {
            chunkX = nil,
            chunkY = nil,
            actualChunk = {},
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
                health = 100,
                containment = false,
            },
            anims = {actual = "idle",},
            textures = {},
            magazine = {
                actual = "first",
                first  = {
                    offsetX=450,offsetY=300,damage=10,    -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                    mode="auto",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    shootOffsetX=50,shootOffsetY=0,shootMaxDistance=2200,shootSpread=rad(1.5),objectDamagePercent=0.1, -- =0≡= config. raycast de disparo =≡0= --
                    pos="first", -- first - second
                    fireRate=.05,fireTime=0,
                    func=function(weapon)end,
                    parts={
                        base=love.graphics.newImage("mod/testing/weapons/guns/test_rifle/base.png"),
                        ammo=love.graphics.newImage("mod/testing/weapons/guns/test_rifle/ammo.png"),
                        pts = {
                            [1] = {
                                img = love.graphics.newImage("mod/testing/weapons/guns/test_rifle/part_1.png"),
                                info = {offX = 20, offY = -28, offS = .025}
                            },
                            [2] = {
                                img = love.graphics.newImage("mod/testing/weapons/guns/test_rifle/part_2.png"),
                                info = {offX = 19, offY = 18.5, offS = .04}
                            },
                        },
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

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[2].info.offS = 0
                                end, value = 0},

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

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.bullets = math.max(0, weapon.bullets - 1)

                                    soldierScripts.shoot.fire(ent, weapon, {
                                        offsetX             = weapon.shootOffsetX,
                                        offsetY             = weapon.shootOffsetY,
                                        rotation            = (math.random() * 2 - 1) * (weapon.shootSpread or 0),
                                        maxDistance         = weapon.shootMaxDistance,
                                        damage              = weapon.damage,
                                        objectDamagePercent = weapon.objectDamagePercent,
                                    })

                                    weapon.parts.pts[2].info.offS = 0
                                    weapon.parts.pts[1].info.offX = 10
                                end, value = 0},
                            },
                            [2] = {
                                time = .025,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 20
                                end, value = 0},
                            },
                        },
                        reload = {
                            loop = false,
                            [1] = {
                                time = .10,
                                {part = "hand", side = "L", prop = "ly", value = 78},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-9)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    soldierScripts.propz.shoot(ent.parts.LEFTforearm.arm.hand.x,
                                                               ent.parts.LEFTforearm.arm.hand.y,
                                                               ent.parts.LEFTforearm.arm.hand.rx + rad(45), {
                                        speed = 750,
                                        accel = -200,            -- aceleración en dirección del movimiento
                                        w = 6, h = 6, s = .035,   -- tamaño de colisión del proyectil
                                        texture = "ammo",      -- nombre en prop.textures
                                        lifetime = 40,
                                        piercing = false,       -- si sigue tras impactar (según onHit)

                                        onHit = "bounce",

                                        -- para onHit = "damage"
                                        damage = 0,
                                        damageRadius = 0,       -- 0 = solo golpea al objeto; >0 = daño en área

                                        -- para onHit = "bounce"
                                        bounceDamage = 0,
                                        bounceRestitution = .1,  -- 1 = rebote perfecto, <1 pierde energía
                                        maxBounces = 10,

                                        onHitFunc = function(proyectil, objeto) return true end,
                                    })
                                    weapon.parts.pts[1].info.offX = 10
                                end, value = 0},
                            },
                            [2] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 100},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(85)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-35)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [3] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 59},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(35)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-42)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [4] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 25},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop= "ro", value = rad(35)},
                                {part = "hand", side = "R", prop= "ro", value = rad(-32)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [5] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(55)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-10)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [6] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "weapon", side = "func", prop=function(weapon)
                                    weapon.parts.pts[2].info.offS = .04
                                    weapon.bullets = weapon.maxBullets
                                end, value = 0},
                            },
                            [7] = {
                                time = .2,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = true},

                                {part = "inHand", side = "L", prop = "img", value = "none"},
                            },
                            [8] = {
                                time = .5,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 2},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                            },
                            [9] = {
                                time = .4,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 7
                                end, value = 0},
                            },
                            [10] = {
                                time = .1,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "handSteps", value = true},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 20
                                end, value = 0},
                            },
                            [11] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[2].info.offS = 0
                                end, value = 0},

                                {part = "inHand", side = "L", prop = "img", value = "ammo"},
                            },
                        },
                    },
                },
                second = {
                    offsetX=10,offsetY=304,damage=35,
                    HandOffX=20,HandOffY=0,size=.035,
                    shootOffsetX=40,shootOffsetY=0,shootMaxDistance=1400,shootSpread=rad(0.5),objectDamagePercent=0.3,
                    mode="semi", -- auto - burst - semi
                    pos="second", -- first - second
                    fireRate=.5,fireTime=0,
                    parts={
                        base=love.graphics.newImage("mod/testing/weapons/guns/test_pistol/base.png"),
                        ammo=love.graphics.newImage("mod/testing/weapons/guns/test_pistol/ammo.png"),
                        pts = {
                            [1] = {
                                img = love.graphics.newImage("mod/testing/weapons/guns/test_pistol/part_1.png"),
                                info = {offX = 0, offY = 0, offS = .035}
                            },
                        },
                    },
                    autoFire=false,
                    maxBullets=10,
                    bullets=10,
                    anims={
                        actual = "idle",
                        idle = {
                            loop = true,
                            [1] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(37)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 2},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

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

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.bullets = math.max(0, weapon.bullets - 1)

                                    weapon.parts.pts[1].info.offX = -10

                                    soldierScripts.shoot.fire(ent, weapon, {
                                        offsetX             = weapon.shootOffsetX,
                                        offsetY             = weapon.shootOffsetY,
                                        rotation            = (math.random() * 2 - 1) * (weapon.shootSpread or 0),
                                        maxDistance         = weapon.shootMaxDistance,
                                        damage              = weapon.damage,
                                        objectDamagePercent = weapon.objectDamagePercent,
                                    })
                                end, value = 0},
                            },
                            [2] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(37)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 0
                                end, value = 0},
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

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = -10
                                end, value = 0},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

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

                                {part = "hand", side = "L", prop = "handSteps", value = true},

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

                                {part = "hand", side = "L", prop = "ro", value = rad(5)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = -15
                                end, value = 0},
                            },
                            [8] = {
                                time = .5,
                                {part = "hand", side = "L", prop = "ly", value = 69},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(5)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = -20
                                end, value = 0},
                            },
                            [9] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 61},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(5)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},
                            },
                            [10] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(37)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 0
                                end, value = 0},
                            },
                        },
                    },
                },
                grenade  = {
                    offsetX=450,offsetY=300,damage=100,   -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                    mode="semi",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    shootOffsetX=50,shootOffsetY=0,shootMaxDistance=2200,shootSpread=rad(1.5),objectDamagePercent=1, -- =0≡= config. raycast de disparo =≡0= --
                    pos="grenade", -- first - second
                    fireRate=.05,fireTime=0,
                    func=function(weapon)end,
                    parts={
                        base=love.graphics.newImage("textures/none.png"),
                        ammo=love.graphics.newImage("mod/testing/weapons/throwable/grenade.png"),
                        pts = {},
                    },
                    props = {
                        lever = {
                            ox = 12,
                            oy = 12,
                        }
                    },
                    autoFire=false,
                    maxBullets=1,
                    bullets=1,
                    anims={
                        actual = "idle",
                        idle = {
                            loop = false,
                            [1] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 41},
                                {part = "hand", side = "R", prop = "ly", value = 55},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-80)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "ammo"},
                            },
                            [2] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 100},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(85)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-35)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [3] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 59},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(35)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-42)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [4] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 25},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop= "ro", value = rad(35)},
                                {part = "hand", side = "R", prop= "ro", value = rad(-32)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [5] = {
                                time = .15,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(55)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-10)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [6] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(0)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                            [7] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 41},
                                {part = "hand", side = "R", prop = "ly", value = 55},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-80)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "ammo"},
                            },
                            [8] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 41},
                                {part = "hand", side = "R", prop = "ly", value = 55},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-80)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "ammo"},
                            },
                            [9] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 59},
                                {part = "hand", side = "R", prop = "ly", value = 49},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-20)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},
                            },
                            [10] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 80},
                                {part = "hand", side = "R", prop = "ly", value = 49},

                                {part = "hand", side = "L", prop = "ro", value = rad(0)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-30)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},
                            },
                            [11] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 81},
                                {part = "hand", side = "R", prop = "ly", value = 49},

                                {part = "hand", side = "L", prop = "ro", value = rad(30)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-20)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 2},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},
                            },
                            [12] = {
                                time = .03,
                                {part = "hand", side = "L", prop = "ly", value = 80},
                                {part = "hand", side = "R", prop = "ly", value = 49},

                                {part = "hand", side = "L", prop = "ro", value = rad(79)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-20)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 2},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "none"},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    soldierScripts.propz.shoot(ent.parts.LEFTforearm.arm.hand.x,
                                                               ent.parts.LEFTforearm.arm.hand.y,
                                                               ent.parts.LEFTforearm.arm.hand.rx, {
                                        speed = 750,
                                        accel = -200,            -- aceleración en dirección del movimiento
                                        w = 6, h = 6, s = .035,   -- tamaño de colisión del proyectil
                                        texture = "grenade",      -- nombre en prop.textures
                                        lifetime = 40,
                                        piercing = false,       -- si sigue tras impactar (según onHit)

                                        onHit = "damage",

                                        -- para onHit = "damage"
                                        damage = weapon.damage,
                                        damageRadius = weapon.damage * 2,       -- 0 = solo golpea al objeto; >0 = daño en área

                                        -- para onHit = "bounce"
                                        bounceDamage = 0,
                                        bounceRestitution = .1,  -- 1 = rebote perfecto, <1 pierde energía
                                        maxBounces = 10,

                                        onHitFunc = function(proyectil, objeto) return true end,
                                    })
                                end, value = 0},
                            },
                            [13] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 85},
                                {part = "hand", side = "R", prop = "ly", value = 39},

                                {part = "hand", side = "L", prop = "ro", value = rad(0)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-45)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 2},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", prop = "actual", value = "first"},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    ent.anims.actual = "shooting"
                                end, value = 0},
                            },
                            [14] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 41},
                                {part = "hand", side = "R", prop = "ly", value = 55},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-80)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "none"},
                            },
                        },
                        shooting = {
                            loop = false,
                            [1] = {
                                time = .45,

                                {part = "weapon", prop = "actual", value = "first"},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    ent.anims.actual = "shooting"
                                end, value = 0},
                            },
                        },
                        reload = {
                            loop = false,
                            [1] = {
                                {part = "weapon", prop = "actual", value = "first"},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    ent.anims.actual = "shooting"
                                end, value = 0},
                            },
                        },
                    },
                },
            },
            parts = {
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
                            x=440, y=300, w=30, h=20, rx=0, ro=0, ly=59, ry=1,
                            handSteps = false,
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
                            x=320, y=300, w=30, h=20, rx=0, ro=1, ly=69, ry=1,
                            handSteps = false,
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
                            },
                        },
                    },
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
                        },
                    },
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
                        },
                    },
                },
            },
        }