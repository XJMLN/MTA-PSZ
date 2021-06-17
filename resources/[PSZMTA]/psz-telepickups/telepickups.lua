--[[

telepickups - wejscia do budynkow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-telepickups
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local tepi={}
local interiory={}

local dane=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT id,interior,dimension,entrance,`exit` FROM psz_interiory WHERE `exit` IS NOT NULL AND active=1")
for _,v in ipairs(dane) do
    local ii = tonumber(v.id)
    v.entrance=split(v.entrance,",")	-- miejsce w ktorym pojawi sie gracz
    v.exit=split(v.exit,",")			-- wyjscie

    v.id=nil
    interiory[ii]=v
end

local function usunTepi(id)
    if isElement(tepi[id].wyjscie) then destroyElement(tepi[id].wyjscie) end
    if isElement(tepi[id].wejscie) then destroyElement(tepi[id].wejscie) end
    if isElement(tepi[id].text) then destroyElement(tepi[id].text) end
    if isElement(tepi[id].blip) then destroyElement(tepi[id].blip) end
    tepi[id]=nil
end

local function dodajTepi(v)
    if not interiory[v.interiorid] then return false end
    
    if tepi[v.id] then
        usunTepi(v.id)
    end
    
    v.pos=split(v.wejscie,",")
    for ii,vv in ipairs(v.pos) do v.pos[ii]=tonumber(vv) end
    v.punkt_wyjscia=split(v.punkt_wyjscia,",")
    for ii,vv in ipairs(v.punkt_wyjscia) do v.punkt_wyjscia[ii]=tonumber(vv) end


    v.wejscie = createMarker(v.pos[1],v.pos[2],v.pos[3],"arrow",1,255,0,0)
    setElementInterior(v.wejscie,v.i)
    setElementDimension(v.wejscie,v.vwe)
    
    if (tonumber(v.i)==0 and tonumber(v.vwe)==0) then

        v.blip=createBlip(v.pos[1], v.pos[2], v.pos[3], 0, 1, 255,105,5,155, -1000, 200)
    end


    v.text = createElement("text")
    setElementPosition(v.text,v.pos[1],v.pos[2],v.pos[3]+0.5)
    setElementData(v.text,"text",("(( "..v.descr.." ))" or "(( Przejście ))"))
    setElementDimension(v.text,v.vwe)
    setElementInterior(v.text,v.i)
        local interior_dimension=v.vwi or interiory[v.interiorid].dimension or 0
    setElementData(v.wejscie,"tepi", {
            ["zamkniety"]=v.zamkniety>0 and true or false,
            ["id"]=v.id,
            ["descr"]=v.descr or "(( Przejście ))",
            ["dimension"]=interior_dimension,
            ["interior"]=interiory[v.interiorid].interior,
            ["interior_loc"]=interiory[v.interiorid].entrance,
            ["exit_loc"]=v.punkt_wyjscia,
        })
    
    -- dodajemy wyjscie
    v.wyjscie=createMarker(interiory[v.interiorid].exit[1], interiory[v.interiorid].exit[2], interiory[v.interiorid].exit[3]+0.5, "arrow",1)
    setElementDimension(v.wyjscie, interior_dimension)
    setElementInterior(v.wyjscie, interiory[v.interiorid].interior)
    setElementData(v.wyjscie,"tpto", {pos=v.punkt_wyjscia,int=v.i,dim=v.vwe})
    if v.id == 22 then 
        setElementData(v.wyjscie,"tpto", {pos=v.punkt_wyjscia,int=v.i,dim=v.vwe,c_onExit=true})
    end
        
    local dbid=v.id
    v.id=nil
    tepi[dbid]=v
    
    return true
end

function tepiGetInfo(id)
    return tepi[id]
end

local function zaladujCzescTepi(procent)
    local tt=getTickCount()
i=0
    local dbtepi
    dbtepi=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT t.id,t.descr,t.wejscie,t.punkt_wyjscia,t.interiorid,t.i,t.vwe,t.vwi,t.zamkniety FROM psz_telepickups t WHERE t.active=1;")
    for __,v in ipairs(dbtepi) do
            if math.random(0,100)<=procent then
                if dodajTepi(v) then i=i+1 end
            end
        end
    outputDebugString("Zaladowano teleportow: "..i.." w "..(getTickCount()-tt).."ms")
    setInteriorSoundsEnabled(false)
end

addEventHandler("onResourceStart",resourceRoot,function()
        zaladujCzescTepi(100)
end)

local function zaladujZmienioneTepi()
    local i=0 
    local dbtepi=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT t.id,t.descr,t.wejscie,t.punkt_wyjscia,t.interiorid,t.i,t.vwe,t.vwi,t.zamkniety FROM psz_telepickups t WHERE t.active=1 AND timediff(now(),t.updated)<'00:09:00' AND datediff(now(),t.updated)<1")
    for __,v in ipairs(dbtepi) do
        if dodajTepi(v) then i=i+1 end
    end
    outputDebugString("Zaladowano zmienionych teleportow: "..i)
end

setTimer(zaladujZmienioneTepi, 150000,0)

function tepiReload(id)
    local dbtepi=exports["psz-mysql"]:pobierzWyniki("SELECT t.id,t.descr,t.wejscie,t.punkt_wyjscia,t.interiorid,t.i,t.vwe,t.vwi,t.zamkniety FROM psz_telepickups t WHERE t.active=1 and t.id=?;",id)
    if dbtepi then
        return dodajTepi(dbtepi)
    end
    return false
end

function moveMeTo(x,y,z,i,d,executor) -- executor XDD coś ty jarał
        setElementDimension(executor, d)
    setElementInterior(executor,i,x,y,z)

    setElementPosition(executor,x,y,z)
    setElementInterior(executor,i)
end

function tepiEnter(hitElement,matchingDimension)
    if (getElementType(hitElement)~="player") then return end
    if (not matchingDimension) then return end
    if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
    if (getPedOccupiedVehicle(hitElement)) then return end
    local tepi=getElementData(source,"tepi")
    if not tepi then return end
    local level = getElementData(hitElement,"level") or 0
    if (not tepi.zamkniety) or (tepi.zamkniety and level == 3) then
        moveMeTo(tepi.interior_loc[1],tepi.interior_loc[2],tepi.interior_loc[3],tepi.interior,tepi.dimension,hitElement)
    elseif tepi.zamkniety and level ~= 3 then 
        outputChatBox("Budynek jest zamknięty",hitElement) 
        return false
    end
end
addEventHandler( "onMarkerHit", resourceRoot, tepiEnter)

addEventHandler("onMarkerHit", resourceRoot, function(el,md)
        if getElementType(el)~="player" or not md then return end
        if getElementInterior(el)~=getElementInterior(source) then return end
        local tpto=getElementData(source,"tpto")
        if not tpto then return end
        setElementPosition(el, tpto.pos[1], tpto.pos[2],tpto.pos[3])
        setElementInterior(el, tpto.int)
        setElementDimension(el, tpto.dim)
        if tpto[4] then
            setPedRotation(el, tpto.pos[4])
        end
        if tpto.c_onExit then
            local fr = getElementData(el,"faction:data")
            if fr and fr.id == 6 then 
                exports['psz-grupy']:grupy_quitJob('bpracy',el)
                outputChatBox("Opuściłeś teren klubu, zostałeś wyrzucony z grupy DJ.",el)
            end
        end
    end
)
