--[[

GUI: Dymki chatu nad glowami graczy

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
local selfVisible = false
local screenX, screenY = guiGetScreenSize()
local messages = {} -- {text, player, lastTick, alpha, yPos}
local timeVisible = 5500
local distanceVisible = 90
local bubble = false -- Rounded rectangle(true) or not(false)

function addBubble(text, player, tick)
    if (not messages[player]) then
        messages[player] = {}
    end
    table.insert(messages[player], {["text"] = text, ["player"] = player, ["tick"] = tick, ["endTime"] = tick + 2000, ["alpha"] = 0})
end

function removeBubble()
    table.remove(messages)
end

addEvent("onChatIncome", true)
addEventHandler("onChatIncome", root,
    function(message, messagetype)
        if source ~= localPlayer then
        addBubble(message, source, getTickCount())
        elseif selfVisible then
        addBubble(message, source, getTickCount())
    end
end
)

addEventHandler("onClientRender", root, 
    function()
        local tick = getTickCount()
        local x, y, z = getElementPosition(localPlayer)
        for _, pMessage in pairs(messages) do
            for i, v in ipairs(pMessage) do
                if isElement(v.player) then
                    if tick-v.tick < timeVisible then
                        local px, py, pz = getElementPosition(v.player)
                        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < distanceVisible and isLineOfSightClear ( x, y, z, px, py, pz, true, not isPedInVehicle(v.player), false, true) and getElementInterior(v.player) == getElementInterior(localPlayer) and getElementDimension(v.player) == getElementDimension(localPlayer) then
                            v.alpha = v.alpha < 200 and v.alpha + 5 or v.alpha
                            local bx, by, bz = getPedBonePosition(v.player, 6)
                            local sx, sy = getScreenFromWorldPosition(bx, by, bz)

                            local elapsedTime = tick - v.tick
                            local duration = v.endTime - v.tick
                            local progress = elapsedTime / duration

                            if sx and sy then
                                if not v.yPos then v.yPos = sy end
                                local width = dxGetTextWidth(v.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
                                local yPos = interpolateBetween ( v.yPos, 0, 0, sy - 22*i, 0, 0, progress, progress > 1 and "Linear" or "OutElastic")
                                if bubble then
                                    local i
                                    if width < 100 then
                                        i = 2
                                    elseif width > 100 and width < 400 then
                                        i = 1
                                    else
                                        i = 3
                                    end
                                    dxDrawImage ( sx-width/2-.01*screenX, yPos - .03*screenY, width+.02*screenX, 20, "images/bubble["..i.."].png", _, _, tocolor(255, 255, 255, v.alpha) )
                                else
                                    dxDrawRectangle(sx-width/2-.01*screenX, yPos - .03*screenY, width+.02*screenX, 20, tocolor(0,0,0, v.alpha+200))
                                end
                                dxDrawText(v.text, sx-width/2, yPos - .03*screenY, width, 20, tocolor( 255,255,255, v.alpha+50), 1, "default-bold", "left", "top", false, false, false, true)
                            end
                        end
                    else
                        table.remove(messages[v.player], i)
                    end
                else
                    table.remove(messages[v.player], i)
                end
            end
        end
    end
)