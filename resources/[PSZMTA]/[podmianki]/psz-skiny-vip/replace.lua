skiny={120,191,79,80,81,82,83,85,121,307,22}

local function replaceSkin(i)
    txd = engineLoadTXD ( i..".txd" )
    engineImportTXD ( txd, i)
    dff = engineLoadDFF ( i..".dff", i )
    engineReplaceModel ( dff, i )

end


for i,v in ipairs(skiny) do
	replaceSkin(v)
end
