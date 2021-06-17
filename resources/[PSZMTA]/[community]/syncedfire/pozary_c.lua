local pozary_location = {
    {1153.51,-2037.41,69.06},
    {1159.78,-2036.20,69.06},
}
-- Na start zasobu zawsze tworzymy wszystkie pozary.
function create_fire()
    for i,v in ipairs(pozary_location) do
    for i=1,50 do
    local radius = math.random(1,5)
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
addEventHandler("onClientResourceStart",getRootElement(),create_fire)

function create_random_fire()
    outputDebugString("tworze nowy ogien przez create_random_fire")
local ilosc = math.random(1,#pozary_location)
local xv = pozary_location[liczba][1]
local yv = pozary_location[liczba][2]
local zv = pozary_location[liczba][3]

for i=1,20 do
    local radius = math.random(1,5)
    local kat=math.random(0,360)
    local x=xv+(radius*math.sin(kat))
    local y=yv+(radius*math.cos(kat))
    local z=getGroundPosition(x,y,zv)

    if (z and z>0) then
        triggerServerEvent("doCreateFire",root, x,y,z-0.5,0,0)
    end
end
end
setTimer(create_random_fire,3000000,0)
