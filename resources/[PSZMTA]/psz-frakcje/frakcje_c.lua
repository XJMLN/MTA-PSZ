--[[

Frakcje - glowny zasob, rozpoczynanie pracy, zmiana ilosci zatrudnionych

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-frakcje
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local miejsca_pracy = {
	--x, y, z, int, dim , fid
	{2291.06,-1215.21,-18.01,1,8, fid=1}, -- LSMC
    {2063.35,-1397.20,1275.07,1,8, fid=1}, -- LSMC v2
    {-836.74,2260.71,201.45,2,0, fid=1}, -- LVMC

    {246.68,118.54,1003.22,10,0, fid=2}, -- LVPD
    {256.46,63.65,1003.64,6,0, fid=2}, -- LSPD
    {228.72,166.24,1003.02,3,0, fid=2}, -- SFPD

    {-0.90,-270.44,11.96,0,0, fid=3}, -- BB

	{1856.38,2418.81,20.83,210,20, fid=4}, -- LV 
}

for i,v in ipairs(miejsca_pracy) do
    v.pickup=createPickup(v[1],v[2],v[3], 3, 1247)
    setElementInterior(v.pickup, v[4])
    setElementDimension(v.pickup, v[5])
    setElementData(v.pickup, "f:pickup",tonumber(v.fid))
end

local function getmrp(s)
    for i,v in ipairs(miejsca_pracy) do
        if (v.pickup==s) then return v end
    end
    return nil
end

addEventHandler("onClientPickupHit", resourceRoot, function(thePlayer, md)
        if (thePlayer~=localPlayer or not md) then return end
        if (getElementInterior(source)~=getElementInterior(localPlayer)) then return end
        local fid = getElementData(source, "f:pickup")
        if (not fid) then return end

        local _,_,z1=getElementPosition(thePlayer)
        local _,_,z2=getElementPosition(source)
        if (math.abs(z1-z2)>3)  then return end
		local mrp=getmrp(source)
		--outputChatBox("halo")
        triggerServerEvent("frakcje_playerHasJoinToJob",localPlayer,mrp.fid)
end)

addEventHandler("onClientPickupLeave", resourceRoot, function(thePlayer, md)

        if (thePlayer~=localPlayer or getElementDimension(thePlayer)~=getElementDimension(source)) then return end

        if (not getElementData(source, "f:pickup")) then return end
        selected_duty = nil
    end)
