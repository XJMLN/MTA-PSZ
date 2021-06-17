
local flagTexture = dxCreateTexture("green.png")
local flagShader = dxCreateShader("shader.fx")
dxSetShaderValue(flagShader,"Tex0",flagTexture)


addEventHandler("onClientElementStreamIn",root,
function()
    if getElementType(source) == "object" then
        if getElementModel(source) == 16000 then -- Your flag object id
        engineApplyShaderToWorldTexture(flagShader,"drvin_screen",source)
        end
    end
end
)
