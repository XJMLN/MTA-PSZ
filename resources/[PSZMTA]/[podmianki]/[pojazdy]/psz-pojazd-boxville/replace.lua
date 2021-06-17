txd = engineLoadTXD("journey.txd")
engineImportTXD(txd, 498)
dff = engineLoadDFF("journey.dff", 498)
engineReplaceModel(dff, 498)