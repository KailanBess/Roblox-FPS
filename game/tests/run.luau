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
