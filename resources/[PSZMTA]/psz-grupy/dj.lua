--[[

Grupy: Praca jako DJ

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-grupy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
C_DJ = 0

local napisy = {
	{476.65,-12.49,1004,17,0, fid=6},-- DJ
}

for i,v in ipairs(napisy) do
	v.napis = createElement("ctext")
	setElementPosition(v.napis,v[1],v[2],v[3]+0.4)
	setElementData(v.napis,"ctext",setTxtByGID(v.fid))
	setElementData(v.napis,"f:text",v.fid)
	setElementDimension(v.napis,v[5])
	setElementInterior(v.napis,v[4])
end

local DJ_info = createElement("text")
setElementPosition(DJ_info, 487.45,-6.16,1004.5)
setElementInterior(DJ_info,17)
setElementDimension(DJ_info,0)
setElementData(DJ_info, "text","Aktualnie gra DJ:\n --")
setElementData(DJ_info, "scale", 1.5)

function grupy_playerStopJob(plr, fid)
	if (not fid or not plr) then return end

	local fr = getElementData(plr,"faction:data")
	if (not fr) then return end

	if fid == 6 then
		C_DJ = C_DJ - 1
		if C_DJ < 0 then C_DJ = 0 end
		updateAllTxt(fid,C_DJ)
		restoreSavedData(plr,fr)
		setElementData(DJ_info,"text","Aktualnie gra DJ:\n --")
		outputChatBox("* Zakończyłeś pracę jako DJ!", plr, 255, 0, 0)
	end
end

function grupy_playerStartJob(plr,fid)
	if (not plr or not fid) then return end

	local fr = getElementData(plr,"faction:data")
	if (fr) then return end

	if fid == 6 then 
		if C_DJ == 1 then return end
		C_DJ = C_DJ + 1 
		if C_DJ > 1 then 
			C_DJ = 1
		end
		updateAllTxt(fid, C_DJ)
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["nick"]=getPlayerName(plr),
			})
		string.gsub(getPlayerName(plr),"|DJ|","")
		setPlayerName(plr,"|DJ|"..getPlayerName(plr))
		setElementData(DJ_info,"text","Aktualnie gra DJ:\n "..string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x",""))
		outputChatBox("* Rozpoczęto pracę jako DJ!", plr, 255,0,0)
	end
end

function grupy_playerJoinToJob(plr,fid)
	if (not plr or not fid) then return end

	local fr = getElementData(plr,"faction:data")
	local blokada = getElementData(plr,"banned_jobs")
	if fid == 6 then 
		if C_DJ>=2 then return end

		if fr and fr.id ~= 6 then 
			outputChatBox('Najpierw zakończ aktualną pracę aby rozpocząć kolejna.',plr,255,0,0)
			return
		elseif fr and fr.id == 6 then
			grupy_playerStopJob(plr,fid)
			
			return
		elseif not fr and not blokada then 
			grupy_playerStartJob(plr,fid)
			return
		end
	end
end

function grupy_checkJob(v)
	if (not v) then return end
	
	grupy_playerJoinToJob(source,v)
end

function grupy_quitJob(reason,plr)
	if reason ~= 'bpracy' then plr = source end 
	local fr = getElementData(plr,"faction:data")
	if (not fr) then return end

	grupy_playerStopJob(plr,fr.id)
end

addEventHandler("onPlayerQuit",getRootElement(),grupy_quitJob)
addEvent("grupy_playerHasJoinToJob", true)
addEventHandler("grupy_playerHasJoinToJob", root, grupy_checkJob)
