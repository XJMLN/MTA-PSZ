--[[

]]

local sw,sh=guiGetScreenSize()
local mw,mh=800,600

local vehicle = {}
vehicle.id = nil
vehicle.speed = nil
vehicle.driver = nil
local option = {}
value=nil
element=nil
option.selected=0
option.actived=false

option["vehicle"]={
    "Akcja: Napraw pojazd",
    "Akcja: Usuń pojazd",
    "Akcja: Zamróź pojazd",
    "Akcja: Podnieś pojazd",
    "Akcja: Odspawnuj pojazd",
    "Akcja: Informacje o pojeździe",
}


option["object"]={
    "Akcja: Identyfikuj element",
    "Akcja: Przeładuj obiekt",
    "Akcja: Zgłoś zbugowany obiekt",
    "Akcja: Sprawdź LOD",
    "Akcja: Sprawdź TXT,DFF,COL",
    "Akcja: test",
}

function isPedAiming ( thePedToCheck )
    if isElement(thePedToCheck) then
        if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
            if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
                return true
            end
        end
    end
    return false
end

function isRendering()
    if option.actived == true then
        if not element then return end
        --if getPlayerName(localPlayer) ~="|PSZ|XJMLN" then  return end
        if value == "vehicle" then
            if not element then return end
            if not isElement(element) then return end
            local vid=getElementData(element,"vehicle:id") or "zrespiony"
            local driver=getElementData(element,"vehicle:driver") or "brak"
            local spawner = getElementData(element,"owner:by") or "SPAWN"
            local plate=getVehiclePlateText(element) or 0
            dxDrawText("Ostatni kierowca: "..driver..", stworzony przez: "..spawner, sw*558/mw, sh*356/mh, sw*790/mw, sh*380/mh, tocolor(255, 255, 255, 255), 1.00, "clear", "left", "top", false, true, false, false, false)
            dxDrawText("Tryb: Zaznaczanie pojedyncze", sw*608/mw, sh*404/mh, sw*790/mw, sh*411/mh, tocolor(255, 255, 255, 255), 1.00, "clear", "left", "top", false, false, false, false, false)
            if getElementData(localPlayer,"faction:id") ~=33 then
                if not element then return end
                    dxDrawText(option[value][option.selected] or "Akcja: Napraw pojazd", sw*608/mw, sh*390/mh, sw*790/mw, sh*401/mh, tocolor(255, 0, 0, 255), 1.00,  "clear", "center", "center", false, false, false, false, false)
            end
        end
    end
end

addEventHandler("onClientPlayerTarget",root, function(el)
        if isPedAiming(localPlayer) and el and getPedWeapon(localPlayer) == 22 then
            if not option.actived  then
                if getElementType(el) == "object" then
                    value="object"
                    element=el
                    option.actived=true
                elseif getElementType(el) == "vehicle" then
                    value="vehicle"
                    element=el
                    option.actived=true
                else return end
                bindKey("mouse1", "down", onElementClicked)
                bindKey("mouse_wheel_down", "down", onElementMoveDown)
                bindKey("mouse_wheel_up", "down", onElementMoveUp)
                bindKey("q", "down", onElementMoveDown)
                bindKey("e", "down", onElementMoveUp)
                addEventHandler("onClientHUDRender", root, isRendering)
            end
        else
            if option.actived then
                vehicle.el=nil
                option.actived=false
                unbindKey("mouse1", "down", onElementClicked)
                unbindKey("mouse_wheel_down", "down", onElementMoveDown)
                unbindKey("mouse_wheel_up", "down", onElementMoveUp)
                unbindKey("q", "down", onElementMoveDown)
                unbindKey("e", "down", onElementMoveUp)
                removeEventHandler("onClientHUDRender", root, isRendering)
            end
        end
    end)

function onElementMoveUp() if option.selected > 6 then option.selected=1 else option.selected=option.selected+1 end end
function onElementMoveDown() if option.selected < 1 then option.selected=6 else option.selected=option.selected-1 end end
function onElementClicked() if option.selected > 0 then triggerServerEvent("onDryerAction", localPlayer, value, option.selected, element) end end
