--[[

Frakcja: Policja - Komputer pokladowy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-frakcje_policja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local function findPlayerByUID(uid)
    for i,v in ipairs(getElementsByType("player")) do
        local c = getElementData(v,"character")
        if c and c.id and tonumber(c.id) == uid then return v end
    end
    return nil
end


addEvent("getInfomationAboutPlayer",true)
addEventHandler("getInfomationAboutPlayer", resourceRoot, function(plr, pid)
local fr = getElementData(client,"faction:data")
if (fr and fr.id ~= 2) then return end
    local fplayer = findPlayerByUID(tonumber(pid))
    if fplayer then
        local cel = getElementData(fplayer,"character")
        local t = string.format("Nick: %s\nPoziom poszukiwania: %d\nPoszukiwany za: Brawurowa jazda, wysoka prędkość.",cel.nick, cel.wanted)
        triggerClientEvent(client,"onReturnInformation",resourceRoot,t)
    --else
        --outputChatbox('can"t find cel')
    end
end)