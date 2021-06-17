local function tables_insertDataToText(id, data)
	if (not id or not data) then return end
	if (tonumber(id)==1) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d punktów driftu",i,v.nick,v.wynik)
		end
		setElementData(tablice_pos[id].footerT, "text",t_data)
	elseif (tonumber(id)==2) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d zebranych totemów",i, v.nick, v.score)
		end
		setElementData(tablice_pos[id].footerT, "text", t_data)
	elseif(tonumber(id)==3) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d zabitych graczy", i, v.nick, v.kills)
		end
		setElementData(tablice_pos[id].footerT, "text", t_data)
	elseif (tonumber(id) == 4) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d otrzymanych mandatów", i, v.nick, v.score)
		end
		setElementData(tablice_pos[id].footerT, "text", t_data)
	elseif (tonumber(id) == 5) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, $%d majątku łącznie", i, v.nick, v.sum_money)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 6) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d zaliczonych zgonów", i, v.nick, v.deaths)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 7) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d punktów zabawy",i,v.nick,v.pz)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 8) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %.2f przegranych godzin",i,v.nick,v.timeplay/60)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 9) then
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d punktów reputacji",i,v.nick,v.good_reputation)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 10) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s, %d punktów reputacji",i,v.nick,v.bad_reputation)
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 11) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s - %s, czas: %s",i,v.nick,getVehicleNameFromModel(v.vid),string.format("%.3fs",v.record_time/1000))
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	elseif (tonumber(id) == 12) then 
		local t_data = ""
		for i,v in pairs(data) do
			t_data = t_data..string.format("\n%d) %s - %s, czas: %s",i,v.nick,getVehicleNameFromModel(v.vid),string.format("%.3fs",v.record_time/1000))
		end
		setElementData(tablice_pos[id].footerT,"text",t_data)
	end
end 

function tables_getDataByID(id)
	if (not id) then return end
	local tt = getTickCount()
	local query = ""
	if (id == 1) then -- Drift
		query = "SELECT pd.wynik, pd.player_id, p.nick FROM psz_players_drift pd JOIN psz_postacie p ON p.userid=pd.player_id ORDER BY pd.wynik DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	
	elseif (id == 2) then -- Totemy
		query = "SELECT ps.score, ps.player_id, p.nick FROM psz_players_scores ps JOIN psz_postacie p ON p.userid=ps.player_id WHERE ps.nazwa='TOTEMY' ORDER BY ps.score DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 3) then -- zabicia
		query = "SELECT p.kills, p.nick FROM psz_postacie p ORDER BY p.kills DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 4) then -- mandaty
		query = "SELECT ps.score, ps.player_id, p.nick FROM psz_players_scores ps JOIN psz_postacie p ON p.userid=ps.player_id WHERE ps.nazwa='FOTOCASH' ORDER BY ps.score DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 5) then -- kasa
		query = "SELECT p.bank_money, p.money, p.nick, sum(p.bank_money + p.money) sum_money FROM psz_postacie p GROUP BY p.nick ORDER BY sum(p.bank_money + p.money) DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end 
	elseif (id == 6) then 
		query = "SELECT p.deaths, p.nick FROM psz_postacie p ORDER BY p.deaths DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 7) then 
		query = "SELECT p.nick,pl.pz FROM psz_players pl JOIN psz_postacie p ON p.userid=pl.id GROUP BY p.nick ORDER BY pl.pz DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 8) then 
		query = "SELECT p.nick, p.timeplay FROM psz_postacie p GROUP BY p.nick ORDER BY p.timeplay DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end
	elseif (id == 9) then 
		query = "SELECT p.nick, pl.good_reputation FROM psz_players pl JOIN psz_postacie p ON p.userid=pl.id GROUP BY p.nick ORDER BY pl.good_reputation DESC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end 
	elseif (id == 10) then 
		query = "SELECT p.nick, pl.bad_reputation FROM psz_players pl JOIN psz_postacie p ON p.userid=pl.id GROUP BY p.nick ORDER BY pl.bad_reputation ASC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end 
	elseif (id == 11) then 
		query = "SELECT pl.nick, drr.vid,drr.record_time FROM psz_postacie pl JOIN psz_dragraces_records drr ON drr.user_id=pl.userid WHERE drr.dragid=2 ORDER BY drr.record_time ASC, drr.ts ASC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end 
	elseif (id == 12) then 
		query = "SELECT pl.nick, drr.vid,drr.record_time FROM psz_postacie pl JOIN psz_dragraces_records drr ON drr.user_id=pl.userid WHERE drr.dragid=1 ORDER BY drr.record_time ASC ,drr.ts ASC LIMIT 10;"
		local wynik = exports['psz-mysql']:pobierzTabeleWynikow(query)
		if (wynik) then 
			tables_insertDataToText(id, wynik)
		else return end 	
	end
end



-- petla uruchamiajaca odswiezanie tabel
-- uruchamiana jest co 1 godzine, przetwarza losowa tabele 
-- nie ma mozliwosci przetworzenia poprzedniej tabeli - wtedy losujemy kolejny raz az do skutku 

local tables_lastLooptable = 0
function tables_loopAllTable()
	local n = math.random(1,12)
	if (tables_lastLooptable ~= n) then 
		tables_lastLooptable = n 
		tables_getDataByID(n)
		outputDebugString("Odświeżono dane dla tablicy: "..n..".")
	else tables_loopAllTable() return end
end

setTimer(tables_loopAllTable, 3600000,0) -- 1 h
addEventHandler("onResourceStart", resourceRoot, function()
	tables_loopAllTable()
end)

addCommandHandler("table_refresh.all",function(plr,cmd)
	if getPlayerName(plr) ~= "|PSZ|XJMLN" then return end
	setTimer(function()
		for i=1,12 do
			tables_getDataByID(i)
		end
		outputChatBox("Odświeżono każdą tabelę!",plr,255,0,0)
	end,5000,1)
	
end)