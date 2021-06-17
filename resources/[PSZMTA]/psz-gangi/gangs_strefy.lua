--[[

Gangi: strefy dla gangow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gangi
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
strefy = {}

local function getGID (player)
	local c = getElementData (player, "character")
	if (not c) then return nil end
	return c.gg_nazwa, c.gg_tag, c.gg_rank_name, c.gg_rank_id, c.gg_id
end

local function gangs_ZoneDelete(id)
    if isElement(strefy[id].strefa) then destroyElement(strefy[id].strefa) end
    if isElement(strefy[id].col) then destroyElement(strefy[id].col) end
    strefy[id]=nil
end

function createGangZones()
	local q = "SELECT id,nazwa,tag,color,wyspa_sphere FROM psz_gangi WHERE active=1"
	local dane = exports['psz-mysql']:pobierzTabeleWynikow(q)

	if (dane) then

		if strefy[dane.id] then 
			gangs_ZoneDelete(dane.id)
		end

		for i,v in ipairs(dane) do
			v.area=split(v.wyspa_sphere,",")
			for ii,vv in ipairs(v.area) do		v.area[ii]=tonumber(vv)	end

			local r,g,b,a = getColorFromString("#"..v.color)
			v.strefa = createRadarArea(v.area[1],v.area[2],v.area[3],v.area[4],r,g,b,160)
			v.col = createColRectangle(v.area[1],v.area[2],v.area[3],v.area[4])

			setElementData(v.col,"gang:zone",{
				['id']=v.id,
				['nazwa']=v.nazwa,
				['tag']=v.tag,
				['color']=v.color,
			})


			local dbid = v.id
			v.id = nil
			strefy[dbid]=v
		end
	end
end
addEventHandler('onResourceStart',resourceRoot,createGangZones)

local function gangs_getZoneInfo(id)
    return strefy[id]
end

local function gangs_getZoneForGang(gid,plr)
	if (not gid or gid<0) then return end
	local col = getElementsByType("colshape")
	local data = gangs_getZoneInfo(gid)
	local q
	local area = split(data.wyspa_sphere,",")
	for ii,vv in ipairs(area) do area[ii]=tonumber(vv) end
	if (tonumber(area[3]) == 90) then 
		
		q = string.format("UPDATE psz_gangi SET wyspa_sphere='%d,%d,%d,%d' WHERE id=%d",area[1],area[2],area[3]*2,area[4]*2,gid)
		exports['psz-mysql']:zapytanie(q)
		
		createGangZones()
		outputChatBox("Ulepszono strefę gangu, aktualny rozmiar: 180x180. Koszt: $120.000.",plr)

		q = string.format("UPDATE psz_gangi SET money_sejf=money_sejf-120000 WHERE id=%d",gid)
		exports['psz-mysql']:zapytanie(q)
		q = string.format("INSERT INTO psz_gangi_owned_upgrades SET id_gang=%d, id_upgrade=3, ts=NOW(), level=1, bought_by=%d",gid, getElementData(plr,"auth:uid"));
		exports['psz-mysql']:zapytanie(q)

		 exports['psz-admin']:gameView_add("Gracz "..getPlayerName(client).." ulepsza gang ("..gid.."), [U_ID: 3, u_level: 1]");
	end
end


function gangs_upgradeGangZone(gid, plr)
	if (not gid or gid<0) then return end
	local g_n, g_t, g_rn, g_ri, g_id = getGID(plr)
	if (g_ri and (g_ri<3)) then return end
	if (g_id ~= gid) then return end 
	q = string.format("SELECT money_sejf FROM psz_gangi WHERE id=%d",gid) 
	local money_sejf = exports['psz-mysql']:pobierzWyniki(q) -- Pobieramy ilosc kasy z sejfu

	if (money_sejf.money_sejf>=120000) then 
		--local mnoznik =gangs_calculateCostZone(gid)
		gangs_getZoneForGang(gid,plr)
	else
		outputChatBox("Nie posiadasz $120.000 w sejfie gangu, aby zakupić to ulepszenie!",plr,255,0,0)
	end
end