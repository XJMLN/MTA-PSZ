addEvent("hol_clientEnter",true)
addEventHandler("hol_clientEnter",root,function(i)
	if i>0 then 
		exports['psz-core']:changeNicknameColor(client,{244,164,96})
	else
		exports['psz-core']:changeNicknameColor(client)
	end
end)