local D=0
local I=0

local playingAudio=nil

local function playNewAudio(audio)
	
	if playingAudio and isElement(playingAudio) then
		destroyElement(playingAudio)
		playingAudio = nil
	end
	playingAudio=playSound3D("http://s15038.sbg1.fastd.svpj.pl/psz-muzyka/swieta/"..audio[1],audio[2],audio[3],audio[4],true)
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
	playNewAudio(getElementData(source,"audio"))
end)

local panel = createMarker(-1549.69,936.88,6.04,"cylinder",1,255,0,0)
setElementInterior(panel,I)
setElementDimension(panel,D)

local t = createElement('ctext')
setElementData(t,"ctext", "Zmiana piosenki")
setElementPosition(t,-1549.69,936.88,7.04+0.50)


GUIEditor_Window = {}
GUIEditor_Button = {}
GUIEditor_CMB = {}

local radia={
	{nazwa="All i want for christmas is You", url="all_i_want_for_christmas.mp3"},
	{nazwa="Ulepimy dziś bałwana", url="ulepimy_dzis_balwana.mp3"},
	{nazwa="Merry Christmas - remix", url="mr_christmas_rmx.mp3"},
}

GUIEditor_Window = guiCreateWindow(0.2688,0.4,0.5138,0.4,"Konsola DJ'a",true)
guiWindowSetSizable(GUIEditor_Window,false)
GUIEditor_CMB = guiCreateComboBox(0.02,0.15,0.674,1.5,"Wybierz nową piosenkę",true,GUIEditor_Window)

for i,v in ipairs(radia) do
	guiComboBoxAddItem(GUIEditor_CMB, v.nazwa)
end
GUIEditor_Button = guiCreateButton(0.7299,0.2966,0.2409,0.2712,"Zmień",true,GUIEditor_Window)
guiSetVisible(GUIEditor_Window, false)

addEventHandler("onClientMarkerHit", panel, function(el,md)
	if el~=localPlayer or not md then return end
	--if getPlayerName(el)~="XJMLN" then return end
	--if playerAllowed(el) then 
	guiSetVisible(GUIEditor_Window, true)
	toggleControl("fire",false)
	showCursor(true,false)
	--end
end)

addEventHandler("onClientMarkerLeave", panel, function(el,md)
	if el~=localPlayer then return end
	guiSetVisible(GUIEditor_Window, false)
	toggleControl("fire",true)
	showCursor(false)
end)

local mc_lu=getTickCount()-10000

addEventHandler("onClientGUIClick", GUIEditor_Button, function()
	local item=guiComboBoxGetSelected(GUIEditor_CMB)
	if not item or item<0 then return end
	if getTickCount()-mc_lu<10000 then
		outputChatBox("Musisz odczekać jeszcze 10 sekund.",255,0,0)
		return
	end
	mc_lu=getTickCount()
	strumien=radia[item+1].url
	strumien_opis= guiComboBoxGetItemText(GUIEditor_CMB, item)

	triggerServerEvent("doChangeAudio", resourceRoot, localPlayer, strumien, strumien_opis)
end, false)

addEvent("doHideWindowsAudio",true)
addEventHandler("doHideWindowsAudio", resourceRoot, function()
	guiSetVisible(GUIEditor_Window,false)
	showCursor(false)
	toggleControl("fire",true)
end)