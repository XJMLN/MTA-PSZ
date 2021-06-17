
local sw, sh = guiGetScreenSize()
local edytor = {
	state = false,
	object = nil,
	--offset = {0,0,0},
	--offsetRot = {0,0,90},
}

local buttons = {
	choosen = 1,
}
function edytor_startup(state,id)
	if edytor.state and isElement(edytor.object) then return end
	local iEdit = getElementData(localPlayer,"itemEditor")
	if iEdit and iEdit.active then
		outputChatBox("Posiadasz już przyklejony obiekt, jeżeli chcesz go usunąć wpisz /edelete.",255,0,0)
		return
	end

	if state then 
		local offSetData = edytor_getOffsetData(tonumber(id))
		if not (offSetData) then 
			outputChatBox("Wystąpił błąd, powiadom administratora.",255,0,0)
			return
		end
		 
		edytor.state = true
		edytor.object = createObject(tonumber(id),0,0,5)
		edytor.offset = {offSetData[1],offSetData[2],offSetData[3]}
		edytor.offsetRot = {offSetData[4],offSetData[5],offSetData[6]}
		setElementCollisionsEnabled(edytor.object, false)
		exports["bone_attach"]:attachElementToBone(edytor.object,localPlayer,1,0,0,0,180,0,90)
		addEventHandler("onClientRender", root, edytor_objectEdit)
		addEventHandler("onClientClick", root, edytor_mouseLogic)
		addEventHandler("onClientKey", root, edytor_changeVector)
		outputChatBox("Aby wyjść z edytora wpisz /ecancel")
		outputChatBox("Aby usunąć czapkę wpisz /edelete")
		outputChatBox("Aby zapisać czapkę wpisz /esave")
	end
end


function edytor_objectEdit()
	if getKeyState("space") then
		if isCursorShowing() then showCursor(false) end
	else
		if not isCursorShowing() then showCursor(true) end
	end

	
	local posX, posY, posZ = getElementPosition(edytor.object)
	local rotX, rotY, rotZ = getElementRotation(edytor.object)

	if rotZ > 360 then rotZ = 0 end
	if rotX > 360 then rotX = 0 end
	if rotY > 360 then rotY = 0 end
	local xxVel, xyVel = edytor_velocityAngleZtoX(rotZ)
	local yxVel, yyVel = edytor_velocityAngleZtoY(-rotZ)

	local colorX = tocolor(255,0,0,255)
	local colorY = tocolor(0,255,0,255)
	local colorZ = tocolor(0,0,255,255)

	local alpha = {0.5, 0.5, 0.5, 0.5, 0.5, 0.5}

	if buttons.choosen == 1 then 
		colorY = tocolor(0, 255, 0, 20)
		colorZ = tocolor(0,0,255,20)
		alpha[1] = 1.0
	elseif buttons.choosen == 2 then
		colorX = tocolor(255,0,0,20)
		colorZ = tocolor(0,0,255,20)
		alpha[2] = 1.0
	elseif buttons.choosen == 3 then 
		colorX = tocolor(255,0,0,20)
		colorY = tocolor(0,255,0,20)
		alpha[3] = 1.0
	elseif buttons.choosen == 4 then 
		colorY = tocolor(0,255,0,20)
		colorZ = tocolor(0,0,255,20)
		alpha[4] = 1.0
	elseif buttons.choosen == 5 then 
		colorX = tocolor(255,0,0,20)
		colorZ = tocolor(0,0,255,20)
		alpha[5] = 1.0
	elseif buttons.choosen == 6 then
		colorX = tocolor(255,0,0,20)
		colorY = tocolor(0,255,0,20)
		alpha[6] = 1.0
	end
	-- posX button
	dxDrawRectangle(sw/2 - 200, sh/2 + 100, 20, 20, tocolor(60,60,60, 200 * alpha[1]))
	dxDrawText("X", sw/2 - 200, sh/2 + 100, (sw/2 -200) + 20, (sh/2 + 100) + 20, tocolor(255,255,255,255 * alpha[1]), 1.0, "default-bold", "center", "center")

	-- posY button
	dxDrawRectangle(sw/2 - 180, sh/2 + 100, 20, 20, tocolor(60, 60, 60, 200 * alpha[2]))
	dxDrawText("Y", sw/2 - 180, sh/2 + 100, (sw/2 - 180) + 20, (sh/2 + 100) + 20, tocolor(255,255,255,255 * alpha[2]), 1.0, "default-bold", "center", "center")

	-- posZ button 
	dxDrawRectangle(sw/2 - 160, sh/2 + 100, 20, 20, tocolor(60,60,60, 200 * alpha[3]))
	dxDrawText("Z", sw/2 - 160, sh/2 + 100, (sw/2 - 160) + 20, (sh/2 + 100) + 20, tocolor(255,255,255,255 * alpha[3]), 1.0, "default-bold", "center", "center")

	-- rX button 
	dxDrawRectangle(sw/2 - 200, sh/2 + 120, 20, 20, tocolor(60, 60, 60, 200 * alpha[4]))
	dxDrawText("rX", sw/2 - 200, sh/2 + 120, (sw/2 - 200) + 20, (sh/2 + 120) + 20, tocolor(255,255,255,255 * alpha[4]), 1.0, "default-bold", "center", "center")

	--rY button
	dxDrawRectangle(sw/2 - 180, sh/2 + 120, 20, 20, tocolor(60, 60, 60, 200 * alpha[5]))
	dxDrawText("rY", sw/2 - 180, sh/2 + 120, (sw/2 - 180) + 20, (sh/2 + 120) + 20, tocolor(255,255,255,255 * alpha[5]), 1.0, "default-bold", "center", "center")

	-- rZ button
	dxDrawRectangle(sw/2 - 160, sh/2 + 120, 20, 20, tocolor(60, 60, 60, 200 * alpha[6]))
	dxDrawText("rZ", sw/2 - 160, sh/2 + 120, (sw/2 - 160) + 20, (sh/2 + 120) + 20, tocolor(255,255,255,255 * alpha[6]), 1.0, "default-bold", "center", "center")

	-- Informacje o komendach

	dxDrawLine3D(posX -xxVel, posY -xyVel, posZ, posX + xxVel, posY + xyVel, posZ, colorX, 2, true)
	dxDrawLine3D(posX - yxVel, posY - yyVel, posZ, posX + yxVel, posY + yyVel, posZ, colorY, 2, true)
	dxDrawLine3D(posX, posY, posZ - 1, posX, posY, posZ + 1, colorZ, 2,true)

	if edytor.mode == "startup" then 
		local sPos = edytor.sPos
		local curX, curY = getCursorPosition()
		if curX then 
			dxDrawLine(sPos[1] * sw, sPos[2] * sh, curX * sw, sPos[2] * sh)
			local vec1 = curX - sPos[1]
			if buttons.choosen == 1 then 
				xxVel , xyVel = edytor_velocityAngleZtoX(rotZ, vec1 * 10)
				posX = edytor.tmpPos.X + xxVel
				posY = edytor.tmpPos.Y + xyVel
				edytor.offset[1] = getOffsetFromXYZ(getElementMatrix(edytor.object),{posX, posY, posZ}, 1)
			elseif buttons.choosen == 2 then 
				yxVel, yyVel = edytor_velocityAngleZtoY(-rotZ, vec1 * 10)
				posX = edytor.tmpPos.X + yxVel
				posY = edytor.tmpPos.Y + yyVel
				edytor.offset[2] = getOffsetFromXYZ(getElementMatrix(edytor.object),{posX, posY, posZ}, 2)
			elseif buttons.choosen == 3 then 
				posZ = edytor.tmpPos.Z + vec1 * 5
				edytor.offset[3] = getOffsetFromXYZ(getElementMatrix(edytor.object),{posX, posY, posZ}, 3)
			elseif buttons.choosen == 4 then 
				rotX = edytor.tmpPos.RX + vec1 * 10
				edytor.offsetRot[1] = getOffsetFromXYZ(getElementMatrix(edytor.object), {rotX, rotY, rotZ}, 1)
			elseif buttons.choosen == 5 then 
				rotY = edytor.tmpPos.RY + vec1 * 10
				edytor.offsetRot[2] = getOffsetFromXYZ(getElementMatrix(edytor.object), {rotX, rotY, rotZ}, 2)
			elseif buttons.choosen == 6 then
				rotZ = edytor.tmpPos.RZ + vec1
				edytor.offsetRot[3] = getOffsetFromXYZ(getElementMatrix(edytor.object), {rotX, rotY, rotZ}, 3)
			end
		end
	end

	exports['bone_attach']:setElementBonePositionOffset(edytor.object, edytor.offset[1], edytor.offset[2], edytor.offset[3])
	exports['bone_attach']:setElementBoneRotationOffset(edytor.object, edytor.offsetRot[1], edytor.offsetRot[2], edytor.offsetRot[3])
end

function edytor_mouseLogic(button, state)
	if button ~= "left" then return end
	if state == "down" and  edytor_getCursor(sw/2 - 200, sh/2 + 100, (sw/2 - 200) + 20, (sh/2 + 100) + 20) then 
		buttons.choosen = 1
	elseif state == "down" and edytor_getCursor(sw/2 - 180, sh/2 + 100, (sw/2 - 180) + 20, (sh/2 + 100) + 20) then 
		buttons.choosen = 2
	elseif state == "down" and edytor_getCursor(sw/2 - 160, sh/2 + 100, (sw/2 - 160) + 20, (sh/2 + 100) + 20) then 
		buttons.choosen = 3
	elseif state == "down" and edytor_getCursor(sw/2 - 200, sh/2 + 120, (sw/2 - 200) + 20, (sh/2 + 120) + 20) then 
		buttons.choosen = 4
	elseif state == "down" and edytor_getCursor(sw/2 - 180, sh/2 + 120, (sw/2 - 180) + 20, (sw/2 + 120) + 20) then 
		buttons.choosen = 5
	elseif state == "down" and edytor_getCursor(sw/2 - 160, sh/2 + 120, (sw/2 - 160) + 20, (sw/2 + 120) + 20) then
		buttons.choosen = 6
	else 
		if state == "down" then 
			local posX, posY = getCursorPosition()
			edytor.sPos = {posX, posY}
			local x, y, z = getElementPosition(edytor.object)
			local rx, ry, rz = getElementRotation(edytor.object)
			edytor.tmpPos = {X = x, Y = y, Z = z, RX = rx, RY = ry, RZ = rz}
			edytor.mode = "startup"
		else
			edytor.sPos = {}
			edytor.mode = nil
		end
	end
end

function edytor_changeVector(button, press)
	if press then 
		if tonumber(button) then 
			button = tonumber(button)
			if button > 0 and button < 7 then 
				buttons.choosen = button
			end
		end
	end
end

function edytor_save()
	if (not edytor.state) then 
		outputChatBox("Nie edytujesz żadnego obiektu.",255,0,0)
		return
	end
	removeEventHandler("onClientRender", root, edytor_objectEdit)
	removeEventHandler("onClientClick", root, edytor_mouseLogic)
	removeEventHandler("onClientKey", root, edytor_changeVector)
	local _,bone,x,y,z,rx,ry,rz = exports['bone_attach']:getElementBoneAttachmentDetails(edytor.object)
	local model = getElementModel(edytor.object)
	exports['bone_attach']:detachElementFromBone(edytor.object)
	destroyElement(edytor.object)

	triggerServerEvent("addHatToPlayer", localPlayer, model, bone, x, y, z, rx, ry, rz)
	showCursor(false)
	edytor.state = false
	edytor.object = nil
	edytor.offset = {0,0,0}
	edytor.offsetRot = {0,0,90}


end

function eCancel()
	if (edytor.state) then 
		edytor.state = false
		destroyElement(edytor.object)
		edytor.object = nil
		edytor.offset = {0,0,0}
		edytor.offsetRot = {0,0,90}
		showCursor(false)
		removeEventHandler("onClientRender", root, edytor_objectEdit)
		removeEventHandler("onClientClick", root, edytor_mouseLogic)
		removeEventHandler("onClientKey", root, edytor_changeVector)
		outputChatBox("Anulowałeś edycję.",255,0,0)
	end
end
addCommandHandler("ecancel", eCancel)
addCommandHandler("esave", edytor_save)

addEvent("edytor_startup", true)
addEventHandler("edytor_startup", localPlayer, edytor_startup)