--[[

mandaty - splata mandatow

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-mandaty
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
function calculateCost()
    local character = getElementData(source,"character")
    if (not character) then
        outputChatBox("Tylko zalogowani gracze mogą spłacać mandaty.",source,255,0,0)
        return
    end
    local level = character.wanted
    if level == 0 then
        koszt = 0
    elseif level == 1 then
        koszt = 10
    elseif level == 2 then
        koszt = 25
    elseif level == 3 then
        koszt = 50
    elseif level == 4 then
        koszt = 75
    elseif level == 5 then
        koszt = 100
    elseif level == 6 then
        koszt = 200
    end
    triggerClientEvent(source,"onServerReturnCostFotoCash",resourceRoot,koszt)
end

addEvent("onPlayerRequestPayFotoCash", true)
addEventHandler("onPlayerRequestPayFotoCash", root,calculateCost)

function takeLevelWanted()
    local character = getElementData(source,"character")
    if (not character) then
        outputChatbox("Tylko zalogowani gracze mogą spłacać mandaty.",source,255,0,0)
        return
    end
    local level = character.wanted
    if level == 1 then
        takePlayerMoney(source,10)
        character.wanted = 0
    elseif level == 2 then
        takePlayerMoney(source,25)
        character.wanted = 0
    elseif level == 3 then
        takePlayerMoney(source,50)
        character.wanted = 0
    elseif level == 4 then
        takePlayerMoney(source,75)
        character.wanted = 0
    elseif level == 5 then
        takePlayerMoney(source,100)
        character.wanted = 0
    elseif level == 6 then
        takePlayerMoney(source,200)
        character.wanted = 0
    end
    setElementData(source,"character",character)
    setPlayerWantedLevel(source,0)
    outputChatBox("* Spłacono mandaty, nie jesteś już poszukiwany.",source,255,0,0)
end

addEvent("onPlayerAcceptPay", true)
addEventHandler("onPlayerAcceptPay", root,takeLevelWanted)
