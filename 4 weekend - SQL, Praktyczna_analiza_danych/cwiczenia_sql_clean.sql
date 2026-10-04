-- Zadanie 1: Podstawowa eksploracja zamówień
-- (A) Zlicz liczbę wszystkich zamówień w tabeli olist_orders_dataset.
-- (B) Wyświetl 10 pierwszych zamówień (order_id) wraz z datą zakupu (order_purchase_timestamp).

-- Zadanie 2: Unikalni klienci i liczność zamówień
-- (A) Sprawdź, ilu unikalnych klientów znajduje się w tabeli olist_customers_dataset (kolumna customer_unique_id).
-- (B) Wyświetl 5 przykładowych klientów (customer_unique_id), którzy występują w bazie, wraz z ich stanem (customer_state).

-- Zadanie 3: Filtrowanie zamówień według statusu
-- (A) Policz liczbę zamówień o statusie delivered w tabeli olist_orders_dataset.
-- (B) Wyświetl po 3 przykładowe zamówienia dla każdego statusu: delivered, canceled i unavailable. Użyj klauzuli WHERE z operatorem IN.

-- Zadanie 4: Sortowanie wyników
-- (A) Znajdź 5 najstarszych zamówień (według order_purchase_timestamp) i wyświetl order_id, order_status, order_purchase_timestamp.
-- (B) Znajdź 5 najnowszych zamówień i wyświetl to samo, ale posortuj malejąco względem daty zakupu.

-- Zadanie 5: Łączenie zamówień z klientami (INNER JOIN)
-- (A) Zrób wewnętrzne złączenie (INNER JOIN) tabel olist_orders_dataset i olist_customers_dataset, aby uzyskać informacje o customer_unique_id dla każdego order_id. Wyświetl 10 pierwszych rekordów.
-- (B) Policz łączną liczbę zamówień przypisanych do klientów (czyli wynik wewnętrznego złączenia).

-- Zadanie 6: Łączenie zamówień z klientami (LEFT JOIN)
-- (A) Wyświetl wszystkie order_id i odpowiadające im customer_unique_id za pomocą LEFT JOIN, nawet jeśli dany klient nie istnieje w tabeli olist_customers_dataset (sprawdź, czy takie przypadki są).
-- (B) Policz, ile rekordów znajdzie się w wyniku zapytania z LEFT JOIN w porównaniu do INNER JOIN z Zadania 5.

-- Zadanie 7: Analiza płatności
-- (A) Policz, ile zamówień zostało opłaconych każdą metodą płatności (payment_type) w tabeli olist_order_payments_dataset.
-- (B) Wyświetl sumaryczną wartość płatności (payment_value) dla każdego typu płatności (payment_type).

-- Zadanie 8: Wielkość zamówień (JOIN z olist_order_items_dataset)
-- (A) Dołącz do tabeli olist_order_items_dataset informacje o statusie zamówienia z olist_orders_dataset (INNER JOIN po order_id). Wyświetl 5 przykładowych wierszy.
-- (B) Policz łączną liczbę produktów (order_item_id) dla zamówień o statusie delivered.

-- Zadanie 9: Agregacja wartości zamówień
-- (A) Wykorzystując olist_order_items_dataset, oblicz łączną kwotę (SUM(price)) wszystkich produktów w dostarczonych zamówieniach.
-- (B) Policz łączną kwotę opłat za przesyłkę (SUM(freight_value)) dla tych samych zamówień.

-- Zadanie 10: Grupowanie zamówień według stanu klienta
-- (A) Połącz olist_orders_dataset z olist_customers_dataset i zgrupuj zamówienia według customer_state. Policz liczbę zamówień w każdym stanie.
-- (B) Posortuj wyniki malejąco według liczby zamówień, wyświetl top 5 stanów z największą liczbą zamówień.

-- Zadanie 11: Sprawdzenie wymiarów i wagi produktów
-- (A) Policz średnią wagę (product_weight_g) produktu w tabeli olist_products_dataset.
-- (B) Policz średnią wysokość (product_height_cm) i szerokość (product_width_cm) produktu.

-- Zadanie 12: Produkty a kategorie
-- (A) Z tabeli olist_products_dataset wyświetl 10 różnych kategorii produktowych (product_category_name) wraz z przykładowym product_id.
-- (B) Połącz ją z tabelą product_category_name_translation, aby dodać tłumaczenie kategorii na język angielski. Wyświetl 10 wierszy.

-- Zadanie 13: Łączenie informacji o sprzedawcach
-- (A) Zrób INNER JOIN między olist_sellers_dataset a olist_order_items_dataset po kolumnie seller_id. Wyświetl 5 przykładowych rekordów.
-- (B) Policz, ilu unikalnych sprzedawców (seller_id) brało udział w zamówieniach występujących w olist_order_items_dataset.

-- Zadanie 14: Obliczanie średniego kosztu dostawy
-- (A) W tabeli olist_order_items_dataset oblicz średnią wartość freight_value.
-- (B) Wyświetl top 5 rekordów o najwyższej wartości freight_value razem z price.

-- Zadanie 15: Zagnieżdżone zapytania (subqueries)
-- (A) Policz, ile jest zamówień w stanie delivered, korzystając z podzapytania do tabeli olist_orders_dataset, i wyświetl tę liczbę.
-- (B) Wyświetl wszystkie wiersze z tabeli olist_orders_dataset, których order_id pojawia się w podzapytaniu pobierającym order_id z tabeli olist_order_reviews_dataset o review_score = 5.

-- Zadanie 16: Użycie CTE (Common Table Expressions)
-- (A) Utwórz CTE, które policzy liczbę zamówień w poszczególnych stanach (customer_state). Następnie wyświetl z tego CTE tylko stany, które mają ponad 2000 zamówień.
-- (B) Utwórz CTE, które zwróci zamówienia dostarczone (delivered) w 2017 roku (na podstawie order_purchase_timestamp), a następnie oblicz na nim liczbę tych zamówień.

-- Zadanie 17: Analiza recenzji
-- (A) Policz średni review_score (ocenę) w tabeli olist_order_reviews_dataset.
-- (B) Wyświetl 5 zamówień o najniższej ocenie i sprawdź, czy mają uzupełnione komentarze (review_comment_message).

-- Zadanie 18: Grupowanie recenzji i obliczanie średniej
-- (A) Zgrupuj recenzje według review_score i oblicz liczbę recenzji dla każdej oceny.
-- (B) Policz średnią długość komentarza (LENGTH(review_comment_message)) dla każdej oceny review_score.

-- Zadanie 19: Relacja między recenzjami a czasem dostawy
-- (A) Przyłącz tabelę olist_order_reviews_dataset do olist_orders_dataset (JOIN po order_id) i oblicz średnią ocenę dla zamówień, w których order_delivered_customer_date < order_estimated_delivery_date.
-- (B) Sprawdź różnicę w średniej ocenie pomiędzy zamówieniami dostarczonymi przed terminem a po terminie.

-- Zadanie 20: Analiza geograficzna
-- (A) Sprawdź, w ilu unikalnych miastach (geolocation_city) występują klienci (JOIN tabel olist_customers_dataset i olist_geolocation_dataset po prefiksie kodu pocztowego).
-- (B) Wyświetl 5 miast o najwyższej liczbie klientów, posortuj malejąco po liczbie klientów.

-- Zadanie 21: Indeksy – tworzenie indeksu na order_id
-- (A) Utwórz indeks na kolumnie order_id w tabeli olist_orders_dataset, aby przyspieszyć wyszukiwanie zamówień.
-- (B) Uruchom zapytanie EXPLAIN dla prostej selekcji z olist_orders_dataset, aby zobaczyć, czy indeks jest używany.

-- Zadanie 22: Indeksy – tworzenie indeksu złożonego
-- (A) Utwórz indeks złożony na kolumnach customer_id i order_status w tabeli olist_orders_dataset.
-- (B) Porównaj czas wykonania zapytania filtrującego po customer_id i order_status przed i po utworzeniu indeksu (używając EXPLAIN ANALYZE).

-- Zadanie 23: Złączenie wielu tabel naraz
-- (A) Za pomocą pojedynczego zapytania, połącz (JOIN) tabele:
-- olist_orders_dataset (alias o)
-- olist_customers_dataset (alias c)
-- olist_order_payments_dataset (alias p)
-- w celu uzyskania informacji: order_id, order_status, payment_type, customer_state. Wyświetl 10 pierwszych wyników.
-- (B) Policz łączną liczbę rekordów zwróconych przez to złączenie.

-- Zadanie 24: Przykład klauzuli HAVING
-- (A) Pogrupuj zamówienia w olist_orders_dataset według order_status i zlicz je.
-- (B) Odfiltruj grupy, które mają mniej niż 1000 zamówień, używając klauzuli HAVING.

-- Zadanie 25: Analiza liczby rat w płatnościach
-- (A) W tabeli olist_order_payments_dataset sprawdź maksymalną liczbę rat (payment_installments) i zlicz, ile zamówień ma właśnie taką najwyższą liczbę rat.
-- (B) Oblicz średnią liczbę rat dla wszystkich zamówień.

-- Zadanie 26: Funkcje tekstowe
-- (A) Wyświetl 10 przykładów komentarzy (review_comment_message) z tabeli olist_order_reviews_dataset w postaci dużymi literami (funkcja UPPER).
-- (B) Policz liczbę komentarzy, które zawierają słowo late (możesz użyć LIKE).

-- Zadanie 27: Funkcje daty i czasu
-- (A) Wyświetl rok i miesiąc (EXTRACT(YEAR FROM ...), EXTRACT(MONTH FROM ...)) z kolumny order_purchase_timestamp dla 10 przykładowych zamówień.
-- (B) Policz, ile zamówień złożono w 2017 roku, a ile w 2018 roku (kolumna order_purchase_timestamp).

-- Zadanie 28: Analiza sprzedawców
-- (A) Z tabeli olist_sellers_dataset wyświetl 5 sprzedawców z miasta o najdłuższej nazwie (mierzonej funkcją LENGTH(seller_city)).
-- (B) Policz, w ilu różnych stanach (seller_state) działają sprzedawcy.

-- Zadanie 29: Najpopularniejsze kategorie produktów
-- (A) Połącz tabele olist_products_dataset i olist_order_items_dataset, aby ustalić, która kategoria (product_category_name) pojawia się najczęściej w zamówieniach. Wyświetl top 5.
-- (B) Dołącz (JOIN) do tego zapytania również product_category_name_translation i wyświetl kategorię w języku angielskim.

-- Zadanie 30: Porównanie danych z kolumną tłumaczeń
-- (A) Zlicz, ile kategorii w olist_products_dataset nie ma odpowiednika w product_category_name_translation (użyj LEFT JOIN i klauzuli WHERE ... IS NULL).
-- (B) Wyświetl te brakujące kategorie (jeśli istnieją).

-- Zadanie 31: Rekordy duplikujące się w bazie
-- (A) Sprawdź, czy w tabeli olist_customers_dataset istnieją duplikaty wartości w kolumnie customer_unique_id. Wyświetl ewentualne duplikujące się identyfikatory i ich liczność.
-- (B) Sprawdź, czy w tabeli olist_orders_dataset istnieją powtarzające się order_id (nie powinno ich być) – wyświetl liczbę takich potencjalnych duplikatów.

-- Zadanie 32: Użycie funkcji okna (window functions) – ranking
-- (A) Za pomocą funkcji okna ROW_NUMBER(), nadaj kolejny numer zamówieniom posortowanym malejąco po dacie zakupu (order_purchase_timestamp). Wyświetl 10 pierwszych.
-- (B) Za pomocą RANK() lub DENSE_RANK(), posortuj zamówienia rosnąco po order_purchase_timestamp i wyświetl 10 pierwszych rekordów z przypisanym rankingiem.

-- Zadanie 33: Użycie funkcji okna – obliczanie sumy częściowej
-- (A) Przyłącz (JOIN) tabelę olist_order_payments_dataset do olist_orders_dataset, a następnie użyj SUM(payment_value) OVER (ORDER BY order_purchase_timestamp) do obliczenia narastającej sumy płatności w porządku czasowym. Wyświetl 10 pierwszych wyników.
-- (B) Policz maksymalną płatność narastającą do danego momentu (użyj MAX(...) OVER (...)).

-- Zadanie 34: Tworzenie tabeli tymczasowej
-- (A) Utwórz tabelę tymczasową temp_delivered_orders zawierającą wyłącznie zamówienia o statusie delivered z olist_orders_dataset.
-- (B) Z tabeli tymczasowej wyświetl liczbę rekordów. Upewnij się, że tabela znika po zakończeniu sesji (cecha TEMPORARY).

-- Zadanie 35: Tworzenie widoku (VIEW)
-- (A) Stwórz widok view_top_states wyświetlający stan (customer_state) oraz liczbę zamówień, posortowaną malejąco. Ogranicz wynik do tych stanów, w których jest co najmniej 1000 zamówień.
-- (B) Wyświetl zawartość widoku i policz, ile stanów się w nim znajduje.

-- Zadanie 36: Poszukiwanie potencjalnych zależności między wielkością produktu a kosztem dostawy
-- (A) Przyłącz olist_products_dataset i olist_order_items_dataset (po product_id), oblicz korelację (CORR(product_weight_g, freight_value)) lub chociaż współczynnik product_weight_g i średniego freight_value.
-- (B) Policz również korelację między product_volume_cm = product_length_cm * product_height_cm * product_width_cm a freight_value (możesz obliczyć tę kolumnę w zapytaniu).

-- Zadanie 37: Sprawdzanie różnicy czasu między akceptacją a wysyłką
-- (A) Z tabeli olist_orders_dataset oblicz różnicę w dniach pomiędzy order_purchase_timestamp a order_approved_at (funkcja AGE lub odejmowanie). Wyświetl 10 przykładów.
-- (B) Policz średnią wartość tej różnicy w dniach.

-- Zadanie 38: Wykorzystanie CASE WHEN
-- (A) W tabeli olist_order_reviews_dataset, wyświetl nową kolumnę, w której:
-- jeśli review_score = 5, wpisz 'Bardzo zadowolony',
-- jeśli review_score pomiędzy 3 a 4, wpisz 'Średnio',
-- w pozostałych przypadkach wpisz 'Niezadowolony'.
-- (B) Policz, ilu klientów ma status 'Bardzo zadowolony', 'Średnio' i 'Niezadowolony' (wygenerowany z CASE WHEN).

-- Zadanie 39: Dodawanie i usuwanie kolumny w tabeli
-- (A) Dodaj kolumnę processed_timestamp TIMESTAMP do tabeli olist_orders_dataset (ALTER TABLE).
-- (B) Usuń ją (kolumnę processed_timestamp) z tabeli olist_orders_dataset.

-- Zadanie 40: Optymalizacja i analiza zapytania
-- (A) Wykonaj zapytanie (np. z Zadania 23 lub innego złożonego JOIN) z użyciem EXPLAIN ANALYZE i sprawdź plan zapytania.
-- (B) Na podstawie planu zapytania, dodaj (jeśli potrzeba) dodatkowy indeks lub skorzystaj z innej optymalizacji. Ponownie uruchom EXPLAIN ANALYZE i sprawdź różnicę w czasie wykonania. */