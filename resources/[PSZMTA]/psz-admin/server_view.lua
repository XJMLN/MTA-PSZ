local text_display=textCreateDisplay()
local gameView= textCreateTextItem ( "", 0.01, 0.5, "medium", 255,255,255,255,1,"left","top",255)
local reportView=textCreateTextItem( "", 0.99, 0.79, "low", 255,255,255,255,1,"right","top",255)
--textitem textCreateTextItem ( string text, float x, float y, [string priority, int red = 255, int green = 0, int blue = 0, int alpha = 255, float scale = 1, string alignX = "left", string alignY = "top", int shadowAlpha = 0] )

textDisplayAddText ( text_display, gameView )
textDisplayAddText ( text_display, reportView )

local gameView_contents={ "INFO zasób psz-admin zresetowany" }
local reportView_contents={}

local time = getRealTime()

local tn=string.format("%04d%02d%02d%02d%02d%02d-%02d.txt", time.year+1900, time.month+1, time.monthday, time.hour, time.minute, time.second, math.random(1,99))

local fh=fileCreate("logi/"..tn)
local ah=fileCreate("logi/a-"..tn)
--fileClose(fh)

function outputLog(text,tryb)
    if (text and fh and ah) then
        if (tonumber(tryb)==1 or not tryb) then
            local time = getRealTime()
            local ts=string.format("%04d%02d%02d%02d%02d%02d> ", time.year+1900, time.month+1, time.monthday, time.hour, time.minute, time.second)
            fileWrite(fh, ts..text.."\n")
            fileFlush(fh)
        elseif(tonumber(tryb)==2) then
            local time = getRealTime()
            local ts=string.format("%04d%02d%02d%02d%02d%02d> ", time.year+1900, time.month+1, time.monthday, time.hour, time.minute, time.second)
            fileWrite(ah, ts..text.."\n")
            fileFlush(ah)
        end
    end
end

outputLog("Logowanie rozpoczęte",1)
outputLog("Logowanie rozpoczęte",2)

for i,v in ipairs(getElementsByType("player")) do
    local accName = getAccountName ( getPlayerAccount ( v ) )
    if accName and (isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderator" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) or isObjectInACLGroup ("user."..accName, aclGetGroup ( "ROOT" ) ) ) then
        textDisplayAddObserver ( text_display, v )
    end
end


function refresh_td()
    local tresc=table.concat(gameView_contents,"\n")
    textItemSetText ( gameView, tresc )
    local tt={}
    for i,v in ipairs(reportView_contents) do
        if (v[1]) then
            table.insert(tt,v[1])
        end
    end
    tresc=table.concat(tt,"\n")
    textItemSetText ( reportView, tresc )
end


function gameView_add(text)
    outputLog(text,1)
    table.insert(gameView_contents,text)
    if (#gameView_contents>10) then
        table.remove(gameView_contents,1)
    end
    refresh_td()
end

function adminView_add(text)
    outputLog(text,2)
end

function reportView_remove(id)
    local del = 0
    for i=#reportView_contents,1,-1 do 
        if (reportView_contents[i][2] and reportView_contents[i][2]==id) then
            table.remove(reportView_contents,i)
            del = del + 1
        end
    end
    if (del and tonumber(del)>0) then return true else return false end
end

function reportView_add(text,id)
    if (string.len(text)>0) then
        outputLog("RAPORT " .. text,1)
        outputLog("RAPORT " .. text,2)
    end
    table.insert(reportView_contents,{text,id})
    if (#reportView_contents>10) then
        table.remove(reportView_contents,1)
    end
    refresh_td()
end

addEventHandler("onPlayerQuit", root, function()
        local id=getElementData(source,"id")
        if (id and tonumber(id)) then
            reportView_remove(tonumber(id))
        end
    end)

addEventHandler("onPlayerLogin", root,  function()
    local accName = getAccountName ( getPlayerAccount ( source ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderator" ) ) then
        textDisplayAddObserver ( text_display, source )
        gameView_add("### " .. accName .. " zalogował/a się.",1)
        adminView_add("### ".. accName .. " zalogował/a się.",2)
        setElementData(source,"level",1)
    elseif accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) then
        textDisplayAddObserver ( text_display, source )
        gameView_add("### ".. accName .. " zalogował/a się.",1)
        adminView_add("### ".. accName .." zalogował/a się.",2)
        setElementData(source,"level",2)
    elseif accName and isObjectInACLGroup ("user."..accName, aclGetGroup("ROOT")) then
        textDisplayAddObserver (text_display, source)
        --gameView_add("### ".. accName .. " zalogował/a się.",1)
        adminView_add("### ".. accName .. " zalogował/a się.",2)
        setElementData(source,"level",3)
    end
end)

addEventHandler("onPlayerLogout", root,  function(acc)
        accName=getAccountName( acc )
        if (textDisplayIsObserver(text_display, source)) then
            textDisplayRemoveObserver ( text_display, source )
            if (getElementData(source,"level")~=3) then
                gameView_add("### " .. accName .. " wylogował/a się.",1)
            end
            adminView_add("### ".. accName .. " wylogował/a się.",2)
            removeElementData(source,"level")
        end
    end)

addCommandHandler("ucho", function(plr,cmd)
  if (textDisplayIsObserver(text_display, plr)) then
	  textDisplayRemoveObserver ( text_display, plr )
  else
	  textDisplayAddObserver ( text_display, plr )
  end
end,true,false)
refresh_td()
