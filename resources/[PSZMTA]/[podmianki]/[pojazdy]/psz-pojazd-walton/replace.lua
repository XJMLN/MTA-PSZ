txd = engineLoadTXD("walton.txd")
engineImportTXD(txd, 478)
dff = engineLoadDFF("walton.dff", 478)
engineReplaceModel(dff, 478)
