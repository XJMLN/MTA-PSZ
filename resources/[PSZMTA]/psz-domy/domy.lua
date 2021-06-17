


domy={}

local function usunDom(id)
    if isElement(domy[id].wyjscie) then destroyElement(domy[id].wyjscie) end
    if isElement(domy[id].wejscie) then destroyElement(domy[id].wejscie) end
    if isElement(domy[id].cs) then destroyElement(domy[id].cs) end
    if isElement(domy[id].text) then destroyElement(domy[id].text) end
    domy[id]=nil
end

local function dodajDom(v,fast)

    if not interiory[v.interiorid] then return false end
    --	if tonumber(v.id)==151 then
    --		outputChatBox("151")
    --	end

    if domy[v.id] then
        usunDom(v.id)
    end

    v.drzwi=split(v.drzwi,",")
    for ii,vv in ipairs(v.drzwi) do		v.drzwi[ii]=tonumber(vv)	end
    v.punkt_wyjscia=split(v.punkt_wyjscia,",")
    for ii,vv in ipairs(v.punkt_wyjscia) do		v.punkt_wyjscia[ii]=tonumber(vv)	end
    local pickupid=1272
    --local c1,c2,c3=255,0,0
    if (not v.ownerid) then
        pickupid=1273
    --    c1,c2,c3=0,150,0
    end
--    if (v.vehicles_allowed) then
--        v.wejscie=createMarker(v.drzwi[1],v.drzwi[2],v.drzwi[3],"cylinder",1,c1,c2,c3,50)
--    else
    v.wejscie=createPickup ( v.drzwi[1], v.drzwi[2], v.drzwi[3], 3, pickupid, 0)
    v.cs=createColSphere(v.drzwi[1],v.drzwi[2],v.drzwi[3], 1)
--    end
    if (not v.ownerid) then
        v.text=createElement("text")
        setElementPosition(v.text, v.drzwi[1],v.drzwi[2],v.drzwi[3]+0.5)
        setElementData(v.text,"text",v.descr.."\nCena: "..v.koszt.."$")
    elseif (v.owner_gang and v.ownerid) then
        v.text=createElement("text")
        setElementPosition(v.text, v.drzwi[1],v.drzwi[2],v.drzwi[3]+0.5)
        setElementData(v.text,"text",v.descr.."\nWłaściciel: "..v.owner_nick.."\nNależy do: "..(v.name_gang).." ")
    elseif (v.ownerid) then
        v.text=createElement("text")
        setElementPosition(v.text, v.drzwi[1],v.drzwi[2],v.drzwi[3]+0.5)
        setElementData(v.text,"text",v.descr.."\nWłaściciel: "..v.owner_nick)
    end
    local interior_dimension=v.vwi or 1000+v.id
    --if (not v.vehicles_allowed) then
    setElementData(v.cs, "dom", {
            ["zamkniety"]=v.zamkniety>0 and true or false,
            ["id"]=v.id,
            ["koszt"]=v.koszt,
            ["ownerid"]=v.ownerid,
            ["owner_nick"]=v.owner_nick,
            ["descr"]=v.descr or "dom",
            ["dimension"]=interior_dimension,
            ["interior"]=interiory[v.interiorid].interior,
            ["interior_loc"]=interiory[v.interiorid].entrance,
            ["exit_loc"]=v.punkt_wyjscia,
            ["paidTo"]=v.paidTo,
            ["paidTo_dni"]=v.paidTo_dni,
            ["restrict_gang"]=v.owner_gang,
            ["name_gang"]=v.name_gang,
            --		["veha"]=(v.vehicles_allowed and v.vehicles_allowed>0) and true or false
        })
--    else end


    -- dodajemy wyjscie
    v.wyjscie=createMarker(interiory[v.interiorid].exit[1], interiory[v.interiorid].exit[2], interiory[v.interiorid].exit[3], "arrow",1)
    setElementDimension(v.wyjscie, interior_dimension)
    setElementInterior(v.wyjscie, interiory[v.interiorid].interior)
    setElementData(v.wyjscie,"tpto", v.punkt_wyjscia)


    local dbid=v.id
    v.id=nil
    domy[dbid]=v

    return true
end

function domyGetInfo(id)
    return domy[id]
end

local function zaladujCzescDomow(procent,fast)
    local tt=getTickCount()
    i=0
    exports["psz-mysql"]:zapytanie("UPDATE psz_domy SET paidTo=NULL,ownerid=NULL,owner_gang=NULL where paidTo<NOW() or paidTo IS NULL")
    local dbdomy
    if fast then
        dbdomy=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT d.id,d.descr,d.vwi,d.drzwi,d.punkt_wyjscia,d.interiorid,d.vehicles_allowed,d.ownerid,concat(c.nick) owner_nick,d.zamkniety,d.owner_gang,concat(g.nazwa) name_gang,d.koszt,d.paidTo,datediff(d.paidTo,now()) paidTo_dni FROM psz_domy d LEFT JOIN psz_postacie c ON c.userid=d.ownerid LEFT JOIN psz_gangi g ON g.id=d.owner_gang WHERE d.active=1 AND d.ownerid IS NOT NULL;")
    else
        dbdomy=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT d.id,d.descr,d.vwi,d.drzwi,d.punkt_wyjscia,d.interiorid,d.vehicles_allowed,d.ownerid,concat(c.nick) owner_nick,d.zamkniety,d.owner_gang,concat(g.nazwa) name_gang,koszt,d.paidTo,datediff(d.paidTo,now()) paidTo_dni FROM psz_domy d LEFT JOIN psz_postacie c ON c.userid=d.ownerid LEFT JOIN psz_gangi g ON g.id=d.owner_gang WHERE d.active=1;")
    end
    for __,v in ipairs(dbdomy) do
        if math.random(0,100)<=procent then
            --			outputChatBox("Wgrywanie domu " .. v.id)
            if dodajDom(v,fast) then i=i+1 end
        end
    end
    outputDebugString("Zaladowano domow: " .. i .. " w " .. (getTickCount()-tt) .. "ms")
end
setTimer(zaladujCzescDomow, 86525000, 0, 100)
addEventHandler("onResourceStart", resourceRoot, function()
        zaladujCzescDomow(100,false)
    end)

local function zaladujZmienioneDomy()
    local i=0
    local dbdomy=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT d.id,d.descr,d.vwi,d.drzwi,d.punkt_wyjscia,d.interiorid,d.vehicles_allowed,d.ownerid,concat(c.nick) owner_nick,d.zamkniety,d.owner_gang,concat(g.nazwa) name_gang,d.koszt,d.paidTo,datediff(d.paidTo,now()) paidTo_dni FROM psz_domy d LEFT JOIN psz_gangi g ON g.id=d.owner_gang LEFT JOIN psz_postacie c ON c.userid=d.ownerid WHERE d.active=1 AND timediff(now(),d.updated)<'00:09:00' AND datediff(now(),d.updated)<1")
    for __,v in ipairs(dbdomy) do

        if dodajDom(v) then i=i+1 end
    end
    outputDebugString("Zaladowano zmienionych domow: " .. i)
end

setTimer(zaladujZmienioneDomy, 10*1000*5, 0)


function domReload(id)
    local dbdom=exports["psz-mysql"]:pobierzWyniki("SELECT d.id,d.descr,d.vwi,d.drzwi,d.punkt_wyjscia,d.interiorid,d.vehicles_allowed,d.ownerid,concat(c.nick) owner_nick,d.zamkniety,d.owner_gang,concat(g.nazwa) name_gang,d.koszt,d.paidTo,datediff(d.paidTo,now()) paidTo_dni FROM psz_domy d LEFT JOIN psz_gangi g ON g.id=d.owner_gang LEFT JOIN psz_postacie c ON c.userid=d.ownerid WHERE d.active=1 and d.id=?;",id)
    if dbdom then
        return dodajDom(dbdom)
    end
    return false
end

function domChangeActive(id)
    local d = domyGetInfo(id)
    if d then 
        usunDom(id)
        return 'Dom o id'..id..' - usunięty'
    end
    return false
end
