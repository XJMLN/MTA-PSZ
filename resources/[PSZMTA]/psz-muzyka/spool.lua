
local i=0

local function pojazdPusty(veh)
    local occupants = getVehicleOccupants(veh)
    for i=0,getVehicleMaxPassengers(veh) do
        if occupants[i] and isElement(occupants[i]) then return false end
    end
    local x,y,z=getElementPosition(veh)
    local cs=createColSphere(x,y,z,10)
    local graczewokolicy=getElementsWithinColShape(cs,"player")
    destroyElement(cs)
    if #graczewokolicy>0 then return false end


    return true
end

local vehResource=getResourceFromName("freeroam")
setTimer(function()
        local vehicles=getElementsByType("vehicle", getResourceRootElement(vehResource))

        local i2=0
        for _,veh in ipairs(vehicles) do
            i2=i2+1
            if (i2%2==i) then
                local caudio=getElementData(veh,"audio:cd")
                if caudio and type(caudio)=="table" and caudio[1] then
                    if pojazdPusty(veh) then
                        setElementData(veh,"audio:cd", false)
                    end
                end
            end

        end


        i=i+1
        if i>1 then i=0 end
    end, 60000,0)