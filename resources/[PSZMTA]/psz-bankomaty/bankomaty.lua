
local function getPlayerID(plr)
    local c=getElementData(client,"character")
    if not c or not c.id then return nil end
    return tonumber(c.id)
end

addEvent("onRequestBankPermission", true)
addEventHandler("onRequestBankPermission", resourceRoot, function()
        local c=getElementData(client,"character")
        if not c or not c.id then
            triggerClientEvent(client,"doFillATMInfo", resourceRoot, false)
            return
        end
        local dbid=tonumber(getElementData(client,"auth:uid"))
        if not dbid then
            triggerClientEvent(client,"doFillATMInfo", resourceRoot, false)
            return
        end
        local sr=exports["psz-mysql"]:pobierzWyniki("SELECT bank_money FROM psz_postacie WHERE userid="..(tonumber(dbid) or 0).." LIMIT 1")
        if not sr or not sr.bank_money then
            triggerClientEvent(client,"doFillATMInfo", resourceRoot, false)
            return
        end
        triggerClientEvent(client,"doFillATMInfo", resourceRoot, true, tonumber(sr.bank_money))
    end)

addEvent("doATMOperation", true)
addEventHandler("doATMOperation", resourceRoot, function(kwota)
        if kwota>0 and kwota>getPlayerMoney(client) then return end -- komunikat bledu po stronie klienta
        local dbid=getElementData(client,"auth:uid")
        if not dbid then return end -- nie powinno sie zdarzyc

        if kwota>0 then
           
            if getPlayerMoney(client)<kwota then return end
            
            takePlayerMoney(client, kwota)
            exports["psz-mysql"]:zapytanie("UPDATE psz_postacie SET bank_money=bank_money+"..(tonumber(kwota) or 0).." WHERE userid="..tonumber(dbid).." LIMIT 1")
            exports["psz-admin"]:gameView_add("BANK wplata "..getPlayerName(client).."/"..dbid.."/"..getPlayerSerial(client).." kwota "..kwota.."$")
            
        elseif kwota<0 then
            
            local sr=exports["psz-mysql"]:pobierzWyniki("SELECT `bank_money` FROM `psz_postacie` WHERE userid="..tonumber(dbid).." LIMIT 1")
            if not sr or not sr.bank_money then return end -- nie opwinno sie wydarzyc
            sr.bank_money=tonumber(sr.bank_money)
            if (sr.bank_money<math.abs(kwota)) then
                outputChatBox("Nie masz tyle środków na koncie!", client, 255,0,0)
                return
            end

            exports["psz-mysql"]:zapytanie("UPDATE psz_postacie SET bank_money=bank_money-"..math.abs(tonumber(kwota)).." WHERE userid="..tonumber(dbid).." LIMIT 1")
            exports["psz-admin"]:gameView_add("BANK wyplata "..getPlayerName(client).."/"..dbid.."/"..getPlayerSerial(client).." kwota "..kwota.."$")
            givePlayerMoney(client, math.abs(kwota))
        end


    end)
