--[[

Drift - zliczanie punktow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drift
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local sw, sh = guiGetScreenSize()
local x1,y1,x2,y2 = sw*0.2, sh*0.1, sw*0.8, sh*0.8

local wynik = 0

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		addEventHandler("onClientRender", getRootElement(), showScoreCounter)
	end
)

function showScoreCounter()
	local veh = getPedOccupiedVehicle(localPlayer)
	if (not veh) then return end
	if (not isSportowyPojazd(getElementModel(veh))) then return end
	if getVehicleOccupant(veh,0) ~= localPlayer then return end
	tick = getTickCount()
	local angl,vel = calc_angle(veh)
	local tempTick = tick - (idleTime or 0 ) < 750
	if not tempTick and wynik ~= 0 then
		triggerEvent("onPlayerFinish",getRootElement(),localPlayer,wynik)
		wynik = 0
	end
	if angl ~= 0 then
		if wynik == 0 then
			driftTime = tick
		end
		if tempTick then
			wynik = wynik + math.floor(angl*vel)
		else
			wynik = math.floor(angl*vel)
		end
		wynikPokazywany = wynik
		idleTime = tick
	end

	if vel <= 0.3 then end

	if tick - (idleTime or 0 ) < 3000 then
		dxDrawText(string.format("%d Pkt.",wynikPokazywany),x1,y1-10,x2,y2, tocolor(255,255,255,255),1.2,"pricedown","center","bottom",false,true,false)
	end
end

addEvent("vehicleCrashed",true)
addEventHandler("vehicleCrashed",getResourceRootElement(getThisResource()),function()
	if wynik ~= 0 then
	 	wynik = 0
	end
end)
