--[[

Drift - zliczanie punktow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drift
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEventHandler("onVehicleDamage",root, function()
local pveh = getVehicleOccupant(source,0)
	if pveh then
		triggerClientEvent(pveh,"vehicleCrashed",root,source)
	end
end)

function updatePlayerScore(player,wynik)
	local c = getElementData(player,"auth:uid")
	if (not c) then
		outputChatBox("Twój wynik nie zostanie zapisany - załóż najpierw konto.",player,255,0,0)
		return
	end
	local query = string.format("INSERT INTO psz_players_drift SET player_id=%d, wynik=%d ON DUPLICATE KEY UPDATE wynik=%d",c,wynik,wynik)
	exports['psz-mysql']:zapytanie(query)
	setElementData(player,"drift",wynik)
end
addEvent("newPlayerRecordScore",true)
addEventHandler("newPlayerRecordScore",root,updatePlayerScore)