local D=0
local I=0
-- wyspa sf
--local naglosnienie=playSound3D("http://www.miastomuzyki.pl/n/rmffm.pls",-3412.31,1936.89,8.31,true)
local naglosnienie=playSound3D("http://s17753.rbx2.fastd.svpj.pl/psz-spawnsf2/radio.pls",0,0,5,true)
setElementInterior(naglosnienie,I)
setElementDimension(naglosnienie,D)
setSoundMinDistance(naglosnienie,10)
setSoundMaxDistance(naglosnienie,100)
-- bar obok SFPD
local naglosnienie=playSound3D("http://lilek.awsome.pl/Radia/popularne.pls",-1571.06,560.65,10.12,true)
setElementInterior(naglosnienie,I)
setElementDimension(naglosnienie,D)
setSoundMinDistance(naglosnienie,10)
setSoundMaxDistance(naglosnienie,40)
-- mechanik LS


local naglosnienie=playSound3D("http://lilek.awsome.pl/Radia/popularne.pls",2448.10,-1641.00,18.0,true)
setElementInterior(naglosnienie,I)
setElementDimension(naglosnienie,D)
setSoundMinDistance(naglosnienie,10)
setSoundMaxDistance(naglosnienie,30)

-- arena ox
local naglosnienie=playSound3D(":psz-dzwieki/audio/ox.ogg",1446.10,1458.23,11.07,true)
setElementInterior(naglosnienie,0)
setElementDimension(naglosnienie,2430)
setSoundMinDistance(naglosnienie,10)
setSoundMaxDistance(naglosnienie,400)
