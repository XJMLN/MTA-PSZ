--[[

GUI: System anty-AFK

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local warns = 0
local sw, sh = guiGetScreenSize()
local font = dxCreateFont("font/font.ttf", 31) or "default-bold"
local lx,ly,lz=0,0,0
local rx,ry,rz=0,0,0

function AFKText()
    dxDrawText("Jesteś AFK, za 10 minut zostaniesz wyrzucony.", (381/1280)*sw, (275/720)*sh, (941/1280)*sw, (320/720)*sh, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
end

local function afkCheck()
    if getCameraTarget()~=localPlayer and not getPedOccupiedVehicle(localPlayer) then return end
    if getElementData(localPlayer,"justConnected") then return end
    if getElementData(localPlayer,"kary:blokada_aj") then return end
    if getPlayerName(localPlayer) == "|PSZ|XJMLN" then return end
    local _,_,_,tarx,tary,tarz = getCameraMatrix()

    if (true) then
        clX = tarx
        clY = tary
        clZ = tarz
        local nx,ny,nz = getElementPosition(localPlayer)
        nx,ny,nz = math.floor(nx/10),math.floor(ny/10),math.floor(nz/10)
        local nrx,nry,nrz=getElementRotation(localPlayer)
        nrx,nry,nrz=math.floor(nrx/10),math.floor(nry/7),math.floor(nrz/10)
        if (nx==lx and ny==ly and nz==lz) or (nrx==rx and nry==ry and nrz==rz) then        -- brak zmiany pozycji przez minute OR brak zmiany rotacji
            warns=warns+1
        elseif (warns>0) then
            warns=warns-2
            if (warns<0) then warns=0 end
            lx,ly,lz=nx,ny,nz
            rx,ry,rz=nrx,nry,nrz
            return
        end
    lx,ly,lz=nx,ny,nz
    rx,ry,rz=nrx,nry,nrz

    setElementData(localPlayer, "afk", warns)
    if (warns>1) then -- 2 minuty
        local solo = getElementData(localPlayer,"solo:active_request")
        if solo then
            removeElementData(solo,"solo:active_request")
            removeElementData(localPlayer,"solo:active_request")
        end
            triggerServerEvent("onAFKPlayer",getRootElement(),localPlayer)
    end
    if (warns>10) then -- 10 minuty
        triggerServerEvent("onAFKPlayerKick",getRootElement(),localPlayer)
    end
end
end
addEventHandler("onClientResourceStart",resourceRoot, function()
        lx,ly,lz=getElementPosition(localPlayer)
        rx,ry,rz=getElementRotation(localPlayer)
        lx=math.floor(lx/3)
        ly=math.floor(ly/3)
        lz=math.floor(lz/3)
        local _,_,_,tarx,tary,tarz = getCameraMatrix()
        clX = tarx
        clY = tary
        clZ = tarz
        lastDetectorTick = getTickCount()
        afktimer = setTimer ( afkCheck, 60000, 0)
        --afktimer = setTimer ( afkCheck, 5000, 0)
        setElementData(localPlayer,"afk",0)
        setElementData(localPlayer,"afk:lozko",false)
end)

addEventHandler("onClientCursorMove",getRootElement(), function()
        if (afktimer and (getTickCount()-lastDetectorTick >= 1000)) then
                lastDetectorTick = getTickCount()
                killTimer(afktimer)
                warns=0
                setElementData(localPlayer, "afk", false)
                setElementData(localPlayer,"afk:lozko",false)
                removeEventHandler("onClientRender",root,AFKText)
                afktimer = setTimer(afkCheck, 60000, 0)
                --afktimer = setTimer ( afkCheck, 5000, 0)
        end
end)

addEventHandler("onClientClick",getRootElement(), function()
        if (afktimer and (getTickCount()-lastDetectorTick >= 1000)) then
                lastDetectorTick = getTickCount()
                killTimer(afktimer)
                warns=0
                setElementData(localPlayer, "afk", false)
                setElementData(localPlayer,"afk:lozko",false)
                removeEventHandler("onClientRender",root,AFKText)
                afktimer = setTimer(afkCheck, 60000, 0)
                --afktimer = setTimer ( afkCheck, 5000, 0)
        end
end)

addEventHandler("onClientKey",getRootElement(), function()
        if (afktimer and (getTickCount()-lastDetectorTick >= 1000)) then
                lastDetectorTick = getTickCount()
                killTimer(afktimer)
                warns=0
                setElementData(localPlayer, "afk", false)
                setElementData(localPlayer,"afk:lozko",false)
                removeEventHandler("onClientRender",root,AFKText)
                afktimer = setTimer(afkCheck, 60000, 0)
                --afktimer = setTimer ( afkCheck, 5000, 0)
        end
end)

addEvent("showAFKText",true)
addEventHandler("showAFKText",root, function() addEventHandler("onClientRender",root,AFKText) end)

local cccnt=0
local function cc_check()
  cccnt=cccnt+1
  if cccnt>15 then
    --triggerServerEvent("banMe", localPlayer, "bug-using (#1)")
    removeEventHandler("onClientGUIClick", root, cc_check)
  end

end
addEventHandler("onClientGUIClick", root, cc_check)

setTimer(function()
  cccnt=0
end, 1000, 0)
