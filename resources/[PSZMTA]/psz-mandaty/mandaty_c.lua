--[[

mandaty - splata mandatow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-mandaty
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
mandaty_win = guiCreateWindow(0.7672,0.2937,0.2016,0.4354,"Spłata mandatów",true)
mandaty_lbl = guiCreateLabel(0.0775, 0.3, 0.8, 03,"Koszt spłaty mandatów: $",true,mandaty_win)
mandaty_btn = guiCreateButton(0.0775,0.5837,0.8295,0.3541,"Spłać mandaty",true,mandaty_win)
guiLabelSetHorizontalAlign(mandaty_lbl,"center",true)
guiSetVisible(mandaty_win, false)

local komisariaty = {
    {252.39,117.30,1002.22,0,10}, -- komisariat LV
    {250.06,68.19,1002.64,0,6}, -- komisariat LS
    {234.95,165.01,1002.03,0,3}, -- komisariat SF
}

for i,v in ipairs(komisariaty) do
    v.marker=createMarker(v[1],v[2],v[3], "cylinder", 1, 255,255,255)
    setElementInterior(v.marker, v[5])
    setElementDimension(v.marker, v[4])
    setElementData(v.marker, "mandaty:delete", true)
end


addEventHandler("onClientMarkerHit", resourceRoot, function(el, md)
    if (el~=localPlayer or not md) then return end
    if (getElementInterior(source)~=getElementInterior(localPlayer)) then return end
    if (not getElementData(source, "mandaty:delete")) then return end
    local _,_,z1=getElementPosition(el)
    local _,_,z2=getElementPosition(source)
    if (math.abs(z1-z2)>3)  then return end
    triggerServerEvent("onPlayerRequestPayFotoCash",localPlayer)
    guiSetEnabled(mandaty_btn, false)
    toggleControl("fire",false)
    guiSetVisible(mandaty_win, true)
    showCursor(true,false)
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(el, md)
    if (el~=localPlayer or getElementDimension(el)~=getElementDimension(source)) then return end
    if (not getElementData(source, "mandaty:delete")) then return end

    guiSetVisible(mandaty_win, false)
    toggleControl("fire",true)
    showCursor(false)
end)

addEvent("onServerReturnCostFotoCash", true)
addEventHandler("onServerReturnCostFotoCash", resourceRoot, function(cost)
    if (not cost) then return end
    if (tonumber(cost) == 0 ) then 
        guiSetText(mandaty_lbl,"Nie posiadasz mandatów do spłacenia.")
        return
    end
    guiSetText(mandaty_lbl,"Koszt spłaty mandatów: $"..cost)

    setElementData(mandaty_btn,"cost",tonumber(cost))
    guiSetEnabled(mandaty_btn,true)
end)



addEventHandler("onClientGUIClick", mandaty_btn, function()
    if (getPlayerMoney() <tonumber(getElementData(source,"cost"))) then
        outputChatBox("Nie posiadasz wystarczającej ilości pieniędzy.",255,0,0)
        return
    end
    triggerServerEvent("onPlayerAcceptPay",localPlayer)
    guiSetVisible(mandaty_win, false)
    showCursor(false)
end, false)
