--[[

Core - chaty

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end


function stripColors(text)
    local cnt=1
    while (cnt>0) do
        text,cnt=string.gsub(text,"#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]","")
    end
    return text
end

addEvent("onGangChat", true)
addEventHandler("onGangChat", resourceRoot, function(plr,gaid,msg)
	local gid=getElementData(localPlayer,"character")
	if (not gid or not gid.gg_id or tonumber(gid.gg_id)~=gaid) then return end
	playSoundFrontEnd(49)
	local nick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    local msg = trim(stripColors(msg))
        if string.len(msg)<1 then
        return
    end
	outputChatBox("#900a27"..gid.gg_nazwa.."> #FFFFFF"..getElementData(plr,"id").." "..nick..": "..msg,255,50,255,true)
end)
local function checkFID(fid)
    local frakcje = {
        {1,"Przychodnia"},
        {2,"Policja"},
        {3,"Straż Pożarna"},
    }
    text = nil
    for i,v in ipairs(frakcje) do
        if v[1] == fid then
            text = v[2]
        end
    end
    return text
end

addEvent("onFractionChatY",true)
addEventHandler("onFractionChatY",resourceRoot, function(plr, fid, msg)
    local lfid = getElementData(localPlayer,"faction:data")
    if (not lfid or tonumber(lfid.id)~=fid) then return end
    --if (not isPlayerInFraction(plr)) then 
    --    return
    --end
    local frakcja = checkFID(tonumber(fid))
    local playername = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    outputChatBox("KF ["..tostring(frakcja).."] #FFFFFF"..playername..": "..msg, 255,50,255, true)    
end)