--[[

Tuning - neony, glosniki

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local miejscaMontazu = {
    warsztat1={
        colCuboid={2662.23, 1195.58, 9.82,9,7.5,4.75}, -- miejsce dla auta
        montaz_ml={2669.50,1197.02,9.99},
        montaz_ml2={2657.32,1192.47,9.99},
        colCuboid2={2652.0561523438, 1191.7014160156, 9.9848680496216,3.25,5.5,4.85},
    },

}

for i,v in pairs(miejscaMontazu) do
    if v.colCuboid then
    v.cs=createColCuboid(unpack(v.colCuboid))
    end
    if v.montaz_ml then
    v.montaz_marker=createMarker(v.montaz_ml[1],v.montaz_ml[2],v.montaz_ml[3],"cylinder",1)
        setElementData(v.montaz_marker,"typ","montaz")
    v.text=createElement("ctext")
    setElementData(v.text,"ctext","Montaż systemu głośników")
    setElementPosition(v.text,v.montaz_ml[1],v.montaz_ml[2],v.montaz_ml[3]+1.5)
    if v.cs then
            setElementParent(v.montaz_marker,v.cs)
    end
    if v.colCuboid2 then
        v.csNeon = createColCuboid(unpack(v.colCuboid2))
    end
    if v.montaz_ml2 then
        v.montaz_neony=createMarker(v.montaz_ml2[1],v.montaz_ml2[2],v.montaz_ml2[3],"cylinder",1)
        setElementData(v.montaz_neony,"typ","neony")
        v.text=createElement("ctext")
        setElementData(v.text,"ctext","Montaż kolorowych neonów")
        setElementPosition(v.text,v.montaz_ml2[1],v.montaz_ml2[2],v.montaz_ml2[3]+1.5)
    end
    if v.csNeon then
            setElementParent(v.montaz_neony,v.csNeon)
    end
end
end

local function addTuningToDBIDVehicle(veh,plr)
    local c = getElementData(plr,"character")
    if (not veh or not plr or not c.id) then return false end
    local dbid = getElementData(veh,"dbid") 
    if (not dbid) then return false end
    local vgid = getElementData(veh,"owning_gang")
    if (not vgid or c.gg_id ~= vgid) then return false end
    if (c.gg_rank_id ~= 4) then 
        outputChatBox("Tylko lider może montować tuning do pojazdów.",plr,255,0,0)
        return false
    end
    return true
end

addEvent("addTuning",true)
addEventHandler("addTuning",resourceRoot,function(pojazd,file)
local vedit = getElementData(pojazd,"edit:tune")
if not vedit then return end
    if (getElementData(pojazd,"tuning:audio")) == true then outputChatBox("Ten pojazd posiada już zamontowany system głośników.",client) return end
        local bbox1 = createObject(2232,0,0,-2) -- 1'szy glosnik
        local bbox2 = createObject(2232,0,0,-3) -- 2'gi glosnik
        setElementCollisionsEnabled(bbox1,false)
        setElementCollisionsEnabled(bbox2,false)
    if bbox1 and bbox2 then
        attachElements(bbox1,pojazd,-0.55,-2.3,0.2,0,0,25) -- attach 1'szy
        attachElements(bbox2,pojazd,0.55,-2.3,0.2,0,0,-25) -- attach 2'gi
        setElementParent(bbox1,pojazd)
        setElementParent(bbox2,pojazd)
        local t=string.format("Montaz tuningu, %s/%d, pojazd %s, audio %s",getPlayerName(client),getElementData(client,"id"),getVehicleNameFromModel(getElementModel(pojazd)),file)
        exports["psz-admin"]:gameView_add(t)
        outputChatBox("W pojeździe zamontowano system nagłośnienia typu Olafen.",client)
        outputChatBox("Dostępne komendy : /wlaczRadio, /nextRadio, /wylaczRadio.",client)
        setElementData(pojazd,"tuning:audio",true)
    end
end)

addEvent("takeClientCash", true)
addEventHandler("takeClientCash", resourceRoot, function(mechanik,kto,ilosc,pojazd,idn)
	if (getElementData(pojazd,"neony")) then 
		outputChatBox("Ten pojazd posiada już zamontowane neony. Demontaż/zmiana będą wprowadzone wkrótce.",kto) 
		outputChatBox("Ten pojazd posiada już zamontowane neony. Demontaż/zmiana będą wprowadzone wkrótce.",mechanik) 
		return 
	end
	local typ=getVehicleType(pojazd)
	if typ~="Automobile" then
		outputChatBox("W tym pojeździe nie można zamontować neonów.",kto)
		outputChatBox("W tym pojeździe nie można zamontować neonów.",mechanik)
		return
	end
	local vip = getElementData(kto, "vip") 
    if (vip) then 
        ilosc = 0 
    end
    if (getPlayerMoney(kto)<ilosc) then 
		outputChatBox("Posiadasz zbyt mało pieniędzy na montaż części.",kto)
		outputChatBox("Gracz posiada zbyt mało pieniędzy na montaż.",mechanik)
		return
	end

    if (addTuningToDBIDVehicle(pojazd,kto)) then 
        local dbid = getElementData(pojazd,"dbid")
        local t 
        if (dbid and tonumber(dbid)>0 )then 
            t=string.format("Montaz tuningu, %s/%d/%s, pojazd %s (%d/%d)",getPlayerName(kto),getElementData(kto,"id"),getPlayerSerial(kto),getVehicleNameFromModel(getElementModel(pojazd)),dbid,getElementData(pojazd,"owning_gang"))
        else
            t=string.format("Montaz tuningu, %s/%d, pojazd %s",getPlayerName(kto),getElementData(kto,"id"),getVehicleNameFromModel(getElementModel(pojazd)))
        end
        exports["psz-admin"]:gameView_add(t)
        setElementData(pojazd,"neony",tonumber(idn))
	    takePlayerMoney(kto,ilosc)
	    outputChatBox("Z twojego konta pobrano "..tonumber(ilosc).."$, za montaż tuningu.",kto)
	    givePlayerMoney(mechanik,50)
	    outputChatBox("Otrzymujesz 50$ za założenie części w pojeździe.",mechanik)
	    outputChatBox("Jeśli neon źle przystaje do pojazdu, lub wisi pod nim, powiadom o tym administrację.",kto)
	    outputChatBox("Podając id lub nazwę pojazdu. Aby włączyć neony wpisz /neony",kto)
	    setElementData(pojazd,"neon:id",tonumber(idn))
	    setElementData(pojazd,"tuning:neon",true)
        if getElementData(pojazd,"dbid") then 
            exports['psz-mysql']:zapytanie(string.format("UPDATE psz_vehicles SET neony=%d WHERE id=%d LIMIT 1",tonumber(idn),getElementData(pojazd,"dbid")))
        end
    else
        local t=string.format("Montaz tuningu, %s/%d, pojazd %s",getPlayerName(kto),getElementData(kto,"id"),getVehicleNameFromModel(getElementModel(pojazd)))
        exports["psz-admin"]:gameView_add(t)
        setElementData(pojazd,"neony",tonumber(idn))
        takePlayerMoney(kto,ilosc)
        outputChatBox("Z twojego konta pobrano "..tonumber(ilosc).."$, za montaż tuningu.",kto)
        givePlayerMoney(mechanik,50)
        outputChatBox("Otrzymujesz 50$ za założenie części w pojeździe.",mechanik)
        outputChatBox("Jeśli neon źle przystaje do pojazdu, lub wisi pod nim, powiadom o tym administrację.",kto)
        outputChatBox("Podając id lub nazwę pojazdu. Aby włączyć neony wpisz /neony",kto)
        setElementData(pojazd,"neon:id",tonumber(idn))
        setElementData(pojazd,"tuning:neon",true)
    end
end)
