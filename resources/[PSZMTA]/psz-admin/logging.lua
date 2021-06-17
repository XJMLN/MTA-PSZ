addEventHandler("onPlayerWasted", root, function( ammo, attacker, weapon, bodypart )
    if (attacker and isElement(attacker) and source and isElement(source)) then 
        if getElementType(attacker) == "vehicle" and getVehicleOccupant(attacker,0) then 
            gameView_add("ZABOJSTWO "..getPlayerName(source).." zabity przez ".. getPlayerName(getVehicleOccupant(attacker,0)) ..", ranover pojazdem "..getVehicleNameFromModel(getElementModel(attacker)))
            return
        elseif getElementType(attacker) == "vehicle" and not getVehicleOccupant(attacker,0) then 
            gameView_add("SMIERC "..string.gsub(getPlayerName(source),"#%x%x%x%x%x%x",""))
            return
        end
        gameView_add("ZABOJSTWO " .. getPlayerName(source) .. " zabity przez " .. getPlayerName(attacker) .. ", bron " .. getWeaponNameFromID(weapon))
        if getElementData(attacker,"auth:moderator") or getElementData(attacker,"auth:root") then
            adminView_add("ZABOJSTWO ".. getPlayerName(source).." zabity przez ".. getPlayerName(attacker).. ", bron ".. getWeaponNameFromID(weapon),2)
        end
    else 
        gameView_add("SMIERC ".. string.gsub(getPlayerName(source),"#%x%x%x%x%x%x",""))
    end
end)

function quitPlayer ( quitType )
   gameView_add("QUIT "..getPlayerName(source).." /"..getElementData(source,'id').."/"..getPlayerSerial(source)..", powod: "..quitType)
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )

function joinPlayer ()
    gameView_add("JOIN "..getPlayerName(source).." , serial: "..getPlayerSerial(source))
end
addEventHandler ( "onPlayerJoin", getRootElement(), joinPlayer )