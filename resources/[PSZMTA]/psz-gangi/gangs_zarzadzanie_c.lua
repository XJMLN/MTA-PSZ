--[[

Gangi: Panel zarzadzania

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
local memoInfoStart = "Tutaj Lider/V-Lider może wpisać notatki, informacje widoczne dla członków gangu"
local memoLbl = "Notatki oraz opis może edytować tylko Lider/V-Lider, każda notatka gangu jest moderowana, używanie przekleństw etc. jest karane."
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
p_g.tabNotes = guiCreateTab("Notatki/Opis gangu",p_g.tabpanel)

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
    guiLabelSetHorizontalAlign(p_g.lblInfoStats,"center",false)
    guiLabelSetVerticalAlign(p_g.lblInfoStats,"center")
p_g.lblLine3 = guiCreateLabel(sw*4/800, sh*52/600, sw*778/800, sh*15/600,lblkres,false,p_g.tabStats)
p_g.lblCzlonkowie = guiCreateLabel(sw*22/800, sh*77/600, sw*350/800, sh*18/600,"Ilość członków:",false,p_g.tabStats)
p_g.lblMoney= guiCreateLabel(sw*22/800, sh*102/600, sw*350/800, sh*18/600,"Pieniądze zgromadzone w sejfie:",false,p_g.tabStats)
p_g.lblLogo = guiCreateLabel(sw*22/800, sh*127/600, sw*350/800, sh*18/600,"Zarejestrowany na forum (posiada logo):",false,p_g.tabStats)
p_g.lblSkin = guiCreateLabel(sw*22/800, sh*152/600, sw*350/800, sh*18/600,"Może ustawić skin gangowy:",false,p_g.tabStats)
p_g.lblBase = guiCreateLabel(sw*22/800, sh*177/600, sw*350/800, sh*18/600,"Posiada własną bazę: [WKRÓTCE]",false,p_g.tabStats)
p_g.lblUpgrades = guiCreateLabel(sw*22/800, sh*202/600, sw*350/800, sh*18/600,"Poziom ulepszenia gangu: [WKRÓTCE]",false,p_g.tabStats)
p_g.lblRank = guiCreateLabel(sw*22/800, sh*229/600, sw*350/800, sh*18/600,"Pozycja w rankingu: [WKRÓTCE]",false,p_g.tabStats)  

-- Notatki
p_g.memo = guiCreateMemo(sw*7/800, sh*8/600, sw*765/800, sh*313/600,tostring(memoInfoStart),false,p_g.tabNotes)
p_g.lblNoteMem = guiCreateLabel(sw*9/800, sh*331/600, sw*400/800, sh*60/600,tostring(memoLbl),false,p_g.tabNotes)
p_g.btnAcceptNote = guiCreateButton(sw*569/800, sh*332/600, sw*203/800, sh*60/600,"Zapisz notatkę",false,p_g.tabNotes)
---------------------------------
p_g.init=function()
	local gname,gtag,grank,grankid,gid=getGID()
	if (not gid) then return end

	triggerServerEvent("onPlayerRequestGangData",localPlayer,gid)
	guiSetText(p_g.wnd,gname)
    guiSetInputMode("no_binds_when_editing")
	if (tonumber(grankid)>2) then
		guiSetEnabled(p_g.btn_dodaj,true)
        guiSetEnabled(p_g.btnAcceptNote,true)
        guiMemoSetReadOnly(p_g.memo,false)
		guiSetEnabled(p_g.btn_dodaj,true)
        guiSetEnabled(p_g.btn_ulepsz,false)
	else
		guiSetEnabled(p_g.btn_dodaj,false)
        guiMemoSetReadOnly(p_g.memo,true)
        guiSetEnabled(p_g.btnAcceptNote,false)
        guiSetEnabled(p_g.btn_ulepsz,false)
	end
	guiSetEnabled(p_g.btn_wyrzuc,false)
	guiSetEnabled(p_g.btn_edytuj,false)
	edytowana_postac=nil
end

--p_g.gridcolumn_nick | p_g.gridcolumn_ranga |p_g.gridcolumn_lastplay | p_g.gridcolumn_money |
p_g.fill=function(dane,data,onlineMembers) 
	guiGridListClear(p_g.gridlist)
	if (not dane or not data) then return end
	for i,v in ipairs(dane) do
		local row = guiGridListAddRow (p_g.gridlist)
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_nick, v.nick,false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_nick, tonumber(v.player_id))
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_ranga, v.ranga,false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_ranga, tonumber(v.rank_id))
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_lastplay, v.lastduty or "Nie określono",false,false)
		guiGridListSetItemText(p_g.gridlist,row,p_g.gridcolumn_money,v.wplacone_sejf.."$",false,false)
		guiGridListSetItemData(p_g.gridlist,row,p_g.gridcolumn_money,tonumber(v.wplacone_sejf))
        guiSetText(p_g.lblCzlonkowie,"Ilość członków: "..#dane)
        guiGridListSetItemColor(p_g.gridlist,row,p_g.gridcolumn_nick,255,0,0)
        for i2,v2 in pairs(onlineMembers) do
            if (v2 == tonumber(v.player_id)) then 
                guiGridListSetItemColor(p_g.gridlist,row,p_g.gridcolumn_nick,155,255,155)
            end
        end
        if (v.text_note) then -- Jesli gang jest nowy, musimy mu nadac poczatkowa informacje
            guiSetText(p_g.memo,tostring(v.text_note))
        end
	end
    for i,v in ipairs(data) do
        guiSetText(p_g.lblMoney,"Pieniądze zgromadzone w sejfie: "..tonumber(v.money_sejf).."$")
        if (v.skin ~="NULL") then
            guiSetText(p_g.lblSkin,"Posiada skin gangowy: Tak")
        else
            guiSetText(p_g.lblSkin,"Posiada skin gangowy: Nie")
        end
        
        if (v.logo==1) then
            guiSetText(p_g.lblLogo,"Zarejestrowany na forum (posiada logo): Tak")
        else
            guiSetText(p_g.lblLogo,"Zarejestrowany na forum (posiada logo): Nie")
        end
        
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
		end
		if (tonumber(grankid)>=3) then
			guiSetEnabled(p_g.btn_edytuj,true)
		else
			guiSetEnabled(p_g.btn_edytuj,false)
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

p_g.note=function()
    local __,__,__,grankid,gid=getGID()
    if (not gid) then return end
    if (grankid and tonumber(grankid)>=3) then
        local Note = guiGetText(p_g.memo)
        guiSetEnabled(p_g.btnAcceptNote,false)
        guiMemoSetReadOnly(p_g.memo,true)
        triggerServerEvent("onGangMemberEditNote",localPlayer,gid,tostring(Note))
    end 
end

p_g.note_result=function(wynik, komunikat)
    if (not wynik) then
        guiSetEnabled(p_g.btnAcceptNote,true)
        guiMemoSetReadOnly(p_g.memo,false)
        guiSetText(p_g.lblNoteMem,komunikat)
        guiLabelSetColor(p_g.lblNoteMem,255,0,0)
        return
    else
        guiSetEnabled(p_g.btnAcceptNote,true)
        guiMemoSetReadOnly(p_g.memo,false)
        guiSetText(p_g.lblNoteMem,komunikat)
        guiLabelSetColor(p_g.lblNoteMem,255,255,255) -- Jesli gracz dostal najpierw false
        p_g.init()
    end    
end
-- Zakladka: Zarzadzanie ---------------------------

p_g.fill_upgrades=function(dane,dane2)
    guiGridListClear(p_g.grid)
    if (not dane) then return end
    for i,v in ipairs(dane) do
        --if (tonumber(v.id) == 3 and dane2.id_upgrade == 3 ) then outputDebugString('lol') return end
        local row = guiGridListAddRow(p_g.grid)

        guiGridListSetItemText(p_g.grid, row, p_g.gridcolumn_name, v.name,false,false)
        guiGridListSetItemData(p_g.grid, row, p_g.gridcolumn_name, tonumber(v.id))
        guiGridListSetItemText(p_g.grid, row, p_g.gridcolumn_price, v.cost.."$", false,false)
        guiGridListSetItemData(p_g.grid, row, p_g.gridcolumn_price, tonumber(v.cost))
        if (tonumber(v.cost)<=tonumber(v.money_sejf)) then
            guiGridListSetItemColor(p_g.grid, row, p_g.gridcolumn_name, 0, 255, 0)
            guiGridListSetItemColor(p_g.grid, row, p_g.gridcolumn_price, 0, 255, 0)
        end
        if (tonumber(v.cost)>tonumber(v.money_sejf)) then
            guiGridListSetItemColor(p_g.grid, row, p_g.gridcolumn_name, 255, 0, 0)
            guiGridListSetItemColor(p_g.grid, row, p_g.gridcolumn_price, 255, 0, 0)
        end
    end
end

p_g.gridclick_upgrade=function()
    local gname,gtag,grank,grankid,gid=getGID()
    if (not gid) then return end
    
    if (not guiGetEnabled(p_g.btn_dodaj)) then return end
    selectedRow= guiGridListGetSelectedItem(p_g.grid)
    if (selectedRow<0) then
        guiSetEnabled(p_g.btn_ulepsz, false)
    else
        local name=guiGridListGetItemData(p_g.grid, selectedRow, p_g.gridcolumn_name)
        if (tonumber(grankid)>=3) then
            guiSetEnabled(p_g.btn_ulepsz, true)
        else
            guiSetEnabled(p_g.btn_ulepsz, false)
        end
    end
end
p_g.addUpgrade=function()
    local __,__,__,grank,gid=getGID()
    if (not gid) then return end
    selectedRow = guiGridListGetSelectedItem(p_g.grid)
    local name = guiGridListGetItemData(p_g.grid, selectedRow, p_g.gridcolumn_name)
    triggerServerEvent("onGangUpgradeBuy", localPlayer, gid, name)
end

p_g.add_money=function()
    local __,__,__,__,gid=getGID()
    local pid = getElementData(localPlayer,"auth:uid")
    if (not gid or not pid) then return end
    
    local money = string.format("%.0f",guiGetText(p_g.editMoney)) -- usuwamy wartośc po '.'
    if (money and tonumber(money)>0) then
        triggerServerEvent("onMemberGangSaveMoney",localPlayer,gid,pid,tonumber(money))
        --guiSetEnabled(p_g.btnWplac,false)
    end
end

p_g.add_money_result=function(wynik,komunikat)
    if (not wynik) then
        guiSetText(p_g.lblWplac2, komunikat)
        guiSetEnabled(p_g.btnWplac,true)
        return 
    else
        p_g.init()
        guiSetEnalbed(p_g.btnWplac,true)
    end
end
-- Dodawanie graczy -----------------------------
p_a={}
p_a.win = guiCreateWindow(sw*185/800, sh*151/600, sw*449/800, sh*306/600, "", false)
	guiWindowSetSizable(p_a.win, false)
	guiSetVisible(p_a.win,false)
p_a.edit_nick = guiCreateEdit(sw*12/800, sh*105/600, sw*427/800, sh*28/600, "", false, p_a.win)
p_a.lbl_nick = guiCreateLabel(sw*13/800, sh*61/600, sw*358/800, sh*38/600, "Wpisz nick gracza:\nMożesz również zaprosić gracza poprzez komendę gang.zapros", false, p_a.win)
p_a.lbl_blad = guiCreateLabel(sw*13/800, sh*150/600, sw*426/800, sh*55/600, "", false, p_a.win) 
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

--- Edycja gracza ----------------------------------------------------------------
p_e = {}
p_e.win = guiCreateWindow(sw*155/800, sh*116/600, sw*489/800, sh*403/600, "Edycja gracza", false) 
    guiWindowSetSizable(p_e.win, false) 
    guiSetVisible(p_e.win,false)
p_e.lbl_player = guiCreateLabel(sw*144/800, sh*24/600, sw*230/800, sh*20/600, "Aktualnie edytujesz gracza", false, p_e.win) 
    guiLabelSetHorizontalAlign(p_e.lbl_player , "center", false) 
    guiLabelSetVerticalAlign(p_e.lbl_player , "center") 
p_e.lbl_ranga = guiCreateLabel(sw*9/800, sh*60/600, sw*135/800, sh*15/600, "Edycja rangi:", false, p_e.win) 
p_e.cmb_ranga = guiCreateComboBox(sw*90/800, sh*60/600, sw*313/800, sh*120/600, "", false, p_e.win) 
p_e.lbl_skin = guiCreateLabel(sw*9/800, sh*150/600, sw*71/800, sh*20/600, "Edycja skina:", false, p_e.win) 
p_e.cmb_skin = guiCreateComboBox(sw*87/800, sh*152/600, sw*237/800, sh*75/600, "", false, p_e.win)
p_e.btn_save = guiCreateButton(sw*9/800, sh*314/600, sw*200/800, sh*79/600, "Zapisz", false, p_e.win) 
p_e.btn_cancel = guiCreateButton(sw*285/800, sh*317/600, sw*194/800, sh*76/600, "Anuluj", false, p_e.win) 

p_e.pokaz=function()
    local __,__,__,__,gid=getGID()
	if (not gid) then return end

	selectedRow = guiGridListGetSelectedItem(p_g.gridlist)
	local pid=guiGridListGetItemData(p_g.gridlist,selectedRow,p_g.gridcolumn_nick)

	guiSetInputMode("no_binds_when_editing")
	guiSetVisible(p_e.win,true)
	guiBringToFront(p_e.win)
	guiComboBoxClear(p_e.cmb_ranga)
	guiComboBoxClear(p_e.cmb_skin)
    guiSetText(p_e.lbl_player,"Oczekiwanie na dane...")
	guiComboBoxAddItem(p_e.cmb_skin, "Nie ustawiono")

	triggerServerEvent("onGangCharacterDetailsRequest",localPlayer,gid,pid)
end

p_e.schowaj=function()
	guiSetVisible(p_e.win,false)
end

p_e.edycja_potwierdz=function(dane)
	if (not dane or not dane.gracz or not dane.gracz.userid) then
		p_e.schowaj()
	end
    local __,__,__,grankid,__=getGID()
	edytowana_postac=dane.gracz.userid
	guiSetText(p_e.lbl_player, "Aktualnie edytujesz gracza : "..dane.gracz.nick)
	guiComboBoxClear(p_e.cmb_ranga)
	guiComboBoxClear(p_e.cmb_skin)
	for i,v in ipairs(dane.rangi) do
		local i2=guiComboBoxAddItem(p_e.cmb_ranga, tostring(v.rank_id)..". "..v.name)
			if (v.rank_id == dane.gracz.rank) then
				guiComboBoxSetSelected(p_e.cmb_ranga,i2)
                if (i==#dane.rangi) then -- Gracz jest liderem, blokujemy edycje
                    guiComboBoxClear(p_e.cmb_ranga)
                    local block = guiComboBoxAddItem(p_e.cmb_ranga,"Zablokowane")
                    guiComboBoxSetSelected(p_e.cmb_ranga,block)
                end
			end
		end
	local skin = guiComboBoxAddItem(p_e.cmb_skin,"brak")
	guiComboBoxSetSelected(p_e.cmb_skin,skin)
	if (dane.skiny and #dane.skiny>0) then
		for i,v in ipairs(dane.skiny) do
			local i3 = guiComboBoxAddItem(p_e.cmb_skin, tostring(v.skin))
			if (v.skin == dane.gracz.skin) then
				guiComboBoxSetSelected(p_e.cmb_skin, i3)
			end
		end
	end
end

p_e.zapisz=function()
	if (not edytowana_postac) then return end
	local ranga = guiComboBoxGetItemText(p_e.cmb_ranga, guiComboBoxGetSelected(p_e.cmb_ranga))
    if (tostring(ranga) == 'Zablokowane') then
        ranga = tonumber(4)
    else
	ranga = tonumber(string.sub(ranga,1,1))
	end
    local skin = tonumber(guiComboBoxGetItemText(p_e.cmb_skin, guiComboBoxGetSelected(p_e.cmb_skin)))
	triggerServerEvent("onGangEdycjaPostaci",localPlayer, edytowana_postac, ranga, skin)
end

addEvent("doFillGangData", true)
addEventHandler("doFillGangData", resourceRoot, p_g.fill)
addEvent("onGangWyrzucComplete", true)
addEventHandler("onGangWyrzucComplete", resourceRoot, p_g.init)
addEvent("onEditSendResult",true)
addEventHandler("onEditSendResult", resourceRoot, p_g.note_result)
-- glowne okno
addEventHandler("onClientGUIClick", p_g.btn_dodaj, p_a.pokaz, false)   
addEventHandler("onClientGUIClick", p_g.btn_wyrzuc, p_g.zwolnij, false)
addEventHandler("onClientGUIClick", p_g.btn_edytuj, p_e.pokaz, false)
addEventHandler("onClientGUIClick", p_g.gridlist, p_g.gridclick, false)
addEventHandler("onClientGUIClick", p_g.btnAcceptNote, p_g.note, false)
-- zakladka: zarzadzanie gangiem
addEvent("doFillUpgradesData",true)
addEventHandler("doFillUpgradesData", resourceRoot, p_g.fill_upgrades)
addEvent('onResultSaveMoney',true)
addEventHandler("onResultSaveMoney", resourceRoot, p_g.add_money_result)
addEventHandler("onClientGUIClick", p_g.btnWplac, p_g.add_money, false)
addEventHandler("onClientGUIClick", p_g.grid, p_g.gridclick_upgrade, false)
addEventHandler("onClientGUIClick", p_g.btn_ulepsz, p_g.addUpgrade, false)
-- dodawanie
addEvent("onGangInviteReply", true)
addEventHandler("onGangInviteReply", resourceRoot, p_a.dodaj_end)
addEventHandler("onClientGUIClick", p_a.btn_dodaj, p_a.dodaj, false)
addEventHandler("onClientGUIClick", p_a.btn_anuluj, p_a.schowaj, false)
-- edycja
addEvent("doFillGangPlayerData", true)
addEventHandler("doFillGangPlayerData", resourceRoot, p_e.edycja_potwierdz)
addEventHandler("onClientGUIClick", p_e.btn_cancel, p_e.schowaj, false)
addEventHandler("onClientGUIClick", p_e.btn_save, p_e.zapisz, false)
addEvent('onGangEdycjaComplete',true)
addEventHandler("onGangEdycjaComplete", resourceRoot, p_g.init)


bindKey("f5","down",function()
	local gid,gname,grank,grankid=getGID()
	if (not gid) then
	  guiSetVisible(p_g.wnd,false)
	  showCursor(false)
	  return
	end
	if isGOWindowOpen(p_g.wnd) then
		showCursor(false)
        toggleControl("fire",true)
		guiSetVisible(p_g.wnd, false)
	else
		showCursor(true,false)
        toggleControl("fire",false)
		guiSetVisible(p_g.wnd,true)
		p_g.init()
	end
end)
