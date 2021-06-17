--[[

Tuning - neony, glosniki

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local piosenki={
    {1,text="CD WAYF",file=1},
    {2,text="CD Polska #1",file=2},
    {3,text="CD Święta",file=3},
}

local neony={
    {1400, text="Czerwony neon",idn=3962},
    {1600, text="Niebieski neon",idn=2113},
    {1300, text="Zielony neon",idn=1784},
    {1500, text="Żółty neon",idn=2054},
    {1150, text="Różowy neon",idn=2428},
    {500, text="Biały neon",idn=2352},
}
local function graczMozeMontowac()
    local job =getElementData(localPlayer,"duty:mechanik")
    if not job then return false end
    return true

end

local aktualny_marker=nil
local przetwarzany_pojazd=nil
local montaz={}
local neon={}
montaz.win= guiCreateWindow(0.20, 0.27, 0.60, 0.54, "Montaż tuningu", true)
guiWindowSetSizable(montaz.win, false)
guiSetVisible(montaz.win,false)
montaz.lbl1 = guiCreateLabel(0.04, 0.06, 0.91, 0.05, "Skrypt w fazie testów, wszelkie błędy zgłoś na forum. WWW.PSZMTA.PL", true, montaz.win)
montaz.grid_czesci = guiCreateGridList(0.02, 0.17, 0.96, 0.58, true, montaz.win)
guiGridListAddColumn(montaz.grid_czesci , "Numer", 0.3)
guiGridListAddColumn(montaz.grid_czesci , "Nazwa piosenki", 0.6)
montaz.btn1 = guiCreateButton(0.02, 0.86, 0.40, 0.11, "Zamontuj", true, montaz.win)
montaz.lbl2 = guiCreateLabel(0.02, 0.76, 0.96, 0.06, "UWAGA: Jeżeli montujesz system nagłośnienia, należy wybrać odtwarzany utwór.", true,montaz.win)
montaz.btn2  = guiCreateButton(0.62, 0.86, 0.36, 0.11, "Zamknij", true, montaz.win) 
-- Neon
neon.win= guiCreateWindow(0.20, 0.27, 0.60, 0.54, "Montaż tuningu", true)
guiWindowSetSizable(neon.win, false)
guiSetVisible(neon.win,false)
neon.lbl1 = guiCreateLabel(0.04, 0.06, 0.91, 0.05, "Aktualnie prawidłowo ustawione są neony do pojazdów: Infernus, Patriot, Tampa, Bullet, Euros.", true, neon.win)
neon.grid_czesci = guiCreateGridList(0.02, 0.17, 0.96, 0.58, true, neon.win)
guiGridListAddColumn(neon.grid_czesci , "Kolor neonu", 0.6)
guiGridListAddColumn(neon.grid_czesci , "Cena", 0.3)
neon.btn1 = guiCreateButton(0.02, 0.86, 0.40, 0.11, "Zamontuj", true, neon.win)
neon.btn2  = guiCreateButton(0.62, 0.86, 0.36, 0.11, "Zamknij", true, neon.win)  
guiSetEnabled(neon.btn1,false)
local function znajdzPojazd()
    if not aktualny_marker then return nil end
    local cs=getElementParent(aktualny_marker)
    if not cs or getElementType(cs)~="colshape" then return nil end
    local pojazdy=getElementsWithinColShape(cs,"vehicle")
    if not pojazdy or #pojazdy~=1 then return nil end
    return pojazdy[1]
end

addEventHandler("onClientMarkerHit", resourceRoot, function(el,md)
        if el~=localPlayer or not md then return end
        local typ=getElementData(source,"typ")
        if not typ then return end
        if not graczMozeMontowac() then return end
        if typ=="montaz" then
        aktualny_marker=source
        przetwarzany_pojazd=znajdzPojazd()
        if not przetwarzany_pojazd then
            outputChatBox("Wjedź pojazdem na podnośnik.")
            aktualny_marker=nil
            return
        end
        if getElementModel(przetwarzany_pojazd) ~= 482 then outputChatBox("Montaż głośników dostępny jest tylko dla pojazdu Burrito.")
            aktualny_marker=nil
            return
        end
            
            guiGridListClear(montaz.grid_czesci)
            for i,v in ipairs(piosenki) do
                    local row=guiGridListAddRow(montaz.grid_czesci)
                    guiGridListSetItemText ( montaz.grid_czesci, row, 1, v[1], false, false )
                    guiGridListSetItemText ( montaz.grid_czesci, row, 2, v.text, false, false )

                    guiGridListSetItemData ( montaz.grid_czesci, row, 2, v.file)
            end
            guiSetVisible(montaz.win,true)
            showCursor(true)
        end
        if typ=="neony" then
            --if getPlayerName(el) ~="|MECH|XJMLN" then outputChatBox("Montaż neonów wkrótce.") return end
            aktualny_marker=source
            przetwarzany_pojazd=znajdzPojazd()
            if not przetwarzany_pojazd then
                outputChatBox("Wjedź pojazdem na podnośnik.")
                aktualny_marker=nil
                return
            end
                guiGridListClear(neon.grid_czesci)
                for i,v in ipairs(neony) do
                    local rows=guiGridListAddRow(neon.grid_czesci)
                    guiGridListSetItemText(neon.grid_czesci, rows,1,v.text,false,false)
                    guiGridListSetItemText(neon.grid_czesci, rows,2,v[1].."$",false,false)
					guiGridListSetItemData(neon.grid_czesci, rows,2,v[1])
                    guiGridListSetItemData(neon.grid_czesci,rows,1,v.idn)
                end
            guiSetVisible(neon.win,true)
            showCursor(true)
        end
end)
local function closeWindow()
    showCursor(false)
    guiSetVisible(montaz.win,false)
end
addEventHandler("onClientMarkerLeave", resourceRoot, function(el,md)
        if el~=localPlayer then return end
        closeWindow()
        aktualny_marker=nil
        przetwarzany_pojazd=nil
    end)

addEventHandler("onClientGUIClick", montaz.btn2, closeWindow,false)
addEventHandler("onClientGUIClick", neon.btn2, function()
    showCursor(false)
    guiSetVisible(neon.win,false)
end,false)
addEventHandler("onClientGUIClick", montaz.grid_czesci, function()
local row = guiGridListGetSelectedItem(montaz.grid_czesci)
    if not row or row<0 then
        guiSetEnabled(montaz.btn1, false)
        return
    end
    guiSetEnabled(montaz.btn1, true)
end,false)


addEventHandler("onClientGUIClick", montaz.btn1, function()
        local row = guiGridListGetSelectedItem(montaz.grid_czesci)
        if not row or row<0 then
            return
        end
        local file_id=guiGridListGetItemData(montaz.grid_czesci, row,2)
        setElementData(przetwarzany_pojazd,"audio:id",tonumber(file_id))
        setElementData(przetwarzany_pojazd,"edit:tune",true)
        triggerServerEvent("addTuning", resourceRoot, przetwarzany_pojazd, tonumber(file_id))
        closeWindow()

    end, false)

addEventHandler("onClientGUIClick", neon.grid_czesci, function()
        local row = guiGridListGetSelectedItem(neon.grid_czesci)
        if not row or row<0 then
            guiSetEnabled(neon.btn1, false)
            return
        end
        guiSetEnabled(neon.btn1, true)
    end, false)

addEventHandler("onClientGUIClick", neon.btn1, function()
        local row = guiGridListGetSelectedItem(neon.grid_czesci)
        if not row or row<0 then
            return
        end
		local idn=guiGridListGetItemData(neon.grid_czesci, row,1)
		local car_occupant = getVehicleOccupant(przetwarzany_pojazd,0)
		local koszt = guiGridListGetItemData (neon.grid_czesci, row, 2)
		if (not car_occupant) then 
			outputChatBox("W pojeździe nie ma żadnego gracza.")
			return 
		end
		triggerServerEvent("takeClientCash", resourceRoot, localPlayer,car_occupant,tonumber(koszt),przetwarzany_pojazd,tonumber(idn))
        showCursor(false)
        guiSetVisible(neon.win,false)
    end, false)