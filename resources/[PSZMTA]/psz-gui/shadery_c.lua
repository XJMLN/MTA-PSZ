--[[

GUI: Okienko opcji graficznych

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local w,h = guiGetScreenSize()
local f3 = {}

f3.wnd = guiCreateWindow(0.68, 0.24, 0.31, 0.58, "Ustawienia graficzne", true)
	guiWindowSetMovable(f3.wnd,false)
	guiWindowSetSizable(f3.wnd,false)
f3.lblInfo = guiCreateLabel(0.02, 0.05, 0.94, 0.12, "Włączenie niektórych ustawień może obniżyć wydajność twojej gry",true,f3.wnd)
	guiLabelSetHorizontalAlign(f3.lblInfo, "center", true)
f3.chckVeh = guiCreateCheckBox(0.04, 0.21, 0.06, 0.04,"",false,true,f3.wnd)
f3.chckBlo = guiCreateCheckBox(0.04,0.32,0.06,0.04,"",false,true,f3.wnd)
f3.chckDeta = guiCreateCheckBox(0.04,0.43,0.06,0.04,"",false,true,f3.wnd)
f3.chckClo = guiCreateCheckBox(0.04,0.54,0.06,0.04,"",false,true,f3.wnd)
f3.chckWate = guiCreateCheckBox(0.04,0.65,0.06,0.04,"",false,true,f3.wnd)
f3.chckSnow = guiCreateCheckBox(0.04,0.75,0.06,0.04,"",false,true,f3.wnd)
f3.lblVeh = guiCreateLabel(0.14, 0.21, 0.70, 0.04,"Karoseria pojazdów", true, f3.wnd)
f3.lblBl = guiCreateLabel(0.14, 0.32, 0.70, 0.04, "Shader bloom", true, f3.wnd)
f3.lblDeta = guiCreateLabel(0.14, 0.43, 0.70, 0.04, "Shader detali", true, f3.wnd)
f3.lblClo = guiCreateLabel(0.14, 0.54, 0.70, 0.04, "Shader chmur", true, f3.wnd)
f3.lblWate = guiCreateLabel(0.14, 0.65, 0.70, 0.04, "Shader wody", true, f3.wnd)
f3.lblSnow = guiCreateLabel(0.14, 0.75, 0.70, 0.04, "Opady śniegu", true, f3.wnd)
guiSetEnabled(f3.chckSnow, false)
guiSetVisible(f3.wnd,false)
function toggleWin()
	if (guiGetVisible(f3.wnd)) then
		showCursor(false)
		guiSetVisible(f3.wnd,false)
	else
		showCursor(true)
		guiSetVisible(f3.wnd,true)
	
	local uo_sb=getElementData(localPlayer, "uo_sb") -- shader bloom
	uo_sb = uo_sb and true or false
	guiCheckBoxSetSelected(f3.chckBlo, uo_sb)

	local uo_sw=getElementData(localPlayer, "uo_sw") -- shader wody
	uo_sw = uo_sw and true or false
	guiCheckBoxSetSelected(f3.chckWate, uo_sw)

	local uo_cp=getElementData(localPlayer, "uo_cp") -- karoseria pojazdow
	uo_cp = uo_cp and true or false
	guiCheckBoxSetSelected(f3.chckVeh, uo_cp)

	local uo_det=getElementData(localPlayer, "uo_det") -- shader detali
	uo_det = uo_det and true or false
	guiCheckBoxSetSelected(f3.chckDeta, uo_det)

	local uo_sc=getElementData(localPlayer, "uo_sc") -- shader chmur
	uo_sc = uo_sc and true or false
	guiCheckBoxSetSelected(f3.chckClo, uo_sc)

	local uo_sno = getElementData(localPlayer, "uo_sno") -- opady sniegu
	uo_sno = uo_sno and true or false
	guiCheckBoxSetSelected(f3.chckSnow, uo_sno)
	
	end
end
bindKey("F3","down",toggleWin)

addEventHandler("onClientGUIClick", resourceRoot, function(btn,state)
			local uo_sb=guiCheckBoxGetSelected(f3.chckBlo)
			local uo_sw=guiCheckBoxGetSelected(f3.chckWate)
			local uo_cp=guiCheckBoxGetSelected(f3.chckVeh)
			local uo_det=guiCheckBoxGetSelected(f3.chckDeta)
			local uo_sc=guiCheckBoxGetSelected(f3.chckClo)
			local uo_sno=guiCheckBoxGetSelected(f3.chckSnow)
			setElementData(localPlayer,"uo_sb", uo_sb) -- shader bloom
			setElementData(localPlayer,"uo_sw", uo_sw) -- shader wody
			setElementData(localPlayer,"uo_cp", uo_cp) -- karo poj
			setElementData(localPlayer,"uo_det", uo_det) -- shader detali
			setElementData(localPlayer,"uo_sc", uo_sc) -- shader chmur 
			setElementData(localPlayer,"uo_sno", uo_sno) -- opady sniegu
			triggerServerEvent("zapiszOpcje", resourceRoot, localPlayer, uo_sb, uo_sw, uo_cp, uo_det, uo_sc, uo_sno)
end)