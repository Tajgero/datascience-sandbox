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
SELECT
    o.order_id,
    o.customer_id,
    COUNT(*) OVER (PARTITION BY o.customer_id) AS customer_order_count
FROM orders o
ORDER BY o.customer_id, o.order_id
LIMIT 50;

-- GROUP BY alternatywa
SELECT
	customer_id,
	COUNT(customer_id)
FROM 
	orders o
GROUP BY o.customer_id
ORDER BY o.customer_id 
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
        SUM(oi.quantity * oi.unit_price - COALESCE(oi.discount, 0)) AS order_value /*Wartość order_id klienta*/
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 
    	o.order_id,
    	o.customer_id,
    	o.order_date 
    ORDER BY 
    	o.customer_id, 
    	o.order_date
)
SELECT
    order_id,
    customer_id,
    order_date,
    order_value,
    SUM(order_value) OVER (PARTITION BY customer_id ORDER BY order_date
    						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS customer_cumulative_value /*Wartość klienta - prognoza klienta*/
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
        ROUND(AVG(oi.quantity*oi.unit_price -COALESCE(oi.discount,0)),2) AS customer_avg_order_value
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id --tabela orders w tym wypadku służy tylko jako łącznik customers z order_items
    JOIN order_items oi ON oi.order_id   = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY
    	c.customer_id,
    	c.country
),

customer_country_avg AS (
	SELECT
	    country,
	    customer_id,
	    customer_avg_order_value,
	    ROUND(AVG(customer_avg_order_value) OVER (PARTITION BY country ), 2) AS country_avg_order_value
	FROM customer_avg
	ORDER BY country, customer_id
)

SELECT * FROM customer_country_avg
WHERE customer_avg_order_value > 1.5 * country_avg_order_value;

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
        ROUND(SUM(oi.quantity * oi.unit_price - COALESCE(oi.discount, 0)), 2) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY order_day
    ORDER BY order_day
)
SELECT
    order_day,
    daily_revenue,
    SUM(daily_revenue) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
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

--Zamówienia, które ważą więcej niż 50% dla danego klienta
WITH order_value AS (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity *oi.unit_price - COALESCE(oi.discount,0)) AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.order_id, o.customer_id
),

share_of_orders AS (
SELECT
    order_id,
    customer_id,
    order_value,
    SUM(order_value) OVER (PARTITION BY customer_id) AS customer_total_value,
    ROUND(order_value/ SUM(order_value) OVER (PARTITION BY customer_id),4) AS order_share_in_customer
FROM order_value
ORDER BY customer_id, order_id
)
SELECT * FROM share_of_orders
WHERE order_share_in_customer > 0.5;

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
    row_number() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_number_for_customer
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
        SUM(oi.quantity *oi.unit_price - COALESCE(oi.discount,0)) AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY 
    	p.category,
    	p.product_id
),
ranked AS (
SELECT
    category,
    product_id,
    revenue,
	RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY category, revenue DESC
)
SELECT * FROM ranked 
WHERE revenue_rank <= 3
ORDER BY category, revenue DESC

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
        SUM(oi.quantity *oi.unit_price - COALESCE(oi.discount,0)) AS clv
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.customer_id
),
decyle AS (
SELECT
    customer_id,
    clv,
    NTILE(10) OVER (ORDER BY clv DESC) AS clv_decile
FROM customer_value
)
SELECT 
	clv_decile,
	ROUND(SUM(clv), 2) AS sum_clv,
	ROUND(AVG(clv), 2) AS avg_clv,
	ROUND(COUNT(customer_id), 2) AS no_customers
FROM 
	decyle
GROUP BY clv_decile
ORDER BY clv_decile;

-- Grupowanie po decylach, segmentacja klientów

---------------------------------------------------------------------------
-- Zadanie 9 – Porównanie ROW_NUMBER, RANK i DENSE_RANK
-- Rankowanie na podstawie unit_price
---------------------------------------------------------------------------
SELECT 
	*,
row_number() OVER (ORDER BY unit_price desc) AS rn,
rank() OVER (ORDER BY unit_price desc) AS rnk,
dense_rank() OVER (ORDER BY unit_price desc) AS dense_rnk
FROM 
	order_items
ORDER BY 
	unit_price DESC;

-- ZADANIE
-- stwórz decyle dla cen produktów - pokaż jaka jest średnia cena produktu w ramach każdego decyla
-- oraz ile jest produktów w każdym decylu
-- cena produktu - unit_price

-- TECHNICZNIE POPRAWNE
WITH product_value AS (
    SELECT
    	p.product_id,
        p.price,
        NTILE(10) OVER (ORDER BY p.price) AS decyl_ceny
    FROM
    	products p
    ORDER BY p.product_id
)
SELECT
	*,
	COUNT(product_id) OVER (PARTITION BY decyl_ceny),
	ROUND(AVG(price) OVER (PARTITION BY decyl_ceny), 2) AS avg_produktu
FROM
	product_value
ORDER BY 
	decyl_ceny;

-- POPRAWNE
WITH decyle AS (
SELECT
	product_id,
	price,
	NTILE(10) OVER (ORDER BY price) AS decile
	FROM products
	
)
SELECT
	decile,
	avg(price) AS avg_price,
	count(product_id) AS product_count
FROM decyle
GROUP BY decile
ORDER BY decile DESC;

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
        sum(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    LEAD(revenue) OVER (ORDER BY month) AS future_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS diff_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month), 4) AS pct_change_mom
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
    LAG(o.order_date) OVER (PARTITION BY customer_id ORDER BY o.order_date) AS prev_order_date,
	o.order_date - LAG(o.order_date) OVER (PARTITION BY customer_id ORDER BY o.order_date) AS diff_dates_interval,
	ROUND(EXTRACT(EPOCH FROM o.order_date - LAG(o.order_date) OVER (PARTITION BY customer_id ORDER BY o.order_date)) / (24*60*60), 3) AS days_since_prev_order
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
        SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 
	    o.customer_id, 
	    o.order_id, 
	    o.order_date
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_value,
    FIRST_VALUE(order_value) OVER (PARTITION BY customer_id ORDER BY order_date),
    order_value - FIRST_VALUE(order_value) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_vs_first,
    ROUND((order_value - FIRST_VALUE(order_value) OVER (PARTITION BY customer_id ORDER BY order_date)) * 100 / FIRST_VALUE(order_value) OVER (PARTITION BY customer_id ORDER BY order_date), 2) AS percent_change
FROM 
	order_value
ORDER BY 
	customer_id, 
	order_date;

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
        SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 
	    o.customer_id, 
	    o.order_id, 
	    o.order_date
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_value,
    FIRST_VALUE(order_value) OVER (
    	PARTITION BY customer_id ORDER BY order_date
    ) AS first_order_value_for_customer,
    LAST_VALUE(order_value) OVER (
    	PARTITION BY customer_id 
    	ORDER BY order_date
    	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_order_value_for_customer
FROM 
	order_value
ORDER BY 
	customer_id, 
	order_date DESC;

-- Zadanie domowe znajdź top 3 produkty per subkategoria (subcategory) + dodatkowo ile sztuk produktu (quantity) zostało kupionych
WITH ranked_bought_products AS ( 
	SELECT
		oi.product_id,
		p.sub_category,
		SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS product_value,
		SUM(oi.quantity) AS total_quantity,
		ROW_NUMBER() OVER (PARTITION BY p.sub_category ORDER BY SUM(oi.quantity) DESC) AS rnk -- Produkty najpopularniejsze
	FROM products p
	JOIN order_items oi ON oi.product_id = p.product_id
	JOIN orders o ON o.order_id = oi.order_id
	GROUP BY 
		oi.product_id,
		p.sub_category
)
SELECT
	product_id,
	sub_category,
	product_value,
	total_quantity
FROM 
	ranked_bought_products
WHERE
	rnk <= 3
ORDER BY
	CASE sub_category
        WHEN 'premium' THEN 1
        WHEN 'standard' THEN 2
        WHEN 'budget' THEN 3
        ELSE 4
    END,
	product_value DESC;

/* Zadanie: policz ile sesji internetowych było per typ urządzeń oraz utm_source
   policz także jakie były wartości liczby sesji WoW i MoM */
WITH aggregated_data AS (
    SELECT
        device_type,
        utm_source,
        DATE_TRUNC('week', session_start) AS session_week,
        DATE_TRUNC('month', session_start) AS session_month,
        COUNT(session_id) AS liczba_sesji
    FROM 
        traffic_sessions
    GROUP BY 
        device_type,
        utm_source,
        DATE_TRUNC('week', session_start),
        DATE_TRUNC('month', session_start)
    ORDER BY
    	device_type,
    	utm_source,
        DATE_TRUNC('week', session_start),
        DATE_TRUNC('month', session_start)
)
SELECT
    device_type,
    utm_source,
    session_week,
    session_month,
    liczba_sesji,
    -- Wartość z poprzedniego tygodnia (Week-over-Week)
    LAG(liczba_sesji, 1) OVER (PARTITION BY device_type, utm_source ORDER BY session_week) AS liczba_sesji_poprzedni_tydzien,
    -- Wartość z poprzedniego miesiąca (Month-over-Month)
    LAG(liczba_sesji, 1) OVER (PARTITION BY device_type, utm_source ORDER BY session_month) AS liczba_sesji_poprzedni_miesiac
FROM 
    aggregated_data
ORDER BY
    device_type,
    utm_source,
    session_week;

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
        SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.order_id
)
SELECT
    PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY order_value) AS p90_order_value,
    AVG(order_value) AS avg_order_value,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY order_value) AS p50_order_value, -- 2210.51 mediana kwoty połowy zamówień
    PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY order_value) AS p99_order_value
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
        oi.order_id,
        SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS line_value
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.category, oi.order_id
)
SELECT
    category,
    PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY line_value) AS p01_value,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY line_value) AS p50_value,
    PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY line_value) AS p90_value,
    PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY line_value) AS p99_value
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
        SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS order_value
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.order_id
)
SELECT
    stddev_pop(order_value),
    avg(order_value),
    min(order_value),
    max(order_value)
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
        SUM(oi.quantity) AS num_items,
        SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS order_value
    FROM order_items oi
    GROUP BY oi.order_id
)
SELECT
    corr(num_items, order_value) AS corr_items_value
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
        SUM(oi.unit_price * oi.quantity - COALESCE(oi.discount, 0)) AS order_value
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY c.country, o.order_id
)
SELECT
    country,
    avg(order_value) AS avg_order_value,
    stddev_pop(order_value) AS std_order_value,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY order_id) AS p50_order_value,
    PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY order_id) AS p90_order_value
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
        SUM(oi.quantity * oi.unit_price - coalesce(oi.discount, 0)) AS clv
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id   = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY c.customer_id, c.country
)
SELECT
    cv.customer_id,
    cv.country,
    cv.clv,
    (SELECT round(avg(cv2.clv), 2) FROM customer_value cv2 WHERE cv2.country = cv.country) AS country_avg_clv,
    cv.clv - (SELECT round(avg(cv2.clv), 2) FROM customer_value cv2 WHERE cv2.country = cv.country) AS diff_vs_country_avg
FROM customer_value cv
ORDER BY cv.clv DESC, cv.country DESC;

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
    sum(t.revenue) OVER (PARTITION BY t.country ORDER BY t.MONTH) AS cumulative_country_revenue
FROM (
    SELECT
        c.country,
        date_trunc('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY country, month
) t
ORDER BY t.country, t.MONTH;

-- Alternatywne CTE
WITH monthly_revenue AS (
	SELECT
        c.country,
        date_trunc('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'completed'
    GROUP BY country, month
)
SELECT
	t.country,
    t.month,
    t.revenue,
    sum(t.revenue) OVER (PARTITION BY t.country ORDER BY t.MONTH) AS cumulative_country_revenue
FROM
	monthly_revenue t;


---------------------------------------------------------------------------
-- Zadanie 21 – Podzapytanie w WHERE (EXISTS)
--
-- Cel biznesowy:
--   Znaleźć klientów, którzy kupowali w ostatnich 570 dniach.
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
      AND o.order_date >= current_date - INTERVAL '570 days' -- Odejmowanie ileś dni
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
    SELECT 
    	date_trunc('month', o.order_date) AS month,
    	SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'completed'
    GROUP BY MONTH
    ORDER BY month
),
monthly_with_prev AS (
    SELECT 
    	MONTH,
    	revenue,
    	lag(revenue) OVER (ORDER BY month) AS prev_month_revenue
    FROM 
    	monthly
)
SELECT
    mwp.*,
    mwp.revenue - mwp.prev_month_revenue AS diff_revenue,
    round((mwp.revenue - mwp.prev_month_revenue) / mwp.prev_month_revenue, 4) AS pct_change_mom
FROM 
	monthly_with_prev mwp
ORDER BY 
	month;

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
DROP TABLE IF EXISTS daily_sales;

CREATE TEMP TABLE daily_sales AS
SELECT
    o.order_date::date AS order_day,
    SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS daily_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'completed'
GROUP BY order_day
ORDER BY order_day;

SELECT
    order_day,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_day) AS cumulative_revenue
FROM daily_sales
ORDER BY order_day;

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
        SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.category
)
SELECT
    category,
    revenue
FROM category_revenue
GROUP BY category, revenue
HAVING SUM(revenue) > (SELECT AVG(revenue) FROM category_revenue)
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
 WITH monthly AS (
    SELECT 
    	date_trunc('month', o.order_date) AS month,
    	SUM(oi.quantity * oi.unit_price - coalesce(discount, 0)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'completed'
    GROUP BY MONTH
    ORDER BY month
),
 monthly_with_lags AS (
     SELECT
         MONTH,
         revenue,
         LAG(revenue, 1) OVER (ORDER BY month) AS prev_month_revenue,
         LAG(revenue, 12) OVER (ORDER BY MONTH) AS prev_year_revenue
     FROM monthly
 )
 SELECT
     month,
     revenue,
     prev_month_revenue,
     prev_year_revenue,
	 ROUND(((revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0)) * 100, 2) AS mom_change_pct,
     ROUND(((revenue - prev_year_revenue) / NULLIF(prev_year_revenue, 0)) * 100, 2) AS yoy_change_pct
 FROM monthly_with_lags
 ORDER BY month;

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
WITH customer_value AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity * oi.unit_price - COALESCE(oi.discount, 0)) AS clv
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'completed'
    GROUP BY o.customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        clv,
        NTILE(10) OVER (ORDER BY clv ASC) AS clv_decile
    FROM customer_value
),
orders_with_segment AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        cs.clv_decile,
        o.order_id,
        SUM(oi.quantity * oi.unit_price - COALESCE(oi.discount, 0)) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customer_segments cs ON o.customer_id = cs.customer_id
    WHERE o.order_status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date), cs.clv_decile, o.order_id
),
segment_monthly AS (
    SELECT 
        month,
        clv_decile AS segment,
        SUM(order_value) AS segment_revenue
    FROM orders_with_segment
    GROUP BY month, clv_decile
),
total_monthly AS (
    SELECT 
        month,
        SUM(order_value) AS total_revenue
    FROM orders_with_segment
    GROUP BY month
)
SELECT
    sm.month,
    sm.segment,
    sm.segment_revenue,
    ROUND((sm.segment_revenue / NULLIF(tm.total_revenue, 0)) * 100, 2) AS segment_share_in_total
FROM segment_monthly sm
JOIN total_monthly tm ON sm.month = tm.month
ORDER BY sm.month DESC, sm.segment DESC;

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