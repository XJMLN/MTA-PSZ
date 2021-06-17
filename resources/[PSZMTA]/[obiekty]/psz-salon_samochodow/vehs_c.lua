addEventHandler("onClientColShapeHit",root, function(el,md) 
	if not md or el~=localPlayer then return end
	if not getElementData(source,"sveh:pickup") then return end
	if getPedOccupiedVehicle(localPlayer) then return end

	local veh = getElementData(source,"sveh:pickup_veh")
	if not veh then return end
	local args = getElementData(veh,"sveh:zakup")
	local c = getElementData(localPlayer,"character")
	if (not c or not c.id) then return end

	if (not c.gg_rank_id or tonumber(c.gg_rank_id)<3) then 
		outputChatBox("Nie jesteś członkiem gangu lub posiadasz zbyt niską rangę aby zakupić pojazd.",255,0,0)
		return
	end
	outputChatBox("* Aby zakupić pojazd #257BC2"..getVehicleNameFromModel(args.model).."#FFFFFF za cenę #257BC2"..args.cena.."#FFFFFF$, wpisz /kup.",255,255,255,true)
	setElementData(localPlayer,"tmp_sveh",args)
	setElementData(localPlayer,"tmp_spick",source)
end)


addCommandHandler("kup",function()
	if not getElementData(localPlayer,"tmp_sveh") then return end
	if isElementWithinColShape(localPlayer,getElementData(localPlayer,"tmp_spick")) then 
		local args = getElementData(localPlayer,"tmp_sveh")
		triggerServerEvent("onPlayerBuyVehicle",localPlayer, args)
	else
		setElementData(localPlayer,"tmp_spick",nil)
		setElementData(localPlayer,"tmp_sveh",nil)
	end
end)

