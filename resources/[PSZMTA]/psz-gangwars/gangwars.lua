gzones = {}

local function getGID (player)
	local c = getElementData (player, "character")
	if (not c) then return nil end
	return c.gg_nazwa, c.gg_tag, c.gg_rank_name, c.gg_rank_id, c.gg_id
end

local function gwars_deleteZone(id)
    if isElement(gzones[id].strefa) then destroyElement(gzones[id].strefa) end
    if isElement(gzones[id].col) then destroyElement(gzones[id].col) end
    gzones[id]=nil
end

local function gwars_getZoneInfo(id)
	return gzones[id]
end













function gwars_createZones()
	exports["psz-mysql"]:zapytanie("DELETE FROM psz_zones_score WHERE respect=0")
	local q = "SELECT * FROM (select z.id, z.miny, z.minx, z.maxy, z.maxx, IFNULL(g.color,'909090') color FROM psz_zones z LEFT JOIN psz_zones_score zs ON zs.id_zone=z.id LEFT JOIN psz_gangi g ON g.id=zs.id_gang WHERE z.active=1 ORDER BY zs.respect DESC) s1 GROUP BY id LIMIT 25;"
	local dane = exports['psz-mysql']:pobierzTabeleWynikow(q)

	if (dane) then

		if gzones[dane.id] then 
			gwars_deleteZone(dane.id)
		end

		for i,v in ipairs(dane) do

			local r,g,b,a = getColorFromString("#"..v.color)
			v.strefa = createRadarArea(v.minx, v.miny, v.maxx, v.maxy,r,g,b,160)
			v.col = createColRectangle(v.minx, v.miny, v.maxx, v.maxy)

			setElementData(v.col,"gangwars:zone",{
				['id']=v.id,
				['owner']=nil,
				['tag']=nil,
				['color']=v.color,
			})


			local dbid = v.id
			v.id = nil
			gzones[dbid]=v
		end
	end
end
addEventHandler('onResourceStart',resourceRoot,gwars_createZones)