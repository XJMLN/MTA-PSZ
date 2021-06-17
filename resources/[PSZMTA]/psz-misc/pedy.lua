local I = 85
local D = 666

local barman1 = createPed(171, -263.68, 2595.25, 71.54, 270, false)
	setElementInterior(barman1, I)
	setElementDimension(barman1, D)
	setElementData(barman1, "npc", true)
	setElementData(barman1, "name", "Barman")
	setElementFrozen(barman1, true)

local barman2 = createPed(171, -263.68,2591.99,71.54,270, false)
	setElementInterior(barman2, I)
	setElementDimension(barman2, D)
	setElementData(barman2, "npc", true)
	setElementData(barman2, "name", "Barman")
	setElementFrozen(barman2, true)

local ochrona1 = createPed(163, -252.22,2598.76,71.54, 90, false)
	setElementInterior(ochrona1, I)
	setElementDimension(ochrona1, D)
	setElementData(ochrona1, "npc", true)
	setElementData(ochrona1, "name", "Ochroniarz")
	setElementFrozen(ochrona1, true)

local ochrona2 = createPed(163, -252.06,2589.60,71.54, 90, false)
	setElementInterior(ochrona2, I)
	setElementDimension(ochrona2, D)
	setElementData(ochrona2, "npc", true)
	setElementData(ochrona2, "name", "Ochroniarz")
	setElementFrozen(ochrona2, true)