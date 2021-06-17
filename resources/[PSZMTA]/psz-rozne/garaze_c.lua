--[[

Rozne - otwarte garaze

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-rozne
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function (resource)
	for i=0,49 do
		setGarageOpen(i, true)
	end
end)
