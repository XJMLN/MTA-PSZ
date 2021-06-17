--[[

Admin - komendy oraz funkcje dla administratorow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
@package PSZMTA.psz-admin
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--


local klatki = {}
local worek = {placed = false} -- placed, pos, by
local e_veh = {
		{3094.26,68.02,57.24,262.4},
		{3094.76,62.39,57.24,284.8},
		{3096.47,57.18,57.24,301.5},
		{3099.15,52.89,57.24,321.0},
		{3103.26,49.51,57.24,334.6},
		{3108.67,47.03,57.24,0.3},
		{3113.40,46.91,57.24,7.9},
		{3118.91,47.87,57.24,30.6},
		{3123.29,50.31,57.25,40.3},
		{3127.49,54.87,57.24,57.0},
		{3095.17,72.77,57.24,247.7},
		{3098.26,77.41,57.24,233.6},
		{3102.58,80.94,57.24,208.6},
		{3129.73,58.80,57.24,67.5},
		{3107.69,82.93,57.24,190.9},
		{3130.55,63.36,57.24,85.4},
		{3113.44,83.22,57.24,171.8},
		{3130.90,68.72,57.24,109.0},
		{3118.52,82.75,57.25,165.8},
		{3129.35,73.02,57.24,111.8},
		{3122.92,80.49,57.24,152.2},
		{3126.02,76.89,57.24,131.0},
}
local function klatka_remove(who)
	if who and klatki[who] then 
		for i,v in pairs(klatki[who]) do
			destroyElement(v)
		end
		klatki[who] = nil
	end
end

function cmd_klatka(plr,cmd)
	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end
	if klatki[plr] then
		klatka_remove(plr)
	end

	local x,y,z = getElementPosition(plr)
	local int = getElementInterior(plr)
	local dim = getElementDimension(plr)
	local klatki_pos = {
		pozycje = {
			sciana_dol = {x, y, z -0.9, 90, 0, 0},
			sciana_pl = {x, y-3.6, z+2.7, 0, 0, 0},
			sciana_lp = {x, y+3.6, z+2.7, 0, 0, 0},
			sciana_prawa = {x+4.4, y, z+2.7, 0, 0, 90}, 
			sciana_lewa = {x-4.4, y, z+2.7, 0, 0, 90}, 
			sciana_gora = {x, y, z+6.3, 90, 0, 0},
		}
	}

	for i,v in pairs(klatki_pos) do
		if v.sciana_dol then 
			v.sciana_dol = createObject(971, v.sciana_dol[1], v.sciana_dol[2], v.sciana_dol[3], v.sciana_dol[4], v.sciana_dol[5],v.sciana_dol[6])
			setElementInterior(v.sciana_dol,int)
			setElementDimension(v.sciana_dol,dim)
			setElementData(v.sciana_dol,"klatka_adm",true)
			if v.sciana_gora then
				v.sciana_gora = createObject(971, v.sciana_gora[1], v.sciana_gora[2], v.sciana_gora[3], v.sciana_gora[4], v.sciana_gora[5], v.sciana_gora[6])
				setElementInterior(v.sciana_gora,int)
				setElementDimension(v.sciana_gora,dim)
				setElementData(v.sciana_gora,"klatka_adm",true)
				if v.sciana_pl then 
					v.sciana_pl = createObject(971, v.sciana_pl[1], v.sciana_pl[2], v.sciana_pl[3], v.sciana_pl[4], v.sciana_pl[5],v.sciana_pl[6])
					setElementInterior(v.sciana_pl,int)
					setElementDimension(v.sciana_pl,dim)
					setElementData(v.sciana_pl,"klatka_adm",true)
					if v.sciana_lp then 
						v.sciana_lp = createObject(971, v.sciana_lp[1], v.sciana_lp[2], v.sciana_lp[3], v.sciana_lp[4], v.sciana_lp[5], v.sciana_lp[6])
						setElementInterior(v.sciana_lp,int)
						setElementDimension(v.sciana_lp,dim)
						setElementData(v.sciana_lp,"klatka_adm",true)
						if v.sciana_prawa then
							v.sciana_prawa = createObject(971, v.sciana_prawa[1], v.sciana_prawa[2], v.sciana_prawa[3], v.sciana_prawa[4], v.sciana_prawa[5], v.sciana_prawa[6])
							setElementInterior(v.sciana_prawa,int)
							setElementDimension(v.sciana_prawa,dim)
							setElementData(v.sciana_prawa,"klatka_adm",true)
							if v.sciana_lewa then 
								v.sciana_lewa = createObject(971, v.sciana_lewa[1], v.sciana_lewa[2], v.sciana_lewa[3], v.sciana_lewa[4], v.sciana_lewa[5], v.sciana_lewa[6])
								setElementInterior(v.sciana_lewa,int)
								setElementDimension(v.sciana_lewa,dim)
								setElementData(v.sciana_lewa,"klatka_adm",true)
							end
						end
					end
				end
			end
		end


		klatki[plr] = {v.sciana_dol, v.sciana_pl, v.sciana_prawa, v.sciana_lp, v.sciana_lewa, v.sciana_gora}
		exports['psz-admin']:adminView_add(string.format("KLATKA> %s, tworzy klatkę na pozycji: %.2f,%.2f,%.2f",getPlayerName(plr), x, y, z),2)
		outputChatBox('► Klatka została stworzona.', plr, 0,255,0)
	end
end

addCommandHandler("klatka",cmd_klatka)
addCommandHandler("rklatka",klatka_remove)

function klatkaAll_remove(plr,cmd)
	local level = getElementData(plr,"level") or 0
	if (level and level~=3) then return end

	local objs = getElementsByType("object", getResourceRootElement())
	local l = 0

	for i,v in ipairs(objs) do
		if getElementData(v,"klatka_adm") then
			destroyElement(v)
			l = l + 1
		end
	end
	klatki = {}
	outputChatBox(string.format("Usunięto %d klatek z mapy.",tonumber(l)/6),plr,255,0,0)
	l = 0
end
addCommandHandler("restart.kl",klatkaAll_remove)

function cage_checker()
    local level = getElementData(source,"level") or 0
    if (level and level<1) then return end 
	
   if klatki[source] then 
	for i,v in pairs(klatki[source]) do
		destroyElement(v)
	end
	klatki[source] = nil
   end
end

function cmd_zheal(plr,cmd,range)
	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end
	if (not range) then 
		outputChatBox("Użyj: /zheal <zasięg>",plr)
		return
	end
	if (tonumber(range)>50) then 
		outputChatBox("Maksymalny zasięg to 50 metrów!",plr,255,0,0)
		return
	end
	
	local x, y, z = getElementPosition(plr)
	local d = getElementDimension(plr)
	local int = getElementInterior(plr)

	local strefa = createColSphere(x,y,z,range)
	setElementDimension(strefa,d)
	setElementInterior(strefa,int)

	local gracze = getElementsWithinColShape(strefa, "player")
	for i,v in ipairs(gracze) do
		if (getElementInterior(v) == int and getElementDimension(v)==d) then 
			setElementHealth(v,100)
			outputChatBox(string.format("* Zostałeś uleczony przez %s",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")),v)
		end
	end

	destroyElement(strefa)
	exports['psz-admin']:adminView_add(string.format("ZHEAL> %s, pozycja: %.2f, %.2f, %.2f, range %d",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""),x,y,z,range),2)
	outputChatBox("► Uleczono graczy w obrębie "..range.." metrów.",plr,255,0,0)
end
addCommandHandler("zheal",cmd_zheal)

function cmd_rozbroj(plr,cmd,range)
	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end
	if (not range) then
		outputChatBox("Użyj: /rozbroj <zasięg>",plr)
		return
	end
	if (tonumber(range)>50) then 
		outputChatBox("Maksymalny zasięg to 50 metrów!",plr,255,0,0)
		return
	end

	local x, y, z = getElementPosition(plr)
	local d = getElementDimension(plr)
	local int = getElementInterior(plr)

	local strefa = createColSphere(x,y,z,range)
	setElementDimension(strefa,d)
	setElementInterior(strefa,int)

	local gracze = getElementsWithinColShape(strefa, "player")
	for i,v in ipairs(gracze) do
		if (getElementInterior(v) == int and getElementDimension(v)==d) then 
			takeAllWeapons(v)
			outputChatBox(string.format("* Zostałeś rozbrojony przez %s.",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")),v)
		end
	end

	destroyElement(strefa)
	exports['psz-admin']:adminView_add(string.format("ZROZBROJ> %s, pozycja: %.2f, %.2f, %.2f, range %d",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""),x,y,z,range),2)
	outputChatBox("► Rozbrojono graczy w obrębie "..range.." metrów.",plr,255,0,0)
end
addCommandHandler("rozbroj",cmd_rozbroj)

function cmd_worek(plr,cmd, ...)
	local level = getElementData(plr,"level") or 0
	if (level and level~=3) then return end

	local description = table.concat(arg, " ")
	
	if (not description) then 
		outputChatBox("Użyj: /worek <wskazówka>",plr)
		return
	end

	if worek and worek.placed then  
		outputChatBox("Najpierw ktoś musi zebrać poprzedni worek z pieniędzmi, wskazówka: "..worek.description..".",plr,255,0,0)
		return
	end

	local x,y,z = getElementPosition(plr)
	local dim = getElementDimension(plr)
	local int = getElementInterior(plr)

	local rrz=math.rad(tonumber(177)+180)
	local x2= tonumber(x + (2 * math.sin(-rrz)))
	local y2= tonumber(y + (2 * math.cos(-rrz)))

	worek.object = createPickup(x2,y2,z,3,1550,100)
	worek.cs = createColSphere(x2,y2,z,0.5)
	worek.placed = true
	worek.by = plr
	worek.description = description

	setElementInterior(worek.cs,int)
	setElementDimension(worek.cs,dim)
	setElementInterior(worek.object,int)
	setElementDimension(worek.object,dim)


	outputChatBox("Administrator "..string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")..", zgubił worek pełny pieniędzy.",getRootElement(),255,0,0)
	outputChatBox("Wskazówka: "..description..".",getRootElement(),255,0,0)
	exports['psz-admin']:adminView_add(string.format("WOREK> %s, pozycja: [%d,%d,%d int:%d, dim:%d], wskazówka: %s",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""),x,y,z,int,dim,description))


	addEventHandler("onColShapeHit", worek.cs, function(he, md)
		if (not worek.placed and not worek.cs) then return end
		if (getElementType(he) ~= "player") then return end
		if ((getElementInterior(source) ~= getElementInterior(he)) or (getElementDimension(source) ~= getElementDimension(he))) then return end

		destroyElement(worek.cs)
		destroyElement(worek.object)
		
		worek = {}
		worek.placed = false

		local reward = math.random(450, 1250);
		outputChatBox("Gracz "..string.gsub(getPlayerName(he),"#%x%x%x%x%x%x","").." odnajduje zgubiony worek. W środku worka znajduje $"..reward..".",getRootElement(),255,0,0)
		givePlayerMoney(he,reward)
	end)
end
addCommandHandler("worek",cmd_worek)

local function bannedWeapons(v)
	local banned = {22,35,36,37,38,16,17,18,39,40}
	for i,v2 in ipairs(banned) do
		if v2 == v then return true end
	end
	return false
end
addCommandHandler("daj.bron",function(plr, cmd, cel, ...)
	
    if (not cel) then 
        outputChatBox("Użyj: /daj.bron <nick/id> <id broni>",plr)
        return
    end
    local target = findPlayer(plr,cel)
    
    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!",plr)
        return
    end
    
    local lvl = getElementData(plr,"level") or 0
    if (lvl and lvl<1) then return end 

    local args = { ... }
    for i,v in ipairs(args) do
        weapID = tonumber(v)
        if (weapID and (weapID<1 or weapID>46)) then
            outputChatBox("Podano złe ID broni.",plr,255,0,0)
            return 
        end
        
        if (bannedWeapons(weapID)) then 
            outputChatBox("Tej broni nie możesz nadać.",plr,255,0,0)
            return
        end
        local ammo = 99999
        if (weapID == 0 or weapID == 1 or weapID == 10 or weapID == 11 or weapID == 12) then 
        	ammo = 1 
        end

        giveWeapon(target, tonumber(weapID), ammo, true)
        adminView_add("ADM-daj.bron> "..getPlayerName(plr)..", spawnuje broń: "..weapID..", dla gracza: "..getPlayerName(target),2)
            local n_target = string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")
        outputChatBox("Nadano broń o id "..tonumber(weapID)..", graczu "..n_target..".",plr,0,255,0)
    end
end, true, false)

local function isValidZSkin(id)
	if id == 91 or id == 58 then return false end
	return true
end
function cmd_zskin(plr,cmd, range, skin)
	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end
	if (not range or not skin) then
		outputChatBox("Użyj: /zskin <zasięg> <id skina>",plr)
		return
	end
	if (tonumber(range)>50) then 
		outputChatBox("Maksymalny zasięg to 50 metrów!",plr,255,0,0)
		return
	end
	skin = tonumber(skin)
	if (isValidZSkin(skin)) then 
		outputChatBox("Nie możesz ustawić innego skina niż 91 lub 58.",plr,255,0,0)
		return
	end

	local x, y, z = getElementPosition(plr)
	local d = getElementDimension(plr)
	local int = getElementInterior(plr)

	local strefa = createColSphere(x,y,z,range)
	setElementDimension(strefa,d)
	setElementInterior(strefa,int)

	local gracze = getElementsWithinColShape(strefa, "player")
	
	for i,v in ipairs(gracze) do
		if (getElementInterior(v) == int and getElementDimension(v)==d) then 
			setElementModel(v,skin)
		end
	end

	destroyElement(strefa)
	exports['psz-admin']:adminView_add(string.format("ZSKIN> %s, pozycja: %.2f, %.2f, %.2f, range %d, skin ID %d",string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""),x,y,z,range, skin),2)
	outputChatBox("► Zmieniono wygląd dla graczy w obrębie "..range.." metrów.",plr,255,0,0)
end
addCommandHandler("zskin",cmd_zskin,true,false)

auta = {}

local function ev_usunAuto(id)
	if isElement(auta[id].veh) then destroyElement(auta[id].veh) end
	auta[id]=nil
end

local function ev_spawnVehicle(v,i)
	if auta[i] then
		ev_usunAuto(i)
	end

	v.veh = createVehicle(444,v[1],v[2],v[3])
	setElementRotation(v.veh,0,0,v[4])
	setElementInterior(v.veh,12)
	setElementDimension(v.veh,121) 
	setElementData(v.veh,"vehicle:event", true)
	local dbid=i
	i = nil
	auta[dbid] =v
	return true
end

function cmd_evdd(plr,cmd, ilosc)
	if (not ilosc) then 
		outputChatBox("Użyj /evdd <ilość>",plr)
		return 
	end

	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end

	ilosc=tonumber(ilosc)
	if (ilosc>#e_veh) then 
		outputChatBox("Nie możesz stworzyć tylu pojazdów, maksymalna ilość: "..#e_veh..".",plr)
		return
	end
	if (ilosc and ilosc>0) then 
		i = 0
		for __,v in ipairs(e_veh) do
			if i == ilosc then return end
				if ev_spawnVehicle(v,i) then 
					i = i + 1
				end
		end
	end
end
addCommandHandler("evdd",cmd_evdd,true,false)

function cmd_evddel(plr)
	local level = getElementData(plr,"level") or 0
	if (level and level<1) then return end

	for i=0,#auta do
		ev_usunAuto(i)
	end

	outputChatBox("Usunięto stworzone pojazdy.",plr)
end
addCommandHandler("evdd.usun",cmd_evddel,true,false)

addEventHandler("onPlayerQuit",getRootElement(),cage_checker)
