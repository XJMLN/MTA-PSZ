local D=0
local I=17

local playingAudio=nil

local function playNewAudio(audio)
	
	if playingAudio and isElement(playingAudio) then
		destroyElement(playingAudio)
		playingAudio = nil
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
	playNewAudio(getElementData(source,"audio"))
end)

local panel = createColSphere(487.31,-0.69,1002.38,1)
setElementInterior(panel,I)
setElementDimension(panel,D)

GUIEditor_Window = {}
GUIEditor_Button = {}
GUIEditor_Edit = {}
GUIEditor_CMB = {}
GUIEditor_lbl = {}
GUIEditor_lbl2 = {}
GUIEditor_Button2 = {}
local radia={
	{nazwa="Disco Polo", url="http://gr-relay-4.gaduradio.pl/21"},
	{nazwa="MTV", url="http://gr-relay-4.gaduradio.pl/51"},
	{nazwa="HIP-HOP PL", url="http://gr-relay-4.gaduradio.pl/24"},
	{nazwa="OPEN.FM - Popularne", url="http://lilek.awsome.pl/Radia/popularne.pls"},
	{nazwa="OPEN.FM - Impreza", url="http://gr-relay-4.gaduradio.pl/2"},
	{nazwa="Dziecinne", url="http://gr-relay-4.gaduradio.pl/16"},
	{nazwa="Biesiady", url="http://gr-relay-4.gaduradio.pl/59"},	
	{nazwa="Ciężkie brzmienia", url="http://gr-relay-4.gaduradio.pl/13"},
	{nazwa="OPEN.FM", url="http://gr-relay-4.gaduradio.pl/69"},
	{nazwa="100% ZBUKU", url="a/zbuku.ogg"},
}

GUIEditor_Window = guiCreateWindow(0.2688,0.4,0.5138,0.4,"Konsola DJ'a",true)
guiWindowSetSizable(GUIEditor_Window,false)
GUIEditor_CMB = guiCreateComboBox(0.02,0.15,0.674,1.5,"Wybierz nową piosenkę",true,GUIEditor_Window)

for i,v in ipairs(radia) do
	guiComboBoxAddItem(GUIEditor_CMB, v.nazwa)
end
GUIEditor_Button = guiCreateButton(0.7299,0.2966,0.2409,0.2712,"Zmień",true,GUIEditor_Window)
GUIEditor_Button2 = guiCreateButton(0.7299, 0.7, 0.2409, 0.2712, "Zmień na YT", true, GUIEditor_Window)
GUIEditor_lbl2 = guiCreateLabel(0.02, 0.7, 0.674, 0.1, "Link z YT:", true, GUIEditor_Window)
GUIEditor_lbl = guiCreateEdit(0.02,0.8,0.674,0.1, "",true, GUIEditor_Window)
guiSetVisible(GUIEditor_Window, false)

local function playerAllowed(plr)
    local c=getElementData(plr,"character")
    if not c then return false end
   	local fr = getElementData(plr,"faction:data")
   	local lvl = getElementData(plr, "level")
   	if fr and fr.id == 6 or (lvl==3) then return true else return false end
end

addEventHandler("onClientColShapeHit", panel, function(el,md)
	if el~=localPlayer or not md then return end
	if playerAllowed(el) then 
	guiSetVisible(GUIEditor_Window, true)
	toggleControl("fire",false)
	showCursor(true,false)
	end
end)

addEventHandler("onClientColShapeLeave", panel, function(el,md)
	if el~=localPlayer then return end
	guiSetVisible(GUIEditor_Window, false)
	toggleControl("fire",true)
	showCursor(false)
end)

local mc_lu=getTickCount()-10000

addEventHandler("onClientGUIClick", GUIEditor_Button, function()
	local item=guiComboBoxGetSelected(GUIEditor_CMB)
	if not item or item<1 then return end
	if getTickCount()-mc_lu<10000 then
		outputChatBox("Musisz odczekać jeszcze 10 sekund.",255,0,0)
		return
	end
	mc_lu=getTickCount()
	strumien=radia[item+1].url
	strumien_opis= guiComboBoxGetItemText(GUIEditor_CMB, item)

	triggerServerEvent("doChangeAudio", resourceRoot, localPlayer, strumien, strumien_opis)
end, false)

addEventHandler("onClientGUIClick", GUIEditor_Button2, function()
	local item=guiGetText(GUIEditor_lbl)
	if not item then return end
	if getTickCount()-mc_lu<10000 then
		outputChatBox("Musisz odczekać jeszcze 10 sekund.",255,0,0)
		return
	end
	mc_lu=getTickCount()
	--strumien=radia[item+1].url
	--strumien_opis= guiComboBoxGetItemText(GUIEditor_CMB, item)
	strumien = item
	strumien_opis = guiGetText(GUIEditor_lbl)
	triggerServerEvent("doChangeAudioYT", resourceRoot, localPlayer, strumien, strumien_opis)
end, false)

addEvent("doHideWindowsAudio",true)
addEventHandler("doHideWindowsAudio", resourceRoot, function()
	guiSetVisible(GUIEditor_Window,false)
	showCursor(false)
	toggleControl("fire",true)
end)