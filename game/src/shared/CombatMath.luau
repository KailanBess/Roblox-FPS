local Combat = {}
Combat.MaxHealth = 200
Combat.MaxArmor = 150
Combat.StudsPerMeter = 3.571
function Combat.finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end
function Combat.reloadSeconds(weapon)
    return 120 / weapon.reloadRating
end
function Combat.damage(weapon, armor, headshot, distance)
    local reduction = math.clamp(armor - weapon.penetration, 0, Combat.MaxArmor) / Combat.MaxArmor * 0.3
    local range = weapon.range * Combat.StudsPerMeter
    local falloff = 1 - math.clamp((distance - range) / range, 0, 1) * 0.5
    local multiplier = if headshot then (if weapon.class == "Sniper" then 2 else 1.5) else 1
    return weapon.damage * multiplier * (1 - reduction) * falloff
end
function Combat.ttk(damage, rpm)
    return (math.ceil(Combat.MaxHealth / damage) - 1) * 60 / rpm
end
return table.freeze(Combat)
