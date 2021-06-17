--[[

wash - mycie pojazdow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-wash
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local myShader = dxCreateShader("texture.fx")

addEventHandler("onClientElementDataChange", root,function (dataName)
    if (getElementType(source) == "vehicle") and (dataName == "vehicle:clean") then
        engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256", source)
        engineApplyShaderToWorldTexture(myShader, "?emap*", source)
    end
end
)

addEventHandler("onClientElementDataChange", root,function (dataName)
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if (getElementData(vehicle, "vehicle:clean")) then
            engineApplyShaderToWorldTexture(myShader, "vehiclegrunge256", vehicle)
            engineApplyShaderToWorldTexture(myShader, "?emap*", vehicle)
        end
    end
end
)