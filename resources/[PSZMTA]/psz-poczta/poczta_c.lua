--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local PSZ_BOT_UID = 2 -- konto 'tester' - zablokowane wiec moge uzyc jako bot
local POCZTA_LISTOW = 4

local punkt_nadawczy = createMarker(2812.77,-1089.48,1593.71,"corona",1,0,53,32,150)
setElementDimension(punkt_nadawczy,51)
setElementInterior(punkt_nadawczy,1)
local p_list = {}

p_list.win = guiCreateWindow(0.2281,0.2021,0.5938,0.6417,"",true)
p_list.lbl_cel = guiCreateLabel(0.0263,0.0682,0.2553,0.0649,"Adresat listu:",true,p_list.win)
p_list.edt_cel = guiCreateEdit(0.0263,0.1331,0.5158,0.0844,"Podaj nick odbiorcy, lub jego fragment",true,p_list.win)
p_list.btn_cel = guiCreateButton(0.5579,0.1364,0.4079,0.0812,"Sprawdź poprawność nicku",true,p_list.win)
p_list.lbl_tresc = guiCreateLabel(0.0263,0.4058,0.2553,0.0649,"Treść:",true,p_list.win)
p_list.mem_tresc = guiCreateMemo(0.0237,0.4773,0.9421,0.4026,"",true,p_list.win)
p_list.info = guiCreateLabel(0.54, 0.35, 0.26, 0.15, "List możesz wysłać jedynie do osoby która ma dom. :)", true,p_list.win)    
p_list.btn_wyslij = guiCreateButton(0.0263,0.8961,0.4079,0.0747,"Wyślij (25$)",true,p_list.win)
p_list.btn_anuluj = guiCreateButton(0.5421,0.8961,0.4237,0.0747,"Zrezygnuj",true,p_list.win)
p_list.players = guiCreateGridList(0.26, 0.30, 0.3, 0.16, true,p_list.win)
p_list.players_nick = guiGridListAddColumn(p_list.players, "Nick gracza:", 0.8)
guiSetText(p_list.win,"Wysyłanie listu")
guiSetAlpha(p_list.players, 0.68)  
guiSetVisible(p_list.players,false)
guiSetVisible(p_list.win,false)

p_list.cel = nil
p_list.verify = false

p_list.pokaz = function()
    guiSetVisible(p_list.win,true)
    guiSetEnabled(p_list.btn_wyslij,false)
    guiSetEnabled(p_list.edt_cel,true)
    p_list.verify = false
    guiSetText(p_list.btn_cel,"Sprawdź poprawność nicku")
    guiSetInputMode("no_binds_when_editing")
    p_list.cel = nil
    toggleControl('fire',false)
    showCursor(true,false)
end

p_list.sprawdzNick=function()
    local cel = guiGetText(p_list.edt_cel)
    if (string.len(cel)<2) then
        guiSetText(p_list.btn_cel,"Podany nick jest zbyt krótki")
        p_list.verify = false
        p_list.cel = nil
        guiSetEnabled(p_list.btn_wyslij,false)
        setTimer(guiSetText,1500,1,p_list.btn_cel,"Sprawdź poprawność")
        return
    end
    triggerServerEvent("doVerifyAccountNickname", localPlayer, cel)
end

p_list.showNicknames=function(wynik)
if not wynik then return end
    guiSetVisible(p_list.players,true)
    guiGridListClear(p_list.players)
    for i,v in ipairs(wynik) do
        local row = guiGridListAddRow(p_list.players)
        guiGridListSetItemText(p_list.players, row, p_list.players_nick, v.nick, false, false)
        guiGridListSetItemData(p_list.players, row, p_list.players_nick, tonumber(v.userid))
    end
 end

p_list.gridclick=function()
    if (guiGetVisible(p_list.players) == true) then
        selectedRow = guiGridListGetSelectedItem(p_list.players)
        if (selectedRow<0) then
            guiSetEnabled(p_list.edt_cel,false)
            guiSetEnabled(p_list.btn_wyslij,false)
        else
            local snick = guiGridListGetItemData(p_list.players, selectedRow, p_list.players_nick)
                if (snick) then
                p_list.verify=true
                p_list.cel=snick
                guiSetEnabled(p_list.btn_wyslij,true)
            end
        end
    end
end

p_list.onResponse=function(wynik)
    --if (cel~=guiGetText(p_list.edt_cel)) then return end
    if (wynik) then
        guiSetText(p_list.btn_cel,"Znaleziono gracza")
        guiSetEnabled(p_list.edt_cel,false)
        guiSetEnabled(p_list.btn_wyslij,false)
        p_list.showNicknames(wynik)
        p_list.verify=false
        p_list.cel=nil
    else
        guiSetText(p_list.btn_cel,"Nie znaleziono żadnego gracza")
        setTimer(guiSetText,2500,1,p_list.btn_cel,"Sprawdź poprawność")
        guiSetEnabled(p_list.btn_wyslij,false)
        p_list.verify=false
        p_list.cel=nil
    end
end

p_list.schowaj=function()
    guiSetVisible(p_list.win,false)
    guiSetVisible(p_list.players,false)
    showCursor(false)
    toggleControl('fire',true)
end

p_list.wyslij=function()
    if (getPlayerMoney(localPlayer)<25) then
        outputChatBox("Nie stać Cię na wysłanie listu - wymagane 25$.")
        p_list.schowaj()
        return
    end
    if (not p_list.cel) then return end
    local tresc = guiGetText(p_list.mem_tresc)
    if (string.len(tresc)<1) then
        outputChatBox("Wprowadź treść wiadomości.")
        return
    end
    
    triggerServerEvent("doSendPost",localPlayer, p_list.cel, tresc)
    p_list.schowaj()
end

addEventHandler("onClientMarkerHit", punkt_nadawczy, function(el,md)
    if (el~=localPlayer) then return end
    if (not md) then return end
    if (getPlayerMoney(localPlayer)<25) then
        outputChatBox("Nie stać Cię na wysłanie listu - wymagane 25$.")
        return
    end
    p_list.pokaz()
end)

addEventHandler("onClientMarkerLeave", punkt_nadawczy, function(el,md)
    if (el~=localPlayer) then return end
    p_list.schowaj()
end)

addEventHandler("onClientGUIClick", p_list.players, p_list.gridclick, false)
addEventHandler("onClientGUIClick", p_list.btn_anuluj, p_list.schowaj, false)
addEventHandler("onClientGUIClick", p_list.btn_wyslij, p_list.wyslij, false)
addEventHandler("onClientGUIClick", p_list.btn_cel, p_list.sprawdzNick, false)
addEvent('showResultAboutAccounts',true)
addEventHandler("showResultAboutAccounts", root, p_list.onResponse)