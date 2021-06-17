--[[

GUI: Lista aktualizacji online

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

addEvent("downloadDataCLog",true)
addEventHandler("downloadDataCLog", resourceRoot, function(plr)
	local q 
	q = "SELECT id, ts, opis, autor FROM psz_aktualnosci ORDER BY id DESC LIMIT 15"
	local wynik = exports['psz-mysql']:pobierzTabeleWynikow(q)
	local text = ""
	for i,v in ipairs(wynik) do
		text = text..string.format("\n%s\n---%s, XJMLN\n\n",v.opis, v.ts)
	end
	triggerClientEvent(plr,"sendDataCLog", resourceRoot, text)
end)