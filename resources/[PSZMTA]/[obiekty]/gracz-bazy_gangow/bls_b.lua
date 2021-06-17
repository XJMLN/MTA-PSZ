local brama = {}

addEventHandler("onResourceStart", resourceRoot, function()
    brama.o=getElementByID("brama_bls")
--"-2272.8" posY="2351.6" posZ="6.59" rotX="0" rotY="0" rotZ="54"
end)
brama.animacja=false
brama.zamknieta=true

brama.otworz=function()
    if (brama.animacja or not brama.zamknieta) then return false end
    brama.animacja=true
    moveObject(brama.o,5500,-2272.8,2351.6,6.59-7,0,0,0,"OutBounce")
    brama.zamknieta=false
    setTimer(function() brama.animacja=false end, 6000, 1)
end

brama.zamknij=function()
    if (brama.zamknieta) then return false end
    brama.animacja=true
    
    moveObject(brama.o,5500,-2272.8,2351.6,6.59,0,0,0,"OutBounce")
    brama.zamknieta=true
    setTimer(function() brama.animacja=false end, 6000, 1)
end

local col = createColSphere(-2273.35,2352.00,4.82,9)
brama.toggle=function(el,md)
    local c= getElementData(el,"character")
    if not c or not c.id then return end
    if c.gg_id and tonumber(c.gg_id)==3 then
        if (brama.animacja) then
            outputChatBox("Odczekaj chwilę.", el, 255, 0, 0, true)
            return
        end 
        if (brama.zamknieta) then
            brama.otworz()
        end
    end
end
addEventHandler("onColShapeHit",col,brama.toggle)

brama.toggle2=function(el,md)
    local c= getElementData(el,"character")
    if not c or not c.id then return end
    if c.gg_id and tonumber(c.gg_id)==3 then
        if (brama.zamknieta) then
        else
            brama.zamknij()
        end
    end
end
addEventHandler("onColShapeLeave",col,brama.toggle2)