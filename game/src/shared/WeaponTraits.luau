-- One modest class trait per weapon. Named weapons retain their own base stats.
-- Traits never multiply damage, RPM, armor penetration, or movement speed.
local Traits = {}
local function profile(title,description,overrides)
    local values={title=title,description=description,recovery=1,equip=1,reload=1,
        scopedSpread=1,recoil=1,stationarySpread=1}
    for key,value in overrides do values[key]=value end
    return table.freeze(values)
end
Traits.ByClass=table.freeze({
    ["Assault Rifle"]=profile("Controlled bursts","+6% bloom recovery",{recovery=1.06}),
    SMG=profile("Ready handling","6% shorter equip time",{equip=.94}),
    Shotgun=profile("Quick chambering","5% shorter magazine reload",{reload=.95}),
    Sniper=profile("Stable optics","6% less scoped base spread",{scopedSpread=.94}),
    Pistol=profile("Quick draw","8% shorter equip time",{equip=.92}),
    LMG=profile("Braced fire","6% less spread while grounded and stationary",{stationarySpread=.94}),
    Marksman=profile("Follow-up control","6% less scoped camera kick",{recoil=.94}),
    Knife=profile("Ready blade","8% shorter equip time",{equip=.92}),
})
function Traits.forWeapon(weapon)
    assert(Traits.ByClass[weapon.class],"Unknown weapon class")
    return Traits.ByClass[weapon.class]
end
function Traits.equipSeconds(weapon)
    return .4*Traits.forWeapon(weapon).equip
end
return table.freeze(Traits)
