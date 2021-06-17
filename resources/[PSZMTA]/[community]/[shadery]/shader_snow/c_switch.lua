
addEventHandler ("onClientElementDataChange", localPlayer, function(dataName, oldValue)
	if (dataName~="uo_sno") then return end
	
	if getElementData(localPlayer, "uo_sno") then
		startSnow()
	else
		stopSnow()
	end
end)
