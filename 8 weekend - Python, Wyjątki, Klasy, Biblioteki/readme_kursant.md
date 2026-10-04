# Blok 8: Python - wyjątki, klasy, biblioteki i moduły

To jest czwarty blok z Pythona. Zakładamy, że znasz już:

- podstawową składnię,
- typy danych,
- kolekcje (`list`, `dict` itd.),
- instrukcje warunkowe i pętle,
- funkcje (`def`, argumenty, `return`).

W tym bloku wchodzimy na „next level”: zaczniemy pisać bardziej „dorosły” kod – z obsługą błędów, klasami, modułami i pracą na plikach.

---

## 1. Po tym bloku będziesz umieć…

1. **Rozumieć błędy w Pythonie:**
   - odróżniać błąd składni od wyjątku w czasie wykonania,
   - czytać komunikaty błędów (traceback),
   - korzystać z `try / except / else / finally`,
   - samodzielnie zgłaszać wyjątki (`raise`),
   - tworzyć własne typy wyjątków (np. dla brakującego zamówienia).

2. **Pracować z programowaniem obiektowym (OOP):**
   - definiować klasy i tworzyć obiekty,
   - używać `__init__`, `self` i atrybutów obiektów,
   - rozróżniać atrybuty instancji i atrybuty klasy,
   - używać dziedziczenia i prostego polimorfizmu (różne klasy z tym samym interfejsem),
   - stosować elementy „prywatne” (konwencje `_name`, `__name`).

3. **Korzystać z metod magicznych:**
   - pisać czytelne reprezentacje obiektów (`__str__`),
   - implementować `__len__`, `__contains__`, `__getitem__`, `__iter__` w prostych klasach,
   - sprawić, że Twoja klasa będzie zachowywała się jak lista/zbiór.

4. **Rozumieć podstawy zasad SOLID:**
   - zauważać, kiedy jedna klasa „robi za dużo”,
   - rozbijać duży kawałek kodu na mniejsze, lepiej opisane fragmenty.

5. **Korzystać z modułów, pakietów i bibliotek:**
   - rozumieć, po co dzielmy kod na pliki i katalogi,
   - używać `import`, `from ... import ...` i aliasów,
   - zainstalować prostą bibliotekę przez `pip`,
   - korzystać z modułu `pathlib` do pracy ze ścieżkami i plikami,
   - wczytywać dane z plików `.csv` i zamieniać je na listy słowników.

---

## 2. Dla kogo jest ten blok?

Ten blok jest dla Ciebie, jeśli:

- znasz już podstawy Pythona i chcesz pisać kod bliższy temu, co robi się w realnych projektach,
- chcesz lepiej rozumieć komunikaty błędów i nie panikować, kiedy „coś wybuchnie”,
- chcesz mieć fundamenty OOP, które przydadzą się w dalszej części kursu (pandas, analityka, projekty).

Poziom jest ustawiony na **2/5** – kontynuacja podstaw, spokojne tempo, dużo przykładów.

---

## 3. Wymagania wstępne

Przed tym blokiem warto, żebyś:

1. Potrafił(a) napisać prostą funkcję w Pythonie, np.:
   - funkcja licząca sumę wartości z listy,
   - funkcja filtrująca listę słowników po jakimś polu.

2. Czuł(a) się w miarę komfortowo z:
   - listami i słownikami,
   - `for`, `if`, `while`,
   - podstawowym użyciem modułu `random` lub innych prostych importów.

Nie musisz znać jeszcze żadnej biblioteki typu pandas – to przyjdzie później.

---

## 4. Środowisko i narzędzia

Podczas bloku możesz pracować:

- w **VS Code** (rekomendowane),
- lub w **Jupyter Notebook**.

Wymagania techniczne:

- **Python:** 3.10 lub nowszy,
- podstawowa obsługa terminala (uruchomienie `python`, `pip`).

### 4.1. Jak przygotować środowisko (wersja minimalna)

1. **Sprawdź, czy masz Pythona**
   - W terminalu / wierszu poleceń wpisz:
     - Windows: `python --version` lub `py --version`
     - macOS/Linux: `python3 --version`
   - Jeśli nie masz Pythona – pobierz ze strony python.org i zainstaluj.

2. **Zainstaluj VS Code (jeśli chcesz pracować w VS Code)**
   - Pobierz VS Code ze strony producenta,
   - zainstaluj rozszerzenie „Python”.

3. **Pobierz materiały do bloku**
   - skopiuj folder z materiałami (notatniki, pliki `*.md`, katalog `data`),
   - otwórz ten folder w VS Code lub innym edytorze.

4. **(Opcjonalnie) Stwórz wirtualne środowisko**
   - w terminalu w folderze projektu:
     - Windows:
       ~~~bash
       python -m venv venv
       venv\Scripts\activate
       ~~~
     - macOS/Linux:
       ~~~bash
       python3 -m venv venv
       source venv/bin/activate
       ~~~
   - na potrzeby tego bloku nie jest to konieczne, ale warto się przyzwyczajać.

---

## 5. Dane wykorzystywane w ćwiczeniach

Ćwiczenia bazują na danych „biznesowych”:

- **zamówienia** (orders),
- **klienci** (customers).

Dane występują w dwóch postaciach:

1. **Jako pliki CSV** (w folderze `data/`):
   - `orders_january.csv`, `orders_february.csv`:
     - `order_id` – numer zamówienia,
     - `customer_id` – numer klienta,
     - `order_date` – data zamówienia (tekst, format np. `2024-01-15`),
     - `status` – np. `paid`, `cancelled`, `pending`,
     - `amount` – kwota zamówienia (liczba zmiennoprzecinkowa).
   - `customers.csv`:
     - `customer_id` – numer klienta,
     - `name` – imię/nazwisko lub nazwa,
     - `country` – kraj,
     - `segment` – np. `B2B` / `B2C`.

2. **Jako listy słowników w kodzie Pythona**:
   Będziemy często operować bezpośrednio na strukturach takich jak:

   ~~~python
   orders = [
       {"order_id": 1, "customer_id": 101, "status": "paid", "amount": 120.5},
       {"order_id": 2, "customer_id": 102, "status": "cancelled", "amount": 45.0},
       {"order_id": 3, "customer_id": 102, "status": "paid", "amount": 300.0},
   ]
   ~~~

   Dzięki temu:
   - utrwalisz pracę ze słownikami,
   - łatwiej będzie Ci później przejść do pandas,
   - zobaczysz, jak klasy mogą „opakować” takie słowniki.

---

## 6. Zakres tematyczny – co dokładnie przerobimy

### 6.1. Wyjątki i błędy

- rodzaje błędów:
  - błędy składni (`SyntaxError`),
  - wyjątki w trakcie działania (`TypeError`, `KeyError`, `ValueError` itd.),
- obsługa wyjątków:
  - `try`,
  - `except`,
  - `else`,
  - `finally`,
- zgłaszanie własnych wyjątków:
  - `raise ValueError("…")`,
  - pisanie własnych klas wyjątków (np. `OrderNotFoundError`),
- praktyczne scenariusze:
  - brak klucza w słowniku,
  - zły format liczby,
  - brak pliku na dysku.

### 6.2. Programowanie obiektowe (OOP)

- pojęcia:
  - klasa, obiekt, instancja,
  - atrybuty i metody,
- konstruktor `__init__` i `self`,
- atrybuty klasy vs atrybuty instancji,
- elementy „prywatne” – konwencje `_nazwa`, `__nazwa`,
- dziedziczenie:
  - `class OnlineOrder(Order):`,
- polimorfizm:
  - różne klasy, ta sama metoda (np. `calculate_discount` działa inaczej).

### 6.3. Metody magiczne

- `__str__` – czytelne drukowanie obiektów,
- `__len__` – definicja „długości” obiektu (np. liczba zamówień),
- `__contains__` – użycie `in` na obiekcie,
- `__getitem__` – indeksowanie obiektu jak listy,
- `__iter__` – iterowanie po własnej kolekcji.

### 6.4. Zasady SOLID (lekko i praktycznie)

- Single Responsibility Principle – jedna klasa, jedna odpowiedzialność,
- przykłady:
  - klasa, która robi „wszystko” – i jak ją poprawić.

Nie będziemy wymagać od Ciebie „wykucia na blachę” teorii. Bardziej chodzi o to, żebyś **czuł(a)**, kiedy warto podzielić klasy i funkcje.

### 6.5. Moduły, pakiety, biblioteki, pathlib

- dzielenie kodu na pliki `.py`,
- importowanie:
  - `import module`,
  - `from module import function`,
  - `import module as m`,
- podstawy korzystania z `pip`:
  - instalacja biblioteki,
  - import i proste użycie,
- `pathlib`:
  - reprezentacja ścieżek (`Path`),
  - operacje na ścieżkach (`/`, `glob`, `exists`, `is_file`),
  - łączenie `pathlib` z `open` i plikami CSV.

---

## 7. Jak będziemy pracować w trakcie bloku

### 7.1. Forma zajęć

- krótki wstęp teoretyczny do każdego tematu,
- dużo **mikroćwiczeń** – krótkie zadania do wykonania na bieżąco,
- kilka większych **mini–projektów**:
  - prosty „manager zamówień”,
  - wczytywanie danych z CSV i opakowywanie ich w klasy.

Nie musisz robić wszystkiego idealnie. Ważne, żebyś próbował(a), zadawał(a) pytania i stopniowo oswajał(a) się z nowymi pojęciami.

---

## 8. Zadanie domowe – w skrócie

**Temat:** Mini system zamówień z obsługą błędów.

- wczytaj dane o zamówieniach i klientach (pliki CSV lub dane „zaszyte” w kodzie),
- zdefiniuj klasy:
  - `Customer`,
  - `Order`,
  - `OrdersRepository` (kolekcja zamówień),
- w `OrdersRepository` zaimplementuj:
  - wyszukiwanie zamówienia po `order_id`,
  - `__len__` (liczba zamówień),
  - `__contains__` (czy istnieje zamówienie o podanym ID),
- zaimplementuj obsługę błędów:
  - brak pliku – przechwyć błąd i pokaż czytelny komunikat,
  - błędny rekord w danych (np. brak `amount`),
  - brak zamówienia o podanym ID – własny wyjątek, np. `OrderNotFoundError`.

To zadanie jest dla chętnych, ale **bardzo** pomaga utrwalić materiał. Możesz je robić swoim tempem po zajęciach.

---

## 9. Praktyczne wskazówki na start

1. **Nie bój się błędów.**  
   W tym bloku błędy są wręcz mile widziane – na nich uczymy się obsługi wyjątków. Zamiast się denerwować, zatrzymaj się i spróbuj na spokojnie przeczytać komunikat.

2. **Czytaj traceback od dołu.**  
   Najbardziej interesuje nas kilka ostatnich linii błędu: typ wyjątku i linia, w której się pojawił.

3. **Małe kroki, częste uruchamianie.**  
   Nie pisz 50 linii kodu „w ciemno”. Zmieniaj kod po trochu, uruchamiaj często, testuj małe fragmenty.

4. **Korzystaj z `print` i `__str__`.**  
   Czytelne wypisywanie obiektów bardzo pomaga w debugowaniu. Lepiej mieć prosty `__str__` niż nic.

5. **Dbaj o nazwy.**  
   Lepsze `total_amount` niż `ta`, lepsze `OrderRepository` niż `X`. Dobre nazwy to już połowa zrozumienia kodu.

6. **Pytaj.**  
   Jeśli coś jest niejasne:
   - zapytaj trenera,
   - pokaż fragment kodu,
   - powiedz, co chciałeś(aś) osiągnąć i co wyszło.

---

## 10. Jak ten blok przyda Ci się później

W dalszej części kursu:

- będziesz pracować z bibliotekami typu pandas, scikit-learn, itp.,
- będziesz pisać własne narzędzia do przetwarzania danych,
- pojawią się większe projekty.

Umiejętności z tego bloku pomogą Ci:

- dzielić kod na czytelne fragmenty (klasy, moduły),
- obsługiwać błędy przy wczytywaniu danych (np. błędny plik),
- tworzyć kod, który jest łatwiejszy do utrzymania i rozwijania.

Innymi słowy: to jest moment, w którym Twój Python zaczyna wyglądać jak kod junior data scientist / analityka, a nie tylko „skrypty na szybko”.

---

Jeśli coś w tym opisie jest niejasne – zanotuj pytania i przynieś je na zajęcia. Ten blok jest idealnym momentem, żeby „dopykać” różne niepewności z poprzednich części Pythona.