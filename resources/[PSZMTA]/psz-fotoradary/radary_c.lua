--[[

Fotoradary - mandaty za przekroczenie predkosci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-fotoradary
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local fotoradary = {
--@UPDATE: 2016-08-16
    {-2547.07,1109.41,54.81,255.1,range=30,predkosc=115}, -- sf przy garver
    {-1997.94,173.23,26.69,33.4,range=25,predkosc=80}, -- sf przy mechaniku
    {-1830.36,-510.62,14.11,8,range=20, predkosc=90}, -- sf przy wyjezdzie na ls
    {-127.42,-1223.10,2.04,341,range=15, predkosc=90}, -- wioski
    {776.12,-1777.51,12.18,87.3,range=20, predkosc=120}, -- LS przy tunelu na lot
    {1351.91,-1293.90,12.50,198.9,range=25, predkosc=90}, -- LS market przy ammo
    {1815.74,-1756.79,12.55,14.2,range=10, predkosc=90}, -- Ls przy starym wm1
    {1967.61,-1981.22,12.55,156,range=20, predkosc=60}, -- LS el corona
    {1870.39,-2172.94,12.55,89.0,range=15, predkosc=90}, -- LS el corona przy wjezdzie na lot
    {2335.96,-1466.29,23.00,2.1,range=15, predkosc=90}, -- LS kosciol
    {1642.78,-981.41,37.22,76.7,range=20, predkosc=120}, -- LS pod petla
    {1633.87,-4.72,35.67,198.6,range=25, predkosc=120}, -- LS-LV autostrada
    {2015.39,306.72,33.44,274.9,range=25, predkosc=120}, -- LS-LV-PC autostrada
    {1688.64,388.94,18.97,268.5,range=10, predkosc=90}, -- Pod autostrada LS-LV
    {1202.43,541.40,19.13,237.5,range=15, predkosc=90}, -- Przy montgomery
   -- {-78.56,2503.29,15.5,270.4,range=10, predkosc=100}, 
}

for i,v in ipairs(fotoradary) do
v.object = createObject(1622,v[1],v[2],v[3],0.9)
	setElementRotation(v.object,0,0,v[4])

v.colshape	= createColSphere(v[1],v[2],v[3],v.range)

v.text = createElement("ctext")
	setElementPosition(v.text,v[1]+0.2,v[2],v[3]+2)
	setElementData(v.text,"ctext","Dozwolona prędkość: "..v.predkosc.." km/H")
end

local tc = getTickCount()

function checkPredkosc(theElement, md)
	for k,v in pairs(fotoradary) do
		if (source == v.colshape) then
			if getTickCount()-tc<500 then return end
			if (theElement == localPlayer and isPedInVehicle(localPlayer)) then 
				local veh = getPedOccupiedVehicle(theElement)
				if getVehicleController(veh) ~=localPlayer then return end
				local vm = getElementModel(veh)
				speedx,speedy,speedz = getElementVelocity(veh)
				speed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
				kmh = speed * 180
				if (kmh>v.predkosc) then
					outputChatBox("Przekroczyłeś dopuszczalną prędkość! Twoja prędkość: "..math.floor(kmh)..".",255,0,0)
					--setSoundMaxDistance(playSound3D("fotoradar.ogg", v[1],v[2],v[3],false),31337)
					triggerServerEvent("fotoradary:takeMoney",localPlayer,math.floor(kmh),v.predkosc)
					tc=getTickCount()
				end
			end
		end
	end
end	
addEventHandler ( "onClientColShapeHit", resourceRoot, checkPredkosc)