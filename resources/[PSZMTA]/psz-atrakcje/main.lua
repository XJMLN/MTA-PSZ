--[[

Atrakcje - zrzuty,

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-atrakcje
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function main_giveReward(player,type)
	if (type) then
		if(type == 'hp') then
			setPedStat(player,24,1000)
			setElementHealth(player,200)
			setPedArmor(player,100)
		elseif(type == 'vip') then
			if (getElementData(player,'vip')) then
				outputChatBox("Posiadasz już konto vip, otrzymujesz jedynie 250$ oraz 10 granatów.",player)
				givePlayerMoney(player,250)
				giveWeapon(player,16,10,true)
			else
			outputChatBox("Otrzymujesz konto VIP do wyjścia z serwera.",player)
			setElementData(player,'vip',true)
			end
		elseif(type == 'ammo') then
			giveWeapon(player,16,50,true)
		elseif(type == 'godveh') then
			local v = createVehicle(601,2740.80,-2008,13.74)
			setVehiclePlateText(v,"GOD")
			setElementData(v,"veh:god",true)
			setVehicleLocked(v,true)
			warpPedIntoVehicle(player,v,0)
		elseif(type == 'cash') then
			local s = math.random(500,1500)
			outputChatBox("W tajemniczej skrzynce znajduje się $"..s..".",player)
			givePlayerMoney(player,s)
		end
	end
end

--triggerServerEvent ("zrzut_checkEnable", root)

addEvent("zrzut_checkEnable",true)
addEventHandler("zrzut_checkEnable",root, function()
	if (zrzut_active) then
		local txt = zrzut_return_text
		triggerClientEvent(root,"zrzut_enabled",root, txt)
		else return end
end)