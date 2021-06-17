addEvent("onPlayerAcceptStartRace",true)
addEventHandler("onPlayerAcceptStartRace", resourceRoot, function(race, vehicle)
	if (not vehicle) then return end
	local raceCP = exports['psz-mysql']:pobierzTabeleWynikow(string.format("SELECT rcp.id,rcp.aid,rcp.rid,rcp.pozycja_cp,rcp.next_cp,rcp.start,rcp.size,rcp.final,sp.pos,sp.angle FROM psz_races_cp rcp LEFT JOIN psz_races_sp sp ON sp.rid = rcp.rid WHERE rcp.rid=%d",race.id))
	local Ctable = {}
	for __,v in ipairs(raceCP) do
		table.insert(Ctable,v)
		v.vp = split(v.pos,",")
		for ii,vv in ipairs(v.vp) do v.vp[ii] = tonumber(vv) end
		setElementPosition(vehicle,v.vp[1],v.vp[2],v.vp[3])
		setElementRotation(vehicle,0,0,v.angle)
	end

	triggerClientEvent(client,"sendReturnDataTable",resourceRoot,Ctable,race,vehicle)
end)

addEvent("showRaceSummary", true)
addEventHandler("showRaceSummary", resourceRoot, function(plr, racetime, race)
	if (not plr or not racetime or not race) then return end
	-- sprawdzmy czy jest juz jakis rekord na danej trasie
	local q 
	q = string.format("SELECT pid, ts, recordtime FROM psz_races_records WHERE raceid=%d",race)
	local wyniki = exports['psz-mysql']:pobierzTabeleWynikow(q)
	if (q) then 
		outputChatBox("Ostatnie rekordy: ",client)
	else
		outputChatBox("Ustanowiles pierwszy rekord na trasie",client)
	end
end)