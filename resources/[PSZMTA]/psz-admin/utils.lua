--[[
@author Lukasz Biegaj <wielebny@bestplay.pl>
]]--




function findPlayer(plr,cel)
    local target=nil
    if (tonumber(cel) ~= nil) then
        target=getElementByID("p"..cel)
    else -- podano fragment nicku
        for _,thePlayer in ipairs(getElementsByType("player")) do
            if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 1, true) then
                if (target) then
                    outputChatBox("Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
                    return nil
                end
                target=thePlayer
            end
        end
    end
    return target
end