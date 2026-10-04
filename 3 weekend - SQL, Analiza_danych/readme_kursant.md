# Blok 3: SQL - Analiza danych

## 1. O czym jest ten blok?

W tym bloku wchodzimy w **analityczną stronę SQL**. Przestajemy używać SQL-a tylko do prostego „wyciągania tabel” i zaczynamy:

- liczyć **wskaźniki biznesowe** (np. YoY, MoM, percentyle),
- budować **raporty** bezpośrednio w SQL,
- wykorzystywać **funkcje okna** i **podzapytania**,
- dzielić zapytania na czytelne etapy dzięki **CTE** (`WITH`).

Pracujemy na jednej, wspólnej bazie danych **e-commerce** (zamówienia, klienci, produkty, sesje na stronie), tak jak robi się to w realnej pracy.

Blok trwa **8 godzin** i jest drugim z trzech bloków SQL (PostgreSQL).

---

## 2. Po tym bloku będziesz umieć…

Po ukończeniu tego bloku będziesz potrafić:

1. **Stosować funkcje okna w PostgreSQL**:
   - pisać `OVER (PARTITION BY ... ORDER BY ...)`,
   - używać `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`, `CUME_DIST()`, `NTILE()`,
   - korzystać z `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`.

2. **Budować wskaźniki analityczne w SQL**:
   - liczyć średnie, sumy, minimum, maksimum jako funkcje okna (`AVG(), SUM(), COUNT(), MIN(), MAX()`),
   - wyznaczać wskaźniki typu **Month-over-Month (MoM)**, **Year-over-Year (YoY)**,
   - obliczać **percentyle** (`percentile_disc`, `percentile_cont`) oraz proste miary statystyczne (wariancja, odchylenie standardowe, korelacja, kowariancja).

3. **Korzystać z podzapytań i CTE**:
   - pisać podzapytania w `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `HAVING`, `LIMIT`,
   - używać `WITH` (CTE) do dzielenia zapytania na etapy,
   - tworzyć proste **tabele tymczasowe** dla skomplikowanych analiz.

4. **Przekładać pytanie biznesowe na SQL**:
   - zbudować raport np. „sprzedaż MoM i YoY per kategoria”,
   - przygotować zapytania dostarczające **dane wejściowe do dashboardu** lub modelu ML.

---

## 3. Dla kogo jest ten blok?

Ten blok jest dla Ciebie, jeśli:

- znasz już podstawy SQL (SELECT, WHERE, JOIN, GROUP BY, HAVING),
- chcesz zacząć pisać **bardziej zaawansowane zapytania**, a nie tylko proste „sumuj po kolumnie”.

Poziom: **2/5** – poziom wczesny-średnio zaawansowany, nadal przyjazny dla osób po podstawach.

---

## 4. Wymagania wstępne

Żeby czuć się komfortowo na tym bloku, powinieneś/powinnaś:

- umieć napisać prosty `SELECT` z:
  - filtrowaniem (`WHERE`),
  - sortowaniem (`ORDER BY`),
  - prostymi agregacjami (`SUM`, `COUNT`, `AVG`),
  - `GROUP BY` i `HAVING`,
  - prostymi `JOIN` (INNER/LEFT) między 2–3 tabelami,
- mieć **działającą instancję PostgreSQL** oraz narzędzie do łączenia się z bazą (`DBeaver`).

---

## 5. Środowisko i narzędzia

### 5.1. Co będziemy używać?

- **PostgreSQL** w wersji 13+ (rekomendowane 15/16),
- narzędzie klienckie do SQL (`DBeaver`),
- pliki dostarczone w ramach kursu:
  - `cwiczenia_sql_clean.sql` – zadania do samodzielnego wykonania,
  - `cwiczenia_sql_solved.sql` – rozwiązania (dla Ciebie po zajęciach).

---

## 6. Instalacja – krok po kroku

**Uwaga**: spróbuj wykonać te kroki przed zajęciami.

### 6.1. Utwórz bazę danych do ćwiczeń

1. Połącz się z serwerem PostgreSQL.
2. Utwórz nową bazę danych, np. o nazwie `ecommerce_analytics`.
3. Otwórz plik, który dostaniesz w ramach kursu z definicją schematu i danymi (np. `setup_ecommerce_analytics.sql` – nazwa może się nieznacznie różnić).
4. Uruchom cały skrypt w nowej bazie (w `DBeaver`).

### 6.2. Przetestuj połączenie

W swoim narzędziu do SQL uruchom testowy SELECT, np.:

~~~sql
SELECT *
FROM orders
LIMIT 5;
~~~

Jeśli widzisz kilka wierszy z tabeli `orders`, wszystko jest OK.

Jeśli napotkasz problemy:

- brak połączenia: sprawdź, czy PostgreSQL jest uruchomiony,
- błąd uprawnień: upewnij się, że jesteś podłączony do właściwej bazy (`ecommerce_analytics`),
- błąd „relation does not exist”: skrypt z tworzeniem tabel prawdopodobnie się nie wykonał – uruchom go jeszcze raz.

---

## 7. Opis danych, na których będziemy pracować

W tym bloku korzystamy z jednej bazy danych, która symuluje **sklep internetowy**.

Najważniejsze tabele:

1. **`customers`** – klienci
   - `customer_id` – identyfikator klienta,
   - `customer_created_at` – data rejestracji,
   - `country`, `city` – lokalizacja klienta,
   - `marketing_channel` – główne źródło pozyskania (np. organic, ads, referral).
   - Zastosowanie: segmentacja klientów, analiza kanałów marketingowych.

2. **`products`** – produkty
   - `product_id` – identyfikator produktu,
   - `category`, `sub_category` – kategoria i podkategoria,
   - `price` – cena katalogowa.
   - Zastosowanie: analiza sprzedaży po kategoriach, top produkty.

3. **`orders`** – zamówienia
   - `order_id` – identyfikator zamówienia,
   - `customer_id` – klient (powiązanie z `customers`),
   - `order_date` – data zamówienia,
   - `order_status` – status (completed, cancelled, itp.),
   - `payment_method` – metoda płatności.
   - Zastosowanie: analiza liczby zamówień w czasie, MoM/YoY, retencja klientów.

4. **`order_items`** – pozycje zamówień
   - `order_item_id` – identyfikator pozycji,
   - `order_id` – powiązanie z `orders`,
   - `product_id` – powiązanie z `products`,
   - `quantity` – liczba sztuk,
   - `unit_price` – cena w momencie zakupu,
   - `discount` – rabat (kwotowo lub procentowo).
   - Zastosowanie: analiza wartości koszyka, marży, top produktów.

5. **`traffic_sessions`** – sesje na stronie
   - `session_id` – identyfikator sesji,
   - `customer_id` – klient (jeśli zalogowany),
   - `session_start` – czas rozpoczęcia sesji,
   - `utm_source`, `utm_campaign` – źródło ruchu i kampania,
   - `device_type` – typ urządzenia (mobile/desktop/tablet).
   - Zastosowanie: powiązanie ruchu na stronie z zamówieniami, efektywność kampanii.

6. **`marketing_campaigns`** (opcjonalna)
   - `campaign_id`, `campaign_name`, `start_date`, `end_date`, `channel`.
   - Zastosowanie: raporty marketingowe.

---

## 8. Jak będziemy pracować na zajęciach?

Balans: **30% teoria, 70% praktyka**

- Krótkie wprowadzenie teoretyczne (max 10–20 min) → **od razu ćwiczenia**.
- Dużo **mikroćwiczeń** (5–10 min), żeby „oswoić” składnię.
- Kilka **większych zadań warsztatowych** (15–25 min) – mini-raporty.
- Na koniec dnia – **1–2 zadania „raportowe”** (mini-projekt SQL).

Przykładowe aktywności:

- samodzielne pisanie zapytań w Twoim narzędziu SQL,
- praca w małych grupach nad trudniejszym zadaniem,
- omawianie różnych rozwiązań tego samego problemu.

---

## 9. Zadanie domowe (skrót)

Po bloku dostaniesz **1–2 zadania domowe**, zaprojektowane tak, aby utrwalić:

- funkcje okna,
- podzapytania,
- CTE.

Przykładowy typ zadania:

> Przygotuj raport miesięcznej sprzedaży dla wybranej kategorii produktów, który pokaże:
> - sprzedaż w danym miesiącu,
> - sprzedaż poprzedniego miesiąca,
> - procentową zmianę (MoM),
> - udział tej kategorii w całkowitej sprzedaży,
> - segment klientów wg percentyla wartości zamówień.

W zadaniu domowym będziesz musieć użyć:

- co najmniej **2 funkcji okna**,
- **jednego CTE** (`WITH`),
- przynajmniej **jednego podzapytania**.

---

## 10. Jak się przygotować do bloku?

Rekomendacja (na dzień przed zajęciami):

1. Sprawdź, czy:
   - możesz uruchomić PostgreSQL,
   - potrafisz połączyć się z bazą w wybranym narzędziu.
2. Przypomnij sobie:
   - `JOIN` (INNER, LEFT),
   - `GROUP BY`, `HAVING`,
   - proste agregacje (`SUM`, `COUNT`, `AVG`).

To naprawdę pomaga wejść w blok bez stresu technicznego.

---

## 11. Typowe problemy i jak sobie z nimi radzić

1. **„Nie działa mi połączenie do bazy”**
   - sprawdź, czy PostgreSQL jest uruchomiony,
   - upewnij się, że korzystasz z poprawnych danych (host, port, baza, użytkownik, hasło),
   - jeśli korzystasz z VPN lub sieci firmowej, może być potrzebna dodatkowa konfiguracja – zgłoś to prowadzącemu.

2. **„Dostaję błąd: relation 'orders' does not exist”**
   - prawdopodobnie skrypt inicjalizujący bazę się nie wykonał,
   - upewnij się, że uruchomiłeś skrypt w bazie `ecommerce_analytics`, a nie w `postgres` itp.

3. **„Moje zapytanie nic nie zwraca”**
   - sprawdź warunki `WHERE` – czy nie są zbyt restrykcyjne,
   - spróbuj tymczasowo usunąć część filtrów i zobacz, co się stanie.

4. **„Nie rozumiem wyników funkcji okna”**
   - spójrz na **mały fragment danych** (np. 5–10 wierszy),
   - dodaj do zapytania:
     - kolumny, po których sortujesz,
     - kolumny, po których dzielisz (`PARTITION BY`),
   - często pomaga dosłownie przepisać wyniki funkcji okna „na kartce”.

5. **„Boje się, że inne osoby są ‘szybsze’ ode mnie”**
   - tempo grupy jest różne – to normalne,
   - staraj się zrozumieć **ideę** na prostszym przykładzie, zamiast kopiować długie zapytania,
   - pytaj śmiało – to najlepszy moment, żeby wyjaśnić wątpliwości.

---

## 12. Jak ten blok pomoże Ci w projekcie końcowym?

W projekcie końcowym będziesz potrzebować:

- przygotować dane wejściowe (features, wskaźniki),
- znać sposób liczenia wskaźników w SQL (a nie tylko w Excelu / Pythonie),
- umieć zbudować **raport z kilku etapów agregacji**.

Ten blok:

- daje Ci narzędzia do zbudowania **pełnych zapytań analitycznych** (od surowych danych po raport),
- pomaga zrozumieć, jak z danych transakcyjnych zrobić np. cechy klienta (częstotliwość zakupów, średnia wartość koszyka, segment wg percentyla).

---

## 13. Co warto zapamiętać z tego bloku?

- Funkcje okna **nie zmieniają liczby wierszy** – działają „po wierszu”, ale liczą coś „w grupie”.
- `ROW_NUMBER`, `RANK`, `DENSE_RANK` – podobne nazwy, ale różne zachowanie przy remisach.
- `LAG` i `LEAD` to Twoi przyjaciele przy analizie czasowej (MoM, YoY, zmiany).
- CTE (`WITH`) to sposób na **czytelne i wieloetapowe** zapytania.
- SQL to nie tylko „pobierz tabelkę”, ale też pełnoprawne narzędzie do **analizy i raportowania**.

Do zobaczenia na bloku – resztę zrobimy już wspólnie na danych!