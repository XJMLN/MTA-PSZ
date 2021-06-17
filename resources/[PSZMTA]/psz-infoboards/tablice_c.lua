--[[

Infoboards - Tablice informacyjne

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-infoboards
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local miejsca_tablic = {
    -- x,y,z,d,i, opcjonalnie id tablicy oraz nazwa 3dtext
    {-1943.86,420.20,-4.32,0,0, tablica=1, nazwa="(( Regulamin kina ))"},
	{1178.17,-1328.31,14.11,0,0, tablica=2, nazwa="(( Praca: Lekarz ))"},
	{2289.71,2421.57,10.82,0,0, tablica=3, nazwa="(( Praca: Policjant ))"},
	{-9.57,-301.04,5.42,0,0, tablica=4, nazwa="(( Praca: Strażak ))"},
    {2649.66,1220.88,10.82,0,0, tablica=5, nazwa="(( Warsztat Samochodowy I ))"},
    {972.13,-2152.18,28.03,3,121, tablica=6, nazwa="(( Magiczna tablica Ekipy Serwera ))"}, -- magiczna
    {1370.02,743.31,10.82,0,0, tablica=7, nazwa="(( Praca: Dziennikarz ))"},
    {2817.89,-1083.21,1593.71,51,1, tablica=8, nazwa="(( Praca: Listonosz ))"},
    {1651.19,1297.69,12.16,0,0,tablica=9, nazwa="Jesteś na serwerze pierwszy raz?\n Tutaj zdobędziesz potrzebne informacje na start!"},
    {2477.41,-1654.43,13.33,0,0,tablica=10, nazwa="Jesteś na serwerze pierwszy raz?\n Tutaj zdobędziesz potrzebne informacje na start!"},
    {-2416.27,-597.14,132.71,0,0,tablica=11, nazwa="Jesteś na serwerze pierwszy raz?\n Tutaj zdobędziesz potrzebne informacje na start!"},
   -- {-2143.29,925.65,79.91,0,0,tablica=12, nazwa="Jesteś na serwerze pierwszy raz?\n Tutaj zdobędziesz potrzebne informacje na start!"},
	{-245.56,2603.09,62.86,0,0,tablica=13, nazwa="Jesteś na serwerze pierwszy raz?\n Tutaj zdobędziesz potrzebne informacje na start!"},
	{1496.39,1811.28,10.81,0,0,tablica=14, nazwa="Wyścig: Lotnisko Las Venturas"},
    {1776.65,-1573.02,1734.94,231,0,tablica=15, nazwa="AJ - Admin Jail"},
    --{1942.31,-2275.52,13.55,0,0,tablica=16, nazwa="Studio Picasso - Co to takiego?"},
    --{1912.25,-2246.67,14.88,0,0,tablica=17, nazwa="Lista graczy z wysoką umiejętnością malowania"}, -- magiczna
    {-2715.56,213.28,4.33,0,0,tablica=18, nazwa="Warsztat: Zmiana wariantów"},
    {2409.84,-1395.17,24.23,0,0,tablica=19, nazwa="Praca: Holowanie pojazdów"},
    {-1630.23,1300.25,7.18,0,0,tablica=20, nazwa="Praca: Holowanie pojazdów"},
    {476.59,-22.08,1003.10,0,17,tablica=21, nazwa="Regulamin puszczania piosenek z YT"},
    {-1963.98,291.84,35.47,0,0,tablica=22, nazwa="Kupowanie pojazdów"}, -- salon
   -- {-1537.43,928.52,7.04,0,0,tablica=23, nazwa="Event: Poszukiwanie ciasteczek"},
    {349.67,-1833.84,7.86,0,0, tablica=24, nazwa="Regulamin: Kino plażowe"},
    {-2020.72,130.03,28.58,0,0, tablica=25, nazwa="Warsztat: Zapis i wczytywanie pojazdów"},
    --{-1546.14,936.11,7.04,0,0, tablica=26, nazwa="Event wielkanocny"},
}

for i,v in ipairs(miejsca_tablic) do
    v.pickup=createPickup(v[1],v[2],v[3],3,1239)
    setElementInterior(v.pickup,v[5])
    setElementDimension(v.pickup,v[4])
    v.text=createElement("text")
    setElementPosition(v.text,v[1],v[2],v[3]+1)
    setElementData(v.text,"text",v.nazwa or "(( Informacja ))") -- pozniej usunac/zmienic default text
    setElementInterior(v.text,v[5])
    setElementDimension(v.text,v[4])

end

local aktualna_tablica = nil

local function znajdzTablice(el)
    for i,v in ipairs(miejsca_tablic) do
        if v.pickup==el then return i end
    end
    return nil
end

x,y = guiGetScreenSize()
window = guiCreateWindow((x-800)/2, (y-600)/2, 800, 600, "Tablica informacyjna", false )
txt_memo = guiCreateMemo(10, 30, 780, 526, "", false, window)
guiSetVisible(window,false)

addEventHandler("onClientPickupHit", resourceRoot, function(el,md)
        --	outputChatBox("dupa")
        if (not md) then return end
        if (el~=localPlayer) then return end

        aktualna_tablica=znajdzTablice(source)
        if (not aktualna_tablica) then return end

        guiSetVisible(window,true)
        guiSetInputMode("no_binds_when_editing")
       -- showCursor(true, false)
        miejsca_tablic[aktualna_tablica].changed=nil
        triggerServerEvent("onPlayerRequestIBContents", localPlayer, miejsca_tablic[aktualna_tablica].tablica)
    end)
addEventHandler("onClientPickupLeave", resourceRoot, function(el,md)
        if (el~=localPlayer) then return end
        guiSetVisible(window,false)
        if (not aktualna_tablica) then return end
        local level = getElementData(localPlayer, "level")
        if (not level or tonumber(level)~=3) then 
            aktualna_tablica = nil
            return 
        end

        if (aktualna_tablica and miejsca_tablic[aktualna_tablica].changed) then 
            triggerServerEvent("onPlayerSendIBContents", localPlayer, miejsca_tablic[aktualna_tablica].tablica, guiGetText(txt_memo))
            if (miejsca_tablic[aktualna_tablica].onUpdate) then 
                setTimer(miejsca_tablic[aktualna_tablica].onUpdate, 5000, 1)
            end
        end
        aktualna_tablica=nil
    end)

addEventHandler("onClientGUIChanged", txt_memo, function()

    if (aktualna_tablica) then
        miejsca_tablic[aktualna_tablica].changed=true
    end
end)

addEvent("onIBContentsRcvd", true)
addEventHandler("onIBContentsRcvd", root, function(dane)
        if (not aktualna_tablica) then return end
        if (dane) then
            guiSetText(window, dane.nazwa)
            guiSetText(txt_memo, dane.tresc)
            miejsca_tablic[aktualna_tablica].changed=nil
            local level = getElementData(localPlayer,"level") or 0
            if (not level or tonumber(level) ~=3) then 
                guiMemoSetReadOnly(txt_memo,true)
            else
                guiMemoSetReadOnly(txt_memo, false)
            end
        else
            guiSetText(tx_win, "Tablica")
            guiSetText(ib_memo, "")
			guiMemoSetReadOnly(txt_memo,true)
        end
    end)
