local function serializeTag(t)
  -- {visible = true, z2 = 23.790163, z1 = 25.288221, nz = 0, y2 = -1021.775391, nx = 0, ny = -1, y = -1021.850403, x = 1409.386353, y1 = -1021.845398, z = 24.539192, x2 = 1409.424561, pngdata = �PNG  , visibility = 90, x1 = 1409.348145}
  local pola={"z1","z2","nz","y2","nx","ny","y","x","y1","z","x2","pngdata","x1"} -- omijamy visible i visibility i active
  local tag={  }
  for i,v in ipairs(pola) do
	tag[v]=getElementData(t,v)
  end
  tag.creator=getElementData(t,"creator")
  return tag
end
--[[
1908.044921875, -2381.185546875, 12.046875
Lenght: 33.25, depth: 57.75, height: 6.25
]]
local function unhex(n)
  local out, ch = ""
  local xtrans = {
    ["0"] = 0, ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5,
    ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9,
    A = 10, B = 11, C = 12, D = 13, E = 14, F = 15,
    a = 10, b = 11, c = 12, d = 13, e = 14, f = 15,
  }
  for c in string.gmatch(n, "[0-9A-Fa-f]") do
    if ch ~= nil then
      out, ch = out .. string.char(ch * 16 + xtrans[c])
    else ch = xtrans[c]; end
  end
  if ch then out = ch * 16 + xtrans[c]; end
  return out
end





local function saveTagToDB(v)
	if (getElementData(v,"visible") and getElementData(v,"pngdata")) then

	  local t=serializeTag(v)
	  -- x,y,z,x1,y1,z1,x2,y2,z2,ny,nx,nz,pngdata
        local query = string.format("INSERT INTO psz_tagi SET creator=%d, x='%s', y='%s', z='%s', x1='%s', y1='%s', z1='%s', x2='%s', y2='%s', z2='%s', ny='%s', nx='%s', nz='%s',pngdata='%s'",
        t.creator or 0, t.x, t.y, t.z, t.x1, t.y1, t.z1, t.x2, t.y2,t.z2, t.ny, t.nx, t.nz,base64Encode(t.pngdata))
        --outputDebugString(base64Encode(t.pngdata))
        return exports['psz-mysql']:zapytanie(query);
	end
	return nil;

end

local function destroyTagsOverLimit(cid,ab_spray)
  local limits="3,3"
  if (ab_spray>=99) then
	limits="7,3"
  elseif (ab_spray>90) then
	limits="6,3"
  elseif (ab_spray>=85) then
	limits="5,3"
  elseif (ab_spray>=75) then
	limits="4,3"
  end
  local query=string.format("select id from psz_tagi where creator=%d AND active=1 ORDER BY ts DESC LIMIT %s;", cid, limits)
  local stareid=exports['psz-mysql']:pobierzTabeleWynikow(query)
  local id_do_usuniecia={}
  if (#stareid>0) then
	for _,v in ipairs(stareid) do
		local tid="tag:"..v.id
		table.insert(id_do_usuniecia, tonumber(v.id))
		local tag=getElementByID(tid)
		if (tag) then
			destroyElement(tag)
		end
	end
        query = string.format("UPDATE psz_tagi SET active=1 WHERE creator=%d AND id IN (%s)",cid, table.concat(id_do_usuniecia, ","))
        exports['psz-mysql']:zapytanie(query)
  end
end

-- rejestracja tagu w bazie danych!
addEvent("drawtag:onTagFinishSpray", true)
addEventHandler("drawtag:onTagFinishSpray",root,function(player)
	if (player) then
		outputDebugString(getPlayerName(player).." finished spraying a tag.")
		local c=getElementData(player,"character")
		if not c then
			destroyElement(source)
			return
		end
		setElementData(source, "creator", tonumber(c.id),false)
		local dbid=saveTagToDB(source)
		destroyTagsOverLimit(tonumber(c.id),tonumber(c.ab_spray) or 50)
		removeElementData(source, "ts")

		if (not dbid) then
			destroyElement(source)
			return
		end
		playSoundFrontEnd(player,3)
		setElementID(source, "tag:"..dbid)
	end
end)

local function getTagID(tag)
  local id=getElementID(tag)
  if (not id) then return nil end
  return tonumber(string.sub(id,5))
end

-- usuwanie tagu z bazy danych
addEvent("drawtag:onTagFinishErase", true)
addEventHandler("drawtag:onTagFinishErase",root,function(player)
	if (player) then
		local tid=getTagID(source)
		if not tid then return end
		local query=string.format("UPDATE psz_tagi SET active=0 WHERE id=%d", tid)
            exports['psz-mysql']:zapytanie(query)
	end
end)


-- wczytywanie tagow przy starcie zasobu
addEventHandler("onResourceStart", resourceRoot, function()
  local eroot=getElementsByType("drawtag:tags", resourceRoot)
  eroot=eroot[1]
  if (not eroot or not isElement(eroot)) then
	outputDebugString("wczytanie tagow z bazy danych nie powiodlo sie - brak eroot")
	return
  end
  -- Tagi które są starsze niż 7 godzin nadajemy date nie aktywnych
        exports['psz-mysql']:zapytanie("UPDATE psz_tagi SET active=0 WHERE datediff(NOW(),ts)>=7")
  -- pobieramy tagi ktore sa swieze
        local tagi=exports['psz-mysql']:pobierzTabeleWynikow("SELECT id,x,y,z,x1,y1,z1,x2,y2,z2,ny,nx,nz,pngdata from psz_tagi WHERE active=1");
  outputDebugString("Aktywnych tagów w bazie: " .. #tagi)
  for i,v in ipairs(tagi) do
    v.pngdata=base64Decode(v.pngdata)

	local tag=createElement("drawtag:tag")
	setElementParent(tag, eroot)
	local pola={"z1","z2","nz","y2","nx","ny","y","x","y1","z","x2","x1"}
	for _,pole in ipairs(pola) do
	  setElementData(tag, pole, tonumber(v[pole]))
	end
	setElementData(tag,"pngdata", v.pngdata)
	setElementData(tag,"visibility", 90)
	setElementData(tag,"visible", true)
	setElementID(tag, "tag:"..v.id)
  end
end)


-- usuwanie niedokonczonych tagow
addEvent("drawtag:onTagStartSpray", true)

addEventHandler("drawtag:onTagStartSpray",root,function()
  setElementData(source,"ts", getTickCount(), false)
end)

local function purgeUnfinishedTags()
  local tagi=getElementsByType("drawtag:tag", resourceRoot)
  for i,v in ipairs(tagi) do
	local ts=getElementData(v,"ts")
	if (ts and getTickCount()-tonumber(ts)>1000*60*2) then
		destroyElement(v)
	end
  end
end

setTimer(purgeUnfinishedTags, 1000*60*3, 0)