addEvent("onDryerAction", true)
addEventHandler("onDryerAction", root, function(typ,selected,el)
    if not el or not selected then return end
    if typ == "vehicle" then
        if selected == 1 then
            _,_,rz=getElementRotation(el)
            fixVehicle(el)
            setElementHealth(el,1000)
            setElementRotation(el,0,0,rz)
            outputChatBox("* Naprawiłeś/aś zaznaczony pojazd.", source)
            exports['psz-admin']:adminView_add("S-FIX> "..getPlayerName(source),2)
        end
        if selected == 2 then
            if getElementData(el,"veh:salon") then return end
            if not getElementData(el,"vehicle:spawn") then
                local model = getElementModel(el)
                local x,y,z = getElementPosition(el)
                local text = string.format("%d, %.2f,%.2f,%.2f",model,x,y,z)
                destroyElement(el)
                outputChatBox("* Pomyślnie usunięto pojazd.", source)
                exports['psz-admin']:adminView_add("S-DELETE> "..getPlayerName(source).." | "..text,2)
            else
                outputChatBox("* Ten pojazd należy do spawn'u, użyj funkcji odspawnuj.", source, 255, 0, 0)
            end
        end
        if selected == 3 then
		  if getElementData(el,"veh:salon") then return end
			local aktualnyStatus = isElementFrozen(el)
			local status = not aktualnyStatus
			setElementFrozen(el,status)
			outputChatBox("Pojazd został zamrożony/odmrożony.",source)
            exports['psz-admin']:adminView_add("S-FREEZE>" ..getPlayerName(source).." freeze/unfreeze",2)
        end
		if selected == 4 then
            if getElementData(el,"veh:salon") then return end
			local x,y,z=getElementPosition(el)
			setElementPosition(el,x,y,z+2)
            exports['psz-admin']:adminView_add("S-UP>" ..getPlayerName(source).." cur_value:"..z+2,2)
		end
        if selected == 5 then
           if getElementData(el,"veh:salon") then return end
                respawnVehicle(el)
                outputChatBox("Pojazd został odspawnowany na wcześniejsze miejsce.",source)
                local text = string.format("Pojazd byl z spawna: %s, Pojazd był z frakcji: %s,%s,%s,%s",tostring(getElementData(el,"spawn:vehicle")),tostring(getElementData(el,"medyk:vehicle")), tostring(getElementData(el,"cn:vehicle")), tostring(getElementData(el,"policja:vehicle")), tostring(getElementData(el,'straz:vehicle')))
                exports['psz-admin']:adminView_add("S-SPAWN> "..getPlayerName(source).." | "..text,2)
    end
		if selected == 6 then
			local model =getElementModel(el)
			local c1,c2,c3,c4 = getVehicleColor(el)
			outputChatBox("Marka: "..model..", Kolor RGB: "..c1..","..c2..","..c3..","..c4..".",source)
	end
end

end)

addEventHandler("onVehicleEnter", root, function(plr,seat)
    if seat ~= 0 then return end
	--setVehicleEngineState(source, false)
	setElementData(source,"vehicle:driver",getPlayerName(plr))
end)
