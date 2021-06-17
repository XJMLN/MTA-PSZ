--[[

GUI: nicki graczy nad glowami

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local sw,sh=guiGetScreenSize()


local nametagFont = dxCreateFont( "font/klavik.otf", 10 )
if not nametagFont then nametagFont = "default-bold" end
local fontHeight=dxGetFontHeight(1, nametagFont)
local nametagScale = 1.0
local nametagAlpha = 180
local nametagColor =
{
	r = 255,
	g = 255,
	b = 255
} 




addEventHandler("onClientRender", getRootElement(), 
	function()
		local rootx, rooty, rootz = getCameraMatrix()--getElementPosition(getLocalPlayer())

		for i, vehicle in ipairs(getElementsByType("vehicle",root,true)) do
			local opis = getElementData(vehicle,"opis")
			if (opis) then 
			local x,y,z = getElementPosition(vehicle)
			local sx, sy = getScreenFromWorldPosition(x,y,z,200)
			if sx then 
					local distance = getDistanceBetweenPoints3D(rootx,rooty,rootz,x,y,z)
					if (distance <= 30 and isLineOfSightClear(x,y,z,rootx,rooty,rootz,true,false,false,false,true)) then 
						dxDrawText(opis, sx-(sw/5), sy, sx+(sw/5),sy, tocolor(255,255,255,255), 1.0, "default-small", "center", "center", false, true,false,true)
					end
				end
			end
		end
		for i, player in ipairs(getElementsByType("player",root,true)) do
			if player ~= localPlayer and getElementDimension(localPlayer)==getElementDimension(player) and getElementInterior(localPlayer)==getElementInterior(player) and getElementAlpha(player)>0 and getElementData(player,"id") then
				local x,y,z = getPedBonePosition(player,8)
				local sx, sy = getScreenFromWorldPosition(x, y, z+0.5)
				if sx then
                    local nickname = getPlayerName(player)
                    local c1,c2,c3=getPlayerNametagColor(player)
                    local c = getElementData(player,"character")
                    local ev = getElementData(player,"attraction:data")
                    local team = {}
                    local name = nickname.." #FFFFFF("..getElementData(player,"id")..")"
                    local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
                    local fX = sx
                    local fY = sy
                    local alpha = 200
                    local health = getElementHealth(player)
                    local lineLength = 56*(health/100)
                    local armor = getPedArmor(player)
                    local lineLength2 = 56*(armor/100)
                    if(distance <= 50 and isLineOfSightClear(x,y,z,rootx,rooty,rootz,true,false,false,false,true) ) then
                        dxDrawText(name, fX+1, fY+1, fX+1, fY+1, tocolor(0, 0, 0, alpha), nametagScale, nametagFont, "center", "center",false,false,false,true)
                        dxDrawText(name, fX, fY, fX, fY, tocolor(c1,c2,c3, alpha), nametagScale, nametagFont, "center", "center", false, false, false, true)
                        -- Pasek HP/Armor
                        dxDrawRectangle(fX-30,fY+15,60,10,tocolor(0,0,0,170))
                        dxDrawRectangle(fX-28,fY+17,lineLength,6,tocolor(255-math.floor(255*(health/100)),math.floor(255*(health/100)),0,200))
                        dxDrawRectangle(fX-28,fY+17,lineLength2,6,tocolor(180,180,180,200))
                        if (c and c.gg_nazwa and not ev) then
                            dxDrawText(c.gg_nazwa, fX, fY-fontHeight*2, fX, fY-fontHeight*2, -1, 0.7, nametagFont, "center", "center", false, false, false, true)
                        end
                        if (ev and ev.type == "TDM" and ev.in_game==true) then 
                        	if ev.team == 1 then team.name = "czerwonych" team.color = tocolor(255,0,0,255) elseif ev.team == 2 then team.name = "niebieskich" team.color = tocolor(0,0,255,255) end
                        	dxDrawText("Drużyna "..team.name, fX, fY-fontHeight*2, fX, fY-fontHeight*2, team.color, 1, nametagFont, "center", "center", false, false, false, true)
                        end
                    end
                end
            end
		for i, ped in ipairs(getElementsByType("ped",root,true)) do
			if getElementData(ped, "npc") and getElementData(ped, "name") and getElementDimension(localPlayer)==getElementDimension(ped) and getElementInterior(localPlayer)==getElementInterior(ped) then
				local x,y,z = getElementPosition(ped)
				local sx, sy = getScreenFromWorldPosition(x, y, z + 1)
				if sx then
					local namePed = getElementData(ped, "name")
					local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
					local fX = sx
					local fY = sy
					local alpha = 120
					if(distance <= 50 and isLineOfSightClear(x,y,z,rootx,rooty,rootz,true,false,false,false,true) ) then
                        dxDrawText(namePed, fX+1, fY+1, fX+1, fY+1, tocolor(0, 0, 0, alpha), nametagScale, nametagFont, "center", "center",false,false,false,true)
                        dxDrawText(namePed, fX, fY, fX, fY, tocolor(255,255,255, alpha), nametagScale, nametagFont, "center", "center", false, false, false, true)
                    end
				end
			end
		end	
    end--)---
end)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), 
	function()
		for k, v in ipairs(getElementsByType("player")) do
			setPlayerNametagShowing ( v, false )
		end
	end
)

addEventHandler("onClientPlayerJoin", root, 
	function()
		setPlayerNametagShowing ( source, false )
	end
)