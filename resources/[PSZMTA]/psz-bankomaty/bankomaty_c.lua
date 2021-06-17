local bankomaty={
    {2458.47,-1668.54,12.48,0,0,180,0,0}, -- LS Ganton, obok spawnu
    { -2418.78,-581.62,131.72,0,0,35,0,0}, -- SF Missionary Hill, obok spawnu
    {1646.35,1319.40,11.16,0,0,0,0,0}, -- LV Pirate Ship, obok spawnu
    {2280.07,2430.63,9.82,0,0,90,0,0}, -- LV, komisariat
    {1172.07,-1319.09,14.39,0,0,90,0,0},-- Los Santos, szpital
    {-32.95,-296.15,4.43,0,0,0,0,0},-- BlueBerry, straz pozarna
   -- {-693.93,960.52,11.24,0,0,274,0,0},-- Tierra Robada Rancho, spawn
    {254.66,-1824.02,2.93,0,0,95.7,0,0},-- Los Santos Santa Maria Beach, scena
    {-2032.98,159.54,28.04,0,0,90,0,0},-- SF Doherty, warsztat
    --{2017.74,-1777.12,12.49,0,0,270,0,0,}, -- LS I-wood, warsztat
    {2650.07,1199.32,9.82,0,0,270,0,0}, -- LV Warsztat
    {965.22,-2139.13,27.04,0,0,88.5,121,3}, -- Bialy dom 
    {2313.45,-17.32,25.74,0,0,180,0,0}, -- Bank w Palomino Creek
    {2172.80,-322.87,62.82,0,0,122.5,0,0}, -- Osiedle domków nad Palomino Creek
    {2941.81,-1797.72,1190.07,0,0,0,2,33}, -- W interiorze banku
    {2823.73,-1085.29,1592.71,0,0,270,1,51},
    --{1910.45,-2246.73,13.88,0,0,0,0,0}, -- studio picasso LS air
    {2404.37,-1230.57,22.82,0,0,88.5,0,0}, -- pig pen ls
    {-2716.91,207.35,3.34,0,0,360,0,0}, -- zmiana wariantow warsztat
    {-252.46,2595.72,61.86,0,0,90,0,0}, -- Las Paysadas, spawn
    {1837.37,-1689.68,12.32,0,0,264.5,0,0}, -- Los Santos, Alhambra
    {1480.36,-1683.47,12.36,0,0,180,0,0}, -- Los Santos, parking zloty
    {-2079.42,1436.19,8.02,0,0,0,0,0}, -- San Fierro, doki obok spawnu
}

for i,v in ipairs(bankomaty) do
    v.bankomat=createObject(2618,v[1],v[2],v[3],v[4],v[5],v[6])
    setElementInterior(v.bankomat,v[7] or 0)
    setElementDimension(v.bankomat,v[8] or 0)

    v.icon=createBlip(v[1],v[2],v[3],0,1,5,255,5,255,-1000,300)
    setElementInterior(v.icon,v[7] or 0)
    setElementDimension(v.icon,v[8] or 0)

    v.cs=createColSphere(v[1],v[2],v[3]+1,1)
    setElementInterior(v.cs,v[7] or 0)
    setElementDimension(v.cs,v[8] or 0)
end

local bn={}

bn.wnd = guiCreateWindow(0.27, 0.29, 0.46, 0.48, "Bankomat",true)
guiWindowSetSizable(bn.wnd,false)
guiWindowSetMovable(bn.wnd,false)
bn.tab1 = guiCreateTabPanel(0.02, 0.18, 0.47, 0.64, true, bn.wnd)
bn.tab1 = guiCreateTab("Wpłata", bn.tab1)
bn.edit1 = guiCreateEdit(0.03, 0.19, 0.94, 0.17, "0", true, bn.tab1)
bn.button1 = guiCreateButton(0.02, 0.48, 0.95, 0.43, "Wpłać", true, bn.tab1)
bn.button2 = guiCreateButton(0.27, 0.85, 0.47, 0.12, "Zamknij", true, bn.wnd)
bn.label1 = guiCreateLabel(0.02, 0.07, 0.97, 0.12, "Stan konta bankowego: 0$", true, bn.wnd)
guiSetFont(bn.label1, "clear-normal")
guiLabelSetHorizontalAlign(bn.label1, "center", false)
bn.tabpanel2 = guiCreateTabPanel(0.50, 0.19, 0.48, 0.64, true, bn.wnd)
bn.tab2 = guiCreateTab("Wypłata", bn.tabpanel2)
bn.edit2 = guiCreateEdit(0.02, 0.19, 0.93, 0.17, "0", true, bn.tab2)
bn.button3 = guiCreateButton(0.03, 0.50, 0.95, 0.42, "Wypłać", true, bn.tab2)

guiSetVisible(bn.wnd,false)

addEventHandler("onClientColShapeHit", resourceRoot, function(el,md)
if not md or el~=localPlayer then return end
        guiSetVisible(bn.wnd, true)
        guiSetEnabled(bn.button1, false)
        guiSetEnabled(bn.button3, false)
        guiSetText(bn.label1,"Trwa łączenie z bankiem...")
        triggerServerEvent("onRequestBankPermission",resourceRoot)
        showCursor(true)
end)

local function closeAll()
    if guiGetVisible(bn.wnd) then
        guiSetVisible(bn.wnd, false)
        showCursor(false)
    end
end
addEventHandler("onClientGUIClick", bn.button2, closeAll, false)

addEvent("doFillATMInfo", true)
addEventHandler("doFillATMInfo", resourceRoot, function(success, balance)
        if not success then
            guiSetText(bn.label1,"Musisz być zarejestrowanym graczem aby skorzystać z bankomatu.")
            return
        end
        guiSetText(bn.label1,"Stan konta bankowego: "..balance.."$")
        setElementData(bn.wnd, "balance", tonumber(balance))
        guiSetText(bn.edit2,balance)
        if balance>0 then
            guiSetEnabled(bn.button3, true)
        end

        guiSetText(bn.edit1,getPlayerMoney(localPlayer))
        guiSetEnabled(bn.button3, true)
        guiSetEnabled(bn.button1,true)
    end)

addEventHandler("onClientPlayerSpawn", localPlayer, closeAll)

-- Wplata/wyplata
addEventHandler("onClientGUIClick", bn.button1, function()
        local kwota=tonumber(guiGetText(bn.edit1))
        if not kwota or kwota<=0 then
            outputChatBox("Nieprawidłowa kwota wpłaty!", 255,0,0)
            return
        end
         if string.find(tonumber(kwota),"%p%d") ~= nil or string.find(tonumber(kwota),"%p%d%d") ~= nil then outputChatBox("Nie możesz wpłacić kwoty z groszami.",255,0,0) return end
            if kwota>getPlayerMoney() then
                outputChatBox("Nie masz tyle gotówki!", 255,0,0)
                return
            end
            closeAll()
            triggerServerEvent("doATMOperation", resourceRoot, kwota)
end, false)

addEventHandler("onClientGUIClick", bn.button3, function()
        if not tonumber(guiGetText(bn.edit2)) then return end
        local kwota=tonumber(guiGetText(bn.edit2))
        if not kwota or kwota<=0 then
            outputChatBox("Nieprawidłowa kwota wypłaty!", 255,0,0)
            return
        end
        if string.find(tonumber(kwota),"%p%d") ~= nil or string.find(tonumber(kwota),"%p%d%d") ~= nil then outputChatBox("Nie możesz wypłacić kwoty z groszami.",255,0,0) return end
        if getPlayerMoney()+kwota>99999999 then
            outputChatBox("Maksymalna ilość gotówki którą możesz mieć przy sobie to 99999999$", 255,0,0)
            return
        end
        closeAll()
        triggerServerEvent("doATMOperation", resourceRoot, -kwota)
end, false)
