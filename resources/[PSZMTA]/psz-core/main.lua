--[[

Core - nagrody za zabójstwa, respawn gracza
@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local ainfo_txt = {
    {"Wszystkie przydatne informacje typu pomoc, regulamin znajdziesz pod klawiszem F9."},
    {"Jeśli potrzebujesz pomocy administracji, pisz /raport. Pomoc pod klawiszem F9."},
    {"Oficjalny TeamSpeak3 serwera: pszmta.pl"},
    {"Oficjalna strona serwera: pszmta.pl"},
    {"Aktualną listę ekipy serwera na serwerze, znajdziesz pod komendą /admins."},
    {"Dodaj do nicku tag PSZ, aby otrzymywać co 15 minut 50$. Zmiana nicku dostępna pod komendą /nick."},
}
local ainfo_colors = {
    {"#FF9700"},
    {"#00FFE4"},
    {"#FF0070"},
    {"#FBFF00"},
}
function ainfo_randomize()
    return math.random(1,#ainfo_txt)
end

function ainfo_getData()
    local i = ainfo_randomize()
    return ainfo_txt[i][1],ainfo_colors[math.random(1,#ainfo_colors)][1]
end

function ainfo_botinit()
    local data,hex = ainfo_getData()
    if data then 
        for k,v in ipairs(getElementsByType("player")) do
            outputChatBox(" ",v)
            outputChatBox(hex.."►►   AUTOINFO   #FFFFFF"..data,v,255,255,255,true)
            outputChatBox(" ",v)
        end
    end
end
setTimer(ainfo_botinit,300000,0)

function giveMoney15()
    for k,v in ipairs(getElementsByType("player")) do
        local checknick = string.find(getPlayerName(v),"PSZ",1,true)
        if checknick then
        	if getElementData(v,"vip") then
        		givePlayerMoney(v,100)
        		outputChatBox("Otrzymujesz 100$ w nagrodę za tag PSZ.(Bonus VIP)",v,0,240,0)
        	else
            givePlayerMoney(v,50)
            outputChatBox("Otrzymujesz 50$ w nagrodę za tag PSZ.",v,0,240,0)
        end
        end
    end
end
setTimer(giveMoney15, 900000, 0)

--function infoPlusTag()
  --  for k,v in ipairs(getElementsByType("player")) do
    --    outputChatBox("Aby zdobyć dodatkowe pieniądze dodaj przed nickiem tag",v,39,245,217)
     --   outputChatBox("PSZ, np. |PSZ|Kacper. Co 15minut otrzymywać będziesz 50$.",v,39,245,217)
    --end
--end
--setTimer(infoPlusTag,900000,0)

function rewardOnWasted ( ammo, killer, killerweapon, bodypart )
    if ( killer ) and ( killer ~= source ) then
            local c = getElementData(killer,"character")
            if (not c) then return end
            local ile = tonumber(c.kills)+1
            c.kills=ile
            setElementData(killer,"character",c)
            givePlayerMoney(killer,math.random(1,30))
            local char = getElementData(source,"character")
            if (not char) then return end
            local ile = tonumber(char.deaths)+1
            char.deaths = ile
            setElementData(source,"character",char)
    else
    local char = getElementData(source,"character")
        if (not char) then return end
    local ile = tonumber(char.deaths)
    char.deaths = tonumber(ile)+1
    setElementData(source,"character",char)
    end
end
addEventHandler ( "onPlayerWasted", getRootElement(), rewardOnWasted )

local spawny ={
    {-252.04,2585.49,63.57},
    {1645.87,1302.43,12.5,270},
    {2485,-1667,13.3,0},
    {-2405,-598,132.6,128},
    { -2078.50,1426.83,9.02,183.5},
}
function death()
    if getElementData(source,"justConnected") then
        setElementHealth(source,100)
        setElementPosition(source,-252.04, 2585.49, 64)
        setElementDimension(source,0)
        setElementInterior(source,0)
        setCameraTarget(source,source)
        return
    end
    local c = getElementData(source,"character")
    local x,y,z = unpack(spawny[math.random(1,#spawny)])
    if (c and c.skin) then
    repeat until setTimer(spawnPlayer,3000,1,source,x+math.random(0.1,3),y+math.random(0.2,4),z,0,c.skin and tonumber(c.skin),0,0)
    else
        repeat until setTimer(spawnPlayer,3000,1,source,x+math.random(0.1,3),y+math.random(0.2,4),z,0,0,0,0)
    end
    fadeCamera(source,true)
    setCameraTarget(source,source)
    if getPlayerMoney(source)>=50 then
        kwota = math.random(10, 50)
        takePlayerMoney(source,kwota)
        outputChatBox("Zginąłeś, straciłeś $"..kwota,source,255,0,0)
    end
    local fr = getElementData(source,"faction:data")
    if (fr and tonumber(fr.id)>0) then 
        setTimer(setPlayerFactionSkin,3100,1,source,fr.id)
    end
end
addEventHandler ( "onPlayerWasted", getRootElement(),death)


function doPlayerHaveHouse(who)
    local uid = getElementData(who, "auth:uid") or 0
    if (not uid or uid== 0) then return end
    local q = string.format("SELECT drzwi FROM psz_domy WHERE ownerid=%d", uid)
    local wynik = exports['psz-mysql']:pobierzWyniki(q)
    if (wynik) then 
        wynik.drzwi=split(wynik.drzwi,",")
        for ii,vv in ipairs(wynik.drzwi) do     wynik.drzwi[ii]=tonumber(vv)    end
            --blip createBlip ( float x, float y, float z [, int icon = 0, int size = 2, int r = 255, int g = 0, int b = 0, int a = 255, int ordering = 0, float visibleDistance = 99999.0, visibleTo = getRootElement( ) ] )
        createBlip(wynik.drzwi[1], wynik.drzwi[2], wynik.drzwi[3],32, 2, 255,0,0,255,0,500000, who )
    end
end

function setPlayerFactionSkin(who, fid)
    if not fid then return end -- nie powinno sie wydarzyc

    if fid == 1 then 
        setElementModel(who,math.random(274,276))
    elseif fid == 2 then 
        setElementModel(who,math.random(280,282))
    elseif fid == 3 then 
        setElementModel(who, 277)
    elseif fid == 4 then 
        setElementModel(who,147)
    end
end

function VIP_addarmor()
    if (client and getElementData(client, "vip")) then 
        local c = getElementData(client, "character")
        c.ar = 100
        setPedArmor(client, c.ar)

        setElementData(client, "character", c)
        takePlayerMoney(client, 250)
        outputChatBox("Kamizelka została nadana. Kolejną możesz odnowić za 5 minut.", client, 255,0,0)
    end
end

addEvent("VIP_addArmorToPlayer", true)
addEventHandler("VIP_addArmorToPlayer", root, VIP_addarmor)


function VIP_spawnVehicle(model)
    if (client and getElementData(client, "vip")) then
        model = tonumber(model)
    -- vipSpecial          | timestamp            | NO   |     | 0000-00-00 00:00:00 |  SELECT 1 FROM psz_players WHERE id=1 AND vipSpecial > NOW() - INTERVAL 1 DAY;
    local q = string.format("SELECT 1 FROM psz_players WHERE id=%d AND vipSpecial >=NOW() - INTERVAL 1 DAY;",getElementData(client,"auth:uid"))
    local wynik = exports['psz-mysql']:zapytanie(q)
    if (wynik and wynik>0) then
        outputChatBox("Musisz odczekać 24 godziny przed kolejnym stworzeniem pojazdu.",client,255,0,0)
        return
    end
        if (model == 520) then 
            exports['psz-vehicles']:spVIP_createVeh(model,client)
            exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET vipSpecial=NOW() WHERE id=%d",getElementData(client, "auth:uid")))
            outputChatBox("Pojazd został stworzony!", client, 255,0,0)
        else
            outputChatBox("Wystąpił błąd!",client,255,0,0)
        end
    end
end

addEvent("VIP_spawnVehicleForPlayer", true)
addEventHandler("VIP_spawnVehicleForPlayer", root, VIP_spawnVehicle)