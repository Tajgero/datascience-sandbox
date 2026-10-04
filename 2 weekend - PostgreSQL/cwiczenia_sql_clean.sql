-- =====================================================================
-- Blok 2 – SQL: Podstawowa składnia
-- Plik: cwiczenia_sql_clean.sql (wersja bez rozwiązań)
-- =====================================================================
-- Ten plik zawiera treści zadań oraz szkielety zapytań SQL BEZ gotowych
-- odpowiedzi. Używaj go w DBeaver (lub innym kliencie), dopisując własne
-- rozwiązania w miejscach oznaczonych jako TODO.
--
-- Rekomendacja pracy:
-- - każde zadanie traktuj jako osobny blok,
-- - uruchamiaj zapytania fragmentami,
-- - dopisuj własne komentarze z wnioskami.
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
--    - customer_id              UUID          -- klucz główny klienta
--    - customer_unique_id       UUID          -- logiczny identyfikator klienta
--    - customer_city            TEXT          -- miasto klienta
--    - customer_state           TEXT          -- region / stan, np. 'SP'
--    - customer_created_at      TIMESTAMP     -- data pierwszej rejestracji
--
-- 2. olist_orders
--    - order_id                 UUID          -- klucz główny zamówienia
--    - customer_id              UUID          -- FK -> olist_customers.customer_id
--    - order_status             TEXT          -- status zamówienia (delivered, canceled, ...)
--    - order_purchase_timestamp TIMESTAMP     -- data złożenia zamówienia
--    - order_approved_at        TIMESTAMP     -- data akceptacji
--    - order_delivered_carrier_date   TIMESTAMP
--    - order_delivered_customer_date  TIMESTAMP
--    - order_estimated_delivery_date  TIMESTAMP
--
-- 3. olist_order_items
--    - order_id                 UUID          -- FK -> olist_orders.order_id
--    - order_item_id            INTEGER       -- numer pozycji w ramach zamówienia
--    - product_id               UUID          -- FK -> olist_products.product_id
--    - seller_id                UUID          -- sprzedawca
--    - shipping_limit_date      TIMESTAMP
--    - price                    NUMERIC(10,2) -- cena jednostkowa
--    - freight_value            NUMERIC(10,2) -- koszt wysyłki dla pozycji
--
-- 4. olist_products
--    - product_id               UUID          -- klucz główny produktu
--    - product_category_name    TEXT          -- kategoria produktu
--    - product_name_length      INTEGER
--    - product_description_length INTEGER
--    - product_photos_qty       INTEGER
--    - product_weight_g         NUMERIC
--    - product_length_cm        NUMERIC
--    - product_height_cm        NUMERIC
--    - product_width_cm         NUMERIC
--
-- 5. olist_order_payments
--    - order_id                 UUID          -- FK -> olist_orders.order_id
--    - payment_sequential       INTEGER
--    - payment_type             TEXT          -- np. credit_card, boleto, voucher
--    - payment_installments     INTEGER       -- liczba rat
--    - payment_value            NUMERIC(10,2) -- kwota płatności
--
-- Typowe etykiety / kategorie:
-- - order_status (status zamówienia)
-- - payment_type (typ płatności)
-- - product_category_name (kategoria produktu)
--
-- #####################################################################
-- #  CZĘŚĆ 1 – PIERWSZE SELECT-Y, FILTROWANIE, SORTOWANIE
-- #####################################################################


-- =====================================================================
-- ZADANIE 1: Pierwsze zapytanie do bazy (olist_customers)
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Podejrzyj kilku klientów, żeby zobaczyć strukturę danych.
--
-- Cel techniczny:
--   - pierwsze SELECT,
--   - użycie LIMIT.
--
-- TODO:
--   - wybierz wszystkie lub wybrane kolumny z olist_customers,
--   - ogranicz wynik do kilku wierszy.
-- =====================================================================

-- TODO: ZADANIE 1 – wpisz swoje zapytanie SELECT dla olist_customers
-- SELECT
--     ...
-- FROM olist_customers
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 2: Wybór konkretnych kolumn i aliasy
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Przygotuj listę klientów z miastem i regionem, bez kolumn technicznych.
--
-- Cel techniczny:
--   - wybór konkretnych kolumn,
--   - aliasy kolumn (AS).
--
-- TODO:
--   - wybierz m.in. customer_id, customer_city, customer_state,
--   - nadaj aliasy kolumnom (np. customer_region),
--   - ogranicz wynik do np. 20 wierszy.
-- =====================================================================

-- TODO: ZADANIE 2 – wybór wybranych kolumn z aliasami
-- SELECT
--     ...
-- FROM olist_customers
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 3: Filtrowanie klientów po regionie (WHERE)
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Potrzebujesz listy klientów z wybranego regionu (np. 'SP').
--
-- Cel techniczny:
--   - użycie WHERE z operatorem = na kolumnie tekstowej.
--
-- TODO:
--   - najpierw możesz sprawdzić dostępne regiony (DISTINCT),
--   - wybierz klientów z jednego regionu.
-- =====================================================================

-- TODO: ZADANIE 3 – filtr na customer_state
-- SELECT
--     ...
-- FROM olist_customers
-- WHERE ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 4: Operatory logiczne AND / OR / NOT
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Wybierz klientów z kilku wybranych regionów.
--
-- Cel techniczny:
--   - złożone warunki w WHERE (AND, OR, NOT),
--   - ewentualnie IN (...).
--
-- TODO:
--   - przygotuj zapytanie z kilkoma warunkami na customer_state,
--   - spróbuj wersji z OR oraz wersji z IN,
--   - spróbuj NOT dla wybranego regionu.
-- =====================================================================

-- TODO: ZADANIE 4 – złożone warunki WHERE
-- SELECT
--     ...
-- FROM olist_customers
-- WHERE ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 5: Sortowanie i LIMIT – ostatnie zamówienia
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Pokaż 20 najnowszych zamówień.
--
-- Cel techniczny:
--   - ORDER BY po dacie,
--   - sortowanie malejące (DESC),
--   - LIMIT.
--
-- TODO:
--   - użyj olist_orders i order_purchase_timestamp,
--   - posortuj malejąco, ogranicz wynik.
-- =====================================================================

-- TODO: ZADANIE 5 – ORDER BY i LIMIT
-- SELECT
--     ...
-- FROM olist_orders
-- ORDER BY ...
-- LIMIT ...;




-- #####################################################################
-- #  CZĘŚĆ 2 – TYPY DANYCH, ARYTMETYKA, FUNKCJE TEKSTOWE I DATY
-- #####################################################################


-- =====================================================================
-- ZADANIE 6: Przegląd typów danych w tabelach
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Zrozum strukturę tabel z zamówieniami i płatnościami.
--
-- Cel techniczny:
--   - SELECT * z LIMIT,
--   - identyfikacja typów w DBeaver (NUMERIC, TEXT, TIMESTAMP).
--
-- TODO:
--   - podejrzyj kilka wierszy z olist_orders,
--   - podejrzyj kilka wierszy z olist_order_payments.
-- =====================================================================

-- TODO: ZADANIE 6 – podgląd danych
-- SELECT * FROM olist_orders LIMIT ...;
-- SELECT * FROM olist_order_payments LIMIT ...;




-- =====================================================================
-- ZADANIE 7: Operatory arytmetyczne – wartość pozycji
-- ---------------------------------------------------------------------
-- The business task:
--   Oblicz wartość pozycji w zamówieniu (cena + koszt dostawy).
--
-- Cel techniczny:
--   - wyrażenie arytmetyczne w SELECT.
--
-- TODO:
--   - użyj olist_order_items,
--   - policz price + freight_value i nadaj alias (np. item_total).
-- =====================================================================

-- TODO: ZADANIE 7 – wyrażenie arytmetyczne na price i freight_value
-- SELECT
--     ...
-- FROM olist_order_items
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 8: Zaokrąglanie – ROUND (opcjonalnie ABS)
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Chcemy pokazać wartości płatności w 2 miejscach po przecinku.
--
-- Cel techniczny:
--   - funkcja ROUND na kolumnie liczbowej.
--
-- TODO:
--   - użyj payment_value z olist_order_payments,
--   - zastosuj ROUND(payment_value, 2) z aliasem.
-- =====================================================================

-- TODO: ZADANIE 8 – ROUND na payment_value
-- SELECT
--     ...
-- FROM olist_order_payments
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 9: Podstawowe funkcje tekstowe – UPPER, LOWER, LENGTH
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Ujednolicenie zapisu kategorii produktów i sprawdzenie długości nazw.
--
-- Cel techniczny:
--   - UPPER, LOWER, LENGTH na product_category_name.
--
-- TODO:
--   - użyj olist_products,
--   - dodaj kolumny z wersją UPPER, LOWER i LENGTH.
-- =====================================================================

-- TODO: ZADANIE 9 – funkcje tekstowe na category_name
-- SELECT
--     ...
-- FROM olist_products
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 10: LEFT, RIGHT, REPLACE, LTRIM, RTRIM
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Stwórz skrócony 'tag' kategorii i pokaż prostą transformację tekstu.
--
-- Cel techniczny:
--   - użycie LEFT, RIGHT, REPLACE, LTRIM, RTRIM w SELECT.
--
-- TODO:
--   - przygotuj skrócony tag (np. pierwsze 3 znaki),
--   - zastosuj REPLACE do zmiany tekstu,
--   - poeksperymentuj z LTRIM/RTRIM.
-- =====================================================================

-- TODO: ZADANIE 10 – zaawansowane funkcje tekstowe
-- SELECT
--     ...
-- FROM olist_products
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 11: Funkcje daty – DATE_PART, TO_CHAR
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Przygotuj kolumny rok, miesiąc i rok-miesiąc z daty zakupu zamówienia.
--
-- Cel techniczny:
--   - DATE_PART('year', ...), DATE_PART('month', ...),
--   - TO_CHAR(..., 'YYYY-MM').
--
-- TODO:
--   - użyj olist_orders i order_purchase_timestamp,
--   - dodaj kolumny z rokiem, miesiącem, rok-miesiąc.
-- =====================================================================

-- TODO: ZADANIE 11 – DATE_PART i TO_CHAR
-- SELECT
--     ...
-- FROM olist_orders
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 12: Obsługa NULL – COALESCE i NULLIF
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Zastąp brakującą datę dostawy wartością planowanej dostawy oraz
--   pokaż prosty przykład użycia NULLIF.
--
-- Cel techniczny:
--   - COALESCE(order_delivered_customer_date, order_estimated_delivery_date),
--   - NULLIF(x, 0) jako ochrona przed dzieleniem przez zero.
--
-- TODO:
--   - przygotuj SELECT z COALESCE na datach,
--   - dodaj prosty przykład NULLIF (np. w osobnym SELECT).
-- =====================================================================

-- TODO: ZADANIE 12 – COALESCE i NULLIF
-- SELECT
--     ...
-- FROM olist_orders
-- LIMIT ...;
--
-- SELECT
--     ...
-- ;




-- =====================================================================
-- ZADANIE 13: GREATEST i LEAST na datach
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Wyznacz najwcześniejszą i najpóźniejszą znaną datę etapu zamówienia.
--
-- Cel techniczny:
--   - GREATEST(...) i LEAST(...) na kolumnach typu TIMESTAMP.
--
-- TODO:
--   - użyj kilku kolumn datowych z olist_orders,
--   - zbuduj kolumny earliest_event i latest_event.
-- =====================================================================

-- TODO: ZADANIE 13 – GREATEST / LEAST na datach zamówień
-- SELECT
--     ...
-- FROM olist_orders
-- WHERE ...
-- LIMIT ...;




-- #####################################################################
-- #  CZĘŚĆ 3 – AGREGACJE, GROUP BY, HAVING, CASE
-- #####################################################################


-- =====================================================================
-- ZADANIE 14: COUNT i COUNT(DISTINCT)
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Porównaj liczbę wszystkich zamówień z liczbą unikalnych klientów.
--
-- Cel techniczny:
--   - COUNT(*),
--   - COUNT(DISTINCT customer_id).
--
-- TODO:
--   - pracuj na olist_orders,
--   - policz obie wartości w jednym zapytaniu.
-- =====================================================================

-- TODO: ZADANIE 14 – liczba zamówień vs liczba klientów
-- SELECT
--     ...
-- FROM olist_orders;




-- =====================================================================
-- ZADANIE 15: SUM, AVG, MIN, MAX na płatnościach
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Podstawowe statystyki wartości płatności.
--
-- Cel techniczny:
--   - SUM, AVG, MIN, MAX na payment_value,
--   - opcjonalnie GROUP BY payment_type.
--
-- TODO:
--   - policz statystyki globalne,
--   - policz statystyki dla każdego payment_type (osobne zapytanie).
-- =====================================================================

-- TODO: ZADANIE 15 – agregacje na payment_value
-- -- wariant globalny
-- SELECT
--     ...
-- FROM olist_order_payments;
--
-- -- wariant per typ płatności
-- SELECT
--     ...
-- FROM olist_order_payments
-- GROUP BY ...
-- ORDER BY ...;




-- =====================================================================
-- ZADANIE 16: GROUP BY – liczba zamówień na klienta
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Sprawdź, jak często klienci składają zamówienia (liczba zamówień / klient).
--
-- Cel techniczny:
--   - GROUP BY customer_id,
--   - COUNT(order_id).
--
-- TODO:
--   - policz liczbę zamówień na klienta,
--   - posortuj malejąco po liczbie zamówień,
--   - ogranicz wynik (np. TOP 20).
-- =====================================================================

-- TODO: ZADANIE 16 – GROUP BY customer_id
-- SELECT
--     ...
-- FROM olist_orders
-- GROUP BY ...
-- ORDER BY ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 17: HAVING – klienci 'lojalni'
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Znajdź klientów, którzy złożyli co najmniej N zamówień.
--
-- Cel techniczny:
--   - HAVING COUNT(order_id) >= N.
--
-- TODO:
--   - wykorzystaj zapytanie z ZADANIA 16 jako bazę,
--   - dodaj HAVING z progiem (np. 5).
-- =====================================================================

-- TODO: ZADANIE 17 – filtr na liczbie zamówień (HAVING)
-- SELECT
--     ...
-- FROM olist_orders
-- GROUP BY ...
-- HAVING ...
-- ORDER BY ...;




-- =====================================================================
-- ZADANIE 18: CASE – segmentacja wartości zamówienia
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Podziel zamówienia na 'małe', 'średnie', 'duże' wg wartości.
--
-- Cel techniczny:
--   - CASE WHEN ... THEN ... ELSE ... END,
--   - GROUP BY segment.
--
-- TODO:
--   - wybierz źródło wartości zamówienia (payment_value lub suma pozycji),
--   - zdefiniuj segmenty wartości (progi),
--   - policz liczbę zamówień w każdym segmencie.
-- =====================================================================

-- TODO: ZADANIE 18 – CASE do segmentacji
-- SELECT
--     ...
-- FROM ...
-- GROUP BY ...
-- ORDER BY ...;




-- #####################################################################
-- #  CZĘŚĆ 4 – JOIN-Y: ŁĄCZENIE TABEL
-- #####################################################################


-- =====================================================================
-- ZADANIE 19: INNER JOIN – klienci + zamówienia
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Stwórz listę zamówień z informacją o mieście i regionie klienta.
--
-- Cel techniczny:
--   - INNER JOIN olist_orders i olist_customers po customer_id.
--
-- TODO:
--   - wybierz sensowne kolumny (order_id, daty, miasto, region),
--   - nadaj aliasy tabelom (np. o, c).
-- =====================================================================

-- TODO: ZADANIE 19 – INNER JOIN orders + customers
-- SELECT
--     ...
-- FROM olist_orders AS o
-- JOIN olist_customers AS c
--     ON ...
-- ORDER BY ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 20: LEFT JOIN – klienci bez zamówień
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Znajdź klientów, którzy nie złożyli żadnego zamówienia.
--
-- Cel techniczny:
--   - LEFT JOIN customers (lewa) + orders (prawa),
--   - filtr na NULL w kolumnie z zamówień.
--
-- TODO:
--   - wykonaj LEFT JOIN,
--   - w WHERE wyfiltruj rekordy bez dopasowanego zamówienia.
-- =====================================================================

-- TODO: ZADANIE 20 – klienci bez zamówień
-- SELECT
--     ...
-- FROM olist_customers AS c
-- LEFT JOIN olist_orders AS o
--     ON ...
-- WHERE ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 21: RIGHT JOIN i FULL JOIN – porównanie
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Porównaj liczbę wierszy dla różnych typów JOIN-ów.
--
-- Cel techniczny:
--   - RIGHT JOIN,
--   - FULL JOIN,
--   - COUNT(*).
--
-- TODO:
--   - policz liczbę wierszy dla INNER, LEFT, RIGHT, FULL (może być kilka zapytań),
--   - porównaj wyniki.
-- =====================================================================

-- TODO: ZADANIE 21 – eksperymenty z JOIN-ami
-- -- przykładowe miejsce na zapytania COUNT(*) dla różnych JOIN-ów
-- SELECT COUNT(*) AS inner_join_rows
-- FROM ...
-- JOIN ... ON ...;
--
-- SELECT COUNT(*) AS left_join_rows
-- FROM ...
-- LEFT JOIN ... ON ...;
--
-- SELECT COUNT(*) AS right_join_rows
-- FROM ...
-- RIGHT JOIN ... ON ...;
--
-- SELECT COUNT(*) AS full_join_rows
-- FROM ...
-- FULL JOIN ... ON ...;




-- =====================================================================
-- ZADANIE 22: CROSS JOIN – kombinacje miesięcy i kategorii
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Przygotuj wszystkie kombinacje miesięcy (z zamówień) i kategorii produktów.
--
-- Cel techniczny:
--   - użycie CROSS JOIN na dwóch listach wartości.
--
-- TODO:
--   - zbuduj listę miesięcy (np. CTE 'months'),
--   - zbuduj listę kategorii (CTE 'categories'),
--   - połącz je CROSS JOIN-em.
-- =====================================================================

-- TODO: ZADANIE 22 – CROSS JOIN miesięcy i kategorii
-- WITH months AS (
--     SELECT DISTINCT
--         ...
--     FROM olist_orders
-- ),
-- categories AS (
--     SELECT DISTINCT
--         ...
--     FROM olist_products
-- )
-- SELECT
--     ...
-- FROM months m
-- CROSS JOIN categories c
-- ORDER BY ...
-- LIMIT ...;




-- =====================================================================
-- ZADANIE 23: Multi-join – zamówienia, pozycje, produkty
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Znajdź top kategorie produktów pod względem przychodu.
--
-- Cel techniczny:
--   - JOIN trzech tabel: orders, order_items, products,
--   - agregacja SUM po kategorii.
--
-- TODO:
--   - połącz oi -> o -> p,
--   - policz SUM(price + freight_value) po product_category_name,
--   - posortuj malejąco po przychodzie, pokaż TOP N.
-- =====================================================================

-- TODO: ZADANIE 23 – JOIN 3 tabel + agregacja
-- SELECT
--     ...
-- FROM olist_order_items AS oi
-- JOIN olist_orders AS o
--     ON ...
-- JOIN olist_products AS p
--     ON ...
-- GROUP BY ...
-- ORDER BY ...
-- LIMIT ...;




-- #####################################################################
-- #  CZĘŚĆ 5 – OPERACJE NA ZBIORACH I WIDOKI
-- #####################################################################


-- =====================================================================
-- ZADANIE 24: UNION vs UNION ALL
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Połącz dwie listy zamówień z różnych okresów i porównaj UNION ALL z UNION.
--
-- Cel techniczny:
--   - użycie UNION ALL,
--   - użycie UNION (usunięcie duplikatów),
--   - porównanie liczby wierszy.
--
-- TODO:
--   - przygotuj dwie listy order_id z różnych lat (lub przedziałów),
--   - połącz je UNION ALL w jednym zapytaniu,
--   - połącz je UNION w drugim i porównaj.
-- =====================================================================

-- TODO: ZADANIE 24 – UNION ALL vs UNION
-- WITH orders_a AS (
--     SELECT ...
--     FROM olist_orders
--     WHERE ...
-- ),
-- orders_b AS (
--     SELECT ...
--     FROM olist_orders
--     WHERE ...
-- )
-- SELECT ...
-- FROM (
--     SELECT ... FROM orders_a
--     UNION ALL
--     SELECT ... FROM orders_b
-- ) t1;
--
-- SELECT ...
-- FROM (
--     SELECT ... FROM orders_a
--     UNION
--     SELECT ... FROM orders_b
-- ) t2;




-- =====================================================================
-- ZADANIE 25: EXCEPT i INTERSECT
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Znajdź klientów kupujących tylko w jednym okresie oraz w obu.
--
-- Cel techniczny:
--   - EXCEPT,
--   - INTERSECT,
--   - praca na listach DISTINCT customer_id.
--
-- TODO:
--   - przygotuj listy klientów z dwóch okresów (np. 2017 i 2018),
--   - znajdź: klientów w obu latach (INTERSECT),
--             tylko w pierwszym (EXCEPT),
--             tylko w drugim (EXCEPT).
-- =====================================================================

-- TODO: ZADANIE 25 – EXCEPT / INTERSECT
-- WITH customers_a AS (
--     SELECT DISTINCT ...
--     FROM olist_orders
--     WHERE ...
-- ),
-- customers_b AS (
--     SELECT DISTINCT ...
--     FROM olist_orders
--     WHERE ...
-- )
-- SELECT ...
-- FROM (
--     SELECT ... FROM customers_a
--     INTERSECT
--     SELECT ... FROM customers_b
-- ) both_years;
--
-- SELECT ...
-- FROM (
--     SELECT ... FROM customers_a
--     EXCEPT
--     SELECT ... FROM customers_b
-- ) only_a;
--
-- SELECT ...
-- FROM (
--     SELECT ... FROM customers_b
--     EXCEPT
--     SELECT ... FROM customers_a
-- ) only_b;




-- =====================================================================
-- ZADANIE 26: CREATE VIEW – zapisanie raportu
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Stwórz widok z dziennym przychodem (orders + order_items).
--
-- Cel techniczny:
--   - CREATE VIEW ... AS (zapytanie),
--   - późniejsze SELECT z widoku,
--   - ewentualnie DROP VIEW.
--
-- TODO:
--   - najpierw zbuduj zapytanie liczące przychód per dzień,
--   - otocz je CREATE VIEW,
--   - przetestuj SELECT z widoku.
-- =====================================================================

-- TODO: ZADANIE 26 – CREATE VIEW dla dziennego przychodu
-- CREATE VIEW olist_daily_revenue AS
-- SELECT
--     ...
-- FROM ...
-- JOIN ...
--     ON ...
-- GROUP BY ...;
--
-- -- Test użycia widoku
-- SELECT
--     ...
-- FROM olist_daily_revenue
-- ORDER BY ...
-- LIMIT ...;
--
-- -- (opcjonalnie) usunięcie widoku po testach
-- -- DROP VIEW olist_daily_revenue;




-- #####################################################################
-- #  CZĘŚĆ 6 – MINI-PROJEKTY
-- #####################################################################


-- =====================================================================
-- ZADANIE 27 (Mini-projekt 1): Raport dzienny sprzedaży
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Przygotuj zapytanie (lub zestaw zapytań), które mogłoby zasilać
--   prosty dashboard dzienny z KPI:
--   - liczba zamówień,
--   - przychód,
--   - średnia wartość zamówienia.
--
-- Cel techniczny:
--   - integracja: funkcje daty, JOIN, agregacje, CASE (jeśli chcesz).
--
-- TODO:
--   - wybierz metryki, które chcesz mieć w raporcie,
--   - zbuduj zapytanie grupujące po dacie,
--   - policz KPI w osobnych kolumnach.
-- =====================================================================

-- TODO: ZADANIE 27 – raport dzienny sprzedaży
-- SELECT
--     ...
-- FROM ...
-- JOIN ...
--     ON ...
-- GROUP BY ...
-- ORDER BY ...;




-- =====================================================================
-- ZADANIE 28 (Mini-projekt 2): Analiza jakości danych zamówień
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Sprawdź jakość danych, np.:
--   - odsetek zamówień bez daty dostawy,
--   - różnice między datą planowaną a faktyczną,
--   - inne „dziwne” wartości.
--
-- Cel techniczny:
--   - COALESCE, CASE,
--   - agregacje, filtry,
--   - opcjonalnie JOIN-y.
--
-- TODO:
--   - przygotuj kilka zapytań, które badają różne aspekty jakości danych,
--   - policz odsetek problematycznych rekordów,
--   - możesz korzystać z funkcji dat i agregacji.
-- =====================================================================

-- TODO: ZADANIE 28 – analiza jakości danych
-- SELECT
--     ...
-- FROM olist_orders
-- WHERE ...
-- GROUP BY ...;




-- #####################################################################
-- #  ZADANIE DOMOWE (DLA CHĘTNYCH)
-- #####################################################################


-- =====================================================================
-- ZADANIE H1: Profilowanie klienta
-- ---------------------------------------------------------------------
-- Opis biznesowy:
--   Dla wybranego klienta (customer_id) przygotuj zestaw zapytań
--   pokazujących jego historię zakupową:
--   - liczba zamówień,
--   - sumaryczna i średnia wartość zamówienia,
--   - kategorie produktów,
--   - sezonowość (w jakich miesiącach klient kupuje).
--
-- Cel techniczny:
--   - utrwalenie JOIN-ów, agregacji, CASE, funkcji daty.
--
-- TODO:
--   1. Wybierz konkretne customer_id (np. z losowej próbki).
--   2. Zbuduj kilka zapytań:
--      - baza: zamówienia klienta,
--      - wartości płatności,
--      - kategorie produktów,
--      - rozkład po czasie.
-- =====================================================================

-- TODO: ZADANIE H1 – profilowanie wybranego klienta
-- -- najpierw wypisz kilka customer_id do wyboru
-- SELECT DISTINCT customer_id
-- FROM olist_orders
-- LIMIT ...;
--
-- -- a następnie stwórz zapytania analizujące konkretnego klienta
-- -- (wstaw tutaj wybrane customer_id)
-- SELECT
--     ...
-- FROM ...
-- WHERE ...
-- GROUP BY ...;


-- =====================================================================
-- KONIEC PLIKU: cwiczenia_sql_clean.sql
-- =====================================================================
