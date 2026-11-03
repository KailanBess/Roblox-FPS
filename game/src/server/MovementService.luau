local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("FPS")
local Tuning=require(Shared.Movement)
local Geometry=require(Shared.LeanGeometry)
local Catalog=require(Shared.WeaponCatalog)
local Service={}
local sessions
function Service.configure(player,character,humanoid)
    local s=sessions[player]
    s.lean,s.leanRequest,s.aiming,s.lastMovement,s.poseTimer=0,0,false,0,0
    s.allowedLean=0
    humanoid.WalkSpeed=Tuning.walkSpeed(Catalog.ById[s.weapon].move,false,0)
    humanoid.UseJumpPower=false
    humanoid.JumpHeight=Tuning.JumpHeight
    humanoid.AutoJumpEnabled=false
    character:SetAttribute("Lean",0)
    local proxy=Instance.new("Part")
    proxy.Name="LeanHead"
    proxy.Transparency=1
    proxy.Anchored=true
    proxy.CanCollide=false
    proxy.CanTouch=false
    proxy.CanQuery=false
    proxy:SetAttribute("Headshot",true)
    proxy.Parent=character
    s.leanHead=proxy
end
function Service.request(player,payload)
    if not Tuning.validRequest(payload) then return end
    local s=sessions[player]
    local now=os.clock()
    if now-(s.lastMovement or 0)<Tuning.RequestInterval*.8 then return end
    s.lastMovement=now
    s.leanRequest=payload.lean
    s.aiming=payload.ads and Catalog.ById[s.weapon].zoom>1
end
function Service.origin(player)
    local s=sessions[player]
    local char=player.Character
    local head=char and char:FindFirstChild("Head")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return nil end
    local origin,allowed,overlapping=Geometry.resolve(char,head,root,s.lean or 0)
    if s.leanHead and s.leanHead.Parent==char then
        s.leanHead.Size=head.Size
        s.leanHead.CFrame=CFrame.new(origin)*head.CFrame.Rotation
        s.leanHead.CanQuery=not overlapping and math.abs(allowed)>.05
    end
    s.allowedLean=allowed
    return if overlapping then nil else origin
end
function Service.start(playerSessions)
    sessions=playerSessions
    RunService.Heartbeat:Connect(function(dt)
        for player,s in sessions do
            local char=player.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not hum then continue end
            local active=hum.Health>0 and os.clock()-(s.lastMovement or 0)<Tuning.RequestTimeout
                and not hum.Sit and hum:GetState()~=Enum.HumanoidStateType.Swimming
            local request=Tuning.availableLean(s.leanRequest or 0,hum.FloorMaterial~=Enum.Material.Air,active)
            s.lean=Tuning.approach(s.lean or 0,request,Tuning.LeanResponse,dt)
            if not active then s.aiming=false end
            Service.origin(player)
            local speed=Tuning.walkSpeed(Catalog.ById[s.weapon].move,s.aiming,s.allowedLean or 0)
            hum.WalkSpeed=Tuning.approach(hum.WalkSpeed,speed,Tuning.SpeedResponse,dt)
            s.poseTimer=(s.poseTimer or 0)+dt
            if s.poseTimer>=.1 then
                s.poseTimer=0
                char:SetAttribute("Lean",if hum.Health>0 then s.allowedLean or 0 else 0)
            end
            if hum.Health<=0 and s.leanHead then s.leanHead.CanQuery=false end
        end
    end)
end
return Service
