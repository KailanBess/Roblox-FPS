local Workshop = require(script.Parent.Workshop)
local Models = {}
local dark = Color3.fromRGB(24, 28, 35)
local steel = Color3.fromRGB(78, 89, 104)
local silver = Color3.fromRGB(151, 166, 180)
local colors = {
    ["Assault Rifle"] = Color3.fromRGB(180, 127, 60), SMG = Color3.fromRGB(38, 164, 164),
    Shotgun = Color3.fromRGB(167, 66, 39), Sniper = Color3.fromRGB(65, 113, 67),
    Pistol = Color3.fromRGB(120, 83, 151), LMG = Color3.fromRGB(160, 149, 61),
    Marksman = Color3.fromRGB(62, 116, 159), Knife = silver,
}
function Models.build(weapon, cells)
    local model = Instance.new("Model")
    model.Name = weapon.id
    local function part(name, size, position, color, material, rotation)
        local item = Instance.new("Part")
        item.Name = name
        item.Size = size
        item.CFrame = CFrame.new(position) * (rotation or CFrame.identity)
        item.Color = color
        item.Material = material or Enum.Material.Metal
        item.Anchored = true
        item.CanCollide = false
        item.CanTouch = false
        item.CanQuery = false
        item.CastShadow = true
        item.TopSurface = Enum.SurfaceType.Smooth
        item.BottomSurface = Enum.SurfaceType.Smooth
        item.Parent = model
        return item
    end
    -- Local +X points down the barrel. Camera transforms are handled by the client.
    if cells then
        for _, cell in cells do
            local rgb = Workshop.Palette[cell.color]
            part("Voxel", Vector3.new(.12, .12, .30), Vector3.new((cell.x-16)*.12, (8-cell.y)*.12, 0),
                Color3.fromRGB(rgb[1], rgb[2], rgb[3]), Enum.Material.SmoothPlastic)
        end
    else
        local accent = colors[weapon.class]
        if weapon.class == "Knife" then
            part("Grip", Vector3.new(.75,.23,.27), Vector3.new(-.5,0,0), dark)
            part("Guard", Vector3.new(.12,.65,.38), Vector3.new(-.05,0,0), accent)
            part("Blade", Vector3.new(1.3,.30,.08), Vector3.new(.65,.02,0), silver)
            part("Edge", Vector3.new(1.2,.08,.045), Vector3.new(.65,-.17,0), Color3.fromRGB(222,230,237))
        else
            local pistol = weapon.class == "Pistol"
            local length = if pistol then 1.2 elseif weapon.class == "Sniper" then 2.7 else 2
            part("Receiver", Vector3.new(length,.48,.42), Vector3.zero, dark)
            part("UpperShroud", Vector3.new(length-.10,.24,.46), Vector3.new(0,.30,0), accent)
            for _, side in {-1,1} do
                part("InsetPanel", Vector3.new(length*.65,.18,.035), Vector3.new(-.12,.03,side*.225), steel)
                part("HighlightRail", Vector3.new(length-.22,.045,.04), Vector3.new(0,.44,side*.18), silver)
                for i=1,4 do
                    part("CoolingVent", Vector3.new(.13,.10,.035), Vector3.new(length*.25-i*.19,.30,side*.24), dark)
                end
                for _, x in {-.5,.4} do
                    part("Fastener", Vector3.new(.055,.055,.025), Vector3.new(x,.07,side*.25), silver)
                end
            end
            local barrelLength = if pistol then .48 elseif weapon.class == "Sniper" then 2 else 1.05
            part("Barrel", Vector3.new(barrelLength,.17,.17), Vector3.new(length/2+barrelLength/2,0,0), steel)
            part("Muzzle", Vector3.new(.22,.26,.26), Vector3.new(length/2+barrelLength,0,0), dark)
            part("Bore", Vector3.new(.015,.12,.12), Vector3.new(length/2+barrelLength+.116,0,0), Color3.new(0,0,0))
            part("Grip", Vector3.new(.32,.75,.34), Vector3.new(-.45,-.5,0), dark, Enum.Material.SmoothPlastic, CFrame.Angles(0,0,-.18))
            part("TriggerGuard", Vector3.new(.55,.07,.16), Vector3.new(-.05,-.47,0), steel)
            part("Trigger", Vector3.new(.07,.25,.07), Vector3.new(-.06,-.29,0), silver)
            if not pistol then
                part("Magazine", Vector3.new(.45,if weapon.class == "LMG" then .7 else .85,.37), Vector3.new(.26,-.61,0), steel)
                part("Stock", Vector3.new(.8,.4,.36), Vector3.new(-length/2-.4,-.08,0), accent)
                part("ButtPad", Vector3.new(.13,.55,.45), Vector3.new(-length/2-.85,-.08,0), dark, Enum.Material.SmoothPlastic)
            end
            if weapon.zoom > 1 then
                part("ScopeMount", Vector3.new(.6,.18,.28), Vector3.new(-.1,.52,0), dark)
                part("Scope", Vector3.new(.95,.30,.30), Vector3.new(-.1,.74,0), steel)
                part("ScopeLens", Vector3.new(.025,.24,.24), Vector3.new(.39,.74,0), Color3.fromRGB(49,202,214), Enum.Material.Glass)
            else
                part("FrontSight", Vector3.new(.12,.17,.14), Vector3.new(length/2-.14,.51,0), dark)
            end
        end
    end
    local anchor = part("Anchor", Vector3.new(.05,.05,.05), Vector3.zero, dark)
    anchor.Transparency = 1
    model.PrimaryPart = anchor
    return model
end
return Models
