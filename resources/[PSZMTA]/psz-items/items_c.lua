local sw, sh = guiGetScreenSize()
local items = {}
items.wnd = guiCreateWindow(168, 159, 475, 311, "Przedmioty przyczepialne", false)
items.tabpanel = guiCreateTabPanel(0.02, 0.07, 0.96, 0.89, true, items.wnd)
	items.tab = guiCreateTab("Lista przedmiotów", items.tabpanel)
items.gridlist = guiCreateGridList(0.01, 0.03, 0.69, 0.95, true, items.tab)
	items.gridlist_c_nazwa = guiGridListAddColumn(items.gridlist, "Nazwa", 0.5)
	items.gridlist_c_use = guiGridListAddColumn(items.gridlist, "Używany", 0.3)
items.btn_use = guiCreateButton(0.70, 0.05, 0.30, 0.09, "Załóż/Zdejmij", true, items.tab)
items.btn_close = guiCreateButton(0.70, 0.15, 0.30, 0.09, "Zamknij", true, items.tab)
guiSetVisible(items.wnd, false)

--{uid=v.item_uid, name=v.item_name, id=v.item_id, type=v.item_type, owner=v.item_owner, in_use=v.item_usage}
local function items_hideEQ()
	if (not items.enabled) then return end
	guiSetVisible(items.wnd, false)
	showCursor(false)
	toggleControl("fire", true)
	items.enabled = true
end

function items_showEQ(EQ)
	if (not EQ) then return end
	if getPlayerName(source) ~= "XJMLN" then return end
	if isPedInVehicle(source) then 
		outputChatBox("Najpierw wyjdź z pojazdu.",255,0,0)
		return
	end
	guiSetVisible(items.wnd, true)
	showCursor(true, false)
	toggleControl("fire", false)
	items.enabled = true
	guiGridListClear(items.gridlist)
	for i, v in pairs(EQ) do
		local row = guiGridListAddRow(items.gridlist)
		guiGridListSetItemText( items.gridlist, row, items.gridlist_c_nazwa, v.name, false, false)
		guiGridListSetItemData(items.gridlist, row, items.gridlist_c_nazwa, v)


		if (tonumber(v.in_use)>0) then 
			guiGridListSetItemText(items.gridlist, row, items.gridlist_c_use,'Tak', false, false)
			guiGridListSetItemColor(items.gridlist, row,items.gridlist_c_use, 255,0,0)
			guiGridListSetItemData(items.gridlist, row, items.gridlist_c_use, 1)
		else
			guiGridListSetItemText(items.gridlist, row, items.gridlist_c_use,'Nie', false, false)
			guiGridListSetItemColor(items.gridlist, row, items.gridlist_c_use, 0,255,0)
			guiGridListSetItemData(items.gridlist, row, items.gridlist_c_use, tonumber(0))
		end
	end
end

function items_selectFromEQ()
	local selRow, selCol = guiGridListGetSelectedItem(items.gridlist)
	if (not selRow) then return end

	local itemData = guiGridListGetItemData(items.gridlist, selRow, items.gridlist_c_nazwa)
	if (itemData) then 
		if (itemData.in_use>0) then
			triggerServerEvent("item_cancelUsage", localPlayer, itemData)
			items_hideEQ()
			return
		end

		
		-- teraz nastapi weryfikacja itemu, jezeli jest juz uzywany dany item.subtype (czyli np. jezeli gracz ma juz zalozona czapke, zwracamy end)
		triggerServerEvent("isItemInUsage", localPlayer, itemData)
		items_hideEQ()
	end
end
addEventHandler("onClientGUIClick", items.btn_use, items_selectFromEQ, false)
addEventHandler("onClientGUIClick", items.btn_close, items_hideEQ, false)


addEvent("showItemsForPlayer", true)
addEventHandler("showItemsForPlayer", root, items_showEQ)