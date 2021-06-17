--[[

solo: definicje 

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-solo
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function findPlayer(plr,cel)
    local target=nil
    if (tonumber(cel) ~= nil) then
        target=getElementByID("p"..cel)
    else -- podano fragment nicku
        for _,thePlayer in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 1, true) then
                if (target) then
                    outputChatBox("Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
                    return nil
                end
                target=thePlayer
            end
        end
    end
    return target
end

function solo_arenaEnabled()
    local wolne_areny = exports['psz-mysql']:pobierzWyniki("SELECT count(id) ile FROM psz_arena WHERE in_use=0")
    if (wolne_areny and wolne_areny.ile>0) then
        return false
    else
        return true
    end
end

function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end
