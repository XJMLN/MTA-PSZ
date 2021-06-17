--[[

Dzwieki - wlaczanie/wylaczanie dzwiekow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-dzwieki
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--



local lu={}

addEvent("broadcastSound3D", true)
addEventHandler("broadcastSound3D", root, function(dzwiek, range, minrange, delay, bliskiKomunikat, dalekiKomunikat)
	if delay then
		if lu[dzwiek] and getTickCount()-lu[dzwiek]<delay then
			outputChatBox(string.format("(( Musisz odczekać %d sekund. ))", delay/1000), client, 255,0,0)
			return
		end
		lu[dzwiek]=getTickCount()
	end
	triggerClientEvent("broadcastSound3D", source, dzwiek, range, minrange, bliskiKomunikat, dalekiKomunikat)
end)

addEvent("toggleVehicleSound", true)
addEventHandler("toggleVehicleSound", root, function(dzwiek, range)
	local snd=getElementData(source,"snd:"..dzwiek)
	if snd then
		triggerClientEvent("destroyVehicleSound", source, dzwiek)
		setTimer(removeElementData,500,1,source,"snd:"..dzwiek)
		return
	end
	triggerClientEvent("createVehicleSound", source, dzwiek, range)
	setElementData(source,"snd:"..dzwiek,true)
end)