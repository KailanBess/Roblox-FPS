-- Original voxel art, not engineering geometry. Integer grid: +X forward, +Y up.
local Finish = if script then require(script.Parent.WeaponFinish) else require("./WeaponFinish")
local VoxelWeapons = {}
VoxelWeapons.CellSize = 0.05
VoxelWeapons.Palette = {
    Gunmetal={67,74,83}, Dark={25,29,34}, Steel={108,119,130}, Edge={149,158,165},
    Polymer={43,46,45}, Wood={116,65,33}, WoodLight={146,86,43}, Tan={164,144,103},
    Olive={85,99,67}, Glass={49,139,156}, Brass={174,139,65}, Bore={12,14,18},
    Rubber={32,33,32}, Highlight={88,96,104}, WarmMetal={102,98,84},
}
local profiles={
    M4A1="M4",HK416="HK416",["SCAR-L"]="SCAR",["AK-103"]="AK",FAMAS="FAMAS",
    MP5="MP5",MP7="MP7",UMP45="UMP",Vector="Vector",P90="P90",
    M870="M870",M1014="M1014",["SPAS-12"]="SPAS",KSG="KSG",["Super 90"]="M1014",
    M24="M24",AWM="AWM",R700="R700",L96="AWM",Scout="Scout",
    M9="M9",["Glock 17"]="Glock",USP45="USP",P226="P226",["Five-Seven"]="FiveSeven",
    M249="M249",PKM="PKM",RPK="RPK",MG36="MG36",["Stoner 63"]="Stoner",
    ["MK14 EBR"]="EBR",["SR-25"]="SR25",G28="G28",M110="M110",SVD="SVD",
}
VoxelWeapons.Palette,VoxelWeapons.BaseColors=Finish.palette(VoxelWeapons.Palette)
VoxelWeapons.Profiles=table.freeze(profiles)
function VoxelWeapons.generate(weapon,options)
    local family=profiles[weapon.id]
    assert(family,"Missing profile: "..tostring(weapon.id))
    local cells={}
    local sightSpec
    local magazineSeats={}
    local function put(x,y,z,color,role)
        local key=x..":"..y..":"..z
        cells[key]=if color then {x=x,y=y,z=z,color=color,role=role} else nil
    end
    local function box(x1,x2,y1,y2,z1,z2,color,role)
        for x=x1,x2 do for y=y1,y2 do for z=z1,z2 do put(x,y,z,color,role) end end end
    end
    local function polygon(points,z1,z2,color,role)
        local minX,maxX,minY,maxY=math.huge,-math.huge,math.huge,-math.huge
        for _,p in points do
            minX,maxX=math.min(minX,p[1]),math.max(maxX,p[1])
            minY,maxY=math.min(minY,p[2]),math.max(maxY,p[2])
        end
        for x=minX,maxX do for y=minY,maxY do
            local inside=false
            local j=#points
            for i=1,#points do
                local a,b=points[i],points[j]
                if (a[2]>y+.1)~=(b[2]>y+.1) and x+.1<(b[1]-a[1])*(y+.1-a[2])/(b[2]-a[2])+a[1] then inside=not inside end
                j=i
            end
            if inside then box(x,x,y,y,z1,z2,color,role) end
        end end
    end
    local function tube(x1,x2,cy,radius,color,role,hollow,centerZ)
        for y=-radius,radius do for z=-radius,radius do
            local d=y*y+z*z
            if d<=radius*radius+.5 and (not hollow or d>=(if radius>=4 then (radius-2)^2 else (radius-1)^2)) then
                box(x1,x2,cy+y,cy+y,z+(centerZ or 0),z+(centerZ or 0),color,role)
            end
        end end
    end
    local function grip(x,top,color)
        box(x,x+7,top-1,top+3,-3,3,color,"GripTang")
        polygon({{x,top},{x+8,top},{x+5,top-22},{x-5,top-24},{x-8,top-20}},-4,4,color,"Grip")
        for _,z in {-5,5} do
            polygon({{x-1,top-5},{x+5,top-5},{x+2,top-18},{x-4,top-19}},z,z,"Rubber","GripPanel")
            for y=top-17,top-7,3 do box(x-3,x+2,y,y,z,z,"Dark","GripCheckering") end
        end
        box(x-5,x+4,top-23,top-22,-3,3,"Dark","GripBase")
    end
    local function guard(x,top)
        polygon({{x,top},{x+18,top},{x+17,top-13},{x+3,top-13},{x,top-9}},-2,2,"Dark","TriggerGuard")
        polygon({{x+2,top-1},{x+15,top-1},{x+14,top-10},{x+4,top-10}},-3,3,nil)
        polygon({{x+7,top},{x+10,top},{x+8,top-7},{x+6,top-9},{x+5,top-8}},-1,1,"Steel","Trigger")
        box(x,x+2,top-1,top+2,-2,2,"Dark","GuardHanger")
        box(x+15,x+17,top-1,top+2,-2,2,"Dark","GuardHanger")
    end
    local function magazine(x,top,length,curve,color,mountY,width)
        mountY=mountY or 0
        width=width or 10
        for step=0,length do
            local bend=math.floor(curve*(step/length)^2)
            local zwidth=if step>length-3 then 4 else 3
            box(x+bend,x+bend+width-1,top-step,top-step,-zwidth,zwidth,color or "Gunmetal","Magazine")
            if step>4 and step<length-3 then
                for _,z in {-4,4} do
                    box(x+bend+2,x+bend+2,top-step,top-step,z,z,"Dark","MagazineGroove")
                    box(x+bend+width-4,x+bend+width-4,top-step,top-step,z,z,"Highlight","MagazineGroove")
                end
            end
        end
        -- Insert the magazine neck into its receiver/grip, rather than letting a
        -- trigger guard provide the only edge contact across a visible air gap.
        box(x,x+width-1,top,mountY,-3,3,color or "Gunmetal","MagazineInsert")
        box(x-1,x+width,top-1,top+2,-4,4,"Dark","MagazineWell")
        table.insert(magazineSeats,{kind="detachable",x1=x,x2=x+width-1,y1=top,y2=mountY,z1=-2,z2=2})
    end
    local function stock(rear,kind,color)
        if kind=="telescopic" then
            tube(rear+10,-18,5,2,"Steel","BufferTube")
            polygon({{rear,9},{rear+16,9},{rear+22,4},{rear+11,-8},{rear,-12}},-4,4,color,"Stock")
            polygon({{rear+5,2},{rear+15,2},{rear+7,-5}},-5,5,nil)
            box(rear-2,rear-1,-13,9,-5,5,"Rubber","ButtPad")
            box(rear+4,rear+15,8,10,-3,3,"Highlight","CheekRest")
        elseif kind=="skeleton" then
            polygon({{rear,8},{-17,5},{-17,2},{rear+4,-8},{rear,-10}},-2,2,color,"Stock")
            polygon({{rear+7,3},{-26,3},{rear+7,-4}},-3,3,nil)
            box(rear-2,rear,-11,9,-4,4,"Rubber","ButtPad")
        else
            polygon({{rear,7},{rear+15,7},{-19,3},{-16,-4},{rear+10,-10},{rear,-13}},-4,4,color,"Stock")
            box(rear-2,rear-1,-13,7,-5,5,"Rubber","ButtPad")
            polygon({{rear+4,7},{rear+18,7},{rear+23,4},{rear+4,4}},-4,4,"Highlight","CheekRest")
        end
    end
    local function rail(x1,x2,y)
        box(x1,x2,y,y+1,-3,3,"Dark","RailBase")
        for x=x1,x2,3 do box(x,x+1,y+2,y+2,-4,4,"Steel","RailTooth") end
    end
    local function scope(x,y,large)
        local r=if large then 5 else 4
        for _,mount in {x-10,x+9} do
            box(mount-2,mount+2,y-1,y+3,-3,3,"Dark","ScopeMount")
            tube(mount-1,mount+1,y+7,4,"Steel","ScopeRing",true)
        end
        tube(x-16,x+13,y+7,3,"Dark","Scope")
        tube(x-20,x-15,y+7,4,"Gunmetal","Ocular",true)
        if large then tube(x+12,x+15,y+7,4,"Gunmetal","ScopeReducer",true) end
        tube(x+14,x+22,y+7,r,"Gunmetal","Objective",true)
        tube(x+21,x+21,y+7,r-1,"Glass","Lens")
        box(x-2,x+2,y+10,y+14,-2,2,"Steel","ElevationTurret")
        box(x-2,x+2,y+5,y+9,4,6,"Steel","WindageTurret")
        for xx=x-18,x-14,2 do tube(xx,xx,y+7,4,"Highlight","FocusRing",true) end
    end
    local function sights(rear,front,y,hood)
        -- Sight geometry is fitted after the receiver, rails and carry handle exist.
        sightSpec={rear=rear,front=front,height=y+5,hood=hood}
    end
    local function receiver(x1,x2,top,color)
        box(x1,x2,0,top,-4,4,color,"Receiver")
        box(x1+2,x2-1,top+1,top+1,-3,3,"Highlight","ReceiverBevel")
        box(x1+1,x2,1,top-1,-5,-5,color,"ReceiverSide")
        box(x1+1,x2,1,top-1,5,5,color,"ReceiverSide")
        box(-8,4,4,7,5,5,"Bore","EjectionPort")
        box(-8,5,8,8,5,5,"Steel","PortLip")
        for _,x in {x1+3,x2-3} do
            for _,z in {-6,6} do box(x,x+1,2,3,z,z,"Steel","ReceiverPin") end
        end
    end
    local function handguard(x1,x2,top,color)
        box(x1,x2,2,top,-4,4,color,"Handguard")
        box(x1,x2,0,1,-3,3,"Dark","HandguardLowerBevel")
        box(x1,x2,top+1,top+1,-3,3,"Highlight","HandguardUpperBevel")
        for x=x1+3,x2-3,5 do
            for _,z in {-5,5} do box(x,x+2,math.min(4,top-2),math.min(6,top),z,z,"Bore","CoolingVent") end
        end
    end
    local muzzleX,muzzleY,gripX,gripY=75,7,-15,-15
    local cls=weapon.class
    if cls=="Pistol" then
        local beretta=family=="M9"
        local long=if family=="FiveSeven" then 27 else 23
        receiver(-20,long,7,"Gunmetal")
        box(-18,long-2,8,8,-3,3,"Highlight","SlideBevel")
        box(-18,long,-4,-1,-3,3,"Polymer","Frame")
        grip(-15,-4,"Polymer")
        box(-20,-11,-29,-28,-4,4,"Dark","MagazineBase")
        box(-18,-13,-27,-24,-2,2,"Gunmetal","MagazineInsert")
        table.insert(magazineSeats,{kind="grip",x1=-18,x2=-13,y1=-28,y2=-24,z1=-2,z2=2})
        guard(-7,-4)
        for x=-19,-9,2 do
            for _,z in {-5,5} do box(x,x,1,7,z,z,"Dark","SlideSerration") end
        end
        if beretta then
            box(-6,19,6,9,-3,3,nil)
            tube(-5,24,6,2,"Steel","ExposedBarrel")
            box(-22,-20,5,10,-1,1,"Dark","Hammer")
        else
            box(0,9,6,8,2,4,"Bore","SlidePort")
            box(1,7,6,7,2,3,"Steel","Chamber")
            if family=="USP" then rail(5,18,-6) end
        end
        for _,z in {-6,6} do
            if beretta then box(-13,-11,-13,-11,z,z,"Gunmetal","GripMedallion") end
            box(-17,-15,-7,-6,if z<0 then -5 else 4,if z<0 then -4 else 5,"Steel","GripScrew")
            box(-20,-18,1,2,z,z,"Dark","SlideRelease")
        end
        tube(long-1,long+2,5,2,"Steel","Barrel",true)
        box(-19,-16,9,10,-3,-2,"Dark","RearSight")
        box(-19,-16,9,10,2,3,"Dark","RearSight")
        box(long-5,long-3,9,10,0,0,"Dark","FrontSight")
        box(long-4,long-4,10,10,0,0,"Edge","SightDot")
        muzzleX,muzzleY,gripX,gripY=long+3,5,-15,-16
    elseif cls=="Sniper" then
        local tactical=family=="AWM"
        local finish=if tactical then "Olive" elseif family=="R700" then "Wood" else "Polymer"
        stock(-63,if tactical then "skeleton" else "solid",finish)
        polygon({{-27,3},{37,3},{40,0},{34,-5},{-19,-6}},-4,4,finish,"Chassis")
        receiver(-20,14,10,"Gunmetal")
        tube(15,89,7,2,"Steel","Barrel",true)
        tube(82,90,7,3,"Dark","MuzzleBrake",true)
        for x=83,87,3 do for _,z in {-4,4} do box(x,x+1,6,8,z,z,"Bore","BrakePort") end end
        grip(-20,-4,finish)
        guard(-13,-4)
        magazine(4,-6,10,0,"Dark")
        box(-9,-7,3,5,5,10,"Steel","BoltHandle")
        box(-10,-6,0,4,9,12,"Dark","BoltKnob")
        rail(-19,11,12)
        scope(-4,15,true)
        box(-54,-37,6,10,-4,4,finish,"RaisedCheekRest")
        for _,x in {-55,-35} do box(x,x+1,2,5,-5,5,"Steel","StockAdjustment") end
        muzzleX,muzzleY,gripX,gripY=91,7,-20,-16
    elseif cls=="Shotgun" and family~="KSG" then
        local wood=if family=="M870" then "Wood" else "Polymer"
        stock(-56,"solid",wood)
        receiver(-20,13,9,"Gunmetal")
        -- Contoured wrist follows a traditional shotgun stock, not an AR grip.
        polygon({{-23,0},{-15,-2},{-19,-20},{-29,-17},{-32,-10}},-4,4,wood,"Grip")
        guard(-14,-2)
        tube(14,83,7,2,"Steel","Barrel",true)
        tube(14,70,-1,2,"Gunmetal","MagazineTube")
        polygon({{22,3},{47,3},{49,-1},{47,-6},{22,-6},{20,-2}},-5,5,wood,"Pump")
        for x=23,46,3 do
            for _,z in {-6,6} do box(x,x,-5,1,z,z,"Dark","PumpRib") end
        end
        box(14,81,10,10,-1,1,"Dark","VentRib")
        for x=17,77,10 do box(x,x+1,8,9,-1,1,"Gunmetal","RibSupport") end
        sights(-16,79,11,false)
        if family=="SPAS" then
            stock(-58,"skeleton","Steel")
            handguard(19,48,3,"Polymer")
        elseif family=="M1014" then
            stock(-58,"telescopic","Polymer")
            grip(-23,-2,"Polymer")
            rail(-17,8,11)
        end
        muzzleX,muzzleY,gripX,gripY=84,7,-23,-14
    elseif family=="P90" or family=="FAMAS" or family=="KSG" then
        local p90=family=="P90"
        local color=if p90 then "Olive" else "Polymer"
        polygon({{-52,12},{21,12},{32,6},{32,-3},{14,-8},{-44,-8},{-53,-3}},-5,5,color,"Receiver")
        box(-55,-53,-12,12,-6,6,"Rubber","ButtPad")
        grip(3,-6,color)
        gripX=3
        guard(10,-6)
        if p90 then
            polygon({{-41,-4},{-16,-4},{-12,-20},{-33,-21},{-44,-15}},-5,5,color,"Stock")
            polygon({{-35,-8},{-20,-8},{-19,-15},{-32,-16}},-6,6,nil)
            box(-46,23,12,17,-5,5,"WarmMetal","TopMagazine")
            table.insert(magazineSeats,{kind="top",x1=-40,x2=15,y1=11,y2=12,z1=-2,z2=2})
            for x=-41,17,7 do box(x,x+1,14,16,-6,6,"Dark","MagazineRib") end
            box(-17,13,23,25,-2,2,"Dark","OpticsBridge")
            box(-18,-15,18,22,-2,2,"Dark","BridgeSupport")
            box(11,14,18,22,-2,2,"Dark","BridgeSupport")
            tube(-5,6,27,3,"Dark","ReflexSight",true)
            tube(5,5,27,2,"Glass","Lens")
        else
            if family=="FAMAS" then
                magazine(-28,-8,22,1,"Gunmetal",-4)
            end
            box(-38,23,24,26,-2,2,"Dark","CarryHandle")
            box(-40,-37,11,24,-2,2,"Dark","HandleSupport")
            box(21,24,10,24,-2,2,"Dark","HandleSupport")
            sights(-33,21,27,false)
            if family=="KSG" then
                tube(-42,52,0,2,"Gunmetal","MagazineTube",false,-4)
                tube(-42,52,0,2,"Gunmetal","MagazineTube",false,4)
                for _,z in {-6,6} do box(19,39,-4,4,z,z,"Dark","Pump") end
            end
        end
        tube(32,if p90 then 43 else 57,7,2,"Steel","Barrel",true)
        muzzleX=if p90 then 44 else 58
    else
        local ak=family=="AK" or family=="RPK" or family=="SVD"
        local smg=cls=="SMG"
        local lmg=cls=="LMG" and not ak
        local marksman=cls=="Marksman"
        local endX=if smg then 35 elseif marksman or family=="RPK" then 63 else 52
        local finish=if family=="SCAR" or family=="M110" then "Tan" else "Gunmetal"
        receiver(-20,16,11,finish)
        grip(-18,-2,"Polymer")
        guard(-11,-2)
        stock(if smg then -48 else -59,
            if ak then "solid" elseif family=="Vector" or family=="UMP" then "skeleton" else "telescopic",
            if family=="SVD" or family=="RPK" then "Wood" elseif family=="SCAR" then "Tan" else "Polymer")
        local magLength=if smg then 31 elseif marksman then 19 else 30
        if family~="Vector" and family~="MP7" and not lmg then
            magazine(2,-3,magLength,if ak then 11 elseif family=="MP5" then 6 elseif marksman then 0 else 4,"Gunmetal")
        end
        handguard(17,endX-8,10,if ak and family~="AK" then "Wood" else finish)
        if family=="M4" then
            -- Rounded/ribbed polymer forearm in the carbine reference photographs.
            tube(18,endX-9,6,5,"Polymer","Handguard")
            for x=20,endX-10,4 do
                for _,z in {-6,6} do box(x,x+1,3,8,z,z,"Dark","HandguardRib") end
            end
        end
        tube(endX-7,endX+17,7,2,"Steel","Barrel",true)
        tube(endX+13,endX+19,7,3,"Dark","FlashHider",true)
        muzzleX=endX+20
        if ak then
            tube(15,endX+3,13,2,"Gunmetal","GasTube")
            tube(-19,13,11,4,"Dark","DustCover")
            box(-19,15,0,3,-5,5,"Gunmetal","LowerReceiver")
            box(-4,9,3,4,6,6,"Steel","SelectorLever")
            box(-4,-1,8,9,5,9,"Steel","ChargingHandle")
            sights(6,endX+8,15,true)
            -- Magazine's forward sweep and long gas tube define the AK silhouette.
            for _,z in {-6,6} do
                for x=-14,-7,4 do box(x,x+1,4,5,z,z,"Steel","ReceiverRivet") end
            end
        elseif family=="MP5" or family=="UMP" then
            tube(-20,28,9,4,"Dark","TubularReceiver")
            polygon({{13,6},{31,6},{35,0},{29,-5},{15,-5}},-5,5,"Polymer","TaperedForearm")
            box(24,28,12,14,-5,-3,"Steel","ChargingHandle")
            sights(-15,endX+6,13,true)
            if family=="MP5" then
                stock(-49,"solid","Polymer")
                tube(endX+14,endX+18,7,4,"Steel","TriLugMount",true)
            end
        elseif family=="Vector" then
            polygon({{-20,0},{-4,0},{6,-13},{2,-21},{-19,-21}},-6,6,"Tan","RecoilHousing")
            box(12,23,-11,0,-4,4,"Tan","MagazineWell")
            magazine(13,-11,29,0,"Dark")
            guard(-11,-2)
            rail(-19,26,12)
            sights(-15,26,17,false)
        elseif family=="MP7" then
            -- Short machine-pistol receiver and grip-fed magazine.
            magazine(-20,-19,19,0,"Dark",-14,7)
            box(2,13,-34,-4,-3,3,nil)
            grip(20,-3,"Polymer")
            rail(-18,29,13)
            sights(-15,29,17,false)
        else
            rail(-19,if family=="M4" then 14 else endX-10,13)
            if weapon.zoom>1 then scope(-3,17,false) else sights(-17,endX-9,17,false) end
            if family=="M4" then
                -- Raised carry handle and triangular front sight rather than a flat rail.
                box(-16,3,23,24,-2,2,"Dark","CarryHandle")
                box(-17,-15,12,22,-2,2,"Dark","HandleSupport")
                box(2,4,12,22,-2,2,"Dark","HandleSupport")

            end
        end
        if not ak and not smg then
            -- Lower receiver transitions into a flared magwell, with controls on both sides.
            polygon({{-19,0},{-17,-4},{-7,-4},{-3,-2},{13,-2},{16,1}},-5,5,finish,"LowerReceiver")
            box(0,14,-5,-3,-5,5,finish,"MagazineWell")
            box(-19,-16,8,10,5,8,"Gunmetal","ForwardAssist")
            for _,z in {-6,6} do
                box(-13,-10,1,2,z,z,"Steel","Selector")
                box(-9,-8,2,5,z,z,"Dark","BoltCatch")
                box(6,8,0,1,z,z,"Steel","MagazineRelease")
                box(19,20,0,11,-5,5,"Dark","HandguardRing")
            end
        end
        if family=="SCAR" then
            -- Taller monolithic upper, separated folding hinge and cheek piece.
            box(-20,endX-9,11,14,-4,4,"Tan","MonolithicUpper")
            box(-24,-21,0,11,-5,5,"Dark","StockHinge")
            stock(-60,"solid","Tan")
            box(-52,-28,6,13,-4,4,"Tan","AdjustableCheekRest")
            box(-7,-3,8,9,-9,-5,"Steel","ChargingHandle")
        end
        if lmg then
            box(-2,17,-23,-4,-8,8,"Olive","AmmoBox")
            box(-1,16,-4,0,-5,5,"Gunmetal","AmmoBoxMount")
            table.insert(magazineSeats,{kind="beltBox",x1=0,x2=14,y1=-4,y2=0,z1=-2,z2=2})
            box(-18,13,13,15,-5,5,"Gunmetal","FeedCover")
            for x=-1,14,3 do box(x,x+1,5,7,6,12,"Brass","BeltRound") end
            box(5,12,20,21,-2,2,"Dark","CarryHandle")
            box(5,7,15,20,-2,2,"Steel","CarryHandleSupport")
            box(endX-8,endX-2,-2,4,-9,9,"Gunmetal","BipodHinge")
            for _,side in {-1,1} do
                polygon({{endX-7,-1},{endX-3,-1},{endX+4,-31},{endX+1,-32}},side*8,side*8+1,"Steel","Bipod")
            end
        end
        if family=="SVD" then
            stock(-62,"skeleton","Wood")
            handguard(18,50,9,"Wood")
            scope(-4,16,true)
        end
        if family=="EBR" then
            stock(-59,"skeleton","Steel")
            box(-20,8,-4,-1,-6,6,"Steel","Chassis")
        end
    end
    local function surfaceAt(x1,x2,z1,z2)
        local top=-math.huge
        for _,c in cells do
            if c.x>=x1 and c.x<=x2 and c.z>=z1 and c.z<=z2 then top=math.max(top,c.y) end
        end
        assert(top>-math.huge,"Missing mounting surface: "..weapon.id)
        return top
    end
    local sightLine
    if weapon.zoom>1 then sightSpec=nil end
    if sightSpec then
        local rear,front,h=sightSpec.rear,sightSpec.front,sightSpec.height
        if family=="M4" then rear,front,h=-12,53,29 end
        local rearTop=surfaceAt(rear,rear+2,-2,2)
        local frontTop=surfaceAt(front-1,front+1,-2,2)
        h=math.max(h,rearTop+4,frontTop+4)
        -- Separate bases, an open rear aperture and one centered front post.
        box(rear,rear+2,rearTop+1,h-2,-3,3,"Dark","RearSightBase")
        if family=="MP5" or family=="M4" then
            tube(rear,rear+2,h,3,"Steel","RearSight",true)
        else
            box(rear,rear+2,h-1,h+1,-3,-2,"Steel","RearSight")
            box(rear,rear+2,h-1,h+1,2,3,"Steel","RearSight")
        end
        if family=="M4" then
            polygon({{front-5,frontTop},{front+6,frontTop},{front+2,h-3},{front-1,h-3}},-2,2,"Dark","FrontSightTower")
            polygon({{front-2,frontTop+3},{front+3,frontTop+3},{front,h-7}},-3,3,nil)
        else
            box(front-2,front+2,frontTop+1,h-4,-2,2,"Dark","FrontSightBase")
        end
        box(front,front,h-3,h,0,0,"Steel","FrontSight")
        if sightSpec.hood then tube(front-1,front+1,h,4,"Dark","SightHood",true) end
        sightLine={rear={x=rear+1,y=h,z=0},front={x=front,y=h,z=0}}
    elseif cls=="Pistol" then
        sightLine={rear={x=-18,y=10,z=0},front={x=if family=="FiveSeven" then 22 else 18,y=10,z=0}}
    end
    -- Cubic-grid resampling lengthens the whole assembly coherently; it does not
    -- independently stretch or move magazines, sights, sockets or attachment points.
    local lengthScale=if cls=="Pistol" then 1.12 elseif cls=="SMG" then 1.18 else 1.25
    local original=cells
    cells={}
    for _,c in original do
        for x=math.floor(c.x*lengthScale),math.floor((c.x+1)*lengthScale)-1 do
            put(x,c.y,c.z,c.color,c.role)
        end
    end
    for _,seat in magazineSeats do
        seat.x1=math.floor(seat.x1*lengthScale)
        seat.x2=math.floor((seat.x2+1)*lengthScale)-1
    end
    muzzleX=math.floor(muzzleX*lengthScale)
    gripX=math.floor(gripX*lengthScale)
    if sightLine then
        sightLine.rear.x=math.floor(sightLine.rear.x*lengthScale)
        sightLine.front.x=math.floor(sightLine.front.x*lengthScale)
    end
    local finishVoxelCount=if options and options.textured==false then 0 else Finish.apply(cells)
    -- Three-axis greedy merging keeps the fine grid without one Instance per voxel.
    local rows={}
    local voxelCount=0
    for _,cell in cells do
        voxelCount+=1
        local key=cell.z..":"..cell.y
        if not rows[key] then rows[key]={} end
        table.insert(rows[key],cell)
    end
    local strips={}
    for _,row in rows do
        table.sort(row,function(a,b) return a.x<b.x end)
        local last
        for _,c in row do
            if last and last.x2+1==c.x and last.color==c.color and last.role==c.role then last.x2=c.x
            else
                last={x1=c.x,x2=c.x,y1=c.y,y2=c.y,z1=c.z,z2=c.z,color=c.color,role=c.role}
                table.insert(strips,last)
            end
        end
    end
    local function merge(list,axis,a,b,c,d)
        table.sort(list,function(p,q)
            for _,key in {"color","role",a,b,c,d,axis.."1"} do
                if p[key]~=q[key] then return p[key]<q[key] end
            end
            return false
        end)
        local result={}
        for _,p in list do
            local q=result[#result]
            if q and q.color==p.color and q.role==p.role and q[a]==p[a] and q[b]==p[b]
                and q[c]==p[c] and q[d]==p[d] and q[axis.."2"]+1==p[axis.."1"] then
                q[axis.."2"]=p[axis.."2"]
            else table.insert(result,p) end
        end
        return result
    end
    local runs=merge(strips,"y","x1","x2","z1","z2")
    runs=merge(runs,"z","x1","x2","y1","y2")
    return {family=family,runs=runs,finishVoxelCount=finishVoxelCount,voxelCount=voxelCount,magazineSeats=magazineSeats,sightLine=sightLine,lengthScale=lengthScale,muzzle={x=muzzleX,y=muzzleY,z=0},grip={x=gripX,y=gripY,z=0}}
end
return VoxelWeapons
