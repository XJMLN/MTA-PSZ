v=439
txd = engineLoadTXD("stallion.txd")
engineImportTXD(txd, v)
dff = engineLoadDFF("stallion.dff", v)
engineReplaceModel(dff, v)