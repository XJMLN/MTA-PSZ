local resourceRoot = getResourceRootElement(getThisResource())

addEventHandler("onClientResourceStart",resourceRoot,
function ()
	-- AK47
    txd = engineLoadTXD ( "txd/ak47.txd" )
    engineImportTXD ( txd, 355 )
    dff = engineLoadDFF ( "txd/ak47.dff", 0 )
    engineReplaceModel ( dff, 355 )
    -- M4
    txd = engineLoadTXD ( "txd/m4.txd" )
    engineImportTXD ( txd, 356 )
    dff = engineLoadDFF ( "txd/m4.dff", 0 )
    engineReplaceModel ( dff, 356 )
    -- MP5
    txd = engineLoadTXD ( "txd/mp5lng.txd" )
    engineImportTXD ( txd, 353 )
    dff = engineLoadDFF ( "txd/mp5lng.dff", 0 )
    engineReplaceModel ( dff, 353 )
    -- Spaz-12
    txd = engineLoadTXD ( "txd/shotgspa.txd" )
    engineImportTXD ( txd, 351 )
    dff = engineLoadDFF ( "txd/shotgspa.dff", 0 )
    engineReplaceModel ( dff, 351 )
    -- Sniper
    txd = engineLoadTXD ( "txd/sniper.txd" )
    engineImportTXD ( txd, 358 )
    dff = engineLoadDFF ( "txd/sniper.dff", 0 )
    engineReplaceModel ( dff, 358 )
    -- Colt 45
    txd = engineLoadTXD ( "txd/colt45.txd" )
    engineImportTXD ( txd, 346 )
    dff = engineLoadDFF ( "txd/colt45.dff", 0 )
    engineReplaceModel ( dff, 346 )
    -- Micro Uzi
    txd = engineLoadTXD ( "txd/micro_uzi.txd" )
    engineImportTXD ( txd, 352 )
    dff = engineLoadDFF ( "txd/micro_uzi.dff", 0 )
    engineReplaceModel ( dff, 352 )
    -- Desert Eagle
    txd = engineLoadTXD ( "txd/desert_eagle.txd" )
    engineImportTXD ( txd, 348 )
    dff = engineLoadDFF ( "txd/desert_eagle.dff", 0 )
    engineReplaceModel ( dff, 348 )
    -- Shotgun
    txd = engineLoadTXD ( "txd/chromegun.txd" )
    engineImportTXD ( txd, 349 )
    dff = engineLoadDFF ( "txd/chromegun.dff", 0 )
    engineReplaceModel ( dff, 349 )
    -- Country Rifle
    txd = engineLoadTXD ( "txd/crifle.txd" )
    engineImportTXD ( txd, 357 )
    dff = engineLoadDFF ( "txd/crifle.dff", 0 )
    engineReplaceModel ( dff, 357 )
    -- Tec-9
    txd = engineLoadTXD ( "txd/tec9.txd" )
    engineImportTXD ( txd, 372 )
    dff = engineLoadDFF ( "txd/tec9.dff", 0 )
    engineReplaceModel ( dff, 372 )
    -- Sawn-Off Shotgun
    txd = engineLoadTXD ( "txd/sawnoff.txd" )
    engineImportTXD ( txd, 350 )
    dff = engineLoadDFF ( "txd/sawnoff.dff", 0 )
    engineReplaceModel ( dff, 350 )
    -- Silenced
    txd = engineLoadTXD ( "txd/silenced.txd" )
    engineImportTXD ( txd, 347 )
    dff = engineLoadDFF ( "txd/silenced.dff", 0 )
    engineReplaceModel ( dff, 347 )  
end)
