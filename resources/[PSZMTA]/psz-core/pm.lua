--[[

Core - prywatne wiadomosci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--



function privateMessage(plr,cmd, cel, ...)
	local c = getElementData(plr,"character")
	if (not c) then 
		outputChatBox("Najpierw dołącz do gry.",plr,255,0,0)
		return
	end
	if getElementData(plr,"kary:blokada_aj") then outputChatBox("Posiadasz nałożony AJ, nie możesz nic napisać.",plr) return end
	if (getElementData(plr,"kary:blokada_pm")) then
		outputChatBox("Posiadasz nałożoną blokadę prywatnych wiadomości. Blokada wygasa: ".. getElementData(plr, "kary:blokada_pm"),plr, 255,0,0)
		 return
	end
	if (#arg<=0 or (not cel)) then
		outputChatBox("Użyj: /pm <nick> <treść>", plr)
		return
	end

	local target=findPlayer(plr,cel)

	if (not target) then
		outputChatBox("Nie znaleziono gracza o podanym nicku!", plr)
		return
	end
	local blok=getElementData(target,"player:mute")
	if (blok) then
			outputChatBox("Gracz do którego piszesz ma aktywną blokadę PM.",plr)
			return
		end
	local pmoff=getElementData(target,"pmoff")
	if (pmoff) then
	  outputChatBox(getPlayerName(target).." nie akceptuje wiadomości PM.", plr)
	  if (type(pmoff)=="string") then
		outputChatBox("Powód: " .. pmoff, plr)
	  end
	  return
	end

	local lvl = getElementData(target,"level") or 0
	if (lvl and lvl>0) then 
		outputChatBox("Pisząc wiadomość do członka ekipy, zawsze przechodź do sedna sprawy - nie witaj się.",plr,255,0,0)
	end

    if getElementData(plr,"pmoff") then
      outputChatBox("Posiadasz wyłączone wiadomości PM. Ta osoba nie będzie mogła Ci odpisać.", plr)
    end
    if getElementData(plr,"player:mute") then
        outputChatBox("Posiadasz aktywne wyciszenie, nie możesz nic napisać.",plr)
    return
    end
	local wysylajacy = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
	local odbierajacy = string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")
	local tresc = table.concat( arg, " " )
	outputChatBox("<< ".. wysylajacy .." ("..getPlayerID(plr).."): " .. tresc, target, 225, 199, 0)

	outputChatBox(">> ".. odbierajacy .." ("..getPlayerID(target).."): " .. tresc, plr, 245, 219, 0)
	local afk=getElementData(target,"afk") or 0
	if afk>1 then
		outputChatBox("Gracz do którego piszesz jest obecnie AFK.", plr, 245,219,0)
	end
	playSoundFrontEnd(target,12)
	exports["psz-admin"]:gameView_add("PM " .. wysylajacy.."/"..getPlayerID(plr).." >> "..odbierajacy.."/"..getPlayerID(target)..": " .. tresc)
end

addCommandHandler("pm", privateMessage, false, false)
addCommandHandler("pw", privateMessage, false, false)


addCommandHandler("pmon", function(plr,cmd)
  removeElementData(plr,"pmoff")
  outputChatBox("Akceptujesz wiadomości PM.", plr)
  return
end)

addCommandHandler("pmoff", function(plr,cmd,...)
  local powod=table.concat(arg," ")
  if (not powod or string.len(powod)<2) then powod=true end
  setElementData(plr, "pmoff", powod)
  outputChatBox("Nie akceptujesz wiadomości PM.", plr)
  return
end)
