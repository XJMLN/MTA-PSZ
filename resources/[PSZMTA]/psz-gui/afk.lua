--[[

GUI: System anty-AFK

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local lozka = {
    {1867.64,2407.85,21.48,171,use=0},
    {1867.49,2411.55,21.48,180,use=0},
    {1867.47,2414.68,21.48,180,use=0},
    {1867.62,2424.30,21.48,180,use=0},
    {1867.69,2427.30,21.48,180,use=0},
    {1867.88,2430.36,21.48,180,use=0},
    {1864.12,2424.48,21.48,0,use=0},
    {1864.65,2427.37,21.48,0,use=0},
    {1864.43,2430.51,21.48,0,use=0},
}
local function isLozkoInUse(numer)
    local gracze = getElementsByType("player",root, true)
    local rrz=math.rad(lozka[numer][4])
    local x2=lozka[numer][1]
    local y2=lozka[numer][2]
    for i,v in ipairs(gracze) do
        if (v~=localPlayer) then
            local x,y,z = getElementPosition(v)
            if (getDistanceBetweenPoints3D(x,y,z,x2,y2,lozka[numer][3])<1.5) then
                lozka[numer][5]=1
                return true
            end
        end
    end
    lozka[numer][5]=0 -- ?
    return false
end

local function zajeteLozka()
    i = 0
    for __,v in ipairs(lozka) do
        if v.use == 1 then
            i=i+1
        end
    end
    if i == 9 then return true else return false end
end
setTimer(zajeteLozka, 5000,0)
function afkTP(plr)
    if isPedInVehicle(plr) then
        removePedFromVehicle(plr)
    end
    if getElementData(plr,"afk:lozko") then return end -- gracz jest afk i tak wiec nie wykonujemy
    if (not zajeteLozka()) then
    for i,v in ipairs(lozka) do
        if v.use<1 then -- jesli nie uzywane
            if (not isLozkoInUse(i)) then -- sprawdzmy zeby miec pewnosc
                v.use = 1
                setElementInterior(plr,42,v[1],v[2],v[3])

                setElementDimension(plr,1)
                setElementPosition(plr,v[1],v[2],v[3])
                setElementRotation(plr,0,0,180)
                setElementInterior(plr,42)
                setElementData(plr,"afk:lozko",true)
                triggerEvent("setPedAnimation",plr,"CRACK","crckidle2",-1,true,false)
                triggerClientEvent(plr,"showAFKText",getRootElement())
                return
            end -- zeby nie loopowalo
        else -- jesli zajete
            if (not isLozkoInUse(i)) then -- sprawdzmy czy na pewno zajete
                v.use = 0
            end
        end
    end
    else
    setElementInterior(plr,42,1862+math.random(0,2.5),2409+math.random(0,2.5),20.83)
    setElementDimension(plr,1)
    setElementPosition(plr,1862+math.random(0,2.5),2409+math.random(0,2.5),20.83)
    setElementInterior(plr,42)
    setElementData(plr,"afk:lozko",true)
    triggerClientEvent(plr,"showAFKText",getRootElement())
    if getElementData(plr,"duty:dj") and getElementData(plr,"faction:id") == 6 then 
        exports['psz-grupy']:dj_quitGroup('AFK',plr)
    end
end
end
addEvent("onAFKPlayer",true)
addEventHandler("onAFKPlayer",getRootElement(),afkTP)

addEvent("onAFKPlayerKick",true)
addEventHandler("onAFKPlayerKick",getRootElement(),function(plr)
    kickPlayer(plr, "Zostałeś wyrzucony za 10 minut AFK.")
end)
