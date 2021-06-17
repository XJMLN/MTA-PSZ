--[[

GUI: Glowny zasob graficzny

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local sw,sh=guiGetScreenSize()
local mw,mh = 800, 600
local guiopts={cinematic=false,bg_charsel=false}
local font = dxCreateFont("font/homework.ttf",30)
if not font then font="Pricedown" end
local ldc = dxCreateFont("font/klavik.otf",22, false)
if not ldc then ldc="Pricedown" end
local countFont = dxCreateFont("font/asr.ttf", 122, false)
if not countFont then countFont="Pricedown" end
local mpregular = dxCreateFont("font/mp_regular.ttf", 23,false)
if not mpregular then mpregular="Pricedown" end 
local mpregularB = dxCreateFont("font/mp_regular.ttf", 10,false)
if not mpregularB then mpregularB="Pricedown" end 
local fontInfo = dxCreateFont("font/font.ttf", 31) 
if not fontInfo then fontInfo="default-bold" end
local tdm = {}
tdm.active = true
tdm.count = 0
local ph = math.floor(sh/20)
local countdown={}
ogloszenie = {}
ogloszenie.rodzaj = ""
ogloszenie.text = ""
ogloszenie.ts = nil
ogloszenie.event = false
local limit_czasu = 10000
local stoper_st=nil
local stoper_width=dxGetTextWidth("00:00.00", 1, ldc)
local fr_timer=dxGetTextWidth("00:00", 1, mpregular)
local fr_timerB=dxGetTextWidth("Jeżeli teraz zabijesz jakiegoś gracza, trafisz do Admin Jaila.\n              Gdy czas minie, możesz zabijać innych graczy.", 1, mpregularB)
local fr_stoper = nil

warn = {}
warn.active = false
warn.state = nil
warn.text = nil
warn.tClose = nil
warn.tStart = nil
warn.timer = nil
warn.who = nil

addEvent("startRaceTimer", true)
addEventHandler("startRaceTimer", root, function(state)
        stoper_st = state and getTickCount() or nil
end)

addEvent("antyMKTimer", true)
addEventHandler("antyMKTimer", root, function(state)
    setElementData(localPlayer,"antyMKTimer",true)
    setTimer(playSoundFrontEnd, 500, 4,5)
    fr_stoper = setTimer(function() fr_stoper = nil setElementData(localPlayer,"antyMKTimer", false) end,90000 ,1)--210000 : 3.5min
end)
function clientRender()
    if getElementData(localPlayer, "justConnected") then return end 
    if stoper_st then
        local czas=getTickCount()-stoper_st
        local czas_t=string.format("%02d:%02d.%02d", czas/60000, (czas/1000)%60, czas%1000/10)
        dxDrawText(czas_t, sw/2-stoper_width/2, 16, sw, 16, tocolor(255,255,255,255), 1, ldc, "left", "top")
    end
    if (ogloszenie.ts and getTickCount()-ogloszenie.ts<limit_czasu) then 
        local alpha = 1
        if(getTickCount()-ogloszenie.ts>(limit_czasu-1000)) then
            alpha=(limit_czasu-(getTickCount()-ogloszenie.ts))/1000
        end
        
        if (ogloszenie.rodzaj~="Informacja od osoby prowadzącej event" and getTickCount()-ogloszenie.ts<1000) then
            alpha=(getTickCount()-ogloszenie.ts)/1000
        end
        for i=0,5 do
            dxDrawRectangle(0, sh-ph+i, sw, ph-1, tocolor(0,0,0,(i+5)*5*alpha))
        end
        dxDrawText(ogloszenie.rodzaj, 5, sh-ph, sw, sh, tocolor(255,255,255,200*alpha), 0.75, "default-bold", "left", "center")
        local ox=dxGetTextWidth(ogloszenie.rodzaj, 1, "default-bold")
        dxDrawText(ogloszenie.text, 5+15+ox, sh-ph, sw, sh, tocolor(255,255,255,255*alpha), 1, "default", "center", "center")
    end 
    if (not ogloszenie.event and ogloszenie.ts == nil or not ogloszenie.event and getTickCount()-ogloszenie.ts>limit_czasu) then
        local resW, resH = 1280, 720
        local x, y =  (sw/resW), (sh/resH)
        local px, py, pz = getElementPosition ( localPlayer )      
        local playerZoneName = getZoneName ( px, py, pz)          
        local playerCity = getZoneName(px, py, pz, true)
        if getPlayerName(localPlayer) == "XJMLN" then
            dxDrawBorderedText(playerCity.."\n "..playerZoneName, x*5, y*685, x, y, tocolor(255,255,255,255), 0.5, "pricedown")
        else
            dxDrawBorderedText(playerCity..", "..playerZoneName, x*5, y*685, x, y, tocolor(255,255,255,255), 1, "pricedown")
        end
	end

	for i,v in pairs(countdown) do
		if v<getTickCount()-1000 then
			countdown[i]=nil
			if tonumber(i) and tonumber(i)>1 and tonumber(i)<=5 then
				playSound("a/"..tostring(tonumber(i-1))..".ogg")
			end
		elseif v<getTickCount() then
			local scale=math.sqrt(1000-(getTickCount()-v))/20+1
			local alpha=255-math.abs( (getTickCount()-v)/2-250)

			dxDrawText(tostring(i), sw/2,sh/2,sw/2,sh/2, tocolor(255,255,255,alpha), scale, countFont, "center", "center")

		end
	end
    if fr_stoper then 
        local czas = getTimerDetails(fr_stoper)
        local czas_t = string.format("Pozostało %02d:%02d",czas/60000, (czas/1000)%60)
        dxDrawImage((sw/2)-fr_timer/1.3, 12, 250, 52, "i/b_main.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(czas_t, sw/2-fr_timer/2, 16, sw, 16, tocolor(255, 255, 255, 255), 1.00, mpregular, "left", "top")
        dxDrawBorderedText("Jeżeli teraz zabijesz jakiegoś gracza, możesz zostać ukarany.\n              Gdy czas minie, możesz zabijać innych graczy.", sw/2-fr_timerB/3, 16+52, sw, 16, tocolor(255,255,255,255), 1.00, mpregularB, "left","top")
    end 

    if warn.active and warn.state == "in" then
        local color = math.sin(getTickCount()/100)*20
        warn.tClose = getTimerDetails(warn.timer)
        local czas = string.format("%02ds",(warn.tClose/1000)%60)
        DxDrawBorderedRectangle(100, 100, sw-200, sh-200,tocolor(color,0,0,255/2),tocolor(255,255,255,255),2,false)
        dxDrawBorderedText("Otrzymano ostrzeżenie od "..warn.who, 100, 100, sw-100, sh/2-20, tocolor(255,255,255,255),1.00, mpregular, "center", "top")
        
        dxDrawText(warn.text, 100, sh/2+20, sw-100, sh-100, tocolor(255,255,255,255),1,mpregular, "center", "top",true,true)
        dxDrawBorderedText("Wciśnij klawisz 'Z', aby zamknąć\n Okno zniknie za: "..czas, 100, sh/2+20, sw-100, sh-100, tocolor(255,255,255,255),1.00, mpregularB, "right","bottom")
    end

    if getElementData(localPlayer,"newplayer") then 
        dxDrawText("Zapoznaj się z pomocą pod klawiszem F9.", (381/1280)*sw, (275/720)*sh, (941/1280)*sw, (320/720)*sh, tocolor(255, 255, 255, 255), 1.00, fontInfo, "center", "center", false, false, false, false, false)
    end

    if tdm.active and getPlayerName(localPlayer) == "|PSZ|XJMLN" then
        dxDrawText("Drużyna czerwonych ("..tdm.count_red..") - Drużyna niebieskich ("..tdm.count_blue..")",  1+sw*2/8, 1+sh*6/9, 1+sw*6/8, 1+sh*8/9, tocolor(0,0,0), 1, "default-bold", "center","bottom",true,true)
        dxDrawText("Drużyna czerwonych ("..tdm.count_red..") - Drużyna niebieskich ("..tdm.count_blue..")", sw*2/8, sh*6/9, sw*6/8, sh*8/9, tocolor(255,255,255), 1, "default-bold", "center","bottom",true,true)
    
        local vdn = ((0.2+tdm.count_blue)*sw*2/8)/(tdm.count_red+tdm.count_blue+0.4)
        local vdc = ((0.2+tdm.count_red)*sw*2/8)/(tdm.count_red+tdm.count_blue+0.4)

        dxDrawLine( sw*3/8, sh*8/9+8, sw*3/8+vdn, sh*8/9+8, tocolor(0,0,255), 6)
        dxDrawLine( sw*3/8, sh*8/9+8, sw*3/8-vdc, sh*8/9+8, tocolor(255,0,0), 6)
    end
end
addEventHandler("onClientRender",root, clientRender)
addEvent("doCountdown", true)
addEventHandler("doCountdown", root, function(n)
	for i=n,1,-1 do
		countdown[i]=getTickCount()+(n-i)*1000
	end
	playSound("a/"..tostring(tonumber(n))..".ogg")
end)

function gui_showOgloszenie(txt,lrodzaj)
        if ogloszenie.event then
        else
        ogloszenie.rodzaj = lrodzaj or "Informacja o nadanej karze"
        ogloszenie.text = txt
        ogloszenie.ts = getTickCount()
    end
end
addEvent("gui_showOgloszenie", true)
addEventHandler("gui_showOgloszenie", root, gui_showOgloszenie)

function DxDrawBorderedRectangle( x, y, width, height, color1, color2, _width, postGUI )
    local _width = _width or 1
    dxDrawRectangle ( x+1, y+1, width-1, height-1, color1, postGUI )
    dxDrawLine ( x, y, x+width, y, color2, _width, postGUI ) -- Top
    dxDrawLine ( x, y, x, y+height, color2, _width, postGUI ) -- Left
    dxDrawLine ( x, y+height, x+width, y+height, color2, _width, postGUI ) -- Bottom
    dxDrawLine ( x+width, y, x+width, y+height, color2, _width, postGUI ) -- Right
end

function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
    dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end

function clientHUDRender_motionblur()
    if (guiopts.motionblur) then
        local drunkLevel=getElementData(localPlayer, "drunkLevel")
        if (not drunkLevel or tonumber(drunkLevel)<1) then
            triggerEvent("onGUIOptionChange", root, "motionblur", false)
            return
        end
        local colorLevel=getElementData(localPlayer, "colorLevel") or 1
        dxSetShaderValue( motionblur_shader, "drunkLevel", tonumber(drunkLevel)/1.8, colorLevel)
        dxSetRenderTarget( );
        dxUpdateScreenSource( motionblur_screenSrc );
        dxDrawImage( 0, 0, sw, sh, motionblur_shader );
        -- wplyw na auto
        local v=getPedOccupiedVehicle(localPlayer)
        if (not v) then return end
        if not getVehicleEngineState(v) then
            setVehicleGravity(v, 0,0,-1)
            return
        end
        local _,_,rz=getElementRotation(v)
        local vx,vy,vz=getElementVelocity(v)
        local spd=((vx^2 + vy^2 + vz^2)^(0.5)+(drunkLevel/50))*2

        local rrz=math.rad(rz+180)
        local x= (0.15 * math.sin(-rrz))*spd
        local y= (0.15 * math.cos(-rrz))*spd
        setVehicleGravity(v, x,y,-1)

    end
end

addEventHandler ( "onClientElementDataChange", localPlayer, function(dataName, oldValue)
    if (dataName~="drunkLevel") then return end
    local curValue=getElementData(localPlayer, "drunkLevel")
    if ((not curValue or tonumber(curValue)==0) and guiopts.motionblur) then
        triggerEvent("onGUIOptionChange", root, "motionblur", false)
        return
    end

    if ((oldValue==nil or tonumber(oldValue)<1) and tonumber(curValue)>0) then
            triggerEvent("onGUIOptionChange", root, "motionblur", true)
            return
    end
end)

addEvent("onGUIOptionChange", true)
addEventHandler("onGUIOptionChange", root, function(optname, value)
    if (guiopts[optname]==value) then return end
    guiopts[optname]=value
    if (optname=="motionblur") then
        if value and value==true then
            motionblur_shader = dxCreateShader( "fx/motion.fx" );
            motionblur_screenSrc = dxCreateScreenSource( sw, sh );
            if motionblur_shader and motionblur_screenSrc then
                dxSetShaderValue( motionblur_shader, "ScreenTexture", motionblur_screenSrc );
                addEventHandler( "onClientHUDRender", getRootElement( ), clientHUDRender_motionblur );
            end
        else
            if motionblur_shader and motionblur_screenSrc then
                destroyElement( motionblur_shader );
                destroyElement( motionblur_screenSrc );
                motionblur_shader, motionblur_screenSrc = nil, nil;
                removeEventHandler( "onClientHUDRender", getRootElement( ), clientHUDRender_motionblur);
            end
        end
        return
    end



end)

function guiStart()
    triggerServerEvent("onResourcesDownloaded", localPlayer)
     local character=getElementData(localPlayer, "character")
     if (character and character.id) then
        removeEventHandler("onClientRender",root, clientRender)
        bindKey("y","down","chatbox","Krótkofalówka")
        bindKey("o","down","chatbox","g")
        addEventHandler("onClientRender",root, clientRender)
     end
end
addEventHandler("onClientResourceStart",resourceRoot, guiStart)

do
    local curValue=getElementData(localPlayer, "drunkLevel")
    if (curValue and tonumber(curValue)>0) then
            triggerEvent("onGUIOptionChange", root, "motionblur", true)
    end
end


addEventHandler("onClientPlayerVehicleEnter",localPlayer,function(vehicle)
  setVehicleGravity(vehicle, 0,0, -1)
end)

addEventHandler("onClientPlayerVehicleExit",localPlayer,function(vehicle)
  setVehicleGravity(vehicle, 0,0, -1)
end)

function checkPedDmg(attacker)
    if (not getElementData(source, "special_ped")) then 
        cancelEvent()
    end
end

addEventHandler("onClientPedDamage", root, checkPedDmg)

function stopSprayDamage(attacker, weapon, bodypart)
    if (weapon == 41) then
        cancelEvent()
    end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopSprayDamage)

addEvent("doQuake", true)
addEventHandler("doQuake", root, function(s)
    local x,y,z=getElementPosition(localPlayer)
    createExplosion(x,y,z+10,12, false, s, false)
end)

local function checkSpec()
    local ct=getCameraTarget(localPlayer)
    if ct and ct~=localPlayer and getElementType(ct)=="player" then
        setElementInterior(localPlayer, getElementInterior(ct))
        setElementDimension(localPlayer, getElementDimension(ct))
    end
end

setTimer(checkSpec, 1000, 0)

addEvent("onTDMKill",true)
addEventHandler("onTDMKill", getRootElement(), function(votes)
    tdm=votes
end)

function hidePlayerWarning()
    warn.timer = nil
    warn.active = false
    warn.tClose = nil
    warn.who = nil
    warn.text = nil
    warn.tStart = nil
    warn.state = "out"
    unbindKey("Z","down",hidePlayerWarning)
end

function onPlayerReceivedWarning(tresc, who)
    if source == localPlayer then 
        warn.timer = setTimer(hidePlayerWarning, 30000,1)
        warn.active = true
        warn.tStart = getTickCount()
        warn.who = getPlayerName(who) or "System"
        warn.text = tresc 
        warn.state = "in"
        bindKey("Z","down",hidePlayerWarning)
    end
end


addEvent("onPlayerReceivedWarning",true)
addEventHandler("onPlayerReceivedWarning", getRootElement(), onPlayerReceivedWarning)