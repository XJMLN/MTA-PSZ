--[[

Glowne zasoby - umiejetnosci

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

-- Spray ability
function sprayFinish(plr)
    if (not plr or not isElement(plr)) then return end -- zdarza sie gdy tag jest wczytany wprost z bazy danych
    if (not getElementData(plr,"character")) then return end
    
    local x,y,z = getElementPosition(plr)
    local cs = createColSphere(x,y,z,30)
        setElementInterior(cs, getElementInterior(plr))
        setElementDimension(cs, getElementDimension(plr))
    
    local nearbyPlayers=getElementsWithinColShape(cs,"player")
        destroyElement(cs)
    for i,v in ipairs(nearbyPlayers) do
        if (v~=plr and getElementDimension(v)==getElementDimension(plr) and getElementData(v,"sstudio:god")) then
            local c = getElementData(v,"character")
            if c then
                if not c.ab_spray then c.ab_spray=0 end
                if (math.random(1,2)==1 and tonumber(c.ab_spray)<100) then
                    c.ab_spray=tonumber(c.ab_spray)+1

                    setElementData(v,"character",c)
                    outputChatBox("Twoja umiejętność w malowaniu sprayem wzrosła: "..c.ab_spray .."/100.",v)
                    if (c.ab_spray==50) then
                        outputChatBox("Potrafisz już malować graffiti na ścianach.",v)
                    end
                end
            end
        end
    end
end

function abilities_bmxSkills(count, who)
    if (not who or not isElement(who)) then return end
    if (not getElementData(who,"character")) then return end
    local c = getElementData(who, "character")
    if c then 
        if not c.s_bmx then c.s_bmx = 0 end
        if (tonumber(c.s_bmx)<100) then 
            c.s_bmx = tonumber(c.s_bmx)+1
            setElementData(who,"character",c)
            setPedStat(who, 229, tonumber(c.s_bmx)*10)
            setPedStat(who, 230, tonumber(c.s_bmx)*10)
        end
    end
end
--triggerEvent("abilities:bmxSkillAdd",root, bmxS.s_bmx, v)
addEvent("abilities:bmxSkillAdd",true)
addEventHandler("abilities:bmxSkillAdd", root, abilities_bmxSkills)
addEventHandler("drawtag:onTagFinishSpray", root, sprayFinish)
addEventHandler("drawtag:onTagFinishErase", root, sprayFinish)