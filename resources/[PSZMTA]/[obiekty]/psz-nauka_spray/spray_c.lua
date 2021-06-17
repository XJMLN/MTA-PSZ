local col = createColCuboid(1908.16, -2381.90, 12.30,33.25,140.5,10)
setElementData(col,"sstudio",true)
local tstamp = nil
function spray_colHit(el,md)
    if (not md) then return end
    -- uwaga gowno
    if getElementType(el)=="vehicle" then
        destroyElement(el)
    end
    if getElementType(el)=="player" then
        setElementData(el,"sstudio:god",true)
        --triggerServerEvent("onPlayerTakeWeapons",el)
        bindKey("n","down","Pokaz okno spraya");
        setElementHealth(el,100)
    end
end
addEventHandler("onClientColShapeHit",col,spray_colHit)

function spray_colLeave(el,md)
    if (not md) then return end
    if getElementType(el)=="player" then
        setElementData(el,"sstudio:god",false)
        triggerServerEvent("onPlayerTakeWeapons",el)
        unbindKey("n","down","Pokaz okno spraya");
    end
end
addEventHandler("onClientColShapeLeave",col,spray_colLeave)

function onTakeDamage(attacker, weapon, bodypart)
    local nearbyPlayers=getElementsWithinColShape(col,"player")
    for i,v in ipairs(nearbyPlayers) do
        if v==source then
            cancelEvent()
        end
    end
end
addEventHandler("onClientPlayerDamage",getLocalPlayer(),onTakeDamage)

function onPlayerKilled(target)
    local nearbyPlayers=getElementsWithinColShape(col,"player")
    for i,v in ipairs(nearbyPlayers) do
        if v==target then
            cancelEvent()
        end
    end
end
addEventHandler("onClientPlayerStealthKill",getLocalPlayer(),onPlayerKilled)


addCommandHandler("Pokaz okno spraya",function()
    local c = getElementData(localPlayer,"character")
    if (not c) then return end
    if (tstamp and getTickCount()-tstamp<120000) then
        outputChatBox("Odczekaj chwilę przed kolejnym malowaniem.")
        return
    elseif c.ab_spray>50 and getElementData(localPlayer,"sstudio:god") then 
        local show = not exports.drawtag:isDrawingWindowVisible()
        exports.drawtag:showDrawingWindow(show)
        tstamp = getTickCount()
    elseif c.ab_spray<50 and getElementData(localPlayer,"sstudio:god") then
        outputChatBox("Posiadasz zbyt niską umiejętność malowania sprayem.")
        return
    elseif not getElementData(localPlayer,"sstudio:god") then
        outputChatbox("Malować można tylko na terenie studia Picasso.")
        return
    end
end)