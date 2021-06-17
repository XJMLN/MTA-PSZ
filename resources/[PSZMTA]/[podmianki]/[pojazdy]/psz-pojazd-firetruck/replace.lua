txd = engineLoadTXD("firetruk.txd")
engineImportTXD(txd, 407)
dff = engineLoadDFF("firetruk.dff", 480)
engineReplaceModel(dff, 407)
