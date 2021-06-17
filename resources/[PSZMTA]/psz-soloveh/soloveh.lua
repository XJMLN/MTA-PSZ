--[[
]]--

function soloveh_sendRequestValidate(plr,cmd,cel)
	if (not cel) then 
		outputChatBox("Użycie: /pojedynek <id/nick>",plr)
		return 
	end

	local target = findPlayer(plr,cel)
	if (not target) then
		outputChatBox("Nie znaleziono gracza o podanym id/nicku.",plr)
		return
	end

	--if (target == plr) then 
	--	outputChatBox("Nie możesz wyzwać siebie na pojedynek.",plr)
	--	return
	--end
	local x,y,z = getElementPosition(plr)
	local strefa = createColSphere(x,y,z,15)
	local gracze = getElementsWithinColShape(strefa,"player")
	
	for i,v in ipairs(gracze) do
		if (getElementInterior(v)==getElementInterior(plr) and getElementDimension(v)==getElementDimension(plr)) then
			if (target == v) then 
				soloveh_sendRequest(plr,cel)
			else
				outputChatBox("Dany gracz musi być w pobliżu 15 metrów.",plr)
				destroyElement(strefa)
				return 
			end
		end
	end
	destroyElement(strefa)
end
addCommandHandler("pojveh",soloveh_sendRequestValidate)

function soloveh_sendRequest(plr,cel)
	local target = findPlayer(plr,cel)
	if (not target) then 
		outputChatBox("Pojedynek nie mógł się rozpocząć - gracz jest OFFLINE.",plr,255,0,0)
		return
	end

	if (getElementData(plr,"soloveh:deny_invite")) then 
		outputChatBox("Najpierw odblokuj możliwość zapraszania Ciebie do pojedynków samochodowych (/soloacc).",plr)
		return
	end

	if (getElementData(plr,"soloveh:active")) then
		outputChatBox("Najpierw ukończ aktualny pojedynek.",plr, 255,0,0)
		return
	end

	if (getElementData(target, "soloveh:active")) then
		outputChatBox("Gracz którego chcesz zaprosić, aktualnie przeprowadza pojedynek.",plr,255,0,0)
		return
	end

	if (getElementData(target,"soloveh:active_request")) then 
		outputChatBox("Gracz nie odpowiedział jeszcze na poprzednie zaproszenie.",plr,255,0,0)
		return
	end

	if (getElementData(plr,"soloveh:active_request")) then 
		outputChatBox("Nie odpowiedziałeś jeszcze na poprzednie zaproszenie.",plr,255,0,0)
		return
	end

	if (getElementData(target,"blokada:kary_aj") or getElementData(plr,"blokada:kary_aj")) then 
		outputChatBox("Ty lub gracz którego próbujesz zaprosić posiadacie aktywną karę AdminJail.",plr,255,0,0)
		return
	end

	if (getElementData(plr,"soloveh:active_select") or getElementData(target,"soloveh:active_select")) then 
		outputChatBox("Gracz nie ukończył aktualnego pojedynku.",plr,255,0,0)
		return
	end

	local pojazd1 = getPedOccupiedVehicle(plr)
	local pojazd2 = getPedOccupiedVehicle(target)
	if (not pojazd1 or not pojazd2) then 
		outputChatBox("Gracz którego chcesz zaprosić, musi być w pojeździe jako kierowca.",plr,255,0,0) 
		return
	end
	
	local kier1 = getVehicleController(pojazd1)
	local kier2 = getVehicleController(pojazd2)
	if (not kier1 or not kier2) then 
		outputChatBox("Gracz którego chcesz zaprosić, musi być w pojeździe jako kierowca.",plr,255,0,0) 
		return
	end

	outputChatBox("Zaproszenie zostało wysłane.",plr)
end