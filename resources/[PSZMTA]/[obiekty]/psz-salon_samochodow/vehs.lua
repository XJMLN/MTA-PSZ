local pojazdy = {
	-- model, x,y,z,rx,ry,rz,text3d_opis,dostepny,cena,przebieg,owner
	--washington
	{421,-1947.87,271.91,35.22,0,0,115.4,dostepny=true, cena=63000, przebieg=0, owner=false},
	--savanna
	{567,-1946.30,266.71,35.38,0,0,99.2,dostepny=true, cena=66500, przebieg=0, owner=false},
	--sabre
	{475,-1946.11,262.18,35.17,0,0,86.2,dostepny=true, cena=75000, przebieg=0, owner=false},
	--tornado
	{576, -1947.74,257.31,34.99,0,0,85.6,dostepny=true, cena=19850, przebieg=0, owner=false},
	--admiral
	{445,-1962.12,256.61,35.08,0,0,313.7,dostepny=true, cena=32000, przebieg=0, owner=false},
	--merit
	{551,-1962.66,262.31,35.26,0,0,311.5, dostepny=true, cena=59250, przebieg=0, owner=false},
	--tahoma
	{566, -1962.42,268.72,35.08,0,0,314.5, dostepny=true, cena=42000, przebieg=0, owner=false},
	--clover
	{542, -1945.61,272.56,40.67,0,0,90, dostepny=true, cena=9500, przebieg=0, owner=false},
}
--[[
]]
for i,v in ipairs(pojazdy) do
	-- sprawdzmy czy jest miejsce
	local cs = createColSphere(v[2],v[3],v[4],3.5)
	local cs_pojazdy = getElementsWithinColShape(cs,"vehicle")
	destroyElement(cs)
	if (not cs_pojazdy or #cs_pojazdy<1) then 
		pojazdy[i].veh = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementFrozen(pojazdy[i].veh,true)
			if (not v.owner) then 
				local txt = string.format("#257BC2%s #FFFFFFna sprzedaż\nPoprzedni właściciel:#257BC2 %s \n#FFFFFFCena:#257BC2 %d$",getVehicleNameFromModel(v[1]),"brak",v.cena)
				setElementData(pojazdy[i].veh,"opis",txt)
			else
				local txt = string.format("#257BC2%s #FFFFFFna sprzedaż\nPoprzedni właściciel:#257BC2 %s \n#FFFFFFCena:#257BC2 %d$",getVehicleNameFromModel(v[1]),v.owner,v.cena)
				setElementData(pojazdy[i].veh,"opis",txt)
			end
			setVehicleDamageProof(pojazdy[i].veh,true)
			setVehicleLocked(pojazdy[i].veh,true)
			setVehicleOverrideLights(pojazdy[i].veh,1)
			setElementData(pojazdy[i].veh, "veh:salon",true)

		local x,y,z = v[2],v[3],v[4]
		local r = v[7]
		x = x - math.sin (math.rad (r)) * 5
		y = y + math.cos (math.rad (r)) * 5

		pojazdy[i].pickup = createPickup(x,y,z,3,1274,100)
		pojazdy[i].col = createColSphere(x,y,z,0.5)
			setElementData(pojazdy[i].col,"sveh:pickup",true)
			setElementData(pojazdy[i].col,"sveh:pickup_veh",pojazdy[i].veh)
		pojazdy[i].dostepny = true
		pojazdy[i].cena = v.cena
		pojazdy[i].przebieg = v.przebieg
		pojazdy[i].owner = v.owner

		setElementData(pojazdy[i].veh,"sveh:zakup",{model=v[1],cena=v.cena,przebieg=v.przebieg,owner=v.owner,indeks=i})
	end
end

addEvent("onPlayerBuyVehicle",true)
addEventHandler("onPlayerBuyVehicle",root, function(args)
	if (not pojazdy[args.indeks].dostepny) then 
		return 
	end
	local c = getElementData(source,"character")
	local safe_money = exports['psz-mysql']:pobierzWyniki(string.format("SELECT money_sejf FROM psz_gangi WHERE id=%d",c.gg_id))

	if (safe_money.money_sejf and safe_money.money_sejf<args.cena) then 
		outputChatBox("Sejf gangu nie posiada tylu pieniędzy, nie możesz kupić pojazdu.",source,255,0,0)
		return
	end
	pojazdy[args.indeks].dostepny = false
	exports['psz-mysql']:zapytanie(string.format("UPDATE psz_gangi SET money_sejf=money_sejf-%d WHERE id=%d",args.cena,c.gg_id))
	destroyElement(pojazdy[args.indeks].pickup)
	destroyElement(pojazdy[args.indeks].veh)
	destroyElement(pojazdy[args.indeks].col)
	--model,x,y,z,rx,ry,rz,who, gidcreateVehicleEx
	
	local dbid,vehicle = exports['psz-vehicles']:createVehicleEx(pojazdy[args.indeks][1],pojazdy[args.indeks][2],pojazdy[args.indeks][3],pojazdy[args.indeks][4],pojazdy[args.indeks][5],pojazdy[args.indeks][6],pojazdy[args.indeks][7],source,c.gg_id,getElementData(source,"auth:uid"))
	if (not dbid) then 
		outputChatBox("Nie udało się utworzyć pojazdu, zgłoś się do administratora.",source)
		return
	end
	setVehicleLocked(vehicle,false)
	warpPedIntoVehicle(source,vehicle)
end)

--[[
Trzeba pamietac zeby pojazdy nie staly na ukos - wtedy moga sie znaczniki bugowac..
]]