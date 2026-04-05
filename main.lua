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
rad = math.rad
deg = math.deg
sin = math.sin
cos = math.cos
function math.sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

---------------------------------------------------------
-- SOLDIERS DATA (tu mismo)
---------------------------------------------------------
soldiers = {
    {
        actualChunk = {
            {x=100,y=300,w=80,h=120,rx=0,ry=0},
            {x=100,y=330,w=80,h=120,rx=0,ry=0},
            {x=130,y=300,w=80,h=120,rx=0,ry=0},
            {x=250,y=350,w=80,h=120,rx=0,ry=0},
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
            RIGHThand = love.graphics.newImage("textures/soldiers/usa/base/rightHand.png"),
            RIGHTforeleg = love.graphics.newImage("textures/soldiers/usa/base/rigthForeleg.png"),
            RIGHTleg = love.graphics.newImage("textures/soldiers/usa/base/rigthLeg.png"),
            RIGHTfoot = love.graphics.newImage("textures/soldiers/usa/base/rigthFoot.png"),
            LEFTforearm = love.graphics.newImage("textures/soldiers/usa/base/leftForearm.png"),
            LEFTarm = love.graphics.newImage("textures/soldiers/usa/base/leftArm.png"),
            LEFThand = love.graphics.newImage("textures/soldiers/usa/base/leftHand.png"),
            LEFTforeleg = love.graphics.newImage("textures/soldiers/usa/base/leftForeleg.png"),
            LEFTleg = love.graphics.newImage("textures/soldiers/usa/base/leftLeg.png"),
            LEFTfoot = love.graphics.newImage("textures/soldiers/usa/base/leftFoot.png"),
        },
        parts = {
            dir = -1,
            torso = {
                x = 400, y = 300, w = 30, h = 20, rx = 0, ry = 0,
                shouldR = {x=0,y=-30}, shouldL= {x=0,y=30},
                hipR    = {x=-10,y=20}, hipL  = {x=10,y=20},
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
                        x=440, y=300, w=30, h=20, rx=0, ly=59,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            offsetX=100,offsetY=300,damage=35,
                            HandOffX=20,HandOffY=0,size=.04,
                            img=love.graphics.newImage("textures/weapons/guns/test_pistol/base.png")
                        }
                    }
                }
            },

            LEFTforearm = {
                x = 100, y = 100, w = 30, h = 20, ro = -45, rx = 0, ry = 0, long = 40,
                arm = {
                    dist=7, x=100, y=100, w=30, h=20, ro=-45, rx=0, ry=0, long=40,
                    hand = { -- mano izquierda
                        x=320, y=300, w=30, h=20, rx=0, ly=69,
                        _lastSafe = {
                            x=nil,
                            y=nil,
                            rx=nil,
                            ly=nil
                        },
                        inHand = {
                            offsetX=320,offsetY=404,damage=35,
                            HandOffX=20,HandOffY=0,size=.115,
                            img=love.graphics.newImage("textures/weapons/guns/test_pistol/base.png")
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
    }
}

---------------------------------------------------------
function love.load()

    soldierScripts = {
        update = require("src.soldier_update"),
        draw   = require("src.soldier_draw"),
        -- anims  = require("soldiersScript.anims"),
    }

    -- worldScripts = {
    --     terrain = require("ScriptsWorld.terrain")
    -- }
end

function love.resize(w, h)
    WindowsSIZE = (w / 1280)
    win.w = w
    win.h = h
end

function love.update(dt)

    for _,body in ipairs(soldiers) do
        -- soldierScripts.anims(body, dt)
        soldierScripts.update(body, dt)
    end
    collectgarbage("collect")
end

function love.draw()
    soldierScripts.draw()
    -- worldScripts.terrain(soldiers)
end