addEventHandler('onClientPlayerJoin', getRootElement(),function()
        if (#getElementsByType("player")>50) then return end
        local t=string.format("Na serwer wchodzi %s.", string.gsub(getPlayerName(source),"#%x%x%x%x%x%x",""))
        outputChatBox( "» "..t, 255,100,100)
    end)
addEventHandler('onClientPlayerQuit', root,function(reason)
        if (#getElementsByType("player")>50) then return end
       -- if getElementData(source,"dbid") then
            outputChatBox( "× " .. string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","") .. " opuścił/a serwer.", 255,100,100)
       -- end
    end)