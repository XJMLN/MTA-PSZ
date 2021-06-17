local function getPlayerDBID(plr)
	local c=getElementData(plr,"character")
	if not c then return nil end
	return tonumber(c.id)
end

local function getGID(player)
    local c=getElementData(player,"character")
    if (not c) then return nil end
    return c.gg_nazwa,c.gg_tag,c.gg_rank_name,c.gg_rank_id,c.gg_id 
end

addEvent("onHousePaymentRequest", true)
addEventHandler("onHousePaymentRequest", getRootElement(), function(domid,ilosc_dni)
	
	local dbid=getElementData(client,"auth:uid")
	if not dbid then return end
	if ilosc_dni<=0 then return end
	if not domy[domid] then return end
	if domy[domid].ownerid and domy[domid].ownerid~=dbid then return end
	local gotowka=getPlayerMoney(client)
	local koszt=((ilosc_dni*domy[domid].koszt))
	if koszt>gotowka then outputChatBox("Nie stać Ciebie na zakup domu.", client, 255,0,0) return end
	if domy[domid].paidTo_dni and tonumber(domy[domid].paidTo_dni) and tonumber(domy[domid].paidTo_dni)>=14 then
		outputChatBox("Dom można opłacić na maksymalnie 14 dni.", client, 255,0,0)
		return
	end
	local vip = getElementData(client, "vip") or 0 
	-- sprawdzamy ile posiada
	local rp=exports["psz-mysql"]:pobierzWyniki("select count(*) ilosc from psz_domy WHERE ownerid=? AND paidTo>=NOW() AND active=1 AND id!=?", dbid, domid)
	if (rp and rp.ilosc and rp.ilosc>=2 and not vip)  then
		outputChatBox("Nie możesz posiadać więcej niż dwa domy.", client, 255,0,0)
		return
	elseif (rp and rp.ilosc and rp.ilosc>=3 and vip) then 
		outputChatBox("Nie możesz posiadać więcej niż trzy domy.", client, 255,0,0)
		return
	end

	local r=exports["psz-mysql"]:zapytanie("UPDATE psz_domy SET ownerid=?,paidTo=IF(paidTo>NOW(),paidTo,NOW())+INTERVAL ? DAY WHERE id=? AND (ownerid IS NULL or ownerid=?) LIMIT 1", 
				dbid, ilosc_dni, domid, dbid)
	if r and r>0 then
		takePlayerMoney(client, koszt)
		exports["psz-admin"]:gameView_add(string.format("Gracz %s (%d) oplaca dom %d na %d dni koszt %d.", getPlayerName(client), dbid, domid, ilosc_dni,koszt))
        exports['psz-poczta']:poczta_powiadomGracza(tonumber(dbid))
		domReload(domid)
		exports['psz-mysql']:zapytanie(string.format("UPDATE psz_currentstats SET value_i=value_i+%d WHERE name='admin_wallet'",koszt))
		--exports["lss-achievements"]:checkAchievementForPlayer(client, "dom")
--		exports["bp-core"]:givePlayerScore(client, -koszt)
	end

end)

addEvent("onHouseChangeOptions", true)
addEventHandler("onHouseChangeOptions", resourceRoot, function(domid,opcja,stan)
	if not domid or not domy[domid] then return end
	if opcja=="zamkniety" then
		exports["psz-mysql"]:zapytanie("UPDATE psz_domy SET zamkniety=? WHERE id=? LIMIT 1", stan and 1 or 0, domid)
		triggerClientEvent(client, "doHideHouseWindows", resourceRoot)
		domReload(domid)
	end
	if opcja=="gang" then 
		local gname,gtag,grank, grankid, gid = getGID(client)
		if (gid) then 
			if stan then 
			exports['psz-mysql']:zapytanie("UPDATE psz_domy SET owner_gang=? WHERE id=? LIMIT 1", gid, domid)
			else 
				exports['psz-mysql']:zapytanie("UPDATE psz_domy SET owner_gang=NULL WHERE id=? LIMIT 1",domid)
			end
			triggerClientEvent(client, "doHideHouseWindows", resourceRoot)
			domReload(domid)
		else
			outputChatBox("Nie należysz do żadnego gangu.",client)
		end
	end
end)