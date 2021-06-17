local wo = {}
wo.win = guiCreateWindow(0.7531,0.3479,0.2109,0.3792,"Garaż gracza",true)
--wo.lbl = guiCreateLabel(0.037,0.1209,0.9185,0.1352,"Wskaż pojazd, który został zabrany.",true,wo.win)
--wo.cmb = guiCreateComboBox(0.037,0.3,0.9185,0.6352,"Marka pojazdu",true,wo.win)
wo.btn_open = guiCreateButton(0.037,0.3,0.9185,0.3,"Tele",true,wo.win)
wo.btn = guiCreateButton(0.037,0.6,0.9185,0.3,"Zamknij",true,wo.win)

guiSetVisible(wo.win, false)

local function schowajOknaGarazy()
    if guiGetVisible(wo.win) then
        guiSetVisible(wo.win,false)
        showCursor(false)
        toggleControl('fire',true)
    end
end

local function getPlayerDBID(plr)
    local c=getElementData(plr,"character")
    if not c then return nil end
    return tonumber(c.id)
end
local function pokazOknoGarazy(garaz)
    guiSetVisible(wo.win,true)
    showCursor(true,false)
    toggleControl('fire',false)
    local dbid=getPlayerDBID(localPlayer)
    if garaz.ownerid then
        if dbid and garaz.ownerid==dbid then
            guiSetEnabled(wo.btn_open,true)
            guiSetText(wo.btn_open,"Otwórz garaż")

        else
            guiSetEnabled(wo.btn_open,false)
            guiSetText(wo.btn_open,"Otwórz garaż")
        end
    else
        guiSetText(wo.btn,"Zamknij")
    end
end

addEventHandler('onClientMarkerHit',resourceRoot,function(el,md)
    if el~=localPlayer or not md then return end
    local garaz = getElementData(source,"garaz")
    if not garaz then return end
    a_garaz = garaz
    pokazOknoGarazy(garaz)
end)

addEventHandler("onClientGUIClick", wo.btn, schowajOknaGarazy, false)
addEventHandler("onClientGUIClick", wo.btn_open, function()
    if not a_garaz then return end
    local dbid=getPlayerDBID(localPlayer)
    if not dbid then return end
    guiSetEnabled(wo.btn_open,false)
    triggerServerEvent('onGarazOpenRequest',resourceRoot,localPlayer,a_garaz.id)
end, false)
