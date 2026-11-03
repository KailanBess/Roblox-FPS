-- Optional Studio asset generator. Run from the EDIT-mode Command Bar after syncing.
local Catalog=require(script.Parent.WeaponCatalog)
local Models=require(script.Parent.WeaponModel)
local Gallery={}
function Gallery.build(parent,origin,ids)
    local folder=Instance.new("Folder")
    folder.Name="VoxelWeaponGallery"
    local index=0
    for _,id in ids or Catalog.Order do
        local weapon=Catalog.ById[id]
        assert(weapon,"Unknown weapon "..tostring(id))
        if weapon.class~="Knife" then
            local model=Models.build(weapon)
            model:PivotTo((origin or CFrame.identity)*CFrame.new(index%5*12,0,math.floor(index/5)*7))
            model.Parent=folder
            index+=1
        end
    end
    folder.Parent=parent or workspace
    return folder
end
return Gallery
