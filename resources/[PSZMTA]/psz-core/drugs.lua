--[[

Core - drugs

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local function drugProcess()
	for i,v in ipairs(getElementsByType("player")) do
		local drunkLevel=getElementData(v,"drunkLevel")
		if (drunkLevel) then
			drunkLevel=tonumber(drunkLevel)
			if (drunkLevel<1) then
				removeElementData(v, "drunkLevel")
			else
--				outputDebugString("zmniejszanie " .. getPlayerName(v))
				drunkLevel=drunkLevel-1
				setElementData(v, "drunkLevel", drunkLevel)
			end
		end
		local joint=getElementData(v,"joint")
		if (joint) then
			-- regeneracja HP
			local hp=getElementHealth(v)
			hp=hp+math.random(5,10)
			if (hp>100) then hp=100 end
			setElementHealth(v, hp)
		end
	end
end

setTimer(drugProcess, 30000, 0)