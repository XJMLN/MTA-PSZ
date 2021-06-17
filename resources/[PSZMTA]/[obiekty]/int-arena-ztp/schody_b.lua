--[[
 <object id="object (cxref_woodstair) (1)" breakable="true" interior="0" alpha="255" model="3361" doublesided="false" scale="1" dimension="0" posX="288.70001" posY="107.8" posZ="13.08" rotX="0" rotY="0" rotZ="179.75"></object>
    <object id="object (cxref_woodjetty) (1)" breakable="true" interior="0" alpha="255" model="3406" doublesided="false" scale="1" dimension="0" posX="298.5" posY="107.8" posZ="13.1" rotX="0" rotY="0" rotZ="0"></object>
    <object id="object (cxref_woodjetty) (2)" breakable="true" interior="0" alpha="255" model="3406" doublesided="false" scale="1" dimension="0" posX="303.29999" posY="107.8" posZ="13.1" rotX="0" rotY="0" rotZ="0"></object>
]]--
local I = 52
local D = 21
local schody = {}
local marker = createMarker(308.46,105.04,12.9,"cylinder",1,255,51,21,150)
setElementDimension(marker,D)
setElementInterior(marker,I)

local tx = createElement("text")
	setElementDimension(tx,D)
	setElementInterior(tx,I)
	setElementPosition(tx,308.46,105.04,14.5)
	setElementData(tx,"text","Sterowanie schodami")

schody.s = createObject(3361, 288.70001,107.8,9.6,0,0,180)--13.08
schody.p1 = createObject(3406, 298.5,107.8,10,0,0,0) -- 13.1
schody.p2 = createObject(3406, 303.2999, 107.8, 10, 0,0,0) --13.1

setElementDimension(schody.s,D)
setElementDimension(schody.p1,D)
setElementDimension(schody.p2,D)
setElementInterior(schody.s,I)
setElementInterior(schody.p1,I)
setElementInterior(schody.p2,I)

schody.animacja = false
schody.dol = true

schody.na_gore=function()
	if (schody.animacja or not schody.dol) then return false end
	schody.animacja = true

	moveObject(schody.s,7000,288.70001,107.8,13.08,0,0,0)
	moveObject(schody.p1,7000,298.5,107.8,13.1,0,0,0)
	moveObject(schody.p2,7000,303.2999,107.7,13.1,0,0,0)

	setTimer(function() schody.animacja=false schody.dol=false end, 6000,1)
end

schody.na_dol=function()
	if (schody.animacja or schody.dol) then return false end
	schody.animacja = true

	moveObject(schody.s,7000,288.70001,107.8,9.6,0,0,0)
	moveObject(schody.p1,7000,298.5,107.8,10,0,0,0)
	moveObject(schody.p2,7000,303.2999,107.7,10,0,0,0)

	setTimer(function() schody.animacja=false schody.dol=true end, 6000,1)
end


schody.toggle=function(gracz)
	local lvl = getElementData(gracz,"level") or 0
	if (lvl and tonumber(lvl)==0) then 
		outputChatBox('Nie znasz hasła do sterownika.',gracz)
		return
	end

	if (schody.animacja) then 
		outputChatBox("Odczekaj chwilę.", gracz, 255,0,0,true)
		return
	end

	if (schody.dol) then 
		schody.na_gore()
	else
		schody.na_dol()
	end
end

function hit_marker(el,md)
	if (not md) then return end
	if getElementType(el) ~="player" then return end
	local lvl = getElementData(el,"level") or 0
	if (lvl and tonumber(lvl)==0) then 
		outputChatBox('Nie znasz hasła do sterownika.',el)
		return
	end
	schody.toggle(el)
	--outputChatBox("Trwa podnoszenie schodów...",el)
end

addEventHandler("onMarkerHit", marker, hit_marker)