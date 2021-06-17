--[[
rozne - otwarte garaze

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-rozne
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEventHandler("onResourceStart", getResourceRootElement(),
function (resource)
	for i=0,49 do
		if (not isGarageOpen(i)) then
			setGarageOpen(i, true)
		end
	end
end)