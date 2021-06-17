local a_race = nil
local a_marker = nil
local sw, sh = guiGetScreenSize()


function renderWindow()
	if (not a_race) then return end
		dxDrawBorderedRectangle(sw/2 - 200, sh/2 - 75, 400, 150, tocolor(29,29,29,150), tocolor(255,255,255,255),1)
		dxDrawText("Czy chcesz wziąść udział w tym wyścigu?",sw/2 - 100, sh/2 - 50, 200, 100, tocolor(255,255,255,255),1,"default-bold")
		dxDrawBorderedRectangle(sw/2 - 180, sh/2 + 20, 140, 45, tocolor(148,0,0,255), tocolor(255,255,255,255),0.5)
		dxDrawText("Nie, dzięki",(sw/2 - 180) + 40, sh/2 + 35, 120, 65, tocolor(255,255,255,255),1,"default-bold")
		dxDrawBorderedRectangle(sw/2 + 40, sh/2 + 20, 140, 45, tocolor(2,105,2,255), tocolor(255,255,255,255),0.5)
		dxDrawText("Pewnie!", (sw/2 + 40) + 50, sh/2 + 35, 120, 65, tocolor(255,255,255,255),1,"default-bold")
end

local function closeAllWindows()
	removeEventHandler("onClientRender", root, renderWindow)
	a_race = nil
	a_marker = nil
	showCursor(false)
end
local function showAcceptWindow(race)
	addEventHandler("onClientRender", root, renderWindow)
	showCursor(true, false)
end

addEventHandler("onClientClick", root, function(button, state)
	if button=="left" and state=="down" then
		if isMouseInPosition(sw/2 - 180, sh/2 + 20, 140,45) and a_race then 
			closeAllWindows()
			outputChatBox("Wyścigi w trakcie przygotowywania.",255,0,0)
		elseif isMouseInPosition(sw/2 + 40, sh/2 + 20, 140, 45) and a_race then 
			if getPlayerName(getLocalPlayer()) ~= "XJMLN" then 
				closeAllWindows()
				outputChatBox("Wyścigi w trakcie przygotowywania.",255,0,0)
				return
			end
			triggerServerEvent("onPlayerAcceptStartRace",resourceRoot, a_race, getPedOccupiedVehicle(getLocalPlayer()) or nil)
			setMarkerSize(a_marker,0)
			closeAllWindows()
		end
	end
end)


addEventHandler("onClientMarkerHit", resourceRoot, function(el, md)
	if el~=localPlayer or not md then return end
	local race = getElementData(source,"race")
	if not race then return end
	local veh = getPedOccupiedVehicle(el)
	if (not veh or getPedOccupiedVehicleSeat(el)~=0) then return end
	a_race = race
	a_marker = source
	showAcceptWindow(race)
end)