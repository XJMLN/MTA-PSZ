--[[

Atrakcje - zrzuty,

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-atrakcje
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
zrzut_text = nil
zrzut_enable = false
zrzut_show = false
local sw, sh = guiGetScreenSize ()

addEvent ("zrzut_enabled", true)
addEventHandler("zrzut_enabled",root, function(txt)
	if (zrzut_show == true) then return end
	zrzut_enable = true
	zrzut_show = true
	zrzut_text = txt
	addEventHandler ("onClientRender", root, drawOutlineText)
end)

addEvent ("zrzut_drawInfo", true)
addEventHandler("zrzut_drawInfo", root, function(txt)
	if (zrzut_show == true) then return end
	zrzut_text = txt
	zrzut_enable = true
	zrzut_show = true
	addEventHandler("onClientRender",root,drawOutlineText)
end)

addEvent ("zrzut_deleteInfo", true)
addEventHandler("zrzut_deleteInfo", root, function()
	if (zrzut_show == false) then return end
	removeEventHandler ("onClientRender", root, drawOutlineText)
	zrzut_enable = false
	zrzut_show = false
	zrzut_text = nil
end)

function drawOutlineText ()
	if not getElementData(localPlayer,"auth:uid") then return end
	dxDrawText ('Cenny ładunek został zrzucony, \n Lokalizacja: ' .. zrzut_text, sw*(605 - 1)/800, sh*(165 - 1)/600, sw*(790 - 1)/800, sh*(186 - 1)/600, tocolor (0, 0, 0, a), 1, "default-bold", "left", "top", false)
	dxDrawText ('Cenny ładunek został zrzucony, \n Lokalizacja: ' .. zrzut_text, sw*(605 + 1)/800, sh*(165 + 1)/600, sw*(790 + 1)/800, sh*(186 + 1)/600, tocolor (0, 0, 0, a), 1, "default-bold", "left", "top", false)
	dxDrawText ('Cenny ładunek został zrzucony, \n Lokalizacja: ' .. zrzut_text, sw*(605 - 1)/800, sh*(165 - 1)/600, sw*(790 - 1)/800, sh*(186 - 1)/600, tocolor (0, 0, 0, a), 1, "default-bold", "left", "top", false)
	dxDrawText ('Cenny ładunek został zrzucony, \n Lokalizacja: ' .. zrzut_text, sw*(605 + 1)/800, sh*(165 + 1)/600, sw*(790 + 1)/800, sh*(186 + 1)/600, tocolor (0, 0, 0, a), 1, "default-bold", "left", "top", false)
	dxDrawText ('Cenny ładunek został zrzucony, \n Lokalizacja: ' .. zrzut_text, sw*605/800, sh*165/600,sw*790/800, sh*186/600, tocolor (254, 254,254, 255), 1, "default-bold", "left", "top", false)
end

addEventHandler ("onClientResourceStart", resourceRoot, function ()
	triggerServerEvent ("zrzut_checkEnable", root)
end)