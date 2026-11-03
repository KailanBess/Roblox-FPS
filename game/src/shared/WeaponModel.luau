local Workshop = require(script.Parent.Workshop)
local Voxels = require(script.Parent.VoxelWeapons)
local Models = {}
local function newPart(model,name,size,position,color,material)
    local item = Instance.new("Part")
    item.Name, item.Size, item.CFrame = name, size, CFrame.new(position)
    item.Color, item.Material = color, material or Enum.Material.Metal
    item.Anchored, item.CanCollide, item.CanTouch, item.CanQuery = true, false, false, false
    item.CastShadow = true
    item.TopSurface, item.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
    item.Parent = model
    return item
end
local function attachment(anchor,name,position)
    local a=Instance.new("Attachment")
    a.Name=name
    a.CFrame=CFrame.lookAt(position,position+Vector3.xAxis)
    a.Parent=anchor
end
function Models.build(weapon,cells)
    local model=Instance.new("Model")
    model.Name=weapon.id
    local muzzle, grip = Vector3.zero, Vector3.zero
    if cells then
        for _,cell in cells do
            local rgb=Workshop.Palette[cell.color]
            newPart(model,"Voxel",Vector3.new(.12,.12,.30),Vector3.new((cell.x-16)*.12,(8-cell.y)*.12,0),
                Color3.fromRGB(rgb[1],rgb[2],rgb[3]),Enum.Material.SmoothPlastic)
        end
    elseif weapon.class=="Knife" then
        newPart(model,"Grip",Vector3.new(.75,.23,.27),Vector3.new(-.5,0,0),Color3.fromRGB(25,29,34))
        newPart(model,"Guard",Vector3.new(.12,.65,.38),Vector3.new(-.05,0,0),Color3.fromRGB(85,95,109))
        newPart(model,"Blade",Vector3.new(1.3,.30,.08),Vector3.new(.65,.02,0),Color3.fromRGB(151,166,180))
        newPart(model,"Edge",Vector3.new(1.2,.08,.045),Vector3.new(.65,-.17,0),Color3.fromRGB(222,230,237))
        muzzle,grip=Vector3.new(1.3,0,0),Vector3.new(-.5,0,0)
    else
        local data=Voxels.generate(weapon)
        local scale=Voxels.CellSize
        model:SetAttribute("VoxelFamily",data.family)
        model:SetAttribute("VoxelCount",data.voxelCount)
        for _,run in data.runs do
            local rgb=Voxels.Palette[run.color]
            local material=if run.color=="Glass" then Enum.Material.Glass
                elseif run.color=="Polymer" or run.color=="Dark" or run.color=="Rubber" then Enum.Material.SmoothPlastic
                elseif run.color=="Wood" or run.color=="WoodLight" then Enum.Material.Wood
                else Enum.Material.Metal
            local p=newPart(model,run.role,Vector3.new((run.x2-run.x1+1)*scale,(run.y2-run.y1+1)*scale,(run.z2-run.z1+1)*scale),
                Vector3.new((run.x1+run.x2)/2*scale,(run.y1+run.y2)/2*scale,(run.z1+run.z2)/2*scale),
                Color3.fromRGB(rgb[1],rgb[2],rgb[3]),material)
            p:SetAttribute("WeaponComponent",run.role)
        end
        muzzle=Vector3.new(data.muzzle.x,data.muzzle.y,data.muzzle.z)*scale
        grip=Vector3.new(data.grip.x,data.grip.y,data.grip.z)*scale
    end
    local anchor=newPart(model,"Anchor",Vector3.new(.05,.05,.05),Vector3.zero,Color3.new(0,0,0))
    anchor.Transparency=1
    model.PrimaryPart=anchor
    attachment(anchor,"Muzzle",muzzle)
    attachment(anchor,"RightHandGrip",grip)
    model:SetAttribute("WeaponId",weapon.id)
    return model
end
-- Call on the server for world replication. build() returns an anchored display model.
function Models.mount(model,basePart,offset)
    assert(model.PrimaryPart,"Model requires a PrimaryPart")
    model:PivotTo(basePart.CFrame*(offset or CFrame.identity))
    for _,item in model:GetDescendants() do
        if item:IsA("BasePart") then
            item.Anchored=false
            item.Massless=true
            local weld=Instance.new("WeldConstraint")
            weld.Part0=basePart
            weld.Part1=item
            weld.Parent=item
        end
    end
end
return Models
