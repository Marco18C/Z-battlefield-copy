return {
                    offsetX=10,offsetY=304,damage=35,
                    HandOffX=20,HandOffY=0,size=.035,
                    shootOffsetX=40,shootOffsetY=0,shootMaxDistance=1400,shootSpread=rad(0.5),objectDamagePercent=0.3,
                    mode="semi", -- auto - burst - semi
                    texture="guns/test_pistol",
                    pos="second", -- first - second
                    fireRate=.5,fireTime=0,prepared = true,
                    parts={
                        pts = {
                            [1] = {
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
                                    weapon.prepared = false
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

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    ent.anims.actual = "prepairing"
                                    weapon.prepared = false
                                end, value = 0},
                            },
                            [6] = {
                                time = .3,
                                {part = "hand", side = "L", prop = "ly", value = 29},
                                {part = "hand", side = "R", prop = "ly", value = 69},

                                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                                {part = "hand", side = "R", prop = "ro", value = 0},
                            },
                        },
                        prepairing = {
                            loop = false,
                            [1] = {
                                time = .1,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(5)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},

                                {part = "hand", side = "L", prop = "handSteps", value = true},
                                {part = "hand", side = "R", prop = "handSteps", value = false},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = -15
                                    weapon.prepared = false
                                end, value = 0},
                            },
                            [2] = {
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
                            [3] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 61},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(5)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},
                            },
                            [4] = {
                                time = .05,
                                {part = "hand", side = "L", prop = "ly", value = 79},
                                {part = "hand", side = "R", prop = "ly", value = 79},

                                {part = "hand", side = "L", prop = "ro", value = rad(37)},
                                {part = "hand", side = "R", prop = "ro", value = 0},

                                {part = "hand", side = "L", prop = "ry", value = 4},

                                {part = "weapon", side = "func", prop = function(weapon, ent)
                                    weapon.parts.pts[1].info.offX = 0
                                    weapon.prepared = true
                                end, value = 0},
                            },
                        },
                    },
                }
