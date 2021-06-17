--[[
@author Lukasz Biegaj <wielebny@bestplay.pl>
@copyright 2011-2013 Lukasz Biegaj <wielebny@bestplay.pl>
@license Dual GPLv2/MIT
]]--
playerData = {}
serverData = {}

serverData.cenzurowane_slowa = {
    "[kK][uU]+[rR][wW]",
    "[pP][iI][zZ][dD]",
    "[pP][iI][eE][rR][dD][oO][lL]",
    "[sS][pP][iI][eE][rR][dD][aA][lL][aA][jJ]",
    "[sS][uU][kK][iI][nN]",
    "[jJ][eE][bB]",
    "[cC][iI][pP][oO]",
    "[hH][uU][jJ][uU]",
    "[hH][uU][jJ]",
    "[cC][iI][pP]+[aA]",
    "[cC][iI][pP][kK][aA]",
    "[dD][zZ][iI][wW][kK][aA]",
    "[sS][uU][kK][aA]",
    "[sS][zZ][mM][aA][tT][aA]",
    "[jJ][eE][bB][aA][cC]+[ćĆ]",
    "[cC][iI][oO][tT][aA]",
    "[cC][wW][eE][lL]",
    "[fF][uU][cC][kK]",
    "[:͊͌͌͋͋͊͊͊̏̏̏̏̏̏̏̏̏̏̏̏̏͌̏̏̏̏̏̏̏͏͌͌͌͋͋͋͊͊͊͊̏̏̏:͊͌͌͋͋͊͊͊̏]",
    "[╭∩╮][(][ ͡° ͜][ʖ][ ͡°][)][╭∩╮]",
    "[╭∩╮( ͡° ͜ʖ ͡°)╭∩╮]",
}
function removeHEXFromString(str)
    return str:gsub("#%x%x%x%x%x%x","")
end
function string.trim(s)
    return s:match('^()%s*$') and '' or s:match('^%s*(.*%S)')
end
function RGBToHex(red, green, blue, alpha)
    if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
        return nil
    end
    if(alpha) then
        return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
    else
        return string.format("#%.2X%.2X%.2X", red,green,blue)
    end
end

function cenzurujSlowo(slowo)
    return string.gsub(slowo,"(.).*(.)","%1***%2")
end

function cenzurujZdanie(zdanie)
    local cnt=0
    for _,slowo in ipairs(serverData.cenzurowane_slowa) do
        zdanie,lcnt=string.gsub(zdanie,slowo,cenzurujSlowo)
        if lcnt and lcnt>0 then cnt=cnt+lcnt end
    end
    return zdanie,cnt
end
local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local lastPhoto

addEvent("onPlayerTakePhoto", true)
addEventHandler("onPlayerTakePhoto", resourceRoot, function(pixels,who,pdesc)
    lastPhoto=pixels
    local uid = getElementData(who,"auth:uid") or 0 
    exports['psz-admin']:adminView_add("CNN> Gracz "..getPlayerName(who).."/"..uid..", dodaje zdjęcie, opis: "..string.trim(pdesc),2)
	triggerLatentClientEvent("updatePhoto", 50000, resourceRoot, lastPhoto)
end)


local tvroot=createElement("tvroot")

addEvent("requestLastPhoto", true)
addEventHandler("requestLastPhoto", resourceRoot, function()
  if lastPhoto then
    triggerLatentClientEvent(client, "updatePhoto", 50000, resourceRoot, lastPhoto)
  end
end)

addEvent("cnn_Cenzuruj",true)
addEventHandler("cnn_Cenzuruj", resourceRoot, function(msg)
    local msg = removeHEXFromString(cenzurujZdanie(tostring(msg)))
    triggerClientEvent(client,"cnn_sendPhoto",client, msg)    
end)