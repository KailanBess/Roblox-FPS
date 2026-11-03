-- Combat templates and creator tools are free. Purchases may change identity only.
local Policy={
    AllCombatTemplatesFree=true,
    WorkshopToolsFree=true,
    PaidStatModifiersAllowed=false,
    CosmeticCategories=table.freeze({WeaponAppearance=true,ArmorAppearance=true,
        PetAppearance=true,ProfileAppearance=true,CreatorAppearance=true}),
}
-- Contract for future purchase grants. No purchase pipeline exists in this build.
-- Strict keys prevent hiding combat modifiers alongside a cosmetic grant.
function Policy.validCosmeticGrant(grant)
    if type(grant)~="table" or not Policy.CosmeticCategories[grant.category]
        or type(grant.itemId)~="string" or #grant.itemId<1 or #grant.itemId>100 then return false end
    for key in grant do if key~="category" and key~="itemId" then return false end end
    return true
end
return table.freeze(Policy)
