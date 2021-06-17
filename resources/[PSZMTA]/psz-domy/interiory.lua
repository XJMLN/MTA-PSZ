interiory={}


local dane=exports["psz-mysql"]:pobierzTabeleWynikow("SELECT id,interior,entrance,`exit` FROM psz_interiory WHERE `exit` IS NOT NULL AND active=1")
for _,v in ipairs(dane) do
    local ii = tonumber(v.id)
    v.entrance=split(v.entrance,",")	-- miejsce w ktorym pojawi sie gracz
    v.exit=split(v.exit,",")			-- wyjscie

    v.id=nil
    interiory[ii]=v
end

-- triggerServerEvent("moveMeTo", resourceRoot, a_dom.interior_loc[1], a_dom.interior_loc[2], a_dom.interior_loc[3], a_dom.interior, a_dom.dimension)

addEvent("moveMeTo", true)
addEventHandler("moveMeTo", resourceRoot, function(x,y,z,i,d)
        setElementDimension(client, d)
        setElementInterior(client,i,x,y,z)

        setElementPosition(client,x,y,z)
        setElementInterior(client,i)
        --setElementFrozen(client, true)
        triggerClientEvent(client,"moveMeObject", client,x,y,z,i,d) -- anty spadanie przy nie wczytanych obiektach
        --	outputChatBox(string.format("Przenoszenie do %d %d %d, %d %d", x,y,z,i,d), client)
    end)