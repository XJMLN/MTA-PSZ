--[[

Fotoradary - mandaty za przekroczenie predkosci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-fotoradary
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function msgToPolice(text)
	for i,v in ipairs(getElementsByType("player")) do
		if (getElementData(v,"duty:policja")) then
			outputChatBox(text,v,255,0,0)
		end
	end
end
function upgradeWanted(gracz)
local character = getElementData(gracz,"character")
	if (not character) then return end

		local levelWanted = character.wanted
	if levelWanted > 0 and levelWanted<6 then
		setPlayerWantedLevel(gracz,levelWanted+1)
		character.wanted = character.wanted+1
		setElementData(gracz,"character",character)
	elseif levelWanted == 0 then
		setPlayerWantedLevel(gracz,1)
		character.wanted = 1
		setElementData(gracz,"character",character)
	end
end
function Wykroczenie(kmh,limit,tekst)
	przekroczonekm=math.floor(kmh)-limit
	local c = getElementData(source,'character')
	if (c) then
	exports["psz-mysql"]:zapytanie(string.format("INSERT INTO psz_players_scores SET player_id=%d,nazwa='FOTOCASH',score=1 ON DUPLICATE KEY UPDATE score=score+1",tonumber(c.id)))
	local wykroczenia = tonumber(getElementData(source,"wykroczenia"))
		if wykroczenia == 0 or wykroczenia == nil then
			setElementData(source,"wykroczenia",1)
			--local wykroczenia = tonumber(getElementData(source,"wykroczenia"))
		return end -- na 100% gracz nie spełnia wymagań do dalszego kodu ;)
	setElementData(source,"wykroczenia",wykroczenia+1)
	if wykroczenia > 5 then
		upgradeWanted(source)
		setElementData(source,"wykroczenia",1)
	end
end
end
addEvent( "fotoradary:takeMoney", true )
addEventHandler( "fotoradary:takeMoney", getRootElement( ), Wykroczenie)
