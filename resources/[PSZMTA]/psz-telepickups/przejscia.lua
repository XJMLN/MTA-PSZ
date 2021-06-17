--[[

telepickups - przejscia

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-telepickups
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local przejscia = {}

local function usunPrzejscie(id)
    if isElement(przejscia[id].marker) then destroyElement(przejscia[id].marker) end
    if isElement(przejscia[id].text) then destroyElement(przejscia[id].text) end
    przejscia[id]=nil
end

local function dodajPrzejscie(v,fast)
    if przejscia[v.id] then
        usunPrzejscie(v.id)
    end

    v.pos = split(v.wejscie,",")
    for ii,vv in ipairs(v.pos) do v.pos[ii]=tonumber(vv) end
    v.tepi_pos = split(v.tepi_pos,",")
    for ii,vv in ipairs(v.tepi_pos) do v.tepi_pos[ii]=tonumber(vv) end

    v.marker = createMarker(v.pos[1],v.pos[2],v.pos[3],"arrow",1,19,79,209)
    setElementDimension(v.marker,v.vw)
    setElementInterior(v.marker,v.i)

    v.text = createElement("text")
    setElementPosition(v.text,v.pos[1],v.pos[2],v.pos[3]+0.5)
    setElementData(v.text,"text",("(( "..v.descr.." ))" or "(( Przejście ))"))
    setElementDimension(v.text,v.vw)
    setElementInterior(v.text,v.i)

    setElementData(v.marker,"przejscie", {
        ['id']=v.id,
        ['descr']=v.descr or "(( Przejście ))",
        ['tp_pos']=v.tepi_pos,
        ['vw']=v.tdim,
        ['int']=v.ti,
        ['zamkniety']=v.zamkniety>0 and true or false,
    })

    local dbid=v.id
    v.id=nil
    przejscia[dbid]=v

    return true
end


function przejsciaInfo(id)
    return przejscia[id]
end

local function zaladujPrzejscia(procent,fast)
    local tt= getTickCount()
    i = 0
    local dbprze
    dbprze=exports['psz-mysql']:pobierzTabeleWynikow("SELECT p.id,p.descr,p.wejscie,p.tepi_pos,p.ti,p.tdim,p.i,p.vw,p.zamkniety FROM psz_przejscia p WHERE p.active=1;")
    for __,v in ipairs(dbprze) do
        if math.random(0,100)<=procent then
            if dodajPrzejscie(v,fast) then i=i+1 end
        end
    end
    outputDebugString("Zaladowano przejść: "..i.." w "..(getTickCount()-tt).."ms")
end

addEventHandler("onResourceStart",resourceRoot,function()
    zaladujPrzejscia(100,false)
end)

local function zaladujZmienione()
    local i=0
    local dbprze = exports['psz-mysql']:pobierzTabeleWynikow("SELECT p.id,p.descr,p.wejscie,p.tepi_pos,p.ti,p.tdim,p.i,p.vw,p.zamkniety FROM psz_przejscia p WHERE p.active=1 AND timediff(now(),p.updated)<'00:09:00' AND datediff(now(),p.updated)<1")
    for __,v in ipairs(dbprze) do
        if dodajPrzejscie(v) then i=i+1 end
    end
    outputDebugString("Zaladowano zmienionych przejść: "..i)
end

setTimer(zaladujZmienione, 150000,0) -- 2.5minuty

function przejscieReload(id)
    local dbprze = exports['psz-mysql']:pobierzWyniki("SELECT p.id,p.descr,p.wejscie,p.tepi_pos,p.ti,p.tdim,p.i,p.vw,p.zamkniety FROM psz_przejscia p WHERE p.active=1 AND p.id=?;",id)
    if dbprze then
        return dodajPrzejscie(dbprze)
    end
    return false
end

function moveMeTo(x,y,z,i,vw,gracz)
    setElementDimension(gracz,vw)
    setElementInterior(gracz,i,x,y,z)
    setElementPosition(gracz,x,y,z)
    setElementInterior(gracz,i)
    setElementFrozen(gracz,true)
    setTimer(function() setElementFrozen(gracz, false) end, 500, 1) -- zeby czasem pod obiekty nie wpadali
end

function przejscieEnter(hitElement,matchingDimension)
    if (getElementType(hitElement)~="player") then return end
    if (not matchingDimension) then return end
    if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
    if (getPedOccupiedVehicle(hitElement)) then return end
    local przejscie = getElementData(source,"przejscie")
    if not przejscie then return end
    if not przejscie.zamkniety then
        moveMeTo(przejscie.tp_pos[1],przejscie.tp_pos[2],przejscie.tp_pos[3],przejscie.int,przejscie.vw,hitElement)
    elseif przejscie.zamkniety then 
        outputChatBox("Przejście zostało zamknięte.",hitElement,255,0,0) 
        return false 
    end
end
addEventHandler("onMarkerHit",resourceRoot,przejscieEnter)
