--[[

Zmiana hasla do konta

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-zmianahasla
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

addEvent("onPlayerSendNewPassword",true)
addEventHandler("onPlayerSendNewPassword",root,function(oldPassword,newPassword)
	if not oldPassword or not newPassword then
		outputChatBox("Wystąpił błąd - ponów próbę za chwilę.",client,255,0,0)
		return
	end
	local c = getElementData(client,"character")
	if (not c or not c.id) then return end -- Nie powinno sie wydarzyc
    local login = getElementData(client,"auth:login")
	local password = exports['psz-mysql']:zapytanie(string.format("SELECT login FROM psz_players WHERE hash='%s' AND id=%d",hash('sha1',string.lower(login).."ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9"..oldPassword),c.id))
		if password then
			local newPassword = exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET hash='%s' WHERE login='%s' LIMIT 1",hash('sha1',string.lower(login).."ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9"..newPassword),login))
			if newPassword then
				outputChatBox("Hasło zostało zmienione.",client,255,0,0)
				triggerClientEvent(client,"onPlayerNewPasswordEnd",resourceRoot)
				exports["psz-admin"]:gameView_add("ZMIANA (haslo) "..getPlayerName(client).."/"..getPlayerSerial(client).."/"..getElementData(client,"auth:uid"))
			else
				outputChatBox("Wystąpił błąd.",client,255,0,0)
				triggerClientEvent(client,"onPlayerNewPasswordEnd",resourceRoot,false,"Wystąpił błąd.")
			end
		else
			triggerClientEvent(client,"onPlayerNewPasswordEnd",resourceRoot,false,"Podane hasło jest nie prawidłowe")
		end
end)