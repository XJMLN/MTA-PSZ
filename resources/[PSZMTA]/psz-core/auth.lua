--[[

Core - autoryzacja kont, rejestracja, spawn

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

addEvent("onAuthResult",true)
addEventHandler("onAuthResult",root,function (login,password,typ)
        if typ == 1 then -- rejestracja
            if (not login or not password) then
                local retval={success=false, komunikat="Nie wpisałeś loginu lub hasła."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end

            local query = string.format("SELECT * FROM psz_players WHERE login='%s'",login)
            local wyniki=exports["psz-mysql"]:pobierzWyniki(query)
            if (wyniki) then
                local retval={success=false, komunikat="Podany login jest już zajęty."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end
            if string.len(password)<5 then
                local retval={success=false, komunikat="Hasło musi mieć conajmniej 5 znaków."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end
            if strLetters(password) then
                local retval={success=false, komunikat="Hasło nie może zawierać polskich znaków."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end
            if isSerialInAJ(getPlayerSerial(source)) then
                local retval={success=false, komunikat="Na twoim serialu znajduje się aktywna kara - AJ. Zaloguj się na poprawne konto."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end
            local query= string.format("INSERT INTO psz_players SET login='%s',hash='%s';",login,hash('sha1',string.lower(login).."ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9"..password))
            exports["psz-mysql"]:zapytanie(query)
            local id = exports["psz-mysql"]:pobierzWyniki(string.format("SELECT id FROM psz_players WHERE login='%s';",login))
            if (id and id.id) then
                if (isPlayerBanned(source)) then return end
                local query = string.format("INSERT INTO psz_postacie SET userid='%d',nick='%s';",id.id,login)
                exports["psz-mysql"]:zapytanie(query)
                local retval={konto=true, komunikat="Konto zostało założone! Możesz się teraz zalogować."}
                triggerClientEvent(source,"onAuthResult",root,retval)
            end

        elseif typ == 2 then -- logowanie
            if (not login or not password) then
                local retval={ success=false, komunikat="Nieprawidłowy login lub hasło." }
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end

            local query = string.format("SELECT id,login,level,pz,vip>NOW() vip,vip vip_data,blokada_mk>NOW() blokada_mk,blokada_mk blokada_mk_data,spawn_select,bad_reputation,good_reputation,solo_deny FROM psz_players WHERE login='%s' and hash='%s' LIMIT 1",login,hash('sha1',string.lower(login).."ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9"..password))
            local wyniki=exports["psz-mysql"]:pobierzWyniki(query)
            if (not wyniki or not wyniki.id) then
                local retval={success=false, komunikat="Nieprawidłowy login lub hasło."}
                triggerClientEvent(source,"onAuthResult",root,retval)
                return
            end

            for i,v in ipairs(getElementsByType("player")) do
                local uid=getElementData(v,"auth:uid")
                if (uid and tonumber(uid)==tonumber(wyniki.id)) then
                    local retval={success=false, komunikat="Jesteś już zalogowany/a!"}
                    triggerClientEvent(source,"onAuthResult",root,retval)
                    outputDebugString("Proba podwojnego zalogowania na konto "..wyniki.id.." ("..wyniki.login..")")
                    return
                end

            end

            -- rejestrujemy logowanie
            exports["psz-mysql"]:zapytanie("INSERT INTO psz_accesslog SET serial='".. getPlayerSerial(source) .."',ip=INET_ATON('".. getPlayerIP(source) .."'),user_id="..tonumber(wyniki.id).." ON DUPLICATE KEY UPDATE ts=NOW(),ip=INET_ATON('"..getPlayerIP(source) .."');")
            local drift = exports["psz-mysql"]:pobierzWyniki("SELECT player_id,wynik FROM psz_players_drift WHERE player_id="..tonumber(wyniki.id))
            setElementData(source,"auth:uid",tonumber(wyniki.id))

            -- sprawdzamy bany
            if (isPlayerBanned(source)) then return end
            -- sprawdzamy czy gracz jest w aj
            isPlayerInAJ(source)
            if (isPlayerHaveBJ(source)) then 
                setElementData(source, "banned_jobs", true)
            end
            -- sprawdzamy czy gracz ma jakis dom - jesli ma zaznaczamy go na mapie
            doPlayerHaveHouse(source)
            -- sprawdzamy czy gracz ma jakies nieprzeczytane listy
            local letters = exports['psz-mysql']:pobierzWyniki(string.format("SELECT count(p.id) as ilosc FROM psz_poczta p WHERE p.dostarczone=1 and p.przeczytane=0 and p.odbiorca=%d", getElementData(source,"auth:uid")))
            if letters and letters.ilosc and letters.ilosc>0 then
                outputChatBox("Posiadasz nie przeczytane listy, odwiedź pocztę w Las Venturas aby je przeczytać.",source,255,0,0);
            end

            -- finalizujemy logowanie
            setElementData(source,"auth:login",wyniki.login)
            setElementData(source,"bad_reputation",wyniki.bad_reputation)
            setElementData(source,"good_reputation",wyniki.good_reputation)
            setElementData(source,"auth:level",wyniki.level)
            setElementData(source,"PZ",tonumber(wyniki.pz))
            setElementData(source,"solo_deny", tonumber(wyniki.solo_deny))
            if drift then
                setElementData(source,"drift",tonumber(drift.wynik))
            end
            if (tonumber(wyniki.level)>0) then
                setElementData(source,"auth:level",wyniki.level)
            end
            if (tonumber(wyniki.vip)>0) then
                setElementData(source,"vip", wyniki.vip_data)
            end

            if (tonumber(wyniki.blokada_mk)>0) then
                setElementData(source,"kary:blokada_mk",wyniki.blokada_mk)
            end
            if (tonumber(wyniki.spawn_select)>0) then
                setElementData(source,"spawn_select",wyniki.spawn_select)
            end
            local retval={ success=true }
            triggerClientEvent(source,"onAuthResult",root,retval)

            setTimer(auth_fetchPlayerCharacters,500,1,source, tonumber(wyniki.id))
        end
    end)

function auth_fetchPlayerCharacters(gracz,userid)
    local query= string.format("SELECT p.id,p.userid,p.nick,p.skin,p.vipskin,p.ar,p.money,p.s_bmx,p.newplayer,p.kills,p.deaths,p.ab_spray,p.church_visit,p.wanted,g.nazwa gg_nazwa,g.tag gg_tag ,gr.name gg_rank_name,pg.rank gg_rank_id ,pg.id_gang gg_id FROM psz_postacie p LEFT JOIN psz_players_gangs pg ON pg.id_player=p.userid LEFT JOIN psz_gangi g ON g.id=pg.id_gang LEFT JOIN psz_gangs_ranks gr ON gr.gang_id=pg.id_gang AND gr.rank_id=pg.rank WHERE p.userid=%d AND p.accepted=1",userid)
    local characters=exports["psz-mysql"]:pobierzTabeleWynikow(query)
    if (not characters or #characters<1) then
        kickPlayer(gracz,"Wystąpił błąd! Prosimy stwórz nowe konto lub zawiadom administratora.") -- Nigdy się nie wydarzy
        -- outputDebugString("ERROR MYSQL")
        return
    end

    for i,v in ipairs(characters) do
        if (getElementData(gracz,"vip") and characters[i].vipskin and tonumber(characters[i].vipskin) and tonumber(characters[i].vipskin)>0) then
            characters[i].skin=tonumber(characters[i].vipskin)
        end
        characters[i].nick=translit(characters[i].nick)

        setTimer(spawn,500,1,gracz,characters)

    end
end

local spawny ={
    {-252.04,2585.49,63.57},
    {1645.87,1302.43,12.5,270},
    {2485,-1667,13.3,0},
    {-2405,-598,132.6,128},
    { -2078.50,1426.83,9.02,183.5},
}
local playerCharacters={}
local player_character=1

function spawn(plr,data)
    playerCharacters = data
    setElementData(plr,"character",playerCharacters[player_character])
    local character=getElementData(plr,"character")
    if (not character or not character.skin) then
        kickPlayer(plr,"Nie udało się odnaleźć Twojej postaci.")
        return
    end
    local uid = getElementData(plr,"auth:uid")
    if (tonumber(character.newplayer)>0) then
        local query=string.format("UPDATE psz_postacie SET newplayer=0 WHERE userid=%d LIMIT 1",uid)
        exports["psz-mysql"]:zapytanie(query)
        character.newplayer=0
        setElementData(plr,"character",character)
        setElementData(plr,"newplayer",true)
        setTimer(function() removeElementData(plr,"newplayer") end, 15000,1)
        outputChatBox("Witaj na Polskim Serwerze Zabawy, wciśnij klawisz F9 aby zobaczyć krótki przewodnik po serwerze.",plr)
    end
    local aj = getElementData(plr,"kary:blokada_aj")
    if (aj) then
        outputChatBox("Posiadasz nałożony AJ, ilość minut: "..aj,plr,255,0,0,true)
        repeat until spawnPlayer(plr,1760.08,-1574.15,1734.94,90,tonumber(character.skin), 0,231)
    else
    local ssel = getElementData(plr,"spawn_select")
    if (ssel and tonumber(ssel)==1) then
        local x,y,z = unpack(spawny[math.random(1,#spawny)])
        repeat until spawnPlayer(plr,x+math.random(1,5),y+math.random(5,9),z)
    elseif(ssel and tonumber(ssel)==2 and character.gg_id) then
        local query=exports['psz-mysql']:pobierzWyniki(string.format("SELECT d.drzwi FROM psz_domy d WHERE d.owner_gang=%d",character.gg_id))
        query.drzwi=split(query.drzwi,",")
        for ii,vv in ipairs(query.drzwi) do query.drzwi[ii]=tonumber(vv) end
        repeat until spawnPlayer(plr,query.drzwi[1],query.drzwi[2],query.drzwi[3])
    else
        local x,y,z = unpack(spawny[math.random(1,#spawny)])
        repeat until spawnPlayer(plr,x+math.random(1,5),y+math.random(5,9),z)
    end
end
    setElementAlpha(plr,255)
    setPedArmor(plr,tonumber(character.ar))
    setPlayerWantedLevel(plr,tonumber(character.wanted))
    setPlayerMoney(plr, tonumber(character.money))
    setElementModel(plr, tonumber(character.skin))
    -- BMX skills
    setPedStat(plr, 229,tonumber(character.s_bmx)*10)
    setPedStat(plr, 230,tonumber(character.s_bmx)*10)
    
    fadeCamera(plr, true)
    setPlayerHudComponentVisible(plr,"all",true)
    removeElementData(plr,"justConnected")
    --triggerClientEvent("showOwnedHouse",root,plr)
    --triggerClientEvent("gui_showAll",root,clientRender)
    setCameraTarget(plr, plr)
    showChat(plr, true)
    if (isPlayerMuted(plr)) then
        exports["psz-admin"]:gameView_add("Gracz "..getPlayerName(plr).."/"..getElementData(plr,"id").." dolacza do gry z aktywnym wyciszeniem na chat")
    end
end
