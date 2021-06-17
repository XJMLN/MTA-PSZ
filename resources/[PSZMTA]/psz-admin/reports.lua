

function cmd_raport(plr, cmd, id, ...)
    if (not id) then
        outputChatBox("Użyj: /raport <id/nick> <powod>", plr)
        return
    end
    local c = getElementData(plr,"character")
    if (not c) then 
        outputChatBox("Najpierw dołącz do gry.",plr,255,0,0)
        return
    end

    local target=exports["psz-core"]:findPlayer(plr,id)
    if (not target) then
        outputChatBox("Nie odnaleziono gracza o podanym ID.", plr)
        return
    end
    local opis=table.concat(arg, " ")
    local time = getRealTime()
    opis = string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","") .. "/"..getElementData(target,"id").. " - ["..time.hour..":"..time.minute.."] - " .. opis

    opis = opis .. "-- "..string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","").."/"..getElementData(plr,"id")


    reportView_add(opis,getElementData(target,"id"))
    outputChatBox("Zgłoszenie zostało wysłane." , plr)
    adminView_add("RAPORT> "..opis,2)
end

addCommandHandler("raport", cmd_raport, false,false)
addCommandHandler("report", cmd_raport, false,false)

function cmd_cl(plr,cmd,id,...)
    if (not id) then
        outputChatBox("Użyj: /cl <id/nick> <powod>", plr)
        return
    end


    local powod=table.concat(arg, " ")
    if (string.len(powod)<2) then
        outputChatBox("Użyj: /cl <id/nick> <powod>", plr)
        return
    end

    local target=exports["psz-core"]:findPlayer(plr,id)
    local opis="?"
    if (target) then
        id=getElementData(target,"id")
        opis=getPlayerName(target)
    end
    local dbid = getElementData(plr,"auth:uid") or 0
    if (dbid and dbid<1) then return end
    if (reportView_remove(tonumber(id))) then 
        local supportLogin=getPlayerName(plr)

        msgToSupport(string.gsub(supportLogin,"#%x%x%x%x%x%x","") .. " usunął/ęła raport na " .. string.gsub(opis,"#%x%x%x%x%x%x","") .. "/".. id .. ": " .. powod)
        gameView_add("CL "..supportLogin .. " usunął/ęła raport na ".. opis .. "/"..id..": ".. powod)
        adminView_add("CL> "..supportLogin .. " usunął/ęła raport na ".. opis .. "/"..id..": ".. powod,2)
        exports["psz-mysql"]:zapytanie(string.format("INSERT INTO psz_admin_activity SET data=NOW(),raporty=1,id_player=%d ON DUPLICATE KEY UPDATE raporty=raporty+1",tonumber(dbid)))
    else
        outputChatBox("Nie znaleziono podanego raportu.",plr,255,0,0)
        return
    end
end
addCommandHandler("cl", cmd_cl, true, false)
