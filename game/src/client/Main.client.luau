local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local shared = ReplicatedStorage:WaitForChild("FPS")
local Catalog = require(shared.WeaponCatalog)
local Combat = require(shared.CombatMath)
local Workshop = require(shared.Workshop)
local Models = require(shared.WeaponModel)
local MovementController = require(script.Parent.MovementController)
local network = shared:WaitForChild("Network")
local action, state, effect = network:WaitForChild("Action"), network:WaitForChild("State"), network:WaitForChild("Effect")
local weapon, ammo, reloading, savedCells = Catalog.ById.M4A1, 30, false, nil
local firing, ads, lastShot = false, false, -math.huge
local menuOpen = true
local viewmodel
local movementController
local gui = Instance.new("ScreenGui")
gui.Name = "FPSInterface"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local function element(class, parent, props)
    local object = Instance.new(class)
    for key, value in props do object[key] = value end
    object.Parent = parent
    return object
end
local function label(parent, text, pos, size)
    return element("TextLabel",parent,{Text=text, Position=pos, Size=size, BackgroundTransparency=1,
        TextColor3=Color3.fromRGB(233,237,244), Font=Enum.Font.Gotham, TextSize=16, TextWrapped=true})
end
local function button(parent, text, pos, size, callback)
    local b = element("TextButton",parent,{Text=text, Position=pos, Size=size,
        BackgroundColor3=Color3.fromRGB(43,57,77), TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.GothamBold, TextSize=14, BorderSizePixel=0})
    element("UICorner",b,{CornerRadius=UDim.new(0,5)})
    b.Activated:Connect(callback)
    return b
end
local hud = label(gui,"",UDim2.fromScale(.25,.89),UDim2.fromScale(.5,.09))
local notice = label(gui,"",UDim2.fromScale(.2,.79),UDim2.fromScale(.6,.06))
local hitMarker = label(gui,"",UDim2.fromScale(.45,.44),UDim2.fromScale(.1,.12))
local crosshair = label(gui,"+",UDim2.fromScale(.475,.475),UDim2.fromScale(.05,.05))
crosshair.TextSize = 24
local panel = element("Frame",gui,{Size=UDim2.fromScale(.94,.84),Position=UDim2.fromScale(.03,.05),
    BackgroundColor3=Color3.fromRGB(17,23,34),BorderSizePixel=0})
element("UICorner",panel,{CornerRadius=UDim.new(0,10)})
label(panel,"FPS // ARMORY & CUSTOM WORKSHOP",UDim2.fromScale(.02,.01),UDim2.fromScale(.75,.06)).TextXAlignment=Enum.TextXAlignment.Left
local armory = element("Frame",panel,{BackgroundTransparency=1,Position=UDim2.fromScale(.02,.16),Size=UDim2.fromScale(.96,.81)})
local editor = element("Frame",panel,{BackgroundTransparency=1,Position=UDim2.fromScale(.02,.16),Size=UDim2.fromScale(.96,.81),Visible=false})
local function rebuildViewmodel()
    if viewmodel then viewmodel:Destroy() end
    viewmodel = Models.build(weapon,savedCells)
    viewmodel.Parent = workspace.CurrentCamera
end
local function setMenu(open)
    menuOpen = open
    panel.Visible = open
    firing, ads = false, false
    player.CameraMode = if open then Enum.CameraMode.Classic else Enum.CameraMode.LockFirstPerson
    Input.MouseBehavior = if open then Enum.MouseBehavior.Default else Enum.MouseBehavior.LockCenter
    Input.MouseIconEnabled = open
    if viewmodel then viewmodel.Parent = if open then nil else workspace.CurrentCamera end
end
button(panel,"ARMORY",UDim2.fromScale(.02,.085),UDim2.fromScale(.18,.06),function() armory.Visible=true; editor.Visible=false end)
button(panel,"CUSTOM WEAPONS",UDim2.fromScale(.21,.085),UDim2.fromScale(.25,.06),function() armory.Visible=false; editor.Visible=true end)
button(panel,"PLAY / CLOSE [M]",UDim2.fromScale(.71,.085),UDim2.fromScale(.27,.06),function() setMenu(false) end)
local list = element("ScrollingFrame",armory,{Size=UDim2.fromScale(.31,1),BackgroundTransparency=1,
    BorderSizePixel=0,ScrollBarThickness=5,CanvasSize=UDim2.new(0,0,0,#Catalog.Order*42)})
local preview = element("ViewportFrame",armory,{Position=UDim2.fromScale(.34,.02),Size=UDim2.fromScale(.65,.64),
    BackgroundColor3=Color3.fromRGB(28,38,52),Ambient=Color3.fromRGB(145,156,180),
    LightColor=Color3.fromRGB(255,238,211),LightDirection=Vector3.new(-1,-1,-1)})
local camera = Instance.new("Camera")
camera.CFrame = CFrame.lookAt(Vector3.new(1.8,1.6,6.3),Vector3.zero)
camera.Parent = preview
preview.CurrentCamera = camera
local world = Instance.new("WorldModel")
world.Parent = preview
local stats = label(armory,"",UDim2.fromScale(.34,.68),UDim2.fromScale(.65,.19))
local selected = weapon
local function selectWeapon(id)
    selected = Catalog.ById[id]
    world:ClearAllChildren()
    Models.build(selected).Parent = world
    stats.Text = string.format("%s / %s\nDMG %d   RPM %d   MAG %d   RANGE %sm\n%d coins • sandbox unlocked • %s",
        selected.id,selected.class,selected.damage,selected.rpm,selected.magazine,tostring(selected.range),selected.price,
        if selected.zoom>1 then tostring(selected.zoom).."x scope" else "hipfire / no recoil")
end
for i,id in Catalog.Order do
    button(list,id,UDim2.new(0,0,0,(i-1)*42),UDim2.new(1,-8,0,36),function() selectWeapon(id) end)
end
button(armory,"EQUIP SELECTED",UDim2.fromScale(.34,.9),UDim2.fromScale(.4,.08),function() action:FireServer("Equip",selected.id) end)
button(armory,"RESTORE SYSTEM MODEL",UDim2.fromScale(.75,.9),UDim2.fromScale(.24,.08),function() action:FireServer("ClearDesign") end)
selectWeapon(weapon.id)
-- A 32×16 side-profile editor, extruded into a voxel model. No copied image assets.
local design, cellButtons, history = {}, {}, {}
local paletteIndex, erasing, drawing, strokeSaved = 5, false, false, false
local grid = element("Frame",editor,{Position=UDim2.fromScale(0,.10),Size=UDim2.fromScale(.72,.70),BackgroundTransparency=1})
element("UIAspectRatioConstraint",grid,{AspectRatio=2,DominantAxis=Enum.DominantAxis.Width})
local function repaint()
    for id,b in cellButtons do
        local index = design[id]
        local rgb = index and Workshop.Palette[index]
        b.BackgroundColor3 = if rgb then Color3.fromRGB(rgb[1],rgb[2],rgb[3]) else Color3.fromRGB(35,65,86)
    end
end
local editorPreview = element("ViewportFrame",editor,{Position=UDim2.fromScale(.75,.10),Size=UDim2.fromScale(.25,.43),
    BackgroundColor3=Color3.fromRGB(28,38,52),Ambient=Color3.fromRGB(160,170,185),LightDirection=Vector3.new(-1,-1,-1)})
local editCamera = Instance.new("Camera")
editCamera.CFrame = CFrame.lookAt(Vector3.new(1.5,1,5),Vector3.zero)
editCamera.Parent=editorPreview
editorPreview.CurrentCamera=editCamera
local editWorld = Instance.new("WorldModel")
editWorld.Parent=editorPreview
-- Orbit either 3D preview without rotating the gameplay camera.
local function orbitPreview(viewport, previewCamera, container)
    viewport.Active=true
    previewCamera.FieldOfView=35
    local yaw,pitch,dragging,zoom=.25,.12,false,1
    local function update()
        local model=container:FindFirstChildOfClass("Model")
        if not model then return end
        local bounds,size=model:GetBoundingBox()
        local center=bounds.Position
        local direction=Vector3.new(math.sin(yaw)*math.cos(pitch),math.sin(pitch),math.cos(yaw)*math.cos(pitch))
        local orientation=CFrame.lookAt(center+direction,center)
        local aspect=math.max(viewport.AbsoluteSize.X,1)/math.max(viewport.AbsoluteSize.Y,1)
        local tanV=math.tan(math.rad(previewCamera.FieldOfView/2))
        local tanH=tanV*aspect
        local distance=.5
        -- Fit all eight corners in the current view, rather than using a fixed
        -- camera distance or a sphere that makes long, thin weapons look tiny.
        for _,x in {-1,1} do for _,y in {-1,1} do for _,z in {-1,1} do
            local corner=bounds:PointToWorldSpace(Vector3.new(x*size.X,y*size.Y,z*size.Z)/2)
            local localCorner=orientation:VectorToObjectSpace(corner-center)
            distance=math.max(distance,math.abs(localCorner.X)/tanH+localCorner.Z,
                math.abs(localCorner.Y)/tanV+localCorner.Z)
        end end end
        previewCamera.CFrame=CFrame.lookAt(center+direction*distance*1.12*zoom,center)
    end
    viewport.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
    end)
    Input.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    Input.InputChanged:Connect(function(input)
        if dragging and menuOpen and viewport.Visible and input.UserInputType==Enum.UserInputType.MouseMovement then
            yaw-=input.Delta.X*.012
            pitch=math.clamp(pitch+input.Delta.Y*.012,-1.2,1.2)
            update()
        end
    end)
    viewport.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseWheel then
            zoom=math.clamp(zoom-input.Position.Z*.1,.65,2.5)
            update()
        end
    end)
    container.ChildAdded:Connect(function() zoom=1; update() end)
    viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
    update()
end
orbitPreview(preview,camera,world)
orbitPreview(editorPreview,editCamera,editWorld)
label(preview,"Drag to rotate • scroll to zoom",UDim2.fromScale(0,.90),UDim2.fromScale(1,.10)).TextSize=12
local function serialize()
    local cells = {}
    for id,color in design do
        local x,y = string.match(id,"^(%d+):(%d+)$")
        table.insert(cells,{x=tonumber(x),y=tonumber(y),color=color})
    end
    return cells
end
local function updatePreview()
    editWorld:ClearAllChildren()
    Models.build(weapon,serialize()).Parent=editWorld
end
local function remember()
    if #history >= 30 then table.remove(history,1) end
    table.insert(history,table.clone(design))
end
local function paint(id)
    if not strokeSaved then remember(); strokeSaved=true end
    local count = 0
    for _ in design do count+=1 end
    if not erasing and not design[id] and count >= Workshop.MaxCells then
        notice.Text = "Maximum 384 voxels"; return
    end
    design[id] = if erasing then nil else paletteIndex
    repaint()
end
for y=1,Workshop.Height do
    for x=1,Workshop.Width do
        local id=x..":"..y
        local b=element("TextButton",grid,{Text="",Size=UDim2.new(1/32,-1,1/16,-1),
            Position=UDim2.fromScale((x-1)/32,(y-1)/16),BorderSizePixel=0,AutoButtonColor=false})
        cellButtons[id]=b
        b.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                drawing=true; strokeSaved=false; paint(id)
            end
        end)
        b.MouseEnter:Connect(function() if drawing then paint(id) end end)
    end
end
for i,rgb in Workshop.Palette do
    local b=button(editor,"",UDim2.fromScale((i-1)*.058,0),UDim2.fromScale(.05,.075),function()
        paletteIndex=i; erasing=false; notice.Text="Paint color "..i
    end)
    b.BackgroundColor3=Color3.fromRGB(rgb[1],rgb[2],rgb[3])
end
label(editor,"Paint a side profile • 384 voxel limit • cosmetic only\nPreview and apply to your current weapon. Session only; no publishing yet.",
    UDim2.fromScale(.75,.55),UDim2.fromScale(.25,.28))
button(editor,"ERASER",UDim2.fromScale(0,.86),UDim2.fromScale(.15,.09),function() erasing=not erasing; notice.Text=if erasing then "Eraser selected" else "Paint selected" end)
button(editor,"UNDO",UDim2.fromScale(.16,.86),UDim2.fromScale(.15,.09),function()
    if #history>0 then design=table.remove(history); repaint(); updatePreview() end
end)
button(editor,"CLEAR",UDim2.fromScale(.32,.86),UDim2.fromScale(.15,.09),function() remember(); design={}; repaint(); updatePreview() end)
button(editor,"APPLY DESIGN",UDim2.fromScale(.49,.86),UDim2.fromScale(.23,.09),function()
    local cells,err=Workshop.validate(serialize())
    if cells then action:FireServer("Workshop",cells) else notice.Text=err end
end)
repaint()
Input.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        if drawing then drawing=false; updatePreview() end
        firing=false
    elseif input.UserInputType==Enum.UserInputType.MouseButton2 then ads=false end
end)
local function fire()
    if menuOpen or Input:GetFocusedTextBox() then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 or reloading or (ammo<=0 and weapon.class~="Knife") then return end
    local now=os.clock()
    if now-lastShot<60/weapon.rpm then return end
    lastShot=now
    if movementController then movementController.send() end
    action:FireServer("Fire",{direction=workspace.CurrentCamera.CFrame.LookVector,
        timestamp=workspace:GetServerTimeNow(),ads=ads})
    if weapon.zoom>1 then
        if movementController then movementController.recoil(math.rad(.7)) end
    end
end
Input.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.M then setMenu(not menuOpen)
    elseif input.KeyCode==Enum.KeyCode.R and not menuOpen then action:FireServer("Reload")
    elseif input.UserInputType==Enum.UserInputType.MouseButton1 and not menuOpen then firing=true; fire()
    elseif input.UserInputType==Enum.UserInputType.MouseButton2 and not menuOpen and weapon.zoom>1 then ads=true end
end)
local hitGeneration=0
state.OnClientEvent:Connect(function(data)
    if data.weapon then
        local changed = weapon.id~=data.weapon or data.designChanged == true
        weapon=Catalog.ById[data.weapon]
        ammo,reloading=data.ammo,data.reloading
        if data.designChanged then savedCells=data.cells end
        if changed or not viewmodel then rebuildViewmodel() end
    end
    if data.message then notice.Text=data.message end
    if data.hit then
        hitGeneration+=1
        local generation=hitGeneration
        hitMarker.Text=string.format("%s\n%d",if data.killed then "ELIMINATED" else "×",math.floor(data.hit+.5))
        hitMarker.TextColor3=if data.headshot then Color3.fromRGB(255,190,67) else Color3.new(1,1,1)
        task.delay(.4,function() if hitGeneration==generation then hitMarker.Text="" end end)
    end
end)
effect.OnClientEvent:Connect(function(origin,endpoint)
    local distance=(endpoint-origin).Magnitude
    if distance<.01 then return end
    local tracer=Instance.new("Part")
    tracer.Name="BulletTracer"
    tracer.Anchored=true
    tracer.CanCollide=false
    tracer.CanTouch=false
    tracer.CanQuery=false
    tracer.Material=Enum.Material.Neon
    tracer.Color=Color3.fromRGB(255,218,132)
    tracer.Size=Vector3.new(.025,.025,distance)
    tracer.CFrame=CFrame.lookAt((origin+endpoint)/2,endpoint)
    tracer.Parent=workspace
    Debris:AddItem(tracer,.065)
end)
RunService:BindToRenderStep("FPSView",Enum.RenderPriority.Camera.Value+2,function(dt)
    local cam=workspace.CurrentCamera
    local targetFov=if ads and weapon.zoom>1 and not menuOpen then 70/weapon.zoom else 70
    cam.FieldOfView += (targetFov-cam.FieldOfView)*math.min(1,dt*15)
    crosshair.Visible=not menuOpen and not ads
    crosshair.TextSize=math.clamp((136-weapon.accuracy)*.5,18,55)
    if firing and weapon.automatic then fire() end
    if viewmodel then
        viewmodel.Parent=if menuOpen or ads then nil else cam
        if viewmodel.Parent then
            viewmodel:PivotTo(cam.CFrame*CFrame.new(.65,-.65,-1.9)*CFrame.Angles(0,math.pi/2,0))
        end
    end
    local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local hp=if hum then math.ceil(hum.Health) else 0
    hud.Text=string.format("HP %d / 200     %s     %s\nLMB fire • RMB scope • R reload • Q/E lean • M armory",hp,weapon.id,
        if reloading then "RELOADING" elseif weapon.class=="Knife" then "MELEE" else tostring(ammo).." / "..weapon.magazine)
end)
setMenu(true)
movementController=MovementController.start(action,{
    active=function() return not menuOpen end,
    aiming=function() return ads end,
    weapon=function() return weapon end,
})
action:FireServer("Sync")
