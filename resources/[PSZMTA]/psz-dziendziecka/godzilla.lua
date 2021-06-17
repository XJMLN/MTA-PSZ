function startup(plr)
	if getPlayerName(plr) ~= "XJMLN" then return end
		local godziu = exports['slothBot']:spawnBot(-1728.03,925.01,24.74,90,221,0,0,nil,38,"hunting",true)
	exports['ehc']:setElementExtraHealth(godziu,10000)
end
addCommandHandler("xxxGodziuxxx",startup)


function nagroda(kto)
	if source == godziu then 
		outputChatBox("Ostateczny pocisk wysyła gracz "..getPlayerName(kto)..", gratulacje dla wszystkich pomocników!",getRootElement(),255,0,0,true)
		givePlayerMoney(getRootElement(),1500)
	end
end
addEvent("onBotWasted",true)
addEventHandler("onBotWasted",getRootElement(), nagroda)