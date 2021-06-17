--[[

Podstawowe funkcje w pojezdzie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local wybraneOgraniczenie =1 
local ograniczenia = {nil}
local ograniczeniaPojazdow = {
    [525] = 35,
}

local function getDBID(plr)
    local uid = getElementData(plr,"auth:uid") or 0
    if (uid and uid>0) then return tonumber(uid) else return 0 end
end

local function ograniczPredkosc()
    local ograniczenie = ograniczenia[wybraneOgraniczenie]
    local v = getPedOccupiedVehicle(localPlayer)
    if not v then return end
    local vm = getElementModel(v)

    if getVehicleController(v)~=localPlayer then return end
    if not isVehicleOnGround(v) then return end

    local vx,vy,vz = getElementVelocity(v)

    if not getVehicleEngineState(v) then 
        if getDistanceBetweenPoints2D(0,0,vx,vy)<0.1 then 
            vx,vy = 0,0
            setElementVelocity(v,vx,vy,vy)
            return
        end
    end

    if ograniczeniaPojazdow[vm] then 
        ograniczenie = ograniczeniaPojazdow[vm]
    end

    if not ograniczenie then return end

    local actualspeed = (vx^2 + vy^2 + vz^2)^(0.5) *0.6*180
    if actualspeed>ograniczenie then 
        setElementVelocity(v,vx*0.9,vy*0.9,vz*0.9)
    end
end
setTimer(ograniczPredkosc,50,0)
function playerHasKeys(_,seat,_)
    if (seat ~= 0) then return end
    local dbid = getElementData(source,"dbid")
    if (dbid) then 
        if (getDBID(localPlayer) == tonumber(getElementData(source,"owning_player"))) then return true end
    

    -- pojazd gangowy
    local owning_gg = getElementData(source,"owning_gang")
    if (owning_gg) then 
        local character = getElementData(localPlayer,"character")
        if character and character.gg_id and tonumber(character.gg_id) == tonumber(owning_gg) then return true end
    end
    cancelEvent()
    end

end

addEventHandler("onClientVehicleStartEnter", getRootElement(), playerHasKeys)

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
    if (weapon and getElementModel(source) == 601) then
        if getElementData(source,"veh:god") then 
            setVehicleDamageProof(source,true)
        cancelEvent()
        end
    end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)


function allDoorsOpen()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then 
    	outputChatBox('Nie jesteś w pojeździe.')
    	return
    end

    if getVehicleController(veh)~=localPlayer then
    	outputChatBox("Nie jesteś kierowcą.")
    	return
    end

    local maska = getVehicleDoorOpenRatio(veh,0)
    local bagaznik = getVehicleDoorOpenRatio(veh,1)

    if (maska>0 and bagaznik>0) then 
    	maska=0
    	bagaznik=1
    elseif (bagaznik>0) then 
    	maska=0
    	bagaznik=0
    elseif (maska>0) then 
    	maska=1
    	bagaznik=1
    else
    	maska=1
    	bagaznik=0
    end

    triggerServerEvent("setVehicleDoorOpenRatio", veh, 0, maska,250)
	triggerServerEvent("setVehicleDoorOpenRatio", veh, 1, bagaznik,250)
end
addCommandHandler('maska',allDoorsOpen)
bindKey("m", "down", allDoorsOpen)
