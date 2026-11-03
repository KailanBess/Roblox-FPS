-- Server calls this only after validating weapon selection and equip timing.
local Magazines={}
function Magazines.equip(state,nextWeapon)
    state.magazines[state.weapon]=state.ammo
    state.weapon=nextWeapon
    state.ammo=state.magazines[nextWeapon] or 0
end
return table.freeze(Magazines)
