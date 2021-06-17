local rozpoczecie_pracy = {
    -- x,y,z, int, dim
    {2654.35,1218.05,10.98,0,0},
}

for i,v in ipairs(rozpoczecie_pracy) do
    v.pickup=createPickup(v[1],v[2],v[3], 3, 1247)
    setElementInterior(v.pickup, v[4])
    setElementDimension(v.pickup, v[5])
    setElementData(v.pickup, "faction:duty4", true)
end

local function getmrp(thePlayer)
    for i,v in ipairs(rozpoczecie_pracy) do
        if (v.pickup==thePlayer) then return v end
    end
    return nil
end

addEventHandler("onClientPickupHit", resourceRoot, function(thePlayer, md)
        if (thePlayer~=localPlayer or not md) then return end
        if (getElementInterior(source)~=getElementInterior(localPlayer)) then return end

        if (not getElementData(source, "faction:duty4")) then return end

        local _,_,z1=getElementPosition(thePlayer)
        local _,_,z2=getElementPosition(source)
        if (math.abs(z1-z2)>3)  then return end


        local mrp=getmrp(source)
        triggerServerEvent("onPlayerRequestJoinMechanik",localPlayer,mrp)

    end)

addEventHandler("onClientPickupLeave", resourceRoot, function(thePlayer, md)

        if (thePlayer~=localPlayer or getElementDimension(thePlayer)~=getElementDimension(source)) then return end

        if (not getElementData(source, "faction:duty4")) then return end
        selected_duty = nil
    end)