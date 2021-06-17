--[[

GUI: Zapis opcji graficznych

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-gui
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
                                                                            
addEvent("zapiszOpcje", true)
addEventHandler("zapiszOpcje", resourceRoot, function(plr, uo_sb, uo_sw, uo_cp, uo_det, uo_sc)
  local uid=getElementData(plr, "player:uid")
  if (not uid) then return end

  uo_sb=uo_sb and 1 or 0
  uo_sw=uo_sw and 1 or 0
  uo_cp=uo_cp and 1 or 0
  uo_det=uo_det and 1 or 0
  uo_sc=uo_sc and 1 or 0
  local query=string.format("UPDATE psz_postacie SET uo_sb=%d,uo_sw=%d,uo_cp=%d,uo_det=%d,uo_sc=%d WHERE id=%d", uo_sb, uo_sw, uo_cp, uo_det, uo_sc, uid)
  exports.DB:zapytanie(query)
 -- outputChatBox("▪ Wybrane ustawienia graficzne zostały zapisane!" ,plr)
end)