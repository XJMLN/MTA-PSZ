--[[

Frakcja: Policja - Komputer pokladowy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-frakcje_policja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local sw,sh = guiGetScreenSize()
local screenw, screenh = guiGetScreenSize()
--GUIEditor.combobox[1] = guiCreateComboBox(0.06, 0.12, 0.46, 0.61, "-Wybierz gracza-", true, GUIEditor.window[1])
local poszukiwany_cel = nil
local pager_active=false
local pl= {}
pl.win = guiCreateWindow(sw*114/800, sh*104/600, sw*602/800, sh*382/600, "Komputer policyjny",false)
pl.memo = guiCreateMemo(0.54,0.06,0.45,0.67, "", true, pl.win)
pl.combo = guiCreateComboBox(0.06, 0.12, 0.46, 0.61,"-- Wybierz gracza --", true, pl.win) 
pl.exit = guiCreateButton(0.54, 0.76, 0.43, 0.21, "Zamknij", true, pl.win)
pl.pager = guiCreateButton(0.09, 0.77, 0.40, 0.20, "Namierz gracza", true, pl.win)
guiSetVisible(pl.win, false)
guiWindowSetSizable(pl.win,false)

local function findRotation(startX, startY, targetX, targetY)	-- Doomed-Space-Marine
    local t = -math.deg(math.atan2(targetX - startX, targetY - startY))

    if t < 0 then
        t = t + 360
    end

    return t
end

local function computerCreate()
    showCursor(true)
    guiSetVisible(pl.win,true)
    guiSetText(pl.memo,"")
    guiComboBoxClear(pl.combo)
    for i,v in ipairs(getElementsByType("player")) do
        local c = getElementData(v,"character")
        if c and c.wanted > 0 then
            local t = string.format("%d - %s", c.id, string.gsub(getPlayerName(v),"#%x%x%x%x%x%x",""))
            guiComboBoxAddItem(pl.combo,t)
        end
    end
end

local function computerExit()
    showCursor(false)
    guiSetVisible(pl.win,false)
        if (not getElementData(localPlayer,'pager:active')) then
    poszukiwany_cel = nil
    pager_active=false
    end
end

local function createComputer()
    local f = getElementData(localPlayer,'faction:data') 
    if (f and f.id ~=2) then return end
    if isPedInVehicle(localPlayer) then
        local veh = getPedOccupiedVehicle(localPlayer)
        if (getElementModel(veh) == 596) then
            computerCreate()
        end
    end
end

local function renderPager()
    if (not pager_active or pager_active and not getElementData(localPlayer,"pager:active")) then
        removeEventHandler("onClientRender", root, renderPager)
        pager_active = false
        poszukiwany_cel = nil
    end
    if (poszukiwany_cel and isElement(poszukiwany_cel) and  getElementDimension(poszukiwany_cel)==getElementDimension(localPlayer) and getElementInterior(poszukiwany_cel)==getElementInterior(localPlayer)) then
    local cel_tekst
    local x,y,z=getElementPosition(poszukiwany_cel)
    local px,py,pz=getElementPosition(localPlayer)
    local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
    cel_tekst = string.format("Odległość do celu: %dm",dist)
    dxDrawText(cel_tekst, sw*670/800, sh*398/600, sw*790/800,sh*450/600, tocolor(255,255,255,255), 0.9, "default", "left","top")
        
    -- Import z lss-gui[pager]
    local tx, ty = getWorldFromScreenPosition(screenw * 0.5, screenh * 0.5, 100)
    local cx, cy = getCameraMatrix()
    local cameraAngle = findRotation(cx, cy, tx, ty)
    local kat = cameraAngle - findRotation(px,py,x,y)+270
    dxDrawImage(sw*670/800, sh*300/600, 80, 80, "right_arrow.png",kat)
    end
end
local function pager_init()
    addEventHandler ( "onClientRender", root, renderPager )
    setElementData(localPlayer,"pager:active",true)
    outputChatBox("Aby wyłączyć namierzanie wpisz /pager",255,0,0)
end


local function wyszukaj_cel(uid)
    local c = nil
    for _,p in ipairs(getElementsByType("player")) do
        if (p~=localPlayer) then
            local ch = getElementData(p,"character")
            if ch and ch.id and tonumber(ch.id) == uid then
                c=p
            end
        end
    end
    return c
end
    
local function computerInfo()
    local sc = guiComboBoxGetSelected(pl.combo)
    local uid_poszukiwanego = string.match(guiComboBoxGetItemText(pl.combo,sc) or "","^%d+") -- bylo przez nick - nie dzialalo zbyt dobrze
    if not sc or sc<0 or not uid_poszukiwanego then
        outputChatBox("Najpierw wybierz gracza którego chcesz namierzyć.",255,0,0)
        return
    end
    
    triggerServerEvent("getInfomationAboutPlayer",resourceRoot, localPlayer, uid_poszukiwanego)
    poszukiwany_cel=wyszukaj_cel(tonumber(uid_poszukiwanego))
    pager_active = true
    pager_init()
end

local function computerFill(t)
    if (t) then
        guiSetText(pl.memo,t)
    end
end

local function pager_stop()
    removeEventHandler("onClientRender", root, renderPager)
    setElementData(localPlayer,'pager:active',false)
    pager_active = false
    poszukiwany_cel = nil
end
addEventHandler("onClientGUIClick", pl.pager, computerInfo, false)
addEventHandler("onClientGUIClick", pl.exit, computerExit, false)
addEvent("onReturnInformation",true)
addEventHandler("onReturnInformation",resourceRoot, computerFill)
--addEvent("PD_closePager", true)
--addEventHandler("PD_closePager", localPlayer, pager_stop)
addCommandHandler("pager",pager_stop)
addCommandHandler("komputer",createComputer)