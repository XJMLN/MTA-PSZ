--[[

Atrakcje - zrzuty,

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-atrakcje
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--

zrzut_pozycje = {
-- x1,y1,z1,x2,y2,z2,lokalizacja
	{0,0,50,0,0,3.5,"Farma w Blueberry"}, -- na farmie, srodek mapy
	{304.36,1929.70,50,304.36,1929.70,18.3,"Baza wojskowa"}, -- baza wojskowa
	{-2618.35,-2578.45,50,-2618.35,-2578.45,3.5,"Plaża przy Angel Pine"}, -- przy ap
	{-3394.62,1892.70,50,-3394.62,1892.70,7.49,"Wyspa na zachód od San Fierro"}, -- wyspa sf na lewo
	{-159.89,-364.72,50,-159.89,-364.72,1.09,"Remiza Blueberry"},
	{-2309.74,-1653.98,530,-2309.74,-1653.98,483.69,"Mount Chiliad"},
	{1735.75, -2528.49,45.25,1735.75,-2528.49,13.55,"Lotnisko Los Santos"},
}

zrzut_nagrody = {
	-- opis nagrody, skrot
	{"Zwiększenie ilości zdrowia",'hp'}, 
	{"VIP",'vip'},
	{"50 granatów",'ammo'},
	{"Niezniszczalny pojazd",'godveh'},
	{"Pieniądze","cash"},
}

zrzut_active = false
zrzut_frozen = true
zrzut_kontener = nil
zrzut_text = nil
zrzut_return_text = nil

function zrzut_info(txt)
	if (zrzut_active) then
		outputChatBox("Kontenter z cennym ładunkiem został zrzucony w lokalizacji: "..txt,root,255,0,0); 
		triggerClientEvent("gui_showOgloszenie", root, "Kontener z cennym ładunkiem został zrzucony w lokalizacji: "..txt,"Informacja o lokalizacji zrzutu");
	else
		outputDebugString('Wywolanie zrzut_info, podczas braku zrzutu.');
	end
end

function zrzut_chatbox(txt)
	if (zrzut_active) then
		local x,y,z = getElementPosition(zrzut_kontener);
		local zrzut_strefa = createColSphere(x,y,z,15);
		local zrzut_gracze = getElementsWithinColShape(zrzut_strefa,"player");
		for i,v in ipairs(zrzut_gracze) do
			if (v) then
			outputChatBox(txt,v,255,0,0);
			end
		end
		destroyElement(zrzut_strefa);
	end
end


function zrzut_shuffleWinner(player)
	local text,fopis = unpack(zrzut_nagrody[math.random(1,#zrzut_nagrody)]); 
	outputChatBox("Gratulację zdobyłeś cenny ładunek, a jest nim: "..text,player,52,250,50);

	main_giveReward(player,fopis);
end

function zrzut_occupants(x2,y2,z2) 
	if (zrzut_active) then
		local zrzut_strefa = createColSphere(x2,y2,z2,15);
		local zrzut_gracze = getElementsWithinColShape(zrzut_strefa,"player");  
		for i,v in ipairs(zrzut_gracze) do
			if (v) then 
				outputChatBox("Oddal się od miejsca zrzutu, lub zostaniesz zgnieciony!",v,150,210,50);
			end
		end
		destroyElement(zrzut_strefa);
	end
end

function zrzut_idle()
	if (not zrzut_frozen) then
		zrzut_chatbox("Kontener został otworzony, pierwsza osoba która wejdzie w marker, otrzyma losową nagrodę!");
		local x,y,z = getElementPosition(zrzut_kontener)
		local marker = createMarker(x,y,z-0.5,"cylinder",1,255,0,0);
		--attachElements(marker,zrzut_kontener,0,0,-1);

		addEventHandler("onMarkerHit",marker,function(el, md)
			if not md then return end
			if getElementType(el)~="player" then return end
			if not zrzut_active then return end
			local nick_player = string.gsub(getPlayerName(el),"#%x%x%x%x%x%x","");
			outputChatBox("Kontener zdobył gracz: "..nick_player..", gratulację!");
			local pz = getElementData(el,"PZ");
			setElementData(el,"PZ",tonumber(pz)+5);
			zrzut_shuffleWinner(el);
			destroyElement(source);
			destroyElement(zrzut_kontener);
			destroyElement(zrzut_text);
			zrzut_kontener = nil
			zrzut_text = nil
			zrzut_active = false
			zrzut_frozen = true
			zrzut_return_text = nil
		end)
	end
end

function zrzut_create()
	local x1,y1,z1,x2,y2,z2,txt = unpack(zrzut_pozycje[math.random(1,#zrzut_pozycje)]); 
	zrzut_kontener = createObject(2669,x1,y1,z1,0,0,0);
	local hour,minute = getTime()
	setElementData(zrzut_kontener,'zrzut:obiekt',minute) 
	zrzut_active = true 
	zrzut_return_text = txt
	zrzut_info(txt);
	zrzut_occupants(x2,y2,z2);
	moveObject(zrzut_kontener,26500, x2, y2, z2,0,0,0,"Linear");
	zrzut_text = createElement("text");
	local zrzut_timer = tonumber(26500) + tonumber(420000) + tonumber(500) -- czas spadania + czas otworzenia + czas ladowania + milisekundy na triggery
	local czas = getRealTime();
	czas.timestamp = czas.timestamp+zrzut_timer/1000+math.random(30,90)
	czas= getRealTime(czas.timestamp);
	zrzut_text = createElement("text");
	setElementPosition(zrzut_text,x2,y2,z2+2);
	setElementData(zrzut_text,'text',string.format('Przybliżony czas otworzenia:  %02d:%02d',czas.hour,czas.minute));
	setTimer(function() zrzut_frozen = false zrzut_idle() end,zrzut_timer,1); 
end


function zrzut_spool()
	if(zrzut_kontener and zrzut_active) then return end
	zrzut_create()
end

setTimer(zrzut_spool,21600000,0)

setTimer(zrzut_spool,5000,1)
