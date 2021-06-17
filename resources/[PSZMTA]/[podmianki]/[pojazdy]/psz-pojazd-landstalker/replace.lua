txd = engineLoadTXD("landstal.txd")
engineImportTXD(txd, 400)
dff = engineLoadDFF("landstal.dff", 400)
engineReplaceModel(dff, 400)
