tablice_pos = {
	{pos_header={-2032.37,143.83,31}, pos_footer={-2032.37, 143.83, 29.3}, t_header="10 Najlepszych drifterów", dim=0, int=0, id=1}, -- SF mechanik
	{pos_header={2352.79,-1459.49,26}, pos_footer={2352.79,-1459.49,24.7}, t_header="10 Najlepszych poszukiwaczy totemów", dim=0, int=0, id=2}, -- sklep pamiatki obok kosciola ls
	{pos_header={-1459.84,885.48,74.76}, pos_footer={-1459.84,885.48,72.76}, t_header="10 Najlepszych zabójców", dim=23, int=21, id=3}, 
	{pos_header={-1460.72,866.17,81.06}, pos_footer={-1460.72,866.17,79.06}, t_header="10 Najbardziej poszukiwanych osób", dim=23, int=21, id=4},
	{pos_header={-1489.40,869.73,81.06}, pos_footer={-1489.40,869.73,79.06}, t_header="10 Największych bogaczy", dim=23, int=21, id=5},
	{pos_header={-1459.91,875.57,74.76}, pos_footer={-1459.91,875.57,72.76}, t_header="10 Największych zgonowców", dim=23, int=21, id=6},
	{pos_header={-1490.99,886.14,81.06}, pos_footer={-1490.99,886.14,78.06,79.06}, t_header="10 Najlepiej bawiących się", dim=23, int=21, id=7},
	{pos_header={-1490.89,884.77,74.76}, pos_footer={-1490.89,884.77,72.76}, t_header="10 Graczy z największą ilością godzin", dim=23, int=21, id=8},
	{pos_header={-1490.89,876.51,81.06}, pos_footer={-1490.89,876.51,79.06}, t_header="10 Graczy z największą ilością reputacji", dim=23, int=21, id=9},
	{pos_header={-1490.99,873.07,74.76}, pos_footer={-1490.99,873.07,72.76}, t_header="10 Graczy z najmniejszą ilością reputacji", dim=23, int=21, id=10},
	{pos_header={378.60,2478.39,18.48}, pos_footer={378.60,2478.39,16.48}, t_header="10 Najlepszych wyników z trasy\n Opuszczone lotnisko (handling)", dim=0, int=0, id=11},
	{pos_header={378.20,2526.52,18.57}, pos_footer={378.20,2526.52,16.57}, t_header="10 Najlepszych wyników z trasy\n Opusczone lotnisko (zwykły)", dim=0, int=0, id=12},

	--{pos_header={-1521.17,933.43,10}, pos_footer={-1521.17,933.43,8.5}, t_header="10 Największych poszukiwaczy króliczków", dim=0, int=0, id=7},
	--{pos_header={-1521.17,933.44,9}, pos_footer={-1521.17,933.44,7.04}, t_header="Event: Poszukiwacze ciasteczek", dim=0, int=0, id=??},
}

for i,v in ipairs(tablice_pos) do
	tablice_pos[v.id].headerT = createElement("text")
		setElementPosition(tablice_pos[v.id].headerT,v.pos_header[1],v.pos_header[2],v.pos_header[3])
		setElementInterior(tablice_pos[v.id].headerT, v.int, v.pos_header[1],v.pos_header[2],v.pos_header[3])
		setElementDimension(tablice_pos[v.id].headerT, v.dim)
		setElementData(tablice_pos[v.id].headerT, "text",v.t_header)

	tablice_pos[v.id].footerT = createElement("text")
		setElementPosition(tablice_pos[v.id].footerT, v.pos_footer[1], v.pos_footer[2], v.pos_footer[3])
		setElementInterior(tablice_pos[v.id].footerT, v.int, v.pos_footer[1], v.pos_footer[2], v.pos_footer[3])
		setElementDimension(tablice_pos[v.id].footerT, v.dim)
		setElementData(tablice_pos[v.id].footerT, "text","...Oczekiwanie na dane...")
end