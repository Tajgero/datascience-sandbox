# Blok 11: Python - Pobieranie danych (API, Web scraping)

Ten plik to teoria „na tyle, ile trzeba”, żeby praktyka była bezpieczna i skuteczna. Reszta dzieje się w notebookach z ćwiczeniami.

---

## 1) Skąd brać dane w pracy?
Najczęstsze źródła:
- **API** (najlepsze, jeśli dostępne): stabilne, ustrukturyzowane, łatwiejsze w utrzymaniu.
- **Bazy danych** (SQL) — tu nie używamy w tym bloku, ale to „klasyk” w pracy.
- **Pliki** (CSV/Parquet/Excel) — często wynik eksportów.
- **Web scraping**: gdy API nie istnieje lub jest niepełne, a dane są w HTML.

Zasada zdrowego rozsądku:
1) najpierw szukaj API,
2) jeśli nie ma API → scraping,
3) jeśli strona jest dynamiczna (JS) → narzędzia typu Playwright.

---

## 2) HTTP w pigułce
HTTP to protokół komunikacji klient–serwer. W praktyce:
- klient: Twój kod (`requests`)
- serwer: endpoint API / serwer WWW

### Najważniejsze elementy żądania
- **URL**: adres zasobu (np. `https://api.sampleapis.com/futurama/episodes`)
- **metoda**: najczęściej `GET` (pobieranie)
- **query params**: parametry w URL, np. `?country=Poland`
- **headers**: meta-informacje (np. `User-Agent`, `Authorization`)
- **body**: przy `GET` zwykle brak; przy `POST` często JSON/form-data

### Najważniejsze elementy odpowiedzi
- **status code** (np. 200, 404)
- **reason** (tekst towarzyszący, np. "OK", "Not Found")
- **headers** (np. `Content-Type`)
- **body** (JSON / HTML / tekst)

---

## 3) REST API — co to znaczy „REST” w praktyce?
REST to styl projektowania API. Dla Ciebie ważne jest to, że:
- endpointy często odpowiadają „zasobom” (resources), np. `/pokemon/ditto`
- zwracają dane w formacie **JSON**
- operacje mapują się na metody HTTP:
  - `GET` — pobierz
  - `POST` — utwórz
  - `PUT/PATCH` — zaktualizuj
  - `DELETE` — usuń

W tym bloku skupiamy się na `GET`, bo to najczęstsze źródło danych do analiz.

---

## 4) Status codes: jak szybko diagnozować problemy
Najczęstsze kody:
- **2xx (sukces)**
  - 200 OK — dostałeś dane
- **4xx (problem po stronie klienta / Twojego requestu)**
  - 400 Bad Request — złe parametry / format
  - 401 Unauthorized — brak autoryzacji
  - 403 Forbidden — serwer blokuje (np. brak uprawnień / brak User-Agent / anti-bot)
  - 404 Not Found — zły endpoint albo nie istnieje zasób
  - 429 Too Many Requests — limit zapytań (rate limit)
- **5xx (problem po stronie serwera)**
  - 500/502/503 — serwer ma awarię / przeciążenie

Praktyczna checklista debug:
1) `print(resp.status_code, resp.reason)`
2) jeśli nie 2xx: `print(resp.text[:300])`
3) sprawdź `Content-Type` w `resp.headers.get("Content-Type")`

---

## 5) JSON: jak go czytać i mapować na Pythona
JSON mapuje się na:
- obiekt → `dict`
- tablica → `list`
- liczba → `int/float`
- string → `str`
- `true/false` → `True/False`
- `null` → `None`

### Typowy problem: zagnieżdżenia
API często zwraca coś w stylu:
- lista rekordów (łatwo do DataFrame),
- albo rekord z listami i obiektami w środku (trzeba „wyciągać” pola).

Dobre nawyki:
- sprawdzaj `type(data)` i `data.keys()` (dla dict),
- do tabeli: `pd.DataFrame(list_of_dicts)` albo `pd.json_normalize(...)`.

---

## 6) Biblioteka requests — najważniejsze elementy
### Podstawowy GET
- `requests.get(url, ...)`

### Parametry query
- `params={"country": "Poland", "name": "Warsaw"}`  
requests sam zbuduje `?country=Poland&name=Warsaw`

### Nagłówki
- `headers={"User-Agent": "...", "Authorization": "Bearer ..."}`
User-Agent pomaga uniknąć 403 na niektórych stronach.

### Timeout (must-have)
- `timeout=10`  
Bez timeoutu Twój notebook może „wisieć” w nieskończoność przy problemach sieci.

### JSON
- `resp.json()` (tylko jeśli odpowiedź faktycznie jest JSON-em)

### Obsługa błędów
- `resp.raise_for_status()` — rzuci wyjątek dla 4xx/5xx  
To dobry standard w kodzie pipeline’owym.

---

## 7) Autoryzacja do API (koncepty, bez wchodzenia w OAuth)
Najczęstsze warianty:
- **API key** w nagłówku lub parametrze (np. `X-API-Key: ...`)
- **Bearer token** (JWT lub podobne) w nagłówku:
  - `Authorization: Bearer <token>`

Zasada bezpieczeństwa:
- nie wrzucaj sekretów do repozytorium,
- przechowuj w zmiennych środowiskowych (ENV) lub w menedżerze sekretów.

---

## 8) Postman — po co to w ogóle?
Postman pomaga:
- testować endpointy bez pisania kodu,
- szybciej rozumieć parametry, nagłówki i odpowiedzi,
- generować przykładowy kod requestu.

W praktyce w pracy:
- najpierw sprawdzasz endpoint w Postman,
- potem przepisujesz do Pythona (requests) i robisz pipeline.

---

## 9) Web scraping — idea i granice
Scraping to automatyczne pobieranie i parsowanie danych z HTML.

### Kiedy scraping ma sens
- brak API albo API nie ma potrzebnych pól,
- dane są publiczne i regulamin/robots.txt na to pozwalają,
- robisz małą skalę (np. dzienny raport z kilku stron).

### Największe ryzyko scrapingu
- HTML się zmienia → selektory przestają działać,
- serwis ma zabezpieczenia anty-bot (403, CAPTCHA),
- aspekty prawne/regulaminowe (ToS), roboty, limity.

---

## 10) HTML i DOM — jak myśleć o strukturze strony
HTML to drzewo elementów:
- tagi: `div`, `a`, `h1`, `p`, `span`, `table`, `li`…
- atrybuty: `class`, `id`, `href`, `data-*`

W praktyce parsowania:
- najpierw znajdź „kontener” (np. karta produktu),
- potem z kontenera wyciągaj pola (tytuł, cena, link),
- unikaj selektorów opartych o przypadkowe, długie klasy.

---

## 11) BeautifulSoup — kluczowe techniki wyszukiwania
Zakładamy:
- `soup = BeautifulSoup(html, "html.parser")`

### Wyszukiwanie po tagu
- `soup.find("h1")`
- `soup.find_all("a")`

### Wyszukiwanie po klasie CSS
- `soup.find(class_="title")`
- `soup.find_all("div", class_="thumbnail")`

### Wyszukiwanie po id
- `soup.find(id="main")`

### Wyszukiwanie elementów wewnątrz elementu
- `card = soup.select_one("div.thumbnail")`
- `card.select_one("h4.price")`

### Wyszukiwanie po selektorze CSS
- `soup.select("div.thumbnail h4.price")`
- `soup.select_one("a.title")`

### Wyciąganie tekstu i atrybutów
- tekst: `el.get_text(strip=True)`
- atrybut: `el.get("href")` lub `el["href"]`

Uwaga: `el["href"]` rzuci błąd, jeśli nie ma `href`. Bezpieczniej: `el.get("href")`.

---

## 12) Czyszczenie danych ze scrapingu (typowe)
Scraping prawie zawsze zwraca stringi:
- ceny: `"$1,299.00"` → trzeba usunąć `$` i `,` i zmienić na float
- białe znaki: `"\n  text \t"` → `.get_text(strip=True)`
- brakujące: czasem element nie istnieje → `None` → obsłuż w kodzie

Prosty standard:
- pisz funkcję `safe_text(el)` i `safe_attr(el, "href")`,
- waliduj: czy lista rekordów ma sensowną długość (`>0`),
- loguj: ile elementów znalazłeś.

---

## 13) Strony dynamiczne i Playwright — kiedy jest potrzebny
Jeśli strona:
- ładuje dane po JS (fetch/XHR),
- ma infinite scroll / lazy loading,
- generuje HTML dopiero po interakcji,

to `requests.get(url).text` może nie zawierać docelowych danych.

Playwright uruchamia przeglądarkę (headless) i pozwala:
- wejść na stronę,
- poczekać aż JS dociągnie treść,
- pobrać finalny HTML (`page.content()`),
- dopiero wtedy parsować BeautifulSoup.

---

## 14) Tworzenie własnego API (bonus) — po co?
To pomaga zrozumieć:
- czym jest endpoint,
- jak wygląda JSON odpowiedzi,
- jak działa „kontrakt” danych.

W praktyce: w firmach często pracujesz z API wewnętrznymi, które ktoś wystawił (albo które sam tworzysz jako DS/ML engineer do serwowania wyników).

---

## 15) Dobre praktyki produkcyjne (minimum)
- zawsze `timeout`,
- obsługuj status codes i błędy,
- dawkuj requesty (szczególnie w pętli),
- dodawaj `User-Agent`,
- cache’uj wyniki (nie pobieraj w kółko tego samego),
- zapisuj dane surowe + dane przetworzone,
- dodawaj metadane: `source`, `fetched_at`, parametry zapytania.

---

## 16) Mikro-cheat sheet (do zapamiętania)
requests:
- `requests.get(url, params=..., headers=..., timeout=10)`
- `resp.status_code`, `resp.reason`
- `resp.raise_for_status()`
- `resp.json()` / `resp.text`

BeautifulSoup:
- `soup.find(...)`, `soup.find_all(...)`
- `soup.select(...)`, `soup.select_one(...)`
- `el.get_text(strip=True)`
- `el.get("href")`

Playwright (idea):
- „renderuj stronę” → „dopiero potem parsuj HTML”