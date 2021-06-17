--[[

psz-sklepy: Kupno obiektow przyczepialnych, zapis do EQ gracza

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-sklepy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local sw, sh = guiGetScreenSize()
local sklep = {}

sklep.wnd = guiCreateWindow(sw*168/800, sh*120/600, sw*520/sw, sh*414/sh, "Sklep", false)
sklep.gridlist = guiCreateGridList(0.02, 0.07, 0.55, 0.90, true, sklep.wnd)
	sklep.gridlist_nazwa = guiGridListAddColumn(sklep.gridlist, "Nazwa", 0.5)
	sklep.gridlist_cena = guiGridListAddColumn(sklep.gridlist, "Cena", 0.5)
sklep.img = guiCreateStaticImage(0.59, 0.13, 0.39, 0.32, "s_general/i/empty.png", true, sklep.wnd)
sklep.label1 = guiCreateLabel(0.59, 0.06, 0.39, 0.05, "Wygląd przedmiotu: ", true, sklep.wnd)
sklep.btn_buy = guiCreateButton(0.58, 0.65, 0.40, 0.15, "Kup przedmiot", true, sklep.wnd)
sklep.btn_cancel = guiCreateButton(0.58, 0.83, 0.40 ,0.15, "Anuluj", true, sklep.wnd)
guiSetVisible(sklep.wnd, false)

local function shop_fill(npc)
	local shopOffer = getElementData(npc, "shop_offer")
	if (not shopOffer) then 
		outputChatBox("Sprzedawca: Niestety, nie mamy nic w ofercie.",255,0,0)
		return false
	end
	sklep.sprzedawca = npc
	guiGridListClear(sklep.gridlist)

	for i, v in ipairs(shopOffer) do
		local row = guiGridListAddRow(sklep.gridlist)
		guiGridListSetItemText(sklep.gridlist, row, sklep.gridlist_nazwa, v.itemName, false, false)
		guiGridListSetItemData(sklep.gridlist, row, sklep.gridlist_nazwa, v)
		guiGridListSetItemText(sklep.gridlist, row, sklep.gridlist_cena, v.buyprice.."$", false, false)
		if (tonumber(v.buyprice)>getPlayerMoney()) then 
			guiGridListSetItemColor(sklep.gridlist, row, sklep.gridlist_cena, 255,0,0)
		else
			guiGridListSetItemColor(sklep.gridlist, row, sklep.gridlist_cena, 155, 255, 155)
		end
	end
	return true

end

function shop_refreshPhoto()
	local selRow, selCol = guiGridListGetSelectedItem(sklep.gridlist)
	if (not selRow) then return end
	
	local data = guiGridListGetItemData(sklep.gridlist, selRow, sklep.gridlist_nazwa)
	local img
	if (not data) then 
		img = "s_general/i/empty.png"
	else
		img = "s_general/i/eq-"..data.itemID..".png"
	end

	guiStaticImageLoadImage(sklep.img, img)
end

function shop_buyOffer()
	local selRow, selCol = guiGridListGetSelectedItem(sklep.gridlist)
	if (not selRow) then return end

	local data = guiGridListGetItemData(sklep.gridlist, selRow, sklep.gridlist_nazwa)
	
end
addEventHandler("onClientGUIClick", sklep.gridlist, shop_refreshPhoto, false)
addEventHandler("onClientGUIClick", sklep.btn_buy, shop_buyOffer, false)

addEventHandler("onClientColShapeHit", resourceRoot, function(he,md)
	if (he~=localPlayer or not md or getElementInterior(localPlayer)~=getElementInterior(source)) then return end
	local npc = getElementParent(source)
	if (npc and getElementType(npc)=="ped") then
		if shop_fill(npc) then
			guiSetVisible(sklep.wnd,true)
			showCursor(true,false)
			sklep.enabled=true
			toggleControl("fire", false)
		end
	end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(he,md)
    if (he~=localPlayer or not md or getElementInterior(localPlayer)~=getElementInterior(source)) then return end
    local npc=getElementParent(source)
    if (npc and getElementType(npc)=="ped") then
        guiSetVisible(sklep.wnd,false)
        sklep.sprzedawca=nil
        showCursor(false)
        sklep.enabled=false
        toggleControl("fire",true)
    end
end)

addEventHandler("onClientGUIClick", sklep.btn_cancel, function()
	if (not sklep.enabled) then return end
	guiSetVisible(sklep.wnd,false)
	showCursor(false)
	sklep.enabled=false
	sklep.sprzedawca=nil
	toggleControl("fire",true)
end,false)