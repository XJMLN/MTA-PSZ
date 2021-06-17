local brama = {}

addEventHandler("onResourceStart", resourceRoot, function()
    brama.o=getElementByID("brama-cn")
--<object id="brama-cn" breakable="true" interior="0" alpha="255" model="980" doublesided="false" scale="1" dimension="0" posX="2794.04" posY="1827.0107" posZ="12.5937" rotX="0" rotY="0" rotZ="90"></object>
end)
brama.animacja=false
brama.zamknieta=true

brama.otworz=function()
    if (brama.animacja or not brama.zamknieta) then return false end
    brama.animacja=true
    moveObject(brama.o,5500,2794.04,1827.0107,12.5937-7,0,0,0,"OutBounce")
    brama.zamknieta=false
    setTimer(function() brama.animacja=false end, 6000, 1)
end

brama.zamknij=function()
    if (brama.zamknieta) then return false end
    brama.animacja=true
    
    moveObject(brama.o,5500,2794.04,1827.0107,12.5937,0,0,0,"OutBounce")
    brama.zamknieta=true
    setTimer(function() brama.animacja=false end, 6000, 1)
end

local col = createColSphere(2793.64,1827.05,10.82,9)
brama.toggle=function(el,md)
    local c= getElementData(el,"character")
    if not c or not c.id then return end
    if c.gg_id and tonumber(c.gg_id)==2 then
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
    if c.gg_id and tonumber(c.gg_id)==2 then
        if (brama.zamknieta) then
        else
            brama.zamknij()
        end
    end
end
addEventHandler("onColShapeLeave",col,brama.toggle2)