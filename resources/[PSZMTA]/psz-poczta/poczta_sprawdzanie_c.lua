--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local punkt_odbioru = createMarker(2812.75,-1093.45,1593.71,"corona",1,50,10,99,150)
setElementDimension(punkt_odbioru,51)
setElementInterior(punkt_odbioru,1)
local p_listy = {}

p_listy.win = guiCreateWindow(0.2281,0.2021,0.5938,0.6417,"",true)
p_listy.grd = guiCreateGridList(0.015,0.15,0.5553,0.2,true,p_listy.win)
p_listy.lbl_tresc = guiCreateLabel(0.0263,0.4058,0.2553,0.0649,"Treść:",true,p_listy.win)
p_listy.mem_tresc = guiCreateMemo(0.0237,0.4773,0.9421,0.4026,"",true,p_listy.win)
p_listy.lbl = guiCreateLabel(0.0264,0.10,0.25,0.064, "Wybierz list do przeczytania:", true, p_listy.win)
p_listy.grd_data = guiGridListAddColumn(p_listy.grd, "Data nadania listu", 0.5)
p_listy.grd_nick = guiGridListAddColumn(p_listy.grd, "Nick nadawcy", 0.5)
p_listy.btn_usun = guiCreateButton(0.0263,0.8961,0.4079,0.0747,"Usuń list",true,p_listy.win)
p_listy.btn_anuluj = guiCreateButton(0.5421,0.8961,0.4237,0.0747,"Zamknij",true,p_listy.win)
guiSetVisible(p_listy.win,false)
guiSetText(p_listy.win,"Czytanie listów")

p_listy.id = nil
p_listy.pokazywane = false

p_listy.pokaz = function()
    triggerServerEvent('getPostToPlayer',localPlayer)
    p_listy.pokazywane = false
    p_listy.id = nil
    showCursor(true,false)
    guiSetText(p_listy.mem_tresc,"")
    toggleControl('fire',false)
    guiSetVisible(p_listy.win,true)
end

p_listy.gridclick=function()
        selectedRow = guiGridListGetSelectedItem(p_listy.grd)
        if (selectedRow<0) then
            outputDebugString('selectedRow na poczcie -1')
        else
            local snick = guiGridListGetItemData(p_listy.grd, selectedRow, p_listy.grd_nick)
            if (snick) then
                p_listy.pokazywane=true
                p_listy.id=snick
                triggerServerEvent('getPostTekst',localPlayer,p_listy.id)
            end
        end
end

p_listy.onGetPost=function(wynik)
    if not wynik then return end
    guiGridListClear(p_listy.grd)
    for i,v in ipairs(wynik) do
        local row = guiGridListAddRow(p_listy.grd)
        guiGridListSetItemText(p_listy.grd, row, p_listy.grd_nick, v.nadawca, false, false)
        guiGridListSetItemData(p_listy.grd, row, p_listy.grd_nick, tonumber(v.id))
        guiGridListSetItemText(p_listy.grd, row, p_listy.grd_data, v.ts, false, false)
    end
end

p_listy.schowaj=function()
    showCursor(false)
    p_listy.pokazywane = false
    p_listy.id=nil
    toggleControl('fire',true)
    guiSetVisible(p_listy.win,false)
end

p_listy.show=function(v)
    guiSetText(p_listy.mem_tresc,"")
    guiSetText(p_listy.mem_tresc,v.tresc)
end

p_listy.usun=function()
    if (p_listy.id) then
        triggerServerEvent('deletePostText',localPlayer,p_listy.id)
        guiSetVisible(p_listy.win,false)
        showCursor(false)
    else
        outputChatBox("Nie wybrałeś listu.")
    end
end

addEventHandler("onClientMarkerHit", punkt_odbioru, function(el,md)
        if (el~=localPlayer) then return end
        if (not md) then return end
        p_listy.pokaz()
end)

addEventHandler("onClientGUIClick", p_listy.btn_usun, p_listy.usun, false)
addEventHandler("onClientGUIClick", p_listy.btn_anuluj, p_listy.schowaj, false)
addEventHandler("onClientGUIClick", p_listy.grd, p_listy.gridclick, false)
addEvent("onPlayerGetPost",true)
addEventHandler('onPlayerGetPost',root, p_listy.onGetPost)
addEvent("showPlayerPostData",true)
addEventHandler('showPlayerPostData',root,p_listy.show)