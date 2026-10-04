---------------------------------------------------------------------------
-- Dataset dla Bloku SQL - Analiza danych
--
-- CEL:
--   Ten plik tworzy schemat i tabele bazy danych `ecommerce_analytics`
--
-- UŻYCIE:
--   1. Zaloguj się do PostgreSQL.
--   2. Utwórz bazę (jeśli jeszcze jej nie ma), np.:
--        CREATE DATABASE ecommerce_analytics;
--   3. Połącz się z tą bazą.
--   4. Uruchom TEN plik (schema) – tworzy tabele, klucze, podstawowe indeksy.
--   5. Osobny plik z danymi (INSERT / generate_series) odpalasz później.
--
-- UWAGA:
--   - Plik jest idempotentny na poziomie tabel: najpierw DROP, potem CREATE.
--   - Jeśli chcesz zachować dane, zakomentuj sekcje DROP TABLE.
---------------------------------------------------------------------------

-- 1. Schemat i search_path
CREATE SCHEMA IF NOT EXISTS ecommerce_analytics;
SET search_path TO ecommerce_analytics, public;

---------------------------------------------------------------------------
-- 2. Tabela customers – klienci
--
-- customer_id          (int, PK)     – identyfikator klienta
-- customer_created_at  (timestamp)   – data rejestracji
-- country              (text)        – kraj (np. PL, DE, FR)
-- city                 (text)        – miasto
-- marketing_channel    (text)        – kanał pozyskania (organic, ads, email…)
---------------------------------------------------------------------------

DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id          INTEGER      PRIMARY KEY,
    customer_created_at  TIMESTAMP    NOT NULL,
    country              TEXT         NOT NULL,
    city                 TEXT,
    marketing_channel    TEXT
);

-- Indeksy pomocnicze pod analizy
CREATE INDEX IF NOT EXISTS idx_customers_country
    ON customers(country);

CREATE INDEX IF NOT EXISTS idx_customers_created_at
    ON customers(customer_created_at);


---------------------------------------------------------------------------
-- 3. Tabela products – produkty
--
-- product_id   (int, PK)       – identyfikator produktu
-- category     (text)          – kategoria (electronics, fashion, …)
-- sub_category (text)          – podkategoria (premium, standard, budget…)
-- price        (numeric(10,2)) – cena katalogowa
---------------------------------------------------------------------------

DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id    INTEGER        PRIMARY KEY,
    category      TEXT           NOT NULL,
    sub_category  TEXT,
    price         NUMERIC(10,2)  NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_products_category
    ON products(category);

CREATE INDEX IF NOT EXISTS idx_products_sub_category
    ON products(sub_category);


---------------------------------------------------------------------------
-- 4. Tabela orders – zamówienia
--
-- order_id      (int, PK)     – identyfikator zamówienia
-- customer_id   (int, FK)     – klient (customers.customer_id)
-- order_date    (timestamp)   – data złożenia zamówienia
-- order_status  (text)        – completed / cancelled / pending / …
-- payment_method(text)        – card / blik / transfer / paypal / …
---------------------------------------------------------------------------

DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
    order_id       INTEGER      PRIMARY KEY,
    customer_id    INTEGER      NOT NULL,
    order_date     TIMESTAMP    NOT NULL,
    order_status   TEXT         NOT NULL,
    payment_method TEXT         NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_orders_status
    ON orders(order_status);


---------------------------------------------------------------------------
-- 5. Tabela order_items – pozycje zamówień
--
-- order_item_id (int, PK)        – identyfikator pozycji
-- order_id      (int, FK)        – zamówienie (orders.order_id)
-- product_id    (int, FK)        – produkt (products.product_id)
-- quantity      (int)            – liczba sztuk
-- unit_price    (numeric(10,2))  – cena jednostkowa w momencie zakupu
-- discount      (numeric(10,2))  – rabat kwotowy (NULL jeśli brak)
--
-- Wartość pozycji (logika w zapytaniach):
--   value_line = quantity * unit_price - COALESCE(discount, 0)
---------------------------------------------------------------------------

DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE order_items (
    order_item_id  INTEGER        PRIMARY KEY,
    order_id       INTEGER        NOT NULL,
    product_id     INTEGER        NOT NULL,
    quantity       INTEGER        NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(10,2)  NOT NULL CHECK (unit_price >= 0),
    discount       NUMERIC(10,2),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);


---------------------------------------------------------------------------
-- 6. Tabela traffic_sessions – sesje na stronie
--
-- session_id    (int, PK)     – identyfikator sesji
-- customer_id   (int, NULL)   – klient (jeśli zalogowany)
-- session_start (timestamp)   – początek sesji
-- utm_source    (text)        – źródło (google, facebook, newsletter, …)
-- utm_campaign  (text)        – nazwa kampanii (np. 'Spring Sale Search')
-- device_type   (text)        – mobile / desktop / tablet
---------------------------------------------------------------------------

DROP TABLE IF EXISTS traffic_sessions CASCADE;

CREATE TABLE traffic_sessions (
    session_id    INTEGER      PRIMARY KEY,
    customer_id   INTEGER,
    session_start TIMESTAMP    NOT NULL,
    utm_source    TEXT,
    utm_campaign  TEXT,
    device_type   TEXT,
    CONSTRAINT fk_sessions_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE INDEX IF NOT EXISTS idx_sessions_customer_id
    ON traffic_sessions(customer_id);

CREATE INDEX IF NOT EXISTS idx_sessions_session_start
    ON traffic_sessions(session_start);

CREATE INDEX IF NOT EXISTS idx_sessions_utm_campaign
    ON traffic_sessions(utm_campaign);


---------------------------------------------------------------------------
-- 7. Tabela marketing_campaigns – kampanie marketingowe
--
-- campaign_id   (int, PK)
-- campaign_name (text)       – nazwa kampanii
-- start_date    (date)       – początek kampanii
-- end_date      (date)       – koniec kampanii
-- channel       (text)       – kanał (paid_search, social_ads, email, …)
--
-- Uwaga:
--   - Nie ma twardego FK do traffic_sessions. Łączymy logicznie po utm_campaign
--     i ewentualnie datach (start_date/end_date).
---------------------------------------------------------------------------

DROP TABLE IF EXISTS marketing_campaigns CASCADE;

CREATE TABLE marketing_campaigns (
    campaign_id   INTEGER    PRIMARY KEY,
    campaign_name TEXT       NOT NULL,
    start_date    DATE       NOT NULL,
    end_date      DATE       NOT NULL,
    channel       TEXT       NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_campaigns_channel
    ON marketing_campaigns(channel);

CREATE INDEX IF NOT EXISTS idx_campaigns_dates
    ON marketing_campaigns(start_date, end_date);


---------------------------------------------------------------------------
-- 8. Podsumowanie
--
-- Po uruchomieniu tego pliku masz:
--   - komplet tabel pod zadania z Bloku 3,
--   - podstawowe indeksy, które pomagają przy typowych analizach:
--       * filtry po dacie, kraju, statusie, kampanii,
--       * joiny po kluczach obcych.
--
-- Następny krok:
--   Uruchom plik z danymi (np. dataset_ecommerce_analytics_data.sql),
--   który wypełni te tabele syntetycznymi, ale biznesowo spójnymi danymi.
---------------------------------------------------------------------------