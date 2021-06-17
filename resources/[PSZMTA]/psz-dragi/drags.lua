--[[

Wyścigi drag 

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drags
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

drags = {}

local function dr_deleteRace(id)
	if isElement(drags[id].col) then destroyElement(drags[id].col) end 
    drags[id]=nil
end

function dr_createRace()
	local q = "SELECT dr.id,dr.nazwa,dr.cuboid_start,dr.rotation,dr.cuboid_end,dr.pos_text,dr.type FROM psz_dragraces dr WHERE dr.active=1;"
	local dane = exports['psz-mysql']:pobierzTabeleWynikow(q)

	if (dane) then

		if drags[dane.id] then 
			dr_deleteRace(dane.id)
		end

		for i,v in ipairs(dane) do
			v.zone=split(v.cuboid_start,",")
			
			for ii,vv in ipairs(v.zone) do		v.zone[ii]=tonumber(vv)	end

			v.zone_end=split(v.cuboid_end,",")
			for ii,vv in ipairs(v.zone_end) do v.zone_end[ii]=tonumber(vv) end
			
			v.pt = split(v.pos_text,",")
			for ii,vv in ipairs(v.pt) do		v.pt[ii]=tonumber(vv)	end

			v.rt = split(v.rotation,",")
			for ii,vv in ipairs(v.rt) do  		v.rt[ii]=tonumber(vv) end

			v.colS = createColCuboid(v.zone[1],v.zone[2],v.zone[3],v.zone[4],v.zone[5],v.zone[6])
			v.colE = createColCuboid(v.zone_end[1],v.zone_end[2],v.zone_end[3],v.zone_end[4],v.zone_end[5],v.zone_end[6])

			v.text = createElement("text")
			setElementPosition(v.text,v.pt[1],v.pt[2],v.pt[3])
			setElementData(v.text,"text",v.nazwa)
			setElementData(v.text,"scale",1.5)

			setElementData(v.colS,"drag:data",{
				['id']=v.id,
				['nazwa']=v.nazwa,
				['meta']=false,
				['type']=v.type,
				['rot']={v.rt[1],v.rt[2]},
				['pair']=v.colE,
			})
			setElementData(v.colE,"drag:data",{
				['id']=v.id,
				['nazwa']=v.nazwa,
				['meta']=true,
				['type']=v.type,
				['rot']={v.rt[3],v.rt[4]},
				['pair']=v.colS,
			})


			local dbid = v.id
			v.id = nil
			drags[dbid]=v
		end
	end
end
addEventHandler('onResourceStart',resourceRoot,dr_createRace)

local function dr_getRaceInfo(id)
    return drags[id]
end

function dr_saveRecordToTrack(plr,drag_id,veh,czas)
	if not plr or tonumber(drag_id)<1 then outputDebugString("tu") return end
	local uid = getElementData(plr,"auth:uid") or nil
	if not uid then return end
	removeElementData(plr,"hedit_ban")
	-- sprawdzamy czy pobil rekord na trasie
	local q = string.format("SELECT drr.record_time,pl.nick,drr.user_id,dr.nazwa FROM psz_dragraces_records drr JOIN psz_dragraces dr ON dr.id=drr.dragid JOIN psz_postacie pl ON pl.userid=drr.user_id WHERE drr.dragid=%d ORDER BY drr.record_time ASC LIMIT 1",drag_id)
	local wyniki = exports['psz-mysql']:pobierzWyniki(q)
	if wyniki and wyniki.record_time>czas then 
		if wyniki.user_id ~= uid then 
			outputChatBox(string.format("%s★ %sGracz %s ustanowił nowy rekord na trasie %s, należący do %s (%s). Nowy rekord wynosi: %s.","#00FF00","#FFFFFF",getPlayerName(plr),wyniki.nazwa,wyniki.nick,string.format("%.3fs",wyniki.record_time/1000),string.format("%.3fs",czas/1000)),getRootElement(),255,255,255,true)
		else
			outputChatBox(string.format("%s★ %sGracz %s pobił swój własny rekord (%s) na trasie %s. Nowy rekord wynosi: %s.","#00FF00","#FFFFFF",getPlayerName(plr),string.format("%.3fs",wyniki.record_time/1000),wyniki.nazwa,string.format("%.3fs",czas/1000)),getRootElement(),255,255,255,true)
		end
	end
	local q = string.format("INSERT INTO psz_dragraces_records SET user_id=%d,vid=%d,dragid=%d,record_time=%d,ts=NOW() ON DUPLICATE KEY UPDATE record_time=%d,ts=NOW() ",tonumber(uid),tonumber(veh),drag_id,czas,czas)
	exports['psz-mysql']:zapytanie(q)
end
addEvent("dr_saveTrackRecord",true)
addEventHandler("dr_saveTrackRecord",root,dr_saveRecordToTrack)