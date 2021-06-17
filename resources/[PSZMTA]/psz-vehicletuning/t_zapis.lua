--[[
Tuning - zapis zmodyfikowanego pojazdu

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local pozycje_garazy =  {
    sf_doherty = {
        s_cuboid={-2032.24, 118.69, 28, 5.25, 11, 4.75}, -- cuboid odbierania pojazdow 
        l_cuboid={-2027.19, 118.69, 28,5.25,11,4.75},
        marker_save={-2026.92,130.08,27.8}, -- cuboid zabierania pojazdow
        mpos={-2032.51,129.95,27.8}, -- pozycja markera
    },
}
for i,v in pairs(pozycje_garazy) do
    v.cs_load = createColCuboid(unpack(v.s_cuboid))
    v.marker = createMarker(v.mpos[1], v.mpos[2], v.mpos[3], "cylinder", 1, 0,0,0,100)
    v.marker_save = createMarker(v.marker_save[1],v.marker_save[2],v.marker_save[3],"cylinder", 1, 255, 150, 50, 100);
    v.cs_save = createColCuboid(unpack(v.l_cuboid))
    setElementData(v.marker, "cs_load", v.cs_load)
    setElementData(v.marker_save, "cs_save", v.cs_save)
end

local function bannedVehicle(v)
	local banned = {592,577,511,512,593,520,553,476,519,460,513,548,425,417,487,488,497,563,447,469,472,473,493,595,484,430,453,452,446,454,485,574,420,525,408,552,416,433,427,490,528,407,544,523,470,596,598,599,597,432,601,428,524,532,486,406}
	for i,v2 in ipairs(banned) do
		if v2 == v then return true end
	end
	return false
end
--Wczytywanie/Usuwanie pojazdow
function tsave_getUserData(uid)
	if (not uid) then return end
	local q = string.format("SELECT sv.id, sv.model, sv.saved_by FROM psz_saved_vehicle sv WHERE sv.saved_by=%d",tonumber(uid));
	local wynik = exports['psz-mysql']:pobierzTabeleWynikow(q)
	if (wynik and #wynik>0) then 
		triggerClientEvent("tsave_sendUserData", source, wynik) 
	elseif (wynik and #wynik<1) then 
		triggerClientEvent("tsave_sendUserData", source, nil)
	end
end

function tsave_spawnPlayerVeh(vid)
	if (not vid) then return end
	local pid = getElementData(client, "auth:uid") or 0 
	if (pid and tonumber(pid)==0) then return end

	local q = string.format("SELECT sv.id,sv.model, sv.saved_by, sv.neony, sv.upgrades, sv.headlightcolor, sv.c1, sv.c2, sv.c3, sv.c4, sv.tablica, sv.washed, sv.paintjob FROM psz_saved_vehicle sv WHERE sv.saved_by=%d AND sv.id=%d",tonumber(pid),tonumber(vid))
	local wynik = exports['psz-mysql']:pobierzTabeleWynikow(q)
	if (wynik and #wynik>0) then
		if getPlayerMoney(client)<100 then 
			outputChatBox("Nie posiadasz 100$ - nie możesz wczytać pojazdu.",client,255,0,0)
			return
		end
		takePlayerMoney(client, 100)
		triggerEvent("tsave_spawnVehicle",root,client,wynik)
	else
		outputChatBox("Błąd podczas wczytywania danych, powiadom administratora.",source,255,0,0)
		return 
	end
end

function tsave_deletePlayerVeh(vid)
	if (not vid) then return end
	local pid = getElementData(client, "auth:uid") or 0
	if (pid and tonumber(pid)==0) then return end

	local q = string.format("DELETE FROM psz_saved_vehicle WHERE id=%d AND saved_by=%d",vid, pid)
	exports['psz-mysql']:zapytanie(q)

	outputChatBox("Pojazd został usunięty z listy zapisanych", client, 255,0,0)
end

-- Zapisywanie pojazdow 

function tsave_savePlayerVeh(veh)
	if (not veh) then return end
	local limit = 1

	local uid = getElementData(client, "auth:uid") or 0 
	if (uid and tonumber(uid)==0) then return end

	local vip = getElementData(client, "vip")
	if (vip) then 
		limit = 3 
	end

	local q= string.format("SELECT COUNT(*) ilosc FROM psz_saved_vehicle WHERE saved_by=%d",uid)
	local wynik = exports['psz-mysql']:pobierzWyniki(q)
	if (wynik.ilosc == limit or wynik.ilosc>limit) then 
		outputChatBox("Nie możesz zapisać więcej pojazdów.",client,255,0,0)
		return
	end
	if (getPlayerMoney(client)<2500) then 
		outputChatBox("Nie stać Ciebie na zapis pojazdu, wymagane $2500.",client,255,0,0)
		return
	end
	
	local model = getElementModel(veh)
	
	if (bannedVehicle(model)) then 
		outputChatBox("Tego pojazdu nie możesz zapisać!",client,255,0,0)
		return
	end
	local marka = getVehicleNameFromModel(model)
	local c11,c12,c13, c21,c22,c23, c31,c32,c33, c41,c42,c43 = getVehicleColor(veh,true)
	local hc1, hc2, hc3 = getVehicleHeadLightColor(veh)
    local vehUpgrades=getVehicleUpgrades(veh)
    if not vehUpgrades then vehUpgrades={} end
    local upgrades=(table.concat(vehUpgrades,","))
    local washed = getElementData(veh, "veh:clean") or 0
    local paintjob = getVehiclePaintjob(veh) or 0
    local tablica = getVehiclePlateText(veh)
    local neon = getElementData(veh,"neony") or 0 
	local q = string.format("INSERT INTO psz_saved_vehicle SET model=%d, marka='%s', saved_by=%d, upgrades='%s', headlightcolor='%.2f, %.2f, %.2f', c1=%d, c2=%d, c3=%d, c4=%d, tablica='%s', washed=%d, paintjob=%d,neony=%d, last_modified=NOW()",
		tonumber(model),tostring(marka), tonumber(uid), upgrades,hc1, hc2, hc3, c13+c12*256+c11*256*256, c23+c22*256+c21*256*256, c33+c32*256+c31*256*256, c43+c42*256+c41*256*256, tablica, washed, paintjob,neon)

	exports['psz-mysql']:zapytanie(q)

	destroyElement(veh)

	takePlayerMoney(client, 2500)
	outputChatBox("Pojazd został zapisany.",client,255,0,0)

end
addEvent("tsave_sendSavedData", true)
addEventHandler("tsave_sendSavedData", root, tsave_savePlayerVeh)
addEvent("tsave_verifyVehicle", true)
addEventHandler("tsave_verifyVehicle", root, tsave_spawnPlayerVeh)
addEvent("tsave_getUserData", true)
addEventHandler("tsave_getUserData", root, tsave_getUserData)
addEvent("tsave_deletePlayerVehicle", true)
addEventHandler("tsave_deletePlayerVehicle", root, tsave_deletePlayerVeh)
