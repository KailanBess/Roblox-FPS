local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local GuiService=game:GetService("GuiService")
local VR=game:GetService("VRService")
local State=require(game:GetService("ReplicatedStorage"):WaitForChild("FPS").ControlState)
local Router={}
function Router.start(callbacks)
    local leanState=State.new()
    local actions={}
    local api={}
    function api.reset()
        State.clear(leanState)
        callbacks.fire(false)
        callbacks.aim(false)
    end
    function api.lean() return State.lean(leanState) end
    function api.gamepad() return string.find(UIS:GetLastInputType().Name,"Gamepad")~=nil end
    function api.hint()
        if VR.VREnabled then return "Head aim • trigger fire • grip aim • X reload • Y armory" end
        if api.gamepad() then return "RT fire • LT aim • X reload • LB/RB lean • Y armory • B back" end
        if UIS:GetLastInputType()==Enum.UserInputType.Touch then return "Touch fire / aim / reload • tap lean L/R • Armory" end
        return "LMB fire • RMB scope • R reload • Q/E lean • M armory"
    end
    function api.refresh()
        for name,position in actions do
            local button=CAS:GetButton(name)
            if button then
                button.Visible=UIS.TouchEnabled and not api.gamepad() and not VR.VREnabled
                    and (name=="FPSArmory" or callbacks.active())
                button.Parent=callbacks.controlsParent
                button.AnchorPoint=Vector2.new(.5,.5)
                button.Position=position
                button.Size=UDim2.fromOffset(60,60)
                button.ZIndex=10
            end
        end
        if api.gamepad() and callbacks.menuOpen() and not GuiService.SelectedObject then callbacks.focusMenu() end
    end
    local function bind(name,title,position,keys,handler)
        actions[name]=position
        CAS:BindAction(name,function(_,state,input)
            if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
            if state==Enum.UserInputState.Cancel then api.reset();return Enum.ContextActionResult.Sink end
            if name~="FPSArmory" and name~="FPSBack" and not callbacks.active() then
                return Enum.ContextActionResult.Pass
            end
            handler(state,input)
            return Enum.ContextActionResult.Sink
        end,true,table.unpack(keys))
        CAS:SetTitle(name,title)
        CAS:SetPosition(name,position)
    end
    bind("FPSFire","FIRE",UDim2.fromScale(.88,.59),{Enum.UserInputType.MouseButton1,Enum.KeyCode.ButtonR2},function(state)
        if state==Enum.UserInputState.Begin then callbacks.fire(true)
        elseif state==Enum.UserInputState.End then callbacks.fire(false) end
    end)
    bind("FPSAim","AIM",UDim2.fromScale(.75,.45),{Enum.UserInputType.MouseButton2,Enum.KeyCode.ButtonL2},function(state,input)
        if input.UserInputType==Enum.UserInputType.Touch then
            if state==Enum.UserInputState.Begin then callbacks.aim(not callbacks.aiming()) end
        elseif state==Enum.UserInputState.Begin then callbacks.aim(true)
        elseif state==Enum.UserInputState.End then callbacks.aim(false) end
    end)
    bind("FPSReload","RELOAD",UDim2.fromScale(.88,.38),{Enum.KeyCode.R,Enum.KeyCode.ButtonX},function(state)
        if state==Enum.UserInputState.Begin then callbacks.reload() end
    end)
    for _,side in {-1,1} do
        bind(if side<0 then "FPSLeanLeft" else "FPSLeanRight",if side<0 then "LEAN L" else "LEAN R",
            UDim2.fromScale(if side<0 then .64 else .75,.68),
            if side<0 then {Enum.KeyCode.Q,Enum.KeyCode.ButtonL1,Enum.KeyCode.DPadLeft}
                else {Enum.KeyCode.E,Enum.KeyCode.ButtonR1,Enum.KeyCode.DPadRight},function(state,input)
            State.setLean(leanState,side,state==Enum.UserInputState.Begin,input.UserInputType==Enum.UserInputType.Touch)
        end)
    end
    bind("FPSArmory","ARMORY",UDim2.fromScale(.05,.13),{Enum.KeyCode.M,Enum.KeyCode.ButtonY},function(state)
        if state==Enum.UserInputState.Begin then api.reset();callbacks.menu(not callbacks.menuOpen());api.refresh() end
    end)
    CAS:BindAction("FPSBack",function(_,state)
        if not callbacks.menuOpen() then return Enum.ContextActionResult.Pass end
        if state==Enum.UserInputState.Begin then callbacks.menu(false);api.refresh() end
        return Enum.ContextActionResult.Sink
    end,false,Enum.KeyCode.ButtonB)
    UIS.WindowFocusReleased:Connect(api.reset)
    UIS.TextBoxFocused:Connect(api.reset)
    local function mode(inputType) return State.mode(inputType.Name) end
    local currentMode=mode(UIS:GetLastInputType())
    UIS.LastInputTypeChanged:Connect(function(inputType)
        local nextMode=mode(inputType)
        if nextMode~=currentMode then api.reset();currentMode=nextMode end
        api.refresh()
    end)
    UIS.GamepadDisconnected:Connect(function() api.reset();api.refresh() end)
    GuiService.MenuOpened:Connect(api.reset)
    api.refresh()
    task.defer(api.refresh)
    return api
end
return Router
