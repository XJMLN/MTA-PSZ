v=429
txd = engineLoadTXD("banshee.txd")
engineImportTXD(txd, v)
dff = engineLoadDFF("banshee.dff", v)
engineReplaceModel(dff, v)