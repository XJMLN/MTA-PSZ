--[[

Dzwieki - syrena w osp

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-dzwieki
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local myMarker = createMarker(-12.23,-296.67,4.5,"cylinder",1,50,50,50,255)
local text = createElement('text')
	setElementPosition(text,-12.23,-296.67,6)
	setElementData(text,"text","Syrena w remizie")
	
function MarkerHit(hitElement, matchingDimension )
    if (getElementType(hitElement)~="player") then return end
    if (not matchingDimension) then return end
    if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
	if (getPedOccupiedVehicle(hitElement)) then return end
	--if getPlayerName(hitElement) ~="XJMLN" then outputChatBox("Na ekranie syreny wyświetla się komunikat: AWARIA...",hitElement) return false end
	local fr = getElementData(hitElement,"faction:data")
	if (not fr or fr and fr.id~=3) then outputChatBox("Nie pracujesz jako strażak!",hitElement) return false end
           triggerClientEvent(hitElement, "openGUI",hitElement)
end
addEventHandler( "onMarkerHit", myMarker, MarkerHit)

