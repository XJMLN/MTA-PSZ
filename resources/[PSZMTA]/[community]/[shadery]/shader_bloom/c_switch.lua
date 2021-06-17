addEventHandler ("onClientElementDataChange", localPlayer, function(dataName, oldValue)
	if (dataName~="uo_sb") then return end
	
	if getElementData(localPlayer, "uo_sb") then
		enableBloom()
	else
		disableBloom()
	end
end)