--[[

Podstawowe funkcje w pojezdzie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local nlOffsets={
    [411]={-1,0,-0.6},  -- infernus
    [470]={-1,0,-0.4},  -- patriot
    [541]={-0.9,0,-0.4},    -- bulelt
    [549]={-0.9,0,-0.4},    -- tampa
    [587]={-1,0,-0.5},  -- euros
}

local nlIDX={
    3962,2113,1784,2054,2428,2352
}

function neony(plr)
        local veh = getPedOccupiedVehicle(plr)
            if veh then
        local rodzajneonu=tonumber(getElementData(veh,"neony"))
        if not rodzajneonu then return end
        local zneony=getElementData(veh,"zneony")
        if (zneony and type(zneony)=="table") then
            destroyElement(zneony[1])
            destroyElement(zneony[2])
            removeElementData(veh,"zneony")

            outputChatBox("Neony zostały wyłączone.",plr)

        else
            local m = getElementModel(veh)
            local of
            if not nlOffsets[m] then
                of={-1,0,-0.5}
            else
                of=nlOffsets[m]
            end
            neon1=createObject(rodzajneonu,0,0,0)
            neon2=createObject(rodzajneonu,0,0,0)
            setElementData(veh,"zneony", {neon1, neon2})
            attachElements(neon1,veh,of[1],of[2],of[3])
            attachElements(neon2,veh,-of[1],of[2],of[3])
            setElementParent(neon1,veh)
            setElementParent(neon2,veh)
            outputChatBox("Neony zostały włączone.",plr)
    end
end
end
addCommandHandler("neony",neony)

function vehicle_Engine(player,key,keyState)
if (keyState == 'down') then
    if not isPedInVehicle(player) then return end
    local vehicle = getPedOccupiedVehicle(player)
    local seat = getPedOccupiedVehicleSeat(player)
        if getVehicleEngineState(vehicle) == true then
            if seat == 0 then
            setVehicleEngineState(vehicle,false)
            outputChatBox("* Silnik został wyłączony.",player)
        end
        else
            if seat == 0 then
            setVehicleEngineState(vehicle,true)
            outputChatBox("* Silnik został włączony.",player)
        end
        end
    end
end

function vehicle_Lights(player,key,keyState)
if (keyState == 'down') then
    if not isPedInVehicle(player) then return end
    local vehicle = getPedOccupiedVehicle(player)
    local seat = getPedOccupiedVehicleSeat(player)
    state = 0
        if (getVehicleOverrideLights(vehicle) ~= 2) then
            if seat == 0 then
            setVehicleOverrideLights(vehicle,2)
            state = 2
        end
        else
            if seat == 0 then
            setVehicleOverrideLights(vehicle,1)
            state = 1
        end
        end
    local przyczepa=getVehicleTowedByVehicle(vehicle)
        if przyczepa then
            setVehicleOverrideLights(przyczepa,state)
        end
    end
end
local vDataBan = {"spawn:vehicle", "pojazd:spawn", "veh:fid","pojazd_spawn"}
local function isPublicVehicle(veh)
    if (not isElement(veh)) then return end
    for i,v in ipairs(vDataBan) do
        if getElementData(veh,v) then return true end
    end
end

function vehicle_lock(thePlayer)
    if (not isPedInVehicle(thePlayer)) then return end
    local veh = getPedOccupiedVehicle(thePlayer)
    local seat = getPedOccupiedVehicleSeat(thePlayer)
    if (isVehicleLocked(veh) and seat == 0 and not isPublicVehicle(veh)) then 
        if (getElementData(veh,"veh_zamek:plr") == thePlayer) then 
            setVehicleLocked(veh,false)
            removeElementData(veh,"veh_zamek:plr")
            outputChatBox("* Pojazd został otworzony.", thePlayer)
        else
            outputChatBox("Nie możesz otworzyć tego pojazdu, nie Ty go zamknąłeś.", thePlayer)
        end
    elseif (not isVehicleLocked(veh) and seat == 0 and not isPublicVehicle(veh)) then
        if (not getElementData(veh,"veh_zamek:plr")) then
            setVehicleLocked(veh,true)
            setElementData(veh,"veh_zamek:plr",thePlayer)
            outputChatBox("* Pojazd został zamknięty.", thePlayer)
        end
    else 
        outputChatBox("Ten pojazd jest publiczny, nie możesz go zamknąć.", thePlayer)
    end
end

addEventHandler("onVehicleStartEnter", getRootElement(), function(player,seat, jacked)
    if isVehicleLocked(source) and getElementData(source,"veh_zamek:plr") == player then 
        setVehicleLocked(source,false)
        removeElementData(source,"veh_zamek:plr")
    end
end)
function vehicleSirens(plr)
    local veh = getPedOccupiedVehicle(plr)
    if veh and getVehicleOccupant(veh,0) then 
        if not getVehicleSirensOn(veh) then 
            setVehicleSirensOn(veh, true)
        else
            setVehicleSirensOn(veh, false)
        end

    end
end
addEventHandler("onResourceStart",resourceRoot,
function ()
    for index, player in pairs(getElementsByType("player")) do
        bindKey(player, "k", "down", vehicle_Engine)
        bindKey(player,"l","down",vehicle_lock)   
        bindKey(player, ";","down", vehicle_Lights) 
        bindKey(player, 'h','down',vehicleSirens)
    end
end)

function resetVehicle()
	if not isPedInVehicle(source) then return end
	local veh = getPedOccupiedVehicle(source)
    if veh then
        setVehicleLocked(veh,false)
        removeElementData(veh,"veh_zamek:plr")
    end
end
addEventHandler("onPlayerQuit",getRootElement(),resetVehicle)



function e_setVehicleDoorOpenRatio(door, ratio, time)
    setVehicleDoorOpenRatio(source,door,ratio, time or 1000)
end
addEvent("setVehicleDoorOpenRatio", true)
addEventHandler("setVehicleDoorOpenRatio", resourceRoot, e_setVehicleDoorOpenRatio)

addEventHandler("onPlayerJoin",root,
function ()
    bindKey(source, "k", "down", vehicle_Engine)
    bindKey(source,"l","down",vehicle_lock)
    bindKey(source, ";","down", vehicle_Lights) 
    bindKey(source,"h",'down',vehicleSirens)
end)

addEventHandler("onVehicleEnter", resourceRoot, function(plr, seat)
    local vm = getElementModel(source)
    if (vm==481 or vm==509 or vm==510) then return end
    if (seat~=0) then return end
    setVehicleEngineState(source, true)
end)


addEventHandler("onVehicleExit", resourceRoot, function(plr,seat)
    if (seat== 0) then 
        setVehicleEngineState(source, false)
        setVehicleOverrideLights(source, 1)
    end

    veh_save(source)
end)