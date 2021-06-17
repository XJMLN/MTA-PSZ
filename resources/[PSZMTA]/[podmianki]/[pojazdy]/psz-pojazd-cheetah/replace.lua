v=415
txd = engineLoadTXD("infernus.txd")
engineImportTXD(txd, v)
dff = engineLoadDFF("infernus.dff", v)
engineReplaceModel(dff, v)