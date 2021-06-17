--[[

reputacja: Zdobywanie respektu, zagubieni turysci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-reputacja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
-- Za co możemy zdobyć respekt:
	-- * Wykonywanie zadań importu (@TODO);
	-- * Praca w policji, straży pożarnej, szpitalu, mechaniku, psznews, DJ, na poczcie;
	-- * Wykonywanie stuntów (@TODO);
	-- * Odnajdywanie zagubionych osób (@done);
local ped_pos = {
	{name="Zagubiony turysta", -162.92,1171.46,19.74,150,258.4}, -- FC obok banku
	{name="Zagubiony turysta", -312.91,1296.31,53.66,218,257.3}, -- FC zajazd nad miasteczkiem
	{name="Zagubiony turysta", 127.60,1942.33,19.32,210,354.0}, -- Przed wjazdem na A69
	{name="Zagubiony turysta", -1941.83,2382.89,49.70,202,276.6}, -- Zajazd milena
	{name="Zagubiony turysta", -1705.43,1396.91,7.18,236,126.1}, -- SF port pier 
	{name="Zagubiony turysta", -2174.02,-1811.65,213.32,50,205.6}, -- Mount Chiliad tor wyczynowy
	{name="Zagubiony turysta", -1571.58,-2720.60,48.74,219,99.9}, -- AP autostrada zajazd moto
	{name="Zagubiony turysta", 148.54,-1807.07,3.74,249,279.1}, -- LS przy latarni
	{name="Zagubiony turysta", 2239.86,-82.36,26.50,120,359.6}, -- PC cmentarz
	{name="Zagubiony turysta", 1274.85,296.72,19.55,200,141.5}, -- Montgomery scieki entry
	{name="Zagubiony turysta", 2540.73,2270.58,10.82,202,83.4}, -- LV rock hotel
	{name="Zagubiony turysta", 2505.80,-1724.61,13.55,50,177.4}, -- LS przy Grove Street
	{name="Zagubiony turysta", 985.98,-1296.58,13.55,202,181.2}, -- LS Market
	{name="Zagubiony turysta", 492.54,-1362.04,17.37,219,24.8}, -- LS przy ubraniach
	{name="Zagubiony turysta", 412.74,-1503.31,31.43,202,47.9}, -- LS Rodero
}
local ped_anims = {
	{"CRACK", "crckidle4", -1, true, false},
	{ "BEACH", "ParkSit_M_loop", -1, true, false},
	{"COP_AMBIENT", "Coplook_loop", -1, true, false},
	{"DEALER", "DEALER_IDLE", -1, true, false},
	{"CRACK", "Bbalbat_Idle_01", -1, true, false},
	{"GHANDS", "gsign2", -1, true, false },
	{"KISSING", "gfwave2", -1, true, false},
}
local npcs = {}

local function rp_setAnimsForPed()
	if #npcs<1 then return end
	for i,v in ipairs(npcs) do
		local am1, am2, am3, am4, am5 = unpack(ped_anims[math.random(1, #ped_anims)])
		setPedAnimation(v, am1, am2, am3, am4, am5)
	end
end

local function rp_countPed()
	local count = 0
	for i,v in ipairs(ped_pos) do
		if (v.ped and isElement(v.ped)) then 
			count = count+1
		end
	end
	return count
end

local function rp_haveLowLevel()
	local cnt = 0
	for i,v in ipairs(ped_pos) do
		if (v.ped and isElement(v.ped)) then 
			cnt = cnt+1
			if (cnt>5) then return true end
		end
	end
	return cnt>5 and true or false
end

function rp_spawnAllPeds()
	i2 = 0
	for i,v in ipairs(ped_pos) do
		v.ped = createPed(v[4], v[1],v[2],v[3],v[5], false)
			setElementData(v.ped, "name", v.name)
			setElementData(v.ped,"npc",true)
			setElementData(v.ped,"special_ped",true)
			setElementFrozen(v.ped, true)
			table.insert(npcs, v.ped)
		v.colshape = createColSphere(v[1],v[2],v[3],1)
			setElementData(v.colshape, "reputacja_col", true)
			setElementParent(v.colshape, v.ped)
		i2 = i2+1
	end
	outputDebugString("Stworzono "..i2..", zagubionych NPC'tów.")
	setTimer(rp_setAnimsForPed, 1500, 1)
end

function rp_givePoints(el,ped)
	if (el and getElementType(ped)=="ped") then
	local br = getElementData(el,"bad_reputation")
	local gr = getElementData(el,"good_reputation")

	setElementData(el,"good_reputation",tonumber(gr)+1)

	local count = (getElementData(el,"bad_reputation"))+(getElementData(el,"good_reputation"))
		triggerClientEvent(el, "rp_showInfo", root, "Punkty reputacji zwiększone!", "Aktualna ilość reputacji:", count, 'up')
		for i,v in ipairs(npcs) do
			if v == ped then 
				table.remove(npcs,i)
				setElementModel(ped,0)
				destroyElement(ped)
			end
		end
	end
end

function rp_respawnPeds()
	if (rp_haveLowLevel()) then return end
	outputDebugString("Ilość specjalnych NPC'tów spadła poniżej 5, respawnowanie...")

	for i,v in ipairs(ped_pos) do
		if (not v.ped or not isElement(v.ped)) then 
			v.ped = createPed(v[4], v[1],v[2],v[3],v[5], false)
			setElementData(v.ped, "name", v.name)
			setElementData(v.ped,"npc",true)
			setElementData(v.ped,"special_ped",true)
			setElementFrozen(v.ped, true)
			table.insert(npcs, v.ped)
		v.colshape = createColSphere(v[1],v[2],v[3],1)
			setElementData(v.colshape, "reputacja_col", true)
			setElementParent(v.colshape, v.ped)
		end
	end
	outputDebugString("Respawnowanie specjalnych NPC'tów zakończone.")
end
setTimer(rp_respawnPeds, 60000*5,0)
rp_spawnAllPeds()


addEventHandler("onColShapeHit", root, function(el, md)
	if (getElementType(el) ~= "player") then return end
	if (not md) then return end
	local uid = getElementData(el,"auth:uid") 
	if (not uid) then return end
	if (getElementData(source,"reputacja_col")) then
		local ped = getElementParent(source)
		outputChatBox("Gratulacje, znalazłeś jedną z zaginionych osób!", el, 255,0,0) 
		exports['psz-admin']:gameView_add("ZTURYSTA gracz "..getPlayerName(el)..", odnajduje (ped)")
		rp_givePoints(el,ped)
	end
end)

function rp_plrKillPed(tAmmo, killer, killerWeapon, bodypart, stealth)
	local uid = getElementData(killer,"auth:uid")
	if (not uid) then return end
	local br = getElementData(killer,"bad_reputation")
	local gr = getElementData(killer,"good_reputation")
	setElementData(killer,"bad_reputation",tonumber(br)-1)
	local count = br+gr
	triggerClientEvent(killer, "rp_showInfo", root, "Punkty reputacji zmniejszone!", "Aktualna ilość reputacji:", count-1, 'down')
	for i,v in ipairs(npcs) do
		if v == source then 
			destroyElement(v)
			table.remove(npcs,i)
		end
	end
end


addEventHandler("onPedWasted", root, rp_plrKillPed)

--[[
function rp_givePointsPer15()
	local gracze = getElementsByType("player") or 0
	for i,v in ipairs(gracze) do
		if getElementData(v, "faction:id") then
			local c = getElementData(v,"character")
			if (c and c.reputacja) then 
				c.reputacja = c.reputacja + 1 
				setElementData(v,"character",c)
				triggerClientEvent(v,"rp_showInfo",root, "Punkty reputacji zwiększone!", "Aktualna ilość reputacji:", c.reputacja, 'up')
			end
		end
	end
end

setTimer(rp_givePointsPer15, 900000,0)

]]--