local GARAGE_USE_PENALTY = 30000 

local garageElements = {}


addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function (resource)
	setGarageOpen(45,false)
	-- set up garages and stuff
	for i=0,49 do
		--if i == 21 then return end
		if i == 45 then return end
		setGarageOpen(i, true)
		--local westX, eastX, southY, northY = getGarageBoundingBox(i)
		local posX, posY, posZ = getGaragePosition(i)
		local size1, size2, size3 = getGarageSize(i)
		--outputConsole("Garage " .. i .. ": bounding box = " .. westX .. " " .. eastX .. " " .. southY .. " " .. northY .. ", position = " .. posX .. " " .. posY .. " " .. posZ .. ", size = " .. size1 .. " " .. size2 .. " " .. size3)
		--outputConsole("Garage " .. i .. ": size = " .. size1 .. " " .. size2 .. " " .. size3)
		size1, size2, size3 = 10, 10, 5 -- getGarageSize() returns numbers that are way too big.. so let's make it 10
		-- fixes for problem garages:
		if (i == 18 or i == 19) then -- wang's fender and wang's spray
			posY = posY - 10
		end
		if (i == 21) then -- wang's fender and wang's spray
			size1 = 22
		end
		if (i == 22) then
			size1 = 20
			size2 = 32
		end
	end
end
)
