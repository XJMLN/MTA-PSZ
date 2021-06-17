--[[
reputacja: Zdobywanie respektu, uczesczanie na msze

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-reputacja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

local church_interiors = {
    -- x, y, z, int, dim, size
    {378.47,2324.27,1889.57, int=10, vw=0, size= 15}, -- LS
    {1252.74,-999.97,1069.85, int=5, vw=10, size=30}, -- SF
    {256.97,-1800.30,1479.88, int=20, vw=99, size=100}, -- LV
}

--local TS_START = getTickCount()
local last_id = nil

for i,v in ipairs(church_interiors) do
    v.cs = createColSphere(v[1],v[2],v[3],v.size)
        setElementDimension(v.cs,v.vw)
        setElementInterior(v.cs,v.int)
        setElementData(v.cs,"church_col",true)
end


local function getPlayersInChurch(colshape)
    if ( not getElementData(colshape,"church_col")) then return end
    local wierni = getElementsWithinColShape(colshape, "player")
    local data = {}
    for i, gracz in ipairs(wierni) do
        local uid = getElementData(gracz,"auth:uid") or 0 
        if (uid and uid == 0) then return end

        if ((getElementDimension(gracz) == getElementDimension(colshape)) and getElementInterior(gracz) == getElementInterior(colshape)) then 
            table.insert(data,gracz)
        end
    end
    return data
end

function church_timer()
    local church = math.random(1,#church_interiors)
    if (last_id and last_id == church) then church_timer() end
    last_id = church
    local gracze = getPlayersInChurch(church_interiors[church].cs)
    if (gracze and #gracze == 0 ) then return end
        
    local time = getRealTime()

    for i,v in ipairs(gracze) do
        local uid = getElementData(v,"auth:uid") or 0 
        local c = getElementData(v,"character")
        local DATE = string.format("%04d-%02d-%02d",time.year+1900, time.month+1, time.monthday)
        if (uid and uid<1) then return end
        if (c and c.church_visit) then 
            if (tostring(DATE) == c.church_visit) then return end
            c.church_visit = tostring(DATE)
            local gr = getElementData(v,"good_reputation")
            
            setElementData(v,"character",c)

            setElementData(v,"good_reputation",tonumber(gr)+1)
            local count = (getElementData(v,"bad_reputation"))+(getElementData(v,"good_reputation"))

            triggerClientEvent(v, "rp_showInfo", root, "Punkty reputacji zwiększone!", "Aktualna ilość reputacji:", count, 'up')

        end
    end

    outputDebugString('Następuje rozdanie reputacji w kościele o ID: '..church..'.')
end

setTimer(church_timer,300000,0)