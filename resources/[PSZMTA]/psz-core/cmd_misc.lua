--[[

Core - komendy dla graczy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function cmd_admins(plr)
  local supporterzy={}
  local root ={}
  local admini={}
  for i,v in ipairs(getElementsByType("player")) do

	if (isAdmin(v)) then
	  local t
	  local login=string.gsub(getPlayerName(v),"#%x%x%x%x%x%x","")
	  if (login) then
		t=login.."("..getElementData(v,"id")..")"

		table.insert(admini,t)
	  end
	elseif (isRoot(v)) then
		local t 
		local login = string.gsub(getPlayerName(v),"#%x%x%x%x%x%x","")
		if (login) then
		t=login.."("..getElementData(v,"id")..")"
		
		table.insert(root,t)
		end
	elseif (isSupport(v)) then
	  local t
	  local login= string.gsub(getPlayerName(v),"#%x%x%x%x%x%x","")
	  if (login) then
		t=login.."("..getElementData(v,"id")..")"
		table.insert(supporterzy,t)
	  end
	end
  end
  outputChatBox("Administratorzy ROOT:",plr,255,0,0)
  if (#root>0) then
	outputChatBox("  ".. table.concat(root,", "), plr)
else
	outputChatBox("  brak",plr)
end
  outputChatBox("Administratorzy:", plr, 100,0,0)
  if (#admini>0) then
    outputChatBox("  " .. table.concat(admini,", "), plr)
  else
	outputChatBox("  brak", plr)
  end

  outputChatBox("Moderatorzy:", plr, 255,102,51)
  if (#supporterzy>0) then
    outputChatBox("  " .. table.concat(supporterzy,", "), plr)
  else
	outputChatBox("  brak", plr)
  end
end
addCommandHandler("admins", cmd_admins, false, false)

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

local odlicz_INTERVAL=30000
local odlicz_RANGE=200
local odlicz_LU=getTickCount()-odlicz_INTERVAL

addCommandHandler("odlicz", function(plr,cmd)
	if (getTickCount()-odlicz_LU<odlicz_INTERVAL) then
		outputChatBox("Musisz chwile odczekac.",plr)
		return
	end
	odlicz_LU=getTickCount()
	local x,y,z=getElementPosition(plr)
	local col=createColSphere(x,y,z,odlicz_RANGE)
	setElementInterior(col, getElementInterior(plr))
	setElementDimension(col, getElementDimension(plr))
	local gracze=getElementsWithinColShape(col, "player")
	local odliczanieDSP = textCreateDisplay()
	for i,v in ipairs(gracze) do
		local nick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
		outputChatBox(nick .. " uruchomił/a odliczanie.", v)
		textDisplayAddObserver ( odliczanieDSP, v )
		playSoundFrontEnd(v,44)
	end
	local odliczanie_step=5

	local odliczanieTXT = textCreateTextItem ( tostring(odliczanie_step), 0.5, 0.5, 2, 255,255,255,255,5, "center", "center", 255)
	textDisplayAddText ( odliczanieDSP, odliczanieTXT )
	setTimer(function()
			odliczanie_step=odliczanie_step-1
			if (odliczanie_step==0) then
				textItemSetText(odliczanieTXT, "START!")
			else
				textItemSetText(odliczanieTXT, tostring(odliczanie_step))
			end
			for i,v in ipairs(getElementsWithinColShape(col,"player")) do
				if (odliczanie_step==0) then
					playSoundFrontEnd(v,45)
				else
					playSoundFrontEnd(v,44)
				end
			end
		end, 1000, 5)
	setTimer(function()
		textDestroyTextItem(odliczanieTXT)
		textDestroyDisplay(odliczanieDSP)
		destroyElement(col)
		end, 6000, 1)
end,false,false)

function onTransferMoney(plr, cmd, target, value)
    if not target or not tonumber(value) then
        outputChatBox('Użyj: /przelej <nick/ID> <kwota>', plr)
        return
    end

    if string.find(tonumber(value),"%p%d") ~= nil or string.find(tonumber(value),"%p%d%d") ~= nil then outputChatBox("Nie możesz przelać wartości z groszami.",plr,255,0,0) return end
    value=tonumber(value)
    local target=findPlayer(plr,target)
    if not target then
        outputChatBox('Nie znaleziono podanego gracza.',plr, 255, 0, 0)
        return
    end
    if target == plr then 
    	outputChatBox("Nie możesz przelać pieniędzy do siebie.",plr,255,0,0)
    	return 
    end
    if getPlayerMoney(plr) < value then
        outputChatBox('Nie posiadasz wystarczającej ilości pieniędzy.', plr, 255, 0, 0)
        return
    end
    if value == 0 or value < 0 then
        outputChatBox('Podałeś nieprawidłową wartość przelewu.', plr, 255, 0, 0)
        return
    end

    takePlayerMoney(plr, value)
    givePlayerMoney(target ,value)

    outputChatBox(string.format("Przekazujesz #257BC2%d#FFFFFF$ do gracza #257BC2%s#FFFFFF.",value,getPlayerName(target)),plr,255,255,255,true)
    outputChatBox(string.format("Gracz #257BC2%s przekazał Ci #257BC2%d#FFFFFF$.",getPlayerName(plr),value),target,255,255,255,true)
	exports["psz-admin"]:gameView_add("PRZELEW "..getPlayerName(plr).."/"..getElementData(plr,"id").." >> "..getPlayerName(target).."/"..getElementData(target,"id")..", ilosc "..value)
end
addCommandHandler('przelej', onTransferMoney)
addCommandHandler('zaplac', onTransferMoney)
addCommandHandler('dajkase', onTransferMoney)