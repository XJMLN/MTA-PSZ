txd = engineLoadTXD("mesa.txd")
engineImportTXD(txd, 500)
dff = engineLoadDFF("mesa.dff", 500)
engineReplaceModel(dff, 500)

txd2 = engineLoadTXD("bandito.txd")
engineImportTXD(txd2, 568)
dff2 = engineLoadDFF("bandito.dff", 568)
engineReplaceModel(dff2, 568)


txd3 = engineLoadTXD("bfinject.txd")
engineImportTXD(txd3, 424)
dff3 = engineLoadDFF("bfinject.dff", 424)
engineReplaceModel(dff3, 424)

txd4 = engineLoadTXD("quad.txd")
engineImportTXD(txd4, 572)
dff4 = engineLoadDFF("quad.dff", 572)
engineReplaceModel(dff4, 572)

txd5 = engineLoadTXD("nrg500.txd")
engineImportTXD(txd5, 461)
dff5 = engineLoadDFF("nrg500.dff", 461)
engineReplaceModel(dff5, 461)

txd6 = engineLoadTXD("infernus.txd")
engineImportTXD(txd6, 558)
dff6 = engineLoadDFF("infernus.dff", 558)
engineReplaceModel(dff6, 558)
