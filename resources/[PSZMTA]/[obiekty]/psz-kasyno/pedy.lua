--[[

kasyno - NPC'ty

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
@package PSZMTA.psz-kasyno
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local I = 10
local D = 0

local ochroniarz1 = createPed(163,2004.86,1024.75,994.47,180,false)
setElementInterior(ochroniarz1, I)
setElementDimension(ochroniarz1, D)
setElementData(ochroniarz1, "npc", true)
setElementData(ochroniarz1, "name", "Ochroniarz")
setElementFrozen(ochroniarz1, true)