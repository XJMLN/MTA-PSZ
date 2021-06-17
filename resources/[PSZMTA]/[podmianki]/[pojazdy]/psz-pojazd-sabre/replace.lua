txd = engineLoadTXD("infernus.txd")
engineImportTXD(txd, 475)
dff = engineLoadDFF("infernus.dff", 475)
engineReplaceModel(dff, 475)