texture hTexture;

technique TexReplace {
	pass P0 {
	Texture[0] = hTexture;
	}
}