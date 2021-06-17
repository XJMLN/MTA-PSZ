local radiowozy = {
-- x,y,z,rx,ry,rz,model
    -- LS
    {1535.43,-1678.77,12.95,0,0,0,596},
    {1535.44,-1666.73,12.95,0,0,0,596},

    --LV
    {2251.91,2477.00,10.41,0,0,180,596},
    {2260.81,2477.00,10.41,0,0,180,596},
    {2273.88,2477.00,10.41,0,0,180,596},
    {2282.25,2477.00,10.41,0,0,180,596},
    {2295.62,2477.00,10.41,0,0,180,596},
    {2290.98,2457.97,11.21,0,0,180,427},
    {2295.14,2444.48,11.21,0,0,0,427},
}

for i,v in ipairs(radiowozy) do
    v.pojazd = createVehicle(v[7],v[1],v[2],v[3],v[4],v[5],v[6],"POLICJA")
    setElementData(v.pojazd,"policja:vehicle",true)
	setElementFrozen(v.pojazd,true)
	setVehicleColor(v.pojazd,0,0,0,255,255,255)
	setVehicleDamageProof(v.pojazd,true)
	toggleVehicleRespawn(v.pojazd,true)
end

function enterVehicle(player,seat,jacked)
    if (getElementData(source,"policja:vehicle")) and (not getElementData(player,"duty:policja")) then
    	if seat==0 then
            cancelEvent()
            outputChatBox("Nie jesteś policjantem - rozpocznij pracę w komisariacie.",player)
        end
    elseif (getElementData(source,"policja:vehicle")) and getElementModel(source) == 596 and getElementData(player,"duty:policja") then
            outputChatBox("Wpisz /komputer aby włączyć listę poszukiwanych.",player)
    elseif (getElementData(source,"polcja:vehicle")) then
		setElementFrozen(source,false)
		setVehicleDamageProof(source,false)
    end
end
addEventHandler("onVehicleStartEnter",getRootElement(),enterVehicle)
