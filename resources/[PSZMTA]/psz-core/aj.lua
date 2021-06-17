local I = 0
local D = 231

local mexit = createMarker(1780.55,-1576.44,1734.94,"arrow",1)
local aj_cs = createColSphere(1768.89,-1572.70,1734.94,35)
setElementInterior(aj_cs,I)
setElementDimension(aj_cs,D)
setElementInterior(mexit,I)
setElementDimension(mexit,D)
local texit = createElement("text")
setElementPosition(texit,1780.55,-1576.44, 1735.4)
setElementDimension(texit,D)
setElementData(texit,"text","Wyjście z AJ")

addEventHandler("onMarkerHit", mexit, function(el,md)
    if (not md) then return end
    if (getElementType(el)~="player") then return end
    local aj = getElementData(el,"kary:blokada_aj")
    if (not aj or tonumber(aj)<1) then
        setElementPosition(el,887.37,-2371.54,13.28)
        setElementRotation(el,0,0,297.4)
        setElementInterior(el,0)
        setElementDimension(el,0)
        removeElementData(el,"kary:blokada_aj")
        outputChatBox("Wychodzisz z Admin Jail'a, mamy nadzieję że będziemy Ciebie tam widywać jak najrzadziej.",el,255,0,0)
        savePlayerData(el)
        return
    else
        outputChatBox("Twój AJ kończy sie za ".. aj .." min.", el, 255,0,0,true)
    end
end)

function aj_process()
for i,v in ipairs(getElementsWithinColShape(aj_cs,"player")) do
    local aj=getElementData(v,"kary:blokada_aj")
    local uid = getElementData(v,"auth:uid")
    if (uid and tonumber(aj)) then
        aj=tonumber(aj)-1
        setElementData(v,"kary:blokada_aj",aj)
        if (aj<0) then aj=0 end
            local query = string.format("UPDATE psz_players SET blokada_aj=%d WHERE id=%d LIMIT 1",aj,uid)
            exports['psz-mysql']:zapytanie(query)
            if (aj<=0) then
                outputChatBox("Twój AJ się skończył, możesz opuścić więzienie.",v,255,0,0,true)
                removeElementData(v,"kary:blokada_aj")
            end
        end
    end
end

setTimer(aj_process, 60000,0)