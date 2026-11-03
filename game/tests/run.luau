local Combat = require("../src/shared/CombatMath")
local Catalog = require("../src/shared/WeaponCatalog")
local Workshop = require("../src/shared/Workshop")
local checks = 0
local function check(value, message)
    checks += 1
    assert(value, message)
end
local function near(a,b) return math.abs(a-b)<.00001 end
check(#Catalog.Order==41,"All 41 named weapons imported")
local classes={}
for _,id in Catalog.Order do
    local w=Catalog.ById[id]
    classes[w.class]=true
    check(w.damage>0 and w.rpm>0 and w.magazine>=1,"Positive combat stats: "..id)
    check(w.move>=190 and w.move<=250,"Movement bounds: "..id)
    check(w.zoom==1 or w.class=="Sniper" or w.class=="Marksman","Scoped classes only: "..id)
    check(Combat.reloadSeconds(w)>0,"Valid reload: "..id)
end
local count=0
for _ in classes do count+=1 end
check(count==8,"Eight classes")
local w={damage=40,penetration=0,range=42,class="Assault Rifle"}
check(near(Combat.damage(w,150,false,0),28),"Armor reduces damage by 30% at cap")
check(near(Combat.damage(w,75,false,0),34),"Half armor reduces damage by 15%")
check(near(Combat.damage(w,0,true,0),60),"Standard headshot multiplier")
w.class="Sniper"
check(near(Combat.damage(w,0,true,0),80),"Sniper headshot multiplier")
w.penetration=70
check(near(Combat.damage(w,150,false,0),33.6),"Penetration subtracts armor points")
check(near(Combat.damage(w,0,false,42*Combat.StudsPerMeter*2),20),"Minimum ranged damage")
check(near(Combat.ttk(40,600),.4),"TTK counts intervals between five hits")
check(not Combat.finite(0/0) and not Combat.finite(math.huge) and not Combat.finite("40"),"Reject nonfinite inputs")
local cells={}
for x=1,8 do table.insert(cells,{x=x,y=1,color=5}) end
check(Workshop.validate(cells)~=nil,"Valid design accepted")
local valid=Workshop.validate(cells)
cells[1].color=3
check(valid[1].color==5,"Validation creates an independent copy")
local function rejects(payload, reason)
    local ok,result=pcall(Workshop.validate,payload)
    check(ok and result==nil,reason)
end
rejects(nil,"Reject missing payload")
rejects({},"Reject empty design")
rejects({{}},"Reject missing coordinates without throwing")
rejects({{x=0/0,y=1,color=1}},"Reject NaN")
rejects({{x=1.5,y=1,color=1}},"Reject fractional coordinates")
rejects({{x=33,y=1,color=1}},"Reject out of bounds")
rejects({{x=1,y=1,color=99}},"Reject invalid palette")
rejects({{x=1,y=1,color=1},{x=1,y=1,color=2}},"Reject duplicate coordinates")
rejects({bad={x=1,y=1,color=1}},"Reject dictionary payload")
local huge={}
for i=1,385 do huge[i]={x=(i-1)%32+1,y=math.floor((i-1)/32)+1,color=1} end
rejects(huge,"Reject excessive cells")
print(string.format("PASS: %d checks (roster, combat formulas, hostile workshop payloads)",checks))

local Voxels=require("../src/shared/VoxelWeapons")
local firearmCount=0
local maxParts=0
for _,id in Catalog.Order do
    local weapon=Catalog.ById[id]
    if weapon.class~="Knife" then
        local model=Voxels.generate(weapon)
        firearmCount+=1
        check(model.voxelCount>100,"Volumetric model: "..id)
        check(#model.runs<600,"Render instance budget: "..id)
        local occupied={}
        local volume=0
        local roles={}
        local minZ,maxZ=math.huge,-math.huge
        local maxX=-math.huge
        for _,run in model.runs do
            check(Voxels.Palette[run.color]~=nil,"Palette defined")
            check(run.x1<=run.x2,"Positive run length")
            minZ,maxZ=math.min(minZ,run.z1),math.max(maxZ,run.z2)
            maxX=math.max(maxX,run.x2)
            roles[run.role]=true
            for x=run.x1,run.x2 do for y=run.y1,run.y2 do for z=run.z1,run.z2 do
                local key=x..":"..y..":"..z
                check(not occupied[key],"Meshed geometry has no overlapping voxels")
                occupied[key]={x,y,z}
                volume+=1
            end end end
        end
        local pending=table.clone(occupied)
        local firstKey,first=next(pending)
        pending[firstKey]=nil
        local queue={first}
        local nextIndex=1
        while nextIndex<=#queue do
            local cell=queue[nextIndex]
            nextIndex+=1
            for axis=1,3 do for _,step in {-1,1} do
                local p={cell[1],cell[2],cell[3]}
                p[axis]+=step
                local key=p[1]..":"..p[2]..":"..p[3]
                if pending[key] then table.insert(queue,pending[key]);pending[key]=nil end
            end end
        end
        check(#queue==volume,"Every voxel connects to the weapon body: "..id)
        local needsMagazine=weapon.class~="Shotgun" or id=="KSG"
        if needsMagazine and id~="KSG" then
            check(#model.magazineSeats>0,"Magazine mounting region defined: "..id)
        end
        for _,seat in model.magazineSeats do
            check(seat.y1<=seat.y2 and seat.x1<=seat.x2,"Valid magazine seat bounds: "..id)
            for x=seat.x1,seat.x2 do for y=seat.y1,seat.y2 do for z=seat.z1,seat.z2 do
                check(occupied[x..":"..y..":"..z]~=nil,"Continuous magazine-to-receiver seat: "..id)
            end end end
        end
        if id=="KSG" then
            check(roles.MagazineTube and not roles.Magazine,"KSG uses tube magazines, not a detachable rifle magazine")
        end
        if model.sightLine then
            local rear,front=model.sightLine.rear,model.sightLine.front
            check(rear.y==front.y and rear.z==0 and front.z==0,"Iron sights share a centered sight plane: "..id)
            check(not occupied[rear.x..":"..rear.y..":0"],"Rear aperture remains open: "..id)
            check(occupied[front.x..":"..front.y..":0"]~=nil,"Front aim point sits on its post: "..id)
            for x=rear.x+2,front.x-1 do
                check(not occupied[x..":"..rear.y..":0"],"Clear iron-sight line: "..id)
            end
        end
        check(volume==model.voxelCount,"Meshing preserves exact voxel volume")
        check(minZ<0 and maxZ>0,"True depth on both sides of receiver")
        check(roles.Barrel and roles.Grip and roles.Trigger,"Required weapon components: "..id)
        check(model.muzzle.x>maxX,"Muzzle attachment clear of model: "..id)
        if weapon.zoom>1 then check(roles.Scope and roles.Lens,"Scoped model: "..id) end
        local features={
            M4A1={"CarryHandle","FrontSightTower","ForwardAssist","MagazineWell"},
            ["AK-103"]={"GasTube","DustCover","SelectorLever","ReceiverRivet"},
            MP5={"TubularReceiver","TaperedForearm","ChargingHandle","TriLugMount"},
            P90={"TopMagazine","OpticsBridge","ReflexSight"},
            M870={"Pump","PumpRib","VentRib","MagazineTube"},
            AWM={"BoltHandle","BoltKnob","RaisedCheekRest","ElevationTurret"},
            ["Glock 17"]={"SlideSerration","SlidePort","Chamber","SightDot"},
            M9={"ExposedBarrel","Hammer","GripMedallion"},
        }
        for _,role in features[id] or {} do check(roles[role],id.." defining detail: "..role) end
        local repeated=Voxels.generate(weapon)
        check(#repeated.runs==#model.runs and repeated.voxelCount==model.voxelCount,"Stable regeneration")
        maxParts=math.max(maxParts,#model.runs)
    end
end
check(firearmCount==35,"All 35 real-world firearm roster entries modeled")
print(string.format("PASS: %d total checks; %d voxel firearms, maximum %d render parts",checks,firearmCount,maxParts))
