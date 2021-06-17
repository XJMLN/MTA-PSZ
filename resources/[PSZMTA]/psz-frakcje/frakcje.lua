--[[

Frakcje - glowny zasob, rozpoczynanie pracy, zmiana ilosci zatrudnionych

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-frakcje
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
C_MEDIC = 0
C_POLICE = 0
C_FIREWORKER = 0
C_NEWSMAN = 0


local napisy = {
	{2291.06,-1215.21,-18.01,1,8, fid=1}, -- LSMC
    {2063.35,-1397.20,1275.07,1,8, fid=1}, -- LSMC v2
    {-836.74,2260.71,201.45,2,0, fid=1}, -- LVMC

	{246.68,118.54,1003.22,10,0, fid=2}, -- LVPD
    {256.46,63.65,1003.64,6,0, fid=2}, -- LSPD
    {228.72,166.24,1003.02,3,0, fid=2}, -- SFPD

    {-0.90,-270.44,12.46,0,0, fid=3}, -- BB

    {1856.38,2418.81,21.3,210,20, fid=4}, -- LV
}

for i,v in ipairs(napisy) do
	v.napis = createElement("ctext")
	setElementPosition(v.napis,v[1],v[2],v[3]+0.4)
    setElementData(v.napis,"ctext",setTxtByFID(v.fid))
    setElementData(v.napis,"f:text",v.fid)
    setElementDimension(v.napis,v[5])
    setElementInterior(v.napis,v[4])
end

function frakcje_vipStopJob(plr, fid)
	if (not fid or not plr) then return end

	local fr = getElementData(plr,"faction:data")
	if (not fr) then return end

	if (not fr.vip) then return end

	if fid == 1 then 
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako lekarz!", plr,255, 0, 0)

	elseif fid == 2 then 
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako policjant!", plr, 255, 0, 0)

	elseif fid == 3 then 
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako strażak!", plr, 255, 0, 0)

	elseif fid == 4 then 
		restoreSavedData(plr, fr)
		outputChatBox("* Zakończyłeś pracę jako reporter!", plr, 255, 0, 0)

	end
end

function frakcje_playerStopJob(plr, fid)
	if (not fid or not plr) then return end

	local fr = getElementData(plr,"faction:data")
	if (not fr) then outputDebugString('fiut:72') return end

	if fr and fr.vip then frakcje_vipStopJob(plr,fid) return end

	if fid == 1 then 
		C_MEDIC = C_MEDIC - 1
		if C_MEDIC < 0 then C_MEDIC = 0 end
		updateAllTxt(fid,C_MEDIC)
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako lekarz!", plr,255, 0, 0)

	elseif fid == 2 then 
		C_POLICE = C_POLICE - 1
		if C_POLICE < 0 then C_POLICE = 0 end
		updateAllTxt(fid,C_POLICE)
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako policjant!", plr, 255, 0, 0)

	elseif fid == 3 then 
		C_FIREWORKER = C_FIREWORKER - 1
		if C_FIREWORKER < 0 then C_FIREWORKER = 0 end
		updateAllTxt(fid, C_FIREWORKER)
		restoreSavedData(plr,fr)
		outputChatBox("* Zakończyłeś pracę jako strażak!", plr, 255, 0, 0)

	elseif fid == 4 then 
		C_NEWSMAN = C_NEWSMAN - 1
		if C_NEWSMAN < 0 then C_NEWSMAN = 0 end
		updateAllTxt(fid, C_NEWSMAN)
		restoreSavedData(plr, fr)
		outputChatBox("* Zakończyłeś pracę jako reporter!", plr, 255, 0, 0)

	end
end

function frakcje_vipStartJob(plr,fid)
	if (not plr or not fid) then return end

	local fr = getElementData(plr,"faction:data")
	if (fr) then return end

	local vip = getElementData(plr,"vip")

	if fid == 1 and vip then
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			["vip"]=1,
			})
		setElementModel(plr,math.random(274,276))
        setPlayerNametagColor(plr,247,147,152)
        string.gsub(getPlayerName(plr),"|SAMC|","")
        setPlayerName(plr,"|SAMC|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako lekarz!", plr, 255, 0, 0)

    elseif fid == 2 and vip then 
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			["vip"]=1,
			})
        setElementModel(plr,math.random(280,282))
        setPlayerNametagColor(plr,0,162,232)
        string.gsub(getPlayerName(plr),"|SAPD|","")
        setPlayerName(plr,"|SAPD|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako policjant!", plr, 255, 0, 0)

    elseif fid == 3 and vip then
    	setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			["vip"]=1,
			})
		setElementModel(plr,277)
        setPlayerNametagColor(plr,247,147,152)
        string.gsub(getPlayerName(plr),"|PSP|","")
        setPlayerName(plr,"|PSP|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako strażak!", plr, 255, 0, 0)

    elseif fid == 4 and vip then 
    	setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			["vip"]=1,
			})
    	setElementModel(plr,147)
        setPlayerNametagColor(plr,25,162,232)
        giveWeapon(plr,43)
        string.gsub(getPlayerName(plr),"|SN|","")
        setPlayerName(plr,"|SN|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako reporter!", plr, 255, 0, 0)
    end
end

function frakcje_playerStartJob(plr, fid)
	if (not plr or not fid) then return end

	local fr = getElementData(plr,"faction:data")
	if (fr) then return end

	local vip = getElementData(plr,"vip")

	if fid == 1 then 
		if (C_MEDIC >= 5 and vip) then 
			frakcje_vipStartJob(plr,fid)
			return
		end
		C_MEDIC = C_MEDIC + 1
		if C_MEDIC > 5 then 
			C_MEDIC = 5 
		end
		updateAllTxt(fid,C_MEDIC)
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			})
		setElementModel(plr,math.random(274,276))
        setPlayerNametagColor(plr,247,147,152)
        string.gsub(getPlayerName(plr),"|SAMC|","")
        setPlayerName(plr,"|SAMC|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako lekarz!", plr, 255, 0, 0)

    elseif fid == 2 then 

		if (C_POLICE >= 5 and vip) then 
			frakcje_vipStartJob(plr,fid)
			return
		end
		C_POLICE = C_POLICE + 1
		if C_POLICE > 5 then 
			C_POLICE = 5
		end

		updateAllTxt(fid,C_POLICE)
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			})
        setElementModel(plr,math.random(280,282))
        setPlayerNametagColor(plr,0,162,232)
        string.gsub(getPlayerName(plr),"|SAPD|","")
        setPlayerName(plr,"|SAPD|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako policjant!", plr, 255, 0, 0)

    elseif fid == 3 then 
		if (C_FIREWORKER >= 5 and vip) then 
			frakcje_vipStartJob(plr,fid)
			return
		end
		C_FIREWORKER = C_FIREWORKER + 1
		if C_FIREWORKER > 5 then 
			C_FIREWORKER = 5
		end
		updateAllTxt(fid, C_FIREWORKER)
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			})
		setElementModel(plr,277)
        setPlayerNametagColor(plr,247,147,152)
        string.gsub(getPlayerName(plr),"|PSP|","")
        setPlayerName(plr,"|PSP|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako strażak!", plr, 255, 0, 0)

    elseif fid == 4 then 
		if (C_NEWSMAN >= 5 and vip) then 
			frakcje_vipStartJob(plr,fid)
			return
		end
		C_NEWSMAN = C_NEWSMAN + 1 
		if C_NEWSMAN > 5 then 
			C_NEWSMAN = 5
		end
		updateAllTxt(fid, C_NEWSMAN)
		setElementData(plr,"faction:data",{
			["id"]=fid,
			["skin"]=getElementModel(plr),
			["nick"]=getPlayerName(plr),
			})
    	setElementModel(plr,147)
        setPlayerNametagColor(plr,25,162,232)
        giveWeapon(plr,43)
        string.gsub(getPlayerName(plr),"|SN|","")
        setPlayerName(plr,"|SN|"..getPlayerName(plr))
        outputChatBox("* Rozpoczęto pracę jako reporter!", plr, 255, 0, 0)

    end
end

function frakcje_playerJoinToJob(plr, fid)
	if (not plr or not fid) then return end
	local vip = getElementData(plr,"vip")
	local fr = getElementData(plr,"faction:data")
	if fid == 1 then 
		if C_MEDIC>5 then return end
		
		if fr and fr.id ~= 1 then 
			outputChatBox("Najpierw zakończ aktualną pracę aby rozpocząć kolejną.",plr,255,0,0)
			return
		elseif fr and fr.id == 1 then 
			frakcje_playerStopJob(plr,fid)
			return

		elseif not fr then
			frakcje_playerStartJob(plr,fid)
			return
		end
	elseif fid == 2 then 
		if C_POLICE>5 then return end

		if fr and fr.id ~=2 then 
			outputChatBox("Najpierw zakończ aktualną pracę aby rozpocząć kolejną.",plr,255,0,0)
			return
		elseif fr and fr.id == 2 then
			frakcje_playerStopJob(plr,fid)
			return
		elseif not fr then 
			frakcje_playerStartJob(plr,fid)
			return
		end
	elseif fid == 3 then 
		if C_FIREWORKER>5 then return end

		local fr = getElementData(plr,"faction:data")

		if fr and fr.id ~=3 then 
			outputChatBox("Najpierw zakończ aktualną pracę aby rozpocząć kolejną.",plr,255,0,0)
			return
		elseif fr and fr.id == 3 then
			frakcje_playerStopJob(plr,fid)
			return
		elseif not fr then 
			frakcje_playerStartJob(plr,fid)
			return
		end
	elseif fid == 4 then 
		if C_NEWSMAN>5 then return end

		local fr = getElementData(plr,"faction:data")

		if fr and fr.id ~=4 then 
			outputChatBox("Najpierw zakończ aktualną pracę aby rozpocząć kolejną.",plr,255,0,0)
			return
		elseif fr and fr.id == 4 then
			frakcje_playerStopJob(plr,fid)
			return
		elseif not fr then 
			frakcje_playerStartJob(plr,fid)
			return
		end
	end
end

function frakcje_checkJob(v)
	if (not v) then return end
	
	frakcje_playerJoinToJob(source,v)
end

function frakcje_quitJob()
	local fr = getElementData(source,"faction:data")
	if (not fr) then return end

	frakcje_playerStopJob(source,fr.id)
end

addEventHandler("onPlayerQuit",getRootElement(),frakcje_quitJob)
addEvent("frakcje_playerHasJoinToJob", true)
addEventHandler("frakcje_playerHasJoinToJob", root, frakcje_checkJob)