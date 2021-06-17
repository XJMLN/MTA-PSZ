local pojazdyPubliczne = {
	-- LS
	{2403.63,-1397.58,24.29,0,0,180,525, c1={29,24,48}, c2={255,242,35}}, -- towtruck
	{2411.55,-1405.74,24.35,0,0,90,525, c1={29,24,48}, c2={255,242,35}},
	{2411.42,-1412.87,24.31,0,0,90,525, c1={29,24,48}, c2={255,242,35}},
	{2403.56,-1420.34,24.21,0,0,182.0,525, c1={29,24,48}, c2={255,242,35}},
	-- SF 
	{-1630.48,1289.83,7.26,0,0,133,525, c1={29,24,48}, c2={255,242,35}}, -- towtruck
	{-1637.51,1296.83,7.24,0,0,133,525, c1={29,24,48}, c2={255,242,35}},
	-- LV
	{2048.15,2162.59,11.03,0,0,180,525, c1={29,24,48}, c2={255,242,35}}, -- towtruck
	{2036.40,2166.12,11.04,0,0,180,525, c1={29,24,48}, c2={255,242,35}},
	{2036.34,2175.55,11.03,0,0,180,525, c1={29,24,48}, c2={255,242,35}},
}

for i,v in ipairs(pojazdyPubliczne) do
	v.pojazd = createVehicle(v[7],v[1],v[2],v[3],v[4],v[5],v[6])
	setElementData(v.pojazd,"pojazd_spawn",true)
	setElementData(v.pojazd,"opis","Praca: Holowanie pojazdów")
	setTimer(function() setElementFrozen(v.pojazd,false) end,1000,1)
	local c1,c2,c3 = unpack(v.c1)
	local c4,c5,c6 = unpack(v.c2)
	toggleVehicleRespawn(v.pojazd,true)
	setVehicleIdleRespawnDelay(v.pojazd,15000)
	setVehicleRespawnPosition(v.pojazd,v[1],v[2],v[3],v[4],v[5],v[6])
	setVehicleColor(v.pojazd,c1,c2,c3,c4,c5,c6)

end


local function getVehOccupants(m) 
	local i = 0
	for _,v in pairs(getVehicleOccupants(m)) do
		i = i + 1
	end
	return i
end
function onExit()
    if (getElementData(source,"pojazd_spawn")) then
    	if getVehOccupants(source) == 0 then
    		setElementData(source,"opis","Praca: Holowanie pojazdów")
       	end
    end
end

function onEnter()
    if (getElementData(source,"pojazd_spawn")) then
    	removeElementData(source,"opis")
    end
end
addEventHandler("onVehicleExit",resourceRoot,onExit)
addEventHandler("onVehicleEnter",resourceRoot,onEnter)