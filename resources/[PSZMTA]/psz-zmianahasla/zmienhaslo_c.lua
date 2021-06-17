--[[

Zmiana hasla do konta

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-zmianahasla
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local sw,sh = guiGetScreenSize()
local zh = {}
local lu = getTickCount()
zh.wnd = guiCreateWindow((159/800)*sw, (205/600)*sh, (506/800)*sw, (234/600)*sh, "Zmiana hasła", false)
    guiWindowSetSizable(zh.wnd, false)
    guiSetVisible(zh.wnd,false)
zh.lbl1 = guiCreateLabel((10/800)*sw, (80/600)*sh, (73/800)*sw, (15/600)*sh, "Stare hasło:", false, zh.wnd)
zh.lbl2 = guiCreateLabel((10/800)*sw, (115/600)*sh, (75/800)*sw, (15/600)*sh, "Nowe hasło:", false, zh.wnd)
zh.lbl3 = guiCreateLabel((12/800)*sw, (34/600)*sh, (484/800)*sw, (32/600)*sh, "", false, zh.wnd)
    guiLabelSetColor(zh.lbl3, 255, 0, 0)
    guiLabelSetHorizontalAlign(zh.lbl3, "center", false)
    guiLabelSetVerticalAlign(zh.lbl3, "center")
zh.buttonDone = guiCreateButton((10/800)*sw, (171/600)*sh, (222/800)*sw, (46/600)*sh, "Zmień hasło", false, zh.wnd)
zh.buttonCancel = guiCreateButton((274/800)*sw, (171/600)*sh, (222/800)*sw, (46/600)*sh, "Anuluj", false, zh.wnd)
zh.editStare = guiCreateEdit((89/800)*sw, (111/600)*sh, (332/800)*sw, (25/600)*sh, "", false, zh.wnd)
    guiEditSetMasked(zh.editStare, true)
zh.edit = guiCreateEdit((89/800)*sw, (76/600)*sh, (332/800)*sw, (25/600)*sh, "", false, zh.wnd)   
guiEditSetMasked(zh.edit, true)  
guiSetInputMode("no_binds_when_editing")
function toggleGui()
    if not getElementData(localPlayer,"auth:uid") then return end
    if (guiGetVisible(zh.wnd)) then
        showCursor(false)
        guiSetVisible(zh.wnd,false)
    else
        showCursor(true)
        guiSetVisible(zh.wnd,true)
    end
end
addCommandHandler("zmienhaslo",toggleGui,false)

function hasloError(sukces,info)
    if info then
        guiSetText(zh.lbl3,info)
        return
    else
        showCursor(false)
        guiSetVisible(zh.wnd,false)
    end
end
addEvent("onPlayerNewPasswordEnd", true)
addEventHandler("onPlayerNewPasswordEnd", resourceRoot, hasloError)

addEventHandler("onClientGUIClick",zh.buttonDone,function()
	if getTickCount()-lu<5000 then
		return
	end
    if string.len(guiGetText(zh.edit))<1 then
        guiSetText(zh.lbl3, "Podaj aktualne hasło!")
        return
    end

    if string.len(guiGetText(zh.editStare))<1 then
        guiSetText(zh.lbl3, "Podaj nowe hasło!")
        return
    end
    triggerServerEvent("onPlayerSendNewPassword", resourceRoot, guiGetText(zh.edit), guiGetText(zh.editStare))
end,false)

addEventHandler('onClientGUIClick',zh.buttonCancel,function()
    showCursor(false)
    guiSetVisible(zh.wnd,false)
end,false)