addCommandHandler("xxdraw",function()
    local level = getElementData(localPlayer,"level")
        if not level or level and level~=3 then
            outputChatBox(" ╭∩╮( ͡° ͜ʖ ͡°)╭∩╮")
            return
        end
	local show = not exports.drawtag:isDrawingWindowVisible()
	exports.drawtag:showDrawingWindow(show)
end)

