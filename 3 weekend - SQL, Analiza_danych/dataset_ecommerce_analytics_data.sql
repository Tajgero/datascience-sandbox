---------------------------------------------------------------------------
-- Dataset dla Bloku 3 SQL - Analiza danych
-- Plik: dataset_ecommerce_analytics_data.sql
--
-- CEL:
--   Ten plik WYPEŁNIA danymi tabele zdefiniowane w
--   dataset_ecommerce_analytics_schema.sql.
--
-- UŻYCIE:
--   1. Upewnij się, że wykonałeś już plik:
--        dataset_ecommerce_analytics_schema.sql
--      (tabele istnieją).
--   2. Połącz się z bazą `ecommerce_analytics`.
--   3. Uruchom TEN plik – wygeneruje syntetyczne dane.
--
-- UWAGA:
--   - Skrypt najpierw czyści tabele (TRUNCATE ... RESTART IDENTITY).
--   - Jeśli chcesz zachować istniejące dane, zakomentuj sekcję TRUNCATE.
---------------------------------------------------------------------------

-- Ustawiamy schemat
SET search_path TO ecommerce_analytics, public;

---------------------------------------------------------------------------
-- 0. (Opcjonalne) Wyczyszczenie danych
--    UWAGA: usunie wszystkie dane z tabel i zresetuje sekwencje ID.
---------------------------------------------------------------------------

TRUNCATE
    order_items,
    orders,
    traffic_sessions,
    products,
    customers,
    marketing_campaigns
RESTART IDENTITY;


---------------------------------------------------------------------------
-- 1. Klienci – ok. 4000 rekordów
--
-- Założenia:
--   - daty rejestracji w 2024 roku,
--   - kilka krajów i miast,
--   - różne kanały marketingowe.
---------------------------------------------------------------------------

INSERT INTO customers (customer_id, customer_created_at, country, city, marketing_channel)
SELECT
    gs AS customer_id,
    (
        DATE '2024-01-01'
        + (random() * 365)::INT
    )::timestamp
    + (random() * 24 || ' hours')::interval             AS customer_created_at,
    (ARRAY['PL','DE','FR','UK','US'])[1 + (random()*4)::INT] AS country,
    (ARRAY['Warsaw','Berlin','Paris','London','New York'])[1 + (random()*4)::INT] AS city,
    (ARRAY['organic','paid_search','social_ads','email','referral'])[1 + (random()*4)::INT] AS marketing_channel
FROM generate_series(1, 4000) AS gs;


---------------------------------------------------------------------------
-- 2. Produkty – ok. 300 produktów
--
-- Założenia:
--   - 5 kategorii,
--   - 3 poziomy „sub_category”,
--   - cena w zakresie ~10–500.
---------------------------------------------------------------------------

INSERT INTO products (product_id, category, sub_category, price)
SELECT
    gs AS product_id,
    (ARRAY['electronics','fashion','home','sport','toys'])[1 + (random()*4)::INT] AS category,
    (ARRAY['premium','standard','budget'])[1 + (random()*2)::INT] AS sub_category,
    ROUND((10 + random() * 490)::NUMERIC, 2) AS price
FROM generate_series(1, 300) AS gs;


---------------------------------------------------------------------------
-- 3. Kampanie marketingowe – kilka przykładowych rekordów
---------------------------------------------------------------------------

INSERT INTO marketing_campaigns (campaign_id, campaign_name, start_date, end_date, channel)
VALUES
    (1, 'Spring Sale Search',   '2024-03-01', '2024-03-31', 'paid_search'),
    (2, 'Summer Social Boost',  '2024-06-01', '2024-06-30', 'social_ads'),
    (3, 'Black Friday Email',   '2024-11-15', '2024-11-30', 'email'),
    (4, 'Winter Remarketing',   '2024-12-01', '2024-12-31', 'display');


---------------------------------------------------------------------------
-- 4. Zamówienia – ok. 35 000 zamówień
--
-- Założenia:
--   - daty w 2024 roku,
--   - status głównie 'completed', czasem 'cancelled',
--   - losowe metody płatności.
---------------------------------------------------------------------------

INSERT INTO orders (order_id, customer_id, order_date, order_status, payment_method)
SELECT
    gs AS order_id,
    (1 + (random() * 3999)::INT) AS customer_id,
    (
        DATE '2024-01-01'
        + (random() * 364)::INT
    )::timestamp
    + (random() * 24 || ' hours')::interval             AS order_date,
    (ARRAY['completed','completed','completed','cancelled'])[1 + (random()*3)::INT] AS order_status,
    (ARRAY['card','blik','transfer','paypal'])[1 + (random()*3)::INT] AS payment_method
FROM generate_series(1, 35000) AS gs;


---------------------------------------------------------------------------
-- 5. Pozycje zamówień – 3 pozycje na każde zamówienie
--
-- Założenia:
--   - do każdego order_id generujemy 3 pozycje,
--   - produkt losowany z puli 1–300,
--   - quantity 1–5,
--   - unit_price losowana niezależnie od tabeli products (uproszczenie),
--   - sporadyczne rabaty.
---------------------------------------------------------------------------

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
SELECT
    (order_id - 1) * 3 + item_no      AS order_item_id,
    order_id,
    (1 + (random() * 299)::INT)       AS product_id,
    (1 + (random() * 4)::INT)         AS quantity,
    ROUND((10 + random() * 490)::NUMERIC, 2) AS unit_price,
    CASE
        WHEN random() < 0.2
            THEN ROUND((random() * 20)::NUMERIC, 2)
        ELSE NULL
    END AS discount
FROM (
    SELECT
        o.order_id,
        gs_item AS item_no
    FROM orders o
    JOIN generate_series(1, 3) AS gs_item ON TRUE
) x;


---------------------------------------------------------------------------
-- 6. Sesje ruchu – ok. 60 000 sesji
--
-- Założenia:
--   - część sesji bez powiązanego klienta (customer_id NULL),
--   - różne źródła ruchu i kampanie (spójne z marketing_campaigns),
--   - daty w 2024 roku,
--   - różne typy urządzeń.
---------------------------------------------------------------------------

INSERT INTO traffic_sessions (session_id, customer_id, session_start, utm_source, utm_campaign, device_type)
SELECT
    gs AS session_id,
    CASE
        WHEN random() < 0.7 THEN (1 + (random() * 3999)::INT)
        ELSE NULL
    END AS customer_id,
    (
        DATE '2024-01-01'
        + (random() * 364)::INT
    )::timestamp
    + (random() * 24 || ' hours')::interval             AS session_start,
    (ARRAY['google','facebook','newsletter','direct','referral'])[1 + (random()*4)::INT] AS utm_source,
    (ARRAY['Spring Sale Search','Summer Social Boost','Black Friday Email','Winter Remarketing', NULL])[1 + (random()*4)::INT] AS utm_campaign,
    (ARRAY['mobile','desktop','tablet'])[1 + (random()*2)::INT] AS device_type
FROM generate_series(1, 60000) AS gs;


---------------------------------------------------------------------------
-- 7. Szybkie sanity check – liczności tabel (opcjonalnie)
--
-- Możesz odpalić poniższy blok „ad-hoc” po wykonaniu skryptu:
--
-- SELECT 'customers'          AS table, COUNT(*) FROM customers
-- UNION ALL
-- SELECT 'products',          COUNT(*) FROM products
-- UNION ALL
-- SELECT 'orders',            COUNT(*) FROM orders
-- UNION ALL
-- SELECT 'order_items',       COUNT(*) FROM order_items
-- UNION ALL
-- SELECT 'traffic_sessions',  COUNT(*) FROM traffic_sessions
-- UNION ALL
-- SELECT 'marketing_campaigns', COUNT(*) FROM marketing_campaigns;
--
-- Jeśli liczby są rozsądne (kilka–kilkadziesiąt tys. rekordów tam, gdzie trzeba),
-- dataset jest gotowy do pracy na Bloku 3.
---------------------------------------------------------------------------