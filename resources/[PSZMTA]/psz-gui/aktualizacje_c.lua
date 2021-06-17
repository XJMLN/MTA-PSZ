--[[

GUI: Lista aktualizacji online

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local sx, sy = guiGetScreenSize()
local text = nil
local ts_lc = getTickCount()-60000

local window = guiCreateWindow(sx*22/800, sy*88/600, sx*768/800, sy*471/600, "", false)
local btn_close = guiCreateButton(0.94, 0.94, 0.05, 0.04, "✘", true, window)    
guiSetVisible(window, false)

function aktualizacje_start()
	if getTickCount()-ts_lc<60000 then 
		outputChatBox("Odczekaj chwilę..",255,0,0)
		return
	end
	ts_lc = getTickCount()
	triggerServerEvent("downloadDataCLog", resourceRoot, localPlayer)
end
addCommandHandler("aktualizacje", aktualizacje_start)

addEvent("sendDataCLog", true)
addEventHandler("sendDataCLog", resourceRoot, function(ttt)
	text = ttt 
	memo = guiCreateMemo(0.01, 0.05, 0.98, 0.86, text, true, window)
		guiWindowSetSizable(window, false)
    	guiSetVisible(window,true)
    	guiMemoSetReadOnly(memo,true)
    	showCursor(true,false)
end)

function aktualizacje_close()
	if text == nil then return end
	guiSetVisible(window, false)
	showCursor(false)
end
addEventHandler("onClientGUIClick", btn_close,aktualizacje_close,false)