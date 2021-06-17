txd = engineLoadTXD("dft30.txd")
engineImportTXD(txd, 578)
dff = engineLoadDFF("dft30.dff", 480)
engineReplaceModel(dff, 578)
