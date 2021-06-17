local pozary_location = {
    {-2104.09,161.63,35.10, nazwa="San Fierro, ruiny obok Doherty"},
    {-1956.96,288.33,35.47, nazwa="San Fierro, salon samochodowy"},
    
}
-- Na start zasobu zawsze tworzymy wszystkie pozary.
function create_fire()
    for i,v in ipairs(pozary_location) do
        local x,y,z = v[1],v[2],v[3]

    for i=1,50 do
    local radius = math.random(5,50)
    local kat=math.random(0,360)
    local x=v[1]+(radius*math.sin(kat))
    local y=v[2]+(radius*math.cos(kat))
    local z=getGroundPosition(x,y,v[3])

    if (z and z>0) then
        triggerServerEvent("doCreateFire",root, x,y,z-0.5,0,0)
    end
end
end
end
setTimer(create_fire,10000,1)

function create_random_fire()
local ilosc = math.random(1,#pozary_location)
local xv = pozary_location[ilosc][1]
local yv = pozary_location[ilosc][2]
local zv = pozary_location[ilosc][3]
for i=1,50 do
    local radius = math.random(5,50)
    local kat=math.random(0,360)
    local x=xv+(radius*math.sin(kat))
    local y=yv+(radius*math.cos(kat))
    local z=getGroundPosition(x,y,zv)

    if (z and z>0) then
        triggerServerEvent("doCreateFire",root, x,y,z-0.5,0,0)
    end
end
end
setTimer(create_random_fire,300000,0)
