--[[

BMX skill - zwiekszanie skillu za jazde bmx'em

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-rozne
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

function getVehicleSpeed(who)
	if isPedInVehicle(who) then 
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(who))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 161
    end
    return 0
end

function bmx_math()
	local gracze = getElementsByType("player")
	for i,v in ipairs(gracze) do
		local veh = getPedOccupiedVehicle(v)
		if (veh and getVehicleController(veh)==v) then 
			if (getElementModel(veh)==481) then -- BMX
				if (getVehicleSpeed(v) >0) then 
					local c = getElementData(v, "character")
					if (c and tonumber(c.id)>0) then 
						local uid = getElementData(v, "auth:uid")
							if math.random(1,2)==1 then -- szybka losowość skryptu XD
							exports['psz-mysql']:zapytanie(string.format("UPDATE psz_postacie SET s_bmx=s_bmx+1 WHERE userid=%d", uid))
							local query = exports['psz-mysql']:pobierzWyniki(string.format("SELECT s_bmx FROM psz_postacie WHERE userid=%d", uid))
							if query and query.s_bmx<=100 then
								outputChatBox("Twoja umiejętność jazdy na rowerze wzrosła: "..query.s_bmx.."/100.", getVehicleOccupant(veh, 0))
							end
							triggerEvent("abilities:bmxSkillAdd",root, query.s_bmx, v)
						end
					end
				end
			end
		end
	end
end
setTimer(bmx_math, 1*60*1000, 0)