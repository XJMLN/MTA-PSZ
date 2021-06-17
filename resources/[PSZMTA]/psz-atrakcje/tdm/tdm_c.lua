--[[
atrakcje: zabawa w chowanego

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-reputacja
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.
]]--

function tdm_friendlyfire(attracker)
    if source and source~=attacker then 
    local attrS = getElementData(source,"attraction:data")
    local attrA = getElementData(attacker,"attraction:data")
    if ((attrS and attrA) and (attrS.type == "TDM" and attrA.type == "TDM") and (attrS.team == attrA.team)) then 
        cancelEvent()
    end
end