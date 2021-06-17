--[[

Core - statystyki serwera: ilość graczy oraz spis graczy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

---setTimer(function()
   -- local ilosc=#getElementsByType("player") or 0
    --local query=string.format("insert into psz_currentstats set name='online_players',value_i=%d ON DUPLICATE KEY UPDATE value_i=%d", ilosc, ilosc)
    --exports["psz-mysql"]:zapytanie(query)
--end, 31000, 0)

setTimer(function()
        local dane={}
        local gracze=getElementsByType("player")
        for i,v in ipairs(gracze) do
            local c=getElementData(v,"character")
            local fid=getElementData(v,"faction:id")
            if c then
                c.nick = replaceIlleagalCharacters(c.nick)
                local aninja = getElementData(v,"admin:ninja") or false
                table.insert(dane, { tonumber(c.id), c.nick, c.skin, getElementData(v,"auth:uid"), (getElementData(v,"vip") and 1 or 0), (fid or 0), getElementData(v,"auth:login"), aninja})
            end
        end
        dane=toJSON(dane)
        local query=string.format("insert into psz_currentstats set name='online_players',value_t='%s' ON DUPLICATE KEY UPDATE value_t='%s'", dane, dane)
        exports['psz-mysql']:zapytanie(query)

    end, 53000, 0)