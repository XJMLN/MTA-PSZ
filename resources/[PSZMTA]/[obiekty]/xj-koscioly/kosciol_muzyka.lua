local VW=0
local I=10
kosciol=createColSphere(374.53,2324.52,1889.57,350)	-- kosciol ls
setElementDimension(kosciol,VW)
setElementInterior(kosciol,I)



local muzyka

local function onClientColShapeHit( theElement, matchingDimension )
    if (not matchingDimension) then return end
    if ( theElement == getLocalPlayer() and getElementInterior(source)==getElementInterior(localPlayer)) then  -- Checks whether the entering element is the local player
        if (source==kosciol) then
            muzyka=playSound("audio/fx-kosciol.ogg",true)
        end
    end
end

local function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == getLocalPlayer() ) then  -- Checks whether the entering element is the local player
        if (source==kosciol) then
            stopSound(muzyka)
        end
    end
end




addEventHandler("onClientColShapeHit",getResourceRootElement(),onClientColShapeHit)
addEventHandler("onClientColShapeLeave",getResourceRootElement(),onClientColShapeLeave)