--[[

Grupy: Praca jako DJ

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-grupy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function updateAllTxt(fid, count)
	if (not fid) then return end
    local teksty = getElementsByType("ctext",getRootElement())
    for i,v in pairs(teksty) do
        if (getElementData(v,"f:text") == fid) then
        	if (tonumber(fid) == 6) then 
            	setElementData(v,"ctext","Ilość DJów: "..count.."/1")

        	end
        end
    end
end

function setTxtByGID(fid)
    if (fid and tonumber(fid)>0) then 
        if fid == 6 then 
            return "Ilość DJów: "..C_DJ.."/1"
        end
    end
end

function restoreSavedData(plr,fr)
    if (not plr or not fr) then return end
    setPlayerName(plr,fr.nick)
    setPlayerNametagColor(plr,math.random(0,255),math.random(0,255),math.random(0,255))
    removeElementData(plr,"faction:data")
    
end