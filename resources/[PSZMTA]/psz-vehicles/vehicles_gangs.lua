--[[

Pojazdy gangowe

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local function veh_create(v)
    v.loc=split(v.loc,",")
    v.rot=split(v.rot,",")
    local pojazd=createVehicle(v.model, v.loc[1],v.loc[2],v.loc[3],v.rot[1],v.rot[2],v.rot[3],v.tablica) -- tablica nie dziala?

    if getElementModel(pojazd)==439 then setVehicleVariant(pojazd, 1, 255) end
    if getElementModel(pojazd)==555 then setVehicleVariant(pojazd, 0, 255) end

    if (tonumber(v.d)>0) then
        setElementDimension(pojazd, tonumber(v.d))
    end
    if (tonumber(v.i)>0) then
        setElementInterior(pojazd, tonumber(v.i))
    end

    if (v.special and type(v.special)=="string" and string.len(v.special)>1) then
        setElementData(pojazd,"special",v.special)
    end


    setVehicleDamageProof(pojazd, true)
    v.hp=tonumber(v.hp)
    if (v.hp<301) then v.hp=301 end
    setElementHealth(pojazd,v.hp)
    setElementData(pojazd,"dbid",v.id)

    if (tonumber(v.hp)>0 and tonumber(v.model)~=510 and tonumber(v.model)~=509 and tonumber(v.model)~=481) then
        setVehicleLocked(pojazd, tonumber(v.locked)>0)
        setElementFrozen(pojazd, tonumber(v.frozen)>0)
    end

    --if (v.headlightcolor and type(v.headlightcolor)=="string") then
      --  v.headlightcolor=split(v.headlightcolor,",")
      --  setVehicleHeadLightColor(pojazd, tonumber(v.headlightcolor[1]) or 255, tonumber(v.headlightcolor[2]) or 255 , tonumber(v.headlightcolor[3]) or 255)
   -- end
    if (v.owning_player and (type(v.owning_player)=="string" or type(v.owning_player)=="number")) then 
        setElementData(pojazd, "owning_player", tonumber(v.owning_player))
    end
    if (v.owning_gang and (type(v.owning_gang)=="string" or type(v.owning_gang)=="number")) then
        setElementData(pojazd, "owning_gang", tonumber(v.owning_gang))
    end

    --if (v.neony and tonumber(v.neony)>0) then
    --    setElementData(pojazd,"neony", tonumber(v.neony))
    --end


    if (v.damageproof and tonumber(v.damageproof)==1) then
        setElementData(pojazd,"damageproof", true)
    end

    v.wheelstates=split(v.wheelstates,",")
    setVehicleWheelStates(pojazd, unpack(v.wheelstates))
    if (v.panelstates~="0,0,0,0,0,0,0") then
        v.panelstates=split(v.panelstates,",")
        for i,v in ipairs(v.panelstates) do
            setVehiclePanelState(pojazd,i-1, tonumber(v))
        end
    else
        v.panelstates=split(v.panelstates,",")
    end
   -- if (v.upgrades and type(v.upgrades)=="string") then
    --    v.upgrades=split(v.upgrades,",")
    --    for i,v in ipairs(v.upgrades) do
    --        addVehicleUpgrade(pojazd, tonumber(v))
    --    end
   -- end
    setVehicleColor ( pojazd, math.floor(v.c1/65536), math.floor(v.c1/256%256), v.c1%256, math.floor(v.c2/65536), math.floor(v.c2/256%256), v.c2%256, math.floor(v.c3/65536), math.floor(v.c3/256%256), v.c3%256, math.floor(v.c4/65536), math.floor(v.c4/256%256), v.c4%256)
    setVehicleEngineState ( pojazd, false )
end

function veh_reload(id)
    if (not id) then return end
    -- reload bez save!
    for i,v in ipairs(getElementsByType("vehicle")) do
        local dbid=getElementData(v,"dbid")
        if dbid and tonumber(dbid)==tonumber(id) then

            local zneony=getElementData(v,"zneony")
            if (zneony and type(zneony)=="table") then
                destroyElement(zneony[1])
                destroyElement(zneony[2])
            end
            destroyElement(v)
        end
    end
    veh_load(id)
end

function veh_load(id)
    local pojazd=exports['psz-mysql']:pobierzWyniki("select id,model,loc,d,i,rot,locked,frozen,tablica,hp,owning_gang,owning_player,c1,c2,c3,c4,headlightcolor,neony,upgrades,wheelstates,panelstates,special,damageproof from psz_vehicles WHERE przechowalnia=0 AND id="..tonumber(id))
    if pojazd and pojazd.id then
        veh_create(pojazd)
    end
end

function veh_init()
    local pojazdy=exports['psz-mysql']:pobierzTabeleWynikow("select id,model,loc,d,i,rot,locked,frozen,tablica,hp,owning_gang,owning_player,c1,c2,c3,c4,headlightcolor,neony,upgrades,wheelstates,panelstates,special,damageproof from psz_vehicles WHERE przechowalnia=0")
    for i,v in ipairs(pojazdy) do
        veh_create(v)
    end
end

-- zapisujemy stan pojazdu do bazy danych
function veh_save(vehicle)
    local dbid=getElementData(vehicle, "dbid")
    if (not dbid) then
        return
    end
    local x,y,z=getElementPosition(vehicle)
    local rx,ry,rz=getElementRotation(vehicle)
    local hp=getElementHealth(vehicle)
    local wheelstates=table.concat({getVehicleWheelStates(vehicle)},",")
    local panelstates={}
    for i=0,6 do
        table.insert(panelstates, getVehiclePanelState(vehicle,i))
    end
    panelstates=table.concat(panelstates,",")
    local locked=isVehicleLocked(vehicle) and 1 or 0
    local frozen= isElementFrozen(vehicle) and 1 or 0
    local vm=getElementModel(vehicle)
    if (vm==510 or vm==509 or vm==481) then	-- rowery
        locked=0
        frozen=0
    end
    local c11,c12,c13, c21,c22,c23, c31,c32,c33, c41,c42,c43 = getVehicleColor(vehicle,true)
    local vehUpgrades=getVehicleUpgrades(vehicle)
    if not vehUpgrades then vehUpgrades={} end
    local upgrades=(table.concat(vehUpgrades,","))

    local query=string.format("UPDATE psz_vehicles SET upgrades='%s',loc='%.2f,%.2f,%.2f',rot='%.2f,%.2f,%.2f',hp=%d,locked=%d,frozen=%d,c1=%d,c2=%d,c3=%d,c4=%d,wheelstates='%s',panelstates='%s' WHERE id=%d LIMIT 1",
        upgrades,x,y,z,rx,ry,rz,hp,locked, frozen,
        c13+c12*256+c11*256*256, c23+c22*256+c21*256*256, c33+c32*256+c31*256*256, c43+c42*256+c41*256*256, 
        wheelstates,panelstates, 
        dbid)
    exports['psz-mysql']:zapytanie(query)
end

function veh_saveall()
    local pojazdy=getElementsByType("vehicle",resourceRoot)
    for i,v in ipairs(pojazdy) do
        veh_save(v)
    end
end

function createVehicleEx(model,x,y,z,rx,ry,rz,who, gid,pid)
    local pojazd=createVehicle(model, x,y,z,rx,ry,rz) -- tablica nie dziala?
    setVehicleDamageProof(pojazd, true)
    local c = getElementData(who, "character")
    local ilosc_pojazdow = exports['psz-mysql']:pobierzWyniki(string.format("SELECT count(*) ile FROM psz_vehicles WHERE owning_gang=%d",tonumber(c.gg_id)))
    local tb_veh = string.format("%s %d", c.gg_nazwa, ilosc_pojazdow.ile)
    local query=string.format("INSERT INTO psz_vehicles SET created=NOW(),model=%d,loc='%.2f,%.2f,%.2f',rot='%.2f,%.2f,%.2f',locked=1,owning_gang=%d,owning_player=%d,tablica='%s'", model, x,y,z,rx,ry,rz,gid,pid,tostring(tb_veh))
    exports['psz-mysql']:zapytanie(query)
    local c2 = exports['psz-mysql']:pobierzWyniki(string.format("SELECT id FROM psz_vehicles WHERE loc='%.2f,%.2f,%.2f'",x,y,z))
    setVehicleLocked(pojazd,true)
    if (c2.id and c2.id>0) then
        setElementData(pojazd,"dbid",c2.id)
        setElementData(pojazd,"owning_gang", gid)
        setElementData(pojazd,"owning_player", pid)
        return c2.id,pojazd
    else
        return false
    end
end

addEventHandler("onResourceStart",resourceRoot, veh_init)
addEventHandler("onResourceStop",resourceRoot, veh_saveall)

function tsave_createVeh(plr,data)
    if (not data) then return end
    local vehs = getElementsByType("vehicle") 


    for i,v in pairs(data) do
        for i, pojazd in pairs(vehs) do -- usuwamy duplikaty pojazdu
            local vdata = getElementData(pojazd, "vsaved")
            if (vdata and vdata.owner == getElementData(plr,"auth:uid") and vdata.id == v.id ) then 
                destroyElement(pojazd)
            end
        end

    local pojazd=createVehicle(v.model,-2030.30,123.64,28.67,0,0,0) -- tablica nie dziala?

    if (v.tablica and type(v.tablica)=="string") then 
        setVehiclePlateText(pojazd,v.tablica)
    end

    if getElementModel(pojazd)==439 then setVehicleVariant(pojazd, 1, 255) end
    if getElementModel(pojazd)==555 then setVehicleVariant(pojazd, 0, 255) end

    if (v.washed and tonumber(v.washed)>0) then 
        setElementData(pojazd, "vehicle:clean", true)
    end

    if (v.paintjob and tonumber(v.paintjob)>0) then 
        setVehiclePaintjob(pojazd, tonumber(v.paintjob))
    end

    if (v.headlightcolor and type(v.headlightcolor)=="string") then
        v.headlightcolor=split(v.headlightcolor,",")
        setVehicleHeadLightColor(pojazd, tonumber(v.headlightcolor[1]) or 255, tonumber(v.headlightcolor[2]) or 255 , tonumber(v.headlightcolor[3]) or 255)
    end


    if (v.neony and tonumber(v.neony)>0) then
        setElementData(pojazd,"neony", tonumber(v.neony))
    end

    if (v.upgrades and type(v.upgrades)=="string") then
       v.upgrades=split(v.upgrades,",")
        for i,v in ipairs(v.upgrades) do
            addVehicleUpgrade(pojazd, tonumber(v))
        end
    end

    setVehicleColor ( pojazd, math.floor(v.c1/65536), math.floor(v.c1/256%256), v.c1%256, math.floor(v.c2/65536), math.floor(v.c2/256%256), v.c2%256, math.floor(v.c3/65536), math.floor(v.c3/256%256), v.c3%256, math.floor(v.c4/65536), math.floor(v.c4/256%256), v.c4%256)
    warpPedIntoVehicle(plr, pojazd)
    setElementData(pojazd, "vsaved",{
                                    ["id"]=v.id, 
                                    ["owner"]=v.saved_by,
                                    })
    end
    outputChatBox("Pojazd został wczytany.", plr)
   
end

addEvent("tsave_spawnVehicle", true)
addEventHandler("tsave_spawnVehicle", root, tsave_createVeh)