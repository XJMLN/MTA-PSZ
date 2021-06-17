addEventHandler("onClientResourceStart",resourceRoot,
    function ()

        SKIN_ID=277
        txd = engineLoadTXD ( "277.txd" )
        engineImportTXD ( txd, SKIN_ID )
        dff = engineLoadDFF ( "277.dff", SKIN_ID )
        engineReplaceModel ( dff, SKIN_ID )


    end)