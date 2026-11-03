-- Creates a practice range only in an otherwise empty place. Existing maps are preserved.
local Lighting = game:GetService("Lighting")
if workspace:FindFirstChild("FPSPracticeRange") or workspace:FindFirstChildWhichIsA("SpawnLocation", true) then return end
local range = Instance.new("Model")
range.Name = "FPSPracticeRange"
range.Parent = workspace
local function block(name, size, position, color)
    local p = Instance.new("Part")
    p.Name, p.Size, p.Position, p.Color = name, size, position, color
    p.Anchored = true
    p.Material = Enum.Material.Concrete
    p.Parent = range
    return p
end
block("Floor",Vector3.new(160,1,220),Vector3.new(0,-.5,-65),Color3.fromRGB(56,65,78))
for _, x in {-80,80} do block("Wall",Vector3.new(2,18,220),Vector3.new(x,8,-65),Color3.fromRGB(34,44,58)) end
block("Backstop",Vector3.new(160,18,2),Vector3.new(0,8,-175),Color3.fromRGB(34,44,58))
local spawn = Instance.new("SpawnLocation")
spawn.Size, spawn.Position = Vector3.new(8,1,8), Vector3.new(0,.5,25)
spawn.Anchored, spawn.Neutral, spawn.Duration = true, true, 3
spawn.Parent = range
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.GlobalShadows = true
Lighting.Ambient = Color3.fromRGB(80,88,105)
Lighting.OutdoorAmbient = Color3.fromRGB(130,140,160)
local function dummy(x, z)
    local model = Instance.new("Model")
    model.Name = "Practice Target"
    local root = block("HumanoidRootPart",Vector3.new(2,2,1),Vector3.new(x,3,z),Color3.fromRGB(40,47,59))
    root.Transparency = 1
    root.Parent = model
    local torso = block("Torso",Vector3.new(3,3,1.5),Vector3.new(x,3,z),Color3.fromRGB(225,156,47))
    torso.Parent = model
    local head = block("Head",Vector3.new(1.5,1.5,1.5),Vector3.new(x,5.25,z),Color3.fromRGB(230,216,179))
    head.Parent = model
    local humanoid = Instance.new("Humanoid")
    humanoid.RequiresNeck = false
    humanoid.MaxHealth, humanoid.Health = 200, 200
    humanoid.Parent = model
    model:SetAttribute("Armor",75)
    model.PrimaryPart = root
    model.Parent = range
    humanoid.Died:Connect(function()
        task.delay(3,function() model:Destroy(); dummy(x,z) end)
    end)
end
for i=1,5 do dummy((i-3)*12,-20-i*12) end
