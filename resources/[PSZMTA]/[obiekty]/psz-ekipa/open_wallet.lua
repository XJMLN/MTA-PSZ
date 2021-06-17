--[[

ekipa - otwarty portfel administracyjny

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
@package PSZMTA.psz-ekipa
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

addEvent("onPlayerRequestAOinfo", true)
addEventHandler("onPlayerRequestAOinfo", resourceRoot, function()
	local c = getElementData(client, "character")
	if (not c or not c.id) then 
		triggerClientEvent(client,"doFillAO", resourceRoot, false)
		return
	end

	local dbid = getElementData(client,"auth:uid")

	local sr = exports['psz-mysql']:pobierzWyniki("SELECT value_i FROM psz_currentstats WHERE name='admin_wallet'")
	if (not sr or not sr.value_i) then 
		triggerClientEvent(client,"doFillAO", resourceRoot, false)
		return
	end
	triggerClientEvent(client,"doFillAO", resourceRoot, true, tonumber(sr.value_i))
end)

addEvent("doAOOperation", true)
addEventHandler("doAOOperation", resourceRoot, function(kwota)
	local dbid = getElementData(client,"auth:uid") or 0
	if (dbid and dbid<1) then return end
	if kwota>0 then
		local sr = exports['psz-mysql']:pobierzWyniki("SELECT value_i FROM psz_currentstats WHERE name='admin_wallet'")
		if (not sr or not sr.value_i) then return end
		sr.value_i = tonumber(sr.value_i)
		if (sr.value_i<math.abs(kwota)) then 
			outputChatBox("Portfel nie posiada tylu środków!", client, 255,0,0)
			return 
		end

		exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_admlog SET ts=NOW(), action='takewalletmoney',target_type='player',target_id=%d,target_name='%s',admin_nick='%s',admin_id=%d, reason='Wyplata na event ($%d)'",dbid,getPlayerName(client),dbid,dbid,math.abs(tonumber(kwota))))

		exports['psz-mysql']:zapytanie("UPDATE psz_currentstats SET value_i=value_i-"..math.abs(tonumber(kwota)).." WHERE name='admin_wallet'")

		givePlayerMoney(client,math.abs(kwota))

		exports['psz-admin']:adminView_add(string.format("AWALLET> wyplata %s/%d kwota %s$",getPlayerName(client),dbid,kwota))
	end
end)