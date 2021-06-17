--[[

Drugs - automaty z alkoholem

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-drugs
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
butelkiID={1486,1543,1544,1520,1664}
butelkiP={{-0.08,0.03,0.1,0,90,0},{-0.3,0.02,0.1,0,90,0},{-0.3,0.01,0.1,0,90,0},{-0.25,0.023,0.1,0,90,0},{-0.1,0.04,0.1,0,90,-10}}
for i,v in ipairs(getElementsByType("player")) do
    removeElementData(v,"butelka")
end

local butelki = {}
local wypite = 0

function drunk(gracz)
local kielichy=getElementData(gracz,"kielichy")

    if kielichy then
        if kielichy ~= 0 then
            unbindKey(gracz,"mouse1","down",drunk)
            unbindKey(gracz,"mouse2","down",wyrzucenie)
            setElementData(gracz,"kielichy",kielichy - 1)
            wypite = wypite + 1
            setPedAnimation(gracz,"VENDING","VEND_Drink_P",-1,false,true,false,false)
            setTimer(function()
                bindKey(gracz,"mouse1","down",drunk)
                ---bindKey(gracz,"mouse2","down",wyrzucenie)
                end,1400,1)
            if wypite>0 then 
                unbindKey(gracz,"mouse2","down",wyrzucenie)
                
                setTimer(function()
                    bindKey(gracz,"mouse2", "down",wyrzucenie)
                end,1400,1)
            end
        else
            triggerClientEvent("onGUIOptionChange", gracz, "motionblur", true)
            wyrzucenie(gracz)
        end
    end
end

function deleteAttachButelki(plr)
    source = plr
    exports['bone_attach']:detachElementFromBone(butelki[source])
    destroyElement(butelki[source])
    butelki[source] = nil
end
function wyrzucenie(gracz)
    source = gracz
    wypite = 0
    if (not butelki[source] or not isElement(butelki[source])) then
        return
    end
    if (isElement(source)) then
    end
    local butelka=getElementData(source,"butelka")
    if (butelka) then
        setPedAnimation(source,"MISC","KAT_Throw_K",800,false,true,false,false)
        removeElementData(source,"kielichy")
        removeElementData(source,"butelka")
        setTimer(deleteAttachButelki,800,1,source)
        setElementData(source,"drunkLevel",8)
        toggleControl(source,"fire",true)
        unbindKey(source,"mouse1","down",drunk)
        unbindKey(source,"mouse2","down",wyrzucenie)
    end
end

function dodawanieButelki(gracz,id)
        source = gracz
        if (not id)or(id<1)or(id>5) then
                id=math.random(1,5)
        end
        if (butelki[source] and isElement(butelki[source])) then destroyElement(butelki[source]) end
        
        butelki[source]=createObject(butelkiID[id],0,0,0)
        setElementCollisionsEnabled(butelki[source], false)
    exports["bone_attach"]:attachElementToBone(butelki[source],source,11,butelkiP[id][1],butelkiP[id][2],butelkiP[id][3],butelkiP[id][4],butelkiP[id][5],butelkiP[id][6])
        setElementData(gracz,"kielichy",math.random(4,7))
        setElementData(gracz,"butelka",butelki[source])
        setElementDimension(butelki[source], getElementDimension(gracz))
        setElementInterior(butelki[source], getElementInterior(gracz))
        toggleControl(gracz,"fire",false)
        bindKey(gracz,"mouse1","down",drunk)
        --bindKey(gracz,"mouse2","down",wyrzucenie)
end

local punkty = {
	{227.16,-1846.54,2.38,0,0},
    {-1576.70,547.52,9.13,0,0},
    {-3418.34,1940.41,7.31,0,0},
    {2445.12,-1639.93,17.08,0,0},
    {499.97,-20.65,999.68,0,17},
    {-261.77,2595.24,70.54,666,85},
}
for i,v in ipairs(punkty) do
    v.marker = createMarker(v[1],v[2],v[3],"cylinder",1.2,255,90,101)
    setElementDimension(v.marker,v[4])
    setElementInterior(v.marker,v[5])
end

function handleMarkers(hitElement,matchingDimension)
    if (getElementType(hitElement)~="player") then return end
    if (not matchingDimension) then return end
    if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
    if (getPedOccupiedVehicle(hitElement)) then return end

    for i,v in ipairs(punkty) do
        if (v.marker==source) then
            if (getElementData(hitElement,"kielichy")) then
                outputChatBox("* Musisz wyrzucić butelkę, którą masz w ręku! (kliknij prawym przyciskiem myszy)",hitElement,50,150,50)
            else
                outputChatBox("* Na zdrowie! :)",hitElement,50,150,50)
                dodawanieButelki(hitElement)
            end
        end
    end
end
addEventHandler("onMarkerHit", resourceRoot, handleMarkers)


addEventHandler("onPlayerQuit", root, function()
    if getElementData(source,"butelka") then 
        if (butelki[source] and isElement(butelki[source])) then
            destroyElement(butelki[source]) 
            butelki[source] = nil
        end
    end
end)