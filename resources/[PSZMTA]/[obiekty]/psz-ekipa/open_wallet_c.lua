--[[

ekipa - otwarty portfel administracyjny

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
@package PSZMTA.psz-ekipa
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local wplatomaty = {
    {981.19,-2152.79,27.03,0,0,177.3,int=121, vw=3},
}

for i, v in ipairs(wplatomaty) do
    v.obiekt = createObject(2618, v[1],v[2],v[3],v[4],v[5],v[6])
    setElementInterior(v.obiekt,v.int)
    setElementDimension(v.obiekt,v.vw)

    v.cs = createColSphere(v[1],v[2],v[3]+1,1)
    setElementDimension(v.cs, v.vw or 0)
    setElementInterior(v.cs, v.int or 0)
    setElementData(v.cs,"open_wallet",true)
end

local ao = {}
    ao.win = guiCreateWindow(0.20, 0.20, 0.58, 0.35, "Otwarty portfel administratorski", true)
        guiWindowSetSizable(ao.win, false)
    ao.lblInfo = guiCreateLabel(0.02, 0.10, 0.96, 0.14, "Każda wypłata z otwartego portfela administratorskiego jest logowana.", true, ao.win)
        guiLabelSetColor(ao.lblInfo, 255,0,0)
        guiSetFont(ao.lblInfo, "default-bold-small")
        guiLabelSetHorizontalAlign(ao.lblInfo, "center", false)
    ao.lblStan = guiCreateLabel(0.11, 0.24, 0.72, 0.08, "Stan konta: $0", true, ao.win)
        --guiLabelSetColor(ao.lblStan, 255,0,0)
        guiSetFont(ao.lblStan, "default-bold-small")
        guiLabelSetHorizontalAlign(ao.lblStan, "center", false)
        guiLabelSetVerticalAlign(ao.lblStan, "center")
    ao.edit = guiCreateEdit(0.23, 0.54, 0.53, 0.14, "0", true, ao.win)
    ao.lblWyplata = guiCreateLabel(0.24, 0.41, 0.50, 0.08, "Wypłata pieniędzy", true, ao.win)
        guiSetFont(ao.lblWyplata, "default-bold-small")
        guiLabelSetHorizontalAlign(ao.lblWyplata, "center", false)
        guiLabelSetVerticalAlign(ao.lblWyplata, "center")
    ao.btn = guiCreateButton(0.24, 0.70, 0.53, 0.19, "Wypłać pieniądze", true, ao.win)
    guiSetVisible(ao.win,false)  


addEventHandler("onClientColShapeHit", resourceRoot, function(el,md)
    if not md or el~=localPlayer then return end
    if (not getElementData(source,"open_wallet")) then return end
    local level = getElementData(el,"level") or 0
    if (level and tonumber(level)<1) then return end
        guiSetVisible(ao.win, true)
        guiSetEnabled(ao.btn,false)
        showCursor(true,false)
        toggleControl("fire",false)
        guiSetText(ao.lblStan,"Trwa pobieranie danych...")
        triggerServerEvent("onPlayerRequestAOinfo", resourceRoot)
        guiSetInputMode("no_binds_when_editing")
end)

local function closeAOWin()
    if guiGetVisible(ao.win) then 
        guiSetVisible(ao.win, false)
        toggleControl("fire",true)
        showCursor(false)
    end
end

addEventHandler("onClientColShapeLeave", resourceRoot, function(el, md)
    if not md or el~=localPlayer then return end
    closeAOWin()
end)


addEvent("doFillAO", true)
addEventHandler("doFillAO", resourceRoot, function(succes, balance)
    if (not succes) then 
        guiSetText(ao.lblStan, "Nie jesteś zalogowany.")
        return 
    end
    guiSetText(ao.lblStan, "Stan konta:"..balance.."$")
    setElementData(ao.win, "balance", tonumber(balance))
    guiSetEnabled(ao.btn, true)
end)

addEventHandler("onClientPlayerSpawn",localPlayer, closeAOWin)

addEventHandler("onClientGUIClick", ao.btn, function()
    local kwota = tonumber(guiGetText(ao.edit))

    if not kwota or kwota<=0 then 
        outputChatBox("Nieprawidłowa kwota wpłaty!",255,0,0)
        return
    end

    local balance = getElementData(ao.win,"balance")
    if kwota>balance then
        outputChatBox("Portfel nie posiada tyle gotówki!", 255,0,0)
        return 
    end

    closeAOWin()
    triggerServerEvent("doAOOperation", resourceRoot, kwota)
end, false)

