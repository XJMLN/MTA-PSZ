g_Root = getRootElement()
g_ResRoot = getResourceRootElement(getThisResource())
g_PlayerData = {}
g_VehicleData = {}
playerData = {}
serverData = {}
g_ArmedVehicles = {
	[425] = true,
	[447] = true,
	[520] = true,
	[430] = true,
	[464] = true,
	[432] = true
}
g_Trailers = {
	[606] = true,
	[607] = true,
	[610] = true,
	[590] = true,
	[569] = true,
	[611] = true,
	[584] = true,
	[608] = true,
	[435] = true,
	[450] = true,
	[591] = true
}
g_RPCFunctions = {
	addPedClothes = { option = 'clothes', descr = 'Modifying clothes' },
	addVehicleUpgrade = { option = 'upgrades', descr = 'Adding/removing upgrades' },
	fadeVehiclePassengersCamera = true,
	fixVehicle = { option = 'repair', descr = 'Repairing vehicles' },
	giveMeVehicles = { option = 'createvehicle', descr = 'Creating vehicles' },
	giveMeWeapon = { option = 'weapons.enabled', descr = 'Getting weapons' },
	givePedJetPack = { option = 'jetpack', descr = 'Getting a jetpack' },
	killPed = { option = 'kill', descr = 'Killing yourself' },
	removePedClothes = { option = 'clothes', descr = 'Modifying clothes' },
	removePedFromVehicle = true,
	removePedJetPack = { option = 'jetpack', descr = 'Removing a jetpack' },
	removeVehicleUpgrade = { option = 'upgrades', descr = 'Adding/removing upgrades' },
	setElementAlpha = { option = 'alpha', descr = 'Changing your alpha' },
	setElementPosition = true,
	setElementInterior = true,
	setMyGameSpeed = { option = 'gamespeed.enabled', descr = 'Setting game speed' },
	setMySkin = { option = 'setskin', descr = 'Setting skin' },
	setPedAnimation = { option = 'anim', descr = 'Setting an animation' },
	setPedFightingStyle = { option = 'setstyle', descr = 'Setting fighting style' },
	setPedGravity = { option = 'gravity.enabled', descr = 'Setting gravity' },
	setPedStat = { option = 'stats', descr = 'Changing stats' },
	setTime = { option = 'time.set', descr = 'Changing time' },
	setTimeFrozen = { option = 'time.freeze', descr = 'Freezing time' },
	setVehicleColor = true,
	setVehicleHeadLightColor = true,
	setVehicleOverrideLights = { option = 'lights', descr = 'Forcing lights' },
	setVehiclePaintjob = { option = 'paintjob', descr = 'Applying paintjobs' },
	setVehicleRotation = true,
	setWeather = { option = 'weather', descr = 'Setting weather' },
	spawnMe = true,
	warpMe = { option = 'warp', descr = 'Warping' }
}

g_OptionDefaults = {
	alpha = true,
	anim = true,
	clothes = true,
	createvehicle = true,
	gamespeed = {
		enabled = true,
		min = 0.0,
		max = 3
	},
	gravity = {
		enabled = true,
		min = 0,
		max = 0.1
	},
	jetpack = true,
	kill = true,
	lights = true,
	paintjob = true,
	repair = true,
	setskin = true,
	setstyle = true,
	spawnmaponstart = true,
	spawnmapondeath = true,
	stats = true,
	time = {
		set = true,
		freeze = true
	},
	upgrades = true,
	warp = true,
	weapons = {
		enabled = true,
		vehiclesenabled = true,
		disallowed = {}
	},
	weather = true,
	welcometextonstart = true,
	vehicles = {
		maxidletime = 9999999999999,
		idleexplode = true,
		maxperplayer = 2,
		disallowed = {}
	}
}
function isPlayerArenaPlayed(cel)
    local pvp = getElementData(cel,"solo:active")
	if (pvp) then return true else return false end
end

function isPlayerInAJ(cel)
    local aj = getElementData(cel,"kary:blokada_aj")
    if (aj) then return true else return false end
end

function isPlayerVIP(cel)
	local vip = getElementData(cel,"vip")
	if vip then return true else return false end
end

function isVehicleVIP(pojazd)
	if pojazd == 500 or pojazd == 424 or pojazd == 572 or pojazd == 461 or pojazd == 558 or pojazd == 451 then
		return true
	else
		return false
	end
end

function getOption(optionName)
	local option = get(optionName:gsub('%.', '/'))
	if option then
		if option == 'true' then
			option = true
		elseif option == 'false' then
			option = false
		end
		return option
	end
	option = g_OptionDefaults
	for i,part in ipairs(optionName:split('.')) do
		option = option[part]
	end
	return option
end

addEventHandler('onResourceStart', g_ResRoot,
	function()
		table.each(getElementsByType('player'), joinHandler)
	end
)

function joinHandler(player)
	if not player then
		player = source
	end
	local r, g, b = math.random(50, 255), math.random(50, 255), math.random(50, 255)
	setPlayerNametagColor(player, r, g, b)
	g_PlayerData[player] = { vehicles = {} }
	g_PlayerData[player].blip = createBlipAttachedTo(player, 0, 2, r, g, b)
	if g_FrozenTime then
		clientCall(player, 'setTimeFrozen', true, g_FrozenTime[1], g_FrozenTime[2], g_FrozenWeather)
	end
end
addEventHandler('onPlayerJoin', g_Root, joinHandler)

addEvent('onLoadedAtClient', true)
addEventHandler('onLoadedAtClient', g_ResRoot,
	function(player)
		if getOption('spawnmaponstart') and isPedDead(player) then
			clientCall(player, 'showWelcomeMap')
		end
	end,
	false
)

addEventHandler('onPlayerWasted', g_Root,
	function()
		if not getOption('spawnmapondeath') then
			return
		end
		local player = source
		setTimer(
			function()
				if isPedDead(player) then
					clientCall(player, 'showMap')
				end
			end,
			2000,
			1
		)
	end
)

addEvent('onClothesInit', true)
addEventHandler('onClothesInit', g_Root,
	function()
		local result = {}
		local texture, model
		-- get all clothes
		result.allClothes = {}
		local typeGroup, index
		for type=0,17 do
			typeGroup = {'group', type = type, name = getClothesTypeName(type), children = {}}
			table.insert(result.allClothes, typeGroup)
			index = 0
			texture, model = getClothesByTypeIndex(type, index)
			while texture do
				table.insert(typeGroup.children, {id = index, texture = texture, model = model})
				index = index + 1
				texture, model = getClothesByTypeIndex(type, index)
			end
		end
		-- get current player clothes { type = {texture=texture, model=model} }
		result.playerClothes = {}
		for type=0,17 do
			texture, model = getPedClothes(source, type)
			if texture then
				result.playerClothes[type] = {texture = texture, model = model}
			end
		end
		triggerClientEvent(source, 'onClientClothesInit', source, result)
	end
)

addEvent('onPlayerGravInit', true)
addEventHandler('onPlayerGravInit', g_Root,
	function()
		triggerClientEvent('onClientPlayerGravInit', source, getPedGravity(source))
	end
)
local function isPlayerInFaction(player)
	local f = getElementData(player,"faction:data") 
	if (f and f.id>0) then return true else return false end
end
function setMySkin(skinid)
	if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
    if skinid == 265 or skinid == 266 or skinid == 267 or skinid == 274 or skinid == 275 or skinid == 276 or skinid == 277 or skinid == 278 or skinid == 279 or skinid == 280 or skinid == 281 or skinid == 282 or skinid == 283 or skinid == 284 or skinid == 285 or skinid == 286 or skinid == 288 or skinid == 71 or skinid == 70 then return end
    if getElementDimension(source) == 2430 then
        outputChatBox("Zmiana skinu jest zablokowana na mapie eventowej.",source,255,0,0)
        return
    end
    if tonumber(skinid) ~= getElementModel(source) then
    if isPlayerInFaction(source) then 
        outputChatBox("Zostałeś/aś wyrzucony/a z pracy, z powodu zmiany skinu.",source,255,0,0)
        exports['psz-frakcje']:frakcje_playerStopJob(source,getElementData(source,"faction:data").id)
    end
    end
 	if skinid == 120 or skinid == 191 or skinid == 80 or skinid == 81 or skinid == 82 or skinid == 83 or skinid == 84 or skinid == 85 or skinid == 79 or skinid == 121 or skinid == 22 then
		if getElementData(source,"vip") then
			setElementModel(source, skinid)
		else
			outputChatBox("Ta opcja dostępna jest jedynie dla graczy VIP.",source,255,0,0)
			outputChatBox("Wpisz /vip i kup konto VIP bez wychodzenia z serwera.",source,255,0,0)
		end
	elseif skinid == 21 or skinid == 23 then 
		local uid = getElementData(source, "auth:uid")
		if (uid and tonumber(uid)==1 or uid and tonumber(uid)==426) then 
			setElementModel(source, skinid)
		else
			outputChatBox("Ten skin jest nie dostępny dla Ciebie.", source, 255,0,0)
		end
	else
	setElementModel(source,skinid)
end
end

function spawnMe(x, y, z)
	if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
	if not x then
		x, y, z = getElementPosition(source)
	end
	if isPedTerminated(source) then
		repeat until spawnPlayer(source, x, y, z, 0, math.random(9, 288))
	else
		spawnPlayer(source, x, y, z, 0, getPedSkin(source))
	end
	setCameraTarget(source, source)
	setCameraInterior(source, getElementInterior(source))
end

function warpMe(targetPlayer)
	if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
    if getElementDimension(source) == 2430 then
        outputChatBox("Używanie teleportacji jest zabronione na mapie eventowej.",source,255,0,0) 
        return
    end
    
	if isPedDead(source) then
		spawnMe()
	end

	local vehicle = getPedOccupiedVehicle(targetPlayer)
	if not vehicle then
		-- target player is not in a vehicle - just warp next to him
		local x, y, z = getElementPosition(targetPlayer)
		clientCall(source, 'setPlayerPosition', x + 2, y, z)
	else
		-- target player is in a vehicle - warp into it if there's space left
		if getPedOccupiedVehicle(source) then
			--removePlayerFromVehicle(source)
			outputChatBox('Wyjdź z pojazdu.', source)
			return
		end
		local numseats = getVehicleMaxPassengers(vehicle)
		for i=0,numseats do
			if not getVehicleOccupant(vehicle, i) then
				if isPedDead(source) then
					local x, y, z = getElementPosition(vehicle)
					spawnMe(x + 4, y, z + 1)
				end
				warpPedIntoVehicle(source, vehicle, i)
				return
			end
		end
		outputChatBox('Brak wolnych miejsc w pojeździe, gracza ' .. getPlayerName(targetPlayer) .. '.', source, 255, 0, 0)
	end
	local interior = getElementInterior(targetPlayer)
	setElementInterior(source, interior)
	setCameraInterior(source, interior)
end

function giveMeWeapon(weapon, amount)
	if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
    if getElementDimension(source) == 2430 then
        outputChatBox("Używanie teleportacji jest zabronione na mapie eventowej.",source,255,0,0) 
        return
    end
	if weapon and weapon > 50 then
		return
	end
	if table.find(getOption('weapons.disallowed'), weapon) then
		if weapon == nil then return end
		errMsg((getWeaponNameFromID(weapon) or tostring(weapon)) .. ' jest zablokowany.', source)
	else
		giveWeapon(source, weapon, amount, true)
	end
end

function giveMeVehicles(vehicles)
if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
    if getElementDimension(source) == 2430 then
        outputChatBox("Używanie teleportacji jest zabronione na mapie eventowej.",source,255,0,0) 
        return
    end
	if type(vehicles) == 'number' then
		vehicles = { vehicles }
	end

	local px, py, pz, prot
	local radius = 3
	local playerVehicle = getPedOccupiedVehicle(source)
	if playerVehicle and isElement(playerVehicle) then
		px, py, pz = getElementPosition(playerVehicle)
		prot, prot, prot = getVehicleRotation(playerVehicle)
	else
		px, py, pz = getElementPosition(source)
		prot = getPedRotation(source)
	end
	local offsetRot = math.rad(prot)
	local vx = px + radius * math.cos(offsetRot)
	local vy = py + radius * math.sin(offsetRot)
	local vz = pz + 2
	local vrot = prot

	local vehicleList = g_PlayerData[source].vehicles
	local vehicle
	if ( not vehicles ) then return end
		for i,vehID in ipairs(vehicles) do
			if i > getOption('vehicles.maxperplayer') then
				break
			end
			if vehID < 400 or vehID > 611 then
				errMsg('Podano złe ID pojazdu.', source)

			elseif not table.find(getOption('vehicles.disallowed'), vehID) then
				if #vehicleList >= getOption('vehicles.maxperplayer') then
					unloadVehicle(vehicleList[1])
				end
					if isVehicleVIP(vehID) and not getElementData(source,"vip") then
						outputChatBox("Ten pojazd jest dostępny tylko dla graczy VIP.",source,255,0,0)
						return
					end
					if getElementInterior(source) >0 then return end
					vehicle = createVehicle(vehID, vx, vy, vz, 0, 0, vrot)
					if (not isElement(vehicle)) then return end
					setElementDimension(vehicle, getElementDimension(source))
					table.insert(vehicleList, vehicle)
					setElementData(vehicle,"owner:by",getPlayerName(source))
					setElementData(vehicle,"fr_veh",true)
					g_VehicleData[vehicle] = { creator = source, timers = {} }
						if vehID == 464 then
							warpPedIntoVehicle(source, vehicle)
						elseif not g_Trailers[vehID] then
							--if getOption('vehicles.idleexplode') then
							--	g_VehicleData[vehicle].timers.fire = setTimer(commitArsonOnVehicle, getOption('vehicles.maxidletime'), 1, vehicle)
							--end
						--g_VehicleData[vehicle].timers.destroy = setTimer(unloadVehicle, getOption('vehicles.maxidletime') + (getOption('vehicles.idleexplode') and 10000 or 0), 1, vehicle)
					end -- vehid == 464
					vx = vx + 4
					vz = vz + 4
		else
			errMsg(getVehicleNameFromModel(vehID):gsub('y$', 'ie') .. ' został zablokowany', source)
		end -- vehid
	end -- for do
end --function

_setPlayerGravity = setPedGravity
function setPedGravity(player, grav)
	if isPlayerArenaPlayed(player) then return end
    if isPlayerInAJ(source) then return end
	if grav < getOption('gravity.min') then
		errMsg(('Minimum allowed gravity is %.5f'):format(getOption('gravity.min')), player)
	elseif grav > getOption('gravity.max') then
		errMsg(('Maximum allowed gravity is %.5f'):format(getOption('gravity.max')), player)
	else
		_setPlayerGravity(player, grav)
	end
end

function setMyGameSpeed(speed)
	if isPlayerArenaPlayed(source) then return end
    if isPlayerInAJ(source) then return end
	if speed < getOption('gamespeed.min') then
		errMsg(('Minimum allowed gamespeed is %.5f'):format(getOption('gamespeed.min')), source)
	elseif speed > getOption('gamespeed.max') then
		errMsg(('Maximum allowed gamespeed is %.5f'):format(getOption('gamespeed.max')), source)
	else
		clientCall(source, 'setGameSpeed', speed)
	end
end

function setTimeFrozen(state)

	if state then
		g_FrozenTime = { getTime() }
		g_FrozenWeather = getWeather()
		clientCall(g_Root, 'setTimeFrozen', state, g_FrozenTime[1], g_FrozenTime[2], g_FrozenWeather)
	else
		if g_FrozenTime then
			setTime(unpack(g_FrozenTime))
			g_FrozenTime = nil
			setWeather(g_FrozenWeather)
			g_FrozenWeather = nil
		end
		clientCall(g_Root, 'setTimeFrozen', state)
	end
end

function fadeVehiclePassengersCamera(toggle)
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle then
		return
	end
	local player
	for i=0,getVehicleMaxPassengers(vehicle) do
		player = getVehicleOccupant(vehicle, i)
		if player then
			fadeCamera(player, toggle)
		end
	end
end

addEventHandler('onVehicleEnter', g_Root,
	function(player, seat)
		if not g_VehicleData[source] then
			return
		end
		--if g_VehicleData[source].timers.fire then
			--killTimer(g_VehicleData[source].timers.fire)
			--g_VehicleData[source].timers.fire = nil
		--end
	--	if g_VehicleData[source].timers.destroy then
	--		killTimer(g_VehicleData[source].timers.destroy)
	--		g_VehicleData[source].timers.destroy = nil
	--	end
		if not getOption('weapons.vehiclesenabled') and g_ArmedVehicles[getElementModel(source)] then
			toggleControl(player, 'vehicle_fire', false)
			toggleControl(player, 'vehicle_secondary_fire', false)
		end
	end
)

addEventHandler('onVehicleExit', g_Root,
	function(player, seat)
		if not g_VehicleData[source] then
			return
		end
	--	if not g_VehicleData[source].timers.fire then
		--	for i=0,getVehicleMaxPassengers(source) or 1 do
			--	if getVehicleOccupant(source, i) then
		--			return
		--		end
			--end
		--	if getOption('vehicles.idleexplode') then
			--	g_VehicleData[source].timers.fire = setTimer(commitArsonOnVehicle, getOption('vehicles.maxidletime'), 1, source)
			--end
			--g_VehicleData[source].timers.destroy = setTimer(unloadVehicle, getOption('vehicles.maxidletime') + (getOption('vehicles.idleexplode') and 10000 or 0), 1, source)
	--	end
		if g_ArmedVehicles[getElementModel(source)] then
			toggleControl(player, 'vehicle_fire', true)
			toggleControl(player, 'vehicle_secondary_fire', true)
		end
	end
)

function commitArsonOnVehicle(vehicle)
	g_VehicleData[vehicle].timers.fire = nil
	setElementHealth(vehicle, 0)
end

function unloadVehicle(vehicle)
	if not g_VehicleData[vehicle] then
		return
	end
	for name,timer in pairs(g_VehicleData[vehicle].timers) do
		if isTimer(timer) then
			killTimer(timer)
		end
		g_VehicleData[vehicle].timers[name] = nil
	end
	local creator = g_VehicleData[vehicle].creator
	if g_PlayerData[creator] then
		table.removevalue(g_PlayerData[creator].vehicles, vehicle)
	end
	g_VehicleData[vehicle] = nil
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
end

function quitHandler(player)
	if type(player) ~= 'userdata' then
		player = source
	end
	if g_PlayerData[player].blip and isElement(g_PlayerData[player].blip) then
		destroyElement(g_PlayerData[player].blip)
	end
	table.each(g_PlayerData[player].vehicles, unloadVehicle)
	g_PlayerData[player] = nil
end
addEventHandler('onPlayerQuit', g_Root, quitHandler)

addEventHandler('onResourceStop', g_ResRoot,
	function()
		for player,data in pairs(g_PlayerData) do
			quitHandler(player)
		end
	end
)

addEvent('onServerCall', true)
addEventHandler('onServerCall', g_Root,
	function(fnName, ...)
		local fnInfo = g_RPCFunctions[fnName]
		if fnInfo and ((type(fnInfo) == 'boolean' and fnInfo) or (type(fnInfo) == 'table' and getOption(fnInfo.option))) then
			local fn = _G
			for i,pathpart in ipairs(fnName:split('.')) do
				fn = fn[pathpart]
			end
			fn(...)
		elseif type(fnInfo) == 'table' then
			errMsg(fnInfo.descr .. ' is not allowed', source)
		end
	end
)

function clientCall(player, fnName, ...)
	triggerClientEvent(player, 'onClientCall', g_ResRoot, fnName, ...)
end
--triggerServerEvent('checkplayers',localPlayer,x,y,z)
addEvent("checkplayers",true)
addEventHandler("checkplayers",root, function(x,y,z,type)
        local strefa = createColSphere(x,y,z,150)
        local strefa2 = createColSphere(x,y,z,500) 
        local c2
        c2 = ""
        local gracze2 = getElementsWithinColShape(strefa2,"player")
        for i,v in ipairs(gracze2) do
        	if (getElementInterior(v)==getElementInterior(source) and getElementDimension(v)==getElementDimension(source)) then
        		c2=c2..getPlayerName(v)..","
        	end
        end

        local c
        c = ""
        local gracze = getElementsWithinColShape(strefa, "player")
        for i,v in ipairs(gracze) do
            if (getElementInterior(v)==getElementInterior(source) and getElementDimension(v)==getElementDimension(source)) then
                c=c..getPlayerName(v)..","
                
            end
        end

       	 	--triggerClientEvent(source,"antyMKTimer", source, true)
        if (type == 1) then 
        	exports['psz-admin']:adminView_add("MAP-FR> "..getPlayerName(source)..", graczy w poblizu: "..#gracze.." ["..c.."], graczy w oddali: "..#gracze2.." ["..c2.."], koordy:"..x..","..y..','..z,2)
        elseif (type == 2) then
            exports['psz-admin']:adminView_add("MAP-BOK> "..getPlayerName(source)..", graczy w poblizu: "..#gracze.." ["..c.."], graczy w oddali: "..#gracze2.." ["..c2.."], koordy:"..x..","..y..','..z,2)
        end
        	destroyElement(strefa2)
            destroyElement(strefa) 
end)
