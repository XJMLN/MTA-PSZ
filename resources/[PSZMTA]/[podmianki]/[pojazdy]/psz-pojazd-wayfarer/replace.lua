txd = engineLoadTXD("wayfarer.txd")
engineImportTXD(txd, 586)
dff = engineLoadDFF("wayfarer.dff", 586)
engineReplaceModel(dff, 586)
