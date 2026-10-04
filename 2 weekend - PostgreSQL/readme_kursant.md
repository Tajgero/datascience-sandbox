# Blok 2: SQL – Podstawowa składnia  
Moduł: 2 (wprowadzenie do PostgreSQL)  
Czas trwania: 8 godzin

---

## 1. O czym jest ten blok?

W tym bloku zaczynasz **prawdziwą pracę z bazą danych** w języku SQL, na silniku **PostgreSQL**.  
Przestajesz patrzeć na bazę jak na „czarną skrzynkę” – zaczynasz samodzielnie:

- zadawać pytania w SQL,
- wyciągać dane z wielu tabel,
- budować pierwsze proste raporty.

Pracujemy na **realistycznym datasetcie e-commerce** (inspirowanym danymi sklepu internetowego / marketplace’u). To bardzo zbliżona sytuacja do tego, co robią analitycy i data scientist w pracy (marketing, sprzedaż, product analytics).

---

## 2. Po tym bloku będziesz umieć…

Po tym bloku będziesz potrafić:

1. **Napisać i przeczytać podstawowe zapytanie SQL**:
   - wybrać kolumny (`SELECT`),
   - wskazać tabelę (`FROM`),
   - przefiltrować wiersze (`WHERE`),
   - posortować wynik (`ORDER BY`),
   - ograniczyć liczbę wierszy (`LIMIT`).

2. **Rozumieć typy danych w PostgreSQL**:
   - liczby (`INTEGER`, `NUMERIC`),
   - daty i czas (`DATE`, `TIMESTAMP`),
   - tekst (`TEXT`, `VARCHAR`),
   - `NULL` – brak wartości.

3. **Używać operatorów**:
   - porównujące: `=`, `<>`, `<`, `>`, `<=`, `>=`,
   - logiczne: `AND`, `OR`, `NOT`,
   - arytmetyczne: `+`, `-`, `*`, `/`.

4. **Korzystać z funkcji agregujących**:
   - liczyć rekordy (`COUNT`, `COUNT(DISTINCT ...)`),
   - liczyć sumy, średnie, minimum, maksimum (`SUM`, `AVG`, `MIN`, `MAX`),
   - grupować dane (`GROUP BY`),
   - filtrować grupy (`HAVING`).

5. **Posługiwać się funkcjami wbudowanymi** (PostgreSQL):
   - tekstowe: `UPPER`, `LOWER`, `REPLACE`, `LENGTH`, `LEFT`, `RIGHT`, `LTRIM`, `RTRIM`,
   - numeryczne: `ABS`, `ROUND`,
   - dat/czasu: `DATE_PART`, `TO_CHAR`,
   - obsługa braków danych: `COALESCE`, `NULLIF`,
   - wybór wartości: `GREATEST`, `LEAST`.

6. **Stosować instrukcję warunkową `CASE`**:
   - kategoryzować dane, np. podział zamówień na „małe / średnie / duże”.

7. **Łączyć tabele**:
   - `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`, `CROSS JOIN`.

8. **Łączyć wyniki zapytań**:
   - `UNION`, `UNION ALL`, `EXCEPT`, `INTERSECT`.

9. **Tworzyć proste widoki**:
   - `CREATE VIEW`, `DROP VIEW`,
   - rozumieć, że widok to zapisane zapytanie.

---

## 3. Dla kogo jest ten blok?

Ten blok jest dla Ciebie, jeśli:

- **dopiero zaczynasz** z SQL (poziom 1 – „początkujący”),
- chcesz umieć samodzielnie „wyklikać” dane, zamiast prosić o nie inną osobę.

Nie potrzebujesz wcześniejszej znajomości Pythona ani statystyki do tego bloku.

---

## 4. Wymagania wstępne

Przed zajęciami załóżmy, że:

- masz zainstalowane:
  - **PostgreSQL** (np. wersja 14+),
  - **DBeaver** (darmowa wersja community),
- możesz się zalogować do swojej lokalnej bazy danych (hasło, użytkownik),
- masz dostęp do:
  - skryptów przygotowanych przez prowadzącego:
    - `setup_olist_schema.sql`,
    - `setup_olist_data.sql`.

Jeśli coś z powyższej listy brzmi obco – spokojnie, pomożemy na początku zajęć.  

---

## 5. Środowisko – z czego będziemy korzystać?

W tym bloku używamy:

- **Silnik bazy danych:** PostgreSQL  
- **Klient SQL:** DBeaver (interfejs graficzny)  
- **Schemat bazy:** `olist`  
- **Język:** standardowy SQL w dialekcie PostgreSQL

Dodatkowo w plikach kursowych:

- pliki `.sql` z zadaniami (`cwiczenia_sql_clean.sql` i `cwiczenia_sql_solved.sql`).

---

## 6. Instalacja i przygotowanie krok po kroku

Jeśli już masz PostgreSQL i DBeaver – możesz ten rozdział tylko przejrzeć.

### 6.1. PostgreSQL (skrót)

1. Zainstaluj PostgreSQL (jeśli jeszcze nie masz).
2. Podczas instalacji:
   - zapamiętaj:
     - nazwę użytkownika (np. `postgres`),
     - hasło,
     - port (domyślnie 5432).
3. Po instalacji – upewnij się, że usługa PostgreSQL działa.

### 6.2. DBeaver – pierwsze połączenie

1. Uruchom DBeaver.
2. Kliknij „New Database Connection”.
3. Wybierz `PostgreSQL`.
4. Uzupełnij:
   - Host: `localhost`,
   - Port: `5432` (jeśli nie zmieniałeś),
   - Database: np. `postgres` (na start),
   - User: np. `postgres`,
   - Password: Twoje hasło.
5. Kliknij „Test Connection”.
6. Jeśli wszystko jest OK – kliknij „Finish”.

### 6.3. Utworzenie bazy i załadowanie danych

1. W DBeaver w drzewku połączeń kliknij prawym na serwer → „Create → Database…”.  
   Nazwij ją np. `ds_bootcamp`.
2. Po utworzeniu bazy:
   - kliknij prawym na nazwę bazy `ds_bootcamp`,
   - wybierz „SQL Editor → New SQL Script”.
3. Otwórz plik `setup_olist_schema.sql` (dostarczony przez prowadzącego).
   - Skopiuj jego treść do DBeaver **albo** użyj opcji „Run SQL Script”.
   - Uruchom cały skrypt (ikona „play”).
4. Następnie uruchom `setup_olist_data.sql` (analogicznie).
5. Po wszystkim w drzewku powinna pojawić się baza / schemat `olist` z tabelami:

   - `olist_customers`
   - `olist_orders`
   - `olist_order_items`
   - `olist_products`
   - `olist_order_payments`

Jeśli coś nie działa – na początku zajęć prowadzący pomoże Ci to dopiąć.

---

## 7. Dane, na których pracujemy – obraz biznesowy

Pracujemy na danych **sklepu internetowego / marketplace’u**. Możesz je mentalnie traktować jak uproszczone dane np. Allegro / Amazon / OLX, ale zanonimizowane.

Najważniejsze tabele:

1. `olist_customers` – klienci:
   - skąd są (miasto, region),
   - kiedy się „pojawili” w systemie.

2. `olist_orders` – zamówienia:
   - kto zamówił (klient),
   - kiedy (data zakupu),
   - jaki był status (dostarczone, anulowane itp.),
   - daty z różnych etapów (akceptacja, wysyłka, dostawa).

3. `olist_order_items` – pozycje w zamówieniu:
   - jakie produkty wchodziły w skład zamówienia,
   - cena, koszt dostawy.

4. `olist_products` – produkty:
   - kategoria produktu,
   - proste cechy (np. długość opisu, waga).

5. `olist_order_payments` – płatności:
   - sposób płatności (karta, przelew, voucher),
   - kwota, liczba rat.

Na tych danych będziesz zadawać pytania typu:

- Ilu mamy klientów?
- Ile zamówień dziennie?
- Jakie kategorie sprzedają się najlepiej?
- Jaki jest średni koszyk klienta?

To są typowe pytania z pracy analityka / data scientist w firmach e-commerce.

---

## 8. Jak będziemy pracować na zajęciach?

### Balans: 30% teoria, 70% praktyka

- **Teoria (krótkie bloki):**
  - co to jest `SELECT` / `FROM` / `WHERE`,
  - co oznaczają poszczególne typy danych,
  - jak działa `JOIN`, `GROUP BY`, `CASE`.

- **Praktyka (większość czasu):**
  - seria krótkich zadań (5–15 min),
  - 1–2 mini-projekty (ok. 30–40 min każdy).

Pracujemy w DBeaver – wszystkie zapytania będziesz pisać samodzielnie (z pomocą prowadzącego i gotowych szablonów).  

W materiałach dostajesz:

- plik z zadaniami SQL bez rozwiązań (`cwiczenia_sql_clean.sql`) – do pracy w trakcie,
- plik z rozwiązaniami (`cwiczenia_sql_solved.sql`) – do nauki po zajęciach.

---

## 9. Zadanie domowe – skrót

Zadanie domowe (dla chętnych, ale bardzo polecane):

**H1. Profilowanie klienta**  
Dla wybranego klienta przygotuj jedno lub kilka zapytań, które pokażą jego „historię zakupową”:

- liczba zamówień,
- sumaryczna / średnia wartość koszyka,
- jakich kategorii produkty kupuje,
- czy ma sezony (np. dużo zamówień w Q4).

Cel: utrwalenie:

- `JOIN` między tabelami,
- agregacji (`SUM`, `AVG`, `COUNT`),
- funkcji daty (`DATE_PART` / `TO_CHAR`),
- ewentualnie `CASE` (np. segment „lojalności”).

---

## 10. Twoja checklista przed zajęciami

Przejdź po tej liście i zaznacz ✅:

- [ ] Mam zainstalowany **PostgreSQL** (albo przynajmniej mogę to zrobić).
- [ ] Mam zainstalowany **DBeaver**.
- [ ] Znam (albo mam zapisane) dane do logowania do bazy (`user`, `password`, `port`).
- [ ] Mam pliki:
  - [ ] `setup_olist_schema.sql`
  - [ ] `setup_olist_data.sql`
- [ ] Potrafię:
  - [ ] otworzyć DBeaver,
  - [ ] połączyć się z bazą (choćby `postgres`),
  - [ ] uruchomić proste zapytanie w SQL Editor (np. `SELECT 1;`).

Jeśli czegoś nie odhaczasz – nie panikuj. Zapisz problem, a na początku bloku przejdziemy przez to razem.

---

## 11. Praktyczne wskazówki dla Ciebie

1. **Formatuj kod od początku**  
   Lepiej przyzwyczaić się od razu do czytelnego zapisu:
   ~~~sql
   SELECT
       c.customer_id,
       c.customer_city,
       c.customer_state
   FROM olist_customers AS c
   WHERE c.customer_state = 'SP'
   ORDER BY c.customer_city;
   ~~~
   To jest standard, jaki zobaczysz w pracy.

2. **Dawkuj trudność**  
   Jeśli zadanie wydaje się trudne:
   - najpierw napisz prostsze zapytanie (np. z jedną tabelą),
   - uruchom, sprawdź wynik,
   - dopiero potem dodaj `JOIN`, `GROUP BY` itd.

3. **Nie bój się błędów**  
   Komunikaty błędów w SQL bywają „gęste”, ale to normalne.  
   Ucz się z nich:
   - często chodzi o literówki w nazwach kolumn,
   - brak przecinka,
   - złą kolejność klauzul.

4. **Pytaj „po ludzku”**  
   Jeśli nie wiesz, jak coś napisać w SQL, zacznij od zdania po polsku:  
   „Chcę policzyć, ilu klientów kupowało w 2018 roku więcej niż 3 razy” – a dopiero potem przekładaj to na SQL.

5. **Zapisz swoje ulubione zapytania**  
   Warto mieć swój plik / notatnik z fragmentami SQL, do których wrócisz później (np. bazowy `JOIN` trzech tabel).

---

## 12. Jak ten blok pomoże Ci w projekcie końcowym?

W projekcie końcowym będziesz:

- potrzebować **własnego datasetu** (z bazy lub plików),
- budować cechy / metryki (np. „liczba zamówień klienta w ostatnim roku”).

Po tym bloku:

- będziesz w stanie samodzielnie przygotować takie dane z bazy PostgreSQL,
- zrozumiesz, jak łączyć tabele i agregować dane w taki sposób, żeby karmiąc potem modele ML:
  - wiedzieć, co oznacza każda kolumna,
  - móc odtworzyć logikę (to bardzo ważne w realnych projektach).

---

## 13. Czego na tym bloku jeszcze nie robimy?

Świadomie **nie zajmujemy się tutaj**:

- tworzeniem własnych tabel (`CREATE TABLE`),
- modyfikacją struktury bazy (`ALTER TABLE`),
- uprawnieniami (`GRANT`, `REVOKE`),
- skomplikowaną optymalizacją wydajności.

Skupiamy się na tym, co realnie potrzebujesz na poziomie **data scientist**:  
czyli **czytaniu i wyciąganiu danych**.

---

## 14. Na koniec – krótka motywacja

SQL to jedno z najważniejszych narzędzi w pracy z danymi.  

Po tym bloku:

- nie będziesz jeszcze „guru SQL” (spokojnie, to normalne),
- ale będziesz w stanie:
  - samodzielnie odpalić bazę,
  - wybrać i połączyć dane z kilku tabel,
  - policzyć podstawowe metryki biznesowe.

To w praktyce wystarczy, żeby:

- sensownie współpracować z innymi analitykami,
- przygotowywać dane do raportów,
- rozpocząć pracę nad modelami ML w kolejnych modułach.

Przyjdź z otwartą głową, notatnikiem i gotowością na sporo pisania SQL 😊

---