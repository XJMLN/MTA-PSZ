--[[

Policyjne swiatla

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

-- Simple Police-Lights by MuLTi!

p_lights = {}
p_timer = {}
p_lvar = {}
p_pvar = {}
p_lvar2 = {}
p_lvar3 = {}
p_lvar4 = {}



function toggleLights(thePlayer, cmd)
    local level = 2
    local veh = getPedOccupiedVehicle(thePlayer)
    local id = getElementModel(veh)
    if (id == 598) or (id == 596) or (id == 597) or (id == 599) then
        if(level == 2) then
            if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
                p_lights[veh] = 1
                setVehicleOverrideLights ( veh, 2 )
                p_timer[veh] = setTimer(
                    function()
                        if(p_lvar3[veh] == 4) then
                            setTimer(function() p_lvar3[veh] = 0 end, 1000, 1)
                            setTimer(
                                function()
                                    if(p_lvar4[veh] == 1)then
                                        p_lvar4[veh] = 0
                                        setVehicleLightState ( veh, 1, 0)
                                        setVehicleLightState ( veh, 2, 0)
                                        setVehicleLightState ( veh, 0, 1)
                                        setVehicleLightState ( veh, 3, 1)
                                        setVehicleHeadLightColor(veh, 77, 77, 255)
                                    else
                                        setVehicleLightState ( veh, 3, 0)
                                        setVehicleLightState ( veh, 0, 0)
                                        setVehicleLightState ( veh, 1, 1)
                                        setVehicleLightState ( veh, 2, 1)
                                        setVehicleHeadLightColor(veh, 255, 77, 77)
                                        p_lvar4[veh] = 1
                                    end
                                end, 50, 5)
                            return end
                        if(p_lvar2[veh] == 0) or (p_lvar2[veh] == nil) then
                            p_lvar2[veh] = 1
                            setVehicleLightState ( veh, 1, 0)
                            setVehicleLightState ( veh, 2, 0)
                            setVehicleLightState ( veh, 0, 1)
                            setVehicleLightState ( veh, 3, 1)
                            setVehicleHeadLightColor(veh, 0, 0, 255)
                        else
                            setVehicleLightState ( veh, 3, 0)
                            setVehicleLightState ( veh, 0, 0)
                            setVehicleLightState ( veh, 1, 1)
                            setVehicleLightState ( veh, 2, 1)
                            setVehicleHeadLightColor(veh, 255, 0, 0)
                            p_lvar2[veh] = 0
                        end
                        if(p_lvar3[veh] == nil) then p_lvar3[veh] = 0  end
                        p_lvar3[veh] = (p_lvar3[veh]+1)
                    end, 500, 0)
            else
                p_lights[veh] = 0
                killTimer(p_timer[veh])
                setVehicleLightState ( veh, 0, 0)
                setVehicleLightState ( veh, 1, 0)
                setVehicleLightState ( veh, 2, 0)
                setVehicleLightState ( veh, 3, 0)
                setVehicleHeadLightColor(veh, 255, 255, 255)
                setVehicleOverrideLights ( veh, 1 )
            end
        end
    end
end
addCommandHandler("frakcjekoguty", toggleLights)


addEventHandler ( "onVehicleExplode", getRootElement(),
    function()
        if(p_lights[source] == 1) then
            killTimer(p_timer[source])
        end
    end )

addEventHandler ( "onVehicleRespawn", getRootElement(),
    function()
        if(p_lights[source] == 1) then
            killTimer(p_timer[source])
        end
    end )

addEventHandler("onElementDestroy", getRootElement(),
    function ()
        if getElementType(source) == "vehicle" then
            if(p_lights[source] == 1) then
                killTimer(p_timer[source])
            end
        end
    end)
