local function lerp(a,b,t)
    return a + (b-a)*t
end

local function resolveTarget(ent, cmd)

    if cmd.part == "weapon" then
        return ent.magazine, cmd.prop
    end

    if cmd.part == "hand" then
        if cmd.side == "R" then
            return ent.parts.RIGHTforearm.arm.hand, cmd.prop
        else
            return ent.parts.LEFTforearm.arm.hand, cmd.prop
        end
    end

    if cmd.part == "foot" then
        if cmd.side == "R" then
            return ent.parts.RIGHTforeleg.leg.foot, cmd.prop
        else
            return ent.parts.LEFTforeleg.leg.foot, cmd.prop
        end
    end

    if cmd.part == "inHand" then
        if cmd.side == "R" then
            return ent.parts.RIGHTforearm.arm.hand.inHand, cmd.prop
        else
            return ent.parts.LEFTforearm.arm.hand.inHand, cmd.prop
        end
    end

end

local function findCommand(frame, cmdA)
    for i = 1, #frame do
        local cmd = frame[i]

        if type(cmd) == "table"
        and cmd.part == cmdA.part
        and cmd.side == cmdA.side
        and cmd.prop == cmdA.prop then
            return cmd
        end
    end

    return cmdA
end

return function(ent, dt)

    local animName = ent.anims.actual
    local anim = ent.magazine[ent.magazine.actual].anims[animName]
    if not anim then return end

    local loop = anim.loop ~= false -- default: true

    -- detectar cambio de animacón --
    if ent._lastAnim ~= animName then
        ent._lastAnim = animName
        ent._animFrame = 1
        ent._animTime = 0
    end

    ent._animFrame = ent._animFrame or 1
    ent._animTime  = ent._animTime or 0

    local frameIndex = ent._animFrame
    local frameA = anim[frameIndex]
    if not frameA then return end

    local nextIndex = frameIndex + 1
    local frameB

    if nextIndex > #anim then
        if loop then
            nextIndex = 1
            frameB = anim[nextIndex]
        else
            frameB = frameA -- CLAVE y no es peru, no cambiar
        end
    else
        frameB = anim[nextIndex]
    end

    local duration = frameA.time or 0.25

    ent._animTime = ent._animTime + dt
    local t = ent._animTime / duration
    if t > 1 then t = 1 end

    for i=1,#frameA do

        local cmdA = frameA[i]
        local cmdB = findCommand(frameB, cmdA)

        if type(cmdA) == "table" then
                local target, prop = resolveTarget(ent, cmdA)

            if target and prop then

                local a = cmdA.value
                local b = cmdB.value

                if b == nil then
                    b = a
                end

                if type(a)=="number" and type(b)=="number" then
                    target[prop] = lerp(a,b,t)
                elseif t>=1 then
                    target[prop] = b
                end

            end

        end

    end

    while ent._animTime >= duration do

        -- 🔥 DISPARAR EVENTOS DEL FRAME QUE TERMINA
        for i=1,#frameA do
            local cmd = frameA[i]
            if type(cmd) == "table" then

                if cmd.part == "weapon" and cmd.side == "func" then
                    if type(cmd.prop) == "function" then
                        local weapon = ent.magazine[ent.magazine.actual]
                        cmd.prop(weapon, ent)
                    end
                end
            end
        end

        if frameIndex + 1 > #anim then
            if loop then
                ent._animFrame = 1
            else
                ent.anims.actual = "idle"
                return
            end
        else
            ent._animFrame = frameIndex + 1
        end

        frameIndex = ent._animFrame

        ent._animTime = ent._animTime - duration
    end

end