# Blok 11: Python - Pobieranie danych (API, Web scraping)

To jest ostatni blok w module Pythona. Nauczysz się „skąd brać dane” w praktyce: z REST API (JSON) oraz ze stron WWW (web scraping). Efekt ma być biznesowy: umiesz samodzielnie pozyskać dane, zamienić je w tabelę i zapisać jako plik do dalszej analizy / ML.

---

## Po tym bloku będziesz umieć
- wykonać zapytanie HTTP w Pythonie (`requests.get`) i dodać parametry (`params`) oraz nagłówki (`headers`),
- sprawdzić kod odpowiedzi (`status_code`, `reason`) i poprawnie obsłużyć błędy (np. 404, 429),
- wczytać JSON do Pythona (`dict`/`list`) i zamienić go na `pandas.DataFrame`,
- wyciągać dane z HTML: po tagu, klasie CSS, id oraz selektorach CSS (BeautifulSoup),
- pobrać linki (URL) i teksty (tytuły/ceny/opisy) ze strony,
- zrozumieć kiedy potrzebujesz narzędzia do stron dynamicznych (Playwright) i użyć go w prostym scenariuszu,
- zapisywać wyniki do `CSV` i `JSON` + dodać metadane pobrania (`source`, `fetched_at`).

---

## Wymagania wstępne
- podstawy Pythona: listy/słowniki, pętle, funkcje, `try/except`,
- mile widziane: podstawy pandas (DataFrame), ale da się nadrobić w trakcie.

---

## Narzędzia i instalacja
### Minimalny zestaw
- Python 3.10+
- Jupyter Notebook / VS Code
- biblioteki: `requests`, `pandas`, `beautifulsoup4` (opcjonalnie `lxml`)

Instalacja:
~~~bash
pip install requests pandas beautifulsoup4 lxml
~~~

### Playwright (opcjonalnie, do stron dynamicznych)
~~~bash
pip install playwright
playwright install
~~~

Jeśli Playwright nie działa (np. blokada instalacji przeglądarek), zrobisz pełną część bloku na `requests + BeautifulSoup`, a Playwright potraktuj jako bonus.

---

## Źródła do ćwiczeń (API i strony)
### Publiczne API (JSON)
- PokeAPI: https://pokeapi.co  (np. `/api/v2/pokemon/{name}`)
- Official Joke API: https://official-joke-api.appspot.com  (np. `/random_joke`)
- Universities (Hipolabs): http://universities.hipolabs.com  (np. `/search?country=Poland`)
- Futurama episodes: https://api.sampleapis.com/futurama/episodes

### Strony do web scrapingu (HTML)
- W3Schools demo page: https://w3schools.com/python/demopage.htm
- WebScraper test e-commerce: https://webscraper.io/test-sites/e-commerce/allinone
- Wikipedia (pojedyncze pobrania, bez „masowego” scrapingu):
  - https://en.wikipedia.org/wiki/The_Game_Awards_2024
  - https://en.wikipedia.org/wiki/96th_Academy_Awards

---

## Ważne zasady (praktyczne i „etyczne”)
- Nie wysyłamy setek requestów w pętli do prawdziwych serwisów. Test site ok, Wikipedia tylko pojedynczo.
- Zawsze ustaw `timeout` w requestach (np. 10 sekund), bo inaczej notebook potrafi wisieć.
- Ustawiaj `User-Agent` (to częsty powód 403).
- Jeśli dostaniesz 429 (rate limit): zwolnij i spróbuj później, nie spamuj.

---

## Szybkie minimum teorii, które przyda się w praktyce
### API (REST)
- Endpoint = adres zasobu (URL).
- Parametry query idą w `params={...}`.
- JSON to zwykle `dict` albo `list[dict]`.

### Kody odpowiedzi (najczęstsze)
- 200: OK
- 404: nie znaleziono (zły endpoint / nie ma takiego zasobu)
- 401/403: brak autoryzacji / brak uprawnień / blokada
- 429: limit zapytań (za dużo w krótkim czasie)
- 500+: błąd serwera (to nie zawsze „twoja wina”)

---

## Minimalne „szablony” (żeby wystartować szybko)
### 1) requests: pobranie JSON + kontrola błędów
~~~python
import requests

url = "https://official-joke-api.appspot.com/random_joke"
resp = requests.get(
    url,
    timeout=10,
    headers={"User-Agent": "ds-ai-course/1.0"}
)

print(resp.status_code, resp.reason)

# Jeśli to nie 2xx, dostaniesz wyjątek
resp.raise_for_status()

data = resp.json()
print(type(data), data)
~~~

### 2) params: zapytanie z parametrami (Universities)
~~~python
import requests
import pandas as pd

url = "http://universities.hipolabs.com/search"
params = {"country": "Poland"}

resp = requests.get(url, params=params, timeout=10, headers={"User-Agent": "ds-ai-course/1.0"})
resp.raise_for_status()

data = resp.json()  # lista słowników
df = pd.DataFrame(data)
df.head()
~~~

### 3) BeautifulSoup: pobranie HTML i wyciąganie danych
~~~python
import requests
from bs4 import BeautifulSoup

url = "https://webscraper.io/test-sites/e-commerce/allinone"
html = requests.get(url, timeout=10, headers={"User-Agent": "ds-ai-course/1.0"}).text

soup = BeautifulSoup(html, "html.parser")

# przykład: znajdź wszystkie karty produktu
cards = soup.select("div.thumbnail")
print("Liczba kart:", len(cards))

first = cards[0]
title = first.select_one("a.title").get_text(strip=True)
price = first.select_one("h4.price").get_text(strip=True)

print(title, price)
~~~

---

## Co będziemy robić na ćwiczeniach (w skrócie)
- API: pobranie danych → walidacja → DataFrame → zapis do plików
- Scraping: wyciąganie tytułów, linków, cen, opisów (tag/klasa/id/CSS selector)
- Mini-projekt: „Collector” — 2 źródła (API + HTML) → folder `data/` + metadane pobrania

---

## Najczęstsze problemy (i szybkie rozwiązania)
- „Nie działa / wisi”: dodaj `timeout=10`.
- „JSONDecodeError”: sprawdź `resp.status_code` i `resp.text[:200]` — to może być HTML z błędem.
- „Zwraca 403”: dodaj `User-Agent` w `headers`.
- „Selektor nie trafia”: zrób `len(soup.select("..."))` i przetestuj prostszy selektor.
- „Cena jest stringiem”: usuń `$` i przecinki, potem `astype(float)`.

---

## Zadanie domowe (dla chętnych)
1) Rozszerz mini-projekt Collector:
- dodaj cache: jeśli plik z dzisiejszą datą istnieje, nie pobieraj ponownie,
- dodaj obsługę 429 (np. `sleep` i ponowna próba 2–3 razy).

2) Bonus: własne API lokalnie (FastAPI)
- endpoint `/health` i `/items` (zwracający listę rekordów),
- odpytywanie z `requests` + zapis do pliku.

---

## Jak to się przyda dalej
W projekcie końcowym kluczowe jest umieć „dowiezienie danych”:
- zamiast dostać gotowy CSV, potrafisz dane pobrać, odświeżać i wersjonować,
- budujesz nawyk pipeline: fetch → parse → validate → save → analyze.