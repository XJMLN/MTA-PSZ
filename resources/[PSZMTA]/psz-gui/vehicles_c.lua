local blips={}
local REFRESH_INTERVAL=10000

local function odswiez()
	local pojazdy={}
	local c = getElementData(localPlayer,"character")
	if (c and c.gg_id) then 
		for i,v in ipairs(getElementsByType("vehicle")) do
			local dbid=tonumber(getElementData(v,"dbid"))
			local vgid = getElementData(v,"owning_gang") or 0
			if c.gg_id == vgid and dbid then 
				table.insert(pojazdy,{gid=vgid, element = v})
			end
		end

		for i,v in ipairs(pojazdy) do
			if v.gid == c.gg_id and not blips[v.element] then 
				if getElementDimension(v.element)~=getElementDimension(localPlayer) or getElementInterior(v.element)~=getElementDimension(localPlayer) then return end
				blips[v.element]=createBlipAttachedTo(v.element, 0, 1, 0,238,255, 255, 255)
				setElementData(blips[v.element], "upd", getTickCount())
			end
		end
	

		for i,v in ipairs(blips) do
			if (getTickCount()-getElementData(v,"upd")>(REFRESH_INTERVAL*2)) then
				destroyElement(v)
				blips[i]=nil
			end
		end
	end
end


setTimer(odswiez, REFRESH_INTERVAL, 0)



--[[
local pojazdy = {}
local c = getElementData(localPlayer,"character")
if (c and c.gg_id) then -- jesli jest w gangu, 
	for i,v in ipairs(getElementsByType("vehicle")) do
		local dbid = tonumber(getElementData(v,"dbid"))
		if c.gg_id == tonumber(getElementData())
]]