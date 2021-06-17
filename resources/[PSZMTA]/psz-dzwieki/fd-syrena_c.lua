--[[

Dzwieki - syrena w osp

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-dzwieki
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

syrena_win = guiCreateWindow(0.7766,0.3042,0.1766,0.5167,"Syrena",true)
guiSetVisible(syrena_win, false)
syrena_lbl = guiCreateLabel(0.0885,0.1169,0.7965,0.1935,"Tylko dla straży pożarnej!",true,syrena_win)
guiLabelSetHorizontalAlign(syrena_lbl, "center", true)
syrena_btnon = guiCreateButton(0.1062,0.2500,0.7788,0.4702,"Uruchom",true,syrena_win)
syrena_btnoff = guiCreateButton(0.1062,0.7500,0.7788,0.2000,"Zamknij",true,syrena_win)


addEventHandler("onClientGUIClick", syrena_btnon, function()

	triggerServerEvent("broadcastSound3D", localPlayer, "fd-syrena.ogg", 500,1,10*1000,"Niedaleko Ciebie rozlega się dźwięk syreny alarmowej straży pożarnej.")
end,false)


function otworzGUI()
    guiSetVisible(syrena_win,true)
    showCursor(true)
end
addEvent("openGUI",true)
addEventHandler("openGUI",localPlayer,otworzGUI)

addEventHandler("onClientGUIClick", syrena_btnoff, function()
        guiSetVisible(syrena_win,false)
        showCursor(false)
end)
