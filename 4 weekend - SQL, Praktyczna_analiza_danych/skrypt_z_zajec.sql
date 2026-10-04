-- Zadanie 1: Podstawowa eksploracja zamówień
-- (A) Zlicz liczbę wszystkich zamówień w tabeli olist_orders_dataset.
-- (B) Wyświetl 10 pierwszych zamówień (order_id) wraz z datą zakupu (order_purchase_timestamp).

SELECT COUNT(*) AS total_orders
FROM orders o;

SELECT order_id, order_purchase_timestamp 
FROM orders
ORDER BY order_purchase_timestamp
LIMIT 10;


-- Zadanie 2: Unikalni klienci i liczność zamówień
-- (A) Sprawdź, ilu unikalnych klientów znajduje się w tabeli olist_customers_dataset (kolumna customer_unique_id).
-- (B) Wyświetl 5 przykładowych klientów (customer_unique_id), którzy występują w bazie, wraz z ich stanem (customer_state).

SELECT COUNT(DISTINCT customer_unique_id) AS liczba_unikalnych_klientow
FROM customers;

SELECT DISTINCT customer_unique_id, customer_state
FROM customers
LIMIT 5;


--UWAGA
---zrobic rozklad stanow w tabeli customers

-- Zadanie 3: Filtrowanie zamówień według statusu
-- (A) Policz liczbę zamówień o statusie delivered w tabeli olist_orders_dataset.
-- (B) Wyświetl po 3 przykładowe zamówienia dla każdego statusu: delivered, canceled i unavailable. Użyj klauzuli WHERE z operatorem IN.

SELECT COUNT(*) AS total_delivered
FROM orders o 
WHERE o.order_status = 'delivered'


--SELECT o.order_id, o.order_status 
--FROM orders o 
--WHERE o.order_status IN ('delivered', 'canceled', 'unavailable');


SELECT order_id, order_status, order_purchase_timestamp
FROM (
    SELECT
        order_id,
        order_status,
        order_purchase_timestamp,
        ROW_NUMBER() OVER (PARTITION BY order_status) AS rn
    FROM orders
    WHERE order_status IN ('delivered', 'canceled', 'unavailable')
) t
WHERE rn <= 3;


SELECT order_id, order_status
FROM (
	SELECT
    	order_id,
    	order_status
	FROM orders
	WHERE order_status = 'delivered'
	LIMIT 3
)
UNION ALL
SELECT order_id, order_status
FROM (
	SELECT
    	order_id,
    	order_status
	FROM orders
	WHERE order_status = 'canceled'
	LIMIT 3
)
UNION ALL
SELECT order_id, order_status
FROM (
	SELECT
    	order_id,
    	order_status
	FROM orders
	WHERE order_status = 'unavailable'
	LIMIT 3
);

-- Zadanie 4: Sortowanie wyników
-- (A) Znajdź 5 najstarszych zamówień (według order_purchase_timestamp) i wyświetl order_id, order_status, order_purchase_timestamp.
-- (B) Znajdź 5 najnowszych zamówień i wyświetl to samo, ale posortuj malejąco względem daty zakupu.

SELECT order_id, order_status, order_purchase_timestamp
FROM orders o
ORDER BY order_purchase_timestamp;

SELECT order_id, order_status, order_purchase_timestamp
FROM orders o
ORDER BY order_purchase_timestamp DESC;

-- Zadanie 5: Łączenie zamówień z klientami (INNER JOIN)
-- (A) Zrób wewnętrzne złączenie (INNER JOIN) tabel olist_orders_dataset i olist_customers_dataset, aby uzyskać informacje o customer_unique_id dla każdego order_id. Wyświetl 10 pierwszych rekordów.
-- (B) Policz łączną liczbę zamówień przypisanych do klientów (czyli wynik wewnętrznego złączenia).

-- A
SELECT o.order_id, c.customer_unique_id
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
LIMIT 10;

-- B
SELECT COUNT(*) AS total_joined
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id;

-- Zadanie 6: Łączenie zamówień z klientami (LEFT JOIN)
-- (A) Wyświetl wszystkie order_id i odpowiadające im customer_unique_id za pomocą LEFT JOIN, nawet jeśli dany klient nie istnieje w tabeli olist_customers_dataset (sprawdź, czy takie przypadki są).
-- (B) Policz, ile rekordów znajdzie się w wyniku zapytania z LEFT JOIN w porównaniu do INNER JOIN z Zadania 5.

-- A
SELECT o.order_id, c.customer_unique_id
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
ORDER BY o.order_id
LIMIT 10;

-- B

WITH left_join_count AS (
  SELECT COUNT(*) AS cnt
  FROM orders o
  LEFT JOIN customers c
    ON o.customer_id = c.customer_id
),
inner_join_count AS (
  SELECT COUNT(*) AS cnt
  FROM orders o
  INNER JOIN customers c
    ON o.customer_id = c.customer_id
)
SELECT 
  (SELECT cnt FROM left_join_count) AS left_join_result,
  (SELECT cnt FROM inner_join_count) AS inner_join_result;

------jeden customer_unique_id to nie zawsze unikalny customer_id! 

SELECT
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS customer_ids
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1;

-- Zadanie 7: Analiza płatności
-- (A) Policz, ile zamówień zostało opłaconych każdą metodą płatności (payment_type) w tabeli olist_order_payments_dataset.
-- (B) Wyświetl sumaryczną wartość płatności (payment_value) dla każdego typu płatności (payment_type).

-- A
SELECT op.payment_type, COUNT(*) as total_payment_value
FROM order_payments op 
GROUP BY op.payment_type;

-- B
SELECT op.payment_type, SUM(op.payment_value) as sum_payment_value
FROM order_payments op 
GROUP BY op.payment_type;

-- Zadanie 8: Wielkość zamówień (JOIN z olist_order_items_dataset)
-- (A) Dołącz do tabeli olist_order_items_dataset informacje o statusie zamówienia z olist_orders_dataset (INNER JOIN po order_id). Wyświetl 5 przykładowych wierszy.
-- (B) Policz łączną liczbę produktów (order_item_id) dla zamówień o statusie delivered.

-- A
SELECT oi.*, o.order_status 
FROM order_items oi 
JOIN orders o 
ON oi.order_id = o.order_id
LIMIT 5;

-- B
SELECT COUNT(oi.order_item_id) AS total_item_delivered
FROM order_items oi 
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Zadanie 9: Agregacja wartości zamówień
-- (A) Wykorzystując olist_order_items_dataset, oblicz łączną kwotę (SUM(price)) wszystkich produktów w dostarczonych zamówieniach.
-- (B) Policz łączną kwotę opłat za przesyłkę (SUM(freight_value)) dla tych samych zamówień.

-- A
SELECT SUM(oi.price) AS total_price_delivered
FROM order_items oi 
JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- B
SELECT SUM(oi.freight_value) AS total_freight_delivered
FROM order_items oi 
JOIN orders o
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Zadanie 10: Grupowanie zamówień według stanu klienta
-- (A) Połącz olist_orders_dataset z olist_customers_dataset i zgrupuj zamówienia według customer_state. Policz liczbę zamówień w każdym stanie.
-- (B) Posortuj wyniki malejąco według liczby zamówień, wyświetl top 5 stanów z największą liczbą zamówień.

-- A
SELECT c.customer_state, COUNT(o.order_id) AS num_orders
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state;

-- B
SELECT c.customer_state, COUNT(o.order_id) AS num_orders
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY num_orders DESC
LIMIT 5;


-- Zadanie 11: Sprawdzenie wymiarów i wagi produktów
-- (A) Policz średnią wagę (product_weight_g) produktu w tabeli olist_products_dataset.
-- (B) Policz średnią wysokość (product_height_cm) i szerokość (product_width_cm) produktu.

-- A
SELECT 
    AVG(product_weight_g) AS mean_product_weight_g
FROM products;

-- B
SELECT 
    AVG(product_height_cm) AS mean_product_height_cm,
    AVG(product_width_cm) AS mean_product_width_cm
FROM products;

-- Zadanie 12: Produkty a kategorie
-- (A) Z tabeli olist_products_dataset wyświetl 10 różnych kategorii produktowych (product_category_name) wraz z przykładowym product_id.
-- (B) Połącz ją z tabelą product_category_name_translation, aby dodać tłumaczenie kategorii na język angielski. Wyświetl 10 wierszy.

--A
SELECT DISTINCT
	product_id,
	product_category_name    
FROM products
LIMIT 10;

--B
SELECT p.product_id, p.product_category_name, ct.product_category_name_english
FROM products p 
LEFT JOIN category_translation ct 
	ON p.product_category_name = ct.product_category_name 
LIMIT 10;

-- Zadanie 13: Łączenie informacji o sprzedawcach
-- (A) Zrób INNER JOIN między olist_sellers_dataset a olist_order_items_dataset po kolumnie seller_id. Wyświetl 5 przykładowych rekordów.
-- (B) Policz, ilu unikalnych sprzedawców (seller_id) brało udział w zamówieniach występujących w olist_order_items_dataset.

-- A
SELECT s.*, oi.order_id, oi.product_id
FROM sellers s
INNER JOIN order_items oi 
  ON s.seller_id = oi.seller_id
LIMIT 5;

-- B

SELECT COUNT(DISTINCT s.seller_id) as unique_sellers_count
FROM sellers s
JOIN order_items oi 
  ON s.seller_id = oi.seller_id

--- B drugie
  
SELECT COUNT(DISTINCT s.seller_id) as unique_sellers_count
FROM sellers s;

-- Zadanie 14: Obliczanie średniego kosztu dostawy
-- (A) W tabeli olist_order_items_dataset oblicz średnią wartość freight_value.
-- (B) Wyświetl top 5 rekordów o najwyższej wartości freight_value razem z price.

SELECT AVG(freight_value) AS avg_freight
FROM order_items oi;

-- B
SELECT order_id, price, freight_value, (freight_value + price) 
FROM order_items oi
ORDER BY (freight_value + price) DESC
LIMIT 5;


-- Zadanie 15: Zagnieżdżone zapytania (subqueries)
-- (A) Policz, ile jest zamówień w stanie delivered, korzystając z podzapytania do tabeli olist_orders_dataset, i wyświetl tę liczbę.
-- (B) Wyświetl wszystkie wiersze z tabeli olist_orders_dataset, których order_id pojawia się w podzapytaniu pobierającym order_id z tabeli olist_order_reviews_dataset o review_score = 5.

-- A
SELECT (
	SELECT COUNT(*)
	FROM orders o 
	WHERE o.order_status = "delivered"
) AS delivery_count;


SELECT
    COUNT(order_id) AS orders_count
FROM 
	(SELECT order_id FROM orders WHERE order_status = 'delivered');

--B
SELECT *
FROM orders o 
WHERE order_id IN (
	SELECT t.order_id
	FROM order_reviews t 
	WHERE t.review_score = 5
);

--B z JOINem
SELECT o.*
FROM orders o
JOIN order_reviews t 
	ON o.order_id = t.order_id 
WHERE t.review_score = 5;


-- Zadanie 16: Użycie CTE (Common Table Expressions)
-- (A) Utwórz CTE, które policzy liczbę zamówień w poszczególnych stanach (customer_state). Następnie wyświetl z tego CTE tylko stany, które mają ponad 2000 zamówień.
-- (B) Utwórz CTE, które zwróci zamówienia dostarczone (delivered) w 2017 roku (na podstawie order_purchase_timestamp), a następnie oblicz na nim liczbę tych zamówień.

-- A
WITH order_by_state AS (
	SELECT c.customer_state, COUNT(o.order_id) as order_count
	FROM orders o 
	JOIN customers c 
		ON o.customer_id = c.customer_id
	GROUP BY c.customer_state
)
SELECT customer_state, order_count
FROM order_by_state
WHERE order_count > 2000;

-- B
WITH delivered_2017 AS (
	SELECT *
	FROM orders o 
	WHERE o.order_status = "delivered"
	-- AND EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017;
		AND strftime('%Y', order_purchase_timestamp) = '2017'
)
SELECT COUNT(*) AS delivered_in_2017
FROM delivered_2017;

-- Zadanie 17: Analiza recenzji
-- (A) Policz średni review_score (ocenę) w tabeli olist_order_reviews_dataset.
-- (B) Wyświetl 5 zamówień o najniższej ocenie i sprawdź, czy mają uzupełnione komentarze (review_comment_message).
-- A
SELECT AVG(t.review_score) AS avg_review_score
FROM order_reviews t;

-- B
SELECT t.order_id, t.review_score, t.review_comment_message, t.review_creation_date
FROM order_reviews t 
ORDER BY t.review_score ASC, t.review_creation_date ASC
LIMIT 5;


-- Zadanie 18: Grupowanie recenzji i obliczanie średniej
-- (A) Zgrupuj recenzje według review_score i oblicz liczbę recenzji dla każdej oceny.
-- (B) Policz średnią długość komentarza (LENGTH(review_comment_message)) dla każdej oceny review_score.

-- A
SELECT t.review_score, COUNT(*) AS count_reviews
FROM order_reviews t 
GROUP BY t.review_score
ORDER BY t.review_score;

-- B
SELECT t.review_score, AVG(LENGTH(t.review_comment_message)) AS avg_comment_length
FROM order_reviews t 
GROUP BY t.review_score
ORDER BY t.review_score;


SELECT
    review_score,
    ROUND(AVG(LENGTH(COALESCE(review_comment_message, ''))),4) AS srednia_dlugosc_komentarza
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;




-- Zadanie 19: Relacja między recenzjami a czasem dostawy
-- (A) Przyłącz tabelę olist_order_reviews_dataset do olist_orders_dataset (JOIN po order_id) i oblicz średnią ocenę dla zamówień, w których order_delivered_customer_date < order_estimated_delivery_date.
-- (B) Sprawdź różnicę w średniej ocenie pomiędzy zamówieniami dostarczonymi przed terminem a po terminie.

SELECT AVG(t.review_score) AS avg_score_early_delivery
FROM order_reviews t 
JOIN orders o 
  ON t.order_id = o.order_id
WHERE o.order_delivered_customer_date < o.order_estimated_delivery_date;

-- B
WITH early AS (
  SELECT AVG(t.review_score) AS avg_score_early_delivery
  FROM order_reviews t 
  JOIN orders o
    ON t.order_id = o.order_id
  WHERE o.order_delivered_customer_date < o.order_estimated_delivery_date
),
late AS (
  SELECT AVG(t.review_score) AS avg_score_late_delivery
  FROM order_reviews t 
  JOIN orders o
    ON t.order_id = o.order_id
  WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
)
SELECT early.avg_score_early_delivery, late.avg_score_late_delivery
FROM early, late;


-- Zadanie 20: Analiza geograficzna
-- (A) Sprawdź, w ilu unikalnych miastach (geolocation_city) występują klienci (JOIN tabel olist_customers_dataset i olist_geolocation_dataset po prefiksie kodu pocztowego).
-- (B) Wyświetl 5 miast o najwyższej liczbie klientów, posortuj malejąco po liczbie klientów.

-- A
SELECT COUNT(DISTINCT g.geolocation_city) AS unique_cities
FROM customers c
JOIN geolocation g
  ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


WITH geo_unikalne AS (
    SELECT
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT COUNT(DISTINCT g.geolocation_city) AS liczba_unikalnych_miast
FROM customers c
INNER JOIN geo_unikalne g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;


-- B
SELECT g.geolocation_city, COUNT(distinct(c.customer_unique_id)) AS customer_count
FROM customers c
JOIN geolocation g
  ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY customer_count DESC
LIMIT 5;


WITH geo_unikalne AS (
    SELECT
        geolocation_zip_code_prefix,
        geolocation_city,
        geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT
    g.geolocation_city,
    COUNT(DISTINCT c.customer_unique_id) AS liczba_klientow
FROM customers c
INNER JOIN geo_unikalne g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY liczba_klientow DESC
LIMIT 5;


-- Zadanie 23: Złączenie wielu tabel naraz
-- (A) Za pomocą pojedynczego zapytania, połącz (JOIN) tabele:
-- olist_orders_dataset (alias o)
-- olist_customers_dataset (alias c)
-- olist_order_payments_dataset (alias p)
-- w celu uzyskania informacji: order_id, order_status, payment_type, customer_state. Wyświetl 10 pierwszych wyników.
-- (B) Policz łączną liczbę rekordów zwróconych przez to złączenie.

-- A
SELECT o.order_id,
       o.order_status,
       op.payment_type,
       c.customer_state
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_payments  op
  ON o.order_id = op.order_id
LIMIT 10;

-- B
SELECT COUNT(*)
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_payments op
  ON o.order_id = op.order_id;

-- Zadanie 25: Analiza liczby rat w płatnościach
-- (A) W tabeli olist_order_payments_dataset sprawdź maksymalną liczbę rat (payment_installments) i zlicz, ile zamówień ma właśnie taką najwyższą liczbę rat.
-- (B) Oblicz średnią liczbę rat dla wszystkich zamówień.

-- A

WITH max_installments AS (
  SELECT MAX(op.payment_installments) AS max_inst
  FROM order_payments op 
)
SELECT max_inst AS max_installments,
       (SELECT COUNT(*) 
        FROM order_payments op
        WHERE op.payment_installments = max_inst) AS count_with_max
FROM max_installments;

-- B
SELECT AVG(payment_installments) AS avg_installments
FROM order_payments op;



-- Zadanie 27: Funkcje daty i czasu ZMIENC POLECENIE
-- (A) Wyświetl rok i miesiąc (EXTRACT(YEAR FROM ...), EXTRACT(MONTH FROM ...)) z kolumny order_purchase_timestamp dla 10 przykładowych zamówień.
-- (B) Policz, ile zamówień złożono w 2017 roku, a ile w 2018 roku (kolumna order_purchase_timestamp).

-- A
SELECT
	strftime('%Y', o.order_purchase_timestamp) AS purchase_year,
	strftime('%m', o.order_purchase_timestamp) AS purchase_month
	FROM orders o 
LIMIT 10;

-- B
SELECT
  SUM(CASE WHEN strftime('%Y', o.order_purchase_timestamp) = '2017' THEN 1 ELSE 0 END) AS orders_2017,
  SUM(CASE WHEN strftime('%Y', o.order_purchase_timestamp) = '2018' THEN 1 ELSE 0 END) AS orders_2018
FROM orders o;

-- Zadanie 29: Najpopularniejsze kategorie produktów
-- (A) Połącz tabele olist_products_dataset i olist_order_items_dataset, aby ustalić, która kategoria (product_category_name) pojawia się najczęściej w zamówieniach. Wyświetl top 5.
-- (B) Dołącz (JOIN) do tego zapytania również product_category_name_translation i wyświetl kategorię w języku angielskim.

SELECT p.product_category_name, COUNT(*) AS count_items
FROM order_items oi 
JOIN products p
  ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY count_items DESC
LIMIT 5;

-- B
SELECT p.product_category_name,
       ct.product_category_name_english,
       COUNT(*) AS count_items
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
JOIN category_translation ct 
  ON p.product_category_name = ct.product_category_name
GROUP BY p.product_category_name, ct.product_category_name_english
ORDER BY count_items DESC
LIMIT 5;

-- Zadanie 30: Porównanie danych z kolumną tłumaczeń
-- (A) Zlicz, ile kategorii w olist_products_dataset nie ma odpowiednika w product_category_name_translation (użyj LEFT JOIN i klauzuli WHERE ... IS NULL).
-- (B) Wyświetl te brakujące kategorie (jeśli istnieją).
-- A

SELECT COUNT(DISTINCT (p.product_category_name)) AS categories_without_translation
FROM products p
LEFT JOIN category_translation ct 
  ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL;

-- B
SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN category_translation ct 
  ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL;


-- Zadanie 31: Rekordy duplikujące się w bazie
-- (A) Sprawdź, czy w tabeli olist_customers_dataset istnieją duplikaty wartości w kolumnie customer_unique_id. Wyświetl ewentualne duplikujące się identyfikatory i ich liczność.
-- (B) Sprawdź, czy w tabeli olist_orders_dataset istnieją powtarzające się order_id (nie powinno ich być) – wyświetl liczbę takich potencjalnych duplikatów.

-- A
SELECT c.customer_unique_id, COUNT(*) AS dupl_count
FROM customers c 
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY dupl_count DESC;

-- B
SELECT COUNT(*) AS duplicate_orders
FROM (
  SELECT o.order_id, COUNT(*) AS cnt
  FROM orders o 
  GROUP BY o.order_id
  HAVING COUNT(*) > 1
) AS sub;

-- Zadanie 33: Użycie funkcji okna – obliczanie sumy częściowej
-- (A) Przyłącz (JOIN) tabelę olist_order_payments_dataset do olist_orders_dataset, a następnie użyj SUM(payment_value) OVER (ORDER BY order_purchase_timestamp) do obliczenia narastającej sumy płatności w porządku czasowym. Wyświetl 10 pierwszych wyników.
-- (B) Policz maksymalną płatność narastającą do danego momentu (użyj MAX(...) OVER (...)).

-- A
SELECT o.order_id,
       o.order_purchase_timestamp,
       SUM(op.payment_value) OVER (ORDER BY o.order_purchase_timestamp) AS running_total
FROM orders o
JOIN order_payments op
  ON o.order_id = op.order_id
ORDER BY o.order_purchase_timestamp
LIMIT 10;

-- B
SELECT o.order_id,
       o.order_purchase_timestamp,
       MAX(op.payment_value) OVER (ORDER BY o.order_purchase_timestamp) AS max_running_payment
FROM orders o
JOIN order_payments op 
  ON o.order_id = op.order_id
ORDER BY o.order_purchase_timestamp
LIMIT 10;

--A i B w jednym zapytaniu
SELECT 
	o.order_id,
	o.order_purchase_timestamp,
	op.payment_value,
	SUM(op.payment_value) OVER(ORDER BY o.order_purchase_timestamp ASC) AS payment_value_cumulative_total,
	MAX(op.payment_value) OVER(ORDER BY o.order_purchase_timestamp ASC) AS payment_value_max_till_date
FROM orders	o 
JOIN order_payments op ON op.order_id = o.order_id 
ORDER BY o.order_purchase_timestamp
LIMIT 12;

-- Zadanie 34: Tworzenie tabeli tymczasowej
-- (A) Utwórz tabelę tymczasową temp_delivered_orders zawierającą wyłącznie zamówienia o statusie delivered z olist_orders_dataset.
-- (B) Z tabeli tymczasowej wyświetl liczbę rekordów. Upewnij się, że tabela znika po zakończeniu sesji (cecha TEMPORARY).

-- A
CREATE TEMP TABLE temp_delivered_orders AS
SELECT *
FROM orders
WHERE order_status = 'delivered';

-- B
SELECT COUNT(*) AS temp_delivered_count
FROM temp_delivered_orders;

-- Zadanie 36: Poszukiwanie potencjalnych zależności między wielkością produktu a kosztem dostawy
-- (A) Przyłącz olist_products_dataset i olist_order_items_dataset (po product_id), oblicz korelację (CORR(product_weight_g, freight_value)) lub chociaż współczynnik product_weight_g i średniego freight_value.
-- (B) Policz również korelację między product_volume_cm = product_length_cm * product_height_cm * product_width_cm a freight_value (możesz obliczyć tę kolumnę w zapytaniu).

SELECT CORR(p.product_weight_g , oi.freight_value)
FROM products p
JOIN order_items oi 
	ON p.product_id = oi.product_id 
	

SELECT
    (
        COUNT(*) * SUM(p.product_weight_g * oi.freight_value)
        - SUM(p.product_weight_g) * SUM(oi.freight_value)
    )
    /
    SQRT(
        (
            COUNT(*) * SUM(p.product_weight_g * p.product_weight_g)
            - SUM(p.product_weight_g) * SUM(p.product_weight_g)
        )
        *
        (
            COUNT(*) * SUM(oi.freight_value * oi.freight_value)
            - SUM(oi.freight_value) * SUM(oi.freight_value)
        )
    ) AS correlation
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE p.product_weight_g IS NOT NULL
  AND oi.freight_value IS NOT NULL;

-- Zadanie 38: Wykorzystanie CASE WHEN
-- (A) W tabeli olist_order_reviews_dataset, wyświetl nową kolumnę, w której:
-- jeśli review_score = 5, wpisz 'Bardzo zadowolony',
-- jeśli review_score pomiędzy 3 a 4, wpisz 'Średnio',
-- w pozostałych przypadkach wpisz 'Niezadowolony'.
-- (B) Policz, ilu klientów ma status 'Bardzo zadowolony', 'Średnio' i 'Niezadowolony' (wygenerowany z CASE WHEN).

--A
SELECT review_id, review_score,
CASE
	WHEN review_score = 5 THEN "Bardzo zadowolny"
	WHEN review_score BETWEEN 3 AND 4 THEN "Średnio"
	ELSE "Niezadowolony"
END AS satisfaction_level
FROM order_reviews;


--B
SELECT
CASE
	WHEN review_score = 5 THEN "Bardzo zadowolny"
	WHEN review_score BETWEEN 3 AND 4 THEN "Średnio"
	ELSE "Niezadowolony"
END AS satisfaction_level,
COUNT(*) AS count_reviews
FROM order_reviews
GROUP BY 1;

-- Zadanie 22: Indeksy – tworzenie indeksu złożonego
-- (A) Utwórz indeks złożony na kolumnach customer_id i order_status w tabeli olist_orders_dataset.
-- (B) Porównaj czas wykonania zapytania filtrującego po customer_id i order_status przed i po utworzeniu indeksu (używając EXPLAIN ANALYZE).


-- A
CREATE INDEX idx_orders_customer_status
  ON orders (customer_id, order_status);

-- B
EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE customer_id = '000161a058600d5901f007fab4c27140'
  AND order_status = 'delivered';



-- Zadanie SQL: Identyfikacja klientów zagrożonych odejściem (Churn)
-- Dział CRM chce przygotować kampanię dla klientów, którzy mogą przestać kupować.
-- Za klienta zagrożonego odejściem uznaj klienta, który:
-- złożył co najmniej 2 zamówienia,
-- od ostatniego zakupu minęło więcej niż 180 dni (licząc od daty ostatniego zamówienia w bazie),
-- wydał łącznie co najmniej 500.
-- Przygotuj raport zawierający:
-- identyfikator klienta,
-- liczbę złożonych zamówień,
-- datę pierwszego zakupu,
-- datę ostatniego zakupu,
-- liczbę dni od ostatniego zakupu,
-- łączną wartość zakupów,
-- średnią wartość zamówienia.
--Wyniki posortuj malejąco według liczby dni od ostatniego zakupu.













