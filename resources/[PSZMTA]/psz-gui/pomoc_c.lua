--[[

GUI:    okienko pomocy 

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local x,y = guiGetScreenSize()
local window = guiCreateWindow((x-850)/2, (y-550)/2, 850, 550, "Panel pomocy", false )
local textBox = guiCreateMemo( 246, 30, 594, 510, "", false, window )
local gList = guiCreateGridList( 10, 30, 230, 510, false, window )
guiGridListSetSelectionMode(gList,2)
guiMemoSetReadOnly(textBox, true)
guiGridListAddColumn(gList,"Działy",0.9)
guiSetVisible(window,false)
showCursor(false)

local F2wndShowing = false
bindKey('f9','down',
function()
	if F2wndShowing == true then
	    guiSetVisible(window, false)
        showCursor(false)
        guiSetInputEnabled( false )
        F2wndShowing = false
    else
        guiSetVisible(window, true)
        showCursor(true)
        guiSetInputEnabled( true )
        F2wndShowing = true
    end
end)

local Text = { }
for i,val in ipairs(dzialy) do
    local rowID = guiGridListAddRow(gList)
    if val[2] == 0 then
    	guiGridListSetItemText(gList, rowID, 1, val[1], true, true)
    	guiGridListSetItemColor( gList, rowID, 1, 100, 100, 100 )
    else
    	guiGridListSetItemText(gList, rowID, 1, val[1], false, true)
    	Text[rowID] = dzialy[rowID+1][3]
    end
end
guiSetText(textBox,Text[1])

addEventHandler('onClientGUIClick',root,
function()
	local row,col = guiGridListGetSelectedItem ( gList )
	if Text[row] then
    	guiSetText(textBox,Text[row])
    end
end)
