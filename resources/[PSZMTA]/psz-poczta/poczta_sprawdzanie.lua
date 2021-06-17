--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEvent("getPostToPlayer",true)
addEventHandler('getPostToPlayer',getRootElement(),function()
local c = getElementData(source,'character')
    if (c and c.id) then
        local q = string.format("SELECT p.id,p.ts,pl.nick nadawca FROM psz_poczta p JOIN psz_postacie pl ON pl.userid=p.nadawca  WHERE p.dostarczone=1 AND p.usuniete=0 AND p.odbiorca=%d;",tonumber(c.id))
        local wynik = exports['psz-mysql']:pobierzTabeleWynikow(q)
        triggerClientEvent(source,'onPlayerGetPost',source,wynik)
    end
end)

--triggerServerEvent('getPostTekst',localPlayer,p_listy.id)
addEvent('getPostTekst',true)
addEventHandler('getPostTekst',getRootElement(),function(list_id)
    local q = string.format("SELECT p.id,p.ts,CONCAT(p.tresc,' ') tresc FROM psz_poczta p WHERE p.id=%d AND p.dostarczone=1 AND p.usuniete=0;",tonumber(list_id))
    local tekst = exports['psz-mysql']:pobierzWyniki(q)
        if (tekst) then
            exports['psz-mysql']:zapytanie(string.format("UPDATE psz_poczta SET przeczytane=1 WHERE id=%d",tonumber(list_id)))
            triggerClientEvent(source,'showPlayerPostData',source,tekst)
        end
end)

addEvent('deletePostText',true)
addEventHandler('deletePostText',getRootElement(),function(list_id)
    if (list_id and tonumber(list_id)) then
        local q = string.format("UPDATE psz_poczta SET usuniete=1 WHERE id=%d",tonumber(list_id))
        exports['psz-mysql']:zapytanie(q)
        outputChatBox("List został usunięty.",source)
    end
end)