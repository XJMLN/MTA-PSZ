--[[

Tuning - zmiana rejestracji

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicletuning
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local rc = {}
rc.win = guiCreateWindow (0.17, 0.37, 0.64, 0.28, "Zmiana rejestracji w pojeździe", true);
rc.lbl = guiCreateLabel (0.02, 0.24, 0.70, 0.11, "Napis na rejestracji (Maksymalnie 8 znaków): ", true, rc.win);
rc.btn_cancel = guiCreateButton (0.75, 0.75, 0.23, 0.20, "Anuluj", true, rc.win);
rc.btn_change = guiCreateButton (0.75, 0.46, 0.23, 0.20, "Zmień", true, rc.win);
rc.edt = guiCreateEdit(0.02, 0.39, 0.70, 0.20, "", true, rc.win);

guiWindowSetSizable (rc.win, false);
guiSetVisible(rc.win,false);

function rejestracja_gui()
	guiSetVisible (rc.win, true);
	guiSetInputMode ("no_binds_when_editing");
	showCursor (true);
	guiSetText(rc.edt,"");
end

function rejestracja_del()
	guiSetVisible (rc.win, false);
	showCursor (false);
	guiSetText(rc.edt,"");
end

function rejestracja_get()
	local q = string.len(guiGetText (rc.edt))
	if (q >8 or q == 0) then 
		outputChatBox("Rejestracja jest zbyt długa/krótka.")
	else
		--outputChatBox ("Rejestracja została zmieniona na: " .. guiGetText (rc.edt))
		
		triggerServerEvent ("rejestracja_change", localPlayer, guiGetText (rc.edt))
		rejestracja_del ();
	end
end
addEvent ("rejestracja_show", true)
addEventHandler ("rejestracja_show", localPlayer, rejestracja_gui)

	addEventHandler ("onClientGUIClick", rc.btn_cancel, rejestracja_del,false)
	addEventHandler("onClientGUIClick", rc.btn_change, rejestracja_get,false)
