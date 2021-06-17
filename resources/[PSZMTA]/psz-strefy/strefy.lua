--[[

strefy bez dm

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-strefy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

addEvent("onPlayerColLeave",true)
addEventHandler('onPlayerColLeave',root,function(special)
    removeElementData(source,'strefa:nodm')
    toggleControl(source,'fire',true)
    toggleControl(source,'aim_weapon',true)
    if (special) then 
    	removeElementData(source,"strefa:nodm_special")
    end
end)
addEventHandler("onVehicleDamage",getRootElement(), 
    function(loss) 
        if getVehicleID(source) == 432 then 
            setElementHealth(source,getElementHealth(source) - loss) 
        end 
    end 
) 
  