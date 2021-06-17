--[[

Gangi: Panel gangowy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gangi
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local function getGID()
	local c=getElementData(localPlayer,"character")
	if (not c) then return nil end
	return c.gg_nazwa,c.gg_tag,c.gg_rank_name,c.gg_rank_id,c.gg_id  -- gg_nazwa, gg_tag, gg_rank_name, gg_rank_id, gg_id
end
local sw, sh = guiGetScreenSize() --800x600
local lblkres = string.format("____________________________________________________________________________________________________________________________________________")
local lblw2 = string.format("UWAGA! Ta operacja jest nie odwracalna, pieniądze wpłacone do sejfu nie mogą być już z niego wypłacone. Pamiętaj że lider nie może nakazywać Ci wpłacać pieniędzy do sejfu, robisz to z własnej woli.")
local lblw1 = string.format("UWAGA! Ta operacja jest nie odwracalna, pieniądze zostaną pobrane z sejfu gangu. Każde ulepszenie polepsza Waszą pozycję w rankingu gangów. Aby ulepszyć gang, wybierz pozycję z tabelki i wciśnij przycisk - następnie odczekaj chwilę i ulepszenie zostanie wdrożone. Jeżeli nie posiadasz bazy gangu, lepiej będzie nie ulepszać gangu.")
local edytowana_postac=nil
local p_g={} 
p_g.wnd = guiCreateWindow(sw*0/800, sh*58/600, sw*800/800, sh*469/600,"",false)
	guiSetVisible(p_g.wnd,false)
p_g.tabpanel = guiCreateTabPanel(sw*9/800, sh*23/600, sw*782/800, sh*426/600,false,p_g.wnd)

p_g.tabCzl = guiCreateTab("Członkowie",p_g.tabpanel)
p_g.tabZarzad = guiCreateTab("Zarządzanie gangiem",p_g.tabpanel)
p_g.tabStats = guiCreateTab("Statystyki gangu",p_g.tabpanel)

-- Członkowie
p_g.gridlist = guiCreateGridList(sw*7/800, sh*8/600, sw*765/800, sh*313/600,false,p_g.tabCzl)
	p_g.gridcolumn_nick = guiGridListAddColumn(p_g.gridlist,"Nick",0.2)
	p_g.gridcolumn_ranga = guiGridListAddColumn(p_g.gridlist,"Ranga",0.2)
	p_g.gridcolumn_lastplay = guiGridListAddColumn(p_g.gridlist,"Ostatnio w grze",0.3)
	p_g.gridcolumn_money = guiGridListAddColumn(p_g.gridlist,"Kwota wpłacona do sejfu",0.2) -- Łącznie 0.9
p_g.btn_dodaj = guiCreateButton(sw*9/800, sh*331/600, sw*232/800, sh*60/600,"Dodaj gracza do gangu",false,p_g.tabCzl)
p_g.btn_wyrzuc = guiCreateButton(sw*290/800, sh*331/600, sw*232/800, sh*60/600,"Wyrzuć gracza z gangu",false,p_g.tabCzl)
p_g.btn_edytuj = guiCreateButton(sw*569/800, sh*332/600, sw*203/800, sh*60/600,"Edytuj gracza",false,p_g.tabCzl)
guiGridListSetSelectionMode(p_g.gridlist,1)
-- Zarządzanie gangiem
p_g.lblInfoMoney = guiCreateLabel(sw*184/800, sh*1/600, sw*414/800, sh*40/600,"Wpłata pieniędzy na rzecz gangu",false,p_g.tabZarzad)
	guiSetFont(p_g.lblInfoMoney,"clear-normal");
	guiLabelSetHorizontalAlign(p_g.lblInfoMoney,"center",false)
	guiLabelSetVerticalAlign(p_g.lblInfoMoney,"center")
p_g.lblLine1 = guiCreateLabel(sw*0/800, sh*41/600, sw*782/800, sh*20/600,lblkres,false,p_g.tabZarzad)
p_g.editMoney = guiCreateEdit(sw*64/800, sh*86/600, sw*235/800, sh*25/600,"",false,p_g.tabZarzad)
p_g.btnWplac = guiCreateButton(sw*309/800, sh*80/600, sw*132/800, sh*31/600,"Wpłać",false,p_g.tabZarzad)
p_g.lblWplac = guiCreateLabel(sw*10/800, sh*92/600, sw*44/800, sh*13/600,"Kwota:",false,p_g.tabZarzad)
p_g.lblWplac2 = guiCreateLabel(sw*482/800, sh*61/600, sw*290/800, sh*71/600,lblw2,false,p_g.tabZarzad)
	guiLabelSetColor(p_g.lblWplac2,255,0,0)
	guiLabelSetHorizontalAlign(p_g.lblWplac2,"left",true)
p_g.lblInfoUpgrd = guiCreateLabel(sw*192/800, sh*160/600, sw*414/800, sh*40/600,"Dostępne ulepszenia gangu",false,p_g.tabZarzad)
	guiSetFont(p_g.lblInfoUpgrd,"clear-normal");
	guiLabelSetHorizontalAlign(p_g.lblInfoUpgrd,"center",false)
	guiLabelSetVerticalAlign(p_g.lblInfoUpgrd,"center")
p_g.lblLine2 = guiCreateLabel(sw*0/800, sh*200/600, sw*800/800, sh*18/600,lblkres,false,p_g.tabZarzad)
	
p_g.grid = guiCreateGridList(sw*10/800, sh*222/600, sw*431/800, sh*170/600,false,p_g.tabZarzad)
	p_g.gridcolumn_name = guiGridListAddColumn(p_g.grid,"Nazwa ulepszenia",0.5)
	p_g.gridcolumn_price = guiGridListAddColumn(p_g.grid,"Koszt ulepszenia",0.3)
p_g.btn_ulepsz = guiCreateButton(sw*451/800, sh*220/600, sw*321/800, sh*58/600,"Zatwierdź",false,p_g.tabZarzad)
p_g.lblUp = guiCreateLabel(sw*447/800, sh*288/600, sw*325/800, sh*103/600,lblw1,false,p_g.tabZarzad)
	guiLabelSetColor(p_g.lblUp,255,0,0)
	guiLabelSetHorizontalAlign(p_g.lblUp,"left",true)
-- Statystyki gangu
p_g.lblInfoStats = guiCreateLabel(sw*141/800, sh*10/600, sw*501/800, sh*42/600,"Statystyki gangu",false,p_g.tabStats)
	guiSetFont(p_g.lblInfoStats,"clear-normal")
p_g.lblLine3 = guiCreateLabel(sw*4/800, sh*52/600, sw*778/800, sh*15/600,lblkres,false,p_g.tabStats)
p_g.lblCzlonkowie = guiCreateLabel(sw*22/800, sh*77/600, sw*182/800, sh*15/600,"Ilość członków:",false,p_g.tabStats)
p_g.lblMoney= guiCreateLabel(sw*22/800, sh*102/600, sw*198/800, sh*15/600,"Pieniądze zgromadzone w sejfie:",false,p_g.tabStats)
p_g.lblLogo = guiCreateLabel(sw*22/800, sh*127/600, sw*248/800, sh*15/600,"Zarejestrowany na forum (posiada logo):",false,p_g.tabStats)
p_g.lblSkin = guiCreateLabel(sw*22/800, sh*152/600, sw*260/800, sh*15/600,"Może ustawić skin gangowy:",false,p_g.tabStats)
p_g.lblBase = guiCreateLabel(sw*22/800, sh*177/600, sw*168/800, sh*15/600,"Posiada własną bazę:",false,p_g.tabStats)
p_g.lblUpgrades = guiCreateLabel(sw*22/800, sh*202/600, sw*253/800, sh*17/600,"Poziom ulepszenia gangu:",false,p_g.tabStats)
p_g.lblRank = guiCreateLabel(sw*22/800, sh*229/600, sw*261/800, sh*15/600,"Pozycja w rankingu:",false,p_g.tabStats)  
p_g.init=function()
	local gname,gtag,grank,grankid,gid=getGID()
	if (not gid) then return end

	triggerServerEvent("onPlayerRequestGangData",localPlayer,gid)
	guiSetText(p_g.wnd,gname)

	if (tonumber(grankid)>2) then
		guiSetEnabled(p_g.btn_dodaj,true)
		guiSetEnabled(p_g.btn_edytuj,false)
		guiSetEnabled(p_g.btn_wyrzuc,false)
	else
		guiSetEnabled(p_g.btn_dodaj,false)
		guiSetEnalbed(p_g.btn_edytuj,false)
		guiSetEnabled(p_g.btn_wyrzuc,false)
	end
	edytowana_postac=nil
end

--p_g.gridcolumn_nick | p_g.gridcolumn_ranga |p_g.gridcolumn_lastplay | p_g.gridcolumn_money |
p_g.fill=function(dane)
	guiGridListClear(p_g.gridlist)
	if (not dane) then return end
	for i,v in ipairs(dane) do
		local row = guiGridListAddRow (p_g.gridlist)
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_nick, v.nick,false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_nick, tonumber(v.player_id))
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_ranga, v.ranga,false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_ranga, tonumber(v.rank_id))
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_lastplay, v.lastduty or "Nie określono",false,false)
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_money,v.wplacone_sejf.."$",false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_money,tonumber(v.wplacone_sejf))
	end
end

p_g.gridclick=function()
	local gname,gtag,grank,grankid,gid=getGID()
	if (not gid) then return end
	if (not guiGetEnabled(p_g.btn_dodaj)) then return end
	selectedRow = guiGridListGetSelectedItem(p_g.gridlist)
	if (selectedRow<0) then
		guiSetEnabled(p_g.btn_edytuj,false)
		guiSetEnabled(p_g.btn_wyrzuc,false)
	else
		local sfrank=guiGridListGetItemData(p_g.gridlist,selectedRow,p_g.gridcolumn_ranga)
		if (tonumber(grankid)>sfrank and tonumber(grankid)>=3) then
			guiSetEnabled(p_g.btn_wyrzuc,true)
		else
			guiSetEnabled(p_g.btn_wyrzuc,false)
		if (tonumber(grankid)>=3) then
			guiSetEnabled(p_g.btn_edytuj,true)
		else
			guiSetEnabled(p_g.btn_edytuj,false)
		end
	end
end
end

p_g.zwolnij=function()
	local __,__,__,__,gid=getGID()
	if (not gid) then return end

	selectedRow = guiGridListGetSelectedItem(p_g.gridlist)
	local pid = guiGridListGetItemData(p_g.gridlist,selectedRow,p_g.gridcolumn_nick)
	triggerServerEvent("onGangWyrzucRequest",localPlayer,gid,pid)
end

-- Dodawanie graczy -----------------------------
p_a={}
p_a.win = guiCreateWindow(sw*185/800, sh*151/600, sw*449/800, sh*306/600, "", false)
	guiWindowSetSizable(p_a.win, false)
	guiSetVisible(p_a.win,false)
p_a.edit_nick = guiCreateEdit(sw*12/800, sh*105/600, sw*427/800, sh*28/600, "", false, p_a.win)
p_a.lbl_nick = guiCreateLabel(sw*13/800, sh*71/600, sw*308/800, sh*15/600, "Wpisz nick gracza:", false, p_a.win)
p_a.lbl_blad = guiCreateLabel(sw*13/800, sh*150/600, 426/800, sh*55/600, "", false, p_a.win) 
p_a.btn_dodaj = guiCreateButton(sw*17/800, sh*224/600, sw*184/800, sh*72/600, "Dodaj gracza", false, p_a.win)
p_a.btn_anuluj = guiCreateButton(sw*286/800, sh*224/600, sw*153/800, sh*72/600, "Anuluj", false, p_a.win) 


p_a.pokaz=function()
	guiSetInputMode("no_binds_when_editing")
	guiSetVisible(p_a.win,true)
	guiSetText(p_a.lbl_blad,"")
	guiSetText(p_a.edit_nick,"")
	guiBringToFront(p_a.win)
end

p_a.schowaj=function()
	guiSetVisible(p_a.win,false)
end

p_a.dodaj=function()
	local  __,__,__,__,gid= getGID()
	if (not gid) then return end

	local nick = guiGetText(p_a.edit_nick)
	triggerServerEvent("onGangInviteRequest",localPlayer,gid,nick)
end

p_a.dodaj_end=function(wynik,komunikat)
	if (not wynik) then
		guiSetText(p_a.lbl_blad,komunikat)
		return
	else
		p_a.schowaj()
		p_g.init()
	end
end

--Tutaj kod od okna edycji gracza
p_e = {}

p_e.pokaz=function()
	local coid=getGID()
	if (not coid) then return end

	selectedRow = guiGridListGetSelectedItem(p_g.gridlist)
	local pid=guiGridListGetItemData(p_g.gridlist,selectedRow,p_g.gridcolumn_nick)

	guiSetInputMode("no_binds_when_editing")
	guiSetVisible(p_e.win,true)
	guiBringToFront(p_e.win)
	guiCombBoxClear(p_e.cmb_ranga)
	guiComboBoxClear(p_e.cmb_skin)
	guiComboBoxAddItem(p_e.cmb_skin, "brak")

	triggerServerEvent("onGangCharacterDetailsRequest",localPlayer,coid,pid)
end

p_e.schowaj=function()
	guiSetVisible(p_e.win,false)
end

p_e.edycja_potwierdz=function(dane)
	if (not dane or not dane.postac or not dane.postac.id) then
		p_e.schowaj()
	end

	edytowana_postac=dane.postac.id
	guiSetText(p_e.lbl_nick, dane.postac.nick)
	guiComboBoxClear(p_e.cmb_ranga)
	guiComboBoxClear(p_e.cmb_skin)

	for i,v in ipairs(dane.rangi) do
		local i2=guiComboBoxAddItem(p_e.cmb_ranga, tostring(v.rank_id)..". "..v.name) -- sprawdzic czy działa przy nowej implementacji s-side
			if (v.rank_id == dane.postac.rank) then
				guiComboBoxSetSelected(p_e.cmb_ranga,i2)
			end
		end
	local skin = guiComboBoxAddItem(p_e.cmb_skin,"brak")
	guiComboBoxSetSelected(p_e.cmb_skin,skin)
	if (dane.skiny and #dane.skiny>0) then
		for i,v in ipairs(dane.skiny) do
			local skiny = guiComboBoxAddItem(p_e.cmb_skin, tostring(v.skin))
			if (v.skin == dane.postac.skin) then
				guiComboBoxSetSelected(p_e.cmb_skin, skiny)
			end
		end
	end
end

p_e.zapisz=function()
	if (not edytowana_postac) then return end
	local ranga = guiComboBoxGetItemText(p_e.cmb_ranga, guiComboBoxGetSelected(p_e.cmb_ranga))
	ranga = tonumber(string.sub(ranga,1,1))

	local skin = tonumber(guiComboBoxGetItemText(p_e.cmb_skin, guiComboBoxGetSelected(p_e.cmb_skin)))
	triggerServerEvent("onGangEdycjaPostaci",localPlayer, edytowana_postac, ranga, skin)
end

addEvent("doFillGangData", true)
addEventHandler("doFillGangData", resourceRoot, p_g.fill)
addEvent("onGangWyrzucComplete", true)
addEventHandler("onGangWyrzucComplete", resourceRoot, p_g.init)
-- glowne okno
addEventHandler("onClientGUIClick", p_g.btn_dodaj, p_a.pokaz, false)   
addEventHandler("onClientGUIClick", p_g.btn_wyrzuc, p_g.zwolnij, false)
addEventHandler("onClientGUIClick", p_g.gridlist, p_g.gridclick, false)
-- dodawanie
addEvent("onGangInviteReply", true)
addEventHandler("onGangInviteReply", resourceRoot, p_a.dodaj_end)
addEventHandler("onClientGUIClick", p_a.btn_dodaj, p_a.dodaj, false)
addEventHandler("onClientGUIClick", p_a.btn_anuluj, p_a.schowaj, false)
bindKey("f5","down",function()
	local gid,gname,grank,grankid=getGID()
	if (not gid) then
	  guiSetVisible(p_g.wnd,false)
	  showCursor(false)
	  return
	end
	if isGOWindowOpen(p_g.wnd) then
		showCursor(false)
		guiSetVisible(p_g.wnd, false)
	else
		showCursor(true,false)
		guiSetVisible(p_g.wnd,true)
		p_g.init()
	end
end)
