addEventHandler ("onClientElementDataChange", localPlayer, function(dataName, oldValue)
	if (dataName~="uo_sc") then return end
	
	if getElementData(localPlayer, "uo_sc") then
		startDynamicSky()
	else
		stopDynamicSky()
	end
end)