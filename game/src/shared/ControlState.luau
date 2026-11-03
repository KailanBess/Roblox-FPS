-- Input state is independent of Roblox devices so hybrid-device transitions can
-- be checked without a client runtime. Touch lean is a toggle; other lean is held.
local State={}
function State.new() return {left=false,right=false,touchLean=0} end
function State.clear(state) state.left=false;state.right=false;state.touchLean=0 end
function State.lean(state)
    if state.touchLean~=0 then return state.touchLean end
    return (if state.right then 1 else 0)-(if state.left then 1 else 0)
end
function State.setLean(state,side,pressed,touch)
    assert(side==-1 or side==1,"Invalid lean side")
    if touch then
        if pressed then state.touchLean=if state.touchLean==side then 0 else side end
    elseif side<0 then state.left=pressed else state.right=pressed end
end
function State.mode(name)
    if name=="Touch" then return "Touch" end
    if string.find(name,"Gamepad") then return "Gamepad" end
    return "Desktop"
end
return table.freeze(State)
