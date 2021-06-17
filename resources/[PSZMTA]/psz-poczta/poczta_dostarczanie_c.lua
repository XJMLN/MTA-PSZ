--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEvent("onPlayerGetDeliveryPackage",true)
addEventHandler("onPlayerGetDeliveryPackage",getRootElement(),function(v)
        v.drzwi=split(v.drzwi,',')
        for ii,vv in ipairs(v.drzwi) do v.drzwi[ii]=tonumber(vv) end
    local marker = createMarker(v.drzwi[1],v.drzwi[2],v.drzwi[3],"cylinder",2,255,0,0,255)
        setElementData(marker,'marker:poczta',tonumber(v.id))
    local blip = createBlipAttachedTo(marker,12,2,255,0,0,255,0,65535,source)
        setElementParent(marker,blip)
addEventHandler('onClientMarkerHit',marker,function(hitPlayer,matchingDimension)
        if (not matchingDimension) then return end
        if (hitPlayer~=localPlayer) then return end
    if (getElementData(source,'marker:poczta')) then
            triggerServerEvent('onPlayerDeliveryPackage',hitPlayer,getElementData(source,'marker:poczta'))
            outputChatBox("Dostarczyłeś/aś list do adresata. :) Otrzymujesz 1 PZ oraz $55.",53, 90, 130)
            outputChatBox("Jeśli chcesz dalej rozwozić listy, wróć do bazy.",53, 90, 130)
        destroyElement(source)
        destroyElement(blip)
    end
end)
end)