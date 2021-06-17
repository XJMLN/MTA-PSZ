--[[

ekipa - zamkniete glosowanie w ekipie - zakompilowac!!

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
@package PSZMTA.psz-ekipa
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local wb = {}
local sw,sh = guiGetScreenSize()
wb.win = guiCreateWindow(0.06, 0.17, 0.87, 0.70,"Zamknięte głosowanie",true)
wb.gridlist = guiCreateGridList(0.01, 0.06, 0.39, 0.91, true, wb.win)
    wb.gridlist_nick = guiGridListAddColumn(wb.gridlist,"Nick aplikującego",1)
wb.lblSerial = guiCreateLabel(0.41, 0.08, 0.50, 0.04, "Serial:", true, wb.win)
wb.lblDsc = guiCreateLabel(0.41, 0.14, 0.21, 0.04, "Część opisowa:", true, wb.win)
wb.memo = guiCreateMemo(0.41, 0.19, 0.58, 0.62, "", true, wb.win)
wb.btnCancel = guiCreateButton(0.68, 0.82, 0.26, 0.16, "Zamknij", true, wb.win)
wb.btnSend = guiCreateButton(0.41, 0.82, 0.26, 0.16, "Oddaj głos (0/3)", true, wb.win)

guiSetVisible(wb.win, false)

addEvent("onKartaDoGlosowania", true)
addEventHandler("onKartaDoGlosowania", resourceRoot, function(dane,ilosc)
    guiMemoSetReadOnly(wb.memo,true)
    guiGridListClear(wb.gridlist)
    guiSetText(wb.memo,"")
    guiSetText(wb.lblSerial,"Serial: brak")
    guiSetText(wb.btnSend, string.format("Oddaj głos (%d/3)",ilosc))
    guiSetEnabled(wb.btnSend,false)
    for i,v in ipairs(dane) do
        local row = guiGridListAddRow(wb.gridlist)
        guiGridListSetItemText(wb.gridlist, row, wb.gridlist_nick, tostring(v.nick), false, false)
        guiGridListSetItemData(wb.gridlist, row, wb.gridlist_nick, v )
    end
    guiSetVisible(wb.win, true)
    showCursor(true,false)
end)

addEventHandler("onClientGUIDoubleClick",wb.gridlist, function() 
    local selRow, selCol = guiGridListGetSelectedItem(wb.gridlist)
    if (not selRow) then return end
    guiSetEnabled(wb.btnSend, true)
    local data = guiGridListGetItemData(wb.gridlist, selRow,wb.gridlist_nick)
    guiSetText(wb.memo, tostring(data.description))
    setElementData(wb.btnSend, "choosen_plr",data.user_id)
    guiSetText(wb.lblSerial,string.format("Serial: %s",data.serial))
end, false)


addEventHandler("onClientGUIClick", wb.btnCancel, function()
    guiSetVisible(wb.win, false)
    showCursor(false)
end,false)

addEventHandler("onClientGUIClick", wb.btnSend, function()
    triggerServerEvent("onAdminReceiveVote",resourceRoot,getElementData(source,"choosen_plr"))
    guiSetVisible(wb.win, false)
    showCursor(false)
end,false)
