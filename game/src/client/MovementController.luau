local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local VR=game:GetService("VRService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("FPS")
local Tuning=require(Shared.Movement)
local Geometry=require(Shared.LeanGeometry)
local Catalog=require(Shared.WeaponCatalog)
local Controller={}
function Controller.start(action,callbacks)
    local player=Players.LocalPlayer
    local controls=require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
    local focused=true
    local movement,lean=Vector3.zero,0
    local request,aiming,lastSend,lastLean,lastAim=0,false,-math.huge,nil,nil
    local previousCamera,previousTransform
    local pendingRecoil=0
    local currentCharacter
    local poses=setmetatable({},{__mode="k"})
    local function release() callbacks.reset() end
    Input.WindowFocusReleased:Connect(function() focused=false;release() end)
    Input.WindowFocused:Connect(function() focused=true end)
    Input.TextBoxFocused:Connect(release)
    player.CharacterAdded:Connect(function() movement=Vector3.zero;lean=0;release() end)
    local function send()
        local now=os.clock()
        if now-lastSend<Tuning.RequestInterval then return end
        if request~=lastLean or aiming~=lastAim or now-lastSend>=.25 then
            lastSend,lastLean,lastAim=now,request,aiming
            action:FireServer("Movement",{lean=request,ads=aiming})
        end
    end
    RunService:BindToRenderStep("FPSMovement",Enum.RenderPriority.Input.Value+1,function(dt)
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local active=focused and callbacks.active() and not Input:GetFocusedTextBox()
            and hum and hum.Health>0 and not hum.Sit and workspace.CurrentCamera.CameraType==Enum.CameraType.Custom
        if char~=currentCharacter then currentCharacter=char;movement=Vector3.zero;lean=0;release() end
        if not active then release() end
        local target=if active then controls:GetMoveVector() else Vector3.zero
        if target.Magnitude>1 then target=target.Unit end
        local response=if target.Magnitude<.01 then Tuning.InputBraking else Tuning.InputAcceleration
        movement=movement:Lerp(target,Tuning.alpha(response,dt))
        if movement.Magnitude<.001 then movement=Vector3.zero end
        if hum then
            hum:Move(movement,true)
            if not active then hum.Jump=false end
        end
        request=Tuning.availableLean(callbacks.lean(),
            hum~=nil and hum.FloorMaterial~=Enum.Material.Air,
            active==true and hum:GetState()~=Enum.HumanoidStateType.Swimming)
        aiming=active==true and callbacks.aiming() and callbacks.weapon().zoom>1
        lean=Tuning.approach(lean,request,Tuning.LeanResponse,dt)
        if hum then
            local speed=Tuning.walkSpeed(callbacks.weapon().move,aiming,lean)
            hum.WalkSpeed=Tuning.approach(hum.WalkSpeed,speed,Tuning.SpeedResponse,dt)
        end
        send()
    end)
    -- Remove our own last camera transform before Roblox's camera update. This
    -- prevents accumulated roll/drift and also clears it when a menu opens.
    RunService:BindToRenderStep("FPSLeanRestore",Enum.RenderPriority.Camera.Value-1,function()
        if previousCamera and previousTransform then
            previousCamera.CFrame*=previousTransform:Inverse()
        end
        previousCamera,previousTransform=nil,nil
        if pendingRecoil~=0 and callbacks.active() and not VR.VREnabled then
            workspace.CurrentCamera.CFrame*=CFrame.Angles(pendingRecoil,0,0)
        end
        pendingRecoil=0
    end)
    RunService:BindToRenderStep("FPSLeanCamera",Enum.RenderPriority.Camera.Value+1,function(dt)
        local cam=workspace.CurrentCamera
        local char=player.Character
        local head=char and char:FindFirstChild("Head")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if callbacks.active() and head and root and hum and hum.Health>0 and cam.CameraType==Enum.CameraType.Custom then
            local origin,allowed=Geometry.resolve(char,head,root,lean)
            local base=cam.CFrame
            local result=CFrame.new(base.Position+origin-head.Position)*base.Rotation*CFrame.Angles(0,0,if VR.VREnabled then 0 else -allowed*Tuning.LeanAngle)
            previousCamera,previousTransform=cam,base:ToObjectSpace(result)
            cam.CFrame=result
        end
        -- Remote torso pose is visual. Server-owned LeanHead provides exposed
        -- head hit detection; the local rig stays centered for a stable camera.
        for _,other in Players:GetPlayers() do
            local model=other.Character
            if other==player or not model then continue end
            local joint=model:FindFirstChild("Waist",true) or model:FindFirstChild("RootJoint",true)
            if not joint or not joint:IsA("Motor6D") then continue end
            local pose=poses[joint]
            if not pose then pose={base=joint.C0,value=0};poses[joint]=pose end
            pose.value=Tuning.approach(pose.value,model:GetAttribute("Lean") or 0,Tuning.LeanResponse,dt)
            joint.C0=CFrame.new(pose.base.Position+Vector3.new(pose.value*.45,0,0))
                *CFrame.Angles(0,0,-pose.value*Tuning.LeanAngle)*pose.base.Rotation
        end
    end)
    return {send=send,recoil=function(angle) pendingRecoil+=angle end}
end
return Controller
