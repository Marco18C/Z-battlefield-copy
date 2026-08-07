return {
    offsetX=250,offsetY=300,damage=95,    -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
    HandOffX=610,HandOffY=0,size=.12,     -- =0≡= cambiar ubicación intena del arma =≡0= --
    mode="semi",  -- auto - burst - semi  -- =O=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=≡=O= --
    shootOffsetX=0,shootOffsetY=0,shootMaxDistance=2200,shootSpread=rad(.5),objectDamagePercent=0.1, -- =0≡= config. raycast de disparo =≡0= --
    texture="guns/test_sniper_rifle", pos="first", -- first
    fireRate=.05,fireTime=0, prepared = true,
    func=function(weapon)end,
    parts={
        pts = {
            [1] = {
                info = {offX = 20, offY = 11, offS = .015}
            },
            [2] = {
                info = {offX = 19, offY = 0, offS = .04}
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
    maxBullets=5,
    bullets=5,
    anims={
        actual = "idle",
        idle = {
            loop = false,
            [1] = {
                time = .05,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 52},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "none"},
            },
        },
        shooting = {
            loop = false,
            [1] = {
                time = .025,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 52},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "none"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.bullets = math.max(0, weapon.bullets - 1)
                    weapon.prepared = false

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
                time = 1,
                {part = "hand", side = "L", prop = "ly", value = 75},
                {part = "hand", side = "R", prop = "ly", value = 48},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "none"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    ent.anims.actual = "prepairing"
                end, value = 0},
            },
            [3] = {
                time = .09,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 1},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = true},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.parts.pts[1].info.offX = 7
                end, value = 0},
            },
        },
        reload = {
            loop = false,
            [1] = {
                time = .45,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 52},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = true},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.parts.pts[1].info.offX = 11
                    weapon.prepared = false
                end, value = 0},

                {part = "inHand", side = "L", prop = "img", value = "none"},
            },
            [2] = {
                time = .14,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 74},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 1},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.parts.pts[1].info.offX = 10
                end, value = 0},
            },
            [3] = {
                time = .4,
                {part = "hand", side = "L", prop = "ly", value = 69},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 1},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = true},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [4] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [5] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [6] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [7] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [8] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [9] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [10] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [11] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [12] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [13] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [14] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [15] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [16] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [17] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [18] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [19] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [20] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [21] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [22] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [23] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [24] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [25] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [26] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 73},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(20)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "ammo"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    if weapon.bullets >= weapon.maxBullets then
                        ent.anims.actual = "prepairing"
                    else
                        weapon.bullets = weapon.bullets + 1
                    end
                end, value = 0},
            },
            [27] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 77},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(10)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 2},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
        },
        prepairing = {
            loop = false,
            [1] = {
                time = .075,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 1},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = true},
                {part = "hand", side = "R", prop = "handSteps", value = false},

                {part = "inHand", side = "L", prop = "img", value = "none"},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.parts.pts[1].info.offX = 7
                    weapon.prepared = false
                    if weapon.bullets >= 1 then
                        soldierScripts.propz.shoot(ent.parts.RIGHTforearm.arm.hand.x,
                                                ent.parts.RIGHTforearm.arm.hand.y,
                                                ent.parts.RIGHTforearm.arm.hand.rx + rad(55), {
                            owner = ent,
                            speed = 750,
                            accel = -1800,            -- aceleración en dirección del movimiento
                            w = 6, h = 6, s = .025,   -- tamaño de colisión del proyectil
                            texture = "bullet_carc",      -- nombre en prop.textures
                            lifetime = 1,
                            piercing = false,       -- si sigue tras impactar (según onHit)

                            onHit = "bounce",

                            -- para onHit = "damage"
                            damage = 0,
                            damageRadius = 0,       -- 0 = solo golpea al objeto; >0 = daño en área

                            -- para onHit = "bounce"
                            bounceDamage = 0,
                            bounceRestitution = 1.1,  -- 1 = rebote perfecto, <1 pierde energía
                            maxBounces = 10,

                            onHitFunc = function(proyectil, objeto) return true end,
                        })
                    end
                end, value = 0},
            },
            [2] = {
                time = .11,
                {part = "hand", side = "L", prop = "ly", value = 65},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},
            },
            [3] = {
                time = .1,
                {part = "hand", side = "L", prop = "ly", value = 74},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "handSteps", value = true},

                {part = "weapon", side = "func", prop = function(weapon, ent)
                    weapon.parts.pts[1].info.offX = 20
                    weapon.prepared = true
                end, value = 0},
            },
            [4] = {
                time = .2,
                {part = "hand", side = "L", prop = "ly", value = 74},
                {part = "hand", side = "R", prop = "ly", value = 69},

                {part = "hand", side = "L", prop = "ro", value = rad(15)},
                {part = "hand", side = "R", prop = "ro", value = 0},

                {part = "hand", side = "L", prop = "ry", value = 1},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "hand", side = "L", prop = "handSteps", value = false},
                {part = "hand", side = "R", prop = "handSteps", value = false},
            },
            [5] = {
                time = .02,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 52},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "inHand", side = "L", prop = "img", value = "none"},
            },
            [6] = {
                time = .04,
                {part = "hand", side = "L", prop = "ly", value = 79},
                {part = "hand", side = "R", prop = "ly", value = 52},

                {part = "hand", side = "L", prop = "ro", value = rad(9)},
                {part = "hand", side = "R", prop = "ro", value = rad(10)},

                {part = "hand", side = "L", prop = "ry", value = 5},
                {part = "hand", side = "R", prop = "ry", value = 3},

                {part = "inHand", side = "L", prop = "img", value = "none"},
            },
        },
    },
}