--[[
Tuning - zapis zmodyfikowanego pojazdu

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local t_z = {}

t_z.wnd = guiCreateWindow(168, 159, 475, 311, "Zapisane pojazdy", false)
t_z.tabpanel = guiCreateTabPanel(0.02, 0.07, 0.96, 0.89, true, t_z.wnd)
	t_z.tab = guiCreateTab("Wczytywanie pojazdów", t_z.tabpanel)
	t_z.tab2 = guiCreateTab("Zapis pojazdów",t_z.tabpanel)
t_z.tab2_lbl = guiCreateLabel(0.20, 0.03, 0.69, 0.95, "test",true, t_z.tab2)
t_z.tab2_btn_save = guiCreateButton( 0.10, 0.30, 0.30, 0.25, "Zapisz pojazd", true, t_z.tab2)
t_z.tab2_btn_cancel = guiCreateButton(0.60, 0.30, 0.30, 0.25, "Anuluj", true, t_z.tab2)
t_z.gridlist = guiCreateGridList(0.01, 0.03, 0.69, 0.95, true, t_z.tab)
	t_z.gridlist_c_nazwa = guiGridListAddColumn(t_z.gridlist, "Nazwa", 0.8)
t_z.btn_use = guiCreateButton(0.70, 0.05, 0.30, 0.09, "Stworz pojazd", true, t_z.tab)
t_z.btn_delete = guiCreateButton(0.70, 0.15, 0.30, 0.09, "Usuń zapis", true, t_z.tab)
t_z.btn_close = guiCreateButton(0.70, 0.25, 0.30, 0.09, "Zamknij", true, t_z.tab)

guiSetVisible(t_z.wnd, false)

local function hideWindow()
	guiSetVisible(t_z.wnd, false)
	showCursor(false)
	toggleControl("fire", true)
end

function gridClick()
	if (not guiGetEnabled(t_z.wnd)) then return end
	selectedRow = guiGridListGetSelectedItem(t_z.gridlist)
	if (selectedRow<0) then 
		guiSetEnabled(t_z.btn_use, false)
		guiSetEnabled(t_z.btn_delete, false)
	else
		guiSetEnabled(t_z.btn_use, true)
		guiSetEnabled(t_z.btn_delete, true)
	end
end
-- Wczytywanie/usuwanie pojazdu

local function fillUserData(wynik)
	if (not wynik) then 
		outputChatBox("Nie posiadasz zapisanych pojazdów",255,0,0)
		return
	end
	guiGridListClear(t_z.gridlist)
	
	for i,v in ipairs(wynik) do
		local row = guiGridListAddRow(t_z.gridlist)
		guiGridListSetItemText(t_z.gridlist, row, t_z.gridlist_c_nazwa, getVehicleNameFromModel(v.model), false, false)
		guiGridListSetItemData(t_z.gridlist, row, t_z.gridlist_c_nazwa, tonumber(v.id))
	end

	guiSetVisible(t_z.wnd, true)
	guiSetSelectedTab(t_z.tabpanel, t_z.tab)

	guiSetEnabled(t_z.tab, true)
	guiSetEnabled(t_z.tab2, false)
	guiSetEnabled(t_z.btn_use, false)
	guiSetEnabled(t_z.btn_delete, false)

	showCursor(true, false)
	toggleControl("fire", false)
end

function tsave_spawnVeh()

	selectedRow = guiGridListGetSelectedItem(t_z.gridlist)
	local vid = guiGridListGetItemData(t_z.gridlist, selectedRow, t_z.gridlist_c_nazwa)
	triggerServerEvent("tsave_verifyVehicle", localPlayer, vid)
	hideWindow()
end

function tsave_deleteVeh()
	selectedRow = guiGridListGetSelectedItem(t_z.gridlist)
	local vid = guiGridListGetItemData(t_z.gridlist, selectedRow, t_z.gridlist_c_nazwa)
	triggerServerEvent("tsave_deletePlayerVehicle", localPlayer, vid)
	hideWindow() 
end

-- zapis pojazdu
function tsave_saveVeh()
	local vehicle = getElementData(source, "vehicle")
	if (not vehicle) then 
		hideWindow()
		outputChatBox("Wystąpił błąd.",255,0,0)
		return
	end

	triggerServerEvent("tsave_sendSavedData", localPlayer, vehicle)
	hideWindow()
end



addEventHandler("onClientMarkerHit",resourceRoot, function(el, md) 
	if not md or el~=localPlayer then return end

	local cs = getElementData(source, "cs_load")
	if (not cs) then return end

	local vehs = getElementsWithinColShape(cs, "vehicle")
	if #vehs>0 then 
		outputChatBox("W garażu nie ma miejsca na wczytanie pojazdu.")
		return
	end

	local uid = getElementData(el, "auth:uid") or 0
	if (uid and tonumber(uid)<1) then return end

	triggerServerEvent("tsave_getUserData", localPlayer, uid)
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(el, md)
	if not md or el~=localPlayer then return end

	local cs = getElementData(source, "cs_save")
	if (not cs) then return end

	local vehs = getElementsWithinColShape(cs, "vehicle")
	if #vehs>1 then 
		outputChatBox("W garażu znajduje się więcej niż jeden pojazd.",255,0,0)
		return
	end

	if #vehs<1 then 
		outputChatBox("Najpierw wjedź pojazdem do garażu.", 255,0,0)
		return
	end

	local pojazd = nil
	for i,v in pairs(vehs) do
		if #vehs == 1 then 
			pojazd = v
		end
	end

	guiSetVisible(t_z.wnd, true)

	guiSetEnabled(t_z.tab2, true)
	guiSetSelectedTab(t_z.tabpanel, t_z.tab2)
	guiSetEnabled(t_z.tab, false)

	toggleControl("fire", false)
	showCursor(true)
	
	guiSetText(t_z.tab2_lbl, string.format("Czy chcesz zapisać pojazd %s? Koszt zapisu: 2500$",getVehicleName(pojazd)))
	setElementData(t_z.tab2_btn_save, "vehicle", pojazd)
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(el, md)
	if (el~=localPlayer) then return end

	hideWindow()
end)


addEventHandler("onClientGUIClick", t_z.tab2_btn_save, tsave_saveVeh, false)
addEventHandler("onClientGUIClick", t_z.btn_close, hideWindow, false)
addEventHandler("onClientGUIClick", t_z.btn_use, tsave_spawnVeh, false)
addEventHandler("onClientGUIClick", t_z.btn_delete, tsave_deleteVeh, false)
addEventHandler("onClientGUIClick", t_z.gridlist, gridClick, false)
addEventHandler("onClientGUIClick", t_z.tab2_btn_cancel, hideWindow, false)

addEvent("tsave_sendUserData", true)
addEventHandler("tsave_sendUserData", localPlayer, fillUserData)