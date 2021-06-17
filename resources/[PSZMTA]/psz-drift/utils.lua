--[[

Drift - zliczanie punktow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drift
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function isSportowyPojazd(model)
  local sportowe={402,494,502,503,411,559,561,560,506,451,558,549,555,429,541,415,480,562,565,434,477}
  for i,v in ipairs(sportowe) do
    if model==v then return true end
  end
  return false
end

function calc_angle(pojazd)
    local vx,vy,vz = getElementVelocity(pojazd)
    local modV = math.sqrt(vx*vx + vy*vy)

    if not isVehicleOnGround(pojazd) then return 0,modV end

    local rx,ry,rz = getElementRotation(pojazd)
    local sn, cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

    if modV <= 0.2 then return 0,modV end -- Prędkość poniżej 40km/h

    local cosX = (sn*vx + cs*vy)/modV
    if cosX > 0.966 or cosX < 0 then return 0,modV end -- obrót pomiędzy 15 i 90 stopniami
    return math.deg(math.acos(cosX))*0.5, modV
end

function isPlayerRecordScore(player,wynik)
    local playerRecord = getElementData(player,"drift")
    if (wynik > (playerRecord or 0)) then
        triggerServerEvent("newPlayerRecordScore",resourceRoot,player,wynik)
    end
end
addEvent("onPlayerFinish",true)
addEventHandler("onPlayerFinish",getRootElement(),isPlayerRecordScore)
