garaze={}

local function usunGaraz(id)
    if isElement(garaze[id].wejscie) then destroyElement(garaze[id].wejscie) end
    if isElement(garaze[id].colshape) then destroyElement(garaze[id].colshape) end
    if isElement(garaze[id].text) then destroyElement(garaze[id].text) end
    garaze[id]=nil
end

local function dodajGaraze(v,fast)
    if garaze[v.id] then
        usunGaraz(v.id)
    end

    v.wejscie=split(v.wejscie,",")

    for ii,vv in ipairs(v.wejscie) do v.wejscie[ii]=tonumber(vv) end
    v.colshape=split(v.colshape,",")
    for ii,vv in ipairs(v.colshape) do v.colshape[ii]=tonumber(vv) end

    local c1,c2,c3 = 0,150,0
    if (not v.ownerid) then
        c1,c2,c3=150,0,0
    end

    v.drzwi=createMarker(v.wejscie[1],v.wejscie[2],v.wejscie[3],"cylinder",1,c1,c2,c3,200)
    v.cs=createColCuboid(v.colshape[1],v.colshape[2],v.colshape[3],v.colshape[4],v.colshape[5],v.colshape[6])
    --setElementParent(v.cs,v.wejscie)
    if (not v.ownerid) then
        v.text=createElement('text')
        setElementPosition(v.text,v.wejscie[1],v.wejscie[2],v.wejscie[3]+0.5)
        setElementData(v.text,'text',v.descr.."\nCena: "..v.koszt.."$\nIlość miejsc na pojazdy: 5")
    else
        v.text=createElement('text')
        setElementPosition(v.text,v.wejscie[1],v.wejscie[2],v.wejscie[3]+0.5)
        setElementData(v.text,'text',v.descr.."\nWłaściciel: "..v.owner_nick)
    end

    setElementData(v.drzwi, "garaz", {
        --['zamkniety']=v.zamkniety>0 and true or false,
        ['id']=v.id,
        ['koszt']=v.koszt,
        ['ownerid']=v.ownerid,
        ['owner_nick']=v.owner_nick,
        ['descr']=v.descr or "Garaż",
        ['paidTo']=v.paidTo,
        ['paidTo_dni']=v.paidTo_dni,
        ['gate_id']=v.gate_id,
    })
    setElementData(v.cs,'garaz',{
        ['id']=v.id,
        ['ownerid']=v.ownerid,
        ['gate_id']=v.gate_id,
    })

    local dbid=v.id
    v.id=nil
    garaze[dbid]=v

    return true
end

function garazeGetInfo(id)
    return garaze[id]
end

local function zaladujCzescGarazy(procent,fast)
    local tt=getTickCount()
    i=0
    exports['psz-mysql']:zapytanie('UPDATE psz_garaze SET paidTo=NULL,ownerid=NULL WHERE paidTo<NOW() OR paidTo IS NULL')
    local dbgaraze
    if fast then
        dbgaraze=exports['psz-mysql']:pobierzTabeleWynikow('SELECT g.id,g.descr,g.wejscie,g.colshape,g.gate_id,g.koszt,g.paidTo,g.updated,g.ownerid,concat(c.nick) owner_nick,datediff(g.paidTo,now()) paidTo_dni FROM psz_garaze g LEFT JOIN psz_postacie c ON c.userid=g.ownerid WHERE g.active=1 AND g.ownerid IS NOT NULL;')
    else
        dbgaraze=exports['psz-mysql']:pobierzTabeleWynikow("SELECT g.id,g.descr,g.wejscie,g.colshape,g.gate_id,g.koszt,g.paidTo,g.updated,g.ownerid,concat(c.nick) owner_nick,datediff(g.paidTo,now()) paidTo_dni FROM psz_garaze g LEFT JOIN psz_postacie c ON c.userid=g.ownerid WHERE g.active=1;")
    end
    for __,v in ipairs(dbgaraze) do
        if math.random(0,100)<=procent then
            if dodajGaraze(v,fast) then i=i+1 end
        end
    end
    outputDebugString("Zaladowano garazy: "..i.." w ".. (getTickCount()-tt) .."ms")
end
setTimer(zaladujCzescGarazy,86525000,0,100)
addEventHandler('onResourceStart',resourceRoot,function()
    zaladujCzescGarazy(100,false)
end)

local function zaladujZmienioneGaraze()
    local i=0
    local dbgaraze=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT g.id,g.descr,g.wejscie,g.colshape,g.gate_id,g.koszt,g.ownerid,concat(c.nick) owner_nick,g.paidTo,datediff(g.paidTo,now()) paidTo_dni FROM psz_garaze g LEFT JOIN psz_postacie c ON c.id=g.ownerid WHERE g.active=1 AND timediff(now(),g.updated)<'00:09:00' AND datediff(now(),g.updated)<1")
    for __,v in ipairs(dbgaraze) do

        if dodajDom(v) then i=i+1 end
    end
    outputDebugString("Zaladowano zmienionych garazy: " .. i)
end

setTimer(zaladujZmienioneGaraze, 10*1000*5, 0)


function garazReload(id)
    local dbgaraz=exports["psz-mysql"]:pobierzWyniki("SELECT g.id,g.descr,g.wejscie,d.colshape,g.ownerid,g.colshape,g.gate_id,concat(c.nick) owner_nick,g.koszt,g.paidTo,datediff(g.paidTo,now()) paidTo_dni FROM psz_garaze g LEFT JOIN psz_postacie c ON c.id=g.ownerid WHERE g.active=1 and g.id=?;",id)
    if dbgaraz then
        return dodajGaraz(dbgaraz)
    end
    return false
end

local function getPlayerDBID(plr)
	local c=getElementData(plr,"character")
	if not c then return nil end
	return tonumber(c.id)
end

local garaz = {}
garaz.animacja=false
garaz.zamknieta=true
garaz.otworz = function(gracz,garazid)
    if (garaz.animacja or not garaz.zamknieta) then return false end
    garaz.animacja=true
    triggerEvent("loadVehiclesForGarage",gracz,garazid)
    moveObject(garaz.o,7000,3071.73,-889.10,18.28,-90,0,0,"OutBounce")
    setTimer(function() garaz.animacja=false garaz.zamknieta=false end, 600,1)
end
garaz.zamknij = function(gracz,garazid)
    if (garaz.animacja or garaz.zamknieta) then return false end
    garaz.animacja = true
    triggerEvent('saveVehiclesForGarage',gracz,garazid)
    moveObject(garaz.o,7000,3071.72,-889.10,18.28,90,0,0,"OutBounce")
    setTimer(function() garaz.animacja=false garaz.zamknieta=true end, 600,1)
end

garaz.toggle=function(gracz,garazid)
    if (garaz.zamknieta) then
        garaz.otworz(gracz,garazid)
    else
        garaz.zamknij(gracz,garazid)
    end
end
addEvent("onGarazOpenRequest",true)
addEventHandler("onGarazOpenRequest", getRootElement(), function(gracz,garazid)
    garaz.o = getElementByID(garazid)
    garaz.toggle(gracz,garazid)
end)
