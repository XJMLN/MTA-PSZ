--[[

poczta - wysylka listow, bot na poczcie

@author Jakub 'XJMLN' Starzak <jack@pszmta.pl
@package PSZMTA.psz-poczta
@copyright Jakub 'XJMLN' Starzak <jack@pszmta.pl>

Nie mozesz uzywac tego skryptu bez mojej zgody. Napisz - byc moze sie zgodze na uzycie.

]]--
addEvent("doVerifyAccountNickname",true)
addEventHandler('doVerifyAccountNickname',getRootElement(),function(cel)
    local q = string.format("SELECT p.userid,p.nick,datediff(now(),pl.datetime_last) dnitemu FROM psz_postacie p JOIN psz_players pl ON pl.id=p.userid JOIN psz_domy d ON d.ownerid=pl.id WHERE (p.nick LIKE '%%%s%%' OR p.nick SOUNDS LIKE '%s') ORDER BY dnitemu ASC LIMIT 6;",cel,cel)
    local wyniki = exports['psz-mysql']:pobierzTabeleWynikow(q)
    if (wyniki) then
        triggerClientEvent(source,"showResultAboutAccounts",source,wyniki)
    else
        triggerClientEvent(source,'showResultAboutAccounts',source)
    end
end)

function translit(tekst)
    tekst=string.gsub(tekst,"ą","a")
    tekst=string.gsub(tekst,"ć","c")
    tekst=string.gsub(tekst,"ę","e")
    tekst=string.gsub(tekst,"ł","l")
    tekst=string.gsub(tekst,"ń","n")
    tekst=string.gsub(tekst,"ó","o")
    tekst=string.gsub(tekst,"ś","s")
    tekst=string.gsub(tekst,"ź","z")
    tekst=string.gsub(tekst,"ż","z")
    tekst=string.gsub(tekst,"Ą","A")
    tekst=string.gsub(tekst,"Ć","C")
    tekst=string.gsub(tekst,"Ę","E")
    tekst=string.gsub(tekst,"Ł","L")
    tekst=string.gsub(tekst,"Ń","N")
    tekst=string.gsub(tekst,"Ó","O")
    tekst=string.gsub(tekst,"Ś","S")
    tekst=string.gsub(tekst,"Ź","Z")
    tekst=string.gsub(tekst,"Ż","Z")
    return tekst
end

addEvent('doSendPost',true)
addEventHandler('doSendPost',getRootElement(),function(cel,tresc)
local tresc = translit(tresc)
local c = getElementData(source,'character')
    if (c and c.id) then
        if (c.id == cel) then
            outputChatBox("Wysyłanie listów do samego siebie jest idiotyczne :-).",source)
            return
        end
    local q = string.format("INSERT INTO psz_poczta SET nadawca=%d,odbiorca=%d,tresc='%s',ts=NOW()",tonumber(c.id),tonumber(cel),tresc)
    local wynik = exports['psz-mysql']:zapytanie(q)
        if (wynik) then
            outputChatBox("Pani Renata mówi: Wiadomość została wysłana, wkrótce trafi do odbiorcy.",source)
            outputChatBox("Koszt nadania listu: $25 - kwota została pobrana z Twojego konta.",source)
            takePlayerMoney(source,25)
        else
            outputChatBox('[ERROR] Zawiadom Administratora ROOT. Kod błędu: doSenPost:45',source,255,0,0)
        end
    end  
end)

local tresci_listow = {
    {'Sliczna ma panienko, otworz swe okienko. Bo poranek wstaje, calusa Ci daje. A na skrzydlach ptakow promienie smigaja, lecac hen po swiecie, radosc ludziom daja. Milego, radosnego i cieplego dnia Ci zyczę.'},
    {'Lubie Twoja slodka buzie, moj Ty kochany Lobuzie. I serduszko Twoje gorace, dlatego chce Ci dzis dac calusow tysiace!'},
    {'Zycze Ci milosci i szczescia, drog prostych, usmiechu wiele, zeby slonce Ci przyswiecalo, w dzien powszedni i w niedziele.'},
}
local PSZ_BOT = 5802 -- ID gracza 'Cichy Fan' - BOT, konto zablokowane.

function poczta_powiadomGracza(PLAYER_ID)
    local tresc = unpack(tresci_listow[math.random(#tresci_listow)])
    exports['psz-mysql']:zapytanie(string.format("INSERT INTO psz_poczta SET nadawca=%d,odbiorca=%d,tresc='%s',ts=NOW();",tonumber(PSZ_BOT),tonumber(PLAYER_ID),tostring(tresc)))
    --outputDebugString("BOT wysyła pocztę")
    return true
end