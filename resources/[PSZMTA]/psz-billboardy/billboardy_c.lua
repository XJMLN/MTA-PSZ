local tekstury={
  "ads003 copy", -- 584.67,-1226.36,17.87,133.3
  --"bobobillboard1", -- 1706.51,2246.22,10.82,349.2
  "bobo_2", -- 1867.23,-1050.36,23.83,88.8
  "bobo_3", -- 2366.80,-1989.89,18.55,89.7
  "cj_sprunk_front2", -- 1130.83,-919.68,58.19,31.2
  "cokopops_2", -- 2710.51,1475.23,13.78,357.6
  "didersachs01", --    822.19,-914.29,66.67,57.8
  "eris_1", -- 1525.85,-945.86,38.85,83.8
  "eris_2", -- 1386.78,-1729.58,13.38,65.6
  "eris_3", -- 544.65,-1755.97,32.55,74.7
  "eris_4", -- 1772.98,1447.25,13.29,339.8
  "eris_5", -- 2112.80,-1792.62,22.22,91.9

  "hardon_1", -- 1468.84,-939.89,36.21,265.5
  "heat_01", -- 273.00,-1439.89,24.19,34.3
  "heat_02", -- 771.30,-934.97,55.10,308.1
  "homies_1_128", -- 2188.16,-1949.76,21.78,221.9
  "homies_1", -- 2023.05,-1706.51,18.40,197.1
  "homies_2", -- 496.04,-1745.82,25.89,256.8
  "heat_04", -- 2114.52,-1791.50,22.22,301.8

  "prolaps01", -- 1547.70,-992.39,43.73,80.7
  "prolaps01_small", -- 2804.59,2391.89,10.82,315.0
  "prolaps02", -- 920.22,-956.67,39.92,117.0
  "semi1dirty", -- 1787.47,1935.81,16.16,358.9
  "semi3dirty", -- 1784.96,2310.99,6.05,343.2
  "sunbillb03", -- 392.46,-1344.01,14.75,161.2
  "sunbillb10", -- 587.49,-1234.64,17.68,121.4
  "ws_suburbansign", -- 2755.16,2426.20,10.73,312.8
  "victim_bboard",  -- 780.66,-865.59,59.73,201.9
}

local pliki={
    "img/ts3.jpg",
    "img/snnews.png",
    --"img/pszbirth.png",
	--"img/moto.jpg",
	--"img/forum.png",
}


local myShader

local function replaceTex(image,texture)
        myShader_g1, tec_g1 = dxCreateShader ( "shader.fx" )
        local myTexture_g1 = dxCreateTexture ( image );
        dxSetShaderValue ( myShader_g1, "CUSTOMTEX0", myTexture_g1 );
        if myShader_g1 then
            engineApplyShaderToWorldTexture ( myShader_g1, texture )
        end
end


addEventHandler( "onClientResourceStart", resourceRoot,
    function()

        -- Version check
        if getVersion ().sortable < "1.1.0" then
            return
        end

        for i,v in ipairs(tekstury) do
          replaceTex(pliki[i%#pliki+1], v)
        end
    end
)
