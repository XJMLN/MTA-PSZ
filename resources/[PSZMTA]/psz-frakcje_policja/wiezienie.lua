--[[

Frakcja: Policja - wiezienie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-frakcje_policja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local I=10
local D=0

local lapaczcs=createColCuboid(225.50,116.52, 998.02,2,1.75,2)
setElementInterior(lapaczcs,I)
setElementDimension(lapaczcs,D)

addEventHandler("onColShapeHit", lapaczcs, function(el,md)
        if (not md) then return end
        if (getElementType(el)~="player") then return end
        setElementPosition(el,219.29,109.29,999.02)
        outputChatBox("Przeniosłeś siebie do celi. Aby z niej wyjść wpisz /wyjscie",el)
        setElementData(el,"player:cela",true)
    end,false)


function tp(thePlayer)
    if (getElementData(thePlayer,"player:cela")) then
        outputChatBox("Opuszczasz celę.",thePlayer)
        setElementPosition(thePlayer,220.43,113.54,999.02)
        removeElementData(thePlayer,"player:cela")
    else
        outputChatBox("Nie jesteś w celi.",thePlayer)
end
    end
addCommandHandler("wyjscie",tp)
