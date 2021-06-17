txd = engineLoadTXD("sabre.txd")
engineImportTXD(txd, 518)
dff = engineLoadDFF("sabre.dff", 518)
engineReplaceModel(dff, 518)
