# Blok 7: Python - Funkcje

Czas trwania: 8 godzin  
Poziom: 2 (po podstawach Pythona)

---

## 1. O czym jest ten blok?

W tym bloku „sklejamy” wszystko, co już umiesz z Pythona (typy danych, kolekcje, warunki, pętle) z nowym tematem – funkcjami.

Będziesz uczyć się:

- jak pisać własne funkcje (`def`),
- jak przekazywać dane do funkcji (parametry, argumenty),
- jak zwracać wynik (`return`) i czym różni się to od zwykłego `print`,
- jak pisać funkcje, które potrafią przyjąć różną liczbę argumentów (`*args`, `**kwargs`),
- jak używać type hints (adnotacje typów),
- jak korzystać z funkcji anonimowych `lambda`,
- jak pracować z danymi w formie zagnieżdżonych list i słowników (imitacja danych analitycznych).

Ćwiczenia będą mocno „biznesowe”: dane klientów, zamówień, produktów, proste eventy użytkowników – dokładnie takie struktury, jakie data scientist często dostaje „na dzień dobry” w realnej pracy (tylko tutaj trzymamy je w słownikach, a nie w bazie danych).

---

## 2. Po tym bloku będziesz umieć…

Po zakończeniu bloku będziesz w stanie:

1. Zdefiniować prostą funkcję w Pythonie (z sensowną nazwą, parametrami i `return`).
2. Wyjaśnić różnicę między:
   - parametrem funkcji (w definicji),
   - argumentem (w wywołaniu),
   - wypisaniem wyniku (`print`) a zwróceniem wyniku (`return`).
3. Używać różnych typów parametrów:
   - pozycyjnych,
   - nazwanych (np. `country="PL"`),
   - z wartościami domyślnymi,
   - `*args` (dowolna liczba argumentów pozycyjnych),
   - `**kwargs` (dowolna liczba argumentów nazwanych).
4. Wywoływać funkcje z wykorzystaniem rozpakowywania:
   - `*seq` – lista/krotka do argumentów pozycyjnych,
   - `**dict` – słownik do argumentów nazwanych.
5. Świadomie korzystać z podstawowej wiedzy o przestrzeniach nazw:
   - wiedzieć, co to global, local, enclosing, built-in,
   - rozumieć, że zmienne wewnątrz funkcji nie „istnieją” na zewnątrz.
6. Dodać proste adnotacje typów (type hints) do funkcji i odczytać je.
7. Napisać prostą funkcję rekurencyjną (np. suma elementów listy) i jej odpowiednik iteracyjny.
8. Użyć funkcji `lambda` w typowych sytuacjach:
   - sortowanie (`sorted`),
   - filtrowanie (`filter`),
   - proste transformacje.
9. Wygodnie korzystać z wybranych funkcji wbudowanych:
   - `print`, `input`, `range`, `type`, `sum`, `max`, `min`,
   - metody stringów: `startswith`, `endswith`, `strip`, `lstrip`, `rstrip`, `index`, `count`.
10. Pisać funkcje analizujące zagnieżdżone listy i słowniki (np. agregowanie informacji o klientach i zamówieniach).
11. Łączyć funkcje z warunkami (`if`) i pętlami (`for`, `while`), żeby pisać czysty, łatwy w utrzymaniu kod.

---

## 3. Wymagania wstępne

Przed tym blokiem dobrze, żebyś:

- umiał/a:
  - podstawowe typy: `int`, `float`, `str`, `bool`,
  - listy, krotki, słowniki (dodawanie/odczyt elementów, iteracja),
- rozumiał/a instrukcje warunkowe `if / elif / else`,
- swobodnie pisał/a:
  - pętle `for`,
  - pętle `while` (przynajmniej proste scenariusze),
- potrafił/a pracować w Jupyter Notebook (uruchomić komórkę, dodać nową, zapisać plik).

Jeśli czujesz, że pętle, warunki albo słowniki Ci „uciekają”, przed zajęciami:

- przejrzyj notatki z poprzednich bloków,
- spróbuj napisać krótką pętlę, która:
  - przechodzi po słowniku klientów,
  - wypisuje tylko tych z konkretnego kraju.

To pomoże Ci dużo spokojniej wejść w pracę z funkcjami.

---

## 4. Środowisko i narzędzia

Do pracy na zajęciach potrzebujesz:

- **Python:** wersja 3.10+,
- **Jupyter Notebook** – będziemy pracować w notebookach:
  - `cwiczenia_clean.ipynb` – Twój notatnik do pracy,
  - `cwiczenia_solved.ipynb` – wersja z rozwiązaniami (tylko podgląd/awaryjnie),
- **Brak dodatkowych bibliotek** – wystarczy czysty Python (bez numpy/pandas w tym bloku).

Jeśli korzystasz z Anacondy – najprościej:

1. Otwórz Anaconda Navigator.
2. Uruchom Jupyter Notebook.
3. Przejdź do katalogu z plikami bloku.
4. Otwórz `cwiczenia_clean.ipynb`.

---

## 5. Jakie dane będziemy wykorzystywać?

Na potrzeby tego bloku korzystamy z **gotowych słowników z danymi**, które są zdefiniowane na początku notebooka. Ty **nie musisz** ich tworzyć od zera – wszystko będzie w kodzie.

Przykładowe struktury:

- `customers_data` – klienci sklepu internetowego:
  - klucz: `customer_id`, np. `"C001"`,
  - wartość: słownik z polami:
    - `name` – imię/nazwa klienta,
    - `country` – kraj (np. `"PL"`),
    - `segment` – typ klienta (np. `"B2B"`, `"B2C"`),
    - `email` – e-mail,
    - `is_active` – czy klient aktywny (`True` / `False`).

- `orders_data` – zamówienia:
  - klucz: `order_id`, np. `"O1234"`,
  - wartość: słownik:
    - `customer_id` – powiązanie z klientem,
    - `items` – lista słowników z produktami,
    - `total_net` – kwota netto,
    - `currency` – waluta,
    - `status` – status zamówienia (np. `"completed"`),
    - `created_at` – uproszczona data/czas.

- `products_data` – produkty:
  - klucz: `product_id`,
  - wartość: słownik:
    - `name`,
    - `category`,
    - `base_price`,
    - `discount_group`.

- `events_data` – proste logi zdarzeń użytkownika:
  - lista słowników z:
    - `customer_id`,
    - `event_type` (np. `"login"`, `"add_to_cart"`, `"purchase"`),
    - `timestamp`,
    - `metadata` – dodatkowe informacje (np. ścieżka strony).

Dodatkowo:

- zagnieżdżone listy liczb (np. lista tygodni, w każdym tydzień lista dziennych wolumenów),
- listy stringów (np. nazwy produktów z „brudnymi” spacjami do oczyszczenia).

Twoje zadania będą polegały głównie na:

- pisaniu funkcji, które **przetwarzają** te struktury,
- filtrowaniu, liczeniu, agregowaniu,
- czyszczeniu tekstu i prostych analizach.

Nie pracujemy tutaj z plikami CSV czy bazą SQL – celem jest skupienie się na samych funkcjach.

---

## 6. Jak wygląda praca na zajęciach?

### Struktura dnia

- Krótkie wprowadzenia teoretyczne (ok. 10–20 minut),
- potem od razu seria ćwiczeń w notebooku:
  - mikroćwiczenia (kilka minut),
  - większe zadania (15–30 minut),
  - na końcu mini-projekty, które łączą:
    - funkcje,
    - kolekcje,
    - warunki,
    - pętle `for` i `while`.

### Pliki

- `cwiczenia_clean.ipynb` – Twój plik do pracy:
  - zadania opisane w komórkach tekstowych,
  - przygotowane dane, szkielety funkcji,
  - miejsca oznaczone komentarzami `# TODO`.
- `cwiczenia_solved.ipynb` – pełne rozwiązania:
  - prowadzący może go pokazać,
  - Ty możesz z niego skorzystać po zajęciach lub gdy utkniesz na dłużej,
  - **warto** najpierw spróbować samemu.

---

## 7. Przykładowe tematy ćwiczeń

W czasie bloku zrobisz m.in.:

- proste funkcje do liczenia:
  - ceny brutto,
  - średniej wartości koszyka klienta,
- funkcje filtrujące:
  - aktywnych klientów z danego kraju,
  - zamówienia ze wskazanym statusem,
- funkcje z parametrami domyślnymi:
  - np. domyślna waluta `"PLN"`, domyślny próg wartości zamówienia,
- funkcje z:
  - `*args` (np. różne rabaty),
  - `**kwargs` (np. konfigurowalne metryki),
- zastosowania `lambda`:
  - sortowanie klientów po segmencie,
  - filtrowanie eventów typu `"purchase"`,
- pracę z listami zagnieżdżonymi:
  - liczenie sumy/średniej po tygodniach i dniach,
  - proste agregacje.

Na końcu będą mini-projekty, w których zbudujesz prosty „mini-system”:

- analiza aktywnych klientów (ranking),
- symulator koszyka (pętla `while` + funkcje),
- mini-ETL dla zamówień (kilka funkcji w „pipeline”).

---

## 8. Zadanie domowe (dla chętnych)

Zadanie domowe jest dobrowolne, ale bardzo pomaga utrwalić materiał.

**Cel:** napisać mały „moduł” z funkcjami do analizy prostych danych, np.:

- aktywność użytkowników w aplikacji,
- sprzedaż prostego sklepu,
- logi zdarzeń (wejścia na stronę, kliknięcia, zakupy).

**Wymagania minimalne:**

- co najmniej **5 funkcji** powiązanych ze sobą tematycznie,
- co najmniej jedna funkcja:
  - używa `*args` lub `**kwargs`,
- co najmniej jedna funkcja:
  - ma adnotacje typów (type hints) przy parametrach i zwracanym typie,
- użycie `lambda` przynajmniej raz (np. do sortowania listy wyników),
- co najmniej jedna funkcja pracuje na **zagnieżdżonych listach lub słownikach** (np. lista zamówień, słowniki klientów).

Dodatkowo:

- dopisz krótki opis (2–3 zdania) w komórce tekstowej:
  - jaki problem biznesowy rozwiązujesz,
  - kto mógłby z tego skorzystać (np. dział marketingu, zespół sprzedaży).

---

## 9. Jak najlepiej korzystać z tego bloku?

Kilka praktycznych wskazówek:

1. **Pisz małe funkcje**  
   Jeśli zadanie wydaje się duże – podziel je na kilka mniejszych funkcji.  
   Lepiej mieć 3 krótkie funkcje niż jedną „ścianę kodu”.

2. **Nazwy mają znaczenie**  
   Staraj się, żeby nazwa funkcji odpowiadała temu, co robi, np.:
   - `calculate_average_order_value`,
   - `filter_active_customers`,
   - `get_country_sales`.

3. **Zwracaj dane, nie tylko je wypisuj**  
   `print` jest dobry do debugowania, ale do logiki używamy `return`.  
   Dzięki temu możesz łączyć funkcje w łańcuchy (pipeline).

4. **Nie bój się `lambda`, ale nie nadużywaj**  
   Używaj `lambda` tam, gdzie naprawdę skraca zapis, np. w `sorted` czy `filter`.  
   Jeśli logika robi się zbyt skomplikowana – lepiej napisać normalną funkcję `def`.

5. **Korzystaj z `cwiczenia_solved.ipynb` z głową**  
   Patrz na rozwiązania:
   - gdy naprawdę utkniesz,
   - po zakończeniu własnej próby – porównaj podejście.

6. **Pytaj o LEGB i typy, jeśli coś jest niejasne**  
   Przestrzeń nazw i type hints mogą brzmieć „teoretycznie”, ale w praktyce:
   - LEGB pomaga rozumieć, skąd biorą się wartości zmiennych,
   - type hints bardzo pomagają w większych projektach.

---

## 10. Co dalej po tym bloku?

Po opanowaniu funkcji w Pythonie:

- łatwiej będzie Ci:
  - korzystać z bibliotek typu `pandas` i `scikit-learn`,
  - pisać kod analityczny w sposób modularny,
- będziesz mieć solidny „trzon” do pracy nad projektem końcowym:
  - dane → funkcje czyszczące → funkcje agregujące → funkcje raportujące.

Ten blok to fundament do:
- budowania własnych helperów i utili w projektach,
- zrozumienia, jak działają metody klas w kolejnych blokach,
- pisania kodu, który da się łatwo testować, zmieniać i rozwijać.

Przyjdź z otwartą głową, nie bój się eksperymentów i błędów – funkcje to temat, który trochę „klika” dopiero po kilku próbach.