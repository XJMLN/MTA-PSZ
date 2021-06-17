local race_punkty = {}
local cel = 0
local racetime = 0
local rid = 0
function race_summary(plr)
	local timer = string.format("%02d:%02d.%02d", racetime/60000, (racetime/1000)%60, racetime%1000/10)
	triggerServerEvent("showRaceSummary",resourceRoot,plr,racetime,rid)
	race_punkty = {}
	cel = 0
	racetime = 0
	rid = 0
end
function race_recount(plr,marker)
	local ilosc = #race_punkty 
	cel = cel + 1 
	for k,v in ipairs(race_punkty) do
		if cel == #race_punkty then 

			setMarkerSize(race_punkty[cel],0)
			triggerEvent("startRaceTimer",root,false)
			race_summary(plr)
		elseif k == cel then 

			setMarkerSize(race_punkty[cel+1],getElementData(race_punkty[cel+1],"size"))
			setMarkerSize(marker,0)
			return 
		end
	end
end


addEvent("sendReturnDataTable",true)
addEventHandler("sendReturnDataTable", resourceRoot, function(data,race,veh)
	if (not data or not race or not veh) then return end
	rid = race.id
	for i,v in ipairs(data) do
		v.pos = split(v.pozycja_cp,",")
		for ii,vv in ipairs(v.pos) do v.pos[ii] = tonumber(vv) end

		v.target = split(v.next_cp,",")
		for ii,vv in ipairs(v.target) do v.target[ii] = tonumber(vv) end

		race_punkty[i] = createMarker(v.pos[1],v.pos[2],v.pos[3],"checkpoint",v.size)
		setMarkerTarget(race_punkty[i],v.target[1],v.target[2],v.target[3])
		setMarkerSize(race_punkty[i],0)
		setElementData(race_punkty[i],"race:id",i)
		setElementData(race_punkty[i],"rid",v.rid)
		setElementData(race_punkty[i],"size",v.size)
		

		if v.finish then 
			setElementData(race_punkty[i],"race:finish",true)
			break
		end

		if v.start>0 then 
			setMarkerSize(race_punkty[i],v.size)
			setElementData(race_punkty[i],"race:start",true)
		end
	

		addEventHandler("onClientMarkerHit", race_punkty[i], function(el,md)
			if not el then return end
			if el~=getLocalPlayer() then return end
			local veh = getPedOccupiedVehicle(el)
			if (not veh or getPedOccupiedVehicleSeat(el)~=0) then return end
			race_recount(el,source)
			if getElementData(source,"race:start") then 
				racetime = getTickCount()
				triggerEvent("startRaceTimer",root,true)
			end
		end)
	end
end)

