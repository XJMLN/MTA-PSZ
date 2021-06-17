--[[
@author Lukasz Biegaj <wielebny@bestplay.pl>
]]--
-- Compatibility: Lua-5.1
function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function stripColors(text)
    local cnt=1
    while (cnt>0) do
        text,cnt=string.gsub(text,"#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]","")
    end
    return text
end

function shuffle(t)
    local n = #t
    while n >= 2 do
        -- n is now the last pertinent index
        local k = math.random(n) -- 1 <= k <= n
        -- Quick swap
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
    return t
end

function translit(tekst)
    tekst=string.gsub(tekst,"ą","a")
    tekst=string.gsub(tekst,"ć","c")
    tekst=string.gsub(tekst,"ę","e")
    tekst=string.gsub(tekst,"ł","l")
    tekst=string.gsub(tekst,"ń","n")
    tekst=string.gsub(tekst,"ó","o")
    tekst=string.gsub(tekst,"ś","s")
    tekst=string.gsub(tekst,"ź","z")
    tekst=string.gsub(tekst,"ż","z")
    tekst=string.gsub(tekst,"Ą","A")
    tekst=string.gsub(tekst,"Ć","C")
    tekst=string.gsub(tekst,"Ę","E")
    tekst=string.gsub(tekst,"Ł","L")
    tekst=string.gsub(tekst,"Ń","N")
    tekst=string.gsub(tekst,"Ó","O")
    tekst=string.gsub(tekst,"Ś","S")
    tekst=string.gsub(tekst,"Ź","Z")
    tekst=string.gsub(tekst,"Ż","Z")
    return tekst
end
function strLetters(t)
    return string.match(t,"[Ą-Ź]")
end

function replaceIlleagalCharacters(t) -- ugly
    --t = string.gsub(t,'"', "") --"'","''",
    t = string.gsub(t,"'", "''") 
    return t 
end

function isRoot(plr)
    local accName = getAccountName(getPlayerAccount(plr))
    if accName and isObjectInACLGroup("user."..accName, aclGetGroup("ROOT")) and (not getElementData(plr,"admin:ninja")) then
        return true
    end
    return false
end

function isAdmin(plr)
    local accName = getAccountName ( getPlayerAccount ( plr ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) then
        return true
    end
    return false
end

function isInvisibleAdmin(plr)
    local accName = getAccountName ( getPlayerAccount ( plr ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) and not isObjectInACLGroup ("user."..accName, aclGetGroup ( "Administrator" ) ) then
        return true
    end
    return false
end

function isSupport(plr)
    local accName = getAccountName ( getPlayerAccount ( plr ) )
    if accName and isObjectInACLGroup ("user."..accName, aclGetGroup ( "Moderator" ) ) then
        return true
    end
    return false
end


-- modifiers: v - verbose (all subtables), n - normal, s - silent (no output), dx - up to depth x, u - unnamed
function var_dump(...)
    -- default options
    local verbose = false
    local firstLevel = true
    local outputDirectly = true
    local noNames = false
    local indentation = "\t\t\t\t\t\t"
    local depth = nil

    local name = nil
    local output = {}
    for k,v in ipairs(arg) do
        -- check for modifiers
        if type(v) == "string" and k < #arg and v:sub(1,1) == "-" then
            local modifiers = v:sub(2)
            if modifiers:find("v") ~= nil then
                verbose = true
            end
            if modifiers:find("s") ~= nil then
                outputDirectly = false
            end
            if modifiers:find("n") ~= nil then
                verbose = false
            end
            if modifiers:find("u") ~= nil then
                noNames = true
            end
            local s,e = modifiers:find("d%d+")
            if s ~= nil then
                depth = tonumber(string.sub(modifiers,s+1,e))
            end
        -- set name if appropriate
        elseif type(v) == "string" and k < #arg and name == nil and not noNames then
            name = v
        else
            if name ~= nil then
                name = ""..name..": "
            else
                name = ""
            end

            local o = ""
            if type(v) == "string" then
                table.insert(output,name..type(v).."("..v:len()..") \""..v.."\"")
            elseif type(v) == "userdata" then
                local elementType = "no valid MTA element"
                if isElement(v) then
                    elementType = getElementType(v)
                end
                table.insert(output,name..type(v).."("..elementType..") \""..tostring(v).."\"")
            elseif type(v) == "table" then
                local count = 0
                for key,value in pairs(v) do
                    count = count + 1
                end
                table.insert(output,name..type(v).."("..count..") \""..tostring(v).."\"")
                if verbose and count > 0 and (depth == nil or depth > 0) then
                    table.insert(output,"\t{")
                    for key,value in pairs(v) do
                        -- calls itself, so be careful when you change anything
                        local newModifiers = "-s"
                        if depth == nil then
                            newModifiers = "-sv"
                        elseif  depth > 1 then
                            local newDepth = depth - 1
                            newModifiers = "-svd"..newDepth
                        end
                        local keyString, keyTable = var_dump(newModifiers,key)
                        local valueString, valueTable = var_dump(newModifiers,value)
                        
                        if #keyTable == 1 and #valueTable == 1 then
                            table.insert(output,indentation.."["..keyString.."]\t=>\t"..valueString)
                        elseif #keyTable == 1 then
                            table.insert(output,indentation.."["..keyString.."]\t=>")
                            for k,v in ipairs(valueTable) do
                                table.insert(output,indentation..v)
                            end
                        elseif #valueTable == 1 then
                            for k,v in ipairs(keyTable) do
                                if k == 1 then
                                    table.insert(output,indentation.."["..v)
                                elseif k == #keyTable then
                                    table.insert(output,indentation..v.."]")
                                else
                                    table.insert(output,indentation..v)
                                end
                            end
                            table.insert(output,indentation.."\t=>\t"..valueString)
                        else
                            for k,v in ipairs(keyTable) do
                                if k == 1 then
                                    table.insert(output,indentation.."["..v)
                                elseif k == #keyTable then
                                    table.insert(output,indentation..v.."]")
                                else
                                    table.insert(output,indentation..v)
                                end
                            end
                            for k,v in ipairs(valueTable) do
                                if k == 1 then
                                    table.insert(output,indentation.." => "..v)
                                else
                                    table.insert(output,indentation..v)
                                end
                            end
                        end
                    end
                    table.insert(output,"\t}")
                end
            else
                table.insert(output,name..type(v).." \""..tostring(v).."\"")
            end
            name = nil
        end
    end
    local string = ""
    for k,v in ipairs(output) do
        if outputDirectly then
            outputConsole(v)
        end
        string = string..v
    end
    return string, output
end
