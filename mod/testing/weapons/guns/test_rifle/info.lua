return {
                    offsetX=450,offsetY=300,damage=10,    -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    HandOffX=610,HandOffY=0,size=.08,     -- =0≡= cambiar ubicación intena del arma =≡0= --
                    mode="auto",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
                    shootOffsetX=50,shootOffsetY=0,shootMaxDistance=2200,shootSpread=rad(1.5),objectDamagePercent=0.1, -- =0≡= config. raycast de disparo =≡0= --
                    texture="guns/test_rifle", pos="first", -- first - second
                    fireRate=.05,fireTime=0, prepared = true,
                    func=function(weapon)end,
                    parts={
                        pts = {
                            [1] = {
                                info = {offX = 20, offY = -28, offS = .025}
                            },
                            [2] = {
                                info = {offX = 18, offY = 18.5, offS = .08}
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

                                {part = "hand", side = "L", prop = "handSteps", value = true},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[2].info.offS = .04
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
                                    if weapon.prepared then
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
                                    else
                                        ent.anims.actual = "prepairing"
                                    end
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
                                        owner = ent,
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
                                    weapon.prepared = false
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

                                {part = "weapon", side = "func", prop=function(weapon, ent)
                                    weapon.prepared = false
                                    weapon.parts.pts[2].info.offS = .04
                                    weapon.bullets = weapon.maxBullets
                                    ent.anims.actual = "prepairing"
                                end, value = 0},
                            },
                            [6] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},
                            },
                        },
                        prepairing = {
                            loop = false,
                            [1] = {
                                time = .1,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 1},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "handSteps", value = true},

                                {part = "inHand", side = "L", prop = "img", value = "none"},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.prepared = false
                                end, value = 0},
                            },
                            [2] = {
                                time = .25,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 2},
                                {part = "hand", side = "R", prop = "ry", value = 3},

                                {part = "hand", side = "L", prop = "ry", value = 1},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 7
                                end, value = 0},
                            },
                            [3] = {
                                time = .2,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},
                            },
                            [4] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 74},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(-20)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "handSteps", value = true},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 20
                                    weapon.prepared = true
                                end, value = 0},
                            },
                            [5] = {
                                time = .025,
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
                }
