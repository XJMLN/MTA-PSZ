--[[

strefy bez dm

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-strefy
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local strefy = {
    {1637.84,1283.94,9.65,80,36.25,25,int=0,vw=0}, -- LV spawn
    {2420.06,-1722.36,11.28,120.75,93.75,55,int=0,vw=0}, -- LS Grove
   -- {-727.38,930.76,11,60,60,25,int=0,vw=0}, -- TR Rancho
    {-2446.19,-639.73,128.45,78,75.75,30,int=0,vw=0}, -- SF Miss Hill
    {163.69,-1902.29,-2.83,195,121.75,45.75,int=0,vw=0}, -- LS Plaża
    {2403.96,-18.33,25.21,50,50,33.25,int=0,vw=0}, -- Szpital PC
    {-57.38,-321.75,-4.07,75,79.75,50,int=0,vw=0}, -- Remiza BB
    {-2096.07,-280.79,33.57,85.25,190,50,int=0,vw=0}, -- Tor Gokart SF
    {2232.38,2418.10,-4.5,103.5,90.5,53.25,int=0,vw=0}, -- Komisariat policji AP
    {2265.99,-1231.95,-21.75,55.25,48,13.25,int=1,vw=8}, -- Int Szpital
    --{1971.34,-1787.15,11.96,49,25,14.75,int=0,vw=0}, -- LS Mechanik
    {1848.01,2402.21,19.58,27.75,30.5,4.75,int=42,vw=1}, -- AFK zone
    --{-2169.91, 874.5, 76.23,48.75, 105, 100, int=0,vw=0}, -- sf spawn
    {470, -34.84, 998.92,38.75,38.5,8.5, int=17, vw=0}, -- LS alhambra
    { 1747.35, -1594.0, 1732.4,70.25,68.75,31, int=0, vw=231}, -- AJ
   -- {-3086.24,-3364.54,-21,10000,10000,10000,int=0,vw=2430}, -- Eventowa mapka
   {-294.48, 2576.64, 53.70, 100.5,58.5,18.75, int=0, vw=0}, -- LP spawn
   {2617.24, 1163.43, 9.57,60.25,79.75,50, int=0, vw=0},
   { 363.28430175781, 2315.7409667969, 1888.5668945313,25,17,25,int=10, vw=0}, -- int kosciol LS
  -- {-275.33, 2574.75, 70.04, 36.75,40.75,5.75,int=85, vw=666 }, -- bar int LP
   --{-213.57, 2595.30, 61.66,9.25, 6, 6.75, int=11, vw=432}, -- kibel meski
   --{-213.57, 2595.30, 61.66,9.25, 6, 6.75, int=10, vw=431}, -- kibel damski
   --{276.96,102.86,11.84,120,120,120, int=52, vw=21}, -- arena ztp
  --{ -1555.02, 900.41, 5.78,23.75,45,38, int=0,vw=0}, -- choinka sf
   {3044.45, 10.45, 10, 150, 120, 150, int=12, vw=121},
   {1235.66,-1009.97,1068.85,30,20,50,int=5, vw=10}, -- kosciol sf
   { -2100.16796875, 1332.5531005859, 4.5153656005859,43,105,23.75,int=0, vw=0},
}
for i,v in ipairs(strefy) do
    v.strefa = createColCuboid(v[1],v[2],v[3],v[4],v[5],v[6])
    setElementInterior(v.strefa,v.int)
    setElementDimension(v.strefa,v.vw)
    setElementData(v.strefa,"strefa",i)
end

local function isAdminInEvZones(plr)
    local ev = {

    {0,2430}, -- ev mapa
    {52,21}, -- aztp
    {12,121}, -- add

    }

    for i, v in pairs(ev) do
        if getElementDimension(plr) == v[2] and getElementInterior(plr) == v[1] then return true else return false end
    end
end

local function getcpoint(el)
        if (isElementWithinAColShape(el)) then return true else return false end
end

setTimer(function()
    if (not isCursorShowing()) then 
        local level = getElementData(localPlayer,"level") or 0
        if (getElementData(localPlayer,"strefa:nodm")) and (getcpoint(localPlayer)) then 
            toggleControl("fire",false)
            toggleControl("aim_weapon",false)
            if (level and level>0) then
                toggleControl("aim_weapon",true)
            end
        elseif (getElementData(localPlayer,"strefa:nodm")) and (not getcpoint(localPlayer)) then
            toggleControl("fire",true)
            toggleControl("aim_weapon",true)
            setElementData(localPlayer,"strefa:nodm",false)
        elseif (not getElementData(localPlayer,"strefa:nodm")) and (getcpoint(localPlayer)) then
            setElementData(localPlayer,"strefa:nodm",true)
            toggleControl('fire',false)
            toggleControl('aim_weapon',false)
            if (level and level>0) then
                toggleControl("aim_weapon",true)
            end
        end
    end
end,1000,0)

function isElementWithinAColShape(element)
    element = element or localPlayer or getLocalPlayer()
    if element or isElement(element)then
        for _,colshape in ipairs(getElementsByType("colshape"))do
            if (getElementData(colshape,'strefa')) then
            if isElementWithinColShape(element,colshape) then
                return true
            end
            end
        end
    end
    return false
end

function onTakeDamage(attacker, weapon, bodypart)
    if getElementData(source,"strefa:nodm") then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerDamage",getLocalPlayer(),onTakeDamage)

function onPlayerKilled(target)
    if getElementData(target,"strefa:nodm") then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerStealthKill",getLocalPlayer(),onPlayerKilled)

function onPlayerColHit(theElement,matchingDimension)
    if (getElementData(source,'strefa')) then
    if (not matchingDimension) or getElementInterior(theElement)~=getElementInterior(source) then return end
    if (getElementType(theElement)=='player') then
        if theElement~=getLocalPlayer() then return end
        toggleControl("fire",false)
        toggleControl("aim_weapon",false)
        setElementData(theElement,"strefa:nodm",true)
    elseif (getElementType(theElement) == "vehicle") then
        local occu = getVehicleOccupants(theElement) or {}
        for i,v in pairs(occu) do
            if (v and getElementType(v) == "player") then
                if v ~= getLocalPlayer() then return end
                toggleControl("fire",false)
                toggleControl("aim_weapon",false)
                setElementData(v,"strefa:nodm",true)
            end
        end
    end
end
end
addEventHandler('onClientColShapeHit',resourceRoot,onPlayerColHit)


function onPlayerColLeave(theElement,matchingDimension)
    if (getElementData(source,'strefa')) then
    if (not matchingDimension) or getElementInterior(theElement)~=getElementInterior(source) then return end
    if (getElementType(theElement)=='player') then
        if theElement~=getLocalPlayer() then return end
        toggleControl("fire",true)
        toggleControl("aim_weapon",true)
        triggerServerEvent('onPlayerColLeave',theElement)
    elseif (getElementType(theElement) == "vehicle") then
        local occu = getVehicleOccupants(theElement) or {}
        for i,v in pairs(occu) do
            if (v and getElementType(v) == "player") then
                if v ~= getLocalPlayer() then return end
                toggleControl("fire",true)
                toggleControl("aim_weapon",true)
                triggerServerEvent('onPlayerColLeave',v)
            end
        end
    end
end
end
addEventHandler('onClientColShapeLeave',resourceRoot,onPlayerColLeave)

function admin_CollisionDamage(attacker, weapon, bodypart, loss)
    if attacker and weapon == 38 and getElementDimension(attacker) == 2430 and getElementDimension(source) == 2430 then return end
    if attacker and weapon == 38 and getElementDimension(attacker) == 21 and getElementDimension(source) == 21 and getElementInterior(attacker) == 52 and getElementInterior(source) == 52 then return end
    if attacker and getElementDimension(attacker) == 2430 and getElementDimension(source) == 2430 then 
        cancelEvent()
    elseif getElementDimension(source) == 2430 then 
        cancelEvent()
    elseif attacker and getElementDimension(attacker) == 21 and getElementDimension(source) == 21 and getElementInterior(attacker) == 52 and getElementInterior(source) == 52 then
        cancelEvent()
    elseif getElementDimension(source) == 21 and getElementInterior(source) == 52 then
        cancelEvent()
    end
end

addEventHandler('onClientPlayerDamage',getLocalPlayer(),admin_CollisionDamage)