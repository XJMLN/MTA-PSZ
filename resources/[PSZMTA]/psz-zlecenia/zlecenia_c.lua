--[[for i,v in ipairs(cele) do
    v.obiekt = createObject(2942,v[1],v[2],v[3],v[4],v[5],v[6])
    setElementInterior(v.obiekt,v[7] or 0)
    setElementDimension(v.obiekt,v[8] or 0)
end

]]--
-- pasek na dole ekranu

local sw,sh = guiGetScreenSize() 
local ph=math.floor(sh/20)

local rodzaj="Informacje CNN News"
local informacja=""
local informacja_ts=nil

local limit_czasu=30000

function render_cn()
    if (getPlayerName(localPlayer) ~="|PSZ|XJMLN") then return end
    --    if (not wzasiegu) then return end
    --if (informacja_ts and getTickCount()-informacja_ts<limit_czasu) then

        local alpha=1
       -- if (getTickCount()-informacja_ts>(limit_czasu-1000)) then
       --     alpha=(limit_czasu-(getTickCount()-informacja_ts))/1000
       -- end

        --if (rodzaj~="Wywiad" and getTickCount()-informacja_ts<1000) then
          --  alpha=(getTickCount()-informacja_ts)/1000
       -- end

        for i=0,5 do
            dxDrawRectangle(0, sh-ph+i, sw,ph-i, tocolor(0,0,0,(i+5)*5*alpha))
        end
        dxDrawText("KICK: ", 5, sh-ph, sw, sh,tocolor(255,255,255,200*alpha), 0.75, "default-bold", "left","center")
        local ox=dxGetTextWidth ( "Informacje CNN News", 1, "default-bold" )
        dxDrawText("Gracz XJMLN, został wyrzucony/a przez XJMLN. Powód: test", 5+15+ox, sh-ph, sw, sh, tocolor(255,255,255,255*alpha), 1, "default", "center", "center")
end

addEventHandler("onClientRender", root, render_cn)