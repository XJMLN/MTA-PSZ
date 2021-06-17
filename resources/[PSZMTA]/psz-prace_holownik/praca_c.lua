--[[

praca holownik: holowanie pojazdow za $

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-praca_holownik
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
    
function holowanie_enterTowtruck(thePlayer,seat, jacked)
    if (getElementModel(source) ~= 525) then return end
    if (seat and tonumber(seat)~= 0) then return end
    outputChatBox("Jeśli chcesz zarobić trochę pieniędzy, możesz odholować pojazdy zaznaczone na mapie do skupów (ikona ciężarówki).",thePlayer)
    holowanie_returnAllVehicles(thePlayer)
end

function holowanie_exitTowtruck(thePlayer, seat, jacked)
    if (getElementModel(source)~= 525) then return end
    if (seat and tonumber(seat)~= 0) then return end
    for k, v in ipairs(getElementsByType('blip', getResourceRootElement())) do
        destroyElement(v)
    end
end

addEventHandler("onVehicleExit", getRootElement(), holowanie_exitTowtruck)
addEventHandler("onVehicleEnter", getRootElement(), holowanie_enterTowtruck)
]]--



function jhol_searchVehicles()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (veh and getElementModel(veh)~=525) then return end
	local i = 0
	for _,v in ipairs(getElementsByType('vehicle')) do
		if getElementDimension(v)~=getElementDimension(localPlayer) then return end
		if getElementInterior(v)~=getElementInterior(localPlayer) then return end

		if getElementData(v,"public:vehicle") then
			blip = createBlipAttachedTo(v, 0,2,255,0,0,255,0,65535,localPlayer)
			attachElements(v, blip)
			i = i + 1
			
		end
	end
end

addEventHandler("onClientVehicleEnter", getRootElement(), function(plr, seat)
	if plr ~= localPlayer then return end
	if seat ~=0 then return end
	if getElementModel(source)~=525 then return end
	if not getElementData(source,"pojazd_spawn") then return end

	jhol_searchVehicles()
	outputChatBox("Jeśli chcesz zarobić trochę pieniędzy, możesz odholować pojazdy zaznaczone na mapie do skupów (ikona ciężarówki).",137, 244, 66)
	triggerServerEvent("hol_clientEnter",localPlayer,1)
end)

addEventHandler("onClientVehicleStartEnter",getRootElement(),function(plr,seat)
	if plr ~= localPlayer then return end
	if seat ~=0 then return end
	if getElementModel(source)~=525 then return end
	if not getElementData(source,"pojazd_spawn") then return end
	
	local rep = getElementData(localPlayer,"good_reputation") or 0
	local _rep = getElementData(localPlayer,"bad_reputation") or 0
	if ((_rep + rep) <10) then 
		outputChatBox("Aby rozpocząć pracę musisz posiadać +10 reputacji.",255,0,0)
		cancelEvent()
		return
	end
end)
addEventHandler("onClientVehicleExit", getRootElement(), function(plr, seat)
	if plr ~= localPlayer then return end
	if seat ~= 0 then return end
	if getElementModel(source) ~= 525 then return end
	for k, v in ipairs(getElementsByType('blip', getResourceRootElement())) do
		destroyElement(v)
	end
	triggerServerEvent("hol_clientEnter",localPlayer,0)
end)

