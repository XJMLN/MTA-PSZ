-- brama na zewnatrz
local brama={}

addEventHandler("onResourceStart", resourceRoot, function()

brama.o=getElementByID("brama_drag")
end)

brama.animacja=false
brama.zamknieta=true

brama.otworz=function()
    if (brama.animacja or not brama.zamknieta) then return false end
    brama.animacja=true
	    --{988,-58.4,2528.7,16.5,0,0,180,1,0,0, true},
    moveObject(brama.o,7000,-58.4+5.3,2528.7,16.5,0,0,0,"OutBounce")
    brama.zamknieta=false
    setTimer(function() brama.animacja=false end, 6000, 1)
end

brama.zamknij=function()
    if (brama.zamknieta) then return false end
    brama.animacja=true

    moveObject(brama.o,7000,-58.4,2528.7,16.5,0,0,0,"OutBounce")
    brama.zamknieta=true
    setTimer(function() brama.animacja=false  end, 6000, 1)
end

local col = createColSphere(-58.45,2524.28,16.49,3)
brama.toggle=function(el,md)
    if (brama.animacja) then
	outputChatBox("Odczekaj chwilę.", el, 255,0,0,true)
	return
    end
    if (brama.zamknieta) then
	brama.otworz()
    end
end

addEventHandler("onColShapeHit",col,brama.toggle)

brama.toggle2=function(el,md)
        if (brama.zamknieta) then
        else
            brama.zamknij()
        end
end
addEventHandler("onColShapeLeave",col,brama.toggle2)
