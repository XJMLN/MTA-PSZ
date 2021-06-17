--[[

wash - mycie pojazdow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-wash
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local myjnie = {
	eastls={
		colCuboid={2446.6,-1465.3,22.75,20.5,8.25,5},
		startMarker={2454.31,-1460.96,23},
	},
  iwoodls={
    colCuboid={1908.31,-1781.02,12.13,6.5,9.25,4.75},
    startMarker={1911.18,-1776.41,12.38},
},
  emeraldlv={
    colCuboid={2157.21,2464.23,9.82,11.25,18.25,4.75},
    startMarker={2163.05,2473.27,9.82},
},
    wm1={
        colCuboid={2631.68, 1234.06, 9.82, 9, 7.75, 4.5},
        startMarker={2635.78,1236.78,9.82},
    }
}

for i,v in pairs(myjnie) do
	if v.colCuboid then
  		v.cs=createColCuboid(unpack(v.colCuboid))
  	end
  	if v.startMarker then
  		v.marker=createMarker(v.startMarker[1],v.startMarker[2],v.startMarker[3],"cylinder",2)
		setElementData(v.marker,"myjnia",true)
	end
   if v.cs then
   setElementParent(v.marker,v.cs)
    end
end
function myjniaRun(hitElement,matchingDimension)
	if (getElementType(hitElement)~="vehicle") then return end
	if (not matchingDimension) then return end
	if (getElementInterior(hitElement)~=getElementInterior(source)) then return end
        local myjnia = getElementData(source,"myjnia")
        local driver = getVehicleOccupant(hitElement)
        if not myjnia then return end
        if driver then
        local pojazd = getPedOccupiedVehicle(driver)
        if pojazd then
        if getPlayerMoney(driver) < 10 then 
        	outputChatBox("Masz za mało pieniędzy aby umyć pojazd.",driver,255,0,0)
        	return
        end
        if (getElementHealth(pojazd)/10 <9) then
        	outputChatBox("Pojazd jest uszkodzony, napraw go i wtedy umyj.",driver,255,0,0)
        	return
        end
        if not getElementData(pojazd,"vehicle:clean") then
        	setElementFrozen(pojazd,true)
        local x,y,z=getElementPosition(pojazd)
        	local tlen = createObject(2058,x+2,y,z)
        	local tlen2 = createObject(2058,x,y,z)
        	local tlen3 = createObject(2058,x-2,y,z)
        	setTimer(function() destroyElement(tlen) destroyElement(tlen2) destroyElement(tlen3) outputChatBox('Zapłaciłeś 10$, za wymycie pojazdu.',driver) setElementFrozen(pojazd,false) end,5000,1)
        	setElementData(pojazd,"vehicle:clean",true)
        	takePlayerMoney(driver,10)
        end
   	end
end
end
addEventHandler("onMarkerHit",resourceRoot,myjniaRun)