function updateAllTxt(fid, count)
	if (not fid) then return end
    local teksty = getElementsByType("ctext",getRootElement())
    for i,v in pairs(teksty) do
        if (getElementData(v,"f:text") == fid) then
        	if (tonumber(fid) == 1) then 
            	setElementData(v,"ctext","Ilość lekarzy: "..count.."/5")
            elseif (tonumber(fid) == 2) then 
            	setElementData(v,"ctext","Ilość policjantów: "..count.."/5")
            elseif (tonumber(fid) == 3) then
                setElementData(v,"ctext","Ilość strażaków: "..count.."/5")
            elseif (tonumber(fid) == 4) then 
                setElementData(v, "ctext","Ilość reporterów: "..count.."/5")
            elseif (tonumber(fid) == 5) then
                setElementData(v, "ctext","Ilość mechaników: "..count.."/5")
        	end
        end
    end
end

function setTxtByFID(fid)
    if (fid and tonumber(fid)>0) then 
        if fid == 1 then 
            return "Ilość lekarzy: "..C_MEDIC.."/5"
        elseif fid == 2 then 
            return "Ilość policjantów: "..C_POLICE.."/5"
        elseif fid == 3 then 
            return "Ilość strażaków: "..C_FIREWORKER.."/5"
        elseif fid == 4 then 
            return "Ilość reporterów: "..C_NEWSMAN.."/5"
        end
    end
end

function restoreSavedData(plr,fr)
    if (not plr or not fr) then return end
    setElementModel(plr,fr.skin)
    setPlayerName(plr,fr.nick)
    setPlayerNametagColor(plr,math.random(0,255),math.random(0,255),math.random(0,255))
    removeElementData(plr,"faction:data")
    
end