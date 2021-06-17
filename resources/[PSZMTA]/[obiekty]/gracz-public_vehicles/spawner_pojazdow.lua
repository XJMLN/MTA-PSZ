--[[

spawner pojazdow na spawnie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-vehicles
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--
local auta = {
    -- x,y,z,rx,ry,rz,model 
    -- Uwaga! Auta grupujemy wedlug miast, wiosek jak sie tylko da!

    -- Los Santos 
    {2128.32,-1747.20,13.05,0,0,90,model=518},
    {2123.11,-1783.31,13.01,0,0,179.3,model=542},
    {2071.36,-1770.52,13.26,0,0,270.3,model=589},
    {2096.02,-1801.69,12.93,0,0,89.0,model=559},
    {2054.48,-1767.25,13.17,0,0,0.5,model=412},
    {1929.45,-1787.99,13.36,0,0,270.0,model=499},
    {1999.55,-1940.86,13.21,359.9,359.2,270.1,model=402},
    {2061.73,-1940.73,12.98,359.6,358.8,269.3,model=565},
    {2062.36,-1920.25,13.25,359.2,360.0,0.0,model=552},
    {1980.90,-1985.74,13.26,359.0,360.0,181.7,model=600},
    {1977.89,-1995.47,13.37,359.2,0.1,359.1,model=543},
    {1976.85,-2066.78,13.47,359.4,0.0,359.4,model=554},
    {1938.86,-2089.79,13.34,359.9,0.0,269.7,model=492},
    {1939.10,-2083.17,13.94,359.9,359.9,272.1,model=508},
    {1947.76,-2113.90,13.64,360.0,360.0,270.1,model=418},
    {1948.55,-2126.98,13.38,0.7,359.9,270.7,model=442},
    {1938.17,-2141.58,13.63,358.8,0.1,359.8,model=413},
    {1923.81,-2123.23,13.70,359.3,0.0,1.7,model=440},
    {2079.72,-2115.67,13.22,359.5,7.6,88.8,model=602},
    {1816.21,-1704.03,13.19,359.9,5.1,359.5,model=411},
    {1796.68,-1589.72,13.34,0.4,359.4,312.5,model=479},
    {1837.97,-1870.74,13.11,359.7,360.0,358.6,model=587},
    {1756.53,-1858.64,13.12,359.9,360.0,269.0,model=560},
    {1615.04,-1892.39,13.31,359.8,360.0,267.7,model=535},
    {1493.48,-1723.51,13.14,0.3,0.2,0.5,model=526},
    {1508.08,-1723.26,13.02,359.2,0.0,359.3,model=410},
    {1198.87,-1835.50,12.99,359.5,359.9,269.5,model=585},
    {1198.59,-1827.04,13.22,359.8,0.1,267.5,model=602},
    {1279.47,-1802.51,13.38,359.5,359.8,87.8,model=499},
    {1280.60,-1836.27,13.51,359.8,2.1,92.1,model=418},
    {1280.54,-1823.19,13.20,359.6,360.0,89.5,model=550},
    {1318.23,-1790.54,13.53,359.3,354.8,358.7,model=609},
    {1282.32,-1381.92,13.07,0.1,358.7,358.1,model=411},
    {1276.40,-1321.02,12.82,0.0,1.0,181.2,model=558},
    {1190.44,-1494.66,13.44,358.9,352.6,178.7,model=422},
    {1144.57,-1651.76,13.58,0.7,353.1,178.5,model=439},
    {1136.10,-1695.43,13.55,358.0,360.0,90.3,model=536},
    {1136.23,-1687.92,13.62,357.8,0.2,97.3,model=475},
    {1062.82,-1772.74,12.85,359.4,359.8,89.6,model=480},
    {1062.03,-1743.17,13.55,359.1,359.8,90.8,model=554},
    {1084.09,-1757.98,13.09,359.5,0.1,270.1,model=560},
    {1098.74,-1754.62,13.17,359.9,0.0,270.2,model=561},
    {1099.22,-1772.49,13.24,0.0,0.0,271.8,model=429},
    {1077.41,-1764.11,13.47,0.1,359.8,89.8,model=414},
    {954.60,-1368.14,13.33,359.9,350.4,359.7,model=603},
    {961.87,-1363.98,13.15,359.9,349.5,181.8,model=562},
    {961.03,-1379.38,13.26,359.4,349.3,176.1,model=559},
    {988.81,-1275.49,14.92,0.2,0.0,88.7,model=542},
    {979.66,-1260.91,16.37,350.0,359.6,179.4,model=499},
    {956.13,-1190.51,16.67,0.4,360.0,270.1,model=534},
    {955.95,-1199.21,16.83,359.8,359.6,271.5,model=402},
    {1065.65,-1191.54,19.86,9.8,356.2,27.8,model=555},
    {1050.31,-1206.64,17.71,349.7,3.7,179.6,model=418},
    {1050.02,-1249.58,14.78,354.9,359.9,180.1,model=589},
    {1049.88,-1293.38,13.17,359.6,2.8,179.9,model=542},
    {1049.82,-1349.54,13.48,359.8,359.9,180.3,model=414},
    {1050.38,-1373.85,13.25,0.6,360.0,180.2,model=402},
    {1066.63,-1351.37,13.12,359.8,359.3,1.6,model=536},
    {1066.28,-1322.74,12.93,359.7,360.0,359.9,model=451},
    {1066.36,-1295.54,13.30,0.3,2.8,1.1,model=458},
    {877.25,-1072.54,24.53,0.3,2.2,271.6,model=489},
    {858.36,-1062.54,25.28,359.9,0.1,231.1,model=456},
    {965.05,-932.76,42.10,350.5,2.4,181.1,model=478},
    {1025.80,-982.66,42.79,0.4,358.4,275.4,model=554},
    {2093.29,-1363.71,23.81,1.2,0.7,185.0,model=479},
    -- San Fierro

    {-2179.05,1221.46,33.71,0.3,0.0,4.4,model=411},
    {-2512.77,1209.89,37.20,359.9,0.0,276.2,model=559},
    {-2794.83,805.07,47.92,352.1,357.3,37.3,model=451},
    {-2482.01,740.92,34.97,0.2,359.7,179.4,model=478},
    {-2455.74,740.74,34.75,0.3,0.3,180.5,model=404},
    {-2213.19,726.15,48.99,359.4,354.3,269.4,model=410},
    {-1972.82,892.24,44.57,359.7,359.9,91.0,model=549},
    {-1972.68,880.36,44.94,0.3,360.0,89.7,model=547},
    {-1756.26,948.43,24.36,358.1,357.4,271.3,model=541},
    {-1740.29,954.23,24.58,0.6,0.4,70.5,model=479},
    {-1700.17,1036.13,45.32,359.2,0.7,92.0,model=440},
    {-1993.90,1100.74,53.12,359.8,359.6,269.5,model=517},
    {-2442.18,1032.11,50.21,359.1,359.8,276.4,model=543},
    {-2414.62,1020.95,50.20,0.2,359.7,0.6,model=545},
    {-2429.33,1043.56,50.10,359.2,359.8,269.9,model=600},
    {-2460.86,145.71,34.90,359.9,359.8,189.9,model=579},
    {-2439.42,133.39,35.05,360.0,0.0,271.4,model=400},
    {-2453.64,162.27,35.11,359.7,359.8,2.2,model=489},
    {-2491.08,90.77,25.36,359.0,1.5,214.2,model=474},
    {-2585.06,74.77,4.58,356.9,357.7,88.1,model=550},
    {-2506.94,-14.48,25.55,359.2,4.8,1.7,model=540},
    {-2485.11,6.61,25.41,0.0,0.1,89.2,model=580},
    {-2317.35,-149.39,35.19,0.3,8.0,0.9,model=445},
    {-2322.45,-124.86,35.11,0.0,360.0,180.7,model=419},
    {-2340.88,-125.21,35.02,359.6,0.3,178.8,model=533},
    {-2089.14,-83.54,34.84,359.9,0.0,178.2,model=589},
    {-2072.64,-83.77,34.92,0.6,0.0,183.0,model=491},
    {-2020.66,-44.51,35.12,0.2,359.5,182.2,model=566},
    {-1993.99,143.95,27.26,359.7,0.0,0.3,model=587},
    {-1987.76,170.68,27.32,0.0,360.0,358.9,model=492},
    {-1987.82,119.75,27.42,0.0,359.9,180.5,model=421},
    {-2038.16,139.63,28.58,359.2,0.3,268.2,model=466},
    {-1988.02,303.17,34.94,0.1,0.0,89.7,model=526},
    {-1989.95,276.01,34.91,0.2,359.9,87.0,model=527},
    {-1991.07,258.25,34.86,359.7,0.2,265.2,model=518},
}

for i,v in ipairs(auta) do
    v.pojazd = createVehicle(v.model,v[1],v[2],v[3],v[4],v[5],v[6])
    setElementData(v.pojazd,"public:vehicle",true)
    setElementFrozen(v.pojazd,true)
   setTimer(function() setElementFrozen(v.pojazd,false) end,4000,1)
    setVehicleDamageProof(v.pojazd,true)
    toggleVehicleRespawn(v.pojazd,true)
    setVehicleIdleRespawnDelay(v.pojazd,3500)
    setVehicleRespawnPosition(v.pojazd,v[1],v[2],v[3],v[4],v[5],v[6])
    local c1,c2,c3 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c4,c5,c6 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c7,c8,c9 = math.random(0,255), math.random(0,255), math.random(0,255)
    local c10,c11,c12 = math.random(0,255), math.random(0,255), math.random(0,255)
    setVehicleColor(v.pojazd,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)
end
function onExit()
    if (getElementData(source,"public:vehicle") ) then
        setTimer(respawnVehicle, 3000,1,source)
    end
end
addEventHandler("onVehicleExit",getRootElement(),onExit)
addEventHandler("onVehicleExplode", getRootElement(),onExit)

addEventHandler("onVehicleStartEnter", getRootElement(), function(player)
    if getElementData(source,"public:vehicle") then 
        outputChatBox("Ten pojazd jest zablokowany, nie możesz do niego wsiąść.",player,255,0,0)
        cancelEvent()
    end
end)

local function spawner_restartAllVehs()
    for i,v in ipairs(auta) do
        if v.pojazd then 
            destroyElement(v.pojazd)
            v.pojazd = nil
        end
    end

    for i,v in ipairs(auta) do
        v.pojazd = createVehicle(v.model,v[1],v[2],v[3],v[4],v[5],v[6])
        setElementData(v.pojazd,"public:vehicle",true)
        setElementFrozen(v.pojazd,true)
        setTimer(function() setElementFrozen(v.pojazd,false) end,4000,1)
        setVehicleDamageProof(v.pojazd,true)
        toggleVehicleRespawn(v.pojazd,true)
        setVehicleIdleRespawnDelay(v.pojazd,3500)
        setVehicleRespawnPosition(v.pojazd,v[1],v[2],v[3],v[4],v[5],v[6])
        local c1,c2,c3 = math.random(0,255), math.random(0,255), math.random(0,255)
        local c4,c5,c6 = math.random(0,255), math.random(0,255), math.random(0,255)
        local c7,c8,c9 = math.random(0,255), math.random(0,255), math.random(0,255)
        local c10,c11,c12 = math.random(0,255), math.random(0,255), math.random(0,255)
        setVehicleColor(v.pojazd,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12)
    end
    outputDebugString("Nastąpiło przeładowanie pojazdów do holowania!")
end
setTimer(spawner_restartAllVehs,43200000,0) -- 12 H