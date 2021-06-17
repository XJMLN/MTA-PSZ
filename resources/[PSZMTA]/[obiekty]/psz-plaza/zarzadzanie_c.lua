local kino = false
local marker=createMarker(357.21,-1875.41,9.9,"cylinder",1,255,0,255,255)
local I = 0
local D = 0
local playingAudio=nil

local function allowedPlayer(plr)
	local c = getElementData(plr,"character")
	if not c then return false end
	local root = getElementData(plr,"auth:root")
	if (not root) then return false end
	return true
end

local function playNewAudio(audio)
	
	if playingAudio and isElement(playingAudio) then
		destroyElement(playingAudio)
	end                                                                      
	playingAudio=playSound3D(audio[1],audio[2],audio[3],audio[4],true)
	setElementInterior(playingAudio,audio[5])
	setElementDimension(playingAudio,audio[6])
	setSoundMinDistance(playingAudio,audio[7])
	setSoundMaxDistance(playingAudio,audio[8])
end


addEventHandler("onClientColShapeHit", resourceRoot, function(el,md)
	if el~=localPlayer or not md then return end
	local audio=getElementData(source,"audio")
	if not audio then return end
	playNewAudio(audio)
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(el,md)
	if el~=localPlayer then return end
	if not getElementData(source,"audio") then return end
	if playingAudio and isElement(playingAudio) then
		destroyElement(playingAudio)
	end
end)

addEventHandler("onClientElementDataChange", resourceRoot, function(dataName)
	if dataName~="audio" then return end
	if getElementType(source)~="colshape" then return end
	if not isElementWithinColShape(localPlayer, source) then return end
	if getElementDimension(localPlayer)~=getElementDimension(source) then return end
	if getElementInterior(localPlayer)~=getElementInterior(source) then return end
	if not getElementData(source,"audio") then return end
	playNewAudio(getElementData(source,"audio"))
end)

function onClientHit(el,md)
	if not md or el~=localPlayer then return end

	if getPedOccupiedVehicle(localPlayer) then return end
	if not allowedPlayer(el) then 
		outputChatBox("Nie należysz do grupy zarządzania sceną.",255,0,0)
		return
	end
	triggerServerEvent("doMoveScena",resourceRoot,localPlayer)
end
addEventHandler("onClientMarkerHit",marker,onClientHit)



































local artysta1=createPed(231,336.64,-1860.89,10.75,356.1,false)
setElementDimension(artysta1,D)
setElementInterior(artysta1,I)
setElementFrozen(artysta1, true)
setElementData(artysta1, "npc", true)
--setPedAnimation ( artysta1, "STRIP", "strip_G", -1, true, false )
setPedAnimation ( artysta1, "SKATE", "skate_idle", -1, true, false )

local artysta2=createPed(231,339.00,-1860.93,10.75,1.5,false)
setElementDimension(artysta2,D)
setElementInterior(artysta2,I)
setElementFrozen(artysta2, true)
setElementData(artysta2, "npc", true)
setPedAnimation ( artysta2, "SKATE", "skate_idle", -1, true, false )


local chor1=createPed(69,346.51,-1861.92,10.75,35.4,false)
setElementDimension(chor1,D)
setElementInterior(chor1,I)
setElementFrozen(chor1, true)
setElementData(chor1, "npc", true)
setPedAnimation ( chor1, "ON_LOOKERS", "shout_in", -1, true, false )

local chor2=createPed(56,346.08,-1863.17,10.75,49.2,false)
setElementDimension(chor2,D)
setElementInterior(chor2,I)
setElementFrozen(chor2, true)
setElementData(chor2, "npc", true)
setPedAnimation ( chor2, "ON_LOOKERS", "shout_in", -1, true, false )

local chor3=createPed(93,347.71,-1861.59,10.75,46.3,false)
setElementDimension(chor3,D)
setElementInterior(chor3,I)
setElementFrozen(chor3, true)
setElementData(chor3, "npc", true)
setPedAnimation ( chor3, "ON_LOOKERS", "shout_in", -1, true, false )

local chor4=createPed(54,324.89,-1862.65,10.75,304.4,false)
setElementDimension(chor4,D)
setElementInterior(chor4,I)
setElementFrozen(chor4, true)
setElementData(chor4, "npc", true)
setPedAnimation ( chor4, "ON_LOOKERS", "shout_in", -1, true, false )

local chor5=createPed(89,325.13,-1864.11,10.75,320.7,false)
setElementDimension(chor5,D)
setElementInterior(chor5,I)
setElementFrozen(chor5, true)
setElementData(chor5, "npc", true)
setPedAnimation ( chor5, "ON_LOOKERS", "shout_in", -1, true, false )

local chor6=createPed(234,327.02,-1864.77,10.75,326.3,false)
setElementDimension(chor6,D)
setElementInterior(chor6,I)
setElementFrozen(chor6, true)
setElementData(chor6, "npc", true)
setPedAnimation ( chor6, "ON_LOOKERS", "shout_in", -1, true, false )


local tancerz1=createPed(108,330.85,-1869.83,10.75,353.5,false)
setElementDimension(tancerz1,D)
setElementInterior(tancerz1,I)
setElementFrozen(tancerz1, true)
setElementData(tancerz1, "npc", true)
setPedAnimation ( tancerz1, "FINALE", "FIN_Cop1_Stomp", -1, true, false )

local tancerz2=createPed(214,333.34,-1866.63,10.75,358.9,false)
setElementDimension(tancerz2,D)
setElementInterior(tancerz2,I)
setElementFrozen(tancerz2, true)
setElementData(tancerz2, "npc", true)
setPedAnimation ( tancerz2, "STRIP", "STR_C2", -1, true, false )

local tancerz3=createPed(214,336.13,-1868.46,10.75,351.7,false)
setElementDimension(tancerz3,D)
setElementInterior(tancerz3,I)
setElementFrozen(tancerz3, true)
setElementData(tancerz3, "npc", true)
setPedAnimation ( tancerz3, "STRIP", "STR_C2", -1, true, false )

local tancerz4=createPed(214,339.45,-1866.85,10.75,358.6,false)
setElementDimension(tancerz4,D)
setElementInterior(tancerz4,I)
setElementFrozen(tancerz4, true)
setElementData(tancerz4, "npc", true)
setPedAnimation ( tancerz4, "STRIP", "STR_C2", -1, true, false )

local tancerz5=createPed(108,343.13,-1869.27,10.75,358.9,false)
setElementDimension(tancerz5,D)
setElementInterior(tancerz5,I)
setElementFrozen(tancerz5, true)
setElementData(tancerz5, "npc", true)
setPedAnimation ( tancerz5, "FINALE", "FIN_Cop1_Stomp", -1, true, false )

local tancerz6=createPed(33,334.07,-1868.66,10.75,3.0,false)
setElementDimension(tancerz6,D)
setElementInterior(tancerz6,I)
setElementFrozen(tancerz6, true)
setElementData(tancerz6, "npc", true)
setPedAnimation ( tancerz6, "STRIP", "strip_B", -1, true, false )

local tancerz7=createPed(33,340.07,-1868.29,10.75,356.6,false)
setElementDimension(tancerz7,D)
setElementInterior(tancerz7,I)
setElementFrozen(tancerz7, true)
setElementData(tancerz7, "npc", true)
setPedAnimation ( tancerz7, "STRIP", "strip_B", -1, true, false )

local raper1=createPed(28,337.71,-1857.84,10.75,0.9,false)
setElementDimension(raper1,D)
setElementInterior(raper1,I)
setElementFrozen(raper1, true)
setElementData(raper1, "npc", true)
setPedAnimation ( raper1, "RAPPING", "RAP_C_Loop", -1, true, false )

local raper2=createPed(29,344.25,-1863.54,10.75,30.5,false)
setElementDimension(raper2,D)
setElementInterior(raper2,I)
setElementFrozen(raper2, true)
setElementData(raper2, "npc", true)
setPedAnimation ( raper2, "SCRATCHING", "scmid_l", -1, true, false )