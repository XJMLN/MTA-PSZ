txd = engineLoadTXD("jester.txd")
engineImportTXD(txd, 559)
dff = engineLoadDFF("jester.dff", 559)
engineReplaceModel(dff, 559)
