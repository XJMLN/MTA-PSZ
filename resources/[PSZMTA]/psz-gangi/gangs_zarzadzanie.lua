--[[

Gangi: aktualizacja danych dla czlonkow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gangi
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function updatePlayerCoData(pid)
    if (type(pid)=="number" or type(pid)=="string") then
        pid = tonumber(pid)
        for i,v in ipairs(getElementsByType("player")) do
            local c = getElementData(v, "character")
            local uid = getElementData(v,"auth:uid")
            if (c and uid and tonumber(uid) == pid) then  -- cc = pg
                local query= string.format("SELECT pg.skin,pg.rank, g.id gang_id, g.nazwa gang_name,g.tag gang_tag, gr.name rank_name FROM psz_players_gangs pg JOIN psz_gangs_ranks gr ON gr.gang_id=pg.id_gang AND gr.rank_id=pg.rank JOIN psz_gangi g ON g.id=gr.gang_id WHERE pg.id_player=%d",pid)
                local dane= exports['psz-mysql']:pobierzWyniki(query)

                if (dane) then
                    --c.gg_nazwa,c.gg_tag,c.gg_rank_name,c.gg_rank_id,c.gg_id  -- gg_nazwa, gg_tag, gg_rank_name, gg_rank_id, gg_id
                    c.gg_nazwa = dane.gang_name
                    c.gg_tag = dane.gang_tag
                    c.gg_rank_name = dane.rank_name
                    c.gg_rank_id = dane.rank
                    c.gg_id  = dane.gang_id
                    if (dane.skin and type(dane.skin)~="userdata") then
                        setElementModel(v,dane.skin)
                    else
                        setElementModel(v, c.skin)
                    end
                    outputChatBox("Twoja przynależność do organizacji przestępczej została zaktualizowana.",v)
                else
                    c.gg_nazwa = nil
                    c.gg_tag = nil
                    c.gg_rank_name = nil
                    c.gg_rank_id = nil
                    c.gg_id = nil
                    setElementModel(v, c.skin)
                    outputChatBox("Nie jestes juz czlonkiem organizacji przestepczej.",v)
                end
                setElementData(v,"character",c)

                return true
            end
        end
    end
    return false
end

function onDataUpgradesDownload(gid)
    if (not gid) then return end
    
    local upgrades_acctualy = exports['psz-mysql']:pobierzWyniki(string.format("SELECT id_upgrade FROM psz_gangi_owned_upgrades WHERE id_gang=%d",gid))
    local upgrade = exports['psz-mysql']:pobierzTabeleWynikow(string.format("SELECT gu.id,gu.name,gu.tag,gu.cost,g.money_sejf FROM psz_gangi_upgrades gu JOIN psz_gangi g WHERE g.id=%d ORDER BY cost ASC;",gid))
    if upgrades_acctualy and upgrades_acctualy.id_upgrade then
        triggerClientEvent(source,"doFillUpgradesData", resourceRoot, upgrade,upgrades_acctualy) 
    else
        upgrades_acctualy = nil
        triggerClientEvent(source,"doFillUpgradesData", resourceRoot, upgrade,upgrades_acctualy)
    end
end

addEvent("onGangMemberEditNote",true)
addEventHandler("onGangMemberEditNote",root, function(gid,note)
    if (not gid or not note) then return end
    tresc = tostring(note)
    local pid = getElementData(client,"auth:uid")
    local findString = string.find(note,"'")
    if (findString~=nil) then
        triggerClientEvent("onEditSendResult", resourceRoot, false, "Usuń znak ' z tekstu.")
        return 
    end
    local query = string.format("UPDATE psz_gangi SET text_note='%s' WHERE id=%d", tresc, gid)
    exports['psz-mysql']:zapytanie(query)
    exports['psz-admin']:gameView_add("Gracz "..getPlayerName(client).."/"..pid.." edytuje notatke gangu ("..gid..")")
    triggerClientEvent("onEditSendResult", resourceRoot, true, "Notatka została edytowana.")
end)
addEvent("onPlayerRequestGangData",true)
addEventHandler("onPlayerRequestGangData",root,function(gid)
    if (not gid) then return end
    local query
        --select c.id character_id,cc.rank rank_id,c.imie,c.nazwisko,cc.jointime lastduty,cc.skin,cr.name ranga from lss_character_co cc JOIN lss_characters c ON c.id=cc.character_id JOIN lss_co_ranks cr ON cr.co_id=cc.co_id AND cr.rank_id=cc.rank WHERE cc.co_id=%d
        query = string.format("SELECT p.userid player_id,g.text_note,pg.rank rank_id,pg.money wplacone_sejf,p.nick,pl.datetime_last lastduty,gr.name ranga FROM psz_players_gangs pg JOIN psz_gangi g ON g.id=pg.id_gang JOIN psz_postacie p ON p.userid=pg.id_player JOIN psz_players pl ON pl.id=p.userid JOIN psz_gangs_ranks gr ON gr.gang_id=pg.id_gang AND gr.rank_id=pg.rank WHERE pg.id_gang=%d",gid)
        local dane = exports['psz-mysql']:pobierzTabeleWynikow(query)
        -- ulepszenia
        query = string.format("SELECT g.money_sejf,g.logo,gs.skin FROM psz_gangi g JOIN psz_gangs_skins gs ON gs.gang_id=g.id WHERE g.id=%d",gid)
        local data = exports['psz-mysql']:pobierzTabeleWynikow(query)
        
        onDataUpgradesDownload(gid)
        local onlineMembers = gang_getOnlineMembers(gid)
    triggerClientEvent(source,'doFillGangData',resourceRoot,dane,data,onlineMembers)
   -- triggerClientEvent(source,"doFillUpgradesData", resourceRoot, upgrade)
end)

addEvent("onGangCharacterDetailsRequest",true)
addEventHandler("onGangCharacterDetailsRequest", root, function(gid, pid)
    if (not gid or not pid) then return end
    local query 
        query = string.format("SELECT rank_id, name FROM psz_gangs_ranks WHERE gang_id=%d ORDER BY rank_id ASC;",gid)
        local rangi = exports['psz-mysql']:pobierzTabeleWynikow(query)
    
        query = string.format("SELECT skin FROM psz_gangs_skins WHERE gang_id=%d ORDER BY skin ASC",gid)
        local skiny = exports['psz-mysql']:pobierzTabeleWynikow(query)
        
        query = string.format("SELECT p.userid, p.nick, pg.rank, pg.skin FROM psz_players_gangs pg JOIN psz_postacie p ON pg.id_player=p.userid WHERE pg.id_player=%d LIMIT 1", pid)
        local postac = exports['psz-mysql']:pobierzWyniki(query)
        
        local dane={
            rangi=rangi,
            skiny=skiny,
            gracz=postac
        }
        triggerClientEvent(source, "doFillGangPlayerData", resourceRoot, dane)
end)

addEvent("onMemberGangSaveMoney",true)
addEventHandler("onMemberGangSaveMoney", root, function(gid, pid, money)
    if (not gid or not pid or not money) then return end
    if (getPlayerMoney(client)<money) then 
        triggerClientEvent(source,"onResultSaveMoney",resourceRoot, false, "Nie posiadasz przy sobie tylu pieniędzy.")
        return
    end
        
    takePlayerMoney(client,money)
    exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players_gangs SET money=money+%d WHERE id_player=%d LIMIT 1",money, pid))
    exports['psz-mysql']:zapytanie(string.format("UPDATE psz_gangi SET money_sejf=money_sejf+%d WHERE id=%d LIMIT 1",money,gid))
    exports['psz-admin']:gameView_add("Gracz "..getPlayerName(client).." wplaca $"..money..", do sejfu gangu ("..gid..")")
    triggerClientEvent(source,"onResultSaveMoney", resourceRoot, true)
    outputChatBox("Wpłaciłeś "..money.."$, do sejfu gangu.",client,255,0,0)
end)

addEvent("onGangEdycjaPostaci", true)
addEventHandler("onGangEdycjaPostaci", root, function(pid, ranga, skin)
    if (not pid or not ranga ) then return end
    if ranga == 4 then 
        outputChatBox("Nie możesz nadać tej rangi nikomu.",client)
        return
    end
    skin = skin and tostring(skin) or "NULL"
    local query = string.format("UPDATE psz_players_gangs SET skin=%s, rank=%d WHERE id_player=%d LIMIT 1", skin, ranga, pid)
    exports['psz-mysql']:zapytanie(query)
    triggerClientEvent(source, "onGangEdycjaComplete", resourceRoot, true)
    exports['psz-admin']:gameView_add("Gracz "..getPlayerName(client).." aktualizuje gracza ("..pid.."), rank: "..ranga..", skin: "..skin)
    updatePlayerCoData(pid)
end)

addEvent('onGangInviteRequest',true)
addEventHandler('onGangInviteRequest', root, function(gid, nick)
	if (not gid or not nick) then return end
	nick = tostring(nick)
    nick = string.gsub(nick,"#%x%x%x%x%x%x","")
	local query= string.format("SELECT userid FROM psz_postacie WHERE nick='%s' LIMIT 1", nick)
	local dane=exports['psz-mysql']:pobierzWyniki(query)
	if (dane and dane.userid) then
		query = string.format("SELECT 1 FROM psz_players_gangs WHERE id_player=%d LIMIT 1", dane.userid)
		if (exports['psz-mysql']:pobierzWyniki(query)) then 
			triggerClientEvent(source,"onGangInviteReply", resourceRoot, false, "Ta osoba jest już w gangu.")
			return
		end
		local target = gang_getOnlinePlayer(dane.userid)
    if (target) then 
        query = string.format("SELECT nazwa FROM psz_gangi WHERE id=%d LIMIT 1",gid)
        local g = exports['psz-mysql']:pobierzWyniki(query)
        outputChatBox("#BF5A02* Otrzymałeś zaproszenie do gangu #FFFFFF"..tostring(g.nazwa).."#BF5A02, aby zaakceptować wpisz /dolacz #FFFFFF"..tostring(g.nazwa).."#BF5A02.",target,255,255,255,true)
        setElementData(target,"ginv:ts",getTickCount())
        setElementData(target,"ginv:name",g.nazwa)
        setElementData(target,"ginv:person",client)
        triggerClientEvent(source,'onGangInviteReply', resourceRoot, true)
    else
        triggerClientEvent(source, "onGangInviteReply", resourceRoot, false, "Podana osoba nie jest ONLINE.")
		return
    end
	else
	   triggerClientEvent(source, "onGangInviteReply", resourceRoot, false, "Nie odnaleziono podanej osoby.")
	end
end)
	
addEvent("onGangWyrzucRequest",true)
addEventHandler("onGangWyrzucRequest", root, function(gid,pid)
	if (not gid or not pid) then return end
	local query= string.format("DELETE FROM psz_players_gangs WHERE id_player=%d AND id_gang=%d LIMIT 1", pid, gid)
	exports['psz-mysql']:zapytanie(query)
    exports['psz-admin']:gameView_add("Gracz "..getPlayerName(client).." wyrzuca gracza ("..pid.."), z gangu ("..gid..")")
	triggerClientEvent(source,"onGangWyrzucComplete", resourceRoot)
	updatePlayerCoData(pid)
end)

addEvent("onGangUpgradeBuy", true)
addEventHandler("onGangUpgradeBuy", root, function(gid, name)
    if (not gid or not name) then return end
    if name == 1 then
        outputChatBox("Funkcja w trakcie modyfikacji.",client)
        return 
       -- outputChatBox("Aby dodać pojazd do gangu, wpisz komendę /edytor <id pojazdu/nazwa>.",client)
        --outputChatBox("Pamiętaj, nie możesz być w pojeździe lub innym interiorze.", client)
        --setElementData(client, "ge:have_access", true)
    elseif name == 3 then 
        --local lvl = getElementData(client,"level") or 0 
       -- if (lvl and lvl~=3) then outputChatBox("W trakcie wdrażania.",client,255,0,0) return end 
            gangs_upgradeGangZone(gid,client)
    else
        outputChatBox("Aktualnie możesz jedynie dodać nowe pojazdy do gangu, reszta będzie wkrótce.",client,255,0,0)
        return
    end
end)