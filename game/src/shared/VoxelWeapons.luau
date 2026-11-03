-- Original stylized geometry, in integer voxel coordinates; +X is forward, +Y up.
-- Pure Luau data builder: usable by Roblox and offline validation/export tools.
local VoxelWeapons = {}
VoxelWeapons.CellSize = 0.085
VoxelWeapons.Palette = {
    Gunmetal = {69, 78, 91}, Dark = {30, 35, 42}, Steel = {122, 135, 150},
    Edge = {148, 160, 171}, Polymer = {38, 43, 46}, Wood = {131, 76, 40},
    WoodLight = {166, 103, 55}, Tan = {166, 148, 106}, Olive = {85, 100, 65},
    Glass = {59, 171, 187}, Brass = {186, 148, 65}, Bore = {9, 11, 15},
}
local profiles = {
    M4A1="AR", HK416="AR", ["SCAR-L"]="SCAR", ["AK-103"]="AK", FAMAS="Bullpup",
    MP5="MP5", MP7="Compact", UMP45="MP5", Vector="Vector", P90="P90",
    M870="Pump", M1014="Pump", ["SPAS-12"]="Pump", KSG="Bullpup", ["Super 90"]="Pump",
    M24="Bolt", AWM="AWM", R700="Bolt", L96="AWM", Scout="Bolt",
    M9="Pistol", ["Glock 17"]="Glock", USP45="Glock", P226="Pistol", ["Five-Seven"]="Glock",
    M249="LMG", PKM="LMG", RPK="AK", MG36="LMG", ["Stoner 63"]="LMG",
    ["MK14 EBR"]="DMR", ["SR-25"]="DMR", G28="DMR", M110="DMR", SVD="SVD",
}
VoxelWeapons.Profiles = table.freeze(profiles)
function VoxelWeapons.generate(weapon)
    local family = profiles[weapon.id]
    assert(family, "No voxel firearm profile for " .. tostring(weapon.id))
    local cells = {}
    local function put(x,y,z,color,role)
        cells[x..":"..y..":"..z]={x=x,y=y,z=z,color=color,role=role}
    end
    local function box(x1,x2,y1,y2,z1,z2,color,role)
        for x=x1,x2 do for y=y1,y2 do for z=z1,z2 do put(x,y,z,color,role) end end end
    end
    local function tube(x1,x2,y0,radius,color,role,hollow)
        for x=x1,x2 do for y=-radius,radius do for z=-radius,radius do
            local d=y*y+z*z
            if d<=radius*radius+.5 and (not hollow or d>=(radius-1)*(radius-1)) then
                put(x,y+y0,z,color,role)
            end
        end end end
    end
    local function grip(x,y,color)
        for step=0,7 do
            box(x-math.floor(step/4),x+2-math.floor(step/4),y-step,y-step,-2,2,
                if step%3==0 then "Dark" else color,"Grip")
        end
    end
    local function magazine(x,y,length,curved)
        for step=0,length do
            local offset=if curved then math.floor(step*step/55) else 0
            box(x+offset,x+4+offset,y-step,y-step,-2,2,
                if step%4==0 then "Dark" else "Gunmetal","Magazine")
        end
    end
    local function stock(x1,x2,color)
        box(x1,x2,-1,2,-2,2,color,"Stock")
        box(x1,x1+1,-4,3,-3,3,"Dark","ButtPad")
        box(x1+2,x2-1,3,3,-2,2,"Polymer","CheekRest")
    end
    local function scope(x,y)
        box(x-4,x+4,y,y+1,-1,1,"Dark","ScopeMount")
        tube(x-6,x+6,y+4,2,"Dark","Scope")
        tube(x-7,x-5,y+4,3,"Gunmetal","Ocular",true)
        tube(x+5,x+8,y+4,3,"Gunmetal","Objective",true)
        box(x+7,x+7,y+3,y+5,-1,1,"Glass","Lens")
        box(x-1,x+1,y+6,y+7,-1,1,"Steel","ElevationTurret")
        box(x-1,x+1,y+3,y+5,3,4,"Steel","WindageTurret")
    end
    local function sights(rear,front,y)
        box(rear,rear+1,y,y+2,-2,-1,"Steel","RearSight")
        box(rear,rear+1,y,y+2,1,2,"Steel","RearSight")
        box(front,front+1,y,y+3,0,0,"Dark","FrontSight")
    end
    local muzzleX, muzzleY = 29,1
    local gripX,gripY = -6,-5
    local finish = if family=="SCAR" then "Tan" elseif family=="AWM" then "Olive" else "Gunmetal"
    if family=="Pistol" or family=="Glock" then
        box(-8,9,0,3,-2,2,"Gunmetal","Slide")
        box(-7,7,-2,-1,-2,2,"Polymer","Frame")
        grip(-6,-3,if family=="Pistol" then "Wood" else "Polymer")
        -- Open trigger guard rather than a filled rectangle.
        box(-2,4,-7,-7,-1,1,"Dark","TriggerGuard")
        box(4,4,-6,-2,-1,1,"Dark","TriggerGuard")
        box(0,0,-4,-2,0,0,"Steel","Trigger")
        tube(8,10,1,1,"Steel","Barrel",true)
        for x=-7,-3 do
            if x%2==0 then box(x,x,0,2,-3,-3,"Dark","SlideSerration"); box(x,x,0,2,3,3,"Dark","SlideSerration") end
        end
        if family=="Pistol" then box(-1,6,3,3,-1,1,"Steel","ExposedBarrel") end
        sights(-7,7,4)
        muzzleX,muzzleY=11,1
        gripX,gripY=-6,-6
    elseif family=="Pump" then
        box(-10,3,-2,3,-2,2,"Gunmetal","Receiver")
        tube(4,33,2,1,"Steel","Barrel",true)
        tube(3,27,-2,1,"Gunmetal","MagazineTube")
        local wood=if weapon.id=="M870" then "Wood" else "Polymer"
        stock(-25,-11,wood)
        for step=0,5 do box(-12-step,-9-step,-2-step,-2-step,-2,2,wood,"Grip") end
        box(8,19,-3,0,-3,3,wood,"Pump")
        for x=9,18,3 do box(x,x,-3,0,-4,4,"Dark","PumpRib") end
        box(-8,-1,-7,-7,-1,1,"Dark","TriggerGuard")
        box(0,0,-6,-2,-1,1,"Dark","TriggerGuard")
        box(-4,-4,-5,-2,0,0,"Steel","Trigger")
        sights(-7,30,4)
        muzzleX,muzzleY=34,2
        gripX,gripY=-14,-5
    elseif family=="Bolt" or family=="AWM" then
        stock(-27,-9,if family=="AWM" then "Olive" else "Tan")
        box(-10,18,-2,0,-3,3,if family=="AWM" then "Olive" else "Tan","Chassis")
        box(-8,6,1,3,-2,2,"Gunmetal","Receiver")
        tube(7,38,2,1,"Steel","Barrel",true)
        grip(-8,-2,"Polymer")
        magazine(0,-3,5,false)
        box(-5,-1,-7,-7,-1,1,"Dark","TriggerGuard")
        box(-1,-1,-6,-3,-1,1,"Dark","TriggerGuard")
        box(-4,-4,-5,-2,0,0,"Steel","Trigger")
        box(-5,-4,1,2,3,5,"Steel","BoltHandle")
        box(-5,-3,-1,1,5,6,"Dark","BoltKnob")
        box(29,37,1,3,-2,2,"Dark","MuzzleBrake")
        tube(38,38,2,1,"Steel","Muzzle",true)
        scope(-1,4)
        muzzleX,muzzleY=39,2
        gripX,gripY=-8,-6
    else
        local bullpup=family=="Bullpup" or family=="P90"
        local compact=family=="Compact" or family=="Vector" or family=="MP5" or family=="P90"
        local endX=if compact then 12 else 20
        box(-8,7,-1,3,-3,3,finish,"Receiver")
        box(8,endX,-1,3,-2,2,if family=="AK" then "Wood" else finish,"Handguard")
        tube(endX+1,endX+8,1,1,"Steel","Barrel",true)
        tube(endX+7,endX+9,1,2,"Dark","FlashHider",true)
        muzzleX=endX+10
        gripX=if bullpup then 3 else -6
        grip(gripX,-2,"Polymer")
        if family=="P90" then
            box(-18,9,4,5,-3,3,"Olive","TopMagazine")
            box(-20,-9,-4,3,-3,3,"Polymer","IntegratedStock")
            box(-8,3,-7,-6,-2,2,"Polymer","ThumbholeBase")
            box(5,9,-4,0,-3,3,"Polymer","Foregrip")
        elseif family=="Vector" then
            stock(-23,-10,"Polymer")
            box(-7,0,-8,0,-3,3,"Tan","RecoilHousing")
            magazine(2,-3,12,false)
        elseif family=="LMG" then
            stock(-24,-9,"Polymer")
            box(-1,7,-10,-2,-4,4,"Olive","AmmoBox")
            box(-7,5,4,5,-3,3,"Gunmetal","FeedCover")
            for x=0,6,2 do box(x,x,1,2,4,6,"Brass","BeltRound") end
            for _,z in {-4,4} do box(16,17,-8,-2,z,z,"Steel","Bipod") end
        elseif bullpup then
            stock(-23,-9,"Polymer")
            magazine(-14,-3,9,false)
            box(-12,10,6,6,-1,1,"Dark","CarryHandle")
            box(-12,-11,4,5,-1,1,"Dark","HandleSupport")
            box(9,10,4,5,-1,1,"Dark","HandleSupport")
        else
            stock(-25,-9,if family=="AK" or family=="SVD" then "Wood" else "Polymer")
            magazine(0,-2,if family=="DMR" then 7 else 11,family=="AK" or family=="MP5" or family=="SVD")
        end
        if family=="AK" or family=="SVD" then
            tube(8,endX+4,4,1,"Gunmetal","GasTube")
            box(-8,6,4,4,-2,2,"Dark","DustCover")
            box(-5,-4,0,1,4,6,"Steel","ChargingHandle")
        end
        local triggerX=gripX+4
        box(triggerX-2,triggerX+3,-7,-7,-1,1,"Dark","TriggerGuard")
        box(triggerX+3,triggerX+3,-6,-2,-1,1,"Dark","TriggerGuard")
        box(triggerX,triggerX,-4,-2,0,0,"Steel","Trigger")
        if weapon.zoom>1 then scope(-1,5) else sights(-7,endX-1,5) end
        if family=="AR" then
            box(-7,2,6,6,-1,1,"Dark","CarryHandle")
            box(-7,-6,4,5,-1,1,"Dark","HandleSupport")
            box(1,2,4,5,-1,1,"Dark","HandleSupport")
        end
        for x=9,endX-1,3 do
            for _,z in {-3,3} do box(x,x,0,1,z,z,"Dark","CoolingVent") end
        end
    end
    -- A three-dimensional ejection port on the right side, inset with a metallic lip.
    box(-3,2,1,2,3,3,"Dark","EjectionPort")
    box(-3,2,3,3,3,3,"Edge","PortLip")
    -- Merge neighboring same-material cells along X. Voxel silhouette is preserved,
    -- while hidden internal cube faces and thousands of individual Instances are avoided.
    local ordered={}
    for _,cell in cells do table.insert(ordered,cell) end
    table.sort(ordered,function(a,b)
        if a.z~=b.z then return a.z<b.z end
        if a.y~=b.y then return a.y<b.y end
        return a.x<b.x
    end)
    local runs={}
    for _,cell in ordered do
        local previous=runs[#runs]
        if previous and previous.y==cell.y and previous.z==cell.z and previous.x2+1==cell.x
            and previous.color==cell.color and previous.role==cell.role then
            previous.x2=cell.x
        else
            table.insert(runs,{x1=cell.x,x2=cell.x,y=cell.y,z=cell.z,color=cell.color,role=cell.role})
        end
    end
    return {family=family,runs=runs,voxelCount=#ordered,muzzle={x=muzzleX,y=muzzleY,z=0},
        grip={x=gripX,y=gripY,z=0}}
end
return VoxelWeapons
