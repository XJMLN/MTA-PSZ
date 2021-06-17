addEventHandler ("onClientElementDataChange", localPlayer, function(dataName, oldValue)
	if (dataName~="uo_sw") then return end
	
	if getElementData(localPlayer, "uo_sw") then
		enableWaterRef()
	else
		disableWaterRef()
	end
end)