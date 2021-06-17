txd = engineLoadTXD("burrito.txd")
engineImportTXD(txd, 482)
dff = engineLoadDFF("burrito.dff", 482)
engineReplaceModel(dff, 482)
