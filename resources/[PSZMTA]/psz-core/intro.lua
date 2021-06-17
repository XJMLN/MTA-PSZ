--[[

Core - informacje pokazywane podczas pobierania zasobów

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local T_OPIS="Trwa pobieranie zasobów serwera, prosimy o cierpliwość. :)"

intro_watchers={}

addEventHandler ( "onPlayerJoin", getRootElement(), function()
	--showPlayerHudComponent(source, "all", false)
	--showChat(source, false)
	intro_watchers[source]={}
    spawnPlayer(source,-2395.09,-591.32,132.80)
	intro_watchers[source].introTextDisplay = textCreateDisplay()
	intro_watchers[source].serverText={}
        intro_watchers[source].serverText[1] = textCreateTextItem ( T_OPIS, 0.5, 0.89, 2, 55,55,255, 255, 1.2, "center", "bottom",127 )   -- create a text item for the display

	textDisplayAddText ( intro_watchers[source].introTextDisplay, intro_watchers[source].serverText[1] )
    setElementFrozen(source,false)
	fadeCamera(source, true)
    setCameraTarget(source, source)
    setElementData(source,"newPlayer:join",true)
	textDisplayAddObserver ( intro_watchers[source].introTextDisplay, source )
end)

function onResourcesDownloaded()
--	intro_watchers[client]=nil
	if (intro_watchers[source]) then
		textDisplayRemoveObserver ( intro_watchers[source].introTextDisplay, source )
		introRemoveWatcher(source)
		onPlayerDownloadFinished(source)
        showChat(source,false)
        setPlayerHudComponentVisible(source, "all", false)
        removeElementData(source,"newPlayer:join")
	end
	
end

addEvent("onResourcesDownloaded", true)
addEventHandler("onResourcesDownloaded", getRootElement(), onResourcesDownloaded)

function introRemoveWatcher(plr)
	textDestroyTextItem(intro_watchers[plr].serverText[1])
	textDestroyDisplay(intro_watchers[plr].introTextDisplay)
	intro_watchers[plr]=nil
	setPlayerHudComponentVisible(plr,"all",true)
	fadeCamera(plr,true)
	showChat(plr, true)
end


addEventHandler ( "onPlayerQuit", getRootElement(), function()
	if (intro_watchers[source] and intro_watchers[source].introTextDisplay) then
		textDestroyTextItem(intro_watchers[source].serverText[1])
		textDestroyDisplay(intro_watchers[source].introTextDisplay)
	end
	intro_watchers[source]=nil
end)

addEventHandler("onPlayerWasted",getRootElement(), function()
	if getElementData(source,"newPlayer:join") then
		setTimer(spawnPlayer,2000, 1, source, -2395.09, -591.32, 132.80)
	end
end)