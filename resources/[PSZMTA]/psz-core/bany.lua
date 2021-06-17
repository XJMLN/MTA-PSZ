--[[

Core - banowanie kont, sprawdzanie aktywnych banow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function isPlayerBanned(plr)
    local uid=getElementData(plr,"auth:uid") or 0
    local query=string.format("SELECT b.date_end,b.reason,u.login baner FROM psz_bany b JOIN psz_players u ON b.player_given=u.id WHERE (b.player_banned=%d OR b.serial='%s') AND b.date_end>NOW() ORDER BY b.date_end DESC LIMIT 1",
        uid,getPlayerSerial(plr))
    pasujacy_ban=exports["psz-mysql"]:pobierzWyniki(query)
    if (pasujacy_ban) then
        outputDebugString("Gracz " .. getPlayerName(plr) .. " nie dolacza z powodu aktywnego bana " .. pasujacy_ban.reason .. "(do "..pasujacy_ban.date_end..")")
        outputConsole(" ", plr)
        outputConsole(" ", plr)
        outputConsole(" ", plr)
        outputConsole(" ", plr)
        outputConsole(" ", plr)
        outputConsole("=====================================", plr)
        outputConsole("Zostales/as zbanowany/a na tym serwerze ", plr)
        outputConsole(" ", plr)
        outputConsole("Powód: " .. pasujacy_ban.reason, plr)
        outputConsole("Ban jest aktywny do: "..pasujacy_ban.date_end, plr)
        outputConsole("Ban został nałozony przez: " .. pasujacy_ban.baner, plr)
        outputConsole("Twoj serial: " .. getPlayerSerial(plr), plr)
        outputConsole(" ", plr)
        outputConsole("Jeśli uważasz, że ban jest niesłuszny, bądź też chcesz starac", plr)
        outputConsole("sie o wczesniejsze zdjecie, napisz podanie o odbanowanie pod", plr)
        outputConsole("adresem: http://pszmta.pl/unban", plr)
        outputConsole("=====================================", plr)
        kickPlayer(plr,"Wcisnij ~ ")
        return true
    end
    return false

end

function cmd_ban(plr,cmd,cel,czas,jednostka,...)
    local reason = table.concat( arg, " " )

    if (not cel or not czas or not jednostka) then
        outputChatBox("Uzyj: /ban <id/nick> <czas> <jednostka:m/h/d> <powod>", plr)
        return
    end

    local target=findPlayer(plr,cel)

    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!", plr)
        return
    end

    jednostka=string.lower(jednostka)
    if (jednostka=="m") then
        jednostka="MINUTE"
    elseif (jednostka=="h" or jednostka=="g") then
        jednostka="HOUR"
    elseif (jednostka=="d") then
        jednostka="DAY"
    else
        outputChatBox("Uzyj: /ban <id/nick> <czas> <jednostka:m/h/d> <powod>", plr)
        outputChatBox("Jednostki: m - minuta, h - godzina, d - dzien", plr)
        return
    end


    czas=tonumber(czas)
    if (not czas or czas<1) then
        outputChatBox("Nieprawidlowy okres czasu.",plr)
        return
    end
    local userid=getElementData(target, "auth:uid")
    local q = string.format("INSERT INTO psz_bany SET player_banned=%d,serial='%s',date_end=NOW()+INTERVAL %d %s,reason='%s',notes='%s',player_given=%d", 
        userid,getPlayerSerial(target),czas,jednostka,reason,getPlayerName(target),getElementData(plr,"auth:uid"))
   -- end
    local query = exports["psz-mysql"]:zapytanie(q)
    if (not query) then
        outputChatBox("Nie udalo sie wprowadzic bana do bazy danych.", plr)
        return
    end
    local slogin=string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    if (not slogin) then
        outputChatBox("Nie jestes zalogowany!", plr)
        return
    end
    local kto=string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")

    if isInvisibleAdmin(plr) then
        slogin = "Konsola 23J"
    end
    outputConsole("Gracz "..kto.." został/a zbanowany/a przez "..slogin..".")
    outputConsole("Powód: ".. reason)
    triggerClientEvent("gui_showOgloszenie", root, "Gracz "..kto.." został/a zbanowany/a przez "..slogin..". Powód: "..reason..".","Informacja o nadanej karze")
    kickPlayer(target,"Polacz sie od nowa.")

end

addCommandHandler("ban", cmd_ban, true,false)