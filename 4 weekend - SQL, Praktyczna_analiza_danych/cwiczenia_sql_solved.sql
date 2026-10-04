--------------------------------------------------------------------------
-- ZADANIE 1
--------------------------------------------------------------------------
-- A
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

-- B
SELECT order_id, order_purchase_timestamp
FROM olist_orders_dataset
ORDER BY order_purchase_timestamp
LIMIT 10;

--------------------------------------------------------------------------
-- ZADANIE 2
--------------------------------------------------------------------------
-- A
SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM olist_customers_dataset;

-- B
SELECT customer_unique_id, customer_state
FROM olist_customers_dataset
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 3
--------------------------------------------------------------------------
-- A
SELECT COUNT(*) AS delivered_orders
FROM olist_orders_dataset
WHERE order_status = 'delivered';

-- B
(
  SELECT order_id, order_status
  FROM olist_orders_dataset
  WHERE order_status IN ('delivered')
  LIMIT 3
)
UNION
(
  SELECT order_id, order_status
  FROM olist_orders_dataset
  WHERE order_status IN ('canceled')
  LIMIT 3
)
UNION
(
  SELECT order_id, order_status
  FROM olist_orders_dataset
  WHERE order_status IN ('unavailable')
  LIMIT 3
);

SELECT order_id, order_status
FROM olist_orders_dataset
WHERE order_status IN ('delivered', 'canceled', 'unavailable');


------------
SELECT order_id, order_status
FROM (
    SELECT
        order_id,
        order_status,
        ROW_NUMBER() OVER (
            PARTITION BY order_status
            ORDER BY order_id
        ) AS rn
    FROM orders
    WHERE order_status IN ('delivered', 'canceled', 'unavailable')
)
WHERE rn <= 3;
------------------


SELECT order_id, order_status
FROM (
    SELECT order_id, order_status
    FROM orders
    WHERE order_status = 'delivered'
    LIMIT 3
)

UNION ALL

SELECT order_id, order_status
FROM (
    SELECT order_id, order_status
    FROM orders
    WHERE order_status = 'canceled'
    LIMIT 3
)

UNION ALL

SELECT order_id, order_status
FROM (
    SELECT order_id, order_status
    FROM orders
    WHERE order_status = 'unavailable'
    LIMIT 3
);



--------------------------------------------------------------------------
-- ZADANIE 4
--------------------------------------------------------------------------
-- A
SELECT order_id, order_status, order_purchase_timestamp
FROM olist_orders_dataset
ORDER BY order_purchase_timestamp ASC
LIMIT 5;

-- B
SELECT order_id, order_status, order_purchase_timestamp
FROM olist_orders_dataset
ORDER BY order_purchase_timestamp DESC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 5
--------------------------------------------------------------------------
-- A
SELECT o.order_id, c.customer_unique_id
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
LIMIT 10;

-- B
SELECT COUNT(*) AS total_joined
FROM olist_orders_dataset o
INNER JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id;

--------------------------------------------------------------------------
-- ZADANIE 6
--------------------------------------------------------------------------
-- A
SELECT o.order_id, c.customer_unique_id
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
ORDER BY o.order_id
LIMIT 10;

-- B
WITH left_join_count AS (
  SELECT COUNT(*) AS cnt
  FROM olist_orders_dataset o
  LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
),
inner_join_count AS (
  SELECT COUNT(*) AS cnt
  FROM olist_orders_dataset o
  INNER JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
)
SELECT 
  (SELECT cnt FROM left_join_count) AS left_join_result,
  (SELECT cnt FROM inner_join_count) AS inner_join_result;

--------------------------------------------------------------------------
-- ZADANIE 7
--------------------------------------------------------------------------
-- A
SELECT payment_type, COUNT(*) AS count_orders
FROM olist_order_payments_dataset
GROUP BY payment_type;

-- B
SELECT payment_type, SUM(payment_value) AS total_payment_value
FROM olist_order_payments_dataset
GROUP BY payment_type;

--------------------------------------------------------------------------
-- ZADANIE 8
--------------------------------------------------------------------------
-- A
SELECT i.*, o.order_status
FROM olist_order_items_dataset i
INNER JOIN olist_orders_dataset o
  ON i.order_id = o.order_id
LIMIT 5;

-- B
SELECT COUNT(i.order_item_id) AS total_items_delivered
FROM olist_order_items_dataset i
INNER JOIN olist_orders_dataset o
  ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

--------------------------------------------------------------------------
-- ZADANIE 9
--------------------------------------------------------------------------
-- A
SELECT SUM(i.price) AS total_price_delivered
FROM olist_order_items_dataset i
INNER JOIN olist_orders_dataset o
  ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- B
SELECT SUM(i.freight_value) AS total_freight_delivered
FROM olist_order_items_dataset i
INNER JOIN olist_orders_dataset o
  ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

--------------------------------------------------------------------------
-- ZADANIE 10
--------------------------------------------------------------------------
-- A
SELECT c.customer_state, COUNT(o.order_id) AS num_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state;

-- B
SELECT c.customer_state, COUNT(o.order_id) AS num_orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY num_orders DESC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 11
--------------------------------------------------------------------------
-- A
SELECT AVG(product_weight_g) AS avg_weight
FROM olist_products_dataset;

-- B
SELECT AVG(product_height_cm) AS avg_height,
       AVG(product_width_cm) AS avg_width
FROM olist_products_dataset;

--------------------------------------------------------------------------
-- ZADANIE 12
--------------------------------------------------------------------------
-- A
SELECT DISTINCT product_category_name, product_id
FROM olist_products_dataset
WHERE product_category_name IS NOT NULL
LIMIT 10;

-- B
SELECT p.product_category_name, t.product_category_name_english
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
LIMIT 10;

--------------------------------------------------------------------------
-- ZADANIE 13
--------------------------------------------------------------------------
-- A
SELECT s.*, i.order_id, i.product_id
FROM olist_sellers_dataset s
INNER JOIN olist_order_items_dataset i
  ON s.seller_id = i.seller_id
LIMIT 5;

-- B
SELECT COUNT(DISTINCT s.seller_id) AS unique_sellers
FROM olist_sellers_dataset s
INNER JOIN olist_order_items_dataset i
  ON s.seller_id = i.seller_id;

--------------------------------------------------------------------------
-- ZADANIE 14
--------------------------------------------------------------------------
-- A
SELECT AVG(freight_value) AS avg_freight
FROM olist_order_items_dataset;

-- B
SELECT order_id, price, freight_value
FROM olist_order_items_dataset
ORDER BY freight_value DESC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 15
--------------------------------------------------------------------------
-- A
SELECT (
  SELECT COUNT(*) 
  FROM olist_orders_dataset
  WHERE order_status = 'delivered'
) AS delivered_count;

-- B
SELECT *
FROM olist_orders_dataset
WHERE order_id IN (
  SELECT order_id
  FROM olist_order_reviews_dataset
  WHERE review_score = 5
);

--------------------------------------------------------------------------
-- ZADANIE 16
--------------------------------------------------------------------------
-- A
WITH orders_by_state AS (
  SELECT c.customer_state, COUNT(o.order_id) AS order_count
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
  GROUP BY c.customer_state
)
SELECT customer_state, order_count
FROM orders_by_state
WHERE order_count > 2000;

-- B
WITH delivered_2017 AS (
  SELECT *
  FROM olist_orders_dataset
  WHERE order_status = 'delivered'
    AND EXTRACT(YEAR FROM order_purchase_timestamp) = 2017
)
SELECT COUNT(*) AS delivered_in_2017
FROM delivered_2017;

--------------------------------------------------------------------------
-- ZADANIE 17
--------------------------------------------------------------------------
-- A
SELECT AVG(review_score) AS avg_review_score
FROM olist_order_reviews_dataset;

-- B
SELECT order_id, review_score, review_comment_message
FROM olist_order_reviews_dataset
ORDER BY review_score ASC, review_creation_date ASC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 18
--------------------------------------------------------------------------
-- A
SELECT review_score, COUNT(*) AS count_reviews
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

-- B
SELECT review_score, AVG(LENGTH(review_comment_message)) AS avg_comment_length
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

--------------------------------------------------------------------------
-- ZADANIE 19
--------------------------------------------------------------------------
-- A
SELECT AVG(r.review_score) AS avg_score_early_delivery
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
  ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date < o.order_estimated_delivery_date;

-- B
WITH early AS (
  SELECT AVG(r.review_score) AS avg_early
  FROM olist_order_reviews_dataset r
  JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
  WHERE o.order_delivered_customer_date < o.order_estimated_delivery_date
),
late AS (
  SELECT AVG(r.review_score) AS avg_late
  FROM olist_order_reviews_dataset r
  JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
  WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
)
SELECT early.avg_early, late.avg_late
FROM early, late;

--------------------------------------------------------------------------
-- ZADANIE 20
--------------------------------------------------------------------------
-- A
SELECT COUNT(DISTINCT c.customer_id) AS unique_customers_with_geo
FROM olist_customers_dataset c
JOIN olist_geolocation_dataset g
  ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;

-- B
SELECT g.geolocation_city, COUNT(*) AS customer_count
FROM olist_customers_dataset c
JOIN olist_geolocation_dataset g
  ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY customer_count DESC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 21
--------------------------------------------------------------------------
-- A
CREATE INDEX idx_orders_order_id
  ON olist_orders_dataset (order_id);

-- B
EXPLAIN
SELECT *
FROM olist_orders_dataset
WHERE order_id = 'some_order_id';

--------------------------------------------------------------------------
-- ZADANIE 22
--------------------------------------------------------------------------
-- A
CREATE INDEX idx_orders_customer_status
  ON olist_orders_dataset (customer_id, order_status);

-- B
EXPLAIN ANALYZE
SELECT *
FROM olist_orders_dataset
WHERE customer_id = 'some_customer_id'
  AND order_status = 'delivered';

--------------------------------------------------------------------------
-- ZADANIE 23
--------------------------------------------------------------------------
-- A
SELECT o.order_id,
       o.order_status,
       p.payment_type,
       c.customer_state
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id
LIMIT 10;

-- B
SELECT COUNT(*)
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id;

--------------------------------------------------------------------------
-- ZADANIE 24
--------------------------------------------------------------------------
-- A
SELECT order_status, COUNT(*) AS num_orders
FROM olist_orders_dataset
GROUP BY order_status;

-- B
SELECT order_status, COUNT(*) AS num_orders
FROM olist_orders_dataset
GROUP BY order_status
HAVING COUNT(*) >= 1000
ORDER BY num_orders DESC;

--------------------------------------------------------------------------
-- ZADANIE 25
--------------------------------------------------------------------------
-- A
WITH max_installments AS (
  SELECT MAX(payment_installments) AS max_inst
  FROM olist_order_payments_dataset
)
SELECT max_inst AS max_installments,
       (SELECT COUNT(*) 
        FROM olist_order_payments_dataset
        WHERE payment_installments = max_inst) AS count_with_max
FROM max_installments;

-- B
SELECT AVG(payment_installments) AS avg_installments
FROM olist_order_payments_dataset;

--------------------------------------------------------------------------
-- ZADANIE 26
--------------------------------------------------------------------------
-- A
SELECT UPPER(review_comment_message) AS comment_upper
FROM olist_order_reviews_dataset
LIMIT 10;

-- B
SELECT COUNT(*) AS comments_with_late
FROM olist_order_reviews_dataset
WHERE review_comment_message ILIKE '%late%';

--------------------------------------------------------------------------
-- ZADANIE 27
--------------------------------------------------------------------------
-- A
SELECT order_id,
       EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month
FROM olist_orders_dataset
LIMIT 10;

-- B
SELECT
  SUM(CASE WHEN EXTRACT(YEAR FROM order_purchase_timestamp) = 2017 THEN 1 ELSE 0 END) AS orders_2017,
  SUM(CASE WHEN EXTRACT(YEAR FROM order_purchase_timestamp) = 2018 THEN 1 ELSE 0 END) AS orders_2018
FROM olist_orders_dataset;

--------------------------------------------------------------------------
-- ZADANIE 28
--------------------------------------------------------------------------
-- A
SELECT seller_id, seller_city
FROM olist_sellers_dataset
ORDER BY LENGTH(seller_city) DESC
LIMIT 5;

-- B
SELECT COUNT(DISTINCT seller_state) AS distinct_seller_states
FROM olist_sellers_dataset;

--------------------------------------------------------------------------
-- ZADANIE 29
--------------------------------------------------------------------------
-- A
SELECT p.product_category_name, COUNT(*) AS count_items
FROM olist_order_items_dataset i
JOIN olist_products_dataset p
  ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY count_items DESC
LIMIT 5;

-- B
SELECT p.product_category_name,
       t.product_category_name_english,
       COUNT(*) AS count_items
FROM olist_order_items_dataset i
JOIN olist_products_dataset p
  ON i.product_id = p.product_id
JOIN product_category_name_translation t
  ON p.product_category_name = t.product_category_name
GROUP BY p.product_category_name, t.product_category_name_english
ORDER BY count_items DESC
LIMIT 5;

--------------------------------------------------------------------------
-- ZADANIE 30
--------------------------------------------------------------------------
-- A
SELECT COUNT(*) AS categories_without_translation
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
  ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;

-- B
SELECT DISTINCT p.product_category_name
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
  ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;

--------------------------------------------------------------------------
-- ZADANIE 31
--------------------------------------------------------------------------
-- A
SELECT customer_unique_id, COUNT(*) AS dupl_count
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY dupl_count DESC;

-- B
SELECT COUNT(*) AS duplicate_orders
FROM (
  SELECT order_id, COUNT(*) AS cnt
  FROM olist_orders_dataset
  GROUP BY order_id
  HAVING COUNT(*) > 1
) AS sub;

--------------------------------------------------------------------------
-- ZADANIE 32
--------------------------------------------------------------------------
-- A
SELECT order_id,
       order_purchase_timestamp,
       ROW_NUMBER() OVER (ORDER BY order_purchase_timestamp DESC) AS row_num
FROM olist_orders_dataset
LIMIT 10;

-- B
SELECT order_id,
       order_purchase_timestamp,
       RANK() OVER (ORDER BY order_purchase_timestamp ASC) AS rank_num
FROM olist_orders_dataset
LIMIT 10;

--------------------------------------------------------------------------
-- ZADANIE 33
--------------------------------------------------------------------------
-- A
SELECT o.order_id,
       o.order_purchase_timestamp,
       SUM(p.payment_value) OVER (ORDER BY o.order_purchase_timestamp) AS running_total
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id
ORDER BY o.order_purchase_timestamp
LIMIT 10;

-- B
SELECT o.order_id,
       o.order_purchase_timestamp,
       MAX(p.payment_value) OVER (ORDER BY o.order_purchase_timestamp) AS max_running_payment
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id
ORDER BY o.order_purchase_timestamp
LIMIT 10;

--------------------------------------------------------------------------
-- ZADANIE 34
--------------------------------------------------------------------------
-- A
CREATE TEMP TABLE temp_delivered_orders AS
SELECT *
FROM olist_orders_dataset
WHERE order_status = 'delivered';

-- B
SELECT COUNT(*) AS temp_delivered_count
FROM temp_delivered_orders;

--------------------------------------------------------------------------
-- ZADANIE 35
--------------------------------------------------------------------------
-- A
CREATE OR REPLACE VIEW view_top_states AS
SELECT c.customer_state,
       COUNT(o.order_id) AS state_order_count
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
HAVING COUNT(o.order_id) >= 1000
ORDER BY state_order_count DESC;

-- B
SELECT *, 
  (SELECT COUNT(*) FROM view_top_states) AS total_states
FROM view_top_states;

--------------------------------------------------------------------------
-- ZADANIE 36
--------------------------------------------------------------------------
-- A
SELECT CORR(p.product_weight_g, i.freight_value) AS corr_weight_freight
FROM olist_products_dataset p
JOIN olist_order_items_dataset i
  ON p.product_id = i.product_id;

-- B
SELECT CORR(
  (p.product_length_cm * p.product_height_cm * p.product_width_cm),
  i.freight_value
) AS corr_volume_freight
FROM olist_products_dataset p
JOIN olist_order_items_dataset i
  ON p.product_id = i.product_id;

--------------------------------------------------------------------------
-- ZADANIE 37
--------------------------------------------------------------------------
-- A
SELECT order_id,
       AGE(order_approved_at, order_purchase_timestamp) AS approval_delay
FROM olist_orders_dataset
LIMIT 10;

-- B
SELECT AVG(AGE(order_approved_at, order_purchase_timestamp)) AS avg_approval_delay
FROM olist_orders_dataset;

--------------------------------------------------------------------------
-- ZADANIE 38
--------------------------------------------------------------------------
-- A
SELECT review_id, review_score,
CASE 
  WHEN review_score = 5 THEN 'Bardzo zadowolony'
  WHEN review_score BETWEEN 3 AND 4 THEN 'Średnio'
  ELSE 'Niezadowolony'
END AS satisfaction_level
FROM olist_order_reviews_dataset
LIMIT 10;

-- B
SELECT
  CASE 
    WHEN review_score = 5 THEN 'Bardzo zadowolony'
    WHEN review_score BETWEEN 3 AND 4 THEN 'Średnio'
    ELSE 'Niezadowolony'
  END AS satisfaction_level,
  COUNT(*) AS count_reviews
FROM olist_order_reviews_dataset
GROUP BY 1;

--------------------------------------------------------------------------
-- ZADANIE 39
--------------------------------------------------------------------------
-- A
ALTER TABLE olist_orders_dataset
ADD COLUMN processed_timestamp TIMESTAMP;

-- B
ALTER TABLE olist_orders_dataset
DROP COLUMN processed_timestamp;

--------------------------------------------------------------------------
-- ZADANIE 40
--------------------------------------------------------------------------
-- A
EXPLAIN ANALYZE
SELECT o.order_id, c.customer_state, p.payment_value
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';

-- B
-- (Przykład utworzenia dodatkowego indeksu w celu optymalizacji)
CREATE INDEX idx_orders_status_customer
  ON olist_orders_dataset (order_status, customer_id);

EXPLAIN ANALYZE
SELECT o.order_id, c.customer_state, p.payment_value
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
  ON o.customer_id = c.customer_id
JOIN olist_order_payments_dataset p
  ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';
