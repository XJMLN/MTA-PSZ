local wozy = {
-- x,y,z,rx,ry,rz,model
	{-28.84,-273.45,5.5,0,0,180,407},
    {-22.51,-273.4,5.5,0,0,180,407},
	{-13.69,-273.4,5.5,0,0,180,407},
	{-2.81,-291.60,5.59,0,0,90,544},
	{-31.73,-290.24,5.45,0,0,270,400},
	-- LV
	{1751.75,2070.74,11.07,0,0,180,407},
	{1770.37,2072.38,11.07,0,0,180,407},
	{1764.39,2069.11,11.37,0,0,180,544},
	{1758.51,2068.71,11.36,0,0,180,544},
}

for i,v in ipairs(wozy) do
    v.pojazd = createVehicle(v[7],v[1],v[2],v[3],v[4],v[5],v[6],"STRAZ")
    setElementData(v.pojazd,"straz:vehicle",true)
	setElementFrozen(v.pojazd,true)
	setVehicleDamageProof(v.pojazd,true)
	setVehicleColor(v.pojazd,255,0,0,255,255,255)
	addVehicleUpgrade(v.pojazd,1025)
	toggleVehicleRespawn(v.pojazd,true)
end

function enterVehicle(player,seat,jacked)
    if (getElementData(source,"straz:vehicle")) and (not getElementData(player,"duty:straz")) then
        cancelEvent()
        outputChatBox("Nie jesteś strażakiem - rozpocznij pracę w remizie.",player)
	else
		setElementFrozen(source,false)
		setVehicleDamageProof(source,false)
    end
end
addEventHandler("onVehicleStartEnter",getRootElement(),enterVehicle)
