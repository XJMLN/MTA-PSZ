--[[

misc - nitro na klawisz

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-misc
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function( )
		bindKey( "vehicle_fire", "both", toggleNOS );
		bindKey( "vehicle_secondary_fire", "both", toggleNOS );
	end
)

function toggleNOS( key, state )
	local veh = getPedOccupiedVehicle(localPlayer);
	if veh and getPedOccupiedVehicleSeat(localPlayer)==0 then
		if state == "up" then
			removeVehicleUpgrade( veh, 1010 );
			setControlState( "vehicle_fire", false );
		else
			addVehicleUpgrade( veh, 1010 );
		end
	end
end
