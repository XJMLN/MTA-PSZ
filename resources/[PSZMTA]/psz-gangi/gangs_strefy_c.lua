--[[

Gangi: strefy dla gangów

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gangi
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEventHandler ("onClientColShapeHit", resourceRoot, function (hitElement, matchindDimension)
	if (hitElement ~= localPlayer or not matchindDimension or getElementInterior (localPlayer) ~= getElementInterior (source)) then return end
	local gz = getElementData(source,"gang:zone")
	if (not gz or not gz.id) then return end
	outputChatBox("#".. gz.color .. "Wchodzisz w strefę gangu "..gz.nazwa,255,255,255,true)
end)