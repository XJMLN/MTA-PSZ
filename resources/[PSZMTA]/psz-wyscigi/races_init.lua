
local races = {}

local function deleteRace(rid)
	if isElement(races[rid].startMarker) then deleteElement(races[rid].startMarker) end
	if isElement(races[rid].blip) then deleteElement(races[rid].blip) end
	races[rid] = nil
end

local function addRace(v, fast)
	if races[v.id] then 
		deleteRace(v.id)
	end

	v.pos = split(v.pos_start,",")
	for ii,vv in ipairs(v.pos) do v.pos[ii]=tonumber(vv) end

	v.startMarker = createMarker(v.pos[1],v.pos[2],v.pos[3],"checkpoint",2,0,150,21,100)
	v.blip = createBlip(v.pos[1],v.pos[2],v.pos[3],53,2,255,0,0,255,0,5000)
		setElementData(v.startMarker,"race", {
			["id"] = v.id,
			["blockRepair"] = v.allowRepairs,
			["descr"] = v.descr,
			})
	local dbid=v.id
	v.id = nil
	races[dbid]=v

	return true
end

local function getRaceInfo(id)
	return races[id]
end

function loadFewRaces(procent,fast)
	local tt = getTickCount()
	i = 0 
	local dbrace = exports['psz-mysql']:pobierzTabeleWynikow("SELECT r.id, r.vehicle,r.allowRepairs, r.distance,r.pos_start, r.descr FROM psz_races r WHERE r.active=1")
	for __,v in ipairs(dbrace) do
		if math.random(0, 100)<= procent then 
			if addRace(v,fast) then i=i+1 end
		end
	end
	outputDebugString("Załadowano wyścigów: "..i.." w ".. (getTickCount()-tt).. "ms")
end

addEventHandler("onResourceStart", resourceRoot, function()
	loadFewRaces(100,false)
end)
