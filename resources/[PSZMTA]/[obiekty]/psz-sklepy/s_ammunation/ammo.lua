addEvent("onPlayerAcceptTrade",true)
addEventHandler("onPlayerAcceptTrade",root,function(koszt)
	local character = getElementData(source,"character")
	if (not character or not character.id) then
		outputDebugString("Zadanie onPlayerAcceptTrade dla niezalogowanego gracza.")
		return false
	end
	if (not getPlayerMoney(source) or getPlayerMoney(source)<koszt) then return false end
	takePlayerMoney(source,koszt)
	setPedArmor(source,100)
	outputChatBox("* Zakupiłeś kamizelkę kuloodporną, za 235$.",source)
	return true
end)

arm_pick = createPickup(309.38,-134.70,1000.3,3,1242,1,1)
setElementDimension(arm_pick,12)
setElementInterior(arm_pick,7)
