txd = engineLoadTXD("infernus.txd")
engineImportTXD(txd, 558)
dff = engineLoadDFF("infernus.dff", 558)
engineReplaceModel(dff, 558)
