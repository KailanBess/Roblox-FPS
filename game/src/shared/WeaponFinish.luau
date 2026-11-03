-- Asset-free surface finishes. Recolors existing exterior voxels only: no new
-- geometry, decals, gameplay changes, runtime randomness, or uploaded textures.
local Finish = {}
local bulkMetal = {
    Receiver=true, ReceiverSide=true, Handguard=true, Slide=true, Magazine=true,
    Chassis=true, FeedCover=true, MonolithicUpper=true, UpperShroud=true,
}
local texturedPolymer = {
    Grip=true, GripPanel=true, GripCheckering=true, Pump=true, Stock=true,
    CheekRest=true, RaisedCheekRest=true, TaperedForearm=true, RecoilHousing=true,
}
function Finish.palette(base)
    local palette, originals = {}, {}
    for name,rgb in base do
        palette[name]=rgb
        originals[name]=name
        for suffix,amount in {Grain=-.055, Wear=.075, Pore=-.10, Fiber=.05} do
            local key=name.."_"..suffix
            palette[key]={
                math.clamp(math.floor(rgb[1]*(1+amount)+.5),0,255),
                math.clamp(math.floor(rgb[2]*(1+amount)+.5),0,255),
                math.clamp(math.floor(rgb[3]*(1+amount)+.5),0,255),
            }
            originals[key]=name
        end
    end
    return palette,originals
end
function Finish.apply(cells)
    local changes=0
    for _,cell in cells do
        local x,y,z=cell.x,cell.y,cell.z
        -- Side surfaces are visible in both the armory and first-person model.
        local exposed = not cells[x..":"..y..":"..(z+1)] or not cells[x..":"..y..":"..(z-1)]
        if not exposed then continue end
        local base,role=cell.color,cell.role
        local suffix
        if base=="Wood" or base=="WoodLight" then
            -- Long, gently wandering grain follows the stock/forearm length.
            local grain=(y+math.floor(x/12)+math.floor(z/4))%9
            if grain==0 then suffix="Grain" elseif grain==1 and x%17<11 then suffix="Fiber" end
        elseif texturedPolymer[role] and (base=="Polymer" or base=="Rubber" or base=="Dark" or base=="Tan" or base=="Olive") then
            -- Regular low-density pores read as grip stippling, not camouflage.
            if x%4==0 and y%4==0 then suffix="Pore"
            elseif y%9==2 and x%19>=5 and x%19<=10 then suffix="Grain" end
        elseif bulkMetal[role] then
            -- Short fine brushing and occasional worn coating along panel edges.
            if y%6==1 and x%17>=3 and x%17<=9 then suffix="Grain"
            elseif y%11==0 and x%23>=7 and x%23<=11 then suffix="Wear" end
        end
        if suffix then
            cell.color=base.."_"..suffix
            changes+=1
        end
    end
    return changes
end
return Finish
