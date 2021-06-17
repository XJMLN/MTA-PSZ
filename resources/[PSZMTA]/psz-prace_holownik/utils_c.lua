function jhol_checkBlockedVehs(e)
	if not e then return end
	if getElementData(e,"pojazdy_spawn") or getElementData(e,"spawn:vehicle") or getElementData(e,"veh:fid") or getElementData(e,"dbid") or getElementData(e,"fr_veh") then return true else
	return false end
end