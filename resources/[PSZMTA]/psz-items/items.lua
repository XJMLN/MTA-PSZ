--[[

psz-items: zapis, wczytywanie itemow 

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-items
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

function items_loadItemsForPlayer(player_id)
	if (not player_id or tonumber(player_id)<0) then return end
	local q = string.format("SELECT item_uid, item_name, item_id, item_type,item_subtype,  item_owner, item_usage, item_model FROM psz_items WHERE item_owner=%d ",tonumber(player_id))
	local items = exports['psz-mysql']:pobierzTabeleWynikow(q)
	if (items) then
		local EQ = {} 
		for i, v in ipairs(items) do
			table.insert(EQ, {uid=v.item_uid, name=v.item_name, id=v.item_id, type=v.item_type, subtype=v.item_subtype, owner=v.item_owner, in_use=v.item_usage, model=v.item_model})
		end
		return EQ
	end
end
--{uid=v.item_uid, name=v.item_name, id=v.item_id, type=v.item_type, owner=v.item_owner, in_use=v.item_usage}
function items_usageCancel(item)
	if (not item ) then return end
	local q = string.format("SELECT item_name, item_id, item_type, item_owner, item_usage FROM psz_items WHERE item_uid=%d", tonumber(item.uid))
	local _item = exports['psz-mysql']:pobierzWyniki(q)
	local pid = getElementData(source, "auth:uid") or 0
	if (_item and tonumber(_item.item_usage)>0 and tonumber(_item.item_owner) == tonumber(pid)) then 
		local q = string.format("UPDATE psz_items SET item_usage=0 WHERE item_uid=%d LIMIT 1",tonumber(item.uid))
		exports['psz-mysql']:zapytanie(q)
		outputChatBox("Zdejmujesz "..tostring(_item.item_name)..".",source,255,0,0)
	else return false
	end
end

function items_checkItemsInUsage(item)
	if (not item) then return end
	local pid = getElementData(source, "auth:uid") or 0
	local q
		q = string.format("SELECT item_name, item_uid,item_model FROM psz_items WHERE item_subtype=%d AND item_usage=1 AND item_owner=%d", tonumber(item.subtype), tonumber(pid))
		local wyniki = exports['psz-mysql']:pobierzTabeleWynikow(q)

		if (wyniki) then

			for i, v in ipairs(wyniki) do
				exports['psz-mysql']:zapytanie(string.format("UPDATE psz_items SET item_usage=0 WHERE item_uid=%d",tonumber(v.item_uid)))
			end

		end

		exports['psz-mysql']:zapytanie(string.format("UPDATE psz_items SET item_usage=1 WHERE item_uid=%d",item.uid))
		triggerClientEvent(source,"edytor_startup",source,true,tonumber(item.model))

end

function items_showForPlayer(plr)
	local pid = getElementData(plr, "auth:uid") or 0
	if (pid and pid<0) then return end
	local EQ = items_loadItemsForPlayer(pid)
	triggerClientEvent(plr,"showItemsForPlayer",plr,EQ)
end
addCommandHandler("przedmioty", items_showForPlayer)

addEvent("item_cancelUsage",true)
addEventHandler("item_cancelUsage", root, items_usageCancel)
addEvent("isItemInUsage",true)
addEventHandler("isItemInUsage", root, items_checkItemsInUsage)