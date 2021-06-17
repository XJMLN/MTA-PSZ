local marker = createMarker(1914.47,-2246.74,14,"cylinder",1,100,150,30,100)

function spray_markerHit(plr,matchingDimension)
    if (not matchingDimension) then return end
    local c = getElementData(plr,"character")
    if (not c) then return end

    if (getPlayerMoney(plr)<100) then
        outputChatBox("Kupno puszki z sprayem kosztuje 100$, nie masz tylu.",plr,255,0,0,true)
        return 
    end


    if (tonumber(c.ab_spray or 0)<50) then
        setElementData(plr,"drawtag:spraymode","none")
        outputChatBox("Twoja umiejętność jest zbyt niska aby malować po ścianach.",plr)
        outputChatBox("Zapoznaj się z poradnikiem obok, tam dowiesz się jak zwiększyć umiejętność.",plr)
    else
        setElementData(plr,"drawtag:spraymode","draw")
        giveWeapon(plr,41,10000)
        takePlayerMoney(plr,100)
        outputChatBox("Aby rozpocząć malowanie, wciśnij 'N'.",plr)
    end
end
addEventHandler("onMarkerHit",marker,spray_markerHit)

addEvent("onPlayerTakeWeapons",true)
addEventHandler("onPlayerTakeWeapons", root, function()
        if getElementType(client)=="player" then
            takeWeapon(client,41)
        end
    end)