--[[

Gangi: komendy dla czlonkow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gangi
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local function getGID(player)
	local c=getElementData(player,"character")
	if (not c) then return nil end
	return c.gg_nazwa,c.gg_tag,c.gg_rank_name,c.gg_rank_id,c.gg_id 
end

function teleportToBase(thePlayer)
local gname,gtag,grank_name, grank_id, gid=getGID(thePlayer)
if (not gid) then outputChatBox("Nie należysz do żadnego gangu.",thePlayer,255,0,0) return end
    local q = string.format("SELECT id,basespawn,nazwa FROM psz_gangi WHERE id=%d",gid)
    local dane = exports['psz-mysql']:pobierzTabeleWynikow(q)
    if (dane) then
    	local aj = getElementData(thePlayer,"kary:blokada_aj")
    	if (aj and tonumber(aj)>0) then 
    		outputChatBox("Aktualnie przesiadujesz karę w Admin Jailu.",thePlayer,255,0,0)
    		return
    	end
    	
        for i,v in ipairs(dane) do
            v.bpos = split(v.basespawn,",")
            for ii,vv in ipairs(v.bpos) do v.bpos[ii]=tonumber(vv) end
            if isPedInVehicle(thePlayer) then 
            	outputChatBox("Najpierw wyjdź z pojazdu", thePlayer, 255,0,0)
            	return
            end
            setElementPosition(thePlayer,v.bpos[1],v.bpos[2],v.bpos[3])
            setElementInterior(thePlayer,0)
            setElementDimension(thePlayer,0)
            exports['psz-admin']:adminView_add("GBAZA> "..getPlayerName(thePlayer).."pos:"..v.bpos[1]..","..v.bpos[2]..","..v.bpos[3].." | GID:"..gid,2)
            outputChatBox("Zostałeś przeteleportowany do bazy swojego gangu!",thePlayer,255,0,0)
        end
    end
end
addCommandHandler("gbaza",teleportToBase)

function gangLeave(thePlayer)
	local gname,gtag,grank,grankid,gid=getGID(thePlayer)
	if (not gid) then outputChatBox("Nie należysz do żadnego gangu.",thePlayer,255,0,0) return end
	if (grankid>=3) then 
		outputChatBox("Posiadasz zbyt wysoką rangę, nie możesz odejść z gangu.",thePlayer,255,0,0)
		return
	end

	local q = string.format("DELETE FROM psz_players_gangs WHERE id_player=%d AND id_gang=%d LIMIT 1",getElementData(thePlayer,"auth:uid"),gid)
	exports['psz-mysql']:zapytanie(q)
	outputChatBox("Opuściłeś gang "..gname..".",thePlayer,0,100,100)
	local c = getElementData(thePlayer,"character")
	if (c) then 
	c.gg_nazwa = nil
	c.gg_tag = nil
	c.gg_rank_name = nil
	c.gg_rank_id = nil
	c.gg_id = nil

	setElementData(thePlayer, "character", c)
	end
end
addCommandHandler("opusc.gang",gangLeave)

local function gang_receiveInvite(plr, cmd, ...)
	local m_ts = getElementData(plr,"ginv:ts")
	if (not m_ts) then return end
	if (#arg<=0) then return end

	if (getTickCount()-m_ts>=60000) then 
		outputChatBox("Zaproszenie przedawniło się.",plr,255,0,0)
		removeElementData(plr,"ginv:ts")
		return
	end
	local gname = table.concat( arg, " " )

	local m_name = getElementData(plr,"ginv:name")
	if (tostring(gname) ~= tostring(m_name)) then 
		outputChatBox("Wpisano złą nazwę gangu, poprawna: "..m_name..".",plr,255,0,0)
		return
	end

	local c = getElementData(plr,"character")
	if (not c) then return end

	if (c.gg_id or 0>0) then -- Nie powinno sie wydarzyc
		outputChatBox("Należysz już do innego gangu.",plr,255,0,0)
		return
	end

	local q 
	local c = getElementData(plr,"character")
	if (not c or not c.id) then 
		outputChatBox("Najpierw dołącz do gry.",plr,255,0,0)
		return
	end
	
	q = string.format("SELECT id,tag FROM psz_gangi WHERE nazwa='%s' LIMIT 1",gname)	
	local wyniki = exports['psz-mysql']:pobierzWyniki(q)
	if (wyniki) then
		local g_tag = wyniki.tag
		local g_id = wyniki.id
		q = string.format("SELECT name FROM psz_gangs_ranks WHERE rank_id=1 AND gang_id=%d LIMIT 1",g_id)
		local values = exports['psz-mysql']:pobierzWyniki(q)
		if (values) then 
			local g_rank_name = values.name

			c.gg_nazwa = tostring(gname)
			c.gg_tag = tostring(g_tag)
			c.gg_rank_name = tostring(g_rank_name)
			c.gg_rank_id = 1
			c.gg_id = tonumber(g_id)
			setElementData(plr,"character",c)
			local uid = getElementData(plr,"auth:uid") or 0
			local q = string.format("INSERT INTO psz_players_gangs SET id_player=%d, id_gang=%d, rank=1, join_date=NOW() ON DUPLICATE KEY UPDATE id_gang=%d, rank=1, join_date=NOW()",uid,g_id,g_id)
			exports['psz-mysql']:zapytanie(q)
			outputChatBox("* Przynależność w gangu została zaaktualizowana.",plr)

			local target = getElementData(plr,"ginv:person")
			exports['psz-admin']:gameView_add("Gracz "..getPlayerName(target).." zaprasza gracza ("..uid.."), do gangu ("..g_id..")")

			removeElementData(plr,"ginv:ts") 
			removeElementData(plr,"ginv:name")
			removeElementData(plr,"ginv:person")
		end
	end
	
end
addCommandHandler("dolacz", gang_receiveInvite)

function gang_sendInvite(plr,cmd, cel)
	if (not cel) then
		outputChatBox("Użycie: /gang.zapros <nick/id>",plr)
		return 
	end

	local target = findPlayer(plr,cel)
	if (not target) then 
		outputChatBox("Nie znaleziono podanego gracza.",plr)
		return
	end
	
	local gname,_,_,grankid,gid=getGID(plr)
	local _,_,_,_,t_gid=getGID(target)

	if (not gname) then return end



	if (grankid<0) then 
		outputChatBox("Nie możesz zapraszać innych graczy do gangu, masz zbyt niską rangę.",plr)
		return
	end

	if (t_gid) then 
		outputChatBox("Gracz należy już do innego gangu.",plr)
		return
	end
	local tname = string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")
	outputChatBox("Zaproszenie do gangu zostało wysłane graczu "..tname..".",plr)
	outputChatBox("#BF5A02* Otrzymałeś zaproszenie do gangu #FFFFFF"..gname.."#BF5A02, aby zaakceptować wpisz /dolacz #FFFFFF"..gname.."#BF5A02.",target,255,255,255,true)
	setElementData(target,"ginv:ts",getTickCount())
	setElementData(target,"ginv:name",gname)
	setElementData(target,"ginv:person",plr)
end
addCommandHandler("gang.zapros",gang_sendInvite)