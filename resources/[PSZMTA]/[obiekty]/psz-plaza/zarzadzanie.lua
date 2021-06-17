local kino = false
local scena = createColSphere(336.30,-1869.60,10.75,170)
local ekran = {
	{347.10001,-1855.5,10.9,0,90,269.995},
	{338.10001,-1855.5,10.9,0,90,269.995},
	{329,10001,-1855.5,10.9,0,90,269.995},
	{320.10001,-1855.5,10.9,0,90,269.995},
	{320.10001,-1855.5,15,0,90,269.995},
	{329.10001,-1855.5,15,0,90,269.995},
	{338.10001,-1855.5,15,0,90,269.995},
	{347.10001,-1855.5,15,0,90,269.995},
}
setElementData(scena,"audio",{'http://www.miastomuzyki.pl/n/rmfmaxxx.pls',336.24,-1873.75,10.75,0,0,10,250})
local obj = createObject(10830,335.59961,-1877,13.7) -- glowny budynek
setElementRotation(obj,0,0,43.995) -- glowny budynek
local dym1 = createObject(2780,350.89999,-1857.5,17.3)
local dym2 = createObject(2780,321.29999,-1856,18.2)
local paw = createObject(8492,336.29999,-1853.4,22.8)
setElementRotation(paw,0,0,146)
addEvent("doMoveScena",true)
addEventHandler("doMoveScena",resourceRoot,function(plr)
	if kino == true then
		moveObject(dym2,10000,321.29999,-1856,18.2)
		moveObject(dym1,10000,350.89999,-1857.5,17.3)
		moveObject(paw,10000,336.29999,-1853.4,22.8)
		moveObject(obj,10000,335.59961,-1877,13.7)
		setTimer(function() 
		local obiekty = getElementsByType('object') 
		for i,v in ipairs(obiekty) do
			if getElementModel(v) == 3095 then
				if getElementData(v,'ekran:kino') then
					destroyElement(v)
					kino = false
					exports['psz-kino']:enableKino(0)
					setElementData(scena,"audio",{'http://www.miastomuzyki.pl/n/rmfmaxxx.pls',336.24,-1873.75,10.75,0,0,10,250})
				end
			end
		end
	end,10000,1)
	else
	moveObject(dym2,10000,321.29999,-1875,18.3+2.6)
	moveObject(dym1,10000,350.89999,-1875,17.3+3.6)
	moveObject(obj,10000,335.59961,-1877,16.5)
	moveObject(paw,10000,336.29999,-1853.4,25.5)
	setTimer(function() for i,v in ipairs(ekran) do
		local ekrany = createObject(3095,v[1],v[2],v[3])
		setElementRotation(ekrany,v[4],v[5],v[6])
		setElementData(ekrany,"ekran:kino",true)
		exports['psz-kino']:enableKino(1)
		setElementData(scena,"audio",{'http://www.miastomuzyki.pl/n/rmfmaxxx.pls',336.24,-1873.75,10.75,0,0,10,1})
		kino = true
	end
	end,10000,1)
	end
end)