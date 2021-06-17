local data = {
	[2800]={0,0,0,0,0,90},
}

function edytor_getOffsetData(id)
	if (not id or tonumber(id)<1) then return end

	for i,v in ipairs(data) do
		if v == id then 
			for i2, v2 in ipairs(v) do
				return v2[2]
			end
		end
	end
end
