addEventHandler("onPlayerDamage", getRootElement(),
    function ( attacker, weapon, bodypart, loss )
        if ( bodypart == 9 ) then 
            killPed ( source, attacker, weapon, bodypart )
        end
    end
)