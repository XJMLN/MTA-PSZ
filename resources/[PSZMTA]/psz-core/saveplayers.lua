--[[

Core - zapis danych graczy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function savePlayerData(plr)
    local afk = getElementData(plr,"afk") or 0
    local duty = getElementData(plr,"level") or 0
    local character = getElementData(plr,"character")
    if (not character or not character.id) then return end
        local uid=getElementData(plr,"auth:uid")
        if not uid then return end
    if afk and tonumber(afk) and tonumber(afk)>1 then return end

    if (isSupport(plr) or isAdmin(plr) or isRoot(plr)) then
        if uid then
            local query=string.format("INSERT INTO psz_admin_activity SET data=NOW(),minut=%d,id_player=%d ON DUPLICATE KEY UPDATE minut=minut+%d",1,uid,1)
            exports["psz-mysql"]:zapytanie(query)
        end
    end

    local pz=getElementData(plr,"PZ") or 0
    local ar=getPedArmor(plr)
    local wanted=getPlayerWantedLevel(plr)
    local money=getPlayerMoney(plr)
    if (money<0) then money=0 end
    local skin=getElementModel(plr)
    local kille = character.kills
    local smierc = character.deaths
    local brep = getElementData(plr,"bad_reputation") or 0
    local grep = getElementData(plr,"good_reputation") or 0

    local query = ""
   -- exports["psz-mysql"]:zapytanie(string.format("UPDATE psz_postacie SET  WHERE userid=%d LIMIT 1", ar, wanted, skin, money,kille, smierc, tonumber(character.ab_spray) or 0,tonumber(character.s_bmx) or 0, uid))
    query = string.format("UPDATE psz_players p, psz_postacie pp SET p.datetime_last=NOW(),p.bad_reputation=%d,p.good_reputation=%d,pp.church_visit='%s',p.pz=%d,pp.ar=%d,pp.wanted=%d,pp.skin=%d,pp.money=%d,pp.timeplay=pp.timeplay+1,pp.kills=%d,pp.deaths=%d,pp.ab_spray=%d,pp.s_bmx=%d WHERE p.id=%d AND pp.userid=%d ",brep,grep,tostring(character.church_visit),pz,ar,wanted,skin,money,kille,smierc, tonumber(character.ab_spray) or 0, tonumber(character.s_bmx) or 0,uid,uid)
    
    exports["psz-mysql"]:zapytanie(query)

end

addEventHandler("onPlayerQuit", root, function()
    removeElementData(source,"afk")
    savePlayerData(source)
    local iEdit = getElementData(source,"itemEditor")
    if iEdit and iEdit.active then
        destroyElement(iEdit.object)
        removeElementData(plr,"itemEditor")
    end
end)

local lasti=0
function playerLoop()
lasti=lasti+1
if (lasti==3) then lasti=0 end
for i,v in ipairs(getElementsByType("player")) do
    local id=getElementData(v,"id")
    if (id and id%3==lasti) then
        savePlayerData(v)

    end
end
end
setTimer(playerLoop, 50000, 0)
--setTimer(playerLoop, 30000, 0)