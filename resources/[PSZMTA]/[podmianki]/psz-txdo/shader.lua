
local flags = {
"sam_camo",
"sam_camo2",
}
local flagsShaders = {}

addEventHandler("onClientResourceStart",root,
function()
 for k,image in ipairs(flags) do
    local flagTexture = dxCreateTexture(image..".png")
    local flagShader = dxCreateShader("shader.fx")
    dxSetShaderValue(flagShader,"Tex0",flagTexture)
    flagsShaders[image] = flagShader
    end
end
)

addEventHandler("onClientElementStreamIn",root,
function()
    if getElementType(source) == "object" then
        if getElementModel(source) == 3095 then -- Your flag object id
        local flagIMG = getElementData(source,"obj:texture")
        if flagIMG then
        engineApplyShaderToWorldTexture(flagsShaders[flagIMG],"sam_camo",source)
    --elseif flagIMG == 'sam_camo2' then
        --engineApplyShaderToWorldTexture(flagsShaders[flagIMG],"sam_camo",source)

            end
        end
    end
end
)
