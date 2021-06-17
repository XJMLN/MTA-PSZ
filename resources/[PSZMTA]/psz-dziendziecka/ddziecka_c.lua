--[[
skiny={218,220,221}

--local marker = createMarker(-2893.87,471.97,3.91,"cylinder",2,255,255,255,120)
--local text = createElement("text")
--	setElementPosition(text,-2893.87,471.97,4.93+3)
	--setElementData(text,"scale",2)
	--setElementData(text,"text","Odbierz prezent z okazji urodzin serwera")

ev_wnd = guiCreateWindow(0.25, 0.37, 0.51, 0.38,"Odbiór nagrody - urodziny serwera", true)
ev_tabp = guiCreateTabPanel(0.02, 0.08, 0.95, 0.88, true, ev_wnd)
	--ev_tabVIP = guiCreateTab("Konto VIP", ev_tabp)
		--ev_Vlbl = guiCreateLabel(0.02, 0.00, 0.95, 0.18, "Przedłużenie konta VIP o 7 dni", true, ev_tabVIP)
		--	guiSetFont(ev_Vlbl, "default-bold-small")
		--	guiLabelSetHorizontalAlign(ev_Vlbl,"center", false)
		--	guiLabelSetVerticalAlign(ev_Vlbl, "center")
		--ev_Vbtn = guiCreateButton(0.26, 0.58, 0.50, 0.37, "Odbierz nagrodę!", true, ev_tabVIP)
		--ev_Vlbl2 = guiCreateLabel(0.02, 0.18, 0.95, 0.34, "Twoje konto zostanie ulepszone do konta VIP na okres 7 dni. Jeśli posiadasz aktualnie konto VIP - zostanie ono przedłużone. Dodatkowo otrzymujesz 20 Punktów Zabawy, wkrótce będziesz mógł je wykorzystać!", true, ev_tabVIP)
		--	guiLabelSetHorizontalAlign(ev_Vlbl2, "left", true)
	ev_tabCash = guiCreateTab("Gotówka", ev_tabp)
		ev_Clbl = guiCreateLabel(0.02, 0.00, 0.95, 0.18, "Gotówka - $1000", true, ev_tabCash)
			guiSetFont(ev_Clbl, "default-bold-small")
			guiLabelSetHorizontalAlign(ev_Clbl,"center", false)
			guiLabelSetVerticalAlign(ev_Clbl, "center")
		ev_Cbtn = guiCreateButton(0.26, 0.58, 0.50, 0.37, "Odbierz nagrodę!", true, ev_tabCash)
		ev_Clbl2 = guiCreateLabel(0.02, 0.18, 0.95, 0.34, "Otrzymujesz $1000 do portfela. Dodatkowo otrzymujesz 20 Punktów Zabawy, wkrótce będziesz mógł je wykorzystać!", true, ev_tabCash)    	
	ev_tabRC = guiCreateTab("Pojazd RC Baron", ev_tabp)
	ev_Rlbl = guiCreateLabel(0.02, 0.00, 0.95, 0.18, "Pojazd RC Baron na 1 dzień", true, ev_tabRC)
		guiSetFont(ev_Rlbl, "default-bold-small")
		guiLabelSetHorizontalAlign(ev_Rlbl,"center", false)
		guiLabelSetVerticalAlign(ev_Rlbl, "center")
	ev_Rbtn = guiCreateButton(0.26, 0.58, 0.50, 0.37, "Odbierz nagrodę!", true, ev_tabRC)
    ev_Rlbl2 = guiCreateLabel(0.02, 0.18, 0.95, 0.34, "W tym miejscu będziesz mógł do godziny 24:00, odebrać pojazd RC Baron - normalnie ten pojazd jest tutaj zablokowany. Dodatkowo otrzymujesz 20 Punktów Zabawy, wkrótce będziesz mógł je wykorzystać!", true, ev_tabRC)     
        guiLabelSetHorizontalAlign(ev_Clbl2, "left", true)
        guiLabelSetHorizontalAlign(ev_Rlbl2, "left", true)

guiSetVisible(ev_wnd,false)

addEventHandler("onClientMarkerHit",marker,function(el,md)
	if (not md) then return end
	if (el~=localPlayer) then return end
	if (isPedInVehicle(localPlayer)) then return end
	local uid = getElementData(el,"auth:uid") or 0 
	if (not uid or uid==0) then return end
	triggerServerEvent("onPlayerHitMarkerEvent",localPlayer,uid)
end)

function startup(data)
	if not data then 
		showCursor(false)
		guiSetVisible(ev_wnd,false)
	else
	showCursor(true)
	guiSetVisible(ev_wnd,true)
end
end
addEvent("onServerReturnData",true)
addEventHandler("onServerReturnData",root,startup)

--addEventHandler("onClientGUIClick",ev_Vbtn,function() triggerServerEvent("onPlayerTakeThing",localPlayer,1) showCursor(false) guiSetVisible(ev_wnd,false) end,false)
addEventHandler("onClientGUIClick",ev_Rbtn,function() triggerServerEvent("onPlayerTakeThing",localPlayer,3) showCursor(false) guiSetVisible(ev_wnd,false) end,false)
addEventHandler("onClientGUIClick",ev_Cbtn,function() triggerServerEvent("onPlayerTakeThing",localPlayer,2) showCursor(false) guiSetVisible(ev_wnd,false) end,false)

addEventHandler("onClientResourceStart",root,function()
	local texture = dxCreateTexture("hl_moon.png")
	local shader = dxCreateShader("shader.fx")
	dxSetShaderValue(shader, "Tex0", texture)
	engineApplyShaderToWorldTexture(shader, "coronamoon")
end)

local function replaceSkin(i)
    txd = engineLoadTXD(i..".txd")
    engineImportTXD(txd,i)
    dff = engineLoadDFF(i..".dff",i)
    engineReplaceModel(dff,i)
end

for i,v in ipairs(skiny) do
    replaceSkin(v)
end
]]--
    txd = engineLoadTXD("kart.txd")
    engineImportTXD(txd,571)
    dff = engineLoadDFF("kart.dff",571)
    engineReplaceModel(dff,571)
