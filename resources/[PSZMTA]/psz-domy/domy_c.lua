local a_dom=nil
local font = guiCreateFont(":psz-gui/font/font.ttf",20) 
if not font then font="default-bold-small" end
local md = {}

md.win = guiCreateWindow(0.29,0.26,0.41,0.27,"Dom",true)
    guiWindowSetMovable(md.win,false)
    guiWindowSetSizable(md.win,false)
md.lbl_dom = guiCreateLabel(0.28,0.10,0.46,0.08,"Opis domu",true,md.win)
    guiSetFont(md.lbl_dom, "default-bold-small")
    guiLabelSetHorizontalAlign(md.lbl_dom, "center", false)
    guiLabelSetVerticalAlign(md.lbl_dom, "center")
md.lbl_owner = guiCreateLabel(0.02,0.24,0.96,0.08,"Ten dom nie posiada właściciela.",true,md.win)
md.btn_wejdz = guiCreateButton(0.02,0.54,0.41,0.39,"Wejdź do domu",true,md.win)
md.btn_kupno = guiCreateButton(0.57,0.54,0.41,0.39,"Kup dom",true,md.win)
guiSetVisible(md.win,false)

local bd = {}

bd.win = guiCreateWindow(0.19,0.22,0.58,0.62,"Zarządzanie domem",true)
    guiWindowSetSizable(bd.win,false)
    guiWindowSetMovable(bd.win,false)
bd.btnZamknij = guiCreateButton(0.01,0.86,0.33,0.11,"Zamknij",true,bd.win)

bd.tabp = guiCreateTabPanel(0.01,0.05,0.97,0.80,true,bd.win)

bd.tabKup = guiCreateTab("Kup dom",bd.tabp)
bd.lblKup = guiCreateLabel(0.39,0.00,0.21,0.11,"Kupno domu ",true,bd.tabKup)
    guiSetFont(bd.lblKup,font)
bd.lblAdres = guiCreateLabel(0.26, 0.11, 0.9, 0.08, "-",true,bd.tabKup)
    guiSetFont(bd.lblAdres, "default-bold-small")
    guiLabelSetHorizontalAlign(bd.lblAdres, "center", false)
    guiLabelSetVerticalAlign(bd.lblAdres, "center")
bd.lblKoszt = guiCreateLabel(0.17,0.62,0.62,0.09,"Koszt kupna domu na okres x dni, wynosi: y$.",true,bd.tabKup)
    guiSetFont(bd.lblKoszt,"default-bold-small")
    guiLabelSetHorizontalAlign(bd.lblKoszt,"center",false)
bd.lblDni = guiCreateLabel(0.28,0.43,0.43,0.06,"Wpisz poniżej ilość dni na jaką chcesz kupić dom",true,bd.tabKup)
bd.editDni = guiCreateEdit(0.28,0.50,0.43,0.08,"",true,bd.tabKup)
bd.btnPotwierdz = guiCreateButton(0.718,0.505,0.161,0.081,"Potwierdzam",true,bd.tabKup)
bd.btnKup = guiCreateButton(0.28,0.71,0.43,0.15,"Kup dom",true,bd.tabKup)
bd.lblDomki = guiCreateLabel(0.01,0.89,0.98,0.05,"[WKRÓTCE] Możesz kupić taniej dom za Punkty Zabawy, więcej informacji na www.panel.pszmta.pl/domy",true,bd.tabKup)
    guiLabelSetHorizontalAlign(bd.lblDomki,"center",false)
bd.tabMng = guiCreateTab("Zarządzanie domem",bd.tabp)
bd.btnDrzwi = guiCreateButton(0.01,0.02,0.31,0.22,"Drzwi",true,bd.tabMng)
bd.btnGangHouse = guiCreateButton(0.20, 0.75, 0.6, 0.22, "Przepisz dom na gang", true, bd.tabMng)
guiSetVisible(bd.win,false)

local function schowajOknaDomu()
    if guiGetVisible(md.win) or guiGetVisible(bd.win) then
        guiSetVisible(md.win,false)
        guiSetVisible(bd.win,false)
        toggleControl("fire", true)
        showCursor(false)
    end
end

local function getPlayerDBID(plr)
    local c=getElementData(plr,"auth:uid")
    if not c then return nil end
    return tonumber(c)
end

local function getPlayerGangData(plr)
    local c = getElementData(plr,"character")
    if (not c) then return nil end
    return tonumber(c.gg_id);
end
local function pokazOknoDomu(dom)
    guiSetVisible(md.win, true)
    showCursor(true,false)
    toggleControl("fire", false)
    setPedWeaponSlot(localPlayer, 0)
    guiSetText(md.lbl_dom,dom.descr)
    guiSetText(md.lbl_owner," Dom "..(dom.owner_nick or "nie posiada właściciela."))
    local dbid=getElementData(localPlayer,"auth:uid")

    if dom.ownerid then
        guiSetText(md.btn_wejdz, "Wejdź do domu")
        if dbid and dom.ownerid==dbid then
            guiSetVisible(md.btn_kupno, true)
            guiSetText(md.btn_kupno, "Opcje")

            guiSetEnabled(bd.tabMng, true)
        else
            guiSetVisible(md.btn_kupno, false)
            guiSetEnabled(bd.tabMng, false)
        end
        
    else
        guiSetText(md.btn_wejdz, "Zobacz dom")
        guiSetText(md.btn_kupno, "Kup dom")
        guiSetVisible(md.btn_kupno, true)
        guiSetEnabled(bd.tabMng, false)

    end
    guiSetSelectedTab(bd.tabp,bd.tabKup)
    guiSetText(bd.lblAdres,"")
    guiSetVisible(bd.btnKup,true)
    guiSetVisible(bd.btnPotwierdz, false)
    t = "Koszt kupna domu na jeden dzień wynosi:"..dom.koszt.."$."
    if dom.ownerid and dom.paidTo then
        t=t.."\n"..string.format("Dom jest opłacony do %s (%d dni).", dom.paidTo, dom.paidTo_dni)
    end
    guiSetText(bd.lblKoszt, t)
    guiSetText(bd.win, "Opcje domu " .. dom.id)
        if dom.zamkniety then
            guiSetText(bd.btnDrzwi,"Otwórz dom")
        else
            guiSetText(bd.btnDrzwi,"Zamknij dom")
        end
        if dom.owner_gang then 
            guiSetText(bd.btnGangHouse,"Zakończ udostępnianie domu gangowi")
        else
            guiSetText(bd.btnGangHouse,"Udostępnij dom gangowi")
        end
end

addEventHandler("onClientColShapeHit", resourceRoot, function(el,md)
        if el~=localPlayer or not md then return end
        local dom=getElementData(source,"dom")
        if not dom then return end
        a_dom=dom
        pokazOknoDomu(dom)
end)

local function domWejscie()
    if not a_dom then return end
    local dbid=getPlayerDBID(localPlayer)
    local gg_id = getPlayerGangData(localPlayer)
    if not a_dom.ownerid then   -- dom jest do kupienia, wpuszczamy gracza zeby zobaczyl
        ad=a_dom
        triggerServerEvent("moveMeTo", resourceRoot, a_dom.interior_loc[1], a_dom.interior_loc[2], a_dom.interior_loc[3], a_dom.interior, a_dom.dimension)
        setTimer(function(d,p)
            if (getElementDimension(localPlayer)==d) then
                triggerServerEvent("moveMeTo", resourceRoot, p[1], p[2], p[3], 0,0)
            end
        end, 30000,1,ad.dimension, ad.exit_loc)
    elseif not a_dom.zamkniety or a_dom.ownerid==dbid then
        triggerServerEvent("moveMeTo", resourceRoot, a_dom.interior_loc[1], a_dom.interior_loc[2], a_dom.interior_loc[3], a_dom.interior, a_dom.dimension)
    elseif a_dom.zamkniety and a_dom.ownerid==dbid then
        triggerServerEvent("moveMeTo", resourceRoot, a_dom.interior_loc[1], a_dom.interior_loc[2], a_dom.interior_loc[3], a_dom.interior, a_dom.dimension)
    elseif a_dom.zamkniety and a_dom.restrict_gang==gg_id then 
        triggerServerEvent("moveMeTo", resourceRoot, a_dom.interior_loc[1], a_dom.interior_loc[2], a_dom.interior_loc[3], a_dom.interior, a_dom.dimension)
    elseif a_dom.zamkniety then
        outputChatBox("Dom jest zamknięty.",255,0,0)
   
    end
end
addEventHandler("onClientGUIClick", md.btn_wejdz, domWejscie, false)
local function domOpcje()
    guiSetVisible(bd.win, true)
    guiSetVisible(md.win,false)
end

addEventHandler("onClientGUIClick", md.btn_kupno, domOpcje, false)
addEventHandler("onClientColShapeLeave", resourceRoot, function(el,md)
    if el~=localPlayer then return end
    schowajOknaDomu()
    a_dom=nil
end)

addEventHandler("onClientPlayerSpawn", localPlayer, schowajOknaDomu)
addEvent("doHideHouseWindows", true)
addEventHandler("doHideHouseWindows", resourceRoot, schowajOknaDomu)

addEventHandler("onClientGUIClick", bd.btnZamknij, schowajOknaDomu, false)

addEventHandler("onClientGUIClick", bd.btnKup, function()
    local ilosc_dni=tonumber(guiGetText(bd.editDni))
    if not ilosc_dni or ilosc_dni<1 then
        guiSetText(bd.lblAdres,"Podano nieprawidłową wartość.")
        return
    end
    if (a_dom.paidTo_dni or 0)+ilosc_dni>14 then
        guiSetText(bd.lblAdres,"Dom może być opłacony na maksymalnie 14 dni.")
        return
    end
    
        local dbid=getElementData(localPlayer,"auth:uid")
    if not dbid then
        guiSetText(bd.lblAdres,"Tylko zarejestrowani gracze mogą kupować domy.")
        return
    end
    local gotowka=getPlayerMoney(localPlayer)
    local koszt=ilosc_dni*a_dom.koszt
    if koszt>gotowka then
        guiSetText(bd.lblAdres,string.format("Koszt wynajęcia domu na %d dni\nwynosi %d$. Nie masz aż tyle!", ilosc_dni,koszt))
        return
    end

    guiSetEnabled(bd.editDni, false)
    guiSetVisible(bd.btnKup, false)
    guiSetVisible(bd.btnPotwierdz,true)
    --guiSetText(bd.lblAdres,string.format("Koszt wynajęcia domu na %d dni wynosi %.02f$.\nKliknij potwierdzam jeśli jesteś pewny/a zakupu.", ilosc_dni,koszt))
    
end, false)


addEventHandler("onClientGUIClick", bd.btnPotwierdz, function()
    local ilosc_dni=tonumber(guiGetText(bd.editDni))

    if not ilosc_dni or ilosc_dni<1 then return end
        local dbid=getElementData(localPlayer,"auth:uid")
    if not dbid then return end
    local gotowka=getPlayerMoney(localPlayer)
    local koszt=ilosc_dni*a_dom.koszt
    if koszt>gotowka then return end
    
    guiSetVisible(bd.btnPotwierdz, false)
    triggerServerEvent("onHousePaymentRequest", resourceRoot, a_dom.id, ilosc_dni)
end,false)

addEventHandler("onClientGUIClick", bd.btnDrzwi, function()
    if not a_dom then return end
        local dbid=getElementData(localPlayer,"auth:uid")
    if not dbid then return end
    if dbid~=a_dom.ownerid then return end
        if guiGetText(bd.btnDrzwi) == "Otwórz dom" then
            triggerServerEvent("onHouseChangeOptions", resourceRoot, a_dom.id, "zamkniety", false)
        else
            triggerServerEvent("onHouseChangeOptions", resourceRoot, a_dom.id, "zamkniety", true)
        end
end,false)

addEventHandler("onClientGUIClick", bd.btnGangHouse, function()
    if not a_dom then return end
    local dbid = getElementData(localPlayer, "auth:uid")
    if not dbid then return end
    if dbid~=a_dom.ownerid then return end
        if guiGetText(bd.btnGangHouse) == "Udostępnij dom gangowi" then
            triggerServerEvent("onHouseChangeOptions", resourceRoot, a_dom.id, "gang", true)
        else
            triggerServerEvent("onHouseChangeOptions", resourceRoot, a_dom.id, "gang", false)
        end
end, false)