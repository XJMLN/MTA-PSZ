function itemEditor_deleteElement(plr)
	local itemEdit = getElementData(plr,"itemEditor")
	if (not itemEdit.active or not itemEdit.object) then return end

	exports['bone_attach']:detachElementFromBone(itemEdit.object)
	destroyElement(itemEdit.object)
	removeElementData(plr,"itemEditor")
	outputChatBox("Obiekt został usunięty!", plr,255,0,0)
end
addCommandHandler("edelete", itemEditor_deleteElement)