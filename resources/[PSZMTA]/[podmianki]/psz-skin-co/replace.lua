skiny={11,14,18,20,21,23,24,26,32,40,44,46,50,51,52,53,54,59,98,100,104,105,108,123,246,254,285,288,25,30,56,55,36,35}

local function replaceSkin(i)
    txd = engineLoadTXD ( i..".txd" )
    engineImportTXD ( txd, i)
    dff = engineLoadDFF ( i..".dff", i )
    engineReplaceModel ( dff, i )

end


for i,v in ipairs(skiny) do
	replaceSkin(v)
end
