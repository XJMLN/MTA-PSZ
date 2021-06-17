-- brama na zewnatrz
local brama={}

addEventHandler("onResourceStart", resourceRoot, function()

brama.o=getElementByID("lvpd_brama")
end)

brama.animacja=false
brama.zamknieta=true

brama.otworz=function()
    if (brama.animacja or not brama.zamknieta) then return false end
    brama.animacja=true
	--2237.3999" posY="2453.3" posZ="9.6" rotX="0" rotY="0" rotZ="270"></object>
    moveObject(brama.o,7000,2237.3999,2453.3+10.3,9.6,0,0,0,"OutBounce")
    brama.zamknieta=false
    setTimer(function() brama.animacja=false end, 6000, 1)
end

brama.zamknij=function()
    if (brama.zamknieta) then return false end
    brama.animacja=true

    moveObject(brama.o,7000,2237.3999,2453.3,9.6,0,0,0,"OutBounce")
    brama.zamknieta=true
    setTimer(function() brama.animacja=false  end, 6000, 1)
end

local col = createColSphere(2237,2453,10,10,9)
brama.toggle=function(el,md)
    local fr = getElementData(el,"faction:data")
    if (fr and fr.id==2) then
    --local x,y,z=getElementPosition(brama.o)
--    local x2,y2,z2=getElementPosition(el)
--    local dist1=getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)

    --if ((dist1>5) or getPedOccupiedVehicle(el)) then
	--outputChatBox("Podejdź bliżej do bramy.", el, 255,0,0,true)
--	return
--    end

    if (brama.animacja) then
	outputChatBox("Odczekaj chwilę.", el, 255,0,0,true)
	return
    end
    if (brama.zamknieta) then
	brama.otworz()
    end
    --else
	--brama.zamknij()
    --end
else
    outputChatBox("Aby otworzyć tę bramę, musisz być policjantem.",el,255,0,0)
end
end

addEventHandler("onColShapeHit",col,brama.toggle)

brama.toggle2=function(el,md)
    local fr = getElementData(el,"faction:data")
    if (fr and fr.id==2) then
        --if (brama.animacja) then
        --    outputChatBox("Odczekaj chwilę.", el, 255,0,0,true)
        --    return
    --    end
        if (brama.zamknieta) then
        else
            brama.zamknij()
        end
    end
end
addEventHandler("onColShapeLeave",col,brama.toggle2)
