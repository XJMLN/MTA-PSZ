--[[

Wyścigi drag 

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drags
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local tt 

local drag_meta  = nil
function dr_return(s)
	local di = getElementData(s,"drag:data")
	if (di and di.id>0) then return di else return false end
end

function dr_hitStartRace(hitElement, md)
	if (not md) then return end
	local drag = dr_return(source)
	if not drag then return end

	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and veh == hitElement and getVehicleController(veh) == localPlayer then 
		local _,_,rz = getElementRotation(veh)
		if drag.meta and drag_meta == source then 
			if rz<drag.rot[2] and rz>drag.rot[1] then 
				local czas = getTickCount()-tt
				local tczas = string.format("%.3fs", czas/1000)
				outputChatBox("Twój czas na tym torze wynosi: "..tczas.."! Gratulacje!",255,0,0)
				triggerServerEvent("dr_saveTrackRecord",resourceRoot, localPlayer, drag.id,getElementModel(veh), czas)
				setElementVelocity(veh,0,0,0)
			end
			triggerEvent("startRaceTimer",root, false)
			tt = nil
			drag_meta = nil
			return
		elseif not drag.meta and not drag_meta then 
			if rz<drag.rot[2] and rz>drag.rot[1] then 
				setWorldSpecialPropertyEnabled("aircars", false)
				if drag.type == 1 then
					if getElementData(veh,"vehicle:hedit") then 
						outputChatBox("Ten wyścig nie jest dotępny dla pojazów z zmodyfikowanym handlingiem.",255,0,0)
						return
					end
					drag_meta = drag.pair
					tt = getTickCount()
					setElementData(localPlayer,"hedit_ban",true)
					triggerEvent("startRaceTimer",root, true)
					return
				elseif drag.type == 2 then 
					if not getElementData(veh,"vehicle:hedit") then 
							outputChatBox("Ten wyścig nie jest dotępny dla pojazów bez zmodyfikowanego handlingu.",255,0,0)
						return
					end
					drag_meta = drag.pair
					tt = getTickCount()
					setElementData(localPlayer,"hedit_ban",true)
					triggerEvent("startRaceTimer",root,true)
					return
				end
			end
		end
	end
end

addEventHandler ("onClientColShapeHit", resourceRoot, dr_hitStartRace)