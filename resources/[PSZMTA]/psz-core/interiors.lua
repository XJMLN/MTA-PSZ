--[[

Core - chaty

Glowny tworca kodu to Lukasz Biegaj <wielebny@bestplay.pl>, kod zostal przerobiony pod serwer PSZMTA,

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-core
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.


]]--



interiory={}

function getInterior(id)
	id=tonumber(id)
	if (interiory[id] and type(interiory[id])=="table") then return interiory[id] end

	local query=string.format("select id,interior,entrance,`exit`,dimension,opis FROM psz_interiory WHERE 1 and id=%d LIMIT 1", id)

	local int=exports["psz-mysql"]:pobierzWyniki(query)

	if (not int) then
		return nil
	end

	if (int.entrance and type(int.entrance)=="string") then 
		int.entrance=split(int.entrance,",")
	else
		int.entrance=nil
	end

	if (int.exit and type(int.exit)=="string") then
		int.exit=split(int.exit,",")			-- wyjscie
	else
		int.exit=nil
	end

	interiory[id]=int


	return int

end