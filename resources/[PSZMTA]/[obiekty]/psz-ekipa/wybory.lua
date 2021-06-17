--[[
Okazjonalnie uzywany zasob do przeprowadzania wyborów w ekipie
@author Lukasz Biegaj <wielebny@bestplay.pl>
@author Karer <karer.programmer@gmail.com>
@author WUBE <wube@lss-rp.pl>
@copyright 2011-2013 Lukasz Biegaj <wielebny@bestplay.pl>
@license Dual GPLv2/MIT
@package MTA-XyzzyRP
@link https://github.com/lpiob/MTA-XyzzyRP GitHub
]]--

local ID_WYBOROW=5
local M_GLOSOW=3
local D=3
local I=121

local cs=createColSphere(985.61,-2150.13,28.03,2)
setElementDimension(cs,D)
setElementInterior(cs,I)
setElementData(cs,"wybory_cs",true)

local function hasPlayerVoteEnded(dbid)
    local q = string.format("SELECT COUNT(*) ilosc FROM psz_wybory WHERE id_wyborow=%d AND player_id=%d;",ID_WYBOROW,dbid)
    local dane = exports['psz-mysql']:pobierzWyniki(q)
    if (dane.ilosc>= M_GLOSOW) then return true end
    return false
end

local function checkDoubleVotes(dbid, u_dbid)
    local q = string.format("SELECT 1 FROM psz_wybory WHERE id_wyborow=%d AND player_id=%d AND wybor=%d",ID_WYBOROW,dbid,u_dbid)
    local dane = exports['psz-mysql']:pobierzWyniki(q)
    if (dane) then return true end
    return false
end
addEventHandler("onColShapeHit", cs, function(el,md)
    if not md then return end
    if getElementType(el)~="player" then return end
    if (not getElementData(source,"wybory_cs")) then return end
    local level = getElementData(el,"level") or 0
    if (level and level<1) then return end
    local dbid = getElementData(el,"auth:uid") or 0
    if (dbid and dbid<1) then return end
    if (hasPlayerVoteEnded(dbid)) then 
        outputChatBox("Nie możesz oddać już więcej głosów.",el,255,0,0)
        return
    end
    local q = string.format("SELECT COUNT(*) ilosc FROM psz_wybory WHERE id_wyborow=%d AND player_id=%d;",ID_WYBOROW,dbid)
    local ilosc = exports['psz-mysql']:pobierzWyniki(q)
    local dane = exports['psz-mysql']:pobierzTabeleWynikow("SELECT wp.user_id, wp.serial,wp.description,p.nick FROM psz_wybory_podania wp JOIN psz_postacie p ON p.userid=wp.user_id")
    triggerClientEvent(el,"onKartaDoGlosowania",resourceRoot, dane,ilosc.ilosc)
end)

addEvent("onAdminReceiveVote",true)
addEventHandler("onAdminReceiveVote",resourceRoot, function(u_id)
    if (not u_id) then return end
    local dbid = getElementData(client,"auth:uid") 
    if (not dbid) then return end
    local q = string.format("SELECT COUNT(*) ilosc FROM psz_wybory WHERE id_wyborow=%d AND player_id=%d;",ID_WYBOROW,dbid)
    local ilosc = exports['psz-mysql']:pobierzWyniki(q)
    if (ilosc and ilosc.ilosc>=M_GLOSOW) then 
        outputChatBox("NIe możesz oddać więcej głosów.", client, 255,0,0)
        return 
    end
    if (checkDoubleVotes(dbid,u_id)) then
        outputChatBox("Oddałeś już głos na tą osobę, musisz wybrać inną.",client,255,0,0)
        return
    end

    exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_wybory SET id_wyborow=%d, player_id=%d, wybor=%d,ts=NOW()",ID_WYBOROW, dbid, u_id))
    outputChatBox("Głos został zarejestrowany!",client,255,0,0)
end)
local ped=createPed(54,985.61,-2150.13,28.03,90, false)
setElementInterior(ped, I)
setElementDimension(ped, D)
setElementFrozen(ped, true)
setElementData(ped, "npc", true)
setElementData(ped,"name","Pracownik")

local text = createElement("ctext")
setElementPosition(text,2174.95,-1783.77,1423.33)
setElementData(text,"ctext","Głosowania")
setElementData(text,"scale",2)
setElementInterior(text,I)
setElementDimension(text,D)