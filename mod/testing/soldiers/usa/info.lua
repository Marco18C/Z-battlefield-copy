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
            magazine = { actual = "first" },
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