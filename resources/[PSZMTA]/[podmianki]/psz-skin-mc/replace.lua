addEventHandler("onClientResourceStart",resourceRoot,
    function ()


        SKIN_ID=274
        txd = engineLoadTXD ( "lvemt1.txd" )
        engineImportTXD ( txd, SKIN_ID )
        dff = engineLoadDFF ( "lvemt1.dff", SKIN_ID )
        engineReplaceModel ( dff, SKIN_ID )

        SKIN_ID=275
        txd = engineLoadTXD ( "sfemt1.txd" )
        engineImportTXD ( txd, SKIN_ID )
        dff = engineLoadDFF ( "sfemt1.dff", SKIN_ID )
        engineReplaceModel ( dff, SKIN_ID )
        
        SKIN_ID=276
        txd = engineLoadTXD ( "wfyclot.txd" )
        engineImportTXD ( txd, SKIN_ID )
        dff = engineLoadDFF ( "wfyclot.dff", SKIN_ID )
        engineReplaceModel ( dff, SKIN_ID )


    end)