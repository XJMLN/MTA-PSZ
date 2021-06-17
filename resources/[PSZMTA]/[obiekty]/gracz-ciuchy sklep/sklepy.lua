--[[
Sklepy z odzieza

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.gracz-sklep_odziezowy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local sklepy = {
	-- x, y, z, i, vw, type = 1 - sklep odziezowy; type = 2 - sklep z bronia
	{207.12,-129.18,1002.5,3,0},
}

local function onPlayerHitShopMarker(el,md)
	if (not md) or getElementType(el)~="player" then return end
	local type = getElementData(source,"wear_shop") 
	if (not type) then return end
	triggerClientEvent("onPlayerHitShopMarker", el)
end

for i,v in ipairs(sklepy) do
	sklepy[i].marker = createMarker(v[1],v[2],v[3],"cylinder",1.2,255,255,0,100)
		setElementInterior(sklepy[i].marker,v[4])
		setElementDimension(sklepy[i].marker,v[5])
		addEventHandler("onMarkerHit", sklepy[i].marker,  onPlayerHitShopMarker)
end

--triggerServerEvent("onPlayerRequestEnd",getRootElement(), plr, tonumber(sid))
addEvent("onPlayerRequestEnd",true)
addEventHandler("onPlayerRequestEnd", getRootElement(), function(plr,model)
	if model then 
		local auid = getElementData(plr,"auth:uid") or 0 
		local query = string.format("UPDATE psz_postacie SET skin=%d, vipskin= NULL WHERE id=%d LIMIT 1",model,auid)
		exports['psz-mysql']:zapytanie(query)
	end
end)