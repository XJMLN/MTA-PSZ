--[[

Import - import pojazdow (praca)

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-import
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

miejsca_importu = {
	Lossantos = {
		nazwa = "Port Los Santos",
		receiver_pos = {2270.27,-2494.91,6.84}
	},

	Sanfierro = {
		nazwa = "Port San Fierro",
		receiver_pos = {-1613.06,92.83,2.55}
	},
	bayside = {
		nazwa = "Port Bayside Marina",
		receiver_pos = {-2256.98,2384.33,4.01}
	},
}

local importowanePojazdy = {496, 516, 517, 401, 410, 518, 600, 527, 436, 419, 439, 533, 549, 526,
491, 474, 445, 426, 507, 547, 585, 405, 466, 492, 566, 540, 551, 421,
529, 420, 499, 609, 498, 422, 414, 531, 456, 543, 482, 554, 418, 413,
536, 575, 567, 535, 576, 412, 402, 542, 603, 475, 495, 508, 500,
559, 561, 480, 560, 565, 558, 555, 579, 400, 404, 489, 479, 610, 611}
local wybrane = {}
for i,v in pairs(miejsca_importu) do 
	if v.receiver_pos then 
		v.marker_rec = createMarker(v.receiver_pos[1], v.receiver_pos[2], v.receiver_pos[3], "cylinder", 3, 0,0,0,200)
			setElementData(v.marker_rec, "typ", "receiver")
			setElementData(v.marker_rec, "import", i)
	end
	if v.nazwa then 
		v.text = createElement("text")
		setElementData(v.text, "text", tostring(v.nazwa))
		setElementPosition(v.text, v.receiver_pos[1], v.receiver_pos[2], v.receiver_pos[3]+2.5)
	end

	v.blip = createBlip(v.receiver_pos[1], v.receiver_pos[2], v.receiver_pos[3], 9, 2, 255,0,0,255,0,1000)
end

local function pojazdImportowalny(vid)
	if (getVehicleType(vid)~="Automobile") then return false end
	for i, v in ipairs(wybrane) do
		if (v==vid) then return true end
	end
	return false
end

local txt = ""
local function import_sendInfo()
	if (#wybrane<1) then return end
	for i,v in ipairs(wybrane) do
		if (i==5) then break
		else
			txt = string.format("%s %s,", txt, getVehicleNameFromModel(v))
		end
	end
end

local function import_createList()
	if (#importowanePojazdy<0) then return end -- jesli w tabeli jest 0 pojazdow, nie mieszamy jej

	for _,pojazd in ipairs(importowanePojazdy) do
		table.insert(wybrane, pojazd)
	end

	if (#wybrane<1) then return end
	outputDebugString("Nastąpiła zmiana listy pojazdów do importu!")

	shuffle(wybrane)
	import_sendInfo();
end
import_createList()

addEventHandler("onMarkerHit", resourceRoot, function(el, md)
	if (getElementType(el)~="vehicle" or not md) then return end
	local kierowca = getVehicleController(el)
	if (not kierowca) then return end
	local pojazd = getVehicleTowedByVehicle(el)
	if (not pojazd) then return end
	if (not pojazdImportowalny(getElementModel(pojazd))) then 
		outputChatBox("Importer: Tego pojazdu nie potrzebuję, przyjedź tutaj następującymi pojazdami: ", kierowca)
		outputChatBox(txt, kierowca)
		return 
	end
	outputChatBox("Importer: Dzięki za auto! Możesz przyjechać tutaj jeszcze z następującymi pojazdami: ", kierowca)
	outputChatBox(txt, kierowca)
	destroyElement(pojazd)
	givePlayerMoney(kierowca,10)
end)

--[[
CO 24H mieszamy tabelke - 5 pierwszych idzie na koniec, w ten sposób codziennie będziemy mieć 3 różne pojazdy do importu

Mamy juz pojazdy, teraz jakies info dla graczy
]]--