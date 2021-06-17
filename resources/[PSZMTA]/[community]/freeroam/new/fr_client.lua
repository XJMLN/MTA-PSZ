--[[

@author arc <wiki.multitheftauto.com/wiki/User:Arc

@author Jakub 'XJMLN' Starzak <xjmln.programming@gmail.com> - wersja aktualna pod serwer PSZMTA.PL


]]--

-- DEFS
CONTROL_MARGIN_RIGHT = 5 
LINE_MARGIN = 5
LINE_HEIGHT = 16

server = createServerCallInterface()

guiSetInputMode("no_binds_when_editing")

----------------------
-- Ustawianie skina
---------------------

function skinInit()
	setControlNumber(wndSkin, 'skinid', getElementModel(getLocalPlayer()))
end

function showSkinID(leaf)
	if leaf.id then 
		setControlNumber(wndSkin, 'skindid', leaf.id)
	end
end

function applySkin()	
	local skinID = getControlNumber(wndSkin, 'skinid')
	if skinID then 
		server.setMySkin(skinID)
		fadeCamera(true)
	end
end


wndSkin = {
	'wnd',
	text = 'Ustawianie skina',
	width = 250,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='skinlist',
			width=230,
			height=290,
			columns={
				{text='Skin', attr='name'},
				{text='VIP', attr='vip'},
			},
			rows={xml='skins.xml', attrs={'id','vip', 'name'}},
			onitemclick=showSkinID,
			onitemdoubleclick=applySkin
		},
		{'txt', id='skinid', text='', width=50},
		{'btn', id='set', onclick=applySkin},
		{'btn', id='close', closeswindow=true}
	},
	oncreate = skinInit
}

-------------------
-- Dodawanie broni
-------------------

function addWeapon(leaf, amount)
	if type(leaf) ~= 'table' then 
		leaf = getSelectedGridListLeaf(wndWeapon, 'weaplist')
		amount = getControlNumber(wndWeapon, 'amount')
		if not amount or not leaf then return end
	end
	server.giveMeWeapon(leaf.id, amount)
end

wndWeapon = {
	'wnd',
	text = 'Dodawanie broni',
	width = 250,
	controls = {
		{
			'lst',
			id='weaplist',
			width=230,
			height=280,
			columns={
				{text='Weapon', attr='name'}
			},
			rows={xml='weapons.xml', attrs={'id', 'name'}},
			onitemdoubleclick=function(leaf) addWeapon(leaf, 500) end
		},
		{'br'},
		{'txt', id='amount', text='500', width=60},
		{'btn', id='add', onclick=addWeapon},
		{'btn', id='close', closeswindow=true}
	}
}

--------------------------
-- Ustawianie ubrania CJ
--------------------------

function clothesInit()
	--@TODO: Dodanie sprawdzenia definicji do GM'a
	if getElementModel(getLocalPlayer()) ~= 0 then 
		errMsg("Musisz być w skinie CJ'a (ID 0), aby założyć ubrania.")
		closeWindow(wndClothes)
		return
	end
	if not g_Clothes then 
		triggerServerEvent("onClothesInit", getLocalPlayer())
	end
end

addEvent('onClientClothesInit', true)
addEventHandler('onClientClothesInit', getRootElement(),
	function(clothes)
		g_Clothes = clothes.allClothes
		for i,typeGroup in ipairs(g_Clothes) do
			for j,cloth in ipairs(typeGroup.children) do
				if not cloth.name then
					cloth.name = cloth.model .. ' - ' .. cloth.texture
				end
				cloth.wearing =
					clothes.playerClothes[typeGroup.type] and
					clothes.playerClothes[typeGroup.type].texture == cloth.texture and
					clothes.playerClothes[typeGroup.type].model == cloth.model
					or false
			end
			table.sort(typeGroup.children, function(a, b) return a.name < b.name end)
		end
		bindGridListToTable(wndClothes, 'clothes', g_Clothes, false)
	end
)

function clothListClick(cloth)
	setControlText(wndClothes, 'addremove', cloth.wearing and 'usuń' or 'dodaj')
end

function applyClothes(cloth)
if not cloth then
		cloth = getSelectedGridListLeaf(wndClothes, 'clothes')
		if not cloth then
			return
		end
	end
	if cloth.wearing then
		cloth.wearing = false
		setControlText(wndClothes, 'addremove', 'dodaj')
		server.removePedClothes(getLocalPlayer(), cloth.parent.type)
	else
		local prevClothIndex = table.find(cloth.siblings, 'wearing', true)
		if prevClothIndex then
			cloth.siblings[prevClothIndex].wearing = false
		end
		cloth.wearing = true
		setControlText(wndClothes, 'addremove', 'usuń')
		server.addPedClothes(getLocalPlayer(), cloth.texture, cloth.model, cloth.parent.type)
	end
end

wndClothes = {
	'wnd',
	text = 'Ubrania',
	x = -20,
	y = 0.3,
	width = 350,
	controls = {
		{
			'lst',
			id='clothes',
			width=330,
			height=390,
			columns={
				{text='Clothes', attr='name', width=0.6},
				{text='Wearing', attr='wearing', enablemodify=true, width=0.3}
			},
			rows={
				{name='Pobieranie listy z serwera...'}
			},
			onitemclick=clothListClick,
			onitemdoubleclick=applyClothes
		},
		{'br'},
		{'btn', text='dodaj', id='addremove', width=60, onclick=applyClothes},
		{'btn', id='close', closeswindow=true}
	},
	oncreate = clothesInit
}

-----------------------
-- Ustawianie statystyk
-----------------------
function initStats()
	--@TODO: Dodanie sprawdzenia definicji do GM'a
	applyToLeaves(getGridListCache(wndStats, 'statslist'), function(leaf) leaf.value = getPedStat(getLocalPlayer(), leaf.id) end)
end


function selectStat(leaf)
	setControlNumber(wndStats, 'statval', leaf.value)
end

function maxStat(leaf)
	setControlNumber(wndStats, 'statval', 1000)
	applyStat()
end

function applyStat()
	local leaf = getSelectedGridListLeaf(wndStats, 'statslist')
	if not leaf then
		return
	end
	local value = getControlNumber(wndStats, 'statval')
	if not value then
		return
	end
	leaf.value = value
	server.setPedStat(getLocalPlayer(), leaf.id, value)
end

wndStats = {
	'wnd',
	text = 'Statystyki postaci',
	width = 300,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='statslist',
			width=280,
			columns={
				{text='Stat', attr='name', width=0.6},
				{text='Value', attr='value', width=0.3, enablemodify=true}
			},
			rows={xml='stats.xml', attrs={'name', 'id'}},
			onitemclick=selectStat,
			onitemdoubleclick=maxStat
		},
		{'txt', id='statval', text='', width=60},
		{'btn', id='set', onclick=applyStat},
		{'btn', id='close', closeswindow=true}
	},
	oncreate = initStats
}

-------------------
-- Teleportacja przez mape
-------------------

do
	local screenWidth, screenHeight = guiGetScreenSize()
	g_MapSide = (screenHeight * 0.85)
end

function setPosInit()
	--@TODO: Dodanie definicji sprawdzających do GM'a
	local x, y, z = getElementPosition(getLocalPlayer())
	setControlNumbers(wndSetPos, { x = x, y = y, z = z })
	
	local xEdit = getControl(wndSetPos,'x')
	local yEdit = getControl(wndSetPos,'y')
	local zEdit = getControl(wndSetPos,'z')

	guiEditSetReadOnly(xEdit, true) guiEditSetReadOnly(yEdit, true) guiEditSetReadOnly(zEdit, true)
	addEventHandler('onClientRender', getRootElement(), updatePlayerBlips)
end

function fillInPosition(relX, relY, btn)
	if (btn == 'right') then
		closeWindow (wndSetPos)
		return
	end

	local x = relX*6000 - 3000
	local y = 3000 - relY*6000
	local hit, hitX, hitY, hitZ
	hit, hitX, hitY, hitZ = processLineOfSight(x, y, 3000, x, y, -3000)
	setControlNumbers(wndSetPos, { x = x, y = y, z = hitZ or 0 })
end

function setPosClick()
	--@TODO: Dodanie definicji sprawdzających do GM'a
	setPlayerPosition(getControlNumbers(wndSetPos, {'x', 'y', 'z'}))
	closeWindow(wndSetPos)
end
function setPlayerPosition(x, y, z)
	local elem = getPedOccupiedVehicle(getLocalPlayer())
	local distanceToGround
	local isVehicle
	--@TODO: Dodanie definicji sprawdzających do GM'a
   -- local blokada = getElementData(localPlayer,"kary:blokada_mk")
   -- if isPlayerArenaPlayed(localPlayer) then return end
   -- if isPlayerInAJ(g_Me) then return end
  --  if (blokada) then outputChatBox("Posiadasz blokadę na teleportację.") return end
  --  if getElementDimension(localPlayer) == 2430 then
   -- --    outputChatBox('Używanie teleportacji jest zablokowane na mapie eventowej.',255,0,0)
        return
  -- end
	if elem then
		if getPlayerOccupiedSeat(getLocalPlayer()) ~= 0 then
			errMsg('Tylko kierowca może ustawiać pozycję.')
			return
		end
		distanceToGround = getElementDistanceFromCentreOfMassToBaseOfModel(elem) + 3
		isVehicle = true
	else
		elem = getLocalPlayer()
		distanceToGround = 0.4
		isVehicle = false
	end
	local hit, hitX, hitY, hitZ = processLineOfSight(x, y, 3000, x, y, -3000)
	if not hit then
		if isVehicle then
			server.fadeVehiclePassengersCamera(false)
		else
			fadeCamera(false)
		end
		setTimer(setCameraMatrix, 1000, 1, x, y, z)
		if g_TeleportTimer then killTimer(g_TeleportTimer) end
		g_TeleportTimer = setTimer(
			function()
				local hit, groundX, groundY, groundZ = processLineOfSight(x, y, 3000, x, y, -3000)
				if hit then
					local waterZ = getWaterLevel(x, y, 100)
					z = (waterZ and math.max(groundZ, waterZ) or groundZ) + distanceToGround
					if isPedDead(getLocalPlayer()) then
						server.spawnMe(x, y, z)
					else
						setElementPosition(elem, x, y, z)
						setElementData(localPlayer, "fr:map_used", true)
                        triggerServerEvent('checkplayers',localPlayer,x,y,z,1)

					end
                    
					setCameraPlayerMode()
					if isVehicle then
						server.fadeVehiclePassengersCamera(true)
					else
						fadeCamera(true)
					end
					killTimer(g_TeleportTimer)
					g_TeleportTimer = nil
				end
			end,
			500,
			0
		)
	else
		if isPedDead(getLocalPlayer()) then
			server.spawnMe(x, y, z + distanceToGround)
		else
			setElementPosition(elem, x, y, z + distanceToGround)
			if isVehicle then
				setTimer(setElementVelocity, 100, 1, elem, 0, 0, 0)
				setTimer(setVehicleTurnVelocity, 100, 1, elem, 0, 0, 0)
			end
		end
	end
end

function updatePlayerBlips()
	if not g_PlayerData then
		return
	end
	local wnd = isWindowOpen(wndSpawnMap) and wndSpawnMap or wndSetPos
	local mapControl = getControl(wnd, 'map')
	for elem,player in pairs(g_PlayerData) do
		if not player.gui.mapBlip then
			player.gui.mapBlip = guiCreateStaticImage(0, 0, 9, 9, elem == getLocalPlayer() and 'localplayerblip.png' or 'playerblip.png', false, mapControl)
			player.gui.mapLabelShadow = guiCreateLabel(0, 0, 100, 14, string.gsub(player.name,"#%x%x%x%x%x%x",""), false, mapControl)
			local labelWidth = guiLabelGetTextExtent(player.gui.mapLabelShadow)
			guiSetSize(player.gui.mapLabelShadow, labelWidth, 14, false)
			guiSetFont(player.gui.mapLabelShadow, 'default-bold-small')
			guiLabelSetColor(player.gui.mapLabelShadow, 255, 255, 255)
			player.gui.mapLabel = guiCreateLabel(0, 0, labelWidth, 14, string.gsub(player.name,"#%x%x%x%x%x%x",""), false, mapControl)
			guiSetFont(player.gui.mapLabel, 'default-bold-small')
			guiLabelSetColor(player.gui.mapLabel, 0, 0, 0)
			for i,name in ipairs({'mapBlip', 'mapLabelShadow'}) do
				addEventHandler('onClientGUIDoubleClick', player.gui[name],
					function()
						server.warpMe(elem)
						closeWindow(wnd)
					end,
					false
				)
			end
		end
		local x, y = getElementPosition(elem)
		x = math.floor((x + 3000) * g_MapSide / 6000) - 4
		y = math.floor((3000 - y) * g_MapSide / 6000) - 4
		guiSetPosition(player.gui.mapBlip, x, y, false)
		guiSetPosition(player.gui.mapLabelShadow, x + 14, y - 4, false)
		guiSetPosition(player.gui.mapLabel, x + 13, y - 5, false)
	end
end

addEventHandler('onClientPlayerChangeNick', getRoootElement(),
	function(oldNick, newNick)
		if (not g_PlayerData) then return end
		local player = g_PlayerData[source]
		player.name = string.gsub(newNick,"#%x%x%x%x%x%x","")
		if player.gui.mapLabel then
			guiSetText(player.gui.mapLabelShadow, newNick)
			guiSetText(player.gui.mapLabel, newNick)
			local labelWidth = guiLabelGetTextExtent(player.gui.mapLabelShadow)
			guiSetSize(player.gui.mapLabelShadow, labelWidth, 14, false)
			guiSetSize(player.gui.mapLabel, labelWidth, 14, false)
		end
	end
)

function closePositionWindow()
	removeEventHandler('onClientRender', getRootElement(), updatePlayerBlips)
end

wndSetPos = {
	'wnd',
	text = 'Set position',
	width = g_MapSide + 20,
	controls = {
		{'img', id='map', src='map.png', width=g_MapSide, height=g_MapSide, onclick=fillInPosition, ondoubleclick=setPosClick},
		{'txt', id='x', text='', width=60},
		{'txt', id='y', text='', width=60},
		{'txt', id='z', text='', width=60},
		{'btn', id='ok', onclick=setPosClick},
		{'btn', id='cancel', closeswindow=true},
		{'lbl', text='PPM aby zamknąć'}
	},
	oncreate = setPosInit,
	onclose = closePositionWindow
}

----------------------
-- Tworzenie pojazdów
----------------------

function createSelectedVehicle(leaf)
	if not leaf then
		leaf = getSelectedGridListLeaf(wndCreateVehicle, 'vehicles')
		if not leaf then
			return
		end
	end
	server.giveMeVehicles(leaf.id)
end

wndCreateVehicle = {
	'wnd',
	text = 'Tworzenie pojazdu',
	width = 300,
	controls = {
		{
			'lst',
			id='vehicles',
			width=280,
			height=340,
			columns={
				{text='Vehicle', attr='name'},
				{text='VIP', attr='vip'},
			},
			rows={xml='vehicles.xml', attrs={'id','vip', 'name'}},
			onitemdoubleclick=createSelectedVehicle
		},
		{'btn', id='create', onclick=createSelectedVehicle},
		{'btn', id='close', closeswindow=true}
	}
}

-----------------
-- Tuning pojazdu
-----------------
function upgradesInit()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if not vehicle then
		errMsg('Nie znajdujesz się w pojeździe')
		closeWindow(wndUpgrades)
		return
	end
--@TODO: Dodanie sprawdzenia definicji do GM'a
	local installedUpgrades = getVehicleUpgrades(vehicle)
	local compatibleUpgrades = {}
	local slotName, group
	for i,upgrade in ipairs(getVehicleCompatibleUpgrades(vehicle)) do
		slotName = getVehicleUpgradeSlotName(upgrade)
		group = table.find(compatibleUpgrades, 'name', slotName)
		if not group then
			group = { 'group', name = slotName, children = {} }
			table.insert(compatibleUpgrades, group)
		else
			group = compatibleUpgrades[group]
		end
		table.insert(group.children, { id = upgrade, installed = table.find(installedUpgrades, upgrade) ~= false })
	end
	table.sort(compatibleUpgrades, function(a, b) return a.name < b.name end)
	bindGridListToTable(wndUpgrades, 'upgradelist', compatibleUpgrades, true)
end

function selectUpgrade(leaf)
	setControlText(wndUpgrades, 'addremove', leaf.installed and 'remove' or 'add')
end

function addRemoveUpgrade(selUpgrade)
	-- Add or remove selected upgrade
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if not vehicle then
		return
	end
	
	if not selUpgrade then
		selUpgrade = getSelectedGridListLeaf(wndUpgrades, 'upgradelist')
		if not selUpgrade then
			return
		end
	end
	
	if selUpgrade.installed then
		-- remove upgrade
		selUpgrade.installed = false
		setControlText(wndUpgrades, 'addremove', 'add')
		server.removeVehicleUpgrade(vehicle, selUpgrade.id)
	else
		-- add upgrade
		local prevUpgradeIndex = table.find(selUpgrade.siblings, 'installed', true)
		if prevUpgradeIndex then
			selUpgrade.siblings[prevUpgradeIndex].installed = false
		end
		selUpgrade.installed = true
		setControlText(wndUpgrades, 'addremove', 'remove')
		server.addVehicleUpgrade(vehicle, selUpgrade.id)
	end
end

wndUpgrades = {
	'wnd',
	text = 'Tuning pojazdu',
	width = 300,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='upgradelist',
			width=280,
			height=340,
			columns={
				{text='Upgrade', attr='id', width=0.6},
				{text='Installed', attr='installed', width=0.3, enablemodify=true}
			},
			onitemclick=selectUpgrade,
			onitemdoubleclick=addRemoveUpgrade
		},
		{'btn', id='addremove', text='add', width=60, onclick=addRemoveUpgrade},
		{'btn', id='ok', closeswindow=true}
	},
	oncreate = upgradesInit
}

--------------------
-- Malowanie pojazdu
--------------------
function openColorPicker()
	editingVehicle = getPedOccupiedVehicle(localPlayer)
	if (editingVehicle) then
        --@TODO: Dodanie sprawdzenia definicji do GM'a
		colorPicker.openSelect(colors)
	end
end

function closedColorPicker()
	local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
	server.setVehicleColor(editingVehicle, r1, g1, b1, r2, g2, b2)
	local r, g, b = getVehicleHeadLightColor(editingVehicle)
	server.setVehicleHeadLightColor(editingVehicle, r, g, b)
	editingVehicle = nil
end

function updateColor()
	if (not colorPicker.isSelectOpen) then return end
	local r, g, b = colorPicker.updateTempColors()
	if (editingVehicle and isElement(editingVehicle)) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
		if (guiCheckBoxGetSelected(checkColor1)) then
			r1, g1, b1 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor2)) then
			r2, g2, b2 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor3)) then
			setVehicleHeadLightColor(editingVehicle, r, g, b)
		end
		setVehicleColor(editingVehicle, r1, g1, b1, r2, g2, b2)
	end
end
addEventHandler("onClientRender", root, updateColor)

------------------
-- Grafika pojazdu
------------------
function paintjobInit()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if not vehicle then
		errMsg('Musisz znajdować się w pojeździe')
		closeWindow(wndPaintjob)
		return
	end
	--@TODO: Dodanie sprawdzenia definicji do GM'a
	local paint = getVehiclePaintjob(vehicle)
	if paint then
		guiGridListSetSelectedItem(getControl(wndPaintjob, 'paintjoblist'), paint+1, 1)
	end
end

function applyPaintjob(paint)
	server.setVehiclePaintjob(getPedOccupiedVehicle(getLocalPlayer()), paint.id)
end

wndPaintjob = {
	'wnd',
	text = 'Car paintjob',
	width = 220,
	x = -20,
	y = 0.3,
	controls = {
		{
			'lst',
			id='paintjoblist',
			width=200,
			height=130,
			columns={
				{text='Paintjob ID', attr='id'}
			},
			rows={
				{id=0},
				{id=1},
				{id=2},
				{id=3}
			},
			onitemclick=applyPaintjob,
			ondoubleclick=function() closeWindow(wndPaintjob) end
		},
		{'btn', id='close', closeswindow=true},
	},
	oncreate = paintjobInit
}
-------------------
-- Komendy gracza
-------------------

function setSkinCommand(cmd, skin)
	skin = skin and tonumber(skin)
	if skin then 
		server.setMySkin(skin)
		fadeCamera(true)
		closeWindow(wndSpawnMap)
		closeWindow(wndSetPos)
	end
end
addCommandHandler("ss", setSkinCommand)

function setFightStyle(cmd, style)
	--@TODO: Dodanie sprawdzenia definicji do GM'a
	style = style and tonumber(style)
	if style then
		server.setPedFightingStyle(getLocalPlayer(),style)
	end
end
addCommandHandler("setstyle", setFightStyle)

function toggleJetPack()
	--@TODO: Dodanie sprawdzenia definicji do GM'a
	if not doesPedHaveJetPack(getLocalPlayer()) then
		server.givePedJetPack(getLocalPlayer())
	else
		server.removePedJetPack(getLocalPlayer())
	end
end

bindKey('j', 'down', toggleJetPack)

addCommandHandler('jetpack', toggleJetPack)
addCommandHandler('jp', toggleJetPack)

function createVehicleCommand(cmd, ...)
	local vehID
	local vehiclesToCreate = {}
	local args = { ... }
	for i,v in ipairs(args) do
		vehID = tonumber(v)
		if not vehID then
			vehID = getVehicleModelFromName(v)
		end
		if vehID then
			table.insert(vehiclesToCreate, math.floor(vehID))
		end
	end
	server.giveMeVehicles(vehiclesToCreate)
end
addCommandHandler('cv', createVehicleCommand)

function repairVehicle()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if vehicle then
        --@TODO: Dodanie sprawdzenia definicji do GM'a
		server.fixVehicle(vehicle)
	end
end

addCommandHandler('repair', repairVehicle)
addCommandHandler('rp', repairVehicle)

function flipVehicle()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if vehicle then
		--@TODO: Dodanie sprawdzenia definicji do GM'a
		local rX, rY, rZ = getElementRotation(vehicle)
		server['set' .. 'VehicleRotation'](vehicle, 0, 0, (rX > 90 and rX < 270) and (rZ + 180) or rZ)
	end
end

addCommandHandler('flip', flipVehicle)
addCommandHandler('f', flipVehicle)