--[[

vip - api sms

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vip
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local opcje = {
	{dni=7, napis = "Konto VIP 7 DNI", tresc="AA.SP", koszt = "3,69zł", numer= "7355" },
	{dni=30, napis = "Konto VIP 30 DNI", tresc= "AA.SP", koszt = "7,38zł", numer= "7636"},
	{dni=45, napis = "Konto VIP 45 DNI", tresc= "AA.SP", koszt = "11,07zł", numer= "7936"},
	{dni=60, napis = "Konto VIP 60 DNI", tresc= "AA.SP", koszt = "23,37zł", numer= "91955"},
}
local lu = getTickCount()-15000
local sw,sh = guiGetScreenSize()
local api = {}

api.wnd = guiCreateWindow((118/800)*sw, (79/600)*sh, (554/800)*sw, (424/600)*sh, "Usługi płatne", false)
	guiWindowSetSizable(api.wnd, false)
	guiSetVisible(api.wnd,false)
api.lbl1 = guiCreateLabel((34/800)*sw, (25/600)*sh, (479/800)*sw, (111/600)*sh, "Usługa dostępna jest dla sieci Orange, T-Mobile, Plus, Play, Sferia, Cyfrowy Polsat oraz wszystkich sieci wirtualnych MVNO (np. GaduAir, mBank mobile, Aster).\n            USŁUGA DOSTĘPNA JEST TYLKO NA TERENIE POLSKI.", false, api.wnd)
api.lbl2 = guiCreateLabel((34/800)*sw, (146/600)*sh, (430/800)*sw, (15/600)*sh, "Chcę doładować konto VIP dla konta na którym obecnie jestem zalogowany/a.", false, api.wnd)
api.check1 = guiCreateCheckBox((9/800)*sw, (146/600)*sh, (15/800)*sw, (14/600)*sh, "", false, false, api.wnd)
api.lbl3 = guiCreateLabel((34/800)*sw, (182/600)*sh, (510/800)*sw, (19/600)*sh, "Zapoznałem/am się z regulaminem usługi.", false, api.wnd)
api.check2 = guiCreateCheckBox((9/800)*sw, (182/600)*sh, (15/800)*sw, (14/600)*sh, "", false, false, api.wnd)

api.combo = guiCreateComboBox((130/800)*sw, (209/600)*sh, (259/800)*sw, (81/600)*sh, "Wybierz jedną z opcji", false, api.wnd)
for i,v in ipairs(opcje) do
	guiComboBoxAddItem(api.combo, v.napis)
end

api.lbl5 = guiCreateLabel((9/800)*sw, (247/600)*sh, (119/800)*sw, (15/600)*sh, "Wyślij SMS o treści", false, api.wnd)
	guiLabelSetHorizontalAlign(api.lbl5, "center", false)
	guiLabelSetVerticalAlign(api.lbl5, "center")
api.lbl6 = guiCreateLabel((10/800)*sw, (267/600)*sh, (78/800)*sw, (23/600)*sh, "kod", false, api.wnd)
	guiSetFont(api.lbl6, "default-bold-small")
	guiLabelSetHorizontalAlign(api.lbl6, "center", false)
	guiLabelSetVerticalAlign(api.lbl6, "center")
api.lbl7 = guiCreateLabel((201/800)*sw, (247/600)*sh, (106/800)*sw, (17/600)*sh, "Pod numer", false, api.wnd)
	guiLabelSetHorizontalAlign(api.lbl7, "center", false)
	guiLabelSetVerticalAlign(api.lbl7, "center")
api.lbl10 = guiCreateLabel((209/800)*sw, (268/600)*sh, (93/800)*sw, (22/600)*sh, "numer", false, api.wnd)
	guiSetFont(api.lbl10, "default-bold-small")
	guiLabelSetHorizontalAlign(api.lbl10, "center", false)
	guiLabelSetVerticalAlign(api.lbl10, "center")
api.lbl8 = guiCreateLabel((399/800)*sw, (247/600)*sh, (145/800)*sw, (15/600)*sh, "Koszt SMS (brutto):", false, api.wnd)
	guiLabelSetHorizontalAlign(api.lbl8, "center", false)
	guiLabelSetVerticalAlign(api.lbl8, "center")
api.lbl9 = guiCreateLabel((441/800)*sw, (277/600)*sh, (43/800)*sw, (23/600)*sh, "00,00zł", false, api.wnd)
	guiSetFont(api.lbl9, "default-bold-small")
api.lbl11 = guiCreateLabel((9/800)*sw, (324/600)*sh, (108/800)*sw, (23/600)*sh, "Otrzymany kod:", false, api.wnd)    
api.edit = guiCreateEdit((124/800)*sw, (318/600)*sh, (265/800)*sw, (29/600)*sh, "", false, api.wnd)
api.btnDone = guiCreateButton((10/800)*sw, (364/600)*sh, (241/800)*sw, (50/600)*sh, "Wyślij", false, api.wnd)
api.btnCancel = guiCreateButton((276/800)*sw, (363/600)*sh, (268/800)*sw, (51/600)*sh, "Anuluj", false, api.wnd)

local function checkBoxOptions()
	local sel = guiCheckBoxGetSelected(api.check1) and guiCheckBoxGetSelected(api.check2)

	guiSetEnabled(api.btnDone,sel)

	local select_combo = guiComboBoxGetSelected(api.combo) or -1
	if select_combo<0 or not opcje[select_combo+1] then
		guiSetText(api.lbl6,"-")
		guiSetText(api.lbl10,"-")
		guiSetText(api.lbl9,"-")
	else
		guiSetText(api.lbl6,opcje[select_combo+1].tresc)
		guiSetText(api.lbl10,opcje[select_combo+1].numer)
		guiSetText(api.lbl9,opcje[select_combo+1].koszt)
	end
end

local function guiShow()
	local pid = getElementData(localPlayer,"auth:uid")
	if not pid then
		outputChatBox("Najpierw dołącz do gry.",255,0,0)
		return
	end
	showCursor(true)
	guiSetVisible(api.wnd,true)
	guiCheckBoxSetSelected(api.check1,false)
	guiCheckBoxSetSelected(api.check2,false)
	guiSetEnabled(api.btnDone,false)
	checkBoxOptions()
end

local function guiDelete()
	showCursor(false)
	guiSetVisible(api.wnd,false)
end

addCommandHandler("vip",function()
	if getTickCount()-lu<15000 then 
		outputChatBox("Odczekaj chwilę przed ponownym uruchomieniem zakupu.",255,0,0)
		return
	end
	lu=getTickCount()
	--outputChatBox("Aktualnie przeprowadzamy prace nad systemem VIP, zajrzyj tutaj później. :)",255,0,0)
	outputChatBox("* Proszę czekać trwa sprawdzanie połączenia z serwerem...",255,0,0)
	triggerServerEvent("checkAPIEnabled",resourceRoot)
end)

local function apiSendCode()
	local enable = guiCheckBoxGetSelected(api.check1) and guiCheckBoxGetSelected(api.check2)
	if not enable then return end

	local sl = guiComboBoxGetSelected(api.combo) or -1
	if sl<0 then return end
	sl=sl+1
	if not opcje[sl] then return end

	local kod = guiGetText(api.edit)
	if not kod or string.len(kod)<6 or string.len(kod)>8 then
		guiSetText(api.lbl1,"Wprowadzony kod jest nieprawidłowy - jest krótki lub długi.")
		return
	end
	guiSetText(api.lbl1,"Trwa weryfikacja, proszę czekać...")
	triggerServerEvent("apiCodeTransaction",resourceRoot,opcje[sl].dni, kod)
	guiSetEnabled(api.btnDone,false)
	guiSetEnabled(api.btnCancel,false)
end

addEventHandler("onClientGUIClick",api.btnDone,apiSendCode,false)
addEventHandler("onClientGUIComboBoxAccepted",api.wnd,checkBoxOptions)
addEventHandler("onClientGUIClick",api.btnCancel,guiDelete,false)
addEventHandler("onClientGUIClick",api.wnd,checkBoxOptions)

addEvent("checkAccess",true)
addEventHandler("checkAccess",resourceRoot,function(info)
	if info then
		guiDelete()
		outputChatBox(info,255,0,0)
	else
		guiShow()
	end
end)
addEvent("endTransaction",true)
addEventHandler("endTransaction",resourceRoot,function(info)
	if info then
		guiSetText(api.lbl1,info)
		guiSetEnabled(api.btnDone,true)
		guiSetEnabled(api.btnCancel,true)
	else
		outputChatBox("Gratulacje! Twoje konto VIP zostało przedłużone!")
		guiDelete()
	end
end)