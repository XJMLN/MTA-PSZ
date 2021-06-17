--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local pojazdy={
    {976.44,2241.98,11.00,90},
    {976.44,2238.08,11.00,90},
    {976.40,2233.91,11.00,90},
    {976.53,2229.41,11.00,90},
    {976.42,2225.33,11.00,90},
    {976.43,2221.61,11.00,90},
    {976.47,2217.81,11.00,90},
    {976.42,2213.91,11.00,90},
}

for i,v in ipairs(pojazdy) do 
    v.pojazd = createVehicle(498,v[1],v[2],v[3],0,0,90,"POCZTA")
    setElementData(v.pojazd,"spawn:vehicle",true)
    setElementFrozen(v.pojazd,false)
    setTimer(function() setElementFrozen(v.pojazd,true) end,4000,1)
    setVehicleDamageProof(v.pojazd,true)
    toggleVehicleRespawn(v.pojazd,true)
end

function onEnter(player,seat,jacked)
    if (getElementData(source,"spawn:vehicle")) then
        setElementFrozen(source,false)
        setElementHealth(source,1000)
    end
end
addEventHandler("onVehicleStartEnter",getRootElement(),onEnter)

function onExit()
    if (getElementData(source,"spawn:vehicle")) then
        if getVehicleOccupants(source) ~=0 then return end
        setElementAlpha(source,255)
        setElementInterior(source,0)
        setElementDimension(source,0)
        setTimer(respawnVehicle, 60000,1,source)
    end
end
addEventHandler("onVehicleExit",getRootElement(),onExit)