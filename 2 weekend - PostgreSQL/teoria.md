# SQL – Podstawowa składnia (kompendium do bloku 2)

## 1. Po co nam SQL w pracy z danymi?

**SQL (Structured Query Language)** to standardowy język do pracy z relacyjnymi bazami danych (np. PostgreSQL).  
W pracy data scientist SQL jest używany przede wszystkim do:

- **zadawania pytań biznesowych do danych** (np. „ilu mieliśmy klientów w 2023?”),
- **wyciągania danych** do raportów, dashboardów, Excela, Pythona,
- **budowania cech (features)** do modeli machine learning.

W tym bloku skupiamy się na tym, jak:

- czytać dane (`SELECT`),
- filtrować dane (`WHERE`),
- liczyć agregaty (`GROUP BY`),
- łączyć tabele (`JOIN`),
- łączyć wyniki (`UNION`, `INTERSECT` itd.),
- zapisywać zapytania jako widoki (`VIEW`).

---

## 2. Podział języka SQL – wysokopoziomowy obraz

SQL to nie tylko `SELECT`. Podstawowe kategorie:

- **DDL (Data Definition Language)** – definicja struktury:
  - `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`, `CREATE VIEW` itd.
- **DML (Data Manipulation Language)** – zmiana danych:
  - `INSERT`, `UPDATE`, `DELETE`, czasem `MERGE`.
- **DQL (Data Query Language)** – odpytywanie danych:
  - `SELECT` (z różnymi klauzulami: `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`…).
- **DCL (Data Control Language)** – uprawnienia:
  - `GRANT`, `REVOKE`.
- **TCL (Transaction Control Language)** – transakcje:
  - `COMMIT`, `ROLLBACK`, `SAVEPOINT`.

W tym bloku skupiamy się prawie wyłącznie na **DQL** (czyli `SELECT`) oraz częściowo na `CREATE VIEW` z DDL.

---

## 3. Składnia zapytania SELECT

Najprostsze zapytanie:

~~~sql
SELECT
    kolumna1,
    kolumna2
FROM tabela;
~~~

Typowa pełniejsza struktura (kolejność „pisania”):

~~~sql
SELECT
    ...
FROM ...
JOIN ... ON ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...
LIMIT ...;
~~~

**Kolejność logicznego wykonania** jest inna (uproszczenie):

1. `FROM` (+ `JOIN`)
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`
6. `ORDER BY`
7. `LIMIT`

To tłumaczy, czemu np. w `WHERE` nie możemy używać aliasu z `SELECT` (ale w `ORDER BY` już tak – bo wykonuje się później).

---

## 4. Nazwy tabel, aliasy i formatowanie

### 4.1. Nazwy tabel i kolumn

- W PostgreSQL nazwy zwykle piszemy **małymi literami z podkreśleniami**, np. `olist_orders`, `customer_id`.
- Nazwy tabel i kolumn **bez cudzysłowów** są traktowane jako małe litery.

Lepsze: `order_purchase_timestamp` niż `orderPurchaseTimestamp` – SQL preferuje styl `snake_case`.

### 4.2. Aliasy tabel

Alias tabeli to „skrót”, dzięki któremu:

- unikamy długiego pisania,
- rozróżniamy kolumny z kilku tabel.

~~~sql
SELECT
    c.customer_id,
    o.order_id
FROM olist_customers AS c
JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;
~~~

Często `AS` można pominąć:

~~~sql
FROM olist_customers c
~~~

**Dobra praktyka:** aliasy czytelne – `c` dla customers, `o` dla orders, `p` dla products.

### 4.3. Aliasy kolumn

Alias kolumny to nazwa, pod którą kolumna występuje w wyniku:

~~~sql
SELECT
    COUNT(*) AS orders_cnt,
    AVG(payment_value) AS avg_order_value
FROM olist_order_payments;
~~~

**Dobra praktyka:** aliasy po angielsku, opisowe (`orders_cnt`, `avg_order_value`), bez spacji.

### 4.4. Formatowanie

Rekomendowany styl:

- słowa kluczowe SQL **wielkimi literami**: `SELECT`, `FROM`, `WHERE`, `AND`…
- jedna klauzula na linię,
- wcięcia (4 spacje) przy listach kolumn i warunkach.

Przykład:

~~~sql
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    c.customer_city
FROM olist_orders AS o
JOIN olist_customers AS c
    ON c.customer_id = o.customer_id
WHERE c.customer_state = 'SP'
ORDER BY o.order_purchase_timestamp DESC
LIMIT 10;
~~~

---

## 5. Typy danych w PostgreSQL (podstawy)

Najważniejsze typy, z którymi pracujemy w tym bloku:

### 5.1. Typy numeryczne

- **Całkowite**:
  - `INTEGER`, `BIGINT` – liczby bez części ułamkowej (np. liczba zamówień).
- **Dokładne z kropką dziesiętną**:
  - `NUMERIC(10,2)` / `DECIMAL(10,2)` – np. kwoty pieniędzy; dokładne.
- **Przybliżone** (pływające):
  - `REAL`, `DOUBLE PRECISION` – używane rzadziej w raportowaniu; dokładność przybliżona.

W praktyce dla pieniędzy używamy zwykle `NUMERIC` / `DECIMAL`.

### 5.2. Typy daty i czasu

- `DATE` – data bez czasu (np. 2023-12-31),
- `TIME` – czas bez daty (rzadziej używany),
- `TIMESTAMP` – data + czas (np. 2023-12-31 23:59:59).

W `olist_orders` kluczowe są kolumny typu `TIMESTAMP`, np. `order_purchase_timestamp`.

### 5.3. Typy tekstowe

- `TEXT` – tekst dowolnej długości,
- `VARCHAR(n)` – tekst o maksymalnej długości `n`,
- `CHAR(n)` – tekst „o stałej długości” (rzadziej używany).

W praktyce często używa się po prostu `TEXT`.

### 5.4. Typy binarne

- `BYTEA` – dane binarne (zdjęcia, pliki).  
W tym bloku wspominamy tylko koncepcyjnie – nie pracujemy z nimi.

### 5.5. NULL – brak wartości

`NULL` oznacza **brak wartości** (nie zero, nie pusty string).  
Najczęściej pojawia się, kiedy:

- brakuje daty (np. `order_delivered_customer_date` jeszcze nieznana),
- wartość nie została uzupełniona.

**Kluczowe zasady:**

- `NULL` nie równa się niczemu, nawet `NULL` – porównania z `NULL` dają `UNKNOWN`.
- Zamiast `=` / `<>` używamy `IS NULL` / `IS NOT NULL`.

~~~sql
SELECT
    order_id
FROM olist_orders
WHERE order_delivered_customer_date IS NULL;
~~~

---

## 6. Operatory w SQL

### 6.1. Operatory arytmetyczne

- `+`, `-`, `*`, `/` – suma, różnica, iloczyn, iloraz.

Przykład – wyliczenie wartości pozycji zamówienia:

~~~sql
SELECT
    order_id,
    price,
    freight_value,
    price + freight_value AS item_total
FROM olist_order_items;
~~~

### 6.2. Operatory porównujące

- `=` – równe,
- `<>` lub `!=` – różne,
- `<`, `>`, `<=`, `>=`.

Przykład:

~~~sql
WHERE payment_value >= 100
~~~

### 6.3. Operatory logiczne

- `AND` – oba warunki muszą być spełnione,
- `OR` – wystarczy jeden z warunków,
- `NOT` – negacja.

Przykład:

~~~sql
WHERE
    customer_state = 'SP'
    AND order_status = 'delivered'
~~~

Uwaga na nawiasy – `AND` ma wyższy priorytet niż `OR`.

### 6.4. Dodatkowe operatory / słowa kluczowe

- `IN (lista)` – skrót dla wielu `OR`:
  - `customer_state IN ('SP', 'RJ', 'MG')`
- `BETWEEN a AND b` – zakres (łącznie z końcami):
  - `payment_value BETWEEN 100 AND 200`
- `LIKE`, `ILIKE` – dopasowanie do wzorca tekstowego (z `%` i `_`):
  - `product_category_name LIKE 'toys%'`
- `IS NULL`, `IS NOT NULL` – praca z brakami danych.

---

## 7. Funkcje agregujące i grupowanie

Funkcje agregujące „składają” wiele wierszy w jeden wynik:

- `COUNT(*)` – liczba wierszy,
- `COUNT(kolumna)` – liczba nie-NULL w danej kolumnie,
- `COUNT(DISTINCT kolumna)` – liczba unikalnych wartości,
- `SUM(kolumna)` – suma,
- `AVG(kolumna)` – średnia,
- `MIN(kolumna)` – minimum,
- `MAX(kolumna)` – maksimum.

### 7.1. `GROUP BY`

Bez `GROUP BY` agregacja liczy po całej tabeli.  
Z `GROUP BY` – osobno dla każdej grupy wartości.

Przykład – średnia wartość płatności na typ płatności:

~~~sql
SELECT
    payment_type,
    COUNT(*) AS payments_cnt,
    AVG(payment_value) AS avg_payment
FROM olist_order_payments
GROUP BY payment_type
ORDER BY avg_payment DESC;
~~~

Zasada: wszystkie kolumny w `SELECT`, które **nie** są agregatami, muszą być w `GROUP BY`.

### 7.2. `HAVING`

`HAVING` filtruje **grupy**, a nie pojedyncze wiersze.

Przykład – typy płatności, dla których jest co najmniej 1000 płatności:

~~~sql
SELECT
    payment_type,
    COUNT(*) AS payments_cnt
FROM olist_order_payments
GROUP BY payment_type
HAVING COUNT(*) >= 1000;
~~~

Porównanie:

- `WHERE` – filtr przed agregacją (na wierszach),
- `HAVING` – filtr po agregacji (na grupach).

---

## 8. Funkcje skalarskie (działające na pojedynczych wartościach)

Funkcje skalarskie stosujemy zwykle w `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`.

### 8.1. Funkcje tekstowe

- `UPPER(tekst)` – wielkie litery,
- `LOWER(tekst)` – małe litery,
- `LENGTH(tekst)` – długość tekstu (liczba znaków),
- `LEFT(tekst, n)` – pierwsze `n` znaków,
- `RIGHT(tekst, n)` – ostatnie `n` znaków,
- `REPLACE(tekst, 'stare', 'nowe')` – zamienia „stare” na „nowe”,
- `LTRIM(tekst)` / `RTRIM(tekst)` – usuwanie znaków z lewej / prawej (domyślnie spacje).

Przykład – uproszczona nazwa kategorii:

~~~sql
SELECT
    product_category_name,
    UPPER(product_category_name) AS category_upper,
    LEFT(product_category_name, 3) AS category_prefix
FROM olist_products
LIMIT 10;
~~~

### 8.2. Funkcje numeryczne

- `ABS(x)` – wartość bezwzględna,
- `ROUND(x, n)` – zaokrąglenie do `n` miejsc po przecinku.

Przykład:

~~~sql
SELECT
    payment_value,
    ROUND(payment_value, 2) AS payment_rounded
FROM olist_order_payments
LIMIT 10;
~~~

### 8.3. Funkcje daty i czasu

- `DATE_PART('year', ts)` – rok,
- `DATE_PART('month', ts)` – miesiąc,
- `DATE_PART('dow', ts)` – dzień tygodnia (0–6),
- `TO_CHAR(ts, 'YYYY-MM')` – sformatowanie daty do tekstu.

Przykład – rok i miesiąc zakupu:

~~~sql
SELECT
    order_id,
    DATE_PART('year', order_purchase_timestamp) AS purchase_year,
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS purchase_ym
FROM olist_orders
LIMIT 10;
~~~

### 8.4. Obsługa NULL: `COALESCE`, `NULLIF`

- `COALESCE(a, b, c, ...)` – zwraca pierwszy argument nie będący `NULL`.

  Przykład – użyj daty dostawy, a jeśli jej nie ma – planowanej:

  ~~~sql
  SELECT
      order_id,
      COALESCE(order_delivered_customer_date, order_estimated_delivery_date) AS delivery_date_effective
  FROM olist_orders;
  ~~~

- `NULLIF(a, b)` – zwraca `NULL`, jeśli `a = b`, inaczej `a`.  
  Może być użyte np. do uniknięcia dzielenia przez zero.

### 8.5. `GREATEST`, `LEAST`

- `GREATEST(a, b, c, ...)` – największa z wartości,
- `LEAST(a, b, c, ...)` – najmniejsza.

Przykład – najpóźniejsza znana data etapu zamówienia:

~~~sql
SELECT
    order_id,
    GREATEST(
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_customer_date
    ) AS last_event_timestamp
FROM olist_orders;
~~~

---

## 9. Instrukcja warunkowa CASE

`CASE` to odpowiednik „if/else” w SQL – umożliwia warunkowe tworzenie wartości.

### 9.1. CASE w SELECT

Najczęstsza forma (tzw. „searched CASE”):

~~~sql
SELECT
    order_id,
    payment_value,
    CASE
        WHEN payment_value < 100 THEN 'small'
        WHEN payment_value BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END AS order_size_segment
FROM olist_order_payments;
~~~

Możemy potem zagregować po segmencie:

~~~sql
SELECT
    CASE
        WHEN payment_value < 100 THEN 'small'
        WHEN payment_value BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END AS order_size_segment,
    COUNT(*) AS orders_cnt
FROM olist_order_payments
GROUP BY order_size_segment;
~~~

### 9.2. CASE w ORDER BY

`CASE` można użyć również w `ORDER BY`, np. ustawiając własną kolejność kategorii:

~~~sql
ORDER BY
    CASE
        WHEN order_status = 'delivered' THEN 1
        WHEN order_status = 'shipped' THEN 2
        WHEN order_status = 'canceled' THEN 3
        ELSE 4
    END;
~~~

---

## 10. Łączenie tabel – JOIN

Relacyjna baza danych przechowuje dane w wielu tabelach połączonych przez **klucze**:

- klucz główny (primary key),
- klucz obcy (foreign key).

Przykład w naszym schemacie:

- `olist_orders.customer_id` → `olist_customers.customer_id`,
- `olist_order_items.order_id` → `olist_orders.order_id`,
- `olist_order_items.product_id` → `olist_products.product_id`.

### 10.1. INNER JOIN

Zwraca **tylko wiersze mające dopasowanie po obu stronach**.

~~~sql
SELECT
    o.order_id,
    c.customer_city
FROM olist_orders AS o
INNER JOIN olist_customers AS c
    ON o.customer_id = c.customer_id;
~~~

### 10.2. LEFT JOIN

Zwraca **wszystkie wiersze z lewej tabeli**, a dopasowane wiersze z prawej – jeśli ich nie ma, dostaniemy `NULL`.

~~~sql
SELECT
    c.customer_id,
    o.order_id
FROM olist_customers AS c
LEFT JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;
~~~

Możemy znaleźć klientów bez zamówień:

~~~sql
WHERE o.order_id IS NULL;
~~~

### 10.3. RIGHT JOIN

Odwrotność `LEFT JOIN` – wszystkie wiersze z prawej tabeli, `NULL` dla braku dopasowania z lewej.  
W praktyce częściej używamy `LEFT JOIN`, `RIGHT JOIN` rzadziej.

### 10.4. FULL JOIN

`FULL [OUTER] JOIN` – wszystkie wiersze z obu tabel, `NULL` w miejscach bez dopasowania.

Przydatne przy analizie „sierot” po obu stronach (rekordy bez pary).

### 10.5. CROSS JOIN

Tworzy **iloczyn kartezjański** – każda kombinacja wiersza z lewej i prawej tabeli.

Używamy rzadko i ostrożnie – liczba wierszy rośnie bardzo szybko.  
Może być przydatne do tworzenia „szkieletu raportu”, np. wszystkie kombinacje miesięcy i kategorii.

### 10.6. JOIN kilku tabel naraz

Możemy łączyć wiele tabel w jednym zapytaniu:

~~~sql
SELECT
    o.order_id,
    c.customer_city,
    p.product_category_name,
    oi.price
FROM olist_orders AS o
JOIN olist_customers AS c
    ON o.customer_id = c.customer_id
JOIN olist_order_items AS oi
    ON o.order_id = oi.order_id
JOIN olist_products AS p
    ON oi.product_id = p.product_id;
~~~

Dobra praktyka: dodawać po jednej tabeli naraz, sprawdzać wynik krok po kroku.

---

## 11. Łączenie zbiorów – UNION, UNION ALL, EXCEPT, INTERSECT

Te operatory łączą **wyniki dwóch zapytań**, a nie tabele.

Wymagania:

- oba zapytania muszą zwracać **tę samą liczbę kolumn**,
- typy danych na tych samych pozycjach muszą być kompatybilne.

### 11.1. UNION i UNION ALL

- `UNION` – suma zbiorów **z usunięciem duplikatów**,
- `UNION ALL` – suma zbiorów **z pozostawieniem duplikatów**.

Przykład – listy klientów z dwóch okresów:

~~~sql
SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-01-01'

UNION

SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2018-01-01'
  AND order_purchase_timestamp < '2019-01-01';
~~~

### 11.2. EXCEPT

Zbiór wierszy, które są w pierwszym zapytaniu, ale **nie** ma ich w drugim.

Przykład – klienci, którzy kupowali w 2017, ale nie w 2018:

~~~sql
SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-01-01'

EXCEPT

SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2018-01-01'
  AND order_purchase_timestamp < '2019-01-01';
~~~

### 11.3. INTERSECT

Wspólna część zbiorów – klienci obecni w obu rezultatów.

Przykład – klienci, którzy kupowali zarówno w 2017, jak i 2018:

~~~sql
SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-01-01'

INTERSECT

SELECT DISTINCT customer_id
FROM olist_orders
WHERE order_purchase_timestamp >= '2018-01-01'
  AND order_purchase_timestamp < '2019-01-01';
~~~

---

## 12. Widoki – zapisane zapytania

**Widok (VIEW)** to zapisane zapytanie SQL, które można traktować jak „wirtualną tabelę”.

### 12.1. CREATE VIEW

Przykład – widok dziennego przychodu:

~~~sql
CREATE VIEW olist_daily_revenue AS
SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    SUM(oi.price + oi.freight_value) AS daily_revenue
FROM olist_orders AS o
JOIN olist_order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY DATE(o.order_purchase_timestamp);
~~~

Teraz możemy użyć widoku jak tabeli:

~~~sql
SELECT
    order_date,
    daily_revenue
FROM olist_daily_revenue
ORDER BY order_date;
~~~

### 12.2. DROP VIEW

Usunięcie widoku:

~~~sql
DROP VIEW olist_daily_revenue;
~~~

### 12.3. Dobre praktyki dla widoków

- Czytelna nazwa (`olist_daily_revenue`, `olist_customer_metrics`),
- Logika, którą faktycznie wielokrotnie wykorzystujesz,
- Traktowanie widoku jak „warstwy analitycznej” – spójne KPI w organizacji.

---

## 13. Dobre praktyki – ściąga

Na koniec krótka lista rzeczy, które warto zapamiętać:

1. **Formatuj zapytania** – jedna klauzula na linijkę, wcięcia, słowa kluczowe wielkimi literami.
2. **Aliasuj tabele** – szczególnie przy JOIN-ach (np. `c` dla customers, `o` dla orders).
3. **Uważaj na NULL** – używaj `IS NULL` / `IS NOT NULL`, `COALESCE`.
4. **Zaczynaj prosto** – najpierw `SELECT ... FROM`, dopiero potem dokładanie `WHERE`, `JOIN`, `GROUP BY`.
5. **Sprawdzaj pośrednie wyniki** – np. najpierw zapytanie z jednym JOIN-em, potem dopiero agregacja.
6. **Używaj opisowych aliasów** – `avg_order_value`, `orders_cnt`, `order_size_segment`.
7. **Rozróżniaj UNION i UNION ALL** – czy chcesz usuwać duplikaty, czy nie.
8. **Widoki twórz, gdy logika jest powtarzalna** – nie dla „jednorazowego” zapytania.

To kompendium ma być dla Ciebie „mapą” w trakcie ćwiczeń – nie musisz wszystkiego zapamiętać od razu.  
W trakcie bloku będziesz wielokrotnie wracać do tych elementów w praktyce na danych `olist`.

---