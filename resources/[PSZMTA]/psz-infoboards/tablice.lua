--[[

Infoboards - Tablice informacyjne

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-infoboards
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEvent("onPlayerRequestIBContents", true)
addEventHandler("onPlayerRequestIBContents", root, function(id)
        dane=exports["psz-mysql"]:pobierzWyniki(string.format("SELECT nazwa,tresc FROM psz_infoboards WHERE id=%d LIMIT 1", id))

        triggerClientEvent(source, "onIBContentsRcvd", resourceRoot, dane)
    end)

addEvent("onPlayerSendIBContents", true)
addEventHandler("onPlayerSendIBContents", root, function(id, tresc)
    if not id or not tresc then return end
    local query=string.format("UPDATE psz_infoboards SET tresc='%s' WHERE id=%d LIMIT 1", tresc, id)
    exports['psz-mysql']:zapytanie(query)
end)

--[[
local function updateAbilities()
    local ttt = ""
    local tt2 = ""
    local query = "SELECT nick,ab_spray FROM psz_postacie WHERE ab_spray>=50 ORDER BY ab_spray DESC;"
    local m1 = exports['psz-mysql']:pobierzTabeleWynikow(query)
    --if (m1==nil) then
       -- ttt = "Aktualnie nie ma graczy z umiejętnością pozwalającą na malowanie."
  --  else
    for i,v in ipairs(m1) do
        local tt2 = ""
        if i==1 then
            tt2 = "Lista graczy z wysoką umiejętnością: "
        else
            tt2 = ""
        end
        ttt = tt2..ttt..string.format("\n%d. %s - %d/100",i, v.nick, v.ab_spray)
    end
   -- end
    query = string.format("UPDATE psz_infoboards SET tresc='%s',ts=NOW() WHERE id=17",ttt)
    exports['psz-mysql']:zapytanie(query)
end

setTimer(function() updateAbilities() end, 300000, 0)
function onRun()
    updateAbilities()
end
addEventHandler("onResourceStart",getRootElement(),onRun)
]]--