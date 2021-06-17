--[[

praca holownik: holowanie pojazdow za $

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-praca_holownik
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local holowanie_vehPoints = {
    {2412.70,-1426.08,22.98}, -- LS
    {-1610.50,1284.55,6.18}, -- Sf
    {2019.97,2161.21,9.92}, -- lv
}

for i,v in ipairs(holowanie_vehPoints) do
    v.marker = createMarker(v[1], v[2], v[3], "cylinder", 4, 0, 53, 90, 150)
        setElementData(v.marker,"holowanie_marker",true)
end

function holowanie_returnVehicleToPoint(hitElement, matchingDimension)
    if (not matchingDimension or not getElementData(source,"holowanie_marker")) then return end
    if (getElementType(hitElement)~="vehicle" or getElementModel(hitElement)~=525) then return end

    local kierowca = getVehicleController(hitElement)
    local towedVehicle = getVehicleTowedByVehicle(hitElement)

    if (not kierowca or not towedVehicle) then return end
        if not getElementData(towedVehicle,"public:vehicle") then outputChatBox("Nie możesz oddać tego pojazdu do skupu.",kierowca,255,0,0) return false end
        local s = math.random(1,2)
        if s == 1 then
            respawnVehicle(towedVehicle)
        else
            local attached = getAttachedElements(towedVehicle)
            destroyElement(attached.blip)
            destroyElement(towedVehicle)
        end
        givePlayerMoney(kierowca,150)
        local uid = getElementData(kierowca,"auth:uid") or 0
        if (uid and tonumber(uid)>0) then
            exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_players_scores SET player_id=%d, nazwa='ZLOM', score=1 ON DUPLICATE KEY UPDATE score=score+1",tonumber(uid)))
            outputChatBox("Za dostarczenie pojazdu do skupu otrzymujesz $150.",kierowca)
        end
end
addEventHandler("onMarkerHit", root, holowanie_returnVehicleToPoint)
