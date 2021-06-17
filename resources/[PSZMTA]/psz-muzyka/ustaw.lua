local tt=getTickCount()
function menuUstaw()
    if getTickCount()-tt<2000 then
        outputChatBox("Musisz chwile odczekac.", 255,0,0)
        return
    end
    tt=getTickCount()

    local veh=getPedOccupiedVehicle(localPlayer)
    if not veh then
        outputChatBox("(( Płyty możesz użyc w pojezdzie. ))")
        return
    end
    album=tonumber(getElementData(veh,"audio:id"))
    if not album or not albumyMuzyczne[album] then outputDebugString('nope') return false end
    if not pojazdMaRadio(veh) then
        outputChatBox("(( Ten pojazd nie posiada odtwarzacza płyt. ))")
        return
    end
    if getVehicleOccupant(veh,0)~=localPlayer then -- and getVehicleOccupant(veh,1)~=localPlayer then
        outputChatBox("(( Musisz siedzieć z przodu aby włożyć płytę do odtwarzacza. ))")
        return
    end
    setRadioChannel(0)
    local aktualnaPlyta=getElementData(veh,"audio:cd")
    outputChatBox("Radio zostało włączone")
    setElementData(veh, "audio:cd", {album,1})
end
addCommandHandler("wlaczRadio",menuUstaw,false,true)

function menuNext()
    local veh=getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local aktualnaPlyta=getElementData(veh,"audio:cd")
    if aktualnaPlyta and type(aktualnaPlyta)=="table" then
        local album,utwor=aktualnaPlyta[1], aktualnaPlyta[2]
        if (albumyMuzyczne[album]) then
            outputChatBox("Zmieniono utwór.")
            setRadioChannel(0)
            if albumyMuzyczne[album][utwor+1] then
                setElementData(veh,"audio:cd", {album, utwor+1})
                return
            else
                setElementData(veh,"audio:cd", {album, 1})
                return
            end
        end
    end
end
addCommandHandler("nextRadio",menuNext,false,true)

function menu_cdEject()
    local veh=getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local aktualnaPlyta=getElementData(veh,"audio:cd")
    if aktualnaPlyta and type(aktualnaPlyta)=="table" then
        setRadioChannel(math.random(1,11))
        outputChatBox("wyłaczono audio.")
        setElementData(veh,"audio:cd", false)
    end
end
addCommandHandler('wylaczRadio',menu_cdEject,false,true)
local function destroyAttachedAudio(veh)
    local ae=getAttachedElements(veh)
    for i,v in ipairs(ae) do
        if v and getElementType(v)=="sound" then
            destroyElement(v)
        end
    end
end

local function attachSoundToVehicle(vehicle)
    destroyAttachedAudio(vehicle)
    local caudio=getElementData(vehicle,"audio:cd")
    if not caudio or type(caudio)~="table" or not caudio[1] then return end
    if not albumyMuzyczne[tonumber(caudio[1])] then return end
    local snd=playSound3D("http://s15038.rbx2.fastd.svpj.pl/psz-muzyka/"..albumyMuzyczne[tonumber(caudio[1])][tonumber(caudio[2])], 0,0, -100, true)
    setSoundVolume(snd,1)
    attachElements(snd, vehicle)
    setElementParent(snd,vehicle)
end

local vehResource=getResourceFromName("freeroam")
addEventHandler("onClientElementDataChange", getResourceRootElement(vehResource), function(dataName, oldValue)
        if dataName~="audio:cd" then return end
        if getElementType(source)~="vehicle" then return end
        attachSoundToVehicle(source)
    end, true)

addEventHandler("onClientResourceStart", resourceRoot, function()
        for i,v in ipairs(getElementsByType("vehicle", getResourceRootElement(vehResource))) do
            local caudio=getElementData(v,"audio:cd")
            if caudio and type(caudio)=="table" and caudio[1] then
                attachSoundToVehicle(v)
            end
        end
    end)

addEventHandler("onClientVehicleExplode",getRootElement(), function()
    if not getElementData(source,"audio:cd") and getElementModel(source)~= 482 then return end
        destroyAttachedAudio(source)
end)