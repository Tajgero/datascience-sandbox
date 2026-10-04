-- =====================================================================
-- Blok 2 – SQL: Podstawowa składnia
-- Plik: cwiczenia_sql_solved.sql (wersja z rozwiązaniami)
-- =====================================================================
-- Ten plik zawiera przykładowe rozwiązania do wszystkich zadań z pliku
-- cwiczenia_sql_clean.sql. Traktuj je jako wzorce – w SQL zazwyczaj
-- istnieje wiele poprawnych rozwiązań tego samego problemu.
--
-- Możesz:
-- - uruchamiać je blokami w DBeaver,
-- - modyfikować pod własne potrzeby,
-- - porównywać ze swoimi odpowiedziami.
-- =====================================================================


-- #####################################################################
-- #  OPIS DATASETU – SCHEMAT `olist`
-- #####################################################################
--
-- Kontekst biznesowy:
-- Dane pochodzą z systemu e-commerce / marketplace’u:
-- - klienci składają zamówienia,
-- - zamówienia składają się z pozycji (produkty),
-- - każde zamówienie może mieć przypisane płatności.
--
-- W tym bloku korzystamy z następujących tabel (schemat: olist):
--
-- 1. olist_customers
--    - customer_id              UUID
--    - customer_unique_id       UUID
--    - customer_city            TEXT
--    - customer_state           TEXT
--    - customer_created_at      TIMESTAMP
--
-- 2. olist_orders
--    - order_id                 UUID
--    - customer_id              UUID
--    - order_status             TEXT
--    - order_purchase_timestamp TIMESTAMP
--    - order_approved_at        TIMESTAMP
--    - order_delivered_carrier_date   TIMESTAMP
--    - order_delivered_customer_date  TIMESTAMP
--    - order_estimated_delivery_date  TIMESTAMP
--
-- 3. olist_order_items
--    - order_id                 UUID
--    - order_item_id            INTEGER
--    - product_id               UUID
--    - seller_id                UUID
--    - shipping_limit_date      TIMESTAMP
--    - price                    NUMERIC(10,2)
--    - freight_value            NUMERIC(10,2)
--
-- 4. olist_products
--    - product_id               UUID
--    - product_category_name    TEXT
--    - product_name_length      INTEGER
--    - product_description_length INTEGER
--    - product_photos_qty       INTEGER
--    - product_weight_g         NUMERIC
--    - product_length_cm        NUMERIC
--    - product_height_cm        NUMERIC
--    - product_width_cm         NUMERIC
--
-- 5. olist_order_payments
--    - order_id                 UUID
--    - payment_sequential       INTEGER
--    - payment_type             TEXT
--    - payment_installments     INTEGER
--    - payment_value            NUMERIC(10,2)
--
-- #####################################################################
-- #  CZĘŚĆ 1 – PIERWSZE SELECT-Y, FILTROWANIE, SORTOWANIE
-- #####################################################################


-- =====================================================================
-- ZADANIE 1: Pierwsze zapytanie do bazy (olist_customers)
-- =====================================================================

SELECT
    *
FROM olist_customers
LIMIT 10;


-- =====================================================================
-- ZADANIE 2: Wybór konkretnych kolumn i aliasy
-- =====================================================================

SELECT
    customer_id,
    customer_city,
    customer_state AS customer_region
FROM olist_customers
LIMIT 20;


-- =====================================================================
-- ZADANIE 3: Filtrowanie klientów po regionie (WHERE)
-- Przykład z regionem 'SP' – możesz zmienić wartość.
-- =====================================================================

SELECT
    customer_id,
    customer_city,
    customer_state
FROM olist_customers
WHERE customer_state = 'SP'
LIMIT 50;


-- =====================================================================
-- ZADANIE 4: Operatory logiczne AND / OR / NOT
-- =====================================================================

-- Wersja z OR
SELECT
    customer_id,
    customer_city,
    customer_state
FROM olist_customers
WHERE
    customer_state = 'SP'
    OR customer_state = 'RJ'
    OR customer_state = 'MG'
LIMIT 50;

-- Wersja z IN
SELECT
    customer_id,
    customer_city,
    customer_state
FROM olist_customers
WHERE customer_state IN ('SP', 'RJ', 'MG')
LIMIT 50;

-- Przykład z NOT
SELECT
    customer_id,
    customer_city,
    customer_state
FROM olist_customers
WHERE NOT customer_state = 'SP'
LIMIT 50;


-- =====================================================================
-- ZADANIE 5: Sortowanie i LIMIT – ostatnie zamówienia
-- =====================================================================

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist_orders
ORDER BY order_purchase_timestamp DESC
LIMIT 20;



-- #####################################################################
-- #  CZĘŚĆ 2 – TYPY DANYCH, ARYTMETYKA, FUNKCJE TEKSTOWE I DATY
-- #####################################################################


-- =====================================================================
-- ZADANIE 6: Przegląd typów danych w tabelach
-- =====================================================================

SELECT *
FROM olist_orders
LIMIT 10;

SELECT *
FROM olist_order_payments
LIMIT 10;


-- =====================================================================
-- ZADANIE 7: Operatory arytmetyczne – wartość pozycji
-- =====================================================================

SELECT
    order_id,
    order_item_id,
    price,
    freight_value,
    price + freight_value AS item_total
FROM olist_order_items
LIMIT 20;


-- =====================================================================
-- ZADANIE 8: Zaokrąglanie – ROUND
-- =====================================================================

SELECT
    order_id,
    payment_type,
    payment_value,
    ROUND(payment_value, 2) AS payment_value_rounded
FROM olist_order_payments
LIMIT 20;


-- =====================================================================
-- ZADANIE 9: Podstawowe funkcje tekstowe – UPPER, LOWER, LENGTH
-- =====================================================================

SELECT
    product_id,
    product_category_name,
    UPPER(product_category_name) AS category_upper,
    LOWER(product_category_name) AS category_lower,
    LENGTH(product_category_name) AS category_length
FROM olist_products
LIMIT 20;


-- =====================================================================
-- ZADANIE 10: LEFT, RIGHT, REPLACE, LTRIM, RTRIM
-- =====================================================================

SELECT
    product_id,
    product_category_name,
    LEFT(product_category_name, 3) AS category_prefix,
    RIGHT(product_category_name, 3) AS category_suffix,
    REPLACE(product_category_name, ' ', '_') AS category_no_spaces,
    LTRIM('   ' || product_category_name) AS ltrim_example,
    RTRIM(product_category_name || '   ') AS rtrim_example
FROM olist_products
LIMIT 20;


-- =====================================================================
-- ZADANIE 11: Funkcje daty – DATE_PART, TO_CHAR
-- =====================================================================

SELECT
    order_id,
    order_purchase_timestamp,
    DATE_PART('year', order_purchase_timestamp) AS purchase_year,
    DATE_PART('month', order_purchase_timestamp) AS purchase_month,
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS purchase_ym
FROM olist_orders
LIMIT 20;


-- =====================================================================
-- ZADANIE 12: Obsługa NULL – COALESCE i NULLIF
-- =====================================================================

-- COALESCE na datach dostawy
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    COALESCE(order_delivered_customer_date, order_estimated_delivery_date) AS delivery_effective_date
FROM olist_orders
LIMIT 20;

-- Przykład NULLIF – bezpieczny dzielnik
SELECT
    10 AS numerator,
    0 AS denominator,
    NULLIF(0, 0) AS safe_denominator;


-- =====================================================================
-- ZADANIE 13: GREATEST i LEAST na datach
-- =====================================================================

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_customer_date,
    LEAST(order_purchase_timestamp, order_approved_at, order_delivered_customer_date) AS earliest_event,
    GREATEST(order_purchase_timestamp, order_approved_at, order_delivered_customer_date) AS latest_event
FROM olist_orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
LIMIT 20;



-- #####################################################################
-- #  CZĘŚĆ 3 – AGREGACJE, GROUP BY, HAVING, CASE
-- #####################################################################


-- =====================================================================
-- ZADANIE 14: COUNT i COUNT(DISTINCT)
-- =====================================================================

SELECT
    COUNT(*) AS orders_cnt,
    COUNT(DISTINCT customer_id) AS distinct_customers_cnt
FROM olist_orders;


-- =====================================================================
-- ZADANIE 15: SUM, AVG, MIN, MAX na płatnościach
-- =====================================================================

-- Statystyki globalne
SELECT
    SUM(payment_value) AS total_payments,
    AVG(payment_value) AS avg_payment,
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment
FROM olist_order_payments;

-- Statystyki per typ płatności
SELECT
    payment_type,
    COUNT(*) AS payments_cnt,
    SUM(payment_value) AS total_payments,
    AVG(payment_value) AS avg_payment,
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment
FROM olist_order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;


-- =====================================================================
-- ZADANIE 16: GROUP BY – liczba zamówień na klienta
-- =====================================================================

SELECT
    customer_id,
    COUNT(order_id) AS orders_cnt
FROM olist_orders
GROUP BY customer_id
ORDER BY orders_cnt DESC
LIMIT 20;


-- =====================================================================
-- ZADANIE 17: HAVING – klienci 'lojalni'
-- Próg 5 zamówień – możesz go zmienić.
-- =====================================================================

SELECT
    customer_id,
    COUNT(order_id) AS orders_cnt
FROM olist_orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 5
ORDER BY orders_cnt DESC;


-- =====================================================================
-- ZADANIE 18: CASE – segmentacja wartości zamówienia
-- =====================================================================

SELECT
    CASE
        WHEN payment_value < 100 THEN 'small'
        WHEN payment_value BETWEEN 100 AND 300 THEN 'medium'
        ELSE 'large'
    END AS order_size_segment,
    COUNT(*) AS orders_cnt,
    AVG(payment_value) AS avg_payment_in_segment
FROM olist_order_payments
GROUP BY order_size_segment
ORDER BY orders_cnt DESC;



-- #####################################################################
-- #  CZĘŚĆ 4 – JOIN-Y: ŁĄCZENIE TABEL
-- #####################################################################


-- =====================================================================
-- ZADANIE 19: INNER JOIN – klienci + zamówienia
-- =====================================================================

SELECT
    o.order_id,
    o.order_purchase_timestamp,
    c.customer_id,
    c.customer_city,
    c.customer_state
FROM olist_orders AS o
INNER JOIN olist_customers AS c
    ON o.customer_id = c.customer_id
ORDER BY o.order_purchase_timestamp DESC
LIMIT 20;


-- =====================================================================
-- ZADANIE 20: LEFT JOIN – klienci bez zamówień
-- =====================================================================

SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state
FROM olist_customers AS c
LEFT JOIN olist_orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
LIMIT 50;


-- =====================================================================
-- ZADANIE 21: RIGHT JOIN i FULL JOIN – porównanie
-- =====================================================================

-- INNER JOIN
SELECT COUNT(*) AS inner_join_rows
FROM olist_customers AS c
INNER JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;

-- LEFT JOIN
SELECT COUNT(*) AS left_join_rows
FROM olist_customers AS c
LEFT JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;

-- RIGHT JOIN
SELECT COUNT(*) AS right_join_rows
FROM olist_customers AS c
RIGHT JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;

-- FULL JOIN
SELECT COUNT(*) AS full_join_rows
FROM olist_customers AS c
FULL JOIN olist_orders AS o
    ON c.customer_id = o.customer_id;


-- =====================================================================
-- ZADANIE 22: CROSS JOIN – kombinacje miesięcy i kategorii
-- =====================================================================

WITH months AS (
    SELECT DISTINCT
        TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS purchase_ym
    FROM olist_orders
),
categories AS (
    SELECT DISTINCT
        product_category_name
    FROM olist_products
)
SELECT
    m.purchase_ym,
    c.product_category_name
FROM months AS m
CROSS JOIN categories AS c
ORDER BY m.purchase_ym, c.product_category_name
LIMIT 200;


-- =====================================================================
-- ZADANIE 23: Multi-join – zamówienia, pozycje, produkty
-- =====================================================================

SELECT
    p.product_category_name,
    COUNT(*) AS items_cnt,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM olist_order_items AS oi
JOIN olist_products AS p
    ON oi.product_id = p.product_id
JOIN olist_orders AS o
    ON oi.order_id = o.order_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 20;



-- #####################################################################
-- #  CZĘŚĆ 5 – OPERACJE NA ZBIORACH I WIDOKI
-- #####################################################################


-- =====================================================================
-- ZADANIE 24: UNION vs UNION ALL
-- =====================================================================

WITH orders_2017 AS (
    SELECT order_id
    FROM olist_orders
    WHERE order_purchase_timestamp >= DATE '2017-01-01'
      AND order_purchase_timestamp <  DATE '2018-01-01'
),
orders_2018 AS (
    SELECT order_id
    FROM olist_orders
    WHERE order_purchase_timestamp >= DATE '2018-01-01'
      AND order_purchase_timestamp <  DATE '2019-01-01'
)
SELECT 'UNION ALL' AS op, COUNT(*) AS rows_cnt
FROM (
    SELECT order_id FROM orders_2017
    UNION ALL
    SELECT order_id FROM orders_2018
) t1
UNION ALL
SELECT 'UNION' AS op, COUNT(*) AS rows_cnt
FROM (
    SELECT order_id FROM orders_2017
    UNION
    SELECT order_id FROM orders_2018
) t2;


-- =====================================================================
-- ZADANIE 25: EXCEPT i INTERSECT
-- =====================================================================

WITH customers_2017 AS (
    SELECT DISTINCT customer_id
    FROM olist_orders
    WHERE order_purchase_timestamp >= DATE '2017-01-01'
      AND order_purchase_timestamp <  DATE '2018-01-01'
),
customers_2018 AS (
    SELECT DISTINCT customer_id
    FROM olist_orders
    WHERE order_purchase_timestamp >= DATE '2018-01-01'
      AND order_purchase_timestamp <  DATE '2019-01-01'
)
SELECT 'both_years' AS segment, COUNT(*) AS customers_cnt
FROM (
    SELECT customer_id FROM customers_2017
    INTERSECT
    SELECT customer_id FROM customers_2018
) t_both
UNION ALL
SELECT 'only_2017' AS segment, COUNT(*) AS customers_cnt
FROM (
    SELECT customer_id FROM customers_2017
    EXCEPT
    SELECT customer_id FROM customers_2018
) t_only_2017
UNION ALL
SELECT 'only_2018' AS segment, COUNT(*) AS customers_cnt
FROM (
    SELECT customer_id FROM customers_2018
    EXCEPT
    SELECT customer_id FROM customers_2017
) t_only_2018;


-- =====================================================================
-- ZADANIE 26: CREATE VIEW – zapisanie raportu dziennego przychodu
-- =====================================================================

CREATE OR REPLACE VIEW olist_daily_revenue AS
SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    COUNT(DISTINCT o.order_id) AS orders_cnt,
    SUM(oi.price + oi.freight_value) AS daily_revenue
FROM olist_orders AS o
JOIN olist_order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY DATE(o.order_purchase_timestamp);

-- Test użycia widoku
SELECT
    order_date,
    orders_cnt,
    daily_revenue
FROM olist_daily_revenue
ORDER BY order_date
LIMIT 30;



-- #####################################################################
-- #  CZĘŚĆ 6 – MINI-PROJEKTY
-- #####################################################################


-- =====================================================================
-- ZADANIE 27 (Mini-projekt 1): Raport dzienny sprzedaży
-- =====================================================================

SELECT
    DATE(o.order_purchase_timestamp) AS order_date,
    COUNT(DISTINCT o.order_id) AS orders_cnt,
    SUM(oi.price + oi.freight_value) AS revenue,
    AVG(oi.price + oi.freight_value) AS avg_item_value,
    SUM(oi.price + oi.freight_value) / NULLIF(COUNT(DISTINCT o.order_id), 0) AS avg_order_value
FROM olist_orders AS o
JOIN olist_order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY DATE(o.order_purchase_timestamp)
ORDER BY order_date
LIMIT 60;


-- =====================================================================
-- ZADANIE 28 (Mini-projekt 2): Analiza jakości danych zamówień
-- =====================================================================

-- Udział zamówień bez daty dostawy
SELECT
    COUNT(*) AS orders_total,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS orders_without_delivery_date,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) / COUNT(*),
        2
    ) AS pct_without_delivery_date
FROM olist_orders;

-- Różnica między datą planowaną a faktyczną (tylko zamówienia z kompletem dat)
SELECT
    order_id,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    DATE_PART('day', order_delivered_customer_date - order_estimated_delivery_date) AS delivery_delay_days
FROM olist_orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
LIMIT 50;



-- #####################################################################
-- #  ZADANIE DOMOWE (DLA CHĘTNYCH)
-- #####################################################################


-- =====================================================================
-- ZADANIE H1: Profilowanie klienta
-- Uwaga: trzeba wstawić realne customer_id z danych.
-- =====================================================================

-- Przykład: wybór kilku customer_id do analizy
SELECT DISTINCT customer_id
FROM olist_orders
LIMIT 10;

-- Zakładamy, że wybierasz jedno z powyższych ID i wstawiasz w miejsce
-- poniższego placeholdera '<WSTAW_TUTAJ_CUSTOMER_ID>'.

-- Podstawowe informacje o aktywności klienta
WITH chosen_customer AS (
    SELECT '<WSTAW_TUTAJ_CUSTOMER_ID>'::uuid AS customer_id
),
customer_orders AS (
    SELECT
        o.*
    FROM olist_orders AS o
    JOIN chosen_customer AS cc
        ON o.customer_id = cc.customer_id
)
SELECT
    COUNT(*) AS orders_cnt,
    MIN(order_purchase_timestamp) AS first_order_ts,
    MAX(order_purchase_timestamp) AS last_order_ts
FROM customer_orders;

-- Średnia wartość zamówienia klienta (na bazie płatności)
WITH chosen_customer AS (
    SELECT '<WSTAW_TUTAJ_CUSTOMER_ID>'::uuid AS customer_id
),
customer_orders AS (
    SELECT o.order_id
    FROM olist_orders AS o
    JOIN chosen_customer AS cc
        ON o.customer_id = cc.customer_id
),
customer_payments AS (
    SELECT p.*
    FROM olist_order_payments AS p
    JOIN customer_orders AS co
        ON p.order_id = co.order_id
)
SELECT
    COUNT(DISTINCT order_id) AS orders_cnt,
    SUM(payment_value) AS total_payment,
    SUM(payment_value) / NULLIF(COUNT(DISTINCT order_id), 0) AS avg_order_value
FROM customer_payments;

-- Kategorie produktów kupowanych przez klienta
WITH chosen_customer AS (
    SELECT '<WSTAW_TUTAJ_CUSTOMER_ID>'::uuid AS customer_id
),
customer_orders AS (
    SELECT o.order_id
    FROM olist_orders AS o
    JOIN chosen_customer AS cc
        ON o.customer_id = cc.customer_id
)
SELECT
    p.product_category_name,
    COUNT(*) AS items_cnt,
    SUM(oi.price + oi.freight_value) AS revenue
FROM olist_order_items AS oi
JOIN customer_orders AS co
    ON oi.order_id = co.order_id
JOIN olist_products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================================
-- KONIEC PLIKU: cwiczenia_sql_solved.sql
-- =====================================================================
