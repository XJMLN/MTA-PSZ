--[[

Core - komendy dla graczy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
dFly = false

function cmd_fly(plr, cmd)
    local veh = getPedOccupiedVehicle(localPlayer)
    if (not veh) then return end
    local kierowca = getVehicleOccupant(veh,0)
    if (not kierowca) then 
        outputChatBox("Latanie możesz włączyć tylko gdy siedzisz w pojeździe jako kierowca.",255,0,0)
        return
    end
    if (dFly == false) then 
        if getElementData(veh,"vehicle:event") then 
            outputChatBox("Latanie pojazdem w pojeździe eventowym jest zablokowane.",255,0,0)
            return 
        end
        if getElementData(kierowca,"hedit_ban") then
            outputChatBox("Ułatwienia zostały zablokowane - najpierw zakończ wyścig.",255,0,0)
            return
        end
        
        if (getElementData(kierowca,"praca:kurier")) then
            outputChatBox("Ułatwienia zostały zablokowane - najpierw zakończ pracę.",255,0,0)
            return
        end
        
        dFly = true
        setWorldSpecialPropertyEnabled("aircars", true)
        outputChatBox("Ułatwienie latania pojazdami, zostało włączone!",25,150,0)
    else
        dFly = false
        setWorldSpecialPropertyEnabled("aircars", false)
        outputChatBox("Ułatwienie latania pojazdami, zostało wyłączone!",255,0,0)
    end
end
addCommandHandler("fly", cmd_fly)
local lu100hp = getTickCount () - 30000

function cmd_100hp (plr, cmd)
	if (getTickCount () - lu100hp < 30000) then
		outputChatBox ("Zostaniesz uleczony/a za " .. math.floor ((31000 - (getTickCount () - lu100hp)) / 1000) .. "s.", 0, 255, 0)
		return
	end
	lu100hp = getTickCount ()

	if (getElementDimension (localPlayer) > 0 or getElementInterior (localPlayer) > 0) then
		outputChatBox ("Nie możesz tutaj się uleczyć!")
		return
	end

	setTimer (function ()
		if (getElementDimension (localPlayer) > 0 or getElementInterior (localPlayer) > 0) then
			outputChatBox("Nie możesz tutaj się uleczyć!")
			return
		end
		outputChatBox("Zostałeś/aś uleczony/a.")
        if (getPedStat(localPlayer,24) == 1000) then 
            setElementHealth(localPlayer,200.0)
        else
            setElementHealth(localPlayer, 100.0)
        end
		playSoundFrontEnd (46)
	end, 30000, 1)
	outputChatBox("Zostaniesz uleczony za 30 sekund.")
end

addCommandHandler("zdrowie", cmd_100hp)

-- Komendy VIP'a
local K_INTERVAL = 300000
local luKamizelka = getTickCount() - K_INTERVAL

function cmd_kamizelka (plr, cmd)
    if (not getElementData(localPlayer,"vip")) then return end
    if (getTickCount()-luKamizelka< K_INTERVAL) then 
        outputChatBox("Kolejną kamizelkę możesz dodać za ".. math.floor (((K_INTERVAL - (getTickCount() - luKamizelka)) / 1000)/60) .. " min.", 0, 255, 0)
        return 
    end
    luKamizelka = getTickCount()

    if (getElementDimension (localPlayer) > 0 or getElementInterior (localPlayer) > 0) then
        outputChatBox ("Nie możesz tutaj dodać kamizelki!")
        return
    end

    triggerServerEvent("VIP_addArmorToPlayer", localPlayer)
end
addCommandHandler("kamizelka", cmd_kamizelka)

function cmd_hydra(plr,cmd)
    if (not getElementData(localPlayer, "vip")) then return end
    
   -- if (getPlayerName(localPlayer)~="XJMLN") then return end -- dev

    if (getElementDimension(localPlayer) > 0 or getElementInterior(localPlayer) > 0) then 
        outputChatBox("Nie możesz tutaj stworzyć Hydry.",255, 0, 0)
        return
    end

    triggerServerEvent("VIP_spawnVehicleForPlayer", localPlayer, 520)
end
addCommandHandler("hydra", cmd_hydra)

addCommandHandler("gp",function()
        x,y,z=getElementPosition(localPlayer)
        _,_,a=getElementRotation(localPlayer)
        i=getElementInterior(localPlayer)
        vw=getElementDimension(localPlayer)
        p=string.format("%.2f,%.2f,%.2f,%.1f\nint: %.0f, vw: %.0f",x,y,z,a,i,vw)
        setClipboard(p)
        outputChatBox(p)
    end)

addCommandHandler("vm",function()
    if isPedInVehicle(localPlayer) then 
        local veh = getPedOccupiedVehicle(localPlayer)
        local model = getElementModel(veh)
        outputChatBox("Model pojazdu: "..model,255,0,0)
    end
end)
function worldClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if (not clickedElement) then return end
    if getElementType(clickedElement)=="vehicle" then
        id = getElementID(clickedElement) or "-brak-"
    elseif getElementType(clickedElement) == "object" then 
        id = getElementID(clickedElement) or "-brak-"
    else
        id = getElementID(clickedElement) or "-brak-"
    end
    outputChatBox("Typ: " .. getElementType(clickedElement) .. ", id: " .. id .. ", model: " .. getElementModel(clickedElement))
    local x,y,z=getElementPosition(clickedElement)
    local rx,ry,rz=getElementRotation(clickedElement)
    local i,d=getElementInterior(clickedElement), getElementDimension(clickedElement)
    outputChatBox(string.format("x,y,z: %.2f,%.2f,%.2f",x,y,z))
    outputChatBox(string.format("rx,ry,rz: %d,%d,%d", rx,ry,rz))
    outputChatBox("Interior: " .. i ..", dimension: ".. d)
    local ep=getElementParent(clickedElement)
    outputChatBox("Parent: " .. getElementType(ep))
    ep=getElementParent(ep)
    outputChatBox("Parent2: " .. getElementType(ep))
    if (getElementType(ep)=="resource") then
        outputChatBox("  nazwa: " .. getElementID(ep))
    end


    removeEventHandler ( "onClientClick", root, worldClick )
end

addCommandHandler("idelement", function()
    local level = getElementData(localPlayer,"level")
    if level and level>0 then 

        outputChatBox("Kliknij LPM w element")
        addEventHandler ( "onClientClick", root, worldClick )
    end
end,false)

addCommandHandler('dev', function()
    local level = getElementData(localPlayer,"level")
    if level and level==3 then 
        if getDevelopmentMode() == true then 
        setDevelopmentMode(false)
        outputChatBox("Wyłączono tryb dev.")
        elseif getDevelopmentMode() == false then 
        setDevelopmentMode(true)
        outputChatBox("Włączono tryb dev.")
        end
    end
end,false)