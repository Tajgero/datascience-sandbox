---------------------------------------------------------------------------
-- Blok 3: SQL - Analiza danych
-- Plik: cwiczenia_sql_clean.sql (zadania bez rozwiązań)
--
-- Instrukcja:
--  - Każde zadanie ma opis biznesowy i techniczny oraz szkielet zapytania.
--  - Uzupełniaj miejsca oznaczone jako TODO.
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- OPIS DATASETU – baza: ecommerce_analytics
--
-- Tabela customers
--   customer_id          (int, PK)     – identyfikator klienta
--   customer_created_at  (timestamp)   – data rejestracji klienta
--   country              (text)        – kraj
--   city                 (text)        – miasto
--   marketing_channel    (text)        – kanał pozyskania (organic, ads, referral, ...)
--
-- Tabela products
--   product_id           (int, PK)     – identyfikator produktu
--   category             (text)        – kategoria produktu
--   sub_category         (text)        – podkategoria
--   price                (numeric)     – bieżąca cena katalogowa
--
-- Tabela orders
--   order_id             (int, PK)     – identyfikator zamówienia
--   customer_id          (int, FK)     – klient (customers.customer_id)
--   order_date           (timestamp)   – data złożenia zamówienia
--   order_status         (text)        – completed / cancelled / pending / ...
--   payment_method       (text)        – metoda płatności
--
-- Tabela order_items
--   order_item_id        (int, PK)     – identyfikator pozycji w zamówieniu
--   order_id             (int, FK)     – zamówienie (orders.order_id)
--   product_id           (int, FK)     – produkt (products.product_id)
--   quantity             (int)         – liczba sztuk
--   unit_price           (numeric)     – cena jednostkowa w momencie zakupu
--   discount             (numeric)     – wartość rabatu (kwotowo, może być NULL)
--
-- Tabela traffic_sessions
--   session_id           (int, PK)     – identyfikator sesji
--   customer_id          (int, NULL)   – klient (jeśli zalogowany)
--   session_start        (timestamp)   – początek sesji
--   utm_source           (text)        – źródło (np. google, facebook, newsletter)
--   utm_campaign         (text)        – nazwa kampanii
--   device_type          (text)        – mobile / desktop / ...
--
-- Tabela marketing_campaigns (opcjonalna)
--   campaign_id          (int, PK)
--   campaign_name        (text)
--   start_date           (date)
--   end_date             (date)
--   channel              (text)
--
-- Przyjmij, że wartość pozycji = quantity * unit_price - COALESCE(discount, 0).
-- Wartość zamówienia = suma wartości pozycji danego order_id.
---------------------------------------------------------------------------


/***************************************************************************
 * SEKCJA A – Rozgrzewka i podstawy funkcji okna (Zadania 1–5)
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 1 – Liczba zamówień klienta
--
-- Cel biznesowy:
--   Sprawdzić aktywność klientów – ile zamówień każdy złożył.
--
-- Cel techniczny:
--   Użyć COUNT(*) OVER (PARTITION BY customer_id) na tabeli orders.
--
-- Poziom: 1
-- Szacowany czas: 5–10 min
-- Wskazówki:
--   - Zacznij od prostego SELECT * FROM orders.
--   - Dodaj funkcję okna COUNT(*) OVER (PARTITION BY customer_id).
--   - Posortuj po customer_id, order_id.
---------------------------------------------------------------------------

-- TODO: uzupełnij zapytanie
SELECT
    o.order_id,
    o.customer_id,
    /* TODO: liczba zamówień danego klienta (COUNT(*) OVER (...)) */ AS customer_order_count
FROM orders o
ORDER BY o.customer_id, o.order_id
LIMIT 50;


---------------------------------------------------------------------------
-- Zadanie 2 – Łączna sprzedaż klienta przy każdym zamówieniu
--
-- Cel biznesowy:
--   Zobaczyć, jak rośnie wartość klienta w czasie kolejnych zamówień.
--
-- Cel techniczny:
--   SUM(order_value) OVER (PARTITION BY customer_id ORDER BY order_date).
--
-- Poziom: 1
-- Szacowany czas: 5–10 min
-- Wskazówki:
--   - W podzapytaniu policz wartość zamówienia (JOIN orders z order_items).
--   - W zewnętrznym SELECT użyj funkcji okna SUM(...) OVER (...).
--   - Posortuj po customer_id, order_date.
---------------------------------------------------------------------------

WITH order_value AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        /* TODO: policz wartość zamówienia na podstawie order_items */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    /* TODO: GROUP BY wymagane dla agregacji */
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_value,
    /* TODO: suma wartości zamówień klienta narastająco */ AS customer_cumulative_value
FROM order_value
ORDER BY customer_id, order_date
LIMIT 50;


---------------------------------------------------------------------------
-- Zadanie 3 – Średnia wartość zamówienia w kraju
--
-- Cel biznesowy:
--   Porównać klientów do średniej w ich kraju (czy klient jest „powyżej średniej”?).
--
-- Cel techniczny:
--   AVG(...) OVER (PARTITION BY country) + klasyczne AVG dla klienta.
--
-- Poziom: 1
-- Szacowany czas: 10–15 min
-- Wskazówki:
--   - Połącz customers z orders i order_items.
--   - Najpierw policz średnią wartość zamówienia per klient.
--   - Potem użyj funkcji okna, aby policzyć średnią klienta w kraju.
---------------------------------------------------------------------------

WITH customer_avg AS (
    SELECT
        c.customer_id,
        c.country,
        /* TODO: średnia wartość zamówienia klienta */ AS customer_avg_order_value
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id   = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY klient + kraj */
)
SELECT
    country,
    customer_id,
    customer_avg_order_value,
    /* TODO: średnia wartość klienta w kraju jako funkcja okna */ AS country_avg_order_value
FROM customer_avg
ORDER BY country, customer_id
LIMIT 100;


---------------------------------------------------------------------------
-- Zadanie 4 – Suma narastająca sprzedaży dziennej
--
-- Cel biznesowy:
--   Zobaczyć, jak narasta sprzedaż sklepu w czasie (kumulacja dzienna).
--
-- Cel techniczny:
--   SUM(daily_revenue) OVER (ORDER BY order_day).
--
-- Poziom: 2
-- Szacowany czas: 10–15 min
-- Wskazówki:
--   - W CTE policz dzienną sprzedaż (GROUP BY order_date::date).
--   - W zewnętrznym SELECT użyj SUM(...) OVER (ORDER BY order_day).
--   - Dodaj ORDER BY order_day w końcowym SELECT.
---------------------------------------------------------------------------

WITH daily AS (
    SELECT
        o.order_date::date AS order_day,
        /* TODO: suma wartości zamówień danego dnia */ AS daily_revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY order_day */
)
SELECT
    order_day,
    daily_revenue,
    /* TODO: sprzedaż narastająco */ AS cumulative_revenue
FROM daily
ORDER BY order_day;


---------------------------------------------------------------------------
-- Zadanie 5 – Udział zamówienia w sumie klienta
--
-- Cel biznesowy:
--   Zidentyfikować „kluczowe” zamówienia klientów (jaki % ich całkowitej wartości).
--
-- Cel techniczny:
--   order_value / SUM(order_value) OVER (PARTITION BY customer_id).
--
-- Poziom: 2
-- Szacowany czas: 10–15 min
-- Wskazówki:
--   - W podzapytaniu policz order_value.
--   - Użyj SUM(...) OVER (PARTITION BY customer_id) i NULLIF przy dzieleniu.
---------------------------------------------------------------------------

WITH order_value AS (
    SELECT
        o.order_id,
        o.customer_id,
        /* TODO: oblicz wartość zamówienia */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY order_id, customer_id */
)
SELECT
    order_id,
    customer_id,
    order_value,
    /* TODO: suma wartości zamówień klienta jako funkcja okna */ AS customer_total_value,
    /* TODO: udział zamówienia w sumie klienta */ AS order_share_in_customer
FROM order_value
ORDER BY customer_id, order_id
LIMIT 100;



/***************************************************************************
 * SEKCJA B – Funkcje rangi (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 6 – Numer zamówienia klienta (ROW_NUMBER)
--
-- Cel biznesowy:
--   Zobaczyć, które zamówienie klienta jest pierwsze, drugie, trzecie itd.
--
-- Cel techniczny:
--   ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date).
--
-- Poziom: 1
-- Szacowany czas: 5–10 min
---------------------------------------------------------------------------

SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    /* TODO: ROW_NUMBER() dla klienta po dacie zamówienia */ AS order_number_for_customer
FROM orders o
WHERE o.order_status = 'completed'
ORDER BY o.customer_id, o.order_date;


---------------------------------------------------------------------------
-- Zadanie 7 – Top 3 produkty w kategorii (RANK/DENSE_RANK)
--
-- Cel biznesowy:
--   Znaleźć 3 najlepiej sprzedające się produkty w każdej kategorii.
--
-- Cel techniczny:
--   RANK() lub DENSE_RANK() OVER (PARTITION BY category ORDER BY revenue DESC).
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH product_revenue AS (
    SELECT
        p.category,
        p.product_id,
        /* TODO: revenue produktu */ AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    /* TODO: GROUP BY category, product_id */
)
SELECT
    category,
    product_id,
    revenue,
    /* TODO: ranking w kategorii */ AS revenue_rank
FROM product_revenue
/* TODO: tu możesz odfiltrować rank <= 3 */
ORDER BY category, revenue DESC;



---------------------------------------------------------------------------
-- Zadanie 8 – Decyle klientów wg CLV (NTILE)
--
-- Cel biznesowy:
--   Podzielić klientów na 10 segmentów wg wartości życiowej (CLV).
--
-- Cel techniczny:
--   NTILE(10) OVER (ORDER BY clv DESC).
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH customer_value AS (
    SELECT
        o.customer_id,
        /* TODO: CLV klienta (suma wartości zamówień completed) */ AS clv
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY customer_id */
)
SELECT
    customer_id,
    clv,
    /* TODO: NTILE(10) */ AS clv_decile
FROM customer_value
ORDER BY clv DESC
LIMIT 100;


---------------------------------------------------------------------------
-- Zadanie 9 – Porównanie ROW_NUMBER, RANK i DENSE_RANK
--
-- Cel biznesowy:
--   Zobaczyć różnice między funkcjami rangi przy remisach.
--
-- Cel techniczny:
--   Zastosować ROW_NUMBER, RANK, DENSE_RANK w jednym zapytaniu.
--
-- Poziom: 1–2
-- Szacowany czas: 10–15 min
---------------------------------------------------------------------------

WITH product_revenue AS (
    SELECT
        p.category,
        p.product_id,
        /* TODO: revenue produktu */ AS revenue
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    /* TODO: GROUP BY category, product_id */
)
SELECT
    category,
    product_id,
    revenue,
    /* TODO: ROW_NUMBER() OVER (...) */  AS rn,
    /* TODO: RANK() OVER (...) */        AS rnk,
    /* TODO: DENSE_RANK() OVER (...) */  AS dense_rnk
FROM product_revenue
ORDER BY category, revenue DESC;



/***************************************************************************
 * SEKCJA C – LAG, LEAD, FIRST_VALUE, LAST_VALUE
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 10 – Sprzedaż miesięczna i zmiana MoM (LAG)
--
-- Cel biznesowy:
--   Śledzić wzrost/spadek sprzedaży miesiąc do miesiąca.
--
-- Cel techniczny:
--   LAG(revenue) OVER (ORDER BY month) + obliczenie różnicy i % zmiany.
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH monthly AS (
    SELECT
        date_trunc('month', o.order_date) AS month,
        /* TODO: revenue w miesiącu */ AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY month */
)
SELECT
    month,
    revenue,
    /* TODO: LAG(revenue) */                      AS prev_revenue,
    /* TODO: różnica bezwzględna */               AS diff_revenue,
    /* TODO: zmiana procentowa z NULLIF */        AS pct_change_mom
FROM monthly
ORDER BY month;


---------------------------------------------------------------------------
-- Zadanie 11 – Czas między zamówieniami klienta
--
-- Cel biznesowy:
--   Zrozumieć, co ile dni klienci składają kolejne zamówienia.
--
-- Cel techniczny:
--   LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date).
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    /* TODO: poprzednia data zamówienia klienta (LAG) */ AS prev_order_date,
    /* TODO: różnica w dniach między zamówieniami */     AS days_since_prev_order
FROM orders o
WHERE o.order_status = 'completed'
ORDER BY o.customer_id, o.order_date;


---------------------------------------------------------------------------
-- Zadanie 12 – Pierwsze zamówienie klienta (FIRST_VALUE)
--
-- Cel biznesowy:
--   Zobaczyć, jak zmienia się wartość koszyka względem pierwszego zakupu.
--
-- Cel techniczny:
--   FIRST_VALUE(order_value) OVER (PARTITION BY customer_id ORDER BY order_date).
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH order_value AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        /* TODO: wartość zamówienia */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    /* TODO: GROUP BY customer_id, order_id, order_date */
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_value,
    /* TODO: FIRST_VALUE(order_value) */ AS first_order_value,
    /* TODO: różnica do first_order_value */ AS diff_vs_first
FROM order_value
ORDER BY customer_id, order_date;


---------------------------------------------------------------------------
-- Zadanie 13 – Wartość ostatniego zamówienia klienta (LAST_VALUE)
--
-- Cel biznesowy:
--   Dla każdej obserwacji znać wartość najnowszego zamówienia klienta.
--
-- Cel techniczny:
--   LAST_VALUE(order_value) z odpowiednią ramą okna.
--
-- Poziom: 3
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH order_value AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        /* TODO: wartość zamówienia */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    /* TODO: GROUP BY customer_id, order_id, order_date */
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_value,
    /* TODO: LAST_VALUE(order_value) z pełnym zakresem okna */ AS last_order_value_for_customer
FROM order_value
ORDER BY customer_id, order_date;



/***************************************************************************
 * SEKCJA D – Wskaźniki analityczne, percentyle, statystyka
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 14 – Percentyl 90 wartości koszyka
--
-- Cel biznesowy:
--   Zobaczyć, od jakiej wartości zaczynają się „duże” zamówienia (top 10%).
--
-- Cel techniczny:
--   percentile_disc(0.9) WITHIN GROUP (ORDER BY order_value).
--
-- Poziom: 2
-- Szacowany czas: 10–15 min
---------------------------------------------------------------------------

WITH orders_value AS (
    SELECT
        o.order_id,
        /* TODO: wartość zamówienia */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY order_id */
)
SELECT
    /* TODO: percentyl 0.9 */ AS p90_order_value,
    /* TODO: średnia wartość zamówienia */ AS avg_order_value
FROM orders_value;


---------------------------------------------------------------------------
-- Zadanie 15 – Percentyle wartości zamówień w kategoriach
--
-- Cel biznesowy:
--   Porównać poziomy wartości pozycji zamówienia między kategoriami produktów.
--
-- Cel techniczny:
--   percentyle z WITHIN GROUP per kategoria.
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH category_orders AS (
    SELECT
        p.category,
        /* TODO: wartość pozycji (line_value) */ AS line_value
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
)
SELECT
    category,
    /* TODO: percentyl 0.5 (mediana) */ AS p50_value,
    /* TODO: percentyl 0.9 */          AS p90_value
FROM category_orders
GROUP BY category;


---------------------------------------------------------------------------
-- Zadanie 16 – Odchylenie standardowe wartości koszyka
--
-- Cel biznesowy:
--   Sprawdzić, jak bardzo zróżnicowane są wartości zamówień.
--
-- Cel techniczny:
--   stddev_samp(order_value).
--
-- Poziom: 1
-- Szacowany czas: 5–10 min
---------------------------------------------------------------------------

WITH orders_value AS (
    SELECT
        o.order_id,
        /* TODO: wartość zamówienia */ AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY order_id */
)
SELECT
    /* TODO: odchylenie standardowe */ AS std_order_value,
    /* TODO: średnia wartość zamówienia */ AS avg_order_value
FROM orders_value;


---------------------------------------------------------------------------
-- Zadanie 17 – Korelacja liczby pozycji z wartością koszyka
--
-- Cel biznesowy:
--   Zweryfikować, czy więcej pozycji w koszyku => wyższa wartość zamówienia.
--
-- Cel techniczny:
--   corr(num_items, order_value).
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH order_stats AS (
    SELECT
        oi.order_id,
        /* TODO: liczba pozycji */ AS num_items,
        /* TODO: wartość zamówienia */ AS order_value
    FROM order_items oi
    /* TODO: GROUP BY order_id */
)
SELECT
    /* TODO: korelacja */ AS corr_items_value
FROM order_stats;


---------------------------------------------------------------------------
-- Zadanie 18 – Statystyki per kraj (średnia, odchylenie, percentyle)
--
-- Cel biznesowy:
--   Porównać zachowanie klientów pomiędzy krajami.
--
-- Cel techniczny:
--   AVG, stddev_samp, percentile_disc per kraj.
--
-- Poziom: 3
-- Szacowany czas: 20–25 min
---------------------------------------------------------------------------

WITH country_orders AS (
    SELECT
        c.country,
        o.order_id,
        /* TODO: wartość zamówienia */ AS order_value
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY kraj + order_id */
)
SELECT
    country,
    /* TODO: średnia */      AS avg_order_value,
    /* TODO: odchylenie */   AS std_order_value,
    /* TODO: mediana */      AS p50_order_value,
    /* TODO: percentyl 0.9 */AS p90_order_value
FROM country_orders
GROUP BY country
ORDER BY avg_order_value DESC;



/***************************************************************************
 * SEKCJA E – Podzapytania, CTE, tabele tymczasowe
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 19 – Podzapytanie w SELECT (porównanie do średniej w kraju)
--
-- Cel biznesowy:
--   Odpowiedzieć, czy dany klient jest powyżej/poniżej średniej CLV w swoim kraju.
--
-- Cel techniczny:
--   Podzapytanie skorelowane w SELECT.
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH customer_value AS (
    SELECT
        c.customer_id,
        c.country,
        /* TODO: CLV klienta */ AS clv
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id   = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY customer_id, country */
)
SELECT
    cv.customer_id,
    cv.country,
    cv.clv,
    /* TODO: średnia CLV w kraju (podzapytanie w SELECT) */ AS country_avg_clv,
    /* TODO: różnica cv.clv - średnia */                     AS diff_vs_country_avg
FROM customer_value cv
ORDER BY cv.country, cv.clv DESC
LIMIT 100;


---------------------------------------------------------------------------
-- Zadanie 20 – Podzapytanie w FROM (tabela pośrednia)
--
-- Cel biznesowy:
--   Zbudować raport miesięcznej sprzedaży po krajach z sumą narastającą.
--
-- Cel techniczny:
--   Podzapytanie w FROM z agregacją + funkcja okna na zewnątrz.
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

SELECT
    t.country,
    t.month,
    t.revenue,
    /* TODO: suma narastająca revenue w kraju */ AS cumulative_country_revenue
FROM (
    SELECT
        c.country,
        date_trunc('month', o.order_date) AS month,
        /* TODO: revenue w miesiącu i kraju */ AS revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    /* TODO: GROUP BY country, month */
) t
ORDER BY t.country, t.month;


---------------------------------------------------------------------------
-- Zadanie 21 – Podzapytanie w WHERE (EXISTS)
--
-- Cel biznesowy:
--   Znaleźć klientów, którzy kupowali w ostatnich 90 dniach.
--
-- Cel techniczny:
--   Podzapytanie skorelowane z EXISTS w WHERE.
--
-- Poziom: 1–2
-- Szacowany czas: 10–15 min
---------------------------------------------------------------------------

SELECT
    c.customer_id,
    c.country
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_status = 'completed'
      /* TODO: filtr daty na ostatnie 90 dni */
);


---------------------------------------------------------------------------
-- Zadanie 22 – CTE z wieloma krokami
--
-- Cel biznesowy:
--   Przygotować raport miesięcznej sprzedaży z MoM.
--
-- Cel techniczny:
--   Dwa CTE: monthly + monthly_with_prev.
--
-- Poziom: 2–3
-- Szacowany czas: 20–25 min
---------------------------------------------------------------------------

WITH monthly AS (
    /* TODO: policz revenue miesięczne (month, revenue) */
),
monthly_with_prev AS (
    /* TODO: dodaj LAG(revenue) jako prev_month_revenue */
)
SELECT
    /* TODO: wybierz month, revenue, prev_month_revenue, różnica, zmiana % */
FROM monthly_with_prev
ORDER BY /* TODO: month */;


---------------------------------------------------------------------------
-- Zadanie 23 – Tabela tymczasowa (TEMP TABLE)
--
-- Cel biznesowy:
--   Przygotować dzienną sprzedaż jako temp table i użyć jej w kolejnych zapytaniach.
--
-- Cel techniczny:
--   CREATE TEMP TABLE ... AS SELECT ... + potem SELECT z tej tabeli.
--
-- Poziom: 2
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

-- TODO: utworzenie tabeli tymczasowej z dzienną sprzedażą
-- CREATE TEMP TABLE daily_sales AS
-- SELECT
--     ...
-- FROM orders o
-- JOIN order_items oi ON oi.order_id = o.order_id
-- WHERE ...
-- GROUP BY ... ;

-- TODO: wykorzystanie daily_sales
-- SELECT
--     order_day,
--     daily_revenue,
--     SUM(daily_revenue) OVER (...) AS cumulative_revenue
-- FROM daily_sales
-- ORDER BY order_day;


---------------------------------------------------------------------------
-- Zadanie 24 – Kategoria powyżej średniej globalnej (HAVING z podzapytaniem)
--
-- Cel biznesowy:
--   Zidentyfikować kategorie z ponadprzeciętną sprzedażą.
--
-- Cel techniczny:
--   Podzapytanie w HAVING z AVG(revenue) po wszystkich kategoriach.
--
-- Poziom: 2–3
-- Szacowany czas: 15–20 min
---------------------------------------------------------------------------

WITH category_revenue AS (
    SELECT
        p.category,
        /* TODO: revenue kategorii */ AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    /* TODO: GROUP BY category */
)
SELECT
    category,
    revenue
FROM category_revenue
HAVING /* TODO: revenue > średnia revenue z podzapytania */
ORDER BY revenue DESC;



/***************************************************************************
 * SEKCJA F – Zadania podsumowujące / mini projekty
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 25 – Raport sprzedaży miesięcznej z MoM i YoY
--
-- Cel biznesowy:
--   Raport dla zarządu: revenue, MoM, YoY (na poziomie całego sklepu).
--
-- Cel techniczny:
--   CTE z miesięcznym revenue + LAG z offsetem 1 i 12.
--
-- Poziom: 3
-- Szacowany czas: 30–40 min
---------------------------------------------------------------------------

-- TODO: zaprojektuj 2–3 CTE:
--   - monthly (month, revenue)
--   - monthly_with_lags (month, revenue, prev_month_revenue, prev_year_revenue)
--   - final SELECT z wyliczeniem mom_change_pct, yoy_change_pct

-- PRZYKŁADOWY SZKIELET:
-- WITH monthly AS (
--     SELECT
--         ...
--     FROM ...
-- ),
-- monthly_with_lags AS (
--     SELECT
--         ...
--     FROM monthly
-- )
-- SELECT
--     month,
--     revenue,
--     prev_month_revenue,
--     ... AS mom_change_pct,
--     prev_year_revenue,
--     ... AS yoy_change_pct
-- FROM monthly_with_lags
-- ORDER BY month;


---------------------------------------------------------------------------
-- Zadanie 26 – Raport segmentacji klientów (decyle CLV)
--
-- Cel biznesowy:
--   Segmentacja klientów wg CLV + udział segmentów w miesięcznej sprzedaży.
--
-- Cel techniczny:
--   NTILE(10), CTE, funkcje okna / joiny.
--
-- Poziom: 3
-- Szacowany czas: 30–45 min
---------------------------------------------------------------------------

-- TODO: zaprojektuj kilka CTE:
--   1) customer_value (customer_id, clv)
--   2) customer_segments (customer_id, clv, clv_decile)
--   3) orders_with_segment (month, clv_decile, order_value)
--   4) segment_monthly (month, segment, segment_revenue)
--   5) total_monthly (month, total_revenue)
--
-- Finalnie zwróć:
--   - month
--   - segment (decyl)
--   - segment_revenue
--   - segment_share_in_total

-- Szkielet:
-- WITH customer_value AS (...),
--      customer_segments AS (...),
--      orders_with_segment AS (...),
--      segment_monthly AS (...),
--      total_monthly AS (...)
-- SELECT
--     ...
-- FROM segment_monthly sm
-- JOIN total_monthly tm ON ...
-- ORDER BY ... ;



/***************************************************************************
 * SEKCJA G – Zadania domowe (dla chętnych)
 ***************************************************************************/

---------------------------------------------------------------------------
-- Zadanie 27 – Raport efektywności kampanii marketingowych
--
-- Cel biznesowy:
--   Zobaczyć, które kampanie (utm_campaign) generują najwięcej przychodu
--   i mają najwyższą konwersję.
--
-- Cel techniczny:
--   Połączenie traffic_sessions i orders, CTE, funkcje okna.
--
-- Poziom: 3
-- Szacowany czas: 40–60 min
---------------------------------------------------------------------------

-- TODO: zaprojektuj CTE:
--   - sessions_enriched (sesje z kampaniami)
--   - orders_enriched (zamówienia z wartością)
--   - session_order_match (match sesji do zamówień)
--   - campaign_stats (agregacja per kampania)
--
-- W finalnym SELECT policz m.in.:
--   - sessions
--   - orders
--   - revenue
--   - conversion_rate = orders / sessions
--   - revenue_per_session
--   - share_in_total_revenue (funkcja okna)


---------------------------------------------------------------------------
-- Zadanie 28 – Własny raport analityczny
--
-- Cel biznesowy:
--   Stworzyć raport, który odpowiedziałby na rzeczywiste pytanie w Twojej pracy
--   (np. raport po krajach, kategoriach, kanałach marketingowych).
--
-- Cel techniczny:
--   Co najmniej:
--     - 2 funkcje okna,
--     - 1 CTE,
--     - 1 podzapytanie.
--
-- Poziom: 3
-- Szacowany czas: 40–60 min
---------------------------------------------------------------------------

-- TODO:
--   - Opisz w komentarzu pytanie biznesowe.
--   - Zaprojektuj strukturę raportu (kolumny, poziom agregacji).
--   - Podziel logikę na CTE.
--   - Użyj funkcji okna (np. rank, percentyle, MoM).
--   - Dodaj podzapytanie tam, gdzie ma to sens.

-- Miejsce na Twoje kompletne zapytanie:
-- SELECT
--     ...
-- FROM ...
-- ...