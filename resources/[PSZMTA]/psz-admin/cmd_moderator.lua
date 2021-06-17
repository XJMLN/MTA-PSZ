--[[
psz-admin : różne funkcje admina
====
Główny twórca tego kodu to Wielebny<Wielebny@bestplay.pl>, kod jest dostępny na jego githubie.
Ta wersja została przerobiona pod serwer CraftBos. Zakaz kopiowania tej wersji.
===
@author jack. <jack@craftbos.pl>
@copyright 2015-2016 jack. <jack@craftbos.pl>
]]--


function isInvisibleAdmin(plr)
    local accName = getAccountName ( getPlayerAccount ( plr ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ) ) and getElementData(plr,"admin:ninja") then
        return true
    end
    return false
end

function cmd_tt ( player, command, target )
    local plr = findPlayer ( player, target )
    if (not plr) then
        outputChatBox("Nie znaleziono gracza o nicku " .. target,player )
        return
    end
    local x,y,z = getElementPosition( plr )
    if (isPedInVehicle(player)) then
        removePedFromVehicle(player)
    end
    setPedAnimation(player)
    setElementAlpha(player,0)
    setElementDimension(player, getElementDimension(plr))
    setElementInterior(player, getElementInterior(plr))
    setElementPosition ( player, x+math.random(-3,3), y+math.random(-3,3), z+math.random(0,3) )
    adminView_add("TT> "..getPlayerName(player)..", do: "..getPlayerName(plr).." pos: "..x..","..y..","..z..", dim:"..getElementDimension(plr)..", int: "..getElementInterior(plr),2)
end

addCommandHandler( "tt", cmd_tt,true,false )

function cmd_tp (player, command, target, target2)
    if (not target or not target2) then 
        outputChatBox("Użycie: /tp <kogo> <do kogo>",player)
        return
    end
	local plr = findPlayer (player,target)
	local plr2 = findPlayer (player,target2)
	if (not plr)  or (not plr2) then
		outputChatBox("Nie znaleziono podanego gracza.",player)
		return
	end
	local x,y,z = getElementPosition(plr2)
	if (isPedInVehicle(plr)) then
		removePedFromVehicle(plr)
	end
	setPedAnimation(plr)
	setElementInterior(plr, getElementInterior(plr2))
	setElementDimension(plr, getElementDimension(plr2))
	setElementPosition ( plr, x+math.random(-3,3), y+math.random(-3,3), z+math.random(0,3) )
	outputChatBox(getPlayerName(player).." przenosi Ciebie do gracza "..getPlayerName(plr2),plr,255,0,0)
	outputChatBox(getPlayerName(player).." przeniósł do Ciebie gracza "..getPlayerName(plr),plr2,255,0,0)
	outputChatBox("Przeniesiono gracza "..getPlayerName(plr).." do gracza "..getPlayerName(plr2),player,255,0,0)
    adminView_add("TP> "..getPlayerName(player)..", przenosi: "..getPlayerName(plr)..", do:"..getPlayerName(plr2),2)
end

addCommandHandler("tp", cmd_tp,true,false)

function cmd_stt ( player, command, target )
    local plr = findPlayer ( player, target )
    if (not plr) then
        outputChatBox("Nie znaleziono gracza o nicku " .. target,player )
        return
    end
    local x,y,z = getElementPosition( plr )
    if (isPedInVehicle(player)) then
        removePedFromVehicle(player)
    end
    setPedAnimation(player)
    setElementAlpha(player,0)
    setElementInterior(player, getElementInterior(v))
    setElementDimension(player, getElementDimension(v))
    setElementPosition ( player, x+math.random(-50,50), y+math.random(-50,50), z+math.random(0,1) )
    adminView_add("STT> "..getPlayerName(player)..", do: "..getPlayerName(v).." pos: "..x..","..y..","..z..", dim:"..getElementDimension(v)..", int: "..getElementInterior(v),2)
end

addCommandHandler( "stt", cmd_stt,true,false )

function cmd_th ( player, command, target )
    local plr = findPlayer ( player, target )
    if (not plr) then
        outputChatBox("Nie znaleziono gracza o nicku " .. target,player )
        return
    end
    local x,y,z = getElementPosition( player )
    if (isPedInVehicle(plr)) then
        removePedFromVehicle(plr)
    end
    setElementDimension(plr, getElementDimension(player))
    setElementInterior(plr, getElementInterior(player))
    setElementPosition ( plr, x+(math.random(-1,1)/5), y+(math.random(-1,1)/5), z+(math.random(0,10)/10) )
    adminView_add("TH> "..getPlayerName(plr)..", do: "..getPlayerName(player).." pos: "..x..","..y..","..z..", dim:"..getElementDimension(player)..", int: "..getElementInterior(player),2)
end

addCommandHandler( "th", cmd_th,true,false )

local function isValidSkin(s)
  local allSkins = getValidPedModels ( )
  for key, skin in ipairs( allSkins ) do -- Check all skins
      if skin == s then return true end
  end
  return false
end


local function isSkinPremium(s)
  if s==80 or s== 81 or s==82 or s==83 or s==84 or s==85 or s==120 or s==191 then return true end
  return false
end

function cmd_skin(plr,cmd,cel,skin)
	if (not skin or not cel) then
		outputChatBox("Użyj: /skin <id/nick> <id skinu>", plr)
		return
	end
	skin=tonumber(skin)

	--if (isCOSkin(skin)) then
	--	outputChatBox("Wybrany skin nalezy do organizacji przestepczej, zmiany moze dokonac lider tej organizacji.", plr)
	--	return
	---end

	if (isSkinPremium(skin)) then
	  outputChatBox("Wybrany skin to skin VIP. Gracz musi go zmienić sam.", plr)
	  return
	end

	if (not isValidSkin(skin)) then
	  outputChatBox("Podane ID skina jest nieprawidłowe.", plr)
	  return
	end



	local target=findPlayer(plr,cel)

	if (not target) then
		outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
		return
	end

	local uid=getElementData(target, "auth:uid")
	if (not uid) then
	    outputChatBox("Gracz nie jest zalogowany do gry", plr, 255,0,0,true)
	    return
	end
	local c=getElementData(target,"character")
	if (not c) then
		outputChatBox("Gracz jeszcze nie wybrał postaci.", plr, 255,0,0,true)
		return
	end

	c.skin = skin
    local supportLogin = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
	setElementData(target, "character", c)


	setElementModel(target, skin)
	local query=string.format("UPDATE psz_postacie SET skin=%d WHERE userid=%d LIMIT 1", skin, c.id)
	exports['psz-mysql']:zapytanie(query)
	gameView_add("ZMIANA SKINA "..supportLogin.." zmienił skin " .. getPlayerName(target).." na "..skin)
    adminView_add("SKIN> "..supportLogin.." zmienił skin ".. getPlayerName(target) .." na "..skin,2)
end

addCommandHandler("skin", cmd_skin, true, false)

function cmd_heal(plr,cmd, cel)
    if (not cel) then
        outputChatBox("Uzyj: /heal <id/nick>", plr)
        return
    end
    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end
    setElementHealth(target, 100)
    outputChatBox("Uleczono gracza " .. getPlayerName(target), plr)
    outputChatBox("(( Zostałeś uleczony/a. ))", target)
    adminView_add("HEAL>"..getPlayerName(plr)..", uzdrawia gracza: "..getPlayerName(target),2)
end

addCommandHandler("heal", cmd_heal, true, false)

function cmd_spec(plr,cmd, cel)
    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end
    removePedFromVehicle(plr)
    setElementInterior(plr, getElementInterior(target))
    setElementDimension(plr, getElementDimension(target))
    setElementPosition(plr, 3521.56,3520.72,12.85)
    setCameraTarget(plr, target)
    adminView_add("SPEC>"..getPlayerName(plr)..", spec gracza: "..getPlayerName(target),2)
end

addCommandHandler("spec", cmd_spec,true,false)


function cmd_specoff(plr,cmd)
    setElementPosition(plr, 3521.56,3520.72,12.85)
    setElementInterior(plr,0)
    setElementDimension(plr,0)
    setCameraTarget(plr,plr)
    adminView_add("SPECOFF> "..getPlayerName(plr),2)
end

addCommandHandler("specoff", cmd_specoff,true,false)


addCommandHandler("inv", function(plr)
        if (getElementAlpha(plr)>0) then
            setElementAlpha(plr,0)
            adminView_add("INV-ON>"..getPlayerName(plr),2)
        else
            setElementAlpha(plr,255)
            adminView_add("INV-OFF>"..getPlayerName(plr),2)
        end
    end, true, false)

function cmd_baj(plr,cmd,cel,czas,...)
    if (not cel or not czas) then
        outputChatBox("Użyj: /bAJ <id/nick> <czas w minutach> <powód>",plr)
        return
    end
    
    local target = findPlayer(plr,cel)
    
    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!",plr)
        return
    end
    
    local reason = table.concat( arg, " " )
    local uid=getElementData(target, "auth:uid")
    if (not uid) then
        outputChatBox("Gracz nie jest zalogowany do gry", plr, 255,0,0,true)
        return
    end
    
    local slogin=string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    if (not slogin) then
        outputChatBox("Nie jestes zalogowany!", plr)
        return
    end
    
    local kto=string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")

    if isInvisibleAdmin(plr) then
        slogin = "Konsola 23J"
    end
    
    local serial = getPlayerSerial(target)

    local auid= getElementData(plr, "auth:uid")
        if (not auid) then 
            outputChatBox("Nie jesteś zalogowany do gry.", plr, 255,0,0,true)
        return
    end

    if isPedDead(target) then
        outputChatBox("Podany gracz jest nie żywy, spróbuj za chwilę.", plr, 255, 0, 0, true)
        return
    end
    
    local q = string.format("INSERT INTO psz_kary SET id_player=%d, serial='%s', rodzaj='Admin Jail', date_end=NOW()+INTERVAL %d MINUTE, reason='%s', player_given=%d" ,uid ,serial ,czas ,reason,auid)
    exports['psz-mysql']:zapytanie(q)
    exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET blokada_aj=%d WHERE id=%d LIMIT 1", czas, uid))
    adminView_add("bAJ> "..kto..", powod: '".. reason.. "', przez:".. slogin,2)
    gameView_add("bAJ "..kto..", powod: '".. reason .."', przez: ".. slogin)
    outputConsole(slogin.." nałożył/a AJ ("..czas.." min) na: "..kto..", powód: "..reason)
    triggerClientEvent("gui_showOgloszenie", root, slogin.." nałożył/a AJ ("..czas.." min) na: "..kto..", powód: "..reason..".","Informacja o nadanej karze")

    outputChatBox("Trafiłeś do Admin Jail'a, powód:"..reason.." czas do odsiedzenia: "..czas.." min.",target,255,0,0)
    setElementData(target,"kary:blokada_aj",czas)
    removePedFromVehicle(target)
    setElementDimension(target,231)
    setElementInterior(target,0)
    setElementPosition(target,1775.42,-1574.87,1734.94)
end
addCommandHandler("baj", cmd_baj,true,false)

addCommandHandler("sp", function(plr,cmd)
        local pos={}
        pos[1],pos[2],pos[3]=getElementPosition(plr)
        pos[4]=getElementInterior(plr)
        pos[5]=getElementDimension(plr)
        setElementData(plr,"savedPosition", pos)
        outputChatBox("Pozycja została zapisana.", plr)
        zapis = string.format("%d, %d, %d, %d, %d",pos[1],pos[2],pos[3],pos[4],pos[5])
        adminView_add("SP> "..getPlayerName(plr)..", zapis: "..zapis,2)
        zapis=""
    end,true,false)

addCommandHandler("lp", function(plr,cmd)
        local pos=getElementData(plr, "savedPosition")
        if (not pos) then
            outputChatBox("Nie masz żadnej zapisanej pozycji.", plr)
            return
        end
        setElementAlpha(plr,0)
        setElementPosition(plr,pos[1],pos[2],pos[3])
        setElementInterior(plr,pos[4])
        setElementDimension(plr,pos[5])
        outputChatBox("Wczytano pozycję.", plr)
        zapis = string.format("%d, %d, %d, %d, %d",pos[1],pos[2],pos[3],pos[4],pos[5])
        adminView_add("LP> "..getPlayerName(plr)..", zapis: "..zapis,2)
        zapis = ""
    end,true,false)

function cmd_kick(plr,cmd,cel,...)
    if (not cel) then
        outputChatBox("Uzyj: /k[ick] <nick/id> [powod]",plr)
        return
    end
    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end

    local reason = table.concat( arg, " " )

        local slogin=string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
		 if (not slogin) then
        outputChatBox("Nie jestes zalogowany!", plr)
        return
    end
		local kto=string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")

    if isInvisibleAdmin(plr) then
        slogin = "Konsola 23J"
    end
    gameView_add("KICK "..kto..", powod: '".. reason .."', przez: ".. slogin)
    outputConsole(slogin.." wyrzucił/a gracza "..kto..", powód: "..reason)
    adminView_add("KICK> "..kto..", powod: '".. reason.. "', przez:".. slogin,2)--txt,lrodzaj
    triggerClientEvent("gui_showOgloszenie", root, "Gracz "..kto.." został/a wyrzucony/a przez "..slogin..". Powód: "..reason..".","Informacja o nadanej karze")
    kickPlayer ( target, plr, reason)



end

addCommandHandler("kick", cmd_kick, true, false)
addCommandHandler("k",cmd_kick,true,false)

function cmd_info(plr,cmd,cel)
	if (not cel) then
		outputChatBox("Uzyj: /pinfo <nick/id>",plr)
		return
	end
	local target=findPlayer(plr,cel)

	if (not target) then
		outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
		return
	end
	local id=getElementData(target,"id")
    
    outputChatBox("ID: ".. (id or "-") ..", nick: " .. getPlayerName(target), plr)
	local c=getElementData(target,"character")
	if (not c) then
		outputChatBox("Gracz nie dołączył jeszcze do gry, lub nie wybral jeszcze postaci", plr)
		return
	end
    local uid = getElementData(target,"auth:uid") or 0
	outputChatBox("Nick: " .. c.nick ..", UID: " .. uid .. ", skin: " .. getElementModel(target), plr)
  local login=getElementData(target,"auth:login")
  outputChatBox("Login: " .. login, plr)
    adminView_add("PINFO> "..getPlayerName(plr)..", info o: "..getPlayerName(target)..", UID: "..c.id,2)


end
addCommandHandler("pinfo", cmd_info, true, false)

function cmd_sluzby(plr,cmd)

  local frakcje = {
      {1,"Lekarze"},
      {2,"Policjanci"},
      {3,"Strażacy"},
      {4,"Reporterzy"},
      {5,"Mechanicy"},
      {6,"DJ'e"},
  }

  for i,v in ipairs(frakcje) do
	outputChatBox(v[1]..". ".. v[2],plr, 255,255,0)
	local t=""
	for _,player in ipairs(getElementsByType("player")) do
	  local f = getElementData(player,"faction:data")
	  if (f and f.id and tonumber(f.id) == tonumber(v[1])) then

		  t=t..string.gsub(getPlayerName(player),"#%x%x%x%x%x%x","").."("..getElementData(player,"id")..")"..", "
	  end
	  if (string.len(t)>60) then
		outputChatBox("  "..t, plr)
		t=""
	  end
	end
	if (string.len(t)>0) then
	  outputChatBox("  "..t, plr)
	end

  end
end
addCommandHandler("sluzby", cmd_sluzby, true, false)

addCommandHandler("dp", function(player,cmd)
        local veh = getPedOccupiedVehicle(player)
        if getElementData(veh,"damageproof") then outputChatBox("YES",player) else outputChatBox("NO",player) end

    end)
addCommandHandler("jp",function(plr,cmd)
    if (isPedInVehicle(plr)) then
        removePedFromVehicle(plr)
    end
    if (doesPedHaveJetPack(plr)) then
        removePedJetPack(plr)
            adminView_add("JP-OFF> "..getPlayerName(plr),2)
    else
            givePedJetPack(plr)
            adminView_add("JP-ON> "..getPlayerName(plr),2)
    end
end,true,false)

function cmd_bpracy(plr, cmd, cel, czas, jednostka, ...)
    local reason = table.concat( arg, " ")
    if (not cel or not czas or not jednostka) then 
        outputChatBox("Użyj: /bpracy <id/nick> <czas> <jednostka:m/h/d> <powód>",plr)
        return
    end

    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end

    jednostka=string.lower(jednostka)
    if (jednostka=="m") then
        jednostka="MINUTE"
    elseif (jednostka=="h" or jednostka=="g") then
        jednostka="HOUR"
    elseif (jednostka=="d") then
        jednostka="DAY"
    else
        outputChatBox("Uzyj: /bpracy <id/nick> <czas> <jednostka:m/h/d> <powod>", plr)
        outputChatBox("Jednostki: m - minuta, h - godzina, d - dzien", plr)
        return
    end

    czas=tonumber(czas)
    if (not czas or czas<1) then
        outputChatBox("Nieprawidlowy okres czasu.",plr)
        return
    end

    local userid=getElementData(target, "auth:uid")
    local q = string.format("INSERT INTO psz_kary SET id_player=%d, serial='%s',rodzaj='Blokada Pracy',date_created=NOW(),date_end=NOW()+INTERVAL %d %s, reason='%s', player_given=%d",userid, getPlayerSerial(target), czas, jednostka, reason, getElementData(plr,"auth:uid"))
    --removeElementData(target, "duty:dj")
    --removeElementData(target, "faction:id")
    local query = exports['psz-mysql']:zapytanie(q)
    if (not query) then 
        outputChatBox("Nie udało się wprowadzić kary do bazy danych.",plr)
        return
    end

    local slogin = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    if (not slogin) then
        outputChatBox("Nie jestes zalogowany!", plr)
        return
    end
    local kto=string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")

    if isInvisibleAdmin(plr) then
        slogin = "Konsola 23J"
    end
    setElementData(target, "banned_jobs", true)
    outputConsole("Gracz "..kto.." otrzymał/a blokadę pracy jako DJ,  przez "..slogin..".")
    outputConsole("Powód: ".. reason)
    triggerClientEvent("gui_showOgloszenie", root, "Gracz "..kto.." otrzymał/a blokadę pracy jako DJ, przez "..slogin..". Powód: "..reason..".","Informacja o nadanej karze")
    exports['psz-grupy']:grupy_quitJob('bpracy',target)
end 
addCommandHandler("bpracy", cmd_bpracy, true, false)


local MAXPZ = 15
local PZ_PER_M_DAY = 15
local PZ_PER_M_WEEK = 105
local PZ_PER_A_DAY = 20
local PZ_PER_A_WEEK = 140

function cmd_nadajpz(plr,cmd,cel,jednostka,...)
    local reason = table.concat(arg," ")
    if (not cel or not jednostka) then 
        outputChatBox("Użycie: /nadajpz <id/nick> <ilość> <powód>",plr)
        return
    end

    local auid = getElementData(plr,"auth:uid")
    if not auid then return end -- nie powinno sie wydarzyc

    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end
    jednostka = tonumber(jednostka)
    if (not jednostka or not tonumber(jednostka) or jednostka<1) then 
        return
    end

    if jednostka>MAXPZ then 
        outputChatBox("Maksymalna ilość PZ które możesz nadać naraz to "..MAXPZ..".",plr,255,0,0)
        return
    end

    local uid = getElementData(target,"auth:uid")
    do -- sprawdzenie czy gracz nie otrzymal pz w ciagu ostatniej pol godziny
        local lmt=exports['psz-mysql']:pobierzWyniki(string.format("select 1 from psz_achievements_history WHERE user_id=%d AND timediff(NOW(),ts)<'00:30:00' LIMIT 1",uid))
        if lmt then
            outputChatBox("Ten gracz otrzymał już punkty PZ w ciągu ostatniej pół godziny.", plr,255,0,0)
            return
        end
    end

    if (auid or 0)~=1 then 
        local lmt=exports['psz-mysql']:pobierzWyniki(string.format("select IFNULL(sum(amount),0) suma from psz_achievements_history where given_by=%d AND timediff(now(),ts)<'24:00:00';", auid))
        if lmt and lmt.suma then
            if getElementData(plr,"level") == 2 then 
                if tonumber(lmt.suma)>=PZ_PER_A_DAY then
                    outputChatBox("Wydałeś/as już maksymalną ilość punktów PZ na dobę.", plr)
                    return
                elseif tonumber(lmt.suma)+jednostka>PZ_PER_A_DAY then
                    outputChatBox("Nie masz dostępnych aż tylu punktów PZ, obecnie możesz dać maksymalnie "..(PZ_PER_A_DAY-tonumber(lmt.suma)), plr)
                    return
                end
            elseif getElementData(plr,"level") == 1 then
                if tonumber(lmt.suma)>=PZ_PER_M_DAY then
                    outputChatBox("Wydałeś/as już maksymalną ilość punktów PZ na dobę.", plr)
                    return
                elseif tonumber(lmt.suma)+jednostka>PZ_PER_M_DAY then
                    outputChatBox("Nie masz dostępnych aż tylu punktów PZ, obecnie możesz dać maksymalnie "..(PZ_PER_M_DAY-tonumber(lmt.suma)), plr)
                    return
                end
            elseif getElementData(plr,"level") == 3 then 
                if tonumber(lmt.suma)>=PZ_PER_A_DAY then 
                    outputChatBox("Wydałeś/aś już maksymalną ilość punktów PZ na dobę.",plr)
                    return
                elseif tonumber(lmt.suma)+jednostka>PZ_PER_A_DAY then 
                    outputChatBox("Nie masz dostępnych aż tylu punktów PZ, obecnie możesz dać maksymalnie "..(PZ_PER_A_DAY-tonumber(lmt.suma)),plr)
                    return
                end
            end
        end
    end
    if tonumber(uid)==tonumber(auid) and auid~=1 then
        outputChatBox("Nie mozesz dac punktów sobie.", plr)
        return
    end

    local pz = tonumber(getElementData(target,"PZ"))
    if (not pz) then return false end
    pz = pz + tonumber(jednostka)
    setElementData(target,"PZ",pz)
    outputChatBox("Zostałeś/aś nagrodzony/a dodatkowymi punktami PZ!",target,255,0,0)

    exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_achievements_history SET ts=NOW(),achname='%s',user_id=%d,character_id=%d,amount=%d,given_by=%d,notes='%s'",
        "PZ",uid,uid,jednostka,auid,reason))
    local log=string.format("NadaniePZ %s/%d nadał %dPZ dla gracza %s/%s(%d/%d), powód %s", string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""),auid, jednostka, target and getPlayerName(target) or "-",getElementData(target,"auth:login"),uid, uid, reason)
    gameView_add(log)
    outputChatBox("Punkty PZ zostały nadane.", plr)
end
addCommandHandler("nadajpz",cmd_nadajpz,true,false)

function f(player,cmd,target)
    local plr = findPlayer ( player, target )
    if (not plr) then
        outputChatBox("Nie znaleziono gracza o nicku " .. target,player )
        return
    end

    removeElementData(plr,"faction:data")
    outputChatBox(".",plr)
    outputChatBox(",",player)
end
addCommandHandler("test21",f,false,false)
