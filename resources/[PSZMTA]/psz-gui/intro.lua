--[[

GUI: intro podczas logowania

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local sw,sh=guiGetScreenSize()
local mw,mh=800,600
local intro_audio
local g_l_welcometext, g_l_info, g_e_login, g_e_password, g_l_login, g_l_password, g_b_login, g_b_register
local dxfont0_font = dxCreateFont("/font/font.ttf", 45)
local intro_step=math.random(0,360000)
local viewPoint={1480.03,-1662.76,19.79} -- LS zloty
function renderLoginBox()
    local x,y,z,dist=1544.17,-1352.96,259.47,100	-- wiezowiec


    intro_step=intro_step+1
    local eh=getGroundPosition(viewPoint[1],viewPoint[2],viewPoint[3]+100)
    if eh<viewPoint[3] then
        viewPoint[3]=viewPoint[3]-math.abs(viewPoint[3]-eh)/100
    else
        viewPoint[3]=viewPoint[3]+math.abs(viewPoint[3]-eh)/100
    end


    viewPoint[1]=viewPoint[1]+math.sin(intro_step/1000)
    viewPoint[2]=viewPoint[2]+math.cos(intro_step/1000)

    setCameraMatrix(viewPoint[1],viewPoint[2],viewPoint[3]+50, viewPoint[1]+math.sin(intro_step/4000)*10,viewPoint[2]-math.cos(intro_step/4000)*10,viewPoint[3]+50) -- bylo *14
    dxDrawRectangle(89/mw*sw,153/mh*sh,623/mw*sw,294/mh*sh, tocolor(0,0,0,220),false)
    dxDrawLine(88/mw*sw,152/mh*sh,88/mw*sw,447/mh*sh, tocolor(254,254,254,220),1,false)
    dxDrawLine(712/mw*sw,152/mh*sh,88/mw*sw,152/mh*sh, tocolor(254,254,254,220),1,false)
    dxDrawLine(88/mw*sw,447/mh*sh,712/mw*sw,447/mh*sh, tocolor(254,254,254,220),1,false)
    dxDrawLine(712/mw*sw,447/mh*sh,712/mw*sw,152/mh*sh, tocolor(254,254,254,220),1,false)
    dxDrawText("Polski Serwer Zabawy", sw*88/mw, sh*79/mh, sw*572/mw, sh*123/mh, tocolor(0, 0, 0, 255), 1.00, dxfont0_font, "left", "top", false, false, false, false, false)
    dxDrawText("Polski Serwer Zabawy",sw*87/mw, sh*78/mh, sw*571/mw, sh*122/mh, tocolor(255, 255, 255, 255), 1.00, dxfont0_font, "left", "top", false, false, false, false, false)
end

function fadeOutIntroAudio()
    local vol=getSoundVolume(intro_audio)
    vol=vol-0.1
    if (vol<0) then
        stopSound(intro_audio)
        return
    end
    setSoundVolume(intro_audio,vol)
    setTimer(fadeOutIntroAudio, 300, 1)
end
function findPlayerName()
    triggerServerEvent("findAccount",localPlayer)
end

function displayLoginBox(mozliwyLogin)
    intro_audio=playSound("a/check.ogg",true)
    setSoundVolume(intro_audio,0.5)
    setElementAlpha(localPlayer,0)
    showCursor(true)
    showChat(false)
    setPlayerHudComponentVisible("all",false)
    addEventHandler("onClientRender",root,renderLoginBox)
    guiSetInputMode("no_binds_when_editing")

    g_l_welcometext = guiCreateLabel(385/mw*sw,190/mh*sh,317/mw*sw,170/mh*sh,"Witaj na Polskim Serwerze Zabawy, jeśli będziesz potrzebował pomocy pod klawiszem F9 znajduje się przewodnik po serwerze. Forum serwera: www.pszmta.pl.\n Masz problem z zalogowaniem się na konto? Napisz temat na pszmta.pl. ",false)
    guiLabelSetHorizontalAlign(g_l_welcometext,"left",true)

    g_l_info = guiCreateLabel(99/mw*sw,358/mh*sh,251/mw*sw,15/mh*sh,"",false)

    g_l_login = guiCreateLabel(99/mw*sw,190/mh*sh,250/mw*sw,15/mh*sh,"Login:",false)
    guiLabelSetHorizontalAlign(g_l_login,"center")
    guiLabelSetVerticalAlign(g_l_login,"center")
    g_e_login = guiCreateEdit(sw*99/mw,sh*215/mh,sw*250/mw,sh*27/mh,mozliwyLogin or "",false)

    g_l_password = guiCreateLabel(99/mw*sw,291/mh*sh,250/mw*sw,15/mh*sh,"Hasło:",false)
    guiLabelSetHorizontalAlign(g_l_password,"center")
    guiLabelSetVerticalAlign(g_l_password,"center")
    g_e_password = guiCreateEdit(99/mw*sw,316/mh*sh,250/mw*sw,27/mh*sh,"",false)
    guiEditSetMasked(g_e_password,true)
    g_b_login = guiCreateButton(99/mw*sw,389/mh*sh,276/mw*sw,37/mh*sh,"Zaloguj",false)
    addEventHandler("onClientGUIClick",g_b_login,loginHandler,false)

    g_b_register = guiCreateButton(426/mw*sw,389/mh*sh,276/mw*sw,37/mh*sh,"Zarejestruj",false)
    addEventHandler("onClientGUIClick",g_b_register,loginHandler,false)


end
addEvent("displayLoginBoxWindow",true)
addEventHandler("displayLoginBoxWindow",root,displayLoginBox)
function loginHandler()
local login=guiGetText(g_e_login)
local passwd=guiGetText(g_e_password)
    if source == g_b_login then
        triggerServerEvent("onAuthResult",localPlayer,login,passwd,2)
    elseif source == g_b_register then
        triggerServerEvent("onAuthResult",localPlayer,login,passwd,1)
    end
end


addEvent("onAuthResult",true)
addEventHandler("onAuthResult",resourceRoot,function(retval)
        if (retval.success) then
            removeEventHandler("onClientRender",root,renderLoginBox)
            showCursor(false)
            destroyElement(g_l_welcometext)
            destroyElement(g_l_info)
            destroyElement(g_e_login)
            destroyElement(g_e_password)
            destroyElement(g_l_login)
            destroyElement(g_l_password)
            destroyElement(g_b_login)
            destroyElement(g_b_register)

            fadeOutIntroAudio()

            fadeCamera(false)
            bindKey("y","down","chatbox","Krótkofalówka")
            bindKey("o","down","chatbox","g")
            return
        elseif (retval.konto) then
            guiSetText(g_l_info,retval.komunikat or "ERROR :95 panel")
            guiLabelSetColor(g_l_info,0,255,0)
            return
        else
            guiSetText(g_l_info,retval.komunikat or "Wystąpił błąd podczas autoryzacji")
            guiLabelSetColor(g_l_info,255,0,0)
            return
        end
    end)

addEvent("displayLoginBox", true)
addEventHandler("displayLoginBox",root, findPlayerName)
