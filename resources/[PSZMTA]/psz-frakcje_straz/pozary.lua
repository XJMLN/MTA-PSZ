local pozary_location = {
    {1153.51,-2037.41,69.06,0,0},
    {1159.78,-2036.20,69.06,0,0},
}
-- Na start zasobu zawsze tworzymy wszystkie pozary.
function create_fire()
    for i,v in ipairs(pozary_location) do
    for i=1,50 do
    local radius = math.random(1,5)
    local kat=math.random(0,360)
    local x=v[1]+(radius*math.sin(kat))
    local y=v[2]+(radius*math.cos(kat))
    local z=v[3]

    if (z and z>0) then
        exports['syncedfire']:createFire(x,y,z,v[4],v[5]);
    end
end
end
end
create_fire();
