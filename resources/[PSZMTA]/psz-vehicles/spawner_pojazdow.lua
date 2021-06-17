--[[

spawner pojazdow na spawnie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local auta = {
    -- x,y,z,rx,ry,rz,model
    
    -- LS spawn
    {2508.13,-1666.54,12.98,0,0,11,402},  -- Buffalo
    {2509.63,-1687.67,13.5,0,0,42.0,541}, -- Bullet
    {2487.50,-1655,13.09,0,0,90,415}, -- Cheetah
    {2472.17,-1676.08,12.94,0,0,210.4,436}, -- Previon
    {2517.06,-1671.54,13.6,-15,2,62.1,491}, -- Virgo
    {2488.73,-1683,12.85,0,0,270.2,562}, -- Elegy
	
	-- TR spawn
    {-240.99,2594.42,62.31,0,0,0,551}, -- merit
    {-236.99,2609.11,62.34,0,0,180,478}, -- walton
    {-231.05,2608.41,62.32,0,0,180,518}, -- buccaneer
    {-232.45,2595.19,62.31,0,0,0,507}, -- elegant
    {-209.32,2609.32,62.29,0,0,180,549}, -- Tampa
    {-200.92,2609.47,62.25,0,0,180,587}, -- Euros
    {-213.92,2594.30,62.18,0,0,0,496}, -- blista
    {-205.24,2594.51,62.22,0,0,0,411}, -- infernus

	-- LV spawn
	{1666.29,1305.56,10.37,0,0,358.7,542}, -- banshee
	{1667.10,1297.61,10.21,0,0,180,451},
	{1659.40,1286.67,11.02,0,0,359.9,489}, -- rancher
	{1686.15,1297.62,10.45,0,0,180,560}, -- sultan
	{1657.35,1316.65,10.46,0,0,180,426}, -- premier
	{1688.40,1306.89,10.34,0,0,359.2,411},
	{1669.99,1317.18,10.32,0,0,180,415},
	-- SF spawn
	{-2416.8,-588.83,132.12,0,0,215.9,411}, -- infernus
	{-2411.35,-584.87,132.28,0,0,216.0,560}, -- sultan
	{-2402.67,-584.66,132.17,0,0,124.5,562}, -- elegy
	{-2392.78,-599.05,132.29,0,0,125.5,426}, -- premier
	{-2391.73,-608.04,132.3,0,0,34.3,429}, -- banshee
	{-2396.85,-612.21,132.27,0,0,35.4,480}, -- comet
    -- 2 sf

    {-2062.84,1399.11,6.73,0,0,0,555}, -- windsor
    {-2062.57,1385.78,6.73,0,0,0,533}, -- feltzer
    {-2062.61,1371.77,6.73,0,0,0,451}, -- turismo
    {-2093.57,1398.97,6.73,0,0,180,558}, -- uranus
    {-2093.75,1385.54,6.73,0,0,180,559}, -- jester
    {-2094.06,1369.05,7.14,0,0,219.9,522}, -- nrg
    {-2094.24,1372.66,7.14,0,0,231.4,521}, -- fcr

	-- SF Lotnisko
	{-1310.37,-242.46,13.3,0,0,302.0,577}, -- AT-400
	{-1359.55,-198.46,14.97,0,0,325.4,592}, -- Andromada
	-- LV Lotnisko
	{1612.01,1555.07,11.65,0,0,17.5,592}, -- Andromada
	{1545.07,1484.95,11.65,0,0,112.6,577}, -- AT-400
    -- A69 Lotnisko
    --{271.18,1966.65,18.8,0,0,231.4,476}, -- Rustler
    --{271.11,1945.06,18.8,0,0,316.0,476}, -- Rustler
   -- {285.48,1948.2,18.8,0,0,335.9,476}, -- Rustler
   -- {284.06,1963.31,18.8,0,0,187.3,476}, -- Rustler
    -- Holowniki LS
    
}

for i,v in ipairs(auta) do
    v.pojazd = createVehicle(v[7],v[1],v[2],v[3],v[4],v[5],v[6],"SPAWN")
    setElementData(v.pojazd,"spawn:vehicle",true)
    setElementFrozen(v.pojazd,false)
   setTimer(function() setElementFrozen(v.pojazd,true) end,4000,1)
    setVehicleDamageProof(v.pojazd,true)
    toggleVehicleRespawn(v.pojazd,true)
    local c1,c2,c3 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c4,c5,c6 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c7,c8,c9 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c10,c11,c12 = math.random(0,255), math.random(0,255), math.random(0,255)
    setVehicleColor(v.pojazd,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)
end

function onEnter(player,seat,jacked)
    local v_VIP = getElementData(source, "vip:vehicle")

    if (v_VIP and v_VIP~=player) then 
       -- if getPlayerName(player) == "XJMLN" then 
            outputChatBox("Ten pojazd VIP nie należy do Ciebie!",player,255,0,0)
            cancelEvent()
       -- end
    end
    if (getElementData(source,"spawn:vehicle")) then
        setElementFrozen(source,false)
		setElementHealth(source,1000)
    end
    if (getElementModel(source)==476 or getElementModel(source)==520) then
        toggleControl(player,"vehicle_secondary_fire",false)
        toggleControl(player,"vehicle_fire", false)
    else
        toggleControl(player,"vehicle_secondary_fire",true)
        toggleControl(player, "vehicle_fire", true)
    end
end
addEventHandler("onVehicleStartEnter",getRootElement(),onEnter)

function onExit()
    if (getElementData(source,"spawn:vehicle") or getElementData(source,"public:vehicle")) then
    	if getVehicleOccupants(source) ~=0 then return end
        setElementHealth(source,1000)
        setElementAlpha(source,255)
        setElementInterior(source,0)
        setElementDimension(source,0)
        setTimer(respawnVehicle, 3000,1,source)
    end
end
addEventHandler("onVehicleExit",getRootElement(),onExit)

local veh_VP = {}

function spVIP_createVeh(model, who)
    if (not model or not who) then return end
    local x,y,z = getElementPosition(who)
    local rx, ry, rz = getElementRotation(who)
    table.insert(veh_VP,pojazd)
        pojazd = createVehicle(model, x, y, z, rx, ry, rz, "VIP")
        setElementData(pojazd, "vip:vehicle", who)
        warpPedIntoVehicle( who, pojazd)
        toggleVehicleRespawn(pojazd, false)
        -- gracz jest w pojezdzie odrazu, blokujemy strzelanie
        toggleControl(who, "vehicle_fire", false)
        toggleControl(who, "vehicle_secondary_fire", false)
end
