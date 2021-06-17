--[[

solo: zapraszanie, przyjmowanie zaproszen, wybor broni

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-solo
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

local sw, sh = guiGetScreenSize()
solo_wnd_visible = false
solo_with = nil
local solo = {}

BRONIE_TABLE = {23,24,25,26,27,28,29,32,30,31,33,34}

solo_wnd = guiCreateWindow(0.7437,0.5687,0.2281,0.3500,"Zaproszenie na pojedynek",true)
solo_btn2 = guiCreateButton(0.1096, 0.4400, 0.7877, 0.2233, "Akceptuj", true, solo_wnd) -- 0.2233+0.2689 = 0.4322
solo_btn = guiCreateButton(0.1096,0.6893, 0.7877, 0.2233, "Anuluj", true, solo_wnd)
solo_lbl = guiCreateLabel(0.1096, 0.2233, 0.7877, 0.2689, "XJMLN zaprasza Ciebie na pojedynek.",true, solo_wnd)
guiSetVisible(solo_wnd,false)
guiLabelSetHorizontalAlign(solo_lbl, "center", true)

solo_weapon_wnd = guiCreateWindow(0.25, 0.17, 0.52, 0.54, "Wybór broni", true)
solo_weapon_lbl = guiCreateLabel(0.03, 0.08, 0.95, 0.05, "Wybierz broń do pojedynku (Kliknij 2 razy aby akceptować)", true, solo_weapon_wnd)
solo_weapon_grid = guiCreateGridList(0.03, 0.20, 0.95, 0.77, true, solo_weapon_wnd)
    solo_weapon_name = guiGridListAddColumn(solo_weapon_grid,"Nazwa broni",0.4)
    solo_weapon_winratio = guiGridListAddColumn(solo_weapon_grid, "Ilość wygranych pojedynków bronią", 0.5)
guiSetVisible(solo_weapon_wnd, false)
guiLabelSetHorizontalAlign(solo_weapon_lbl, "center", false)
guiLabelSetVerticalAlign(solo_weapon_lbl, "center")


function solo_show(plr)
    solo_wnd_visible = true
    solo_with = plr
    guiSetVisible(solo_wnd,true)
    guiSetText(solo_lbl,string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","").." zaprasza Ciebie na pojedynek.")
    showCursor(true)
end

function solo_hide()
    solo_wnd_visible = false
    solo_with = nil
    guiSetVisible(solo_wnd,false)
    showCursor(false)
end

function solo_allow()
    if not solo_wnd_visible then return end -- nie powinno sie wydarzyc
    --if solo_with == localPlayer then outputChatBox("Nie możesz zaprosić samego siebie na pojedynek!") return end -- nie powinno sie wydarzyc  [dev]
    triggerServerEvent("solo_sendResponse", localPlayer, true, solo_with) -- w tym wypadku solo_with zwraca plr (s-side)
    solo_hide()
end

function solo_deny()
    if not solo_wnd_visible then return end
    triggerServerEvent("solo_sendResponse", localPlayer, false, solo_with)
    solo_hide()
end


--[[
    {
                        [number "1"]    =>
                        table(2) "table: 6D2158C8"
                            {
                                                [string(9) "wygranych"] =>  number "3"
                                                [string(7) "weapon1"]   =>  number "16"
                            }
                        [number "2"]    =>
                        table(2) "table: 6D215670"
                            {
                                                [string(9) "wygranych"] =>  number "2"
                                                [string(7) "weapon1"]   =>  number "23"
                            }
                        [number "3"]    =>
                        table(2) "table: 6D215940"
                            {
                                                [string(9) "wygranych"] =>  number "1"
                                                [string(7) "weapon1"]   =>  number "28"
                            }
                        [number "4"]    =>
                        table(2) "table: 6D215698"
                            {
                                                [string(9) "wygranych"] =>  number "2"
                                                [string(7) "weapon1"]   =>  number "34"
                            }
]]
function solo_init_weapon(data)
    if (not data) then outputDebugString('brak data') return end
    guiSetVisible(solo_weapon_wnd,true)
    showCursor(true)
    guiGridListClear(solo_weapon_grid)
    local temp_table = {}
    for i,v in ipairs(BRONIE_TABLE) do
        table.insert(temp_table,{weapon = v, wygranych = 0})
        for _,v2 in pairs(data) do
            if v == v2.weapon1 then 
                table.remove(temp_table,i)
                table.insert(temp_table, {weapon = v, wygranych = v2.wygranych})
            end
        end
    end
    for i,v in ipairs(temp_table) do
        local row = guiGridListAddRow (solo_weapon_grid)
        guiGridListSetItemText(solo_weapon_grid, row, solo_weapon_name, getWeaponNameFromID(tonumber(v.weapon)),false,false)
        guiGridListSetItemData(solo_weapon_grid, row, solo_weapon_name, tonumber(v.weapon))
            guiGridListSetItemText(solo_weapon_grid, row, solo_weapon_winratio, v.wygranych, false, false)
    end
    temp_table = nil
end

function solo_grid_click()
    if (not guiGetEnabled(solo_weapon_wnd)) then return end
    selectedRow = guiGridListGetSelectedItem(solo_weapon_grid)
    if (selectedRow<0) then
    else
        local weapon = guiGridListGetItemData(solo_weapon_grid, selectedRow, solo_weapon_name)
        triggerServerEvent("solo_sendSelectedWeapon", localPlayer, weapon) -- jest git nie ma bata zeby zdazyl zaznaczyc dwie bronie 
        guiSetVisible(solo_weapon_wnd, false)
        showCursor(false)
    end
end


addEvent ("solo_startCountdown", true)
addEventHandler("solo_startCountdown", localPlayer,function()
        triggerEvent("doCountdown",source,5)
    end)
addEvent("solo_showRequestForPlayer",true)
addEventHandler("solo_showRequestForPlayer", localPlayer, solo_show)
addEvent("solo_showGridWeapon", true)
addEventHandler("solo_showGridWeapon", localPlayer, solo_init_weapon)
-- default events from mta 
addEventHandler("onClientGUIClick", solo_btn2, solo_allow, false)
addEventHandler("onClientGUIClick", solo_btn, solo_deny, false)
addEventHandler("onClientGUIClick", solo_weapon_grid, solo_grid_click, false)