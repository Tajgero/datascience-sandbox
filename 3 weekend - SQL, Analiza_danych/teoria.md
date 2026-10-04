# SQL – Analiza danych

---

## 1. Funkcje okna – po co i o co chodzi?

**Idea**: funkcje okna (window functions) pozwalają liczyć agregaty i inne wartości „w obrębie grupy”, ale **bez utraty szczegółu wierszy**.

Klasyczna agregacja:

- `GROUP BY` – zmienia liczbę wierszy, spłaszcza dane
- widzisz tylko poziom agregacji (np. 1 wiersz na klienta)

Funkcje okna:

- zachowujesz wszystkie wiersze (np. każde zamówienie),
- możesz dodać kolumny typu „suma po kliencie”, „ranking w kategorii”, „wartość z poprzedniego miesiąca”.

Ogólny schemat funkcji okna:

~~~sql
funkcja_okna(...) OVER (
    PARTITION BY ...
    ORDER BY ...
    [ROWS ...]
)
~~~

- `PARTITION BY` – dzieli dane na „okna” (grupy)
- `ORDER BY` – ustala kolejność w ramach każdej grupy
- opcjonalnie: klauzula ramy okna (`ROWS BETWEEN ...`)

---

## 2. Składnia OVER (PARTITION BY, ORDER BY)

### 2.1. PARTITION BY

Dzieli wiersze na grupy. Każda grupa jest niezależnym „oknem”.

Przykład: suma sprzedaży po kliencie, ale przy każdym zamówieniu:

~~~sql
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_value,
    SUM(o.order_value) OVER (
        PARTITION BY o.customer_id
    ) AS customer_total_value
FROM orders o;
~~~

- w każdej grupie (klient) liczymy sumę
- każdy wiersz klienta dostaje tę samą sumę

### 2.2. ORDER BY w OVER

Ustala kolejność wewnątrz okna – potrzebne dla funkcji:

- `ROW_NUMBER`, `RANK`, `DENSE_RANK`
- `LAG`, `LEAD`
- kumulacje (narastająco)

Przykład – suma narastająca (running total) po dacie:

~~~sql
SELECT
    o.order_date::date AS order_date,
    SUM(o.order_value) AS daily_revenue,
    SUM(SUM(o.order_value)) OVER (
        ORDER BY o.order_date::date
    ) AS cum_revenue
FROM orders o
GROUP BY o.order_date::date
ORDER BY o.order_date::date;
~~~

Interpretacja:

- najpierw agregujemy po dacie (klasyczny `GROUP BY`),
- potem na tych wynikach liczymy sumę narastającą.

### 2.3. Ramy okna (ROWS BETWEEN …)

Domyślnie w wielu przypadkach PostgreSQL używa:

- `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`

Możesz to jawnie zmienić. Przykład – średnia krocząca z 3 dni:

~~~sql
AVG(daily_revenue) OVER (
    ORDER BY order_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS moving_avg_3d
~~~

Tu „okno” dla danego wiersza to: bieżący dzień + 2 poprzednie.

---

## 3. Funkcje rangi: ROW_NUMBER, RANK, DENSE_RANK, PERCENT_RANK, CUME_DIST, NTILE

### 3.1. ROW_NUMBER()

Nadaje unikalny numer wiersza w ramach „okna”. Nie uwzględnia remisów.

Przykład – top klienci w kraju:

~~~sql
SELECT
    country,
    customer_id,
    customer_total_value,
    ROW_NUMBER() OVER (
        PARTITION BY country
        ORDER BY customer_total_value DESC
    ) AS rn
FROM customer_stats;
~~~

- `rn = 1` to „największy” klient w kraju (wg wartości).

### 3.2. RANK() i DENSE_RANK()

Używane, gdy istnieją remisy.

- `RANK()` – przy remisach **dziury w numeracji** (1, 2, 2, 4, …)
- `DENSE_RANK()` – numeracja „gęsta” (1, 2, 2, 3, …)

Przykład – ranking produktów w kategorii:

~~~sql
SELECT
    category,
    product_id,
    total_revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS revenue_dense_rank
FROM product_stats;
~~~

### 3.3. PERCENT_RANK() i CUME_DIST()

- `PERCENT_RANK()` – pozycja w skali 0–1, w stylu „jaki odsetek obserwacji jest przede mną”
- `CUME_DIST()` – skumulowany odsetek obserwacji o wartości **nie większej** niż bieżąca

Przykład – pozycja klienta w rozkładzie CLV w kraju:

~~~sql
SELECT
    country,
    customer_id,
    clv,
    PERCENT_RANK() OVER (
        PARTITION BY country
        ORDER BY clv
    ) AS clv_percent_rank,
    CUME_DIST() OVER (
        PARTITION BY country
        ORDER BY clv
    ) AS clv_cume_dist
FROM customer_stats;
~~~

### 3.4. NTILE()

Dzieli dane na „wiadra” (np. kwartyle, decyle).

Przykład – przypisanie klienta do decyla wg CLV:

~~~sql
NTILE(10) OVER (
    ORDER BY clv DESC
) AS clv_decile
~~~

Interpretacja:

- `NTILE(4)` – kwartyle,
- `NTILE(10)` – decyle,
- `NTILE(100)` – percentyle.

---

## 4. LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE

### 4.1. LAG() i LEAD()

Pozwalają odnieść się do wartości z poprzedniego / kolejnego wiersza w oknie.

Składnia:

- `LAG(wyrażenie [, offset, default])`
- `LEAD(wyrażenie [, offset, default])`

Przykład – zmiana sprzedaży w czasie (Month-over-Month):

~~~sql
SELECT
    month,
    revenue,
    LAG(revenue) OVER (
        ORDER BY month
    ) AS prev_month_revenue,
    revenue - LAG(revenue) OVER (
        ORDER BY month
    ) AS abs_change,
    (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) AS pct_change
FROM monthly_revenue;
~~~

Zastosowania:

- MoM / YoY,
- różnica czasu między zdarzeniami (np. kolejnymi zamówieniami klienta),
- analiza trendów.

### 4.2. FIRST_VALUE, LAST_VALUE, NTH_VALUE

Odwołania do „pierwszej/ostatniej/n-tej” wartości w ramach okna.

Przykład – różnica między bieżącą wartością a pierwszą wartością w oknie (np. wzrost od pierwszego zakupu):

~~~sql
FIRST_VALUE(order_date) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
) AS first_order_date
~~~

Uwaga: przy `LAST_VALUE()` ważna jest **rama okna** (`ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`), inaczej możesz dostać „ostatnią dotąd”, a nie „ostatnią w całej grupie”.

---

## 5. Agregaty jako funkcje okna

Te same funkcje co w `GROUP BY`, ale z `OVER()`:

- `SUM(...) OVER (...)`
- `AVG(...) OVER (...)`
- `COUNT(...) OVER (...)`
- `MIN(...) OVER (...)`
- `MAX(...) OVER (...)`

Przykład – udział zamówienia w sumie klienta:

~~~sql
SELECT
    o.order_id,
    o.customer_id,
    o.order_value,
    SUM(o.order_value) OVER (
        PARTITION BY o.customer_id
    ) AS customer_total,
    o.order_value
        / NULLIF(SUM(o.order_value) OVER (
            PARTITION BY o.customer_id
        ), 0) AS order_share_in_customer
FROM orders o;
~~~

Przykład – średnia krocząca po 3 miesiącach:

~~~sql
AVG(month_revenue) OVER (
    ORDER BY month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS revenue_ma_3
~~~

---

## 6. Wskaźniki analityczne: YoY, MoM, udziały

### 6.1. MoM (Month-over-Month)

Pomysł:

1. zrób agregację miesięczną,
2. użyj `LAG()` do poprzedniego miesiąca,
3. policz różnicę i procentową zmianę.

Przykład:

~~~sql
WITH monthly AS (
    SELECT
        date_trunc('month', order_date) AS month,
        SUM(order_value) AS revenue
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY date_trunc('month', order_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS diff_revenue,
    (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) AS pct_change_mom
FROM monthly
ORDER BY month;
~~~

### 6.2. YoY (Year-over-Year)

Analogicznie, ale agregujemy i porównujemy do roku wcześniej (np. korzystając z dat i `LAG` z offsetem 12 miesięcy albo 1 roku w innej tabeli).

### 6.3. Udziały procentowe

Udział kategorii w całości sprzedaży:

~~~sql
SELECT
    category,
    category_revenue,
    category_revenue
        / NULLIF(SUM(category_revenue) OVER (), 0) AS share_total
FROM (
    SELECT
        p.category,
        SUM(oi.unit_price * oi.quantity) AS category_revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.category
) t;
~~~

- `OVER ()` bez `PARTITION BY` – całe okno to „wszyscy” (np. cała suma).

---

## 7. Percentyle i prosta statystyka w PostgreSQL

### 7.1. Percentyle: percentile_disc, percentile_cont

`percentile_disc` – percentyl dyskretny (zwraca istniejącą wartość),  
`percentile_cont` – percentyl ciągły (interpoluje między wartościami).

Składnia:

~~~sql
percentile_disc(0.9) WITHIN GROUP (ORDER BY order_value)
~~~

Przykład – 90. percentyl wartości koszyka:

~~~sql
SELECT
    percentile_disc(0.9)
        WITHIN GROUP (ORDER BY order_value) AS p90_order_value
FROM orders;
~~~

Percentyle per kategoria (przykład z `PARTITION BY`):

~~~sql
SELECT
    category,
    percentile_disc(0.9)
        WITHIN GROUP (ORDER BY order_value) AS p90_order_value
FROM order_values_per_category
GROUP BY category;
~~~

### 7.2. Wariancja i odchylenie standardowe

Typowe funkcje:

- `var_pop(x)` / `var_samp(x)` – wariancja (populacyjna/próby),
- `stddev_pop(x)` / `stddev_samp(x)` – odchylenie standardowe.

Przykład – odchylenie standardowe wartości koszyka:

~~~sql
SELECT
    stddev_samp(order_value) AS std_order_value
FROM orders;
~~~

Możesz również używać tych funkcji jako funkcji okna:

~~~sql
stddev_samp(order_value) OVER (
    PARTITION BY customer_id
) AS customer_order_std
~~~

### 7.3. Korelacja i kowariancja

- `corr(x, y)` – korelacja Pearsona,
- `covar_pop(x, y)` / `covar_samp(x, y)` – kowariancja.

Przykład – korelacja między liczbą pozycji w koszyku a jego wartością:

~~~sql
SELECT
    corr(num_items, order_value) AS corr_items_value
FROM order_stats;
~~~

Interpretacja intuicyjna:

- korelacja bliska 1 → im więcej pozycji, tym wyższa wartość,
- bliska 0 → brak liniowej zależności,
- bliska -1 → im więcej pozycji, tym niższa wartość (rzadko w e-commerce, ale możliwe w innych danych).

---

## 8. Podzapytania – rodzaje i zastosowania

**Podzapytanie** – `SELECT`, który jest użyty wewnątrz innego zapytania.

Może pojawić się w:

- `SELECT`
- `FROM`
- `WHERE`
- `HAVING`
- `ORDER BY`
- `LIMIT`

### 8.1. Podzapytanie w SELECT

Przykład – średnia wartość zamówienia w kraju (prosty wariant):

~~~sql
SELECT
    c.country,
    o.customer_id,
    AVG(o.order_value) AS customer_avg_order_value,
    (
        SELECT AVG(o2.order_value)
        FROM orders o2
        JOIN customers c2 ON c2.customer_id = o2.customer_id
        WHERE c2.country = c.country
    ) AS country_avg_order_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.country, o.customer_id;
~~~

Uwaga: to jest przykład **podzapytania skorelowanego** (odnosi się do `c.country` z zewnętrznego zapytania).

### 8.2. Podzapytanie w FROM (subtable / derived table)

Częsty sposób na „pre-aggregację”:

~~~sql
SELECT
    t.country,
    t.month,
    t.revenue,
    SUM(t.revenue) OVER (PARTITION BY t.country ORDER BY t.month) AS cum_revenue
FROM (
    SELECT
        c.country,
        date_trunc('month', o.order_date) AS month,
        SUM(o.order_value) AS revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.country, date_trunc('month', o.order_date)
) t;
~~~

### 8.3. Podzapytanie w WHERE (IN, EXISTS)

Przykład – klienci, którzy kupili produkty w więcej niż jednej kategorii:

~~~sql
SELECT
    customer_id
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.category) > 1;
~~~

Można też użyć `EXISTS`:

~~~sql
SELECT
    c.customer_id
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= current_date - INTERVAL '90 days'
);
~~~

### 8.4. Podzapytanie w ORDER BY, LIMIT, HAVING

- w `ORDER BY` – np. sortowanie po rankingu z podzapytania,
- w `LIMIT` – np. dynamiczne ograniczanie liczby wierszy (rzadziej stosowane),
- w `HAVING` – np. porównanie agregatu grupy do agregatu globalnego.

Przykład – kategorie powyżej średniej sprzedaży globalnie:

~~~sql
SELECT
    category,
    SUM(revenue) AS category_revenue
FROM category_revenue
GROUP BY category
HAVING SUM(revenue) >
    (
        SELECT AVG(revenue)
        FROM category_revenue
    );
~~~

---

## 9. CTE (Common Table Expressions) – WITH

**CTE** to „tymczasowa nazwana tabela” w obrębie jednego zapytania.

Składnia:

~~~sql
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
~~~

Zalety:

- czytelność – dzielisz zapytanie na logiczne kroki,
- możliwość wielokrotnego użycia tego samego wyniku w jednym zapytaniu,
- łatwiejsze debugowanie (możesz uruchomić samego CTE).

### 9.1. Wieloetapowa analiza z CTE

Przykład – raport miesięcznej sprzedaży z MoM:

~~~sql
WITH monthly AS (
    SELECT
        date_trunc('month', order_date) AS month,
        SUM(order_value) AS revenue
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY date_trunc('month', order_date)
),
monthly_with_change AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly
)
SELECT
    month,
    revenue,
    prev_revenue,
    revenue - prev_revenue AS diff_revenue,
    (revenue - prev_revenue) / NULLIF(prev_revenue, 0) AS pct_change_mom
FROM monthly_with_change
ORDER BY month;
~~~

Możesz użyć wielu CTE w jednym zapytaniu:

~~~sql
WITH cte1 AS (...),
     cte2 AS (...),
     cte3 AS (...)
SELECT ...
FROM cte3;
~~~

---

## 10. Tabele tymczasowe

Tabele tymczasowe (temporary tables) istnieją **tylko w bieżącej sesji**.

Składnia:

~~~sql
CREATE TEMP TABLE temp_name AS
SELECT ...;
~~~

Zastosowania:

- wielokrotne użycie tych samych danych w kilku zapytaniach,
- „cięższe” wstępne przetwarzanie, które nie powinno się powtarzać,
- eksploracja danych (analiza ad-hoc).

Różnice vs CTE:

- CTE:
  - „żyje” tylko w jednym zapytaniu,
  - jest częścią planu zapytania,
  - często czytelniejszy do raportów.
- TEMP TABLE:
  - istnieje przez całą sesję,
  - może być indeksowana,
  - może być używana w wielu kolejnych zapytaniach.

---

## 11. Dobre praktyki przy pisaniu analitycznego SQL

1. **Zawsze jasno definiuj „okrąg” analizy**  
   - filtruj zakres dat (`WHERE order_date >= ...`),  
   - filtruj statusy (np. tylko `order_status = 'completed'`).

2. **Najpierw prosta wersja, potem komplikowanie**  
   - najpierw policz prostą sumę / średnią,
   - dopiero potem dodawaj funkcje okna, percentyle, CTE.

3. **Małe podzbiory do testów**  
   - dodaj tymczasowo `LIMIT 100`,
   - pracuj na 1–2 krajach / kategoriach, żeby łatwiej zrozumieć wyniki.

4. **Czytelność ponad „spryt”**  
   - lepiej 2–3 czytelne CTE niż jeden gigantyczny SELECT zagnieżdżony,
   - używaj aliasów tabel i kolumn (`o`, `c`, `oi`, `p`) konsekwentnie.

5. **Komentarze w SQL**  
   - dodawaj `-- komentarz` nad trudniejszymi fragmentami,
   - opisuj co jest „krokiem pośrednim” w CTE.

6. **Sprawdzanie wyników „na oko”**  
   - dla funkcji okna – sortuj po `ORDER BY` z okna i patrz na kilka wierszy,
   - przy pct-change – sprawdź kilka wartości kalkulatorem.

7. **Unikaj dzielenia przez zero**  
   - używaj `NULLIF(x, 0)` przy dzieleniu,
   - rozumiej, że `NULL` w wyniku to nie zawsze błąd – czasem „brak poprzedniego okresu”.

---

## 12. Podsumowanie

Po tym bloku powinieneś/powinnaś:

- rozpoznawać, kiedy użyć `GROUP BY`, a kiedy **funkcji okna**,
- swobodnie liczyć:
  - rankingi (`ROW_NUMBER`, `RANK`, `DENSE_RANK`),
  - percentyle (`percentile_disc`, `percentile_cont`),
  - MoM / YoY i udziały procentowe,
- budować czytelne, wieloetapowe zapytania z użyciem **CTE**,
- stosować podzapytania tam, gdzie są naprawdę potrzebne,
- traktować SQL jako narzędzie do **prawdziwej analizy danych**, a nie tylko „pobierania tabel”.