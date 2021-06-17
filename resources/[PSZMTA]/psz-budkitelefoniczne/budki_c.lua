local budki = {
	{2493.79,-1684.33,13.51,354.9, numer=1},
	{1126.34,-2031.77,69.89,270.1, numer=2},
	{1638.51,1309.58,12.16,270, numer=3},
	{-2134.01,928.08,80.00,90,numer=4},
	{-2410.52,-607.04,132.69,36, numer=5},
	{-253.35,2592.72,63.57,180, numer=6},
}

budka_object = {}
budka_marker = {}


addEventHandler("onClientResourceStart", resourceRoot,function()
	for i,v in ipairs(budki) do
		budka_object[v.numer]=createObject(1216, v[1], v[2], v[3]-0.5, 0,0, v[4]-180)
		budka_marker[v.numer]=createColSphere(v[1], v[2], v[3], 1)
		
		local text = createElement("text")
		setElementPosition(text, v[1], v[2], v[3]+1)
		setElementData(text, "text", "Budka telefoniczna")
		--setElementData(budka_marker[v.numer], "budkanumer", v.numer)
--budki[i].blip=createBlip(v.locb[1], v.locb[2], v.locb[3], 56, 1, 0, 0, 0, 255, 100,100)
	end
end)