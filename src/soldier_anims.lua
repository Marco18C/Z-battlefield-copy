local function lerp(a,b,t)
    return a + (b-a)*t
end

local function resolveTarget(ent, cmd)

    if cmd.part == "dir" then
        return ent.parts, "dir"
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

end

return function(ent, dt)

    local animName = ent.anims.actual
    local anim = ent.anims[animName]
    if not anim then return end

    -- detectar cambio de animación --
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
    if nextIndex > #anim then nextIndex = 1 end
    local frameB = anim[nextIndex]

    local duration = frameA.time or 0.25

    ent._animTime = ent._animTime + dt
    local t = ent._animTime / duration
    if t > 1 then t = 1 end

    for i=1,#frameA do

        local cmdA = frameA[i]
        local cmdB = frameB[i] or cmdA

        if type(cmdA) == "table" then

            local target, prop = resolveTarget(ent, cmdA)

            if target and prop then

                local a = cmdA.value
                local b = cmdB.value or a

                if type(a)=="number" and type(b)=="number" then

                    target[prop] = lerp(a,b,t)

                elseif t>=1 then

                    target[prop] = b

                end

            end

        end

    end

    while ent._animTime >= duration do
        ent._animTime = ent._animTime - duration
        ent._animFrame = nextIndex
    end
end