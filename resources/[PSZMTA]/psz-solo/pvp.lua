--[[

solo: zapraszanie, pojedynek

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-solo
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

function solo_sendRequest(plr,cmd,cel)
    -- TODO: Weryfikacja dostępności aren
    if (not cel) then
            outputChatBox("Użycie /solo <id/nick>",plr);
            return
        end
        
    local target = findPlayer(plr,cel)
    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym id/nicku.",plr)
        return
    end

    if solo_arenaEnabled() then
        outputChatBox("Aktualnie nie ma wolnych aren na pojedynek.", plr)
        return 
    end
    if (getElementData(plr,"solo:deny_invite")) then
        outputChatBox("Najpierw odblokuj możliwość zapraszania Ciebie do pojedynków (/soloacc)",plr)
        return
    end
    
    if (target == plr) then
      outputChatBox("Nie możesz wyzwać siebie na pojedynek.",plr,255,0,0)
      return
    end

    if (getElementData(plr,"solo:active")) then
        outputChatBox("Najpierw ukończ aktualny pojedynek.",plr,255,0,0)
        return
    end
    
    if (getElementData(target,"solo:active")) then
        outputChatBox("Gracz którego chcesz zaprosić, aktualnie przeprowadza pojedynek.",plr,255,0,0)
        return
    end
    
    if (tonumber(getElementData(target,"solo_deny"))>0) then
        outputChatBox("Gracz którego chcesz zaprosić do pojedynku, posiada zablokowane zapraszanie.",plr,255,0,0)
        return
    end
    
    if (getElementData(target,"solo:active_request")) then
        outputChatBox("Gracz nie odpowiedział jeszcze na poprzednie zaproszenie.",plr,255,0,0)
        return
    end
    
    if (getElementData(plr,"solo:active_request")) then
        outputChatBox("Nie odpowiedziałeś jeszcze na poprzednie zaproszenie.",plr,255,0,0)
        return
    end
    
    if (getElementData(target,"kary:blokada_aj") or getElementData(plr,"kary:blokada_aj")) then
        outputChatBox("Ty lub gracz którego próbujesz zaprosić posiadacie aktywną karę AdminJail.",plr,255,0,0)
        return
    end
    
    if (getElementData(plr,"solo:active_select") or getElementData(target, "solo:active_select")) then
        outputChatBox("Gracz nie ukończył aktualnego pojedynku.", plr, 255, 0, 0)
        return
    end
    local afk=getElementData(target,"afk") or 0
    if afk>1 then
        outputChatBox("Gracz do którego chcesz wysłać zaproszenie jest AFK - zaproszenie nie zostało wysłane.", plr, 255,0,0)
        return
    end
    outputChatBox("Zaproszenie zostało wysłane.",plr)
    setElementData(plr,"solo:active_request",target)   
    setElementData(target,"solo:active_request",plr)
    triggerClientEvent(target,"solo_showRequestForPlayer", target, plr) -- show gui for target, plr == plr
end
addCommandHandler("solo", solo_sendRequest)

function solo_selectWeapons(plr, target)
    outputChatBox("Twój przeciwnik aktualnie wybiera broń którą będziecie walczyć.", target)
    setElementData(plr,"solo:active_select",target)
    setElementData(target, "solo:active_select", plr)
    local win = exports['psz-mysql']:pobierzTabeleWynikow(string.format("SELECT sm.weapon1, count(*) wygranych FROM psz_solo_matches sm WHERE sm.killerid=%d GROUP BY sm.weapon1",getElementData(plr,"auth:uid"))) -- gotowe
    triggerClientEvent(plr,"solo_showGridWeapon", plr, win)
end

function solo_startSolo(plr, who, id, p1, p2, vw, int, weapon)
   if (not plr or not who) then return end
    local p1=split(p1,",")
    local p2=split(p2,",")
    setElementData(plr,"solo:active", who)
    setElementData(who, "solo:active", plr)
    setElementData(plr,"solo:arena_id",id)
    setElementData(who, "solo:arena_id",id)

    if isPedInVehicle(plr) then
        removePedFromVehicle(plr)
    elseif isPedInVehicle(who) then
        removePedFromVehicle(who)
    end
    setElementDimension(plr, vw)
    setElementDimension(who, vw)
    setElementHealth(plr, 100)
    setElementHealth(who, 100)
    setElementPosition(who, p2[1],p2[2],p2[3])
    setElementPosition(plr, p1[1],p1[2],p1[3])
    setElementInterior(who, int, p2[1], p2[2],p2[3])
    setElementInterior(plr, int, p1[1], p1[2], p1[3])
    setElementFrozen(plr, true)
    setElementFrozen(who, true)
    takeAllWeapons(plr)
    takeAllWeapons(who)
   -- toggleControl(plr,"aim_weapon",true)
   -- toggleControl(plr,"fire",true)
   -- toggleControl(who,"fire",true)
   -- toggleControl(plr,"aim_weapon",true)
   -- if getElementData(plr,"strefa:nodm") then
     --   removeElementData(plr,"strefa:nodm")
    --elseif getElementData(who,"strefa:nodm") then
    --    removeElementData(who,"strefa:nodm")
   -- end
    giveWeapon(plr,weapon, 15000)
    giveWeapon(who, weapon, 15000)
    setPedArmor(plr,100)
    setPedArmor(who, 100)
    for __, id in ipairs({77,71,78,76,69,73,72,70,79,74,75}) do
        setPedStat(plr,id,0)
        setPedStat(who,id,0)
    end
    triggerClientEvent(plr,"solo_startCountdown", plr)
    triggerClientEvent(who,"solo_startCountdown", who)
    setTimer(function() setElementFrozen(who,false) setElementFrozen(plr,false) 
            outputChatBox("Walka rozpoczęła się, niech wygra najlepszy!",plr,255,0,0)
            outputChatBox("Walka rozpoczęła się, niech wygra najlepszy!",who,255,0,0)
            setElementData(plr,"solo:person1", who)
            setElementData(who, "solo:person1", plr)
            removeElementData(plr, "solo:active_select")
            removeElementData(who, "solo:active_select")
           -- toggleControl(plr,"aim_weapon",true)
           -- toggleControl(plr,"fire",true)
           -- toggleControl(who,"fire",true)
           -- toggleControl(plr,"aim_weapon",true)
        end,6000,1)
end
addEvent("solo_sendSelectedWeapon", true)
addEventHandler("solo_sendSelectedWeapon", root, function(weapon)
    local target = getElementData(client, "solo:active_select")
    local arena = exports['psz-mysql']:pobierzTabeleWynikow("SELECT id,descr,vw,interior,in_use,pos1,pos2 FROM psz_arena WHERE in_use=0 LIMIT 1;")
    if (arena) then
        for i2,v in ipairs(arena) do
            exports['psz-mysql']:zapytanie(string.format("UPDATE psz_arena SET in_use=1 WHERE id=%d",v.id))
            solo_startSolo(client, target, v.id,v.pos1, v.pos2, v.vw, v.interior, weapon)
            setElementData(client,"solo:arena_id",v.id)
            setElementData(target,"solo:arena_id",v.id)
        end
    else
        outputChatBox("Pojedynek nie mógł się odbyć.",client,255,0,0)
        outputChatBox("Pojedynek nie mógł się odbyć.",target,255,0,0)
        removeElementData(target,"solo:active_select")
        removeElementData(client,"solo:active_select")
    end
end)

addEvent("solo_sendResponse", true)
addEventHandler("solo_sendResponse", root, function(data, who)
    if (not who) then return end 
    if (data == false) then
        outputChatBox("Gracz odrzucił twoje zaproszenie.", who,255,0,0)
        removeElementData(who,"solo:active_request")
        removeElementData(client, "solo:active_request")
        return
    elseif(data == true) then
        removeElementData(who, "solo:active_request")
        removeElementData(client, "solo:active_request")
        solo_selectWeapons(who, client)
    end
end)

function solo_playerKill(ammo,attacker,weapon,bodypart)
    if (attacker) then
        if getElementType(attacker) =="player" then
            if attacker == source then
                if (getElementData(attacker,"solo:active") and (getElementData(kto,"solo:active"))) then
            	    local kto = getElementData(attacker, "solo:person1")
            	    local id = getElementData(attacker, "solo:arena_id")
                    exports['psz-mysql']:zapytanie(string.format('UPDATE psz_arena SET in_use=0 WHERE id=%d',id))
                
                    local ciapa = string.gsub(getPlayerName(attacker),"#%x%x%x%x%x%x","")
                    local ciapa2 = string.gsub(getPlayerName(kto),"#%x%x%x%x%x%x","")
                    outputChatBox("Gracz "..ciapa..", popełnił samobójstwo podczas pojedynku, wygrywa gracz "..ciapa2..".")
                    local ile = 5
                    givePlayerMoney(kto,tonumber(ile))
                    outputChatBox("Otrzymałeś "..tonumber(ile).."$",kto)
                
                
                -- id, arenaid, weapon1, weapon2, playerid, killerid, hp, ar, ts
                    exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_solo_matches SET arenaid=%d, weapon1=%d, weapon2=%d, playerid=%d, killerid=%d, hp=%d, ar=%d, ts=NOW()",tonumber(id), weapon, weapon, getElementData(source,"auth:uid"), getElementData(kto,"auth:uid"), getElementHealth(kto), getPedArmor(kto)))
                    removeElementData(kto, "solo:active")
                    removeElementData(source,"solo:active")
                    removeElementData(source,"solo:arena_id")
                    removeElementData(kto,"solo:arena_id")
                    removeElementData(kto, "solo:person1")
                    removeElementData(source, "solo:person1")
                    takeAllWeapons(kto)
                    setElementHealth(kto,100)
                    setPedArmor(kto,0)
                    setElementPosition(kto,-2582.80,-17.01,4.6)
                    setElementDimension(kto,0)
                    setElementInterior(kto, 0)
                end
                return
            end
            if getElementData(attacker,"solo:active") and getElementData(source,"solo:active") then -- literowka
                local winner = string.gsub(getPlayerName(attacker),"#%x%x%x%x%x%x","")
                local loser = string.gsub(getPlayerName(source), "#%x%x%x%x%x%x","")
                outputChatBox("#00FF00★ #FFFFFF"..winner..", wygrał/a pojedynek z "..loser.."! Gratulacje!",getRootElement(),255,255,255,true)
                local ile = 25
                givePlayerMoney(attacker,tonumber(ile))
                outputChatBox("Otrzymałeś "..tonumber(ile).."$",attacker)
                local id = getElementData(attacker, "solo:arena_id")
                exports['psz-mysql']:zapytanie(string.format('UPDATE psz_arena SET in_use=0 WHERE id=%d',id))
                -- id, arenaid, weapon1, weapon2, playerid, killerid, hp, ar, ts
                exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_solo_matches SET arenaid=%d, weapon1=%d, weapon2=%d, playerid=%d, killerid=%d, hp=%d, ar=%d, ts=NOW()",tonumber(id), weapon, weapon, getElementData(source,"auth:uid"), getElementData(attacker,"auth:uid"), getElementHealth(attacker), getPedArmor(attacker)))
                removeElementData(attacker, "solo:active")
                removeElementData(source,"solo:active")
                removeElementData(source,"solo:arena_id")
                removeElementData(attacker,"solo:arena_id")
                takeAllWeapons(attacker)
                setElementHealth(attacker,100)
                setPedArmor(attacker,0)
                setElementPosition(attacker,-2582.80,-17.01,4.6)
                setElementDimension(attacker,0)
                setElementInterior(attacker, 0)
            end
        end
    end
end

addEventHandler("onPlayerWasted",getRootElement(),solo_playerKill)

function solo_playerQuit(quitType)
    if getElementData(source,"solo:active") then
        local kto = getElementData(source,"solo:active")
        local id = getElementData(source,"solo:arena_id")
        outputChatBox("Twój przeciwnik wyszedł z gry, zostajesz przeteleportowany na spawn.",kto)
        exports['psz-mysql']:zapytanie(string.format("UPDATE psz_arena SET in_use=0 WHERE id=%d",id))

        removeElementData(kto,"solo:active")
        removeElementData(kto,"solo:active_request")
        removeElementData(kto,"solo:arena_id")
        takeAllWeapons(kto)
        setPedArmor(kto,0)
        setElementHealth(kto,100)
        setElementPosition(kto,-2582.80,-17.01,4.6)
        setElementDimension(kto,0)
        setElementInterior(kto, 0)
    end
    if getElementData(source,"solo:active_request") then 
        local who = getElementData(source,"solo:active_request")
        outputChatBox("Twój przeciwnik wyszedł z gry.", who,255,0,0)
        removeElementData(who,"solo:active_request")
    end
    if getElementData(source,"solo:active_select") then
        local aid = getElementData(source,"solo:arena_id")
        local who = getElementData(source,"solo:active_select")
        exports['psz-mysql']:zapytanie(string.format("UPDATE psz_arena SET in_use=0 WHERE id=%d",aid))
        outputChatBox("Pojedynek nie mógł się odbyć - gracz wyszedł z gry.",who,255,0,0)
        removeElementData(who,"solo:active_select")
    end
end
addEventHandler("onPlayerQuit",getRootElement(),solo_playerQuit)


function solo_denyCommand(plr)
	local c = getElementData(plr,"character")
	if (c and c.id) then 
		local deny = getElementData(plr,"solo_deny") or 0
		if (deny and deny==1) then 
			setElementData(plr,"solo_deny",0)
			exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET solo_deny=0 WHERE id=%d",getElementData(plr,"auth:uid")))
			outputChatBox("Akceptujesz teraz wszystkie zaproszenia na pojedynek.",plr)
		elseif (deny and deny==0) then 
			setElementData(plr,"solo_deny",1)
			exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET solo_deny=1 WHERE id=%d",getElementData(plr,"auth:uid")))
			outputChatBox("Nie akceptujesz teraz zaproszeń na pojedynek.",plr)
		end
	end
end
addCommandHandler("soloacc", solo_denyCommand)
