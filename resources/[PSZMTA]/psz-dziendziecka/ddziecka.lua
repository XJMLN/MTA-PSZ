dziendziecka = true

local dzien_dziecka_loc = {
	--{2240.42,-72.21,26.50,359,id=218,2240.23,-70.06,25.6}, -- PC cmentarz
	--{-2273.89,533.18,35.02,270, id=219, -2271.82,533.16,34.3}, -- SF stacja
	--{389.39,-1525.02,32.27,38.4, id=220, 388.27,-1524.06,31.3}, -- LS Rodeo
	--{2322.61,2394.16,10.82,92.7, id=221, 2320.14,2394.15,10}, -- LV komi

}

for i,v in ipairs(dzien_dziecka_loc) do
	v.obj = createObject(3533, v[1],v[2],v[3]-5)
		setElementFrozen(v.obj,true)

	v.ped = createPed(v.id,v[1],v[2],v[3]+1,v[4])
		setElementFrozen(v.ped,true)
		setElementData(v.ped,"npc",true)
		setElementData(v.ped,"name","Ukryty skin")
		v.blip = createBlip(v[1],v[2],v[3],12,2,255,0,0,255,0,99999)
	v.marker = createMarker(v[5],v[6],v[7],"cylinder",1, 255,255,255,120)
		setElementData(v.marker,"marker:halloween",true)
		setElementData(v.marker,"skin:id",v.id)
		v.t3d = createElement('text')
			setElementPosition(v.t3d,v[5],v[6],v[7]+1.5)
			setElementData(v.t3d, "text","Skin świąteczny")
end

addEventHandler("onMarkerHit",resourceRoot,function(hitElement,matchingDimension)
   	if (getElementType(hitElement)~="player") then return end
    if (not matchingDimension) then return end
    if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
    if (getPedOccupiedVehicle(hitElement)) then return end
    if getElementData(source,"marker:halloween") then 
    	local sid = getElementData(source,"skin:id")
    	setElementModel(hitElement,sid)
    	local uid = getElementData(hitElement,"auth:uid")
    	if (not uid) then return end
    	exports['psz-mysql']:zapytanie(string.format("UPDATE psz_postacie SET skin=%d WHERE userid=%d LIMIT 1",sid,uid))
    	outputChatBox("Odebrałeś specjalny skin, na mapie są ukryte jeszcze inne skiny - znajdź je. :-)",hitElement,0,255,120)

    end
end)
--[[
addEvent("onPlayerHitMarkerEvent",true)
addEventHandler("onPlayerHitMarkerEvent",root,function(uid)
	if (not uid) then return end
	local q = string.format("SELECT type FROM psz_eventy WHERE uid=%d",uid)
	local wynik = exports['psz-mysql']:pobierzWyniki(q)
	if (wynik and wynik.type and wynik.type~=3) then 
		outputChatBox("Odebrałeś już nagrodę.",source,255,0,0)
	elseif(wynik and wynik.type and wynik.type==3) then 
		outputChatBox("Odebrano pojazd RC Baron, miłej zabawy! :-)",source,0,255,120)
		for i,v in ipairs(getElementsByType("vehicle")) do
			if getElementModel(v) == 464 and getElementData(v,"event:rc") == source then 
				destroyElement(v)
			end
		end
		local veh = createVehicle(464,-87.01,1075.54,19.74)
			setElementData(veh,"event:rc",source)
			warpPedIntoVehicle(source,veh)
	elseif(not wynik) then 
		triggerClientEvent(source,"onServerReturnData",resourceRoot,true)
	end
end)

addEvent("onPlayerTakeThing",true)
addEventHandler("onPlayerTakeThing",root,function(type)
	local uid = getElementData(source,"auth:uid") or 0 
	if (not uid) then return end
	local q
	q = string.format("SELECT type FROM psz_eventy WHERE uid=%d",uid)
	local wynik = exports['psz-mysql']:pobierzWyniki(q)
	if (wynik and wynik.type) then outputChatBox("Odebrałeś już prezent!",source,255,0,0) return end

	--if type == 1 then 
		--q = string.format("UPDATE psz_players SET vip = IF(vip>NOW(),vip,NOW())+INTERVAL 7 DAY WHERE id=%d",uid)
		--exports['psz-mysql']:zapytanie(q)
		---q = string.format("INSERT INTO psz_eventy SET uid=%d, type=1, ts=NOW()",uid)
		--exports['psz-mysql']:zapytanie(q)

		--local pz = getElementData(source,"PZ")
		--pz = pz + 20
		--setElementData(source,"PZ",pz)
		--setElementData(source,"vip",true)
		--outputChatBox("Twoje konto VIP zostało przedłużone",source)
	if type == 2 then 
		q = string.format("INSERT INTO psz_eventy SET uid=%d, type=2, ts=NOW()",uid)
		exports['psz-mysql']:zapytanie(q)
		
		local pz = getElementData(source,"PZ")
		pz = pz + 20
		setElementData(source,"PZ",pz)
		givePlayerMoney(source,1000)
		
		outputChatBox("Otrzymałeś $1000.",source)
	elseif type == 3 then
		q = string.format("INSERT INTO psz_eventy SET uid=%d, type=3, ts=NOW()", uid)
		exports['psz-mysql']:zapytanie(q)

		local pz = getElementData(source,"PZ")
		pz = pz + 20
		setElementData(source,"PZ",pz)
		for i,v in ipairs(getElementsByType("vehicle")) do
			if getElementModel(v) == 464 and getElementData(v,"event:rc") == source then 
				destroyElement(v)
			end
		end
		local veh = createVehicle(464,-87.01,1075.54,19.74)
			setElementData(veh,"event:rc",source)
			warpPedIntoVehicle(source,veh)
		outputChatBox("Odebrano pojazd RC Baron, miłej zabawy! :-)",source,0,255,120)
		outputChatBox("Wróć tutaj aby odebrać ponownie pojazd.",source,0,255,120)
	end

end)
]]--