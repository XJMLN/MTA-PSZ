function initDrawtagBC()
	addEventHandler("drawtag:onTagStartSpray",root,function(player)
		outputDebugString(identifyPlayer(player).." started spraying a tag.")
	end)

	addEventHandler("drawtag:onTagFinishSpray",root,function(player)
		outputDebugString(identifyPlayer(player).." finished spraying a tag.")
	end)

	addEventHandler("drawtag:onTagStartErase",root,function(player)
		outputDebugString(identifyPlayer(player).." started erasing a tag.")
	end)

	addEventHandler("drawtag:onTagFinishErase",root,function(player)
		outputDebugString(identifyPlayer(player).." finished erasing a tag.")
	end)
end
addEventHandler("onResourceStart",resourceRoot,initDrawtagBC)

addCommandHandler("xxdrawtag",function(source)
        local level = getElementData(source,"level")
        if not level or level and level~=3 then
            outputChatBox(" ╭∩╮( ͡° ͜ʖ ͡°)╭∩╮",source)
            return
        end
	exports.drawtag:setPlayerSprayMode(source,"draw")
	outputChatBox("Spraying mode: draw",source)
end)

addCommandHandler("xxerasetag",function(source)
        local level = getElementData(source,"level")
        if not level or level and level~=3 then
            outputChatBox(" ╭∩╮( ͡° ͜ʖ ͡°)╭∩╮",source)
            return
        end
	exports.drawtag:setPlayerSprayMode(source,"erase")
	outputChatBox("Spraying mode: erase",source)
end)

function identifyPlayer(player)
	return player and getPlayerName(player) or "Unknown player"
end

