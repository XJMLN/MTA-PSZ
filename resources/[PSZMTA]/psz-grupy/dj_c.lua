--[[

Grupy: Praca jako DJ

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-grupy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local rozpoczecie_pracy = {
	{476.65,-12.49,1002.70,17,0, fid=6},-- dj
}

local ilosc = {}
local textElement = nil

for i,v in ipairs(rozpoczecie_pracy) do
	v.marker = createMarker(v[1],v[2],v[3],"cylinder", 1, 255,255,255,120)
	setElementInterior(v.marker,v[4])
	setElementDimension(v.marker,v[5])
	setElementData(v.marker, "f:marker", tonumber(v.fid))
end

local function getmrp(plr)
	for i,v in ipairs(rozpoczecie_pracy) do
		if (v.marker == plr) then return v end 
	end
	return nil
end

addEventHandler("onClientMarkerHit", resourceRoot, function(plr, md)
	if (plr ~= localPlayer or not md) then return end
	if (getElementInterior(source)~=getElementInterior(localPlayer)) then return end
	local fid = getElementData(source,"f:marker")
	if (not fid) then return end

	local _,_,z1 = getElementPosition(plr)
	local _,_,z2 = getElementPosition(source)
	if (math.abs(z1-z2)>3) then return end
	local mrp = getmrp(source)

	triggerServerEvent("grupy_playerHasJoinToJob", localPlayer, mrp.fid)
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(plr, md)
	if (plr ~= localPlayer or getElementDimension(plr)~=getElementDimension(source) or not md) then return end
	if (not getElementData(source,"f:marker")) then return end
	mrp = nil
end)