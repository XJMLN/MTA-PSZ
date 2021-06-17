addEventHandler("onClientColShapeHit", resourceRoot, function(el, md)
	if (el==localPlayer and md and not getPedOccupiedVehicle(localPlayer)) then 
		if (getPlayerName(el)~="XJMLN") then return end
		local dane = getElementData(source,"sklep")
		if (dane) then 
			if (tonumber(dane.zamkniety)>0 and not getPlayerName(el) == "XJMLN") then 
				outputChatBox("Sklep jest zamknięty.",255,0,0)
				return
			end
			
			triggerServerEvent("movePlayerToInterior", resourceRoot, localPlayer, dane)
		end
	end
end)