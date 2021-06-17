txd = engineLoadTXD("comet.txd")
engineImportTXD(txd, 480)
dff = engineLoadDFF("comet.dff", 480)
engineReplaceModel(dff, 480)
