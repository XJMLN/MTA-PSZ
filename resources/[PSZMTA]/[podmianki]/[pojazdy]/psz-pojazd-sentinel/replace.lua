txd = engineLoadTXD("premier.txd")
engineImportTXD(txd, 405)
dff = engineLoadDFF("premier.dff", 405)
engineReplaceModel(dff, 405)
