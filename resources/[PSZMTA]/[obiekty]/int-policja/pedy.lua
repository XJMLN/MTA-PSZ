local I=10
local D=1

local pedy= {}

pedy[1] = createPed(283,253.80,117.39,1003.22,90) -- policjant przy mandatach

for k,v in ipairs(pedy) do
    setElementDimension(v,D)
    setElementInterior(v,I)
    setElementFrozen(v,true)
end

--[[
function cancelPedDamage ( attacker )
    cancelEvent() 
end
addEventHandler ( "onClientPedDamage", getRootElement(), cancelPedDamage )
]]--