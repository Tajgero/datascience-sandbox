-- =====================================================================
-- Blok 2 – SQL: Podstawowa składnia
-- Plik: setup_olist_schema.sql
-- =====================================================================
-- Ten skrypt tworzy schemat `olist` oraz podstawowe tabele, na których
-- oparte są wszystkie ćwiczenia w module:
--
--   - olist_customers
--   - olist_orders
--   - olist_order_items
--   - olist_products
--   - olist_order_payments
--
-- Uruchom ten plik w DBeaver (lub innym kliencie) na wybranej bazie
-- PostgreSQL (np. ds_bootcamp).
--
-- Kolejny krok po tym pliku: załadowanie danych (setup_olist_data.sql).
-- =====================================================================


-- Bezpiecznie: utwórz schemat, jeśli nie istnieje
CREATE SCHEMA IF NOT EXISTS olist;

SET search_path TO olist, public;


-- #####################################################################
-- #  TABELA: olist_customers
-- #####################################################################
-- Dane klientów (lokalizacja, identyfikatory).
-- #####################################################################

DROP TABLE IF EXISTS olist_customers CASCADE;

CREATE TABLE olist_customers (
    customer_id           UUID PRIMARY KEY,          -- techniczny identyfikator klienta
    customer_unique_id    UUID NOT NULL,             -- logiczny identyfikator klienta (ta sama osoba może mieć wiele customer_id)
    customer_city         TEXT NOT NULL,             -- miasto klienta
    customer_state        TEXT NOT NULL,             -- region / stan (np. 'SP')
    customer_created_at   TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()  -- data pierwszej rejestracji (lub pierwszej obserwacji)
);

-- Przydatne indeksy
CREATE INDEX IF NOT EXISTS idx_olist_customers_state
    ON olist_customers (customer_state);

CREATE INDEX IF NOT EXISTS idx_olist_customers_unique_id
    ON olist_customers (customer_unique_id);


-- #####################################################################
-- #  TABELA: olist_orders
-- #####################################################################
-- Zamówienia klientów – jeden rekord = jedno zamówienie.
-- #####################################################################

DROP TABLE IF EXISTS olist_orders CASCADE;

CREATE TABLE olist_orders (
    order_id                        UUID PRIMARY KEY,  -- identyfikator zamówienia
    customer_id                     UUID NOT NULL,     -- powiązany klient (FK)
    order_status                    TEXT NOT NULL,     -- status (delivered, shipped, canceled, ...)
    order_purchase_timestamp        TIMESTAMP WITHOUT TIME ZONE NOT NULL,  -- data złożenia zamówienia
    order_approved_at               TIMESTAMP WITHOUT TIME ZONE,           -- data akceptacji płatności
    order_delivered_carrier_date    TIMESTAMP WITHOUT TIME ZONE,           -- przekazanie kurierowi
    order_delivered_customer_date   TIMESTAMP WITHOUT TIME ZONE,           -- dostawa do klienta
    order_estimated_delivery_date   TIMESTAMP WITHOUT TIME ZONE,           -- planowana data dostawy

    CONSTRAINT fk_olist_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES olist_customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Indeksy wspierające najczęstsze zapytania
CREATE INDEX IF NOT EXISTS idx_olist_orders_customer_id
    ON olist_orders (customer_id);

CREATE INDEX IF NOT EXISTS idx_olist_orders_purchase_ts
    ON olist_orders (order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_olist_orders_status
    ON olist_orders (order_status);


-- #####################################################################
-- #  TABELA: olist_products
-- #####################################################################
-- Produkty – podstawowe informacje + proste cechy.
-- #####################################################################

DROP TABLE IF EXISTS olist_products CASCADE;

CREATE TABLE olist_products (
    product_id                 UUID PRIMARY KEY,           -- identyfikator produktu
    product_category_name      TEXT,                       -- kategoria produktu (może być NULL)
    product_name_length        INTEGER,                    -- długość nazwy
    product_description_length INTEGER,                    -- długość opisu
    product_photos_qty         INTEGER,                    -- liczba zdjęć
    product_weight_g           NUMERIC,                    -- waga (g)
    product_length_cm          NUMERIC,                    -- długość (cm)
    product_height_cm          NUMERIC,                    -- wysokość (cm)
    product_width_cm           NUMERIC                     -- szerokość (cm)
);

CREATE INDEX IF NOT EXISTS idx_olist_products_category
    ON olist_products (product_category_name);


-- #####################################################################
-- #  TABELA: olist_order_items
-- #####################################################################
-- Pozycje w zamówieniu – jeden wiersz = jedna pozycja (produkt, cena).
-- #####################################################################

DROP TABLE IF EXISTS olist_order_items CASCADE;

CREATE TABLE olist_order_items (
    order_id            UUID   NOT NULL,                  -- FK -> olist_orders
    order_item_id       INTEGER NOT NULL,                 -- kolejny numer pozycji w zamówieniu
    product_id          UUID   NOT NULL,                  -- FK -> olist_products
    seller_id           UUID   NOT NULL,                  -- sprzedawca (bez osobnej tabeli – uproszczenie)
    shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,      -- deadline wysyłki
    price               NUMERIC(10,2) NOT NULL,           -- cena jednostkowa produktu
    freight_value       NUMERIC(10,2) NOT NULL,           -- koszt dostawy przypisany do pozycji

    CONSTRAINT pk_olist_order_items
        PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_olist_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES olist_orders (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_olist_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES olist_products (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_olist_order_items_product_id
    ON olist_order_items (product_id);

CREATE INDEX IF NOT EXISTS idx_olist_order_items_seller_id
    ON olist_order_items (seller_id);


-- #####################################################################
-- #  TABELA: olist_order_payments
-- #####################################################################
-- Płatności do zamówień – jedno zamówienie może mieć kilka płatności
-- (np. różne raty, vouchery, dopłaty).
-- #####################################################################

DROP TABLE IF EXISTS olist_order_payments CASCADE;

CREATE TABLE olist_order_payments (
    order_id             UUID    NOT NULL,            -- FK -> olist_orders
    payment_sequential   INTEGER NOT NULL,            -- numer płatności w ramach zamówienia (0,1,2,...)
    payment_type         TEXT    NOT NULL,            -- typ płatności (credit_card, boleto, voucher, ...)
    payment_installments INTEGER NOT NULL,            -- liczba rat
    payment_value        NUMERIC(10,2) NOT NULL,      -- kwota płatności

    CONSTRAINT pk_olist_order_payments
        PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_olist_order_payments_order
        FOREIGN KEY (order_id)
        REFERENCES olist_orders (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_olist_order_payments_type
    ON olist_order_payments (payment_type);

CREATE INDEX IF NOT EXISTS idx_olist_order_payments_value
    ON olist_order_payments (payment_value);


-- #####################################################################
-- #  PODSUMOWANIE
-- #####################################################################
-- W tym momencie:
--   - struktura wszystkich tabel jest gotowa,
--   - można już uruchamiać proste zapytania typu SELECT ... FROM ...,
--   - ale w tabelach nie ma jeszcze danych.
--
-- Kolejny krok:
--   - uruchom skrypt setup_olist_data.sql, który wypełni tabele danymi
--     (INSERT/COPY), żeby ćwiczenia z bloków 2+ miały na czym działać.
-- #####################################################################

-- (opcjonalnie) możesz zatwierdzić transakcję:
-- COMMIT;
