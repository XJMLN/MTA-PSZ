local pickup = createPickup(299.57,120.95,13.84,2,38,2500,0)
    setElementDimension(pickup,21)
    setElementInterior(pickup,52)
    setPickupType(pickup, 3,362 )
local shape = createColSphere(299.57,120.95,13.84,1)
    setElementDimension(shape,21)
    setElementInterior(shape,52)

function ztp_mg(el, md)
    if getElementType(el) ~= "player" then return end
    if (not md) then return end
    local lvl = getElementData(el,"level") or 0
    if (lvl and tonumber(lvl)<=0) then return end
    giveWeapon(el,38,500,true)
    exports['psz-admin']:adminView_add("ZTP-MG> gracz "..getPlayerName(el)..", giveWeapon: "..getWeaponNameFromID(38)..", 500 ammo",2)
end

addEventHandler("onColShapeHit", shape, ztp_mg)