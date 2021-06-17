albumyMuzyczne={
    [1]={ -- WAYF
        "audio/tuesday.mp3",
        "audio/feel.mp3",
        "audio/riva.mp3",
        "audio/higher.mp3",
    },
    [2]={
        "audio/pomidorowa.ogg",
        "audio/hektar.mp3",
        "audio/podloga.mp3",
    },
    [3]={
        "swieta/all_i_want_for_christmas.mp3",
        "swieta/ulepimy_dzis_balwana.mp3",
        "swieta/mr_christmas_rmx.mp3",
        "swieta/inst_jbells.mp3",
    },
}

local modeleBezRadia={
    -- misc
    [594]=true, -- rc cam
    -- trailers
    [606]=true,
    [607]=true,
    [610]=true,
    [611]=true,
    [584]=true,
    [608]=true,
    [435]=true,
    [450]=true,
    [591]=true,
    --  recreational
    [539]=true,	-- vortex
    [471]=true,	-- quad
    [557]=true,	-- monster
    [444]=true,
    [556]=true,	-- j.w.
    [571]=true,	-- kart
    [530]=true, --widlak na tartaku
    -- rc
    [441]=true,
    [464]=true,
    [501]=true,
    [465]=true,
    [564]=true,
    -- trains
    [449]=true,
    [537]=true,
    [538]=true,
    [570]=true,
    [569]=true,
    [590]=true,
    -- heavy and utility
    [524]=true,
    [532]=true,
    [486]=true,
    [406]=true,
    [455]=true,
    [403]=true,
    [514]=true,
    [515]=true,
    [531]=true,
    -- bikes
    [581]=true,
    [510]=true,
    [522]=true,
    [509]=true,
    [481]=true,
    [462]=true,
    [521]=true,
    [463]=true,
    [586]=true,
    [468]=true,
    [461]=true,
    -- samoloty
    [592]=true,
    [577]=true,
    [511]=true,
    [548]=true,
    [512]=true,
    [593]=true,
    [425]=true,
    [520]=true,
    [417]=true,
    [487]=true,
    [553]=true,
    [488]=true,
    [497]=true,
    [563]=true,
    [476]=true,
    [447]=true,
    [519]=true,
    [460]=true,
    [469]=true,
    [513]=true
}   


function pojazdMaRadio(veh)
    local model=getElementModel(veh)
    if modeleBezRadia[model] then return false end
    return true
end