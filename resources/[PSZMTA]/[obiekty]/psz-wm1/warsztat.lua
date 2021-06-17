local C_MECH = 0
local napisy = {
    {2654.35,1218.05,11.48, 0, 0}, -- LV
}

for i,v in ipairs(napisy) do
    v.d3text = createElement("ctext")
    setElementPosition(v.d3text,v[1],v[2],v[3]+0.4)
    setElementData(v.d3text,"ctext","Ilość mechaników:"..C_MECH.."/5")
    setElementData(v.d3text,"f:text",5)
    setElementDimension(v.d3text,v[5])
    setElementInterior(v.d3text,v[4])
end

local col_warsztat = createColCuboid(2617.24, 1163.43, 9.57,60.25,79.75,50)

function startPlayerDuty()
    local nick = getPlayerName(source)
    if (getElementData(source,"duty:mechanik")) then
        local newNick = getElementData(source,"duty:nick")
        removeElementData(source,"duty:mechanik")
        removeElementData(source,"faction:id")
        local idskin = getElementData(source,"skin:last")
        setElementModel(source,tonumber(idskin))
        setPlayerName(source,newNick) -- tutaj wystepuje blad z zmiana nicku!
        setPlayerNametagColor(source,math.random(0,255),math.random(0,255),math.random(0,255))
        C_MECH = C_MECH - 1
        if C_MECH < 0 then 
            C_MECH = 0
        end
        exports['psz-frakcje']:updateAllTxt(5,C_MECH)
        removeElementData(source,"duty:nick")
        removeElementData(source,"skin:last")

        outputChatBox("* Zakończyłeś pracę mechanika.",source)
    else
        if (getElementData(source,"duty:policja")) or (getElementData(source,"duty:strazak")) or (getElementData(source,"duty:lekarz")) or (getElementData(source,"duty:cnn")) then 
            outputChatBox("* Aktualnie pełnisz funkcję w innej pracy, zakończ pracę i wtedy rozpocznij kolejną.",source)
            return false
        end
        if C_MECH>= 5 then  return end
        setElementData(source,"duty:mechanik",true)
        setElementData(source,"duty:nick",nick)
        local skinid = getElementModel(source)
        setElementData(source,"skin:last",tonumber(skinid))
        setElementData(source,"faction:id",tonumber(5))
        setElementModel(source,50)
        setPlayerNametagColor(source,math.random(0,255),147,math.random(0,150))
        string.gsub(nick,"|MECH|","")
        setPlayerName(source,"|MECH|"..nick)
        outputChatBox("* Rozpoczynasz pracę jako mechanik.",source)      
        C_MECH = C_MECH + 1
        exports['psz-frakcje']:updateAllTxt(5,C_MECH)
    end
end
addEvent("onPlayerRequestJoinMechanik",true)
addEventHandler("onPlayerRequestJoinMechanik",root, startPlayerDuty)

function onPlayerQuitDuty()
    if getElementData(source,"duty:mechanik") then
        C_MECH = C_MECH - 1
        exports['psz-frakcje']:updateAllTxt(5,C_MECH)
    end
end
addEventHandler ( "onPlayerQuit", getRootElement(), onPlayerQuitDuty)

function onPlayerLeavePlace(thePlayer)
    if getElementData(thePlayer,"duty:mechanik") then
        removeElementData(thePlayer,"duty:mechanik")
        outputChatBox("Opuściłeś teren warsztatu, zostałeś wyrzucony z pracy.",thePlayer,255,0,0)
        setPlayerName(thePlayer,getElementData(thePlayer,"duty:nick"))
        setPlayerNametagColor(thePlayer,math.random(0,255),math.random(0,255),math.random(0,255))
        setElementModel(thePlayer,getElementData(thePlayer,"skin:last"))
        removeElementData(thePlayer,"duty:nick")
        removeElementData(thePlayer,"skin:last")
        removeElementData(thePlayer,"faction:id")
        C_MECH = C_MECH - 1
        if C_MECH < 0 then 
            C_MECH = 0
        end
        exports['psz-frakcje']:updateAllTxt(5,C_MECH)
    end
    if getElementType(thePlayer) == "vehicle" then
        local occupants = getVehicleOccupants(thePlayer)
        for seat, player in pairs(occupants) do
            if (player and getElementType(player) == "player") then
                if getElementData(player,"duty:mechanik") then
                    removeElementData(player,"duty:mechanik")
                    outputChatBox("Opuściłeś teren warsztatu, zostałeś wyrzucony z pracy.",player,255,0,0)
                    setPlayerName(player,getElementData(player,"duty:nick"))
                    setPlayerNametagColor(player,math.random(0,255),math.random(0,255),math.random(0,255))
                    setElementModel(player,getElementData(player,"skin:last"))
                    removeElementData(player,"duty:nick")
                    removeElementData(player,"skin:last")
                    removeElementData(player,"faction:id")
                    C_MECH = C_MECH - 1
                    if C_MECH < 0 then 
                        C_MECH = 0
                    end
                    exports['psz-frakcje']:updateAllTxt(5,C_MECH)
                end
            end
        end
    end
end
addEventHandler("onColShapeLeave",col_warsztat,onPlayerLeavePlace)