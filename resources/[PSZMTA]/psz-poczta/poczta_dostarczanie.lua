--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local I=1
local D=51

local punkt_dystrybucji=createMarker(2812,-1085,1594,"corona",1,255,255,255,150)
setElementDimension(punkt_dystrybucji,D)
setElementInterior(punkt_dystrybucji,I)

function poczta_zapelnijTorbe(gracz)
    i=0
    local q = string.format("SELECT p.id,d.drzwi,p.odbiorca,p.nadawca FROM psz_poczta p JOIN psz_domy d ON p.odbiorca=d.ownerid WHERE p.dostarczone=0 AND d.drzwi IS NOT NULL ORDER BY RAND() LIMIT 1")
    local wynik = exports['psz-mysql']:pobierzTabeleWynikow(q)
    for __,v in ipairs(wynik) do
        if triggerClientEvent(gracz,"onPlayerGetDeliveryPackage",gracz,v) then
            i=i+1 
        end
    end
    if (i==0) then
        outputChatBox("Pani Grażynka mówi: Nie ma obecnie listów do rozwiezienia.",gracz)
    else
        outputChatBox("Pani Grażynka mówi: Miejsca docelowe zostały zaznaczone na Twoim radarze za pomocą literki 'C'.",gracz)
        outputChatBox("Wejdź do pojazdu kurierskiego i zawieź listy.",gracz)
        setElementData(gracz,'praca:kurier',true)
        setElementModel(gracz,71)
        setElementPosition(gracz,978.75-math.random(0.5,5),2209.64,11)
        setElementDimension(gracz,0)
        setElementInterior(gracz,0)
    end
end

function poczta_nieprzeczytanych(gracz)
    local c = getElementData(gracz,'character') 
    if (not c or not c.id) then return end
    
    local q = string.format("SELECT count(id) FROM psz_poczta WHERE odbiorca=%d AND dostarczone=1 AND przeczytane=0;",tonumber(c.id))
    local wynik = exports['psz-mysql']:zapytanie(q)
    if (wynik>0) then
        return wynik end
    end

function poczta_botDelivery()
	-- Ponizszy kod jest baardzo nie optymalny, wymaga przerobienia. 
	-- Chociaz w sumie jest uzywany raz na 24h, soo...
	i=0
	local sf_insert = string.format("UPDATE psz_poczta SET dostarczone=1 WHERE DATEDIFF(now(),ts)>1;");
	local sf_select = string.format("SELECT count(id) as liczba FROM psz_poczta WHERE dostarczone=0;");
	
	local select = exports['psz-mysql']:pobierzWyniki(sf_select);
	
	for __,v in ipairs(select) do
		i=v.liczba
	end
	if (i==0) then
		outputDebugString("Brak listów do rozwiezienia.");
	else
		exports['psz-mysql']:zapytanie(sf_insert);
		outputDebugString("Zmieniono status "..i.." nie dostraczonych listów, na dostarczone.");
	end
end
setTimer(poczta_botDelivery,86400000,0)
poczta_botDelivery();
addEvent('onPlayerDeliveryPackage',true)
addEventHandler('onPlayerDeliveryPackage',root,function(id)
    if (id and tonumber(id)) then
            local c = getElementData(source,'character')
        local q = string.format("UPDATE psz_poczta SET dostarczone=1 WHERE id=%d LIMIT 1",tonumber(id))
        exports['psz-mysql']:zapytanie(q)
        local PZ = getElementData(source,'PZ')
        local praca = getElementData(source,'praca:kurier')
        if (praca) then
            removeElementData(source, 'praca:kurier')
            setElementModel(source,tonumber(c.skin))
        end
        givePlayerMoney(source,55)
        PZ = PZ+1
        setElementData(source,'PZ',PZ)
    end
end)

addEventHandler("onMarkerHit",punkt_dystrybucji, function(el,md)
    if (not md) then return end
    if (getElementType(el)~='player') then return end
    local c = getElementData(el,'character')
    if (not c or not c.id) then 
        outputChatBox("Ta praca dostępna jest jedynie dla zalogowanych graczy.",el)
        return
    end
    if (getElementData(el,'praca:kurier')) then
        outputChatBox("Odebrałeś już listy, dostarcz je!",el)
        return
    end
    poczta_zapelnijTorbe(el)
end)

function poczta_deliveryDeath ( ammo, killer, killerweapon, bodypart )
    if not getElementData(source,"praca:kurier") then return end
    setTimer(function(plr)
    outputChatBox("Zostałeś zabity, przeniesiono Ciebie pod siedzibę firmy",plr,255,0,0)
    setElementPosition(plr,984.99,2200.30,10.82)
    setElementDimension(plr,0)
    setElementInterior(plr,0)
    end,4000,1,source)
end
addEventHandler ( "onPlayerWasted", getRootElement(), poczta_deliveryDeath)