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
        check(#model.runs<900,"Render instance budget: "..id)
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
                occupied[key]={x,y,z,color=run.color}
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
        local raw=Voxels.generate(weapon,{textured=false})
        check(raw.voxelCount==model.voxelCount,"Finish preserves geometry volume: "..id)
        check(raw.finishVoxelCount==0 and model.finishVoxelCount>0,"Surface finish applied only when enabled: "..id)
        local sameGeometryAndPalette=true
        for _,run in raw.runs do
            for x=run.x1,run.x2 do for y=run.y1,run.y2 do for z=run.z1,run.z2 do
                local c=occupied[x..":"..y..":"..z]
                if not c or Voxels.BaseColors[c.color]~=run.color then sameGeometryAndPalette=false end
            end end end
        end
        check(sameGeometryAndPalette,"Finish preserves every voxel location and base palette identity: "..id)
        local repeated=Voxels.generate(weapon)
        check(#repeated.runs==#model.runs and repeated.voxelCount==model.voxelCount,"Stable regeneration")
        maxParts=math.max(maxParts,#model.runs)
    end
end
for key,rgb in Voxels.Palette do
    local base=Voxels.Palette[Voxels.BaseColors[key]]
    for channel=1,3 do
        check(math.abs(rgb[channel]-base[channel])<=base[channel]*.11+1,"Surface tones stay within original color family: "..key)
    end
end
check(firearmCount==35,"All 35 real-world firearm roster entries modeled")
print(string.format("PASS: %d total checks; %d voxel firearms, maximum %d render parts",checks,firearmCount,maxParts))

local Movement=require("../src/shared/Movement")
local movementStart=checks
check(near(Movement.walkSpeed(215,false,0),12.5),"Controlled base walking pace")
check(near(Movement.walkSpeed(10000,false,0),14),"Light-weapon speed cap")
check(near(Movement.walkSpeed(1,false,0),11),"Heavy-weapon speed floor")
check(near(Movement.walkSpeed(215,true,0),10),"Aiming slows movement")
check(near(Movement.walkSpeed(215,false,-1),10.25),"Leaning slows movement")
check(near(Movement.walkSpeed(215,true,1),8.2),"Scoped leaning has a controlled pace")
check(near(Movement.walkSpeed(215,false,-1),Movement.walkSpeed(215,false,1)),"Left/right pace symmetric")
check(Movement.validRequest({lean=-1,ads=false}),"Accept left lean")
check(Movement.validRequest({lean=1,ads=true}),"Accept aimed right lean")
check(Movement.validRequest({lean=0,ads=false}),"Accept neutral stance")
for _,payload in {{lean=2,ads=false},{lean=.5,ads=true},{lean=0/0,ads=false},{lean=math.huge,ads=false},
    {lean=0,ads=1},{lean="1",ads=false},{ads=false},{lean=0}} do
    check(not Movement.validRequest(payload),"Reject invalid movement request")
end
check(not Movement.validRequest(nil) and not Movement.validRequest("lean"),"Reject non-table requests")
check(Movement.availableLean(1,false,true)==0,"Jumping neutralizes lean request")
check(Movement.availableLean(-1,true,false)==0,"Inactive/menu stance neutral")
check(Movement.availableLean(-1,true,true)==-1,"Grounded active lean accepted")
check(Movement.wallFraction(.8,0)==0,"Immediate cover prevents lean")
check(Movement.wallFraction(.8,.03)==0,"Padding prevents camera touching cover")
check(near(Movement.wallFraction(.8,.46),.5),"Partial clearance permits partial lean")
check(Movement.wallFraction(.8,5)==1,"Wall fraction cannot exceed full lean")
check(Movement.wallFraction(0,1)==0,"No divide by zero at neutral")
local reference
for _,fps in {30,60,120,240} do
    local lean,input=0,0
    for _=1,fps do
        lean=Movement.approach(lean,1,Movement.LeanResponse,1/fps)
        input=Movement.approach(input,1,Movement.InputAcceleration,1/fps)
        check(lean>=0 and lean<=1 and input>=0 and input<=1,"Smoothing never overshoots")
    end
    if reference then check(near(lean,reference),"Lean timing independent of frame rate") end
    reference=lean
    for _=1,math.floor(fps*.2) do input=Movement.approach(input,0,Movement.InputBraking,1/fps) end
    check(input<.01,"Braking settles in 0.2 seconds without sliding")
end
check(Movement.approach(.5,1,Movement.LeanResponse,0)==.5,"Zero-time step is stable")
check(Movement.approach(.5,1,Movement.LeanResponse,-1)==.5,"Negative-time step is stable")
print(string.format("PASS: %d movement checks (pace, lean, cover clearance, invalid requests and frame rates)",checks-movementStart))
