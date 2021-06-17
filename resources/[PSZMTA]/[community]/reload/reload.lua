function forceReload(p)
	reloadPedWeapon (p)
end

function bindReloadForAllPlayers()
	for k,v in ipairs(getElementsByType("player")) do
		bindKey(v,"r","down",forceReload)
	end
end
addEventHandler("onResourceStart",resourceRoot,bindReloadForAllPlayers) 


addEventHandler("onPlayerJoin",getRootElement(),function()
	bindKey(source,"r","down",forceReload)
end)