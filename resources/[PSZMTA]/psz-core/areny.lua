--[[

Core - wychodzenie z aren, weryfikacja

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local function isPlayerArenaPlayed(cel)
	local pvp = getElementData(cel,"arena:pvp")
	if (pvp and pvp.start) then return true else return false end
end

function arena_exit(thePlayer)
	local c = getElementData(thePlayer,"character")
	if (not c and not c.id) then return end
	if (not isPlayerArenaPlayed(thePlayer)) then
		outputChatBox("Nie jesteś na żadnej arenie.",thePlayer,255,0,0)
		return
	end
	setElementHealth(thePlayer,100)
	setElementPosition(thePlayer,-2400.62,-594.58,132.65)
	setElementDimension(thePlayer,0)
	setElementInterior(thePlayer,0)
end
addCommandHandler("ae",arena_exit)
addCommandHandler("arenaexit",arena_exit)
