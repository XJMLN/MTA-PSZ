--[[

Tuning - zmiana rejestracji

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local marker = createMarker(2660.12,1210.77,9.98,"cylinder",3.5,200,120,50,25)
local text = createElement ("text");
setElementPosition (text, 2659.86,1210.75, 13);
setElementData (text, "text", "Zmiana rejestracji");
setElementData(text,"scale", 1.8);
function rejestracja_hit(el,md)
	if not md then return end
	if getElementType (el) ~= "vehicle" then return end
	local kierowca = getVehicleOccupant (el, 0)
	if (kierowca) then 
		if getElementData(el,"spawn:vehicle") then 
			outputChatBox("Ten pojazd jest z spawnu nie możesz w nim zmienić rejestracji.",kierowca,255,0,0)
			return
		end
		triggerClientEvent(kierowca,"rejestracja_show", kierowca,el)
	end
end
addEventHandler ("onMarkerHit", marker, rejestracja_hit)

addEvent ("rejestracja_change", true)
addEventHandler("rejestracja_change", root, function(txt)
	if (txt) then
		local veh = getPedOccupiedVehicle(client)
		if veh then 
			if getPlayerMoney(client) <100 then 
				outputChatBox("Nie posiadasz przy sobie 100$. Tablica nie została zmieniona.",client,255,0,0)
				return 
			end
			if getElementData(veh,"owning_gang") then 
				outputChatBox("Nie możesz zmienić tablicy rejestracyjnej w pojeździe gangu.",client,255,0,0)
				return
			end
			setVehiclePlateText(veh, txt)
			takePlayerMoney(client, 100)
			outputChatBox("Tablica została zmieniona, z twojego konta zabrano 100$.",client)
			outputChatBox(string.format("Nowa tablica rejestracyjna: %s.",txt), client)
		end
	end
end)