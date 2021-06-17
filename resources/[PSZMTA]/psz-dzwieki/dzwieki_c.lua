--[[

Dzwieki - wylaczanie/wlaczanie

===
Glowny tworca: Lukasz Biegaj <wielebny@bestplay.pl>
Wersja przerobiona pod pszmta.pl :
	@author Jakub 'XJMLN' Starzak <jack@pszmta.pl>
===
@package PSZMTA.psz-dzwieki
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--


--[[

	pd-syrena: 70938__guitarguy1985__police2.wav  http://www.freesound.org/people/guitarguy1985/sounds/70938/ CC-0

]]--

addEvent("broadcastSound3D", true)
addEventHandler("broadcastSound3D", root, function(sound,range,minrange, bliskiKomunikat, dalekiKomunikat)
	local el=source
	if getElementDimension(localPlayer)~=getElementDimension(el) then return end
	if getElementInterior(localPlayer)~=getElementInterior(el) then return end
	local x,y,z=getElementPosition(localPlayer)
	local x2,y2,z2=getElementPosition(el)
	local dist=getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
	if dist<range*2 then
		if bliskiKomunikat and minrange and dist<minrange then
			--triggerEvent("onCaptionedEvent", root, bliskiKomunikat, 10)
			outputChatBox(" * " .. bliskiKomunikat)
		elseif dalekiKomunikat and dist<range then
			--triggerEvent("onCaptionedEvent", root, dalekiKomunikat, 10)
			outputChatBox(" * " .. dalekiKomunikat)
		end
		local s=playSound3D(sound, x2,y2,z2)
		setSoundMinDistance(s, minrange or 5)
		setSoundMaxDistance(s, range)
	end
end)

addEvent("odtworzDzwiek", true)
addEventHandler("odtworzDzwiek", resourceRoot, function(dzwiek)
	if fileExists("audio/"..dzwiek..".ogg") then
		playSound("audio/"..dzwiek..".ogg")
	elseif fileExists("audio/"..dzwiek..".mp3") then
		playSound("audio/"..dzwiek..".mp3")
	end
end)
