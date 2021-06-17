local CHANGE_INTERVAL=60000
local klub=createColSphere(487.02,-12.49,1000.68,170)
local klub_lc=getTickCount()-CHANGE_INTERVAL
setElementInterior(klub, 17)
setElementDimension(klub, 0)

--setElementData(klub,"audio", { ":psz-podklady_muzyczne/a/remix.ogg",487.64,-0.69,1002.38,0, 0, 45, 170} )


addEvent("doChangeAudio", true)
addEventHandler("doChangeAudio", resourceRoot, function(plr, strumien, opis)
	if getTickCount()-klub_lc<CHANGE_INTERVAL then
		outputChatBox("Zmiana muzyki na scenie możliwa za 60 sekund.", plr)
		return
	end
	klub_lc=getTickCount()
    for i,v in ipairs(getElementsByType("player")) do
		triggerClientEvent(plr, "doHideWindowsAudio", resourceRoot)
	end
	setElementData(klub,"audio", { strumien,487.64,-0.69,1002.38,17, 0, 45, 170} )
end)

addEvent("doChangeAudioYT", true)
addEventHandler("doChangeAudioYT", resourceRoot, function(plr, strumien, opis)
	if getTickCount()-klub_lc<CHANGE_INTERVAL then
		outputChatBox("Zmiana muzyki na scenie możliwa za 60 sekund.", plr)
		return
	end
	klub_lc=getTickCount()
    for i,v in ipairs(getElementsByType("player")) do
		triggerClientEvent(plr, "doHideWindowsAudio", resourceRoot)
	end
	local strumien = "http://youtubeinmp3.com/fetch/?video="..tostring(strumien)
	exports['psz-admin']:adminView_add("Konsola DJa >> gracz: "..getPlayerName(plr).."/"..getPlayerSerial(plr)..", odtwarza film z YT: ["..strumien.."]")
	setElementData(klub,"audio", { strumien,487.64,-0.69,1002.38,17, 0, 45, 170} )
end)