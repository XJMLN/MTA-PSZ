--[[

triggerEvent("getDataHandling",plr,target)
]]--

addEvent("getDataHandling",true)
addEventHandler("getDataHandling",root,function(target)
        outputDebugString(getPlayerName(target))
end)