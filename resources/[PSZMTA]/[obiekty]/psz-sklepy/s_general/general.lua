--[[
983.70,-1304.33,13.38,340.9

]]--
local sklepy = {}

local function zaladujOferte(id, npc)
	local q = string.format("SELECT so.itemID,so.itemName,so.itemType,so.buyprice,so.sellprice FROM psz_shops_offers so WHERE so.shop_id=%d",id)
	local oferta = exports['psz-mysql']:pobierzTabeleWynikow(q)
	setElementData(npc,"shop_offer", oferta)
end

local function loadNPC(id)
	local q = string.format("SELECT * FROM psz_shops_npc WHERE shop_id=%d", tonumber(id))
	local dane = exports['psz-mysql']:pobierzTabeleWynikow(q)
	if (not dane) then return nil end
	local npcs = {}
	for i,v in ipairs(dane) do

		v.pozycja=split(v.pozycja,",")
    	for ii,vv in ipairs(v.pozycja) do		v.pozycja[ii]=tonumber(vv)	end

		local npc = createPed(tonumber(v.skin),v.pozycja[1], v.pozycja[2], v.pozycja[3], tonumber(v.angle),false)
		setElementInterior(npc, tonumber(v.interior))
		setElementDimension(npc, tonumber(v.vw))
		setElementData(npc,"npc",true)
		setElementData(npc,"name",v.name)
		setElementFrozen(npc, true)

		local rrz=math.rad(tonumber(v.angle)+180)
		local x2= tonumber(v.pozycja[1] - (2 * math.sin(-rrz)))
		local y2= tonumber(v.pozycja[2] - (2 * math.cos(-rrz)))
		local strefa=createColSphere(x2,y2,tonumber(v.pozycja[3]),1)
		setElementDimension(strefa, tonumber(v.vw))
		setElementInterior(strefa, tonumber(v.interior))
		setElementParent(strefa, npc)

		zaladujOferte(id,npc)
		table.insert(npcs,npc)
	end
	return npcs
end

local function oczyscSklep(id)
	if (not sklepy[id]) then return false end
	destroyElement(sklepy[id].text3d)
	destroyElement(sklepy[id].marker)
	destroyElement(sklepy[id].blip)
	destroyElement(sklepy[id].e_marker)
	for i,v in ipairs(sklepy[id].npcs) do
		for i2, v2 in ipairs(getElementChildren(v)) do
			destroyElement(v2)
		end
		destroyElement(v)
	end
	sklepy[id]=nil
	return true
end

local function utworzSklep(v)
	local id=tonumber(v.id)
	if (sklepy[id]) then
		oczyscSklep(id)
	end
	v.id = tonumber(v.id)

	v.drzwi=split(v.drzwi,",")
	for ii,vv in ipairs(v.drzwi) do v.drzwi[ii]=tonumber(vv) end
	
	v.punkt_wyjscia=split(v.punkt_wyjscia,",")
	for ii,vv in ipairs(v.punkt_wyjscia) do v.punkt_wyjscia[ii]=tonumber(vv) end

	v.i_entrance=split(v.i_entrance,",")
	for ii,vv in ipairs(v.i_entrance) do v.i_entrance[ii]=tonumber(vv) end

	v.i_exit=split(v.i_exit,",")
	for ii,vv in ipairs(v.i_exit) do v.i_exit[ii]=tonumber(vv) end

	sklepy[id]=v

	sklepy[id].text3d = createElement("text")
	setElementPosition(sklepy[id].text3d, v.drzwi[1], v.drzwi[2], v.drzwi[3])
	setElementData(sklepy[id].text3d, "text", v.descr)

	sklepy[id].marker=createMarker(v.drzwi[1],v.drzwi[2],v.drzwi[3]+0.51,"arrow", 1, 255,0,0,100)
	sklepy[id].blip=createBlip(v.drzwi[1],v.drzwi[2],v.drzwi[3], 0, 1, 5, 105, 255, 155, -1000, 200)
	
	sklepy[id].e_marker=createMarker(tonumber(v.i_exit[1]), tonumber(v.i_exit[2]), tonumber(v.i_exit[3])+0.51, "arrow", 1, 255,0,0,100)
	setElementInterior(sklepy[id].e_marker, v.i_i)
	setElementDimension(sklepy[id].e_marker, v.i_d)
	setElementData(sklepy[id].e_marker, "sklep:tpto", v.punkt_wyjscia)
	sklepy[id].cs = createColSphere(v.drzwi[1], v.drzwi[2], v.drzwi[3], 1)
	setElementData(sklepy[id].cs,"sklep",v)

	sklepy[id].npcs=loadNPC(id)
end

do
	local q = "SELECT s.id, s.descr, s.drzwi, s.punkt_wyjscia, i.interior i_i, i.dimension i_d, i.entrance i_entrance, i.exit i_exit, s.zamkniety, s.updated FROM psz_shops s JOIN psz_interiory i ON i.id=s.interiorid"
	local wyniki = exports['psz-mysql']:pobierzTabeleWynikow(q)
	for i, v in ipairs(wyniki) do
		utworzSklep(v)
	end
end

addEventHandler("onMarkerHit", resourceRoot, function(el, md)
	if (getElementType(el)~="player") then return end
	if (not md) then return end

	local tpto = getElementData(source, "sklep:tpto")
	if (tpto) then
		setElementPosition(el, tpto[1]+math.random(-5,5)/10, tpto[2]+math.random(-5,5)/10, tpto[3])
		setPedRotation(el, tpto[4])
    	setElementInterior(el, 0)
    	setElementDimension(el, 0)
    end
end)

addEvent("movePlayerToInterior", true)
addEventHandler("movePlayerToInterior", resourceRoot, function(plr, budynek)

  setElementPosition(plr, budynek.i_entrance[1]+math.random(-5,5)/10, budynek.i_entrance[2]+math.random(-5,5)/10, budynek.i_entrance[3])
  setElementInterior(plr, budynek.i_i)
  setElementDimension(plr, budynek.i_d or 1000+budynek.id)
  setPedRotation(plr, budynek.i_entrance[4])
  if (budynek.radio) and (budynek.radio~="") then triggerClientEvent("startBiznesSound", getRootElement(), plr, budynek.radio) end
  
end)