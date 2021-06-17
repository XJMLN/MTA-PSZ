textures = {
["tshirtwhite"] = 30515,
["sweatrstar"] = 30475,
["tshirtproblk"] = 30511,
}

function replaceClothes()
    for cloth, id in pairs(textures) do
    local txd = engineLoadTXD(cloth..".txd")
    engineImportTXD(txd, id)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, replaceClothes)
