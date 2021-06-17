id = 1254
txd = engineLoadTXD("rabit01.txd",id)
engineImportTXD(txd,id)
dff = engineLoadDFF("rabit01.dff",id)
engineReplaceModel(dff,id)