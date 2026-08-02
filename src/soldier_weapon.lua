local w = {}
local unit

function w.load()
    for _, soldier in ipairs(soldiers) do
        if soldier.player then
            unit = soldier
            return
        end
    end
end

function w.mousepressed(key)
    if unit.player then----------------------------------------<=>

        if key == 1 then
            local weapon = unit.magazine[unit.magazine.actual]
            if weapon then
                if weapon.bullets > 0 and unit.anims.actual ~= "shooting" then
                    if weapon.mode == "auto" then
                        weapon.autoFire = true

                    elseif weapon.mode == "semi" then
                        unit.anims.actual = "shooting"

                    end

                else
                    unit.anims.actual = "reload"

                end

            end

        elseif key == 4 then
            unit.magazine.actual = "first"
        elseif key == 5 then
            unit.magazine.actual = "second"
        elseif key == 3 then
            unit.magazine.actual = "grenade"
        end

    end

end

function w.mousereleased(key)
    if unit.player then

        local weapon = unit.magazine[unit.magazine.actual]
        if key == 1 then
            weapon.autoFire = false

        end

    end

end

function w.updateWeapons(unit, dt)
    local weapon = unit.magazine[unit.magazine.actual]

    weapon.fireTime = math.max(0, weapon.fireTime - dt)

    if weapon.autoFire then
        if weapon.fireTime <= 0 then
            if weapon.bullets < 1 then
                unit.anims.actual = "reload"
            elseif unit.anims.actual ~= "shooting" then
                weapon.fireTime = weapon.fireRate
                unit.anims.actual = "shooting"
            end

        end

    end

end

return w