--[[

vip - api sms

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vip
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
addEvent("checkAPIEnabled",true)
addEventHandler("checkAPIEnabled",root,function()
	fetchRemote("https://admin.serverproject.eu/api/smsapi.php?key=cffd04da3c3c70f38ed1eb8f1&do=checkSaldo",checkAccess,"",false,client)
end)
function checkAccess(responseData,errno,client)
	if errno ~= 0 then
		local info = "Brak połączenia z serwerem, spróbuj ponownie później."
		triggerClientEvent(client,"checkAccess", resourceRoot, info)
	elseif errno == 0 then 
		triggerClientEvent(client,"checkAccess",resourceRoot)
	end
end

addEvent("apiCodeTransaction",true)
addEventHandler("apiCodeTransaction",root,function(dni,kod)
local apikey = 'cffd04da3c3c70f38ed1eb8f1'
	if dni and kod then
		if dni == 7 then
			local smsAmount =  3
				fetchRemote(string.format("https://admin.serverproject.eu/api/smsapi.php?key=%s&amount=%d&code=%s&desc=%s",apikey,smsAmount,kod,kod),endTransaction,"",false,client,7)
				exports['psz-admin']:adminView_add("VIP_API> Gracz "..getPlayerName(client).."/"..getPlayerSerial(client)..", kod: "..kod..", smsAmount: "..smsAmount..".",2)
		elseif dni == 30 then
			local smsAmount = 6
				fetchRemote(string.format("https://admin.serverproject.eu/api/smsapi.php?key=%s&amount=%d&code=%s&desc=%s",apikey,smsAmount,kod,kod),endTransaction,"",false,client,30)
				exports['psz-admin']:adminView_add("VIP_API> Gracz "..getPlayerName(client).."/"..getPlayerSerial(client)..", kod: "..kod..", smsAmount: "..smsAmount..".",2)
		elseif dni == 45 then
			local smsAmount = 9
				fetchRemote(string.format("https://admin.serverproject.eu/api/smsapi.php?key=%s&amount=%d&code=%s&desc=%s",apikey,smsAmount,kod,kod),endTransaction,"",false,client,45)
				exports['psz-admin']:adminView_add("VIP_API> Gracz "..getPlayerName(client).."/"..getPlayerSerial(client)..", kod: "..kod..", smsAmount: "..smsAmount..".",2)
		elseif dni == 60 then
			local smsAmount = 19
				fetchRemote(string.format("https://admin.serverproject.eu/api/smsapi.php?key=%s&amount=%d&code=%s&desc=%s",apikey,smsAmount,kod,kod),endTransaction,"",false,client,60)
				exports['psz-admin']:adminView_add("VIP_API> Gracz "..getPlayerName(client).."/"..getPlayerSerial(client)..", kod: "..kod..", smsAmount: "..smsAmount..".",2)
		end
	end
end)

function endTransaction(responseData,errno,plr,dni)
if errno == 0 then
	local json = fromJSON(responseData)
		if json['status'] == 'ok' then

		exports['psz-mysql']:zapytanie(string.format("UPDATE psz_players SET vip= IF(vip>NOW(),vip,NOW())+INTERVAL %d DAY WHERE id=%d",dni,getElementData(plr,"auth:uid")))
		local dni = exports["psz-mysql"]:zapytanie(string.format("SELECT vip FROM psz_players WHERE id=%d",getElementData(plr,"auth:uid")))
		setElementData(plr,"vip",dni)
		triggerClientEvent(plr,"endTransaction",resourceRoot)
		elseif json['status'] == 'fail' then
			if json['error'] == 'internal_error' or json['error'] == 'wrong_amount' or json['error'] == 'wrong_key' or json['error'] == 'bad_desc' then
				local info = "Wystąpił wewnętrzny błąd w systemie, zgłoś to administracji ROOT. (KOD:1)"
				triggerClientEvent(plr,"endTransaction",resourceRoot,info)
			elseif json['error'] == 'wrong_code' or json['error'] == 'bad_code' then
				local info = "Podano nieprawidłowy kod doładowujący (wykorzystany lub nieprawidłowy)."
				triggerClientEvent(plr,"endTransaction",resourceRoot,info)
			end
		end
	end
end