local I=1
local D=51

local grazynka=createPed(55,2810.90,-1085.22,1593.80,270,false)
setElementDimension(grazynka,D)
setElementInterior(grazynka,I)
setElementFrozen(grazynka,true)
setElementData(grazynka,'npc',true)
setElementRotation(grazynka,0,0,270)
setElementData(grazynka,'name',"Pani Grażynka")

local renia = createPed(55,2810.90,-1089.08,1593.80,270,false)
setElementDimension(renia,D)
setElementInterior(renia,I)
setElementFrozen(renia,true)
setElementData(renia,'npc',true)
setElementRotation(renia,0,0,270)
setElementData(renia,'name',"Pani Renatka")

local tadeusz = createPed(185,2810.90,-1093.36,1593.80,270,false)
setElementDimension(tadeusz,D)
setElementInterior(tadeusz,I)
setElementFrozen(tadeusz,true)
setElementData(tadeusz,'npc',true)
setElementData(tadeusz,'name',"Pan Tadeusz")