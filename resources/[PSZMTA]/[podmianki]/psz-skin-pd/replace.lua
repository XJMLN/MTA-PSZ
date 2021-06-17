addEventHandler("onClientResourceStart",resourceRoot,
    function ()


	SKIN_ID=280
    txd = engineLoadTXD ( "lapd1.txd" )
    engineImportTXD ( txd, SKIN_ID )
    dff = engineLoadDFF ( "lapd1.dff", SKIN_ID )
    engineReplaceModel ( dff, SKIN_ID )

	SKIN_ID=281
    txd = engineLoadTXD ( "sfpd1.txd" )
    engineImportTXD ( txd, SKIN_ID )
    dff = engineLoadDFF ( "sfpd1.dff", SKIN_ID )
    engineReplaceModel ( dff, SKIN_ID )

	SKIN_ID=282
    txd = engineLoadTXD ( "csher.txd" )
    engineImportTXD ( txd, SKIN_ID )
    dff = engineLoadDFF ( "csher.dff", SKIN_ID )
    engineReplaceModel ( dff, SKIN_ID )
end)