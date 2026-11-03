local Movement=require(script.Parent.Movement)
local Geometry={}
function Geometry.resolve(character,head,root,lean)
    local side=root.CFrame.RightVector*Vector3.new(1,0,1)
    if side.Magnitude<.001 then return head.Position,0,false end
    side=side.Unit
    local offset=side*math.clamp(lean,-1,1)*Movement.LeanDistance
    local overlaps=OverlapParams.new()
    overlaps.FilterType=Enum.RaycastFilterType.Exclude
    overlaps.FilterDescendantsInstances={character}
    overlaps.RespectCanCollide=true
    -- Spherecasts do not detect an initial overlap. Conservatively cancel both
    -- leaning and firing when the base eye already intersects collidable cover.
    if #workspace:GetPartBoundsInRadius(head.Position,Movement.CameraClearance,overlaps)>0 then
        return head.Position,0,true
    end
    if offset.Magnitude<.001 then return head.Position,0,false end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={character}
    params.RespectCanCollide=true
    params.IgnoreWater=true
    local hit=workspace:Spherecast(head.Position,Movement.CameraClearance,offset,params)
    local fraction=if hit then Movement.wallFraction(offset.Magnitude,hit.Distance) else 1
    return head.Position+offset*fraction,lean*fraction,false
end
return Geometry
