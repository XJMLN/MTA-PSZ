addEventHandler("onResourceStart", getResourceRootElement(),
function (resource)
setGarageOpen(45,false)
	for i=0,49 do
		if i == 45 then return end
		if (not isGarageOpen(i)) then
			
			setGarageOpen(i, true)
		end
	end
end
)
