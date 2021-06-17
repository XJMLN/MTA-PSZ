txd = engineLoadTXD("lspd.txd")
engineImportTXD(txd, 596)
dff = engineLoadDFF("lspd.dff", 596)
engineReplaceModel(dff, 596)



