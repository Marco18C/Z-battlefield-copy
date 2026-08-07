return {
                    offsetX=450,offsetY=300,damage=100,   -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                    mode="semi",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    shootOffsetX=50,shootOffsetY=0,shootMaxDistance=2200,shootSpread=rad(1.5),objectDamagePercent=1, -- =0≡= config. raycast de disparo =≡0= --
                    texture="throwable/grenade",
                    pos="grenade", -- first - second
                    fireRate=.05,fireTime=0, prepared = true,
                    func=function(weapon)end,
                    parts={
                        pts = {},
                    },
                    props = {
                        lever = {
                            ox = 12,
                            oy = 12,
                        }
                    },
                    autoFire=false,
                    maxBullets=999,
                    bullets=999,
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
                                        owner = ent,
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
                        prepairing = {
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
                                        owner = ent,
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
                                    ent.magazine.actual = "first"
                                end, value = 0},
                            },
                            [14] = {
                                time = .45,
                                {part = "hand", side = "L", prop = "ly", value = 41},
                                {part = "hand", side = "R", prop = "ly", value = 55},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = rad(-80)},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = false},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "inHand", side = "L", prop = "img", value = "none"},
                            },
                        },
                    },
                }
