-- Deliberate movement tuning. Catalog mobility values are ratings, not studs/sec.
local Movement = {
    BaseSpeed = 14, MinSpeed = 12.5, MaxSpeed = 15.5,
    AimMultiplier = .80, LeanMultiplier = .82,
    InputAcceleration = 16, InputBraking = 25, SpeedResponse = 12,
    LeanResponse = 10, LeanDistance = .8, LeanAngle = math.rad(9),
    CameraClearance = .25, WallPadding = .06,
    JumpHeight = 3.2, RequestInterval = .10, RequestTimeout = .6,
}
function Movement.walkSpeed(rating,aiming,lean)
    local speed=math.clamp(Movement.BaseSpeed*rating/215,Movement.MinSpeed,Movement.MaxSpeed)
    if aiming then speed*=Movement.AimMultiplier end
    return speed*(1-(1-Movement.LeanMultiplier)*math.clamp(math.abs(lean),0,1))
end
function Movement.alpha(response,dt)
    return 1-math.exp(-response*math.max(dt,0))
end
function Movement.approach(current,target,response,dt)
    return current+(target-current)*Movement.alpha(response,dt)
end
function Movement.validRequest(payload)
    return type(payload)=="table" and (payload.lean==-1 or payload.lean==0 or payload.lean==1)
        and type(payload.ads)=="boolean"
end
function Movement.availableLean(request,grounded,active)
    return if grounded and active then request else 0
end
function Movement.wallFraction(distance,hitDistance)
    if distance<=0 then return 0 end
    return math.clamp((hitDistance-Movement.WallPadding)/distance,0,1)
end
return table.freeze(Movement)
