addEventHandler("onResourceStart", resourceRoot,function()
    setJetpackMaxHeight(101.82230377197)
    setWaveHeight(0)
    setFPSLimit(60)
    setMapName("PSZ Freeroam")
    setGameType("PSZ Freeroam")
    setRuleValue("Gamemode", "PSZ Freeroam")
    setRuleValue("WWW", "https://pszmta.pl")
	setCloudsEnabled(false)
    local realtime = getRealTime()
    setTime(realtime.hour, realtime.minute)
    setMinuteDuration(60000)	-- 60000
    setTimer ( every1min, 60000, 0)
end)

function every1min()
    setJetpackMaxHeight(101.82230377197)

   -- if isPlayerInCinema() then return end
    local time = getRealTime()
    -- synchronizacja czasu
    setTime(time.hour, time.minute)
    -- bicie dzwonu co godzine
end

function changeNicknameColor(plr,color)
    if color then 
        setPlayerNametagColor(plr,color[1],color[2],color[3])
    else
        setPlayerNametagColor(plr,math.random(0,255),math.random(0,255),math.random(0,255))
    end
end

function onPlayerDownloadFinished(plr)
    setElementFrozen(plr,true)
    setElementInterior(plr,0)
    setElementDimension(plr,7)
    setElementPosition(plr, 2134.67,-81.79,2.98-4)
    triggerClientEvent(plr,"displayLoginBox",getRootElement())
end
function checkAccess()
    local serial = getPlayerSerial(source)
    local q = string.format("SELECT p.login FROM psz_accesslog a JOIN psz_players p ON p.id=a.user_id WHERE UNIX_TIMESTAMP(a.ts)<=UNIX_TIMESTAMP(NOW()) AND a.serial='%s' ORDER BY UNIX_TIMESTAMP(a.ts) DESC LIMIT 1",serial)
    local wyniki = exports["psz-mysql"]:pobierzWyniki(q)
    if (not wyniki or not wyniki.login) then
    	triggerClientEvent(source,"displayLoginBoxWindow",source)
    	return
    end
    triggerClientEvent(source,"displayLoginBoxWindow",source,wyniki.login)
end
addEvent("findAccount",true)
addEventHandler("findAccount",root,checkAccess)


function greetPlayer()
    setElementData(source,'justConnected',true)
end
addEventHandler ( "onPlayerJoin", getRootElement(), greetPlayer )

function cmd_register(source,cmd,username,password)
	if (password ~="" and password~=nil and username~="" and username~=nil) then 
		local level = getElementData(source,"auth:level") or 0 
		if (level and level>0) then 
			local accountAdded = addAccount(username,password)
			if (accountAdded) then 
				outputChatBox("Konto zostało dodane. [login: "..username.." hasło: "..password.."]",source)
				local c = getElementData(source,"character")
				if (c and c.id) then 
					exports['psz-admin']:gameView_add("AC "..getPlayerSerial(source).."/"..getElementData(source,"auth:uid").."/"..getElementData(source,"auth:login").."/"..getElementData(source,"auth:level"))
				end
			else
				outputChatBox("Wystąpił błąd, skontaktuj się z ROOT'em.",source)
			end
		else
			outputChatBox("Zbyt niski poziom uprawnień.",source)
			return
		end
	end
end
addCommandHandler("register", cmd_register)

addEventHandler("onPlayerJoin", getRootElement(), function()
    local plrNick = getPlayerName(source)
    if (string.len(plrNick)<3) then
        kickPlayer(source,"Twój nick musi zawierać przynajmniej 3 znaki.")
        return
    end 
    if (string.find(plrNick,"#000000")) then
        plrNick = string.gsub(plrNick,"#000000","")
        setPlayerName(source,plrNick)
    end
end)
function isPlayerHaveBJ(s)
    local uid = getElementData(s,"auth:uid") or 0
    local q = string.format("SELECT k.date_end FROM psz_kary k WHERE (k.id_player=%d OR k.serial='%s') AND k.date_end>NOW() AND rodzaj='Blokada Pracy' ORDER BY k.date_end DESC LIMIT 1",uid,getPlayerSerial(s))
    pasujaca_kara = exports['psz-mysql']:pobierzWyniki(q)
    if (pasujaca_kara) then 
        return true
    end
    return false
end
function znLog(oldNick, newNick,typ)
    local serial = getPlayerSerial(source)
    local uid = getElementData(source,"auth:uid")
    local c = getElementData(source,"character")
    --if (uid and tonumber(uid)~=1) then 
      --  outputChatBox("Możliwość zmiany nicku na serwerze będzie dostępna za kilkanaście minut.",source,255,0,0)
       -- cancelEvent()
        --return
    --end

    if (string.find(newNick,"#000000")) then 
        outputChatBox("Posiadanie czarnego koloru w nicku jest zabronione.",source,255,0,0)
        cancelEvent()
        return
    end

    local newNick = string.gsub(newNick,"#%x%x%x%x%x%x","")
    local newNick = replaceIlleagalCharacters(newNick)
    if (string.find(newNick,"'")) then
        outputChatBox("W nicku nie możesz posiadać znaku '",source,255,0,0)
        cancelEvent()
        return
    end
    
    if (string.len(newNick)<3) then 
        outputChatBox("Nick musi mieć długość przynajmniej 3 znaków.",source,255,0,0)
        cancelEvent()
        return
    end

    if (not c or not c.id) then 
        cancelEvent()
        return
    end
    local next_nc = exports['psz-mysql']:pobierzWyniki(string.format("SELECT TIMESTAMPDIFF(MINUTE, NOW(), next_nick_change) time FROM psz_players WHERE id=%d AND next_nick_change > NOW() LIMIT 1",tonumber(uid)))
    if (next_nc and tonumber(next_nc.time)>0 and typ) then 
        outputChatBox("Kolejną zmianę nicku możesz wykonać za "..tonumber(next_nc.time).." minut.",source,255,0,0)
        cancelEvent()
        return
    end

    local wyniki = exports['psz-mysql']:pobierzWyniki(string.format("SELECT nick, userid FROM psz_postacie WHERE nick='%s'",newNick))
    if ((not wyniki) or (wyniki and wyniki.userid == c.id)) then
        exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_znlog SET serial='%s',playerid=%d,oldNick='%s',newNick='%s' ON DUPLICATE KEY UPDATE ts=NOW(), oldNick='%s',newNick='%s'",serial,uid,oldNick,newNick,oldNick,newNick))

        
        exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET next_nick_change=NOW()+INTERVAL 1 HOUR WHERE id=%d", tonumber(uid)))
        local ac_login = exports['psz-mysql']:zapytanie(string.format("SELECT nick FROM psz_postacie WHERE userid=%d LIMIT 1",uid))
        if not typ then 
        else
            exports['psz-admin']:gameView_add(string.format("ZMIANA (NICK AND LOGIN) gracz ( %d ) %s, zmienia na %s",uid,oldNick,newNick))
            outputChatBox("Twój nick został zmieniony, kolejną zmianę możesz wykonać za 1 godzinę.",source,255,0,0)
        end
        if (ac_login == newNick) then
        else
            exports['psz-mysql']:zapytanie(string.format("UPDATE psz_postacie SET nick='%s' WHERE userid=%d LIMIT 1",newNick,uid))
        end
    else
        cancelEvent()
        outputChatBox('Taki nick jest już w użyciu!',source,255,0,0)
        setPlayerName(source,oldNick)
        return
    end
end
addEventHandler("onPlayerChangeNick", getRootElement(),znLog)

--[[
function onMKTimerWasted(ammo, attacker, weapon, bodypart)
    if (attacker) then 
        if source == attacker then return end
            if getElementData(attacker,"antyMKTimer") then 
            local cMK = getElementData(attacker,"antyMK:count") or 0 
            if cMK and cMK>0 then 
                local reason = "Zabicie gracza przed upływem czasu (AMK)"
                local uid = getElementData(attacker,"auth:uid") or 0
                local slogin = "System"
                local auid = 5802
                local serial = getPlayerSerial(attacker)
                local kto=string.gsub(getPlayerName(attacker),"#%x%x%x%x%x%x","")
                local czas = 3
                local q = string.format("INSERT INTO psz_kary SET id_player=%d, serial='%s', rodzaj='Admin Jail', date_end=NOW()+INTERVAL %d MINUTE, reason='%s', player_given=%d" ,uid ,serial ,czas ,reason,auid)
                exports['psz-mysql']:zapytanie(q)
                exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET blokada_aj=%d WHERE id=%d LIMIT 1", czas, uid))
                exports['psz-admin']:adminView_add("SYSTEM - bAJ> "..kto..", powod: '".. reason.. "', przez:".. slogin,2)
                exports['psz-admin']:gameView_add("SYSTEM - bAJ "..kto..", powod: '".. reason .."', przez: ".. slogin)
                outputConsole(slogin.." nałożył/a AJ ("..czas.." min) na: "..kto..", powód: "..reason)
                triggerClientEvent("gui_showOgloszenie", root, slogin.." nałożył/a AJ ("..czas.." min) na: "..kto..", powód: "..reason..".","Informacja o nadanej karze")

                outputChatBox("Trafiłeś do Admin Jail'a, powód:"..reason.." czas do odsiedzenia: "..czas.." min.",attacker,255,0,0)
                setElementData(attacker,"kary:blokada_aj",czas)
                removePedFromVehicle(attacker)
                setElementDimension(attacker,231)
                setElementInterior(attacker,0)
                setElementPosition(attacker,1775.42,-1574.87,1734.94)
                removeElementData(attacker,"antyMK:count")
            elseif cMK == 0 and getPlayerName(attacker) == "_kOx_" then 
                setElementData(attacker,"antyMK:count",1)
                triggerClientEvent("onPlayerReceivedWarning", attacker, "Jeżeli zabijesz jeszcze jednego gracza przed skończeniem się czasu, trafisz do Admin Jaila.")
            end
        end
    end
end
addEventHandler("onPlayerWasted", getRootElement(), onMKTimerWasted)
]]--
