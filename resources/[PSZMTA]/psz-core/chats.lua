--[[

Core - chaty

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local meTime = {}
local lastMeMessage = {}
local chatTime = {}
local lastChatMessage = {}

playerData = {}
serverData = {}

serverData.cenzurowane_slowa = {
    "[kK][uU]+[rR][wW]",
	"[pP][iI][zZ][dD]",
	"[pP][iI][eE][rR][dD][oO][lL]",
	"[sS][pP][iI][eE][rR][dD][aA][lL][aA][jJ]",
	"[sS][uU][kK][iI][nN]",
	"[jJ][eE][bB]",
	"[cC][iI][pP][oO]",
	"[hH][uU][jJ][uU]",
	"[hH][uU][jJ]",
	"[cC][iI][pP]+[aA]",
	"[cC][iI][pP][kK][aA]",
	"[dD][zZ][iI][wW][kK][aA]",
	"[sS][uU][kK][aA]",
	"[sS][zZ][mM][aA][tT][aA]",
	"[jJ][eE][bB][aA][cC]+[ćĆ]",
	"[cC][iI][oO][tT][aA]",
	"[cC][wW][eE][lL]",
	"[fF][uU][cC][kK]",
}
local syfEmoty = {
-- ugly table
	"╭",
	"∩",
	"╮",
	"°",
	" ͡",
	"ʖ",
	" ͜",
	":͊͌͌͋͋͊͊͊̏̏̏̏̏̏̏̏̏̏̏̏̏͌̏̏̏̏̏̏̏͏͌͌͌͋͋͋͊͊͊͊̏̏̏:͊͌͌͋͋͊͊͊̏",
	" ͡;",
	" ͜ʖ",
	"っ",
	"◡",
	"＾",
	"╭",
	" ͡",
	"┌",
	"┐",
	"◢",
	"◣",
	"▄",
	"︻̷̿",
	"一",
	"━",
	"═",
	"✖",
	"｡",
	"┻̿",
	"︻̷̿",
	"*͡",
	"͋",
	"̏",
	" ͋",
	"™",
	"✭",
	"★",
	"✔",
}
function removeHEXFromString(str)
    return str:gsub("#%x%x%x%x%x%x","")
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function cenzurujSlowo(slowo)
    return string.gsub(slowo,"(.).*(.)","***")
end

function cenzurujZdanie(zdanie)
    local cnt=0
    for _,slowo in ipairs(serverData.cenzurowane_slowa) do
        zdanie,lcnt=string.gsub(zdanie,slowo,cenzurujSlowo)
        if lcnt and lcnt>0 then cnt=cnt+lcnt end
    end
    return zdanie,cnt
end

local function checkCenzura(zdanie)
	local cnt=0
	for _,slowo in ipairs(serverData.cenzurowane_slowa) do
		zdanie,lcnt=string.gsub(zdanie,slowo,cenzurujSlowo)
		if lcnt and lcnt>0 then cnt=cnt+lcnt end
	end
	return cnt 
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function usuwajSyfskieEmoty(tekst)
	local cnt=0
	for _,v in ipairs(syfEmoty) do
		tekst,lcnt=string.gsub(tekst,v,"")
		if lcnt and lcnt>0 then cnt=cnt+lcnt end
	end
	return tekst
end
local function isPlayerInFraction(plr)
	local fr = getElementData(plr,"faction:data")
	if (not fr) then return false end
	return true
end

local function outputChatBoxSplitted(text, target, c1,c2,c3, ca)
  if (string.len(text)<128) then
    outputChatBox(text, target, c1,c2,c3,ca)
	return
  end
  local t=""
  for i,v in string.gmatch(text,"(.)") do
	  if (string.len(t)>0 and string.len(t)+string.len(i)>=128) then
			outputChatBox(t, target, c1,c2,c3,ca)
			t=" "
	  end
	  t=t..i
  end
  if (string.len(t)>0 and t~=" ") then
		outputChatBox(t, target, c1,c2,c3,ca)
  end
  
end

addEventHandler('onPlayerChat', getRootElement(),
	function(msg, type)
		if type == 0 then
			cancelEvent()
            if (not source or not isElement(source)) then return end
            local character=getElementData(source,"character")
            if (not character) then
                outputChatBox("Najpierw zaloguj się/poczekaj aż pobierze się serwer.", source, 255,0,0,true)
                cancelEvent()
                return
            end
			if getElementData(source,"player:muted") then outputChatBox("Posiadasz wyciszenie, nie możesz nic napisać.",source) return end
            if getElementData(source,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",source) return end
			if chatTime[source] and chatTime[source] + tonumber(1000) > getTickCount() then
				outputChatBox("Powtarzasz się...", source, 255, 0, 0)
				return
			else
				chatTime[source] = getTickCount()
			end
			if lastChatMessage[source] and lastChatMessage[source] == msg then
				outputChatBox("Skończ spamować!", source, 255, 0, 0)
				return
			else
				lastChatMessage[source] = msg
			end
			local r, g, b = getPlayerNametagColor(source)
			if (checkCenzura(msg)>0) then
				outputChatBox("Tracisz 1PZ za przeklinanie. Nie tolerujemy takich czynów - jeśli dalej będziesz przeklinać możesz otrzymać blokadę.",source,255,0,0)
				pz = getElementData(source,"PZ")
				pz = pz-1
				if pz<0 then 
				pz = 0
				end
				setElementData(source,"PZ",pz)
			end
			local msg = removeHEXFromString(cenzurujZdanie(msg))



			local msg = trim(stripColors(msg))
				if string.len(msg)<1 then
				return
			end
			local msg = usuwajSyfskieEmoty(msg)
				if string.len(msg)<1 then 
				return
			end
			local msg = firstToUpper(msg)

			if msg == "()" then return end
			local r,g,b = getPlayerNametagColor(source)
			local nick = RGBToHex(r,g,b)..getPlayerName(source)
			if (getElementData(source,"vip")) then
				local playerID = "#FFD133"..getElementData(source,"id").." #FFFFFF"
				outputChatBox(playerID.." "..nick.. ': #FFFFFF' .. string.gsub(msg,'#%x%x%x%x%x%x', ''), getRootElement(), r, g, b, true)
				exports["psz-admin"]:gameView_add("LOCAL "..string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","").." /"..getElementData(source,"id").." : "..string.gsub(msg,"#%x%x%x%x%x%x",""))
                triggerClientEvent("onChatIncome", source, msg,type)
			else

			local playerID = "#6B6A64"..getElementData(source,"id").." #FFFFFF"

				outputChatBox(playerID.." "..nick.. ': #FFFFFF' .. string.gsub(msg,'#%x%x%x%x%x%x', ''), getRootElement(), r, g, b, true)
				exports["psz-admin"]:gameView_add("LOCAL "..string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","").." /"..getElementData(source,"id").." : "..string.gsub(msg,"#%x%x%x%x%x%x",""))
                triggerClientEvent("onChatIncome", source, msg,type)
			end
		end
	end
)

function chat_me(message, messageType)
    if messageType == 1 then
        cancelEvent()
        local character=getElementData(source,"character")
        if (not character) then
            outputChatBox("Najpierw zaloguj się/poczekaj aż pobierze się serwer.", source, 255,0,0,true)
            cancelEvent()
            return
        end
        if getElementData(source,"player:muted") then outputChatBox("Posiadasz wyciszenie, nie możesz nic napisać.",source) return end
        if getElementData(source,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",source) return end
		if meTime[source] and meTime[source] + tonumber(1000) > getTickCount() then
				outputChatBox("Powtarzasz się...", source, 255, 0, 0)
				return
			else
				meTime[source] = getTickCount()
			end
			if lastMeMessage[source] and lastMeMessage[source] == message then
				outputChatBox("Skończ spamować!", source, 255, 0, 0)
				return
			else
				lastMeMessage[source] = message
			end
			local message = usuwajSyfskieEmoty(message)
			if string.len(message)<1 then 
				return
			end
			if message == "()" then return end
		local x,y,z = getElementPosition(source)
		local strefa = createColSphere(x,y,z,150)
		local gracze = getElementsWithinColShape(strefa,"player")

		local playername = string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","")

		for i,v in ipairs(gracze) do 
			if (getElementInterior(v) == getElementInterior(source) and getElementDimension(v) == getElementDimension(source)) then 
				outputChatBoxSplitted( " * " .. playername .. " " ..message, v, 223,87,223, true)-- 0x41, 0x69, 0xE1
				
			end
		end
		exports["psz-admin"]:gameView_add("LOCAL /ME "..playername.." /"..getElementData(source,"id").." : "..message)
		destroyElement(strefa)
    end
end
addEventHandler("onPlayerChat",getRootElement(),chat_me)

function cmd_chatY(plr, cmd, ...)
    local msg = table.concat(arg, " ")
    if (not isPlayerInFraction(plr)) then
        outputChatBox("Nie masz przy sobie krótkofalówki.", plr)
        return
    end
    local fr = getElementData(plr, "faction:data")
    if (not fr.id) then 
        outputChatBox("Krótkofalówka nie działa.",plr)
        return
    end
    fid=tonumber(fr.id)
    if getElementData(plr,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",plr) return end
    local playername = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
    exports['psz-admin']:gameView_add("KF ("..fid..") "..playername.."/"..getPlayerID(plr)..": "..msg)
    triggerClientEvent(root, "onFractionChatY", resourceRoot, plr, fid, msg)
end
addCommandHandler("Krótkofalówka", cmd_chatY, false, false)

function chat_gang(plr, cmd, ...)
	local msg=table.concat(arg," ")
	local gid=getElementData(plr,"character")
	if (not gid.gg_id) then
		outputChatBox("Nie należysz do gangu.",plr)
		return
	end
    local character=getElementData(plr,"character")
    if (not character) then
        outputChatBox("Najpierw zaloguj się/poczekaj aż pobierze się serwer.", plr, 255,0,0,true)
        --cancelEvent()
        return
    end
    if getElementData(plr,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",plr) return end
	gid=tonumber(gid.gg_id)
	exports['psz-admin']:gameView_add("CHAT G>"..gid.." "..getPlayerName(plr).."/"..getPlayerID(plr)..": "..msg)
	triggerClientEvent(root,"onGangChat",resourceRoot,plr,gid,msg)
end
addCommandHandler("g",chat_gang, false, false)

function msgToVIP(text)
    for i,v in ipairs(getElementsByType("player")) do
        if (getElementData(v,"vip")) then
            outputChatBox(text, v,255, 215, 0,true)
        end
    end
end

function chat_v(plr,cmd, ...)
	local msg = table.concat(arg," ")
	local vip = getElementData(plr,"vip")
	if (not vip) then
		return
	end
    local character=getElementData(plr,"character")
    if (not character) then
        outputChatBox("Najpierw zaloguj się/poczekaj aż pobierze się serwer.", plr, 255,0,0,true)
        --cancelEvent()
        return
    end
    if getElementData(plr,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",plr) return end
    if string.len(msg) <3 then return end
	local nick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
	exports['psz-admin']:gameView_add("CHATV "..getPlayerName(plr).."/"..getElementData(plr,"id")..": "..msg)
	msgToVIP("VIP> #e3d06a"..getElementData(plr,"id").." "..nick..": #FFFFFF"..msg)
end
addCommandHandler("v",chat_v)
