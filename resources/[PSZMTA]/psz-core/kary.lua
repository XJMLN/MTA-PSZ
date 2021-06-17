--[[

Core - kary

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local I = 0
local D = 231

local mexit = createMarker(1780.55,-1576.44,1734.94,"arrow",1)
local aj_cs = createColSphere(1768.89,-1572.70,1734.94,35)
setElementInterior(aj_cs,I)
setElementDimension(aj_cs,D)
setElementInterior(mexit,I)
setElementDimension(mexit,D)
local texit = createElement("text")
setElementPosition(texit,1780.55,-1576.44, 1735.4)
setElementDimension(texit,D)
setElementData(texit,"text","Wyjście z AJ")

addEventHandler("onMarkerHit", mexit, function(el,md)
    if (not md) then return end
    if (getElementType(el)~="player") then return end
    local uid = getElementData(el,"auth:uid")
    local aj=getElementData(el, "kary:blokada_aj")
    local ajC = exports['psz-mysql']:pobierzWyniki(string.format("SELECT blokada_aj FROM psz_players WHERE id=%d",uid))
   	if (not aj or tonumber(aj)<1 or tonumber(ajC.blokada_aj)<1) then 
        setElementPosition(el,628.15,-571.89,17.36)
        setElementRotation(el,0,0,270)
        setElementInterior(el,0)
        setElementDimension(el,0)
        removeElementData(el,"kary:blokada_aj")
        outputChatBox("Wychodzisz z Admin Jail'a, mamy nadzieję że będziemy Ciebie tam widywać jak najrzadziej.",el,255,0,0)
        return
    else
        outputChatBox("Twój AJ kończy sie za ".. aj .." min.", el, 255,0,0,true)
    end
end)

function isPlayerInAJ(plr)
    local uid=getElementData(plr,"auth:uid") or 0
    local q = string.format("SELECT blokada_aj FROM psz_players WHERE id=%d",uid)
    pasujaca_kara = exports['psz-mysql']:pobierzWyniki(q)
    if (pasujaca_kara and tonumber(pasujaca_kara.blokada_aj)>0) then 
        setElementData(plr,"kary:blokada_aj",tonumber(pasujaca_kara.blokada_aj))
    elseif(pasujaca_kara and tonumber(pasujaca_kara.blokada_aj)==0) then 
    -- skoro nie ma na koncie, sprawdźmy jeszcze czy jest na serialu
    local q = string.format("SELECT k.date_end, k.id_player, k.reason FROM psz_kary k WHERE k.serial='%s' AND k.date_end>NOW() ORDER BY k.date_end DESC LIMIT 1",getPlayerSerial(plr))
    pasujaca_kara = exports['psz-mysql']:pobierzWyniki(q)
    if (pasujaca_kara and tonumber(pasujaca_kara.id_player)>0) then 
        local t = exports['psz-mysql']:pobierzWyniki(string.format("SELECT blokada_aj FROM psz_players WHERE id=%d",pasujaca_kara.id_player))
        if (t and tonumber(t.blokada_aj)>0) then 
            setElementData(plr,"kary:blokada_aj",t.blokada_aj)
        end
    end
end
    return false
end

function isSerialInAJ(serial)
    local q = string.format("SELECT id FROM psz_kary WHERE rodzaj='Admin Jail' AND serial='%s' AND date_end>NOW() ORDER BY date_end DESC LIMIT 1",serial)
    pasujaca_kara = exports['psz-mysql']:pobierzWyniki(q)
    if (pasujaca_kara and tonumber(pasujaca_kara.id)>0) then return true end
    return false
end

function aj_process()
    for i,v in ipairs(getElementsWithinColShape(aj_cs,"player")) do
    local aj=getElementData(v, "kary:blokada_aj")
    local uid=getElementData(v,"auth:uid")
    
    if (uid and tonumber(aj)) then
        aj=tonumber(aj)-1
        setElementData(v,"kary:blokada_aj",aj)
        if (aj<0) then aj=0 end
        local query=string.format("UPDATE psz_players SET blokada_aj=%d WHERE id=%d LIMIT 1",aj,uid)
        exports['psz-mysql']:zapytanie(query)
        if (aj<=0) then
            outputChatBox("Twój AJ się skończył, możesz opuścić więzienie.", v, 255,0,0,true)
            removeElementData(v,"kary:blokada_aj")
        end
    end
    end
end

setTimer(aj_process, 60000, 0)