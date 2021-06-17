local vehs = {
	-- x, y, z, rz, fid, table:color, veh model 
	{1391.23, 765.19, 10.84, 0, fid=4, c={255,255,255,25,36,87}, 582},
	{1386.14, 765.19, 10.83, 0, fid=4, c={255,255,255,25,36,87}, 582},
	{1380.32, 765.19, 10.83, 0, fid=4, c={255,255,255,25,36,87}, 582},

	{1178.00, -1338.61, 14.10, 270, fid=1, c={255,255,255,0,10,63}, 416},
	{1178.49, -1308.41, 14.01, 270, fid=1, c={255,255,255,0,10,63}, 416},
	{2036.69, -1414.07, 17.20, 218.4, fid=1, c={255,255,255,0,10,63}, 416},
	{1623.15, 1820.63, 11.03, 0, fid=1, c={255,255,255,0,10,63}, 416},
	{1590.75, 1820.90, 11.03, 0, fid=1, c={255,255,255,0,10,63}, 416},

	{1535.43,-1678.77,12.95, 0, fid=2, c={0,5,35,255,255,255}, 596},
	{1535.44,-1666.73,12.95, 0, fid=2, c={0,5,35,255,255,255}, 596},
	{2251.91,2477.00,10.41, 180, fid=2, c={0,5,35,255,255,255}, 596},
	{2260.81,2477.00,10.41, 180, fid=2, c={0,5,35,255,255,255}, 596},
	{2273.88,2477.00,10.41, 180, fid=2, c={0,5,35,255,255,255}, 596},
	{2282.25,2477.00,10.41, 180, fid=2, c={0,5,35,255,255,255}, 596},
	{2295.62,2477.00,10.41, 180, fid=2, c={0,5,35,255,255,255}, 596},
	{2282.35,2476.63,10.82,180, fid=2, c={0,5,35,255,255,255}, 596},
	{2273.58,2459.08,10.82,180, fid=2, c={0,5,35,255,255,255}, 596},
	{2273.44,2443.56,10.82,358.3, fid=2, c={0,5,35,255,255,255}, 596},
	{2256.08,2442.13,10.82,358.3, fid=2, c={0,5,35,255,255,255}, 596},
	{2251.83,2460.04,10.82,180, fid=2, c={0,5,35,255,255,255}, 596},

	{2290.98,2457.97,11.21, 0, fid=2, c={255,255,255,0,5,35}, 427},
	{2295.14,2444.48,11.21, 0, fid=2, c={255,255,255,0,5,35}, 427},

	{-28.84, -273.45, 5.5, 180, fid=3, c={255,255,255,255,0,0}, 407},
	{-22.51, -273.4,5.5, 180, fid=3, c={255,255,255,255,0,0}, 407},
	{-13.69, -273.4,5.5, 180, fid=3, c={255,255,255,255,0,0}, 407},
	{-2.81, -291.60,5.59, 90, fid=3, c={255,255,255,255,0,0}, 544},
	{-31.73, -290.24,5.45, 270, fid=3, c={255,255,255,255,0,0}, 407},
	{1751.75, 2070.74,11.07, 180, fid=3, c={255,255,255,255,0,0}, 407},
	{1770.37, 2072.38,11.07, 180, fid=3, c={255,255,255,255,0,0}, 407},
	{1764.39, 2069.11,11.37, 180, fid=3, c={255,255,255,255,0,0}, 544},
	{1758.51, 2068.71,11.36, 180, fid=3, c={255,255,255,255,0,0}, 544},
}

for i,v in ipairs(vehs) do
	v.pojazd = createVehicle(v[5],v[1],v[2],v[3],0,0,v[4])
	local c1,c2,c3,c4,c5,c6 = unpack(v.c)
	setVehicleColor(v.pojazd,c1,c2,c3,c4,c5,c6)
	setVehicleDamageProof(v.pojazd, true)
	toggleVehicleRespawn(v.pojazd, true)
	setElementData(v.pojazd, "veh:fid", tonumber(v.fid))
	setElementFrozen(v.pojazd, true)
end

local frakcje = {
      {1,"Lekarza"},
      {2,"Policjanta"},
      {3,"Strażaka"},
      {4,"Reportera"},
}

local function getNameByFID(fid)
	if (not fid) then return end
	for _,f in ipairs(frakcje) do
		if f[1] == fid then 
			return f[2]
		end
	end
end

function enterVehicle(player,seat,jacked)
	local vfid = getElementData(source, "veh:fid") or 0
	if (vfid<=0) then return end
	local pfid = getElementData(player,"faction:data") 
	if (not pfid or pfid and vfid ~= pfid.id) then 
		if seat == 0 then 
			local nazwa = getNameByFID(vfid)
			outputChatBox("Najpierw rozpocznij pracę "..nazwa..".", player)
			cancelEvent()
		end
	elseif (vfid == pfid.id and getElementModel(source) ==596) then 
		outputChatBox("Wpisz /komputer aby otworzyć listę poszukiwanych graczy.",player)
		setElementFrozen(source, false)
		setVehicleDamageProof(source, false)
	else
	setElementFrozen(source, false)
	setVehicleDamageProof(source, false)
end
end
addEventHandler("onVehicleStartEnter", getRootElement(), enterVehicle)
