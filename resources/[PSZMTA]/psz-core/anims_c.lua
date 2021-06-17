--[[

Core - animacje

@author Lukasz Biegaj <wielebny@bestplay.pl>
@author Karer <karer.programmer@gmail.com>
@author WUBE <wube@lss-rp.pl>
@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Animacje zostały zaimportowane z BestPlay (poprzez XyzzyRP), wykonanie: Wujek <wube@bestplay.pl>
Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

-- http://bugs.mtasa.com/view.php?id=7068#bugnotes
addEvent("setPedAnimationProgress", true)
addEventHandler("setPedAnimationProgress", root, function(anim,progress)
    if (isElement(source) and isElementStreamedIn(source)) then
	setPedAnimationProgress(source, anim, progress)
    end
end)



addEvent("hasPedBlockingTalkAnimationC", true)
addEventHandler("hasPedBlockingTalkAnimationC", getRootElement(), function(plr)
	if not (plr==getLocalPlayer()) then return end
	local grupa,animacja = getPedAnimation(plr)
	local grupa = grupa or 0
	local animacja = animacja or 0
		if (grupa==0) and (animacja==0) then
			triggerServerEvent("pedHasNotBlockingTalkAnimationS", getRootElement(), plr)
		elseif (grupa=="GANGS") and (animacja=="prtial_gngtlkH") then
			triggerServerEvent("pedHasNotBlockingTalkAnimationS", getRootElement(), plr)
		end
end)