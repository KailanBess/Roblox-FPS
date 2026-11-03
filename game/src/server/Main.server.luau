local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("FPS")
local Catalog = require(Shared.WeaponCatalog)
local Combat = require(Shared.CombatMath)
local Workshop = require(Shared.Workshop)
local MovementService = require(script.Parent.MovementService)
local network = Instance.new("Folder")
network.Name = "Network"
network.Parent = Shared
local function remote(name)
    local event = Instance.new("RemoteEvent")
    event.Name = name
    event.Parent = network
    return event
end
local action, state, effect = remote("Action"), remote("State"), remote("Effect")
local sessions = {}
MovementService.start(sessions)
local random = Random.new()
local function sync(player, message, includeDesign)
    local s = sessions[player]
    if s then state:FireClient(player, {weapon = s.weapon, ammo = s.ammo,
        reloading = s.reloadEnd > os.clock(), cells = if includeDesign then s.cells else nil,
        designChanged = includeDesign == true, message = message}) end
end
local function alive(player)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local head = char and char:FindFirstChild("Head")
    if humanoid and head and humanoid.Health > 0 then return char, humanoid, head end
    return nil
end
local function setupPlayer(player)
    sessions[player] = {weapon = "M4A1", ammo = Catalog.ById.M4A1.magazine,
        lastShot = -math.huge, reloadEnd = 0, nextEquip = 0, nextWorkshop = 0,
        tokens = 60, tokenTime = os.clock(), bloom = 0, cells = nil}
    local function spawnCharacter(char)
        local hum = char:WaitForChild("Humanoid")
        local s = sessions[player]
        if not s or player.Character ~= char then return end
        hum.MaxHealth = Combat.MaxHealth
        hum.Health = Combat.MaxHealth
        MovementService.configure(player,char,hum)
        char:SetAttribute("Armor", Combat.MaxArmor)
        s.ammo = Catalog.ById[s.weapon].magazine
        s.reloadEnd = 0
        s.lastShot = os.clock()
        s.bloom = 0
        sync(player)
    end
    player.CharacterAdded:Connect(spawnCharacter)
    if player.Character then task.spawn(spawnCharacter, player.Character) end
end
Players.PlayerAdded:Connect(setupPlayer)
for _, player in Players:GetPlayers() do setupPlayer(player) end
Players.PlayerRemoving:Connect(function(player) sessions[player] = nil end)
action.OnServerEvent:Connect(function(player, kind, payload)
    local s = sessions[player]
    if not s then return end
    local now = os.clock()
    s.tokens = math.min(60, s.tokens + (now-s.tokenTime)*30)
    s.tokenTime = now
    if s.tokens < 1 then return end
    s.tokens -= 1
    if kind == "Sync" then sync(player, nil, true); return end
    local char, hum, head = alive(player)
    if not char then return end
    local weapon = Catalog.ById[s.weapon]
    if kind == "Movement" then
        MovementService.request(player,payload)
    elseif kind == "Equip" then
        if type(payload) ~= "string" or not Catalog.ById[payload] or now < s.nextEquip then return end
        -- Sandbox roster is unlocked. Production ownership belongs in a server inventory service.
        s.nextEquip = now + .4
        s.weapon = payload
        -- Re-equipping cannot refill ammunition: a new weapon starts empty and must reload.
        s.ammo = 0
        s.reloadEnd = 0
        s.lastShot = now
        s.bloom = 0
        s.aiming = false
        sync(player, "Equipped — reload to load magazine")
    elseif kind == "Workshop" then
        if now < s.nextWorkshop then return end
        s.nextWorkshop = now + 2
        local cells, err = Workshop.validate(payload)
        if not cells then sync(player, err); return end
        s.cells = cells
        sync(player, "Session design applied; combat stats unchanged", true)
    elseif kind == "ClearDesign" then
        s.cells = nil
        sync(player, "System model restored", true)
    elseif kind == "Reload" then
        if weapon.class == "Knife" or s.reloadEnd > now or s.ammo >= weapon.magazine then return end
        local deadline = now + Combat.reloadSeconds(weapon)
        s.reloadEnd = deadline
        local id, character = s.weapon, char
        sync(player)
        task.delay(Combat.reloadSeconds(weapon), function()
            if sessions[player] == s and player.Character == character and s.weapon == id and s.reloadEnd == deadline then
                s.reloadEnd = 0
                s.ammo = weapon.magazine
                sync(player)
            end
        end)
    elseif kind == "Fire" then
        if type(payload) ~= "table" or typeof(payload.direction) ~= "Vector3" then return end
        local direction = payload.direction
        if not Combat.finite(direction.X) or not Combat.finite(direction.Y) or not Combat.finite(direction.Z)
            or math.abs(direction.Magnitude-1) > .01 then return end
        if not Combat.finite(payload.timestamp) or math.abs(workspace:GetServerTimeNow()-payload.timestamp) > 2 then return end
        if now-s.lastShot < 60/weapon.rpm or s.reloadEnd > now or now < s.nextEquip then return end
        local melee = weapon.class == "Knife"
        if not melee and s.ammo < 1 then sync(player, "Reload required"); return end
        local origin = MovementService.origin(player)
        if not origin then return end
        s.bloom = math.max(0, s.bloom-(now-s.lastShot)*3)
        s.lastShot = now
        if not melee then s.ammo -= 1 end
        local scoped = weapon.zoom > 1 and s.aiming == true and payload.ads == true
        local spread = if scoped then .0015 else (100-weapon.accuracy)*.0006 + s.bloom*.002
        if hum.MoveDirection.Magnitude > .1 then spread += .008 end
        if hum.FloorMaterial == Enum.Material.Air then spread += .025 end
        s.bloom = math.min(s.bloom+.6, 4)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        local range = weapon.range * Combat.StudsPerMeter * (if melee then 1 else 2)
        local pellets = if weapon.class == "Shotgun" then 8 else 1
        local totalDamage, killed, anyHeadshot = 0, false, false
        for _ = 1, pellets do
            local basis = CFrame.lookAt(Vector3.zero, direction)
            local radius = math.sqrt(random:NextNumber()) * spread
            local theta = random:NextNumber(0, math.pi*2)
            local rayDirection = (direction + basis.RightVector*math.cos(theta)*radius + basis.UpVector*math.sin(theta)*radius).Unit
            local result = workspace:Raycast(origin, rayDirection*range, params)
            local endpoint = if result then result.Position else origin + rayDirection*range
            if not melee then effect:FireAllClients(origin, endpoint) end
            if result then
                local target = result.Instance:FindFirstAncestorOfClass("Model")
                local targetHum = target and target:FindFirstChildOfClass("Humanoid")
                local targetPlayer = target and Players:GetPlayerFromCharacter(target)
                local teammate = targetPlayer and player.Team ~= nil and targetPlayer.Team == player.Team
                if targetHum and targetHum.Health > 0 and not teammate and not target:FindFirstChildOfClass("ForceField") then
                    local headshot = result.Instance.Name == "Head" or result.Instance:GetAttribute("Headshot") == true
                    local armor = target:GetAttribute("Armor") or 0
                    if not Combat.finite(armor) then armor = 0 end
                    local damage = Combat.damage(weapon, math.clamp(armor,0,150), headshot, result.Distance) / pellets
                    local before = targetHum.Health
                    targetHum:TakeDamage(damage)
                    totalDamage += math.min(before, damage)
                    anyHeadshot = anyHeadshot or headshot
                    killed = killed or targetHum.Health <= 0
                end
            end
        end
        sync(player)
        if totalDamage > 0 then
            state:FireClient(player, {hit = totalDamage, headshot = anyHeadshot, killed = killed})
        end
    end
end)
