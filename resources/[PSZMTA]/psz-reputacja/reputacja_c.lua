--[[

reputacja: Zdobywanie respektu, zagubieni turysci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-reputacja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local MAX_SHOWTIME = 15000
local sw, sh = guiGetScreenSize()

local rp_display =  false
local rp_render_tables = {}

function rp_infoRender()
	rp_display = false
	for i=#rp_render_tables, 1,-1 do
		local v = rp_render_tables[i]
		local text 
		if (v.type) == "up" then
			text = "Uzyskałeś punkt reputacji, aktualnie posiadasz: "..v.count.."."
		elseif (v.type) == "down" then 
			text = "Straciłeś punkt reputacji, aktualnie posiadasz: "..v.count.."."
		end
		local tX = (sw/2)-(dxGetTextWidth(text, 2)/2)
		local tY = (sw/2)-200 

		dxDrawText(text, tX + 1, tY, tX + 1, tY, tocolor(0,0,0,255), 2)
		dxDrawText(text, tX - 1, tY, tX - 1, tY, tocolor(0,0,0,255), 2)
		dxDrawText(text, tX, tY + 1, tX, tY + 1, tocolor(0,0,0,255), 2)
		dxDrawText(text, tX, tY - 1, tX, tY - 1, tocolor(0,0,0,255), 2)
		dxDrawText(text, tX, tY, tX, tY, tocolor(255,255,255,255), 2)

		if getTickCount()-v.ts>MAX_SHOWTIME then 
			table.remove(rp_render_tables,i)
		else
			rp_display = true
		end
	end
	if not rp_display then 
		removeEventHandler("onClientRender", root, rp_infoRender)
	end
end

addEvent("rp_showInfo", true)
addEventHandler("rp_showInfo", root, function(title, descr, descr2, type)

	table.insert(rp_render_tables,{name=title, descr=descr, count=descr2, type = type, ts=getTickCount()})
	playSound("a/tada"..math.random(1,2)..".ogg")
	if not rp_display then 
		addEventHandler("onClientRender", root, rp_infoRender)
	end
end)