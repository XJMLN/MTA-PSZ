txd = engineLoadTXD("washing.txd")
engineImportTXD(txd, 479)
dff = engineLoadDFF("washing.dff", 479)
engineReplaceModel(dff, 479)
