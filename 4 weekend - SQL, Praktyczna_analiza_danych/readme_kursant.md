# Blok 4: Praktyczna analiza danych z wykorzystaniem SQL

## 1. O czym jest ten blok?

To blok, w którym **robimy „prawdziwą analizę danych” w SQL** – taką, jaką wykonuje się w firmach, gdy trzeba szybko odpowiedzieć na pytania biznesowe, przygotować liczby do raportu albo znaleźć anomalię w danych.

Będziemy pracować na realnym zbiorze danych e‑commerce (**Olist**), a cały blok jest zorganizowany jako seria zadań (od prostych do bardziej zaawansowanych). W trakcie ćwiczeń po drodze dotkniemy m.in.:

- eksploracji danych i sanity-checków (czy dane w ogóle „mają sens”),
- łączenia wielu tabel (JOIN),
- agregacji, metryk i segmentacji,
- podzapytań i CTE,
- funkcji daty/czasu i CASE,
- funkcji okna (window functions) w kontekście rankingu i sum narastających,
- podstaw optymalizacji (indeksy, `EXPLAIN`).

Blok ma charakter **warsztatowy**: większość czasu to samodzielna praca nad zadaniami + omówienia.

---

## 2. Po tym bloku będziesz umieć…

Po ukończeniu tego bloku będziesz potrafić:

1. **Szybko rozeznać się w nowych danych**:
   - policzyć podstawowe wolumeny, sprawdzić zakresy dat, statusy, braki danych,
   - znaleźć podejrzane rekordy (np. duplikaty, nietypowe wartości).

2. **Łączyć tabele i budować spójny „widok analityczny”**:
   - poprawnie dobierać klucze JOIN i kontrolować krotność połączeń,
   - unikać podwójnego liczenia w agregacjach.

3. **Liczyć metryki biznesowe w SQL**:
   - wartości zamówień, koszty dostawy, średnie, mediany/percentyle (tam gdzie użyjemy okien),
   - porównywać grupy (np. stany, kategorie produktów, sprzedawcy).

4. **Stosować narzędzia, które upraszczają złożone zapytania**:
   - podzapytania,
   - CTE (`WITH`),
   - `CASE WHEN`,
   - funkcje daty i czasu.

5. **Rozumieć podstawy wydajności**:
   - kiedy indeks ma sens,
   - jak czytać `EXPLAIN` na poziomie „co boli i dlaczego”.

---

## 3. Dla kogo jest ten blok?

Ten blok jest dla Ciebie, jeśli:

- znasz podstawy SQL (SELECT/WHERE/JOIN/GROUP BY),
- chcesz przećwiczyć **praktyczne** scenariusze analityczne,
- potrzebujesz poczuć się pewniej w pracy z większą liczbą tabel i realnymi danymi.

---

## 4. Wymagania wstępne

Zakładamy, że potrafisz:

- napisać `SELECT` z filtrowaniem (`WHERE`, `IN`, `LIKE`),
- zrobić podstawowe `JOIN` i zrozumieć różnicę między `INNER` i `LEFT`,
- użyć agregacji (`COUNT`, `SUM`, `AVG`) + `GROUP BY`,
- sortować (`ORDER BY`) i limitować (`LIMIT`).

Jeśli te elementy są jeszcze „niestabilne” – to super moment, żeby je utrwalić (w tym bloku będzie dużo powtórek w praktyce).

---

## 5. Środowisko i narzędzia

### 5.1. Co będziemy używać?

- **PostgreSQL** (lokalnie)
- klient SQL: **DBeaver**
- pliki do ćwiczeń:
  - `cwiczenia_sql_clean.sql` – treści zadań,
  - `cwicenia_sql_solved.sql` – przykładowe rozwiązania (korzystaj dopiero po własnej próbie).

---

## 6. Instalacja – krok po kroku

Poniższe kroki są napisane pod **DBeavera**, bo najłatwiej na nim ogarnąć import CSV.

### 6.1. Utwórz bazę danych do ćwiczeń

1. Uruchom PostgreSQL.
2. Utwórz nową bazę danych, np. `ecommerce_sql`.
3. W DBeaverze dodaj połączenie do tej bazy (host/port/login zgodnie z Twoją instalacją).

### 6.2. Zaimportuj dane

Dane są w plikach CSV (dataset Olist). W DBeaverze możesz:

- utworzyć tabelę „z importu” (Create new table),
- albo zaimportować do już istniejącej tabeli (jeśli masz przygotowany schemat).

**Ważne:** zwróć uwagę na kolumny typu `timestamp` (format `YYYY-MM-DD HH:MI:SS`). Przy imporcie ustaw im typ `timestamp`, a nie `varchar`.

Pliki, w których szczególnie często występują kolumny datowe/czasowe (zwykle w nazwie mają `date` albo `timestamp`):

- `olist_order_items_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `olist_orders_dataset.csv`

### 6.3. Przetestuj, czy wszystko działa

Wykonaj w swojej bazie:

```sql
SELECT COUNT(*) FROM olist_orders_dataset;
```

Jeśli zwraca liczbę – jesteś gotowa/-y do pracy.

---

## 7. Opis danych, na których będziemy pracować

Pracujemy na danych e‑commerce (Olist). W praktyce zobaczysz kilka tabel, m.in.:

- `olist_orders_dataset` – zamówienia + statusy i timestampy,
- `olist_customers_dataset` – klienci (z informacją o stanie/regionie),
- `olist_order_items_dataset` – pozycje zamówień (produkty, sprzedawcy, ceny, dostawa),
- `olist_order_payments_dataset` – płatności (typ, raty, kwota),
- `olist_products_dataset` – produkty (wymiary, waga, kategoria),
- `olist_product_category_name_translation` – tłumaczenia kategorii,
- `olist_sellers_dataset` – sprzedawcy,
- `olist_order_reviews_dataset` – recenzje,
- `olist_geolocation_dataset` – geolokalizacja po kodzie pocztowym (prefix).

Najważniejsze identyfikatory, które będą się przewijać:

- `order_id` – klucz zamówienia,
- `customer_id` / `customer_unique_id` – klient,
- `product_id` – produkt,
- `seller_id` – sprzedawca,
- `customer_zip_code_prefix` – prefix kodu pocztowego (łączenie z geolokalizacją).

---

## 8. Jak będziemy pracować na zajęciach?

1. **Start:** szybki sanity-check danych (pierwsze zadania).
2. **Główna część:** rozwiązujecie zadania z `cwiczenia_sql_clean.sql` (kolejność ma znaczenie – stopniujemy trudność).
3. **Check‑pointy:** co jakiś czas robimy krótkie omówienie „wzorcowych” podejść.

W trakcie pracy zwracaj uwagę na:

- krotność JOIN (czy przypadkiem nie „mnożysz” rekordów),
- jawne aliasy i formatowanie zapytań,
- kontrolę wyników na małych próbkach (`LIMIT`, pojedynczy `order_id`).

---

## 9. Zadanie domowe

Wybierz **3–5 zadań** z końcówki listy (np. związanych z oknami/widokami/wydajnością) i przygotuj:

- finalne zapytania,
- krótki komentarz: *co liczę i dlaczego* (2–3 zdania).

---

## 10. Jak się przygotować do bloku?

- Upewnij się, że masz działające połączenie do PostgreSQL.
- Zaimportuj dane **przed zajęciami** (żeby na bloku nie tracić czasu na import).
- Otwórz `cwiczenia_sql_clean.sql` w DBeaverze i przejrzyj spis zadań – zobaczysz, w jakim kierunku idziemy.

---

## 11. Typowe problemy i jak sobie z nimi radzić

**1) Timestamps jako tekst (`varchar`)**  
Objaw: nie da się liczyć różnic dat / sortowanie po dacie jest „dziwne”.  
Rozwiązanie: ustaw typ `timestamp` przy imporcie albo rzutuj: `col::timestamp`.

**2) Złe kodowanie / polskie znaki w kategoriach**  
Rozwiązanie: przy imporcie ustaw `UTF-8`.

**3) Wyniki „za duże” po JOIN**  
Najczęściej to efekt łączenia tabel 1‑do‑wielu bez kontroli.  
Rozwiązanie: sprawdź krotność (`COUNT(*)` vs `COUNT(DISTINCT ...)`), agreguj na właściwym poziomie, testuj na jednym `order_id`.

**4) „Brak tabeli” / inna nazwa**  
Upewnij się, że import stworzył tabelę z dokładną nazwą jak w zadaniach (w PostgreSQL liczy się wielkość liter, jeśli użyto cudzysłowów).

**5) Wydajność**  
Jeśli zapytanie trwa długo: testuj na ograniczonym zakresie (np. `WHERE order_purchase_timestamp >= ...`) i używaj `EXPLAIN`.

---

## 12. Jak ten blok pomoże Ci w projekcie końcowym?

W projekcie końcowym bardzo często:

- trzeba „dociągnąć” dane z kilku tabel,
- policzyć metryki na potrzeby prezentacji,
- znaleźć segmenty i anomalie,
- przygotować dane wejściowe do dalszej analizy w Pythonie.

Ten blok buduje dokładnie tę umiejętność: **zamiana pytań biznesowych na zapytania SQL**, które dają wiarygodne wyniki.

---

## 13. Co warto zapamiętać z tego bloku?

- Zanim policzysz metrykę – upewnij się, że **JOIN nie mnoży rekordów**.
- Buduj zapytania etapami: *CTE → wynik pośredni → finalny SELECT*.
- `CASE WHEN` i funkcje daty/czasu robią 80% roboty w praktyce.
- `EXPLAIN` to nie „magia” – chodzi o to, żeby rozumieć, skąd bierze się koszt.
- W analizie ad‑hoc liczy się powtarzalność: czytelną strukturę zapytań da się potem łatwo przenieść do raportu / notebooka.
