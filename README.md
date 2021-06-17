PSZMTA.PL

Jest to najnowsza wersja plików z serwera pszmta.pl (2015-2017) na licencji MIT.

Autorzy:
=============================
  - XJMLN
  
 ### Zawiera kod z MTA-XyzzyRP (http://github.com/lpiob/MTA-XyzzyRP/), którego autorami są:
  - Łukasz "W/Wielebny" Biegaj
  - WUBE
  - Karer
  - Przemysław "RacheT" Kędziorek
  - Eryk "RootKiller" Dwornicki
  
Nowy skład pszmta.pl:
================================
Ten projekt umożliwia uruchomienie prawie że identycznej kopii serwera z 2017r (bez map, podmianek, paneli web) pszmta.com.

Licencja:
================================
Kod dystrybuowany jest na licencji MIT. Wszystkie pliki .map dystrybuowane są na licencji CC-BY-ND. Streszczenie: http://creativecommons.org/licenses/by-nd/3.0/pl/. W repozytorium znajdują się również fragmenty kodu z community, dystrybuowane na innej licencji, wszystko jest opisane w zasobach.

Co zawiera repozytorium?:
==============================
Repozytorium zawiera:
 * Kod serwera
 * Strukturę bazy danych

Repozytorium nie zawiera:
 * Podmianek skinów i pojazdów
 * Niektórych plików .map 
 * Panelu WEB dla gracza, 
 * Panelu zarządzania WEB dla administracji,
 * Kodu używanego na forum do integracji z serwerem,
 
Jak uruchomić serwer?:
=============================
Aby uruchomić serwer musisz:

  1. Zainstalować serwer MTA,
  2. Skopiować katalog resources/[PSZMTA] do katalogu mods/deathmatch/resources/[PSZMTA]/
  3. Zainicjalizować bazę danych plikiem zawartym w mysql/schema.sql
  4. Zainicjalizowąć samodzielnie czyste konto w ACL
  5. Stworzyć plik mtaserver.conf lub połączyć istniejący z tym znajdującym się w opt/mtaserver.conf.
  6. Uruchomić serwer, zalogować się, zmienić hasło do ACL

Informacje dodatkowe
==============================
Repozytorium nie zawiera pełnej dokumentacji do wszystkich elementów kodu. Jest on dosyć spory, poniżej wypisałem kluczowe aspekty na które musisz zwrócić uwagę przy używaniu kodu, reszty musisz dowiedzieć się sam - czytając kod źródłowy.

### Hasła graczy

Hasła graczy zapisywane są w tabeli psz_users w postaci skrótu SHA1 z wykorzystaniem zmiennej i stałej soli. Solą zmienną jest login gracza zapisany małym literami. Hashe generowane są według następującej funkcji:

  ```SELECT SHA1(CONCAT(LOWER("login_gracza"),"ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9","haslo"));```
  
Przed wdrożeniem własnej instalacji należy zmienić sól z ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9 na swoją własną, w przeciwnym wypadku możesz narazić się na odkowdowanie haseł w przypadku wycieku bazy danych.


### Zmiana hasła do konta

Zmianę hasła możesz wykonać za pomocą poniższego zapytania:

  ```UPDATE psz_users SET hash=SHA1(CONCAT(LOWER(login),'ZU5xTDhnejFOWW13OUVrTGpmUTJUQzBxNXVVQ0FEU0VCVWc9','tu_wpisz_nowe_haslo')) WHERE id=id;```

### Logowanie

Wszystkie logi przechowywane są w katalogu psz-admin/logs. Przy restarcie tego zasobu tworzony jest nowy plik z logami. Wszystkie screeny graczy wykonane komendą /sshot przechowywane są w katalogu psz-admin/ss/
