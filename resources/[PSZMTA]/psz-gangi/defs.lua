function gangs_calculateCostZone(gid)
	if (gid<0) then return end
	local q 
	q = string.format("SELECT level FROM psz_gangi_owned_upgrades WHERE id_gang=%d",gid)
	local wynik = exports['psz-mysql']:pobierzWyniki(q) or 1
	if (wynik) then -- jesli bylo juz kupowane
		local lvl = wynik.level
		q = string.format("SELECT count(pg.id_player) czlonkow, money_sejf FROM psz_players_gangs pg LEFT JOIN psz_gangi g ON g.id=pg.id_gang WHERE pg.id_gang=%d", gid) -- pobieramy ilosc czlonkow w gangu 
		local wynik2 = exports['psz-mysql']:pobierzWyniki(q)
		local money = wynik2.money_sejf
		local czlonkow = wynik2.czlonkow
			--120 TYSIECY * respekt na dzielni / poziom ulepszenia
		local mnoznik = 1200000--((1200000 * 2)/czlonkow) -- 14 * 2 = 28 * 20 = 560 
	return mnoznik end
end 

function gang_getOnlinePlayer(pid)
	if (pid<0) then return end
    pid = tonumber(pid)
    local target = nil
    for _,v in ipairs(getElementsByType("player")) do
    local uid = getElementData(v,"auth:uid") or 0 
        if (tonumber(uid) == pid) then 
        	target = v
        end
    end
    return target
end
    
function gang_getOnlineMembers(gid)
    if (not gid or tonumber(gid)<0) then return end
    local onlineMembers = {}
    for i,v in ipairs(getElementsByType("player")) do
        local c = getElementData(v,"character")
        if (c and c.gg_id == gid) then 
            table.insert(onlineMembers,#onlineMembers+1,getElementData(v,"auth:uid"))
        end
    end
    return onlineMembers
end

function findPlayer(plr,cel)
    local target=nil
    if (tonumber(cel) ~= nil) then
        target=getElementByID("p"..cel)
    else -- podano fragment nicku
        for _,thePlayer in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 1, true) then
                if (target) then
                    outputChatBox("Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
                    return nil
                end
                target=thePlayer
            end
        end
    end
    return target
end