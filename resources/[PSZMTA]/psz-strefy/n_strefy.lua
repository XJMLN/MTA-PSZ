--[[

strefy bez dm

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-strefy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local ns = {
	--x,y,z,r,area,dim,int
	{2491.28,-1664.63,13.34,75,area=1,0,0}, -- grove street [spawn]
	{1676.89,1302.22,10.99,50,area=1,0,0}, -- airport lv [spawn]
	{-2403.92,-596.65,132.65,50,area=1,0,0}, -- miss hill [spawn]
	{-2144.45,918.89,79.91,50,area=1,0,0}, -- spawn sf [spawn]
	{-242.00,2600.99,62.70,55,area=1,0,0}, -- las paysadas [spawn]
	{337.19,-1833.43,8.72,70,area=1,0,0}, -- plaza ls
	{1175.81,-1323.19,14.20,40,area=1,0,0}, -- szpital market
	{-21.08,-284.19,5.43,65,area=1,0,0}, -- remiza bb 
	{2297.12,2458.78,10.82,65,area=1,0,0}, -- komisariat lv
	{2289.78,-1210.40,-18.01,100,area=1,1,8}, -- szpital [interior]
	{1865.64,2418.51,20.84,50,area=1,1,42}, -- afk zone [interior]
	{487.33,-14.23,1000.68,90,area=1,0,17}, -- alhambra [interior]
	{1768.97,-1574.21,1735.03,120,area=1,231,0}, -- AJ [interior]
	{246.82,114.84,1003.22,100,area=1,0,10}, -- komisariat [interior]
	{1446.38,1453.29,11.07,250,area=1,2430,0},
}
for i,v in ipairs(ns) do
	v.strefa = createColSphere(v[1],v[2],v[3],v[4])
	v.temp = createElement("strefaRoot", "strefaRoot")
		setElementParent(v.strefa, v.temp)
		setElementData(v.strefa, "area",1)
		setElementDimension(v.strefa, v[5])
		setElementInterior(v.strefa, v[6])
end
addEventHandler("onClientColShapeHit", resourceRoot, function(plr, md)
	if not md then return end
	if plr ~= localPlayer then return end
	if not getElementParent(source) then return end
	if getElementID(getElementParent(source)) == "strefaRoot" then 
		setElementData(localPlayer,"area",1)
		setElementData(localPlayer,"area_element",source)
	end
	toggleControl("fire",false)
	toggleControl("aim_weapon",false)	
end)

addEventHandler("onClientColShapeLeave",resourceRoot, function(plr, md)
	if plr ~= localPlayer then return end
	onLeaveArea(plr)
end)

function onLeaveArea(plr)
	if getElementData(plr,"area") then 
		setElementData(plr,"area",nil)
		setElementData(plr,"area_element",nil)
		toggleControl("fire",true)
		toggleControl("aim_weapon",true)
	end
end

setTimer(function()
	if not isCursorShowing() then 
		if getElementData(localPlayer,"area_element") and not isElementWithinColShape(localPlayer,getElementData(localPlayer,"area_element")) then
			toggleControl("fire",true)
			toggleControl("aim_weapon",true)
			setElementData(localPlayer,"area",nil)
			setElementData(localPlayer,"area_element",nil)
		end
	end
end, 1000, 0)

addEventHandler("onClientVehicleExit", getRootElement(), function(plr, seat)
	if plr == getLocalPlayer() then 
		if getElementData(localPlayer, "area") and tonumber((getElementData(localPlayer,"area"))) == 1 then 
			toggleControl("vehicle_fire", false)
			toggleControl("vehicle_secondary_fire", false)
		else
			toggleControl("vehicle_fire", true)
			toggleControl("vehicle_secondary_fire", true)
		end
	end
end)

addEventHandler("onClientVehicleEnter", getRootElement(), function(plr, seat) 
	if plr == getLocalPlayer() and seat == 0 then
		if getElementData(localPlayer, "area") and tonumber((getElementData(localPlayer, "area"))) == 1 then 
			toggleControl("vehicle_fire", false)
			toggleControl("vehicle_secondary_fire", false)
		else
			toggleControl("vehicle_fire", true)
			toggleControl("vehicle_secondary_fire", true)
		end
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prevSlot, newSlot)
	if getElementData(localPlayer,"area") and getElementData(localPlayer,"area") == 2 then return end
	if getPedWeapon(getLocalPlayer(),newSlot) == 38 then setPedWeaponSlot(localPlayer, prevSlot) end
end)


function onTakeDamage(attacker, weapon, bodypart)
    if getElementData(source,"area_element") and isElementWithinColShape(source,getElementData(localPlayer,"area_element")) then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerDamage",getLocalPlayer(),onTakeDamage)

function onPlayerKilled(target)
    if getElementData(target,"area_element") and isElementWithinColShape(target,getElementData(localPlayer,"area_element")) then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerStealthKill",getLocalPlayer(),onPlayerKilled)