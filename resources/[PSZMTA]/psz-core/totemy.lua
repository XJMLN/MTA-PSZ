--[[

Core - elementy do zbierania: totemy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
totemy = {}
local a_totem=nil
local function usunTotem(id)
    if isElement(totemy[id].totem) then destroyElement(totemy[id].totem) end
    if isElement(totemy[id].cs) then destroyElement(totemy[id].cs) end
    totemy[id] = nil
end

local function zaladujTotemy(v,fast)
    if totemy[v.id] then
        usunTotem(v.id)
    end

    v.pos = split(v.loc,",")
    for ii,vv in ipairs(v.pos) do v.pos[ii]=tonumber(vv) end

    local pickupid = 1276

    v.totem = createPickup(v.pos[1],v.pos[2],v.pos[3],3,pickupid,0)
    v.cs=createColSphere(v.pos[1],v.pos[2],v.pos[3], 1)

    local dimension = v.vw or 0
    local int = v.i or 0
    --outputDebugString(v.id)
    setElementData(v.cs,"totem", {
            ["id"]=v.id,
            ["vw"]=v.vw,
            ["int"]=v.i,
})

    local dbid=v.id
    v.id=nil
    totemy[dbid]=v

    return true
end

function totemyGetInfo(id)
    return totemy[id]
end

local function zaladujCzescTotemow(procent,fast)
    local tt=getTickCount()
i=0
    local totemki
    if fast then
        totemki=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT t.id,t.loc,t.i,t.vw FROM psz_totemy t WHERE t.actived=1;")
    else
        totemki=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT t.id,t.loc,t.i,t.vw FROM psz_totemy t WHERE t.actived=1;")
    end
        for __,v in ipairs(totemki) do
            if math.random(0,100)<=procent then
                if zaladujTotemy(v,fast) then i=i+1 end
            end
        end
    outputDebugString("Zaladowano totemow: "..i.. " w "..(getTickCount()-tt).."ms")
end

addEventHandler("onResourceStart",resourceRoot,function()
   zaladujCzescTotemow(100,false)
end)

function totemReload(id)
    local totemki=exports["psz-mysql"]:pobierzWyniki("SELECT t.td,t.loc,t.i,t.vw,t.activated FROM psz_totemy WHERE t.actived=1 and t.id=?;",id)
    if totemki then
        return zaladujTotemy(totemki)
    end
    return false
end


addEventHandler("onColShapeHit",resourceRoot,function(thePlayer,matchingDimension)
    local totem = getElementData(source,"totem")
    local c = getElementData(thePlayer,"character")
    if (not matchingDimension) then return end
    if (not totem) then return end
    --outputDebugString(totem.id)
    if getElementType(thePlayer) == "player" then
    if (not c) then
    outputChatBox("Tylko zalogowani gracze mogą zbierać totemy.",thePlayer,255,0,0)
        return
    end
    local q = string.format("SELECT * FROM psz_players_totemy WHERE id_gracza=%d AND id_paczki=%d",getElementData(thePlayer,"auth:uid"),tonumber(totem.id))
    local collectTotems=exports["psz-mysql"]:pobierzWyniki(q)
    if collectTotems then outputChatBox("Zebrałeś już wcześniej ten totem.",thePlayer) return end
        local qq = string.format("INSERT IGNORE INTO psz_players_totemy SET id_paczki=%d,id_gracza=%d",totem.id,getElementData(thePlayer,"auth:uid"))
        local takeTotem=exports["psz-mysql"]:zapytanie(qq)
        if takeTotem >0 then
            local all= exports["psz-mysql"]:pobierzWyniki("SELECT count(id) ile FROM psz_totemy WHERE actived=1")
            local ilosc = exports["psz-mysql"]:pobierzWyniki(string.format("SELECT count(id_paczki) il FROM psz_players_totemy WHERE id_gracza=%d",getElementData(thePlayer,"auth:uid")))
            exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_players_scores SET player_id=%d,nazwa='TOTEMY',score=1 ON DUPLICATE KEY UPDATE score=score+1",getElementData(thePlayer,"auth:uid")))
            outputChatBox(string.format("Odnalazłeś swój %d totem, otrzymujesz %d$! Pozostało do odnalezienia: %d.",ilosc.il,ilosc.il*2,all.ile-ilosc.il),thePlayer)
            givePlayerMoney(thePlayer,ilosc.il*2)
            exports["psz-admin"]:gameView_add("ZNAJDZKA gracz "..getPlayerName(thePlayer)..", odnajduje (totem): "..ilosc.il.."/"..all.ile.." , nagroda: "..(ilosc.il*2) .."$")
        end
    end
end
)
