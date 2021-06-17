txd = engineLoadTXD("windsor.txd")
engineImportTXD(txd, 506)
dff = engineLoadDFF("windsor.dff", 506)
engineReplaceModel(dff, 506)
