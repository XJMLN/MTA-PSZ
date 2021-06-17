addCommandHandler("xzzdoQuakezzx", function(plr,cmd)
    local accName = getAccountName(getPlayerAccount(plr))
    if accName and (isObjectInACLGroup("user."..accName,aclGetGroup("ROOT"))) then
    triggerClientEvent("odtworzDzwiek", root, "trzesienie")
    adminView_add("Quake> "..getPlayerName(plr),2)
    local cel=root
    for i=1,75 do
        setTimer(triggerClientEvent, i*666, 1, cel, "doQuake", root, (i>15 and math.random(5,15) or i)/10)
    end
end
end, false,false)

function cmd_cenypojazdow(plr)
    if (getElementData(plr,"level")==3) then
    local vehicleIDS = { 496, 517, 401, 410, 421, 518, 600, 527, 436, 419, 439, 533, 549, 526, 491, 474, 445, 426, 507, 547, 585,
        405, 587, 409, 466, 492, 566, 540, 551, 421, 529, 592, 553, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
        417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 
        438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
        423, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 543, 482, 478, 554, 418, 582, 413, 440, 536, 575, 
        567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 501, 465, 568, 557, 471, 495, 539, 483, 508, 500, 
        444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 506, 565, 451, 558, 555, 477, 579, 400, 404, 489, 479, 442,
        606, 607, 610, 590, 569, 611, 584, 608, 435, 591} -- , 594 }
    local text="Model\tNazwa\tCena"
    for i,v in ipairs(vehicleIDS) do
        local text2=tostring(v).."\t"..getVehicleNameFromModel(v).."\t"..(getModelHandling(v).monetary*3.5).."$"
        outputConsole(text2)
        text=text..text2.."\n"
    end
end
end
addCommandHandler("cenypojazdow", cmd_cenypojazdow, false, false)

addCommandHandler("restartveh", function(plr,cmd)
    i2=0
    for i,v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v,"vehicle:event") then
            destroyElement(v)
            i2=i2+1
        end
    end
    adminView_add("restartveh> "..getPlayerName(plr)..", usuniecie: "..i2,2)
    outputChatBox("Usunięto "..i2.." pojazdów eventowych.",plr)
    outputDebugString("Usunięto "..i2.." pojazdów eventowych.")
end)
    
function cmd_aa(plr,command, ...)
	local txt = table.concat( arg, " " )

	for i,v in ipairs(getElementsByType("player")) do
		local accName = getAccountName ( getPlayerAccount ( v ) )
		if accName and ( isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ) )) then
            local anick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
			outputChatBox("AA> "..anick.. ":#FFFFFF " .. txt, v,155,0,0,true)
		end
	end
end

addCommandHandler("aa", cmd_aa, true,false)

function cmd_a(plr,command, ...)
    local txt = table.concat( arg, " " )
    local anick
    for i,v in ipairs(getElementsByType("player")) do
        local accName = getAccountName ( getPlayerAccount ( v ) )
        if accName and (isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) )) then
		anick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
            outputChatBox("A> "..anick.. ":#FFFFFF " .. txt, v,255,0,0,true)
            
        end
    end
    adminView_add("CHAT-A> "..anick..": ".. txt,2)
end

addCommandHandler("a", cmd_a, true,false)

function cmd_s(plr,command, ...)
    local txt = table.concat( arg, " " )
    local anick
    for i,v in ipairs(getElementsByType("player")) do
        local accName = getAccountName ( getPlayerAccount ( v ) )
        if accName and (isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ))  or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderator" ) ) ) then
				anick = string.gsub(getPlayerName(plr),"#%x%x%x%x%x%x","")
			outputChatBox("M> "..anick.. ":#FFFFFF " .. txt, v,0,204,0,true)
            
        end
    end
    adminView_add("CHAT-M> "..anick..": ".. txt,2)
end


addCommandHandler("s", cmd_s, true,false)



function cmd_int(plr,command, nbr )
    if (not nbr) then
        outputChatBox("Uzyj: /int <id>", plr)
        return
    end
    local int = exports["psz-core"]:getInterior(tonumber(nbr))
    if (not int) then
        outputChatBox("Nie odnaleziono interioru o podanym ID", plr)
        return
    end

    local c
    c=tonumber(int.id)
    if (int.opis and type(int.opis)=="string") then
        c=c.. " - " .. int.opis
    end
    outputChatBox(c, plr)

    c= string.format("[%d] X,Y,Z,A: %.2f, %.2f, %.2f, %.2f", int.id, int.entrance[1], int.entrance[2], int.entrance[3], int.entrance[4])
    outputChatBox(c,plr)
    adminView_add("INT> "..getPlayerName(plr)..", "..c,2)
    c=""
    if (not int.entrance or not int.entrance[4] or tonumber(int.entrance[4])==0) then c=c .. "brak wejscia" end
    if (not int.exit) then c=c .. " brak wyjscia " end
    if (not int.opis or type(int.opis)~="string") then	c=c .. " brak opisu "	end
    if (string.len(c)>0) then outputChatBox(c,plr,255,0,0) end

    setElementData(plr,"lastInt", int.id, false)

    setElementInterior(plr, int.interior, int.entrance[1], int.entrance[2], int.entrance[3])
    setElementPosition(plr, int.entrance[1], int.entrance[2], int.entrance[3])
    setElementRotation(plr,  0,0,int.entrance[4])
    
    if (int.dimension) then setElementDimension(plr, int.dimension) end
end

addCommandHandler("int",cmd_int, true,false)

addCommandHandler("r", function(plr,cmd,...)
        local txt = table.concat( arg, " " )
        if (isModerator(plr)) then
            outputChatBox(">> "..txt, getRootElement(),0,255,0)
            adminView_add("R> "..getPlayerName(plr)..": "..txt,2)
        else
            outputChatBox(">> "..txt, getRootElement(),255,0,0)
            adminView_add("R> "..getPlayerName(plr)..": "..txt,2)
        end
    end,true,false)

function cmd_tpto ( player, command, ... )
    if (#arg<3) then
        outputChatBox("uzyj /tpto <X> <Y> <Z> [interior] [vw]", player)
        return
    end
    if (arg[4]) then
        setElementInterior(player, tonumber(arg[4]))
    end
    if (arg[5]) then
        setElementDimension(player, tonumber(arg[5]))
    end
    c = string.format("<%d>,<%d>,<%d>,<%d>,<%d>",tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]) or 0,tonumber(arg[5]) or 0)
    adminView_add("TPTO> "..getPlayerName(player).." : "..c,2)
    c=""
    setElementPosition( player, tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]) )
end

addCommandHandler( "tpto", cmd_tpto,true,false )

function cmd_up (player, command, value)
    if (tonumber(value)==nil) then
        outputChatBox("Uzyj: /up <z>", player)
        return
    end

    local e=player

    if (isPedInVehicle(player)) then
        e=getPedOccupiedVehicle(player)
    end

    local x,y,z=getElementPosition(e)
    setElementPosition(e,x,y,z+tonumber(value))
    adminView_add("UP> "..getPlayerName(player).." value: "..tonumber(value)..", current Z:"..z+tonumber(value),2)
end

addCommandHandler( "up", cmd_up,true,false )
function cmd_thru (player, command, value)

    if (tonumber(value)==nil) then
        outputChatBox("Uzyj: /thru <ile>", player)
        return
    end

    local e=player
    if getCameraTarget(player)~=player then
        e=getCameraTarget(player)
    end


    if (isPedInVehicle(player)) then
        e=getPedOccupiedVehicle(e)
    end

    local x,y,z=getElementPosition(e)
    local _,_,rz=getElementRotation(e)

    local rrz=math.rad(rz)
    local x= x + (value * math.sin(-rrz))
    local y= y + (value * math.cos(-rrz))

    setElementPosition(e,x,y,z)
    adminView_add("UP> "..getPlayerName(player).." value: "..tonumber(value)..", current X: "..x + (value * math.sin(-rrz))..", current Y: "..y + (value * math.cos(-rrz)),2)
end

addCommandHandler( "thru", cmd_thru, true, false )

addCommandHandler("veh.fix", function(plr)
        local pojazd=getPedOccupiedVehicle(plr)
        if not pojazd then
            outputChatBox("Musisz być w pojeździe.", plr)
            return
        end
        setElementHealth(pojazd, 1000)
        fixVehicle(pojazd)
        adminView_add("VEH.FIX> "..getPlayerName(plr),2)
    end, true, false)

addCommandHandler("suszarka", function(plr,cmd)
    local accName = getAccountName ( getPlayerAccount ( plr ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderator" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ) ) then
        local stan = getElementData(plr,"admin:status")
        if (stan and stan.active) then 
            takeWeapon(plr,22)
            toggleControl(plr,"aim_weapon",true)
            toggleControl(plr,"fire",true)
            stan.active = false
            stan.weapon = nil
            setElementData(plr,"admin:status",stan)
            adminView_add("SUSZARKA-REMOVE> "..getPlayerName(plr),2)
        elseif((not stan) or (stan and not stan.active)) then 
            giveWeapon(plr,22,90001,true)
            toggleControl(plr,"aim_weapon",true)
            toggleControl(plr,"fire",false)
            setElementData(plr,"admin:status",{active=true, weapon='suszarka'})
            adminView_add("SUSZARKA-ADD> "..getPlayerName(plr),2)
        end
    end
end,true,false)
local function bannedVehicles(v)
    local banned = {520,476,447,425,432,564,464}
    for i,v2 in ipairs(banned) do
        if v2 == v then return true end
    end
    return false
end
addCommandHandler("p",function(plr, cmd, cel, ...)
    if (not cel) then 
        outputChatBox("Użyj: /p <nick/id> <id/nazwa pojazdu>",plr)
        return
    end
    local target = findPlayer(plr,cel)
    
    if (not target) then
        outputChatBox("Nie znaleziono gracza o podanym ID/nicku!",plr)
        return
    end
    
    if (isPedInVehicle(target)) then
        outputChatBox("Podany gracz jest w pojeździe.",plr,255,0,0)
        return
    end
    local lvl = getElementData(plr,"level") or 0
    if (lvl and lvl<2) then return end 

    local args = { ... }
    for i,v in ipairs(args) do
        vehID = tonumber(v)
        if not vehID then
            vehID = getVehicleModelFromName(v)
        end
        if (vehID and (vehID < 400 or vehID > 611)) then
            outputChatBox("Podano złe ID pojazdu.",plr,255,0,0)
            return 
        end
        
        if (bannedVehicles(vehID)) then 
            outputChatBox("Tego pojazdu nie możesz stworzyć.",plr,255,0,0)
            return
        end

        local x, y, z = getElementPosition(target)
        local int = getElementInterior(target)
        local vw = getElementDimension(target)
        local veh = createVehicle(vehID, x,y, z+2)
        if (not isElement(veh)) then return end
        setElementDimension(veh,vw)
        setElementInterior(veh,int)
        setVehiclePlateText(veh, "ADMSPAWN")
        setElementData(veh,"vehicle:event",true)
        setElementData(veh,"owner:by","ADM: "..getPlayerName(plr))
        warpPedIntoVehicle(target,veh)
        adminView_add("ADM-P> "..getPlayerName(plr)..", spawnuje pojazd: "..vehID..", dla gracza: "..getPlayerName(target),2)
            local n_target = string.gsub(getPlayerName(target),"#%x%x%x%x%x%x","")
        outputChatBox("Stworzyłeś pojazd o ID:"..tonumber(vehID)..", graczu "..n_target..".",plr,0,255,0)
    end
end, true, false)

addCommandHandler("xxninjaxx", function(plr, cmd)
    local level = getElementData(plr, "level")
    if (not level or level~=3) then return end
     if (getElementData(plr,"admin:ninja")) then 
        setElementData(plr,"admin:ninja", false)
        outputChatBox("Wchodzisz na duty.", plr)
    else
        setElementData(plr,"admin:ninja",true)
        outputChatBox("Schodzisz z duty.",plr)
    end
end)

function cmd_ttv(player,command,vid)
    if (not vid or not tonumber(vid)) then return end
    vid=tonumber(vid)
    for i,v in ipairs(getElementsByType("vehicle")) do
    local dbid=getElementData(v,"dbid")
    if (dbid and tonumber(dbid)==vid) then
        setElementAlpha(player,0)
        local x,y,z=getElementPosition(v)
        setElementPosition(player,x,y,z+4)
        setElementInterior(player, getElementInterior(v))
        setElementDimension(player, getElementDimension(v))

        return
    end
    end
    outputChatBox("Nie odnaleziono na mapie pojazdu o podanym ID.", player, 255,0,0)
    -- sprawdzmy czy nie jest w przechowalni
    local query=string.format("SELECT 1 FROM psz_vehicles WHERE id=%d AND przechowalnia>0",vid);
    local wynik=exports.DB:pobierzWyniki(query)
    if (wynik) then
        outputChatBox("Pojazd znajduje sie na parkingu/w przechowalni.", player)
    end
    return
end

addCommandHandler("ttv", cmd_ttv, true, false)

function cmd_thv(player,command,vid)
    if (not vid or not tonumber(vid)) then return end
    vid=tonumber(vid)
    for i,v in ipairs(getElementsByType("vehicle")) do
    local dbid=getElementData(v,"dbid")
    if (dbid and tonumber(dbid)==vid) then
        local x,y,z=getElementPosition(player)
        setElementPosition(v,x,y,z+4)
        setElementInterior(v, getElementInterior(player))
        setElementDimension(v, getElementDimension(player))
        warpPedIntoVehicle(player,v)
        return
    end
    end
    outputChatBox("Nie odnaleziono na mapie pojazdu o podanym ID.", player, 255,0,0)
    -- sprawdzmy czy nie jest w przechowalni
    local query=string.format("SELECT 1 FROM psz_vehicles WHERE id=%d AND przechowalnia>0",vid);
    local wynik=exports.DB:pobierzWyniki(query)
    if (wynik) then
        outputChatBox("Pojazd znajduje sie na parkingu/w przechowalni.", player)
    end
    return
end

addCommandHandler("thv", cmd_thv, true, false)

function cmd_vnapis(plr,cmd,...)
    local opis = table.concat(arg, " ")
    if (string.len(opis)<3) then 
        outputChatBox("Użyj: /vnapis <opis>, lub /vnapis usuń",plr)
        return
    end
    local veh = getPedOccupiedVehicle(plr)
    if (not veh) then
        outputChatBox("Musisz być w pojeździe którego napis chcesz zmienić.",plr,255,0,0)
        return
    end
    local dbid = getElementData(veh,"dbid")
    if (dbid and tonumber(dbid)>0) then
        outputChatBox("Nie możesz ustawić napis na ten pojazd.",plr,255,0,0)
        return
    end
    if (opis == "usuń" or opis == "USUŃ") then
        removeElementData(veh,"opis")
        adminView_add("VNAPIS USUŃ> Gracz "..getPlayerName(plr).." z pojazdu "..getVehicleNameFromModel(getElementModel(veh)),2)
    else
        setElementData(veh,"opis",opis)
        adminView_add("VNAPIS> "..getPlayerName(plr)..", ustawia napis: "..opis..", na pojazd "..getVehicleNameFromModel(getElementModel(veh)),2)
    end
end
addCommandHandler("vnapis",cmd_vnapis,true,false)


-- Teleporty
addCommandHandler("tgrove",function(plr,cmd)
	setElementPosition(plr,2496.74,-1652.91,13.44)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
    adminView_add("TP_TGROVE> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("kosciol",function(plr,cmd)
	setElementPosition(plr,2294.91,-1500.83,25.30)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
    adminView_add("TP_KOSCIOL> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("kosciol2",function(plr,cmd)
	setElementPosition(plr,-1988.64,1115.42,54.47)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_KOSCIOL2> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlspd",function(plr,cmd)
	setElementPosition(plr,1539.86,-1675.44,13.55)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TLSPD> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlsammo",function(plr,cmd)
	setElementPosition(plr,1362.89,-1281.47,13.55)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TLSAMMO> "..getPlayerName(plr),2)
end,true,false)


addCommandHandler("tscena",function(plr,cmd)
	setElementPosition(plr,359.20,-1843.98,7.86)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TSCENA> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tport",function(plr,cmd)
	setElementPosition(plr,-211.67,-1766.22,1.82)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TPORT> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tchiliad",function(plr,cmd)
    setElementPosition(plr,-2306.41,-1692.93,482.51)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TCHILIAD> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tmishill",function(plr,cmd)
	setElementPosition(plr,-2392.20,-589.44,132.74)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TMISHILL> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tbbfd",function(plr,cmd)
	setElementPosition(plr,-33.98,-276.05,5.42)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TBBFD> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("twm1",function(plr,cmd)
    setElementPosition(plr,2640.07,1203.94,11.12)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TWM1> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tspawnlp",function(plr,cmd)
	setElementPosition(plr,-264.82,2590.35,63.57)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TSPAWNLP> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tspawnsf",function(plr,cmd)
    setElementPosition(plr,-2072.43,1420.04,9.02)
    setElementDimension(plr,0)
    setElementInterior(plr,0)
    adminView_add("TP_TSPAWNSF> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlvpd",function(plr,cmd)
    setElementPosition(plr,2283.68,2423.94,10.82)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TLVPD> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlsmd",function(plr,cmd)
	setElementPosition(plr,1179.96,-1329.91,14.17)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_LSMD> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tspawnlv",function(plr,cmd)
	setElementPosition(plr,1659.59,1302.12,10.99)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TSPAWNLV> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("twyspasf",function(plr,cmd)
	setElementPosition(plr,-3368.99,1953.90,1.79)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TWYSPASF> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tosiedle1",function(plr,cmd)
	setElementPosition(plr,2188.42,-344.36,57.25)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TOSIEDLE1> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tkartsf",function(plr,cmd)
	setElementPosition(plr,-2036.36,-86.45,35.52)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TKARTSF> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tkopalnia",function(plr,cmd)
    setElementPosition(plr,-569.45,-1487.49,10.71)
    setElementDimension(plr,0)
    setElementInterior(plr,0)
        adminView_add("TP_TKOPALNIA> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tztp",function(plr,cmd)
    setElementPosition(plr,2496.77,-1701.60,175.23)
    setElementDimension(plr,86)
    setElementInterior(plr,4)
        adminView_add("TP_TZTP> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tkosciol3",function(plr,cmd)
        setElementPosition(plr,2489.97,923.02,11.02)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_TKOSCIOL3> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlsair",function(plr,cmd)
        setElementPosition(plr,2094.63,-2633.50,13.63)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_TLSAIR> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tpszn",function(plr,cmd)
        setElementPosition(plr,1357.03,746.54,10.82)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_TPSZN> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tlvair2",function(plr,cmd)
        setElementPosition(plr,403.20,2531.91,16.55)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_TLVAIR2> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("thof",function(plr,cmd)
        setElementPosition(plr,-1517.34,919.80,7.19)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_THOF> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("twyspals",function(plr,cmd)
	setElementPosition(plr,3542.15,-1349.57,15.68)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TWYSPALS> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tgaraze",function(plr,cmd)
	setElementPosition(plr,3053.46,-846.44,12.56)
	setElementDimension(plr,0)
	setElementInterior(plr,0)
        adminView_add("TP_TGARAZE> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("taox",function(plr,cmd)
        setElementPosition(plr,1447.68,1478.90,11.07)
        setElementDimension(plr,2430)
        setElementInterior(plr,0)
        adminView_add("TP_TAOX> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tev",function(plr,cmd)
        setElementPosition(plr,0,0,5)
        setElementDimension(plr,2430)
        setElementInterior(plr,0)
        adminView_add("TP_TEV> "..getPlayerName(plr),2)
end,true,false)

addCommandHandler("tadd",function(plr,cmd)
        setElementPosition(plr,3062.90,56.14,66.83)
        setElementDimension(plr,121)
        setElementInterior(plr,12)
        adminView_add("TP_TADD> "..getPlayerName(plr),2) 
end,true,false)

addCommandHandler('tzlot',function(plr,cmd)
        setElementPosition(plr,1481.01,-1678.72,13.36)
        setElementDimension(plr,0)
        setElementInterior(plr,0)
        adminView_add("TP_TZLOT> "..getPlayerName(plr),2)
end,true,false)