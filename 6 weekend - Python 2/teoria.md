# Python – Instrukcje warunkowe i pętle
 
Znajdziesz tu najważniejsze pojęcia, przykłady i krótkie komentarze „po ludzku”.

---

## 1. Instrukcje przypisania

### 1.1. Proste przypisanie

Najprostsza operacja w Pythonie: przypisanie wartości do zmiennej.

~~~python
# proste przypisanie
order_value = 199.99   # wartość zamówienia
country = "PL"         # kraj klienta
is_first_order = True  # czy to pierwsze zamówienie
~~~

- `order_value`, `country`, `is_first_order` – nazwy zmiennych,
- znak `=` oznacza „przypisz do”.

**Uwaga:** `=` to **nie jest** porównanie – porównanie to `==`.

---

### 1.2. Przypisanie wielokrotne

Możesz przypisać kilka wartości naraz:

~~~python
# przypisanie wielokrotne
customer_id, order_id, order_value = 1001, 50123, 249.0
~~~

Python „rozpakowuje” wartości kolejno:  
`customer_id = 1001`, `order_id = 50123`, `order_value = 249.0`.

---

### 1.3. Przypisanie tej samej wartości do kilku zmiennych

~~~python
# ta sama wartość do kilku zmiennych
min_order_value = max_order_value = 0
~~~

Obie zmienne mają tę samą wartość.  
Uwaga: przy typach mutowalnych (np. listy) taka konstrukcja może być pułapką – wtedy obie zmienne wskazują na **ten sam obiekt**.

---

### 1.4. Rozpakowanie sekwencji (sequence unpacking)

Rozpakowanie można stosować do list, krotek i innych sekwencji.

~~~python
# rozpakowanie krotki
order = (50123, 1001, 249.0)
order_id, customer_id, order_value = order

# rozpakowanie z "rest"
orders = [100, 200, 300, 400]
first, second, *rest = orders
# first = 100, second = 200, rest = [300, 400]
~~~

Konwencja: jeśli nie chcesz jakiejś wartości, użyj `_`:

~~~python
order_id, _, order_value = (50123, 1001, 249.0)
~~~

---

### 1.5. Przypisanie w miejscu (in-place)

Operacje w miejscu zmieniają istniejący obiekt (zwykle typ mutowalny, np. lista):

~~~python
total_revenue = 0
total_revenue += 199.99   # to samo co total_revenue = total_revenue + 199.99

# dla listy
quantities = [1, 2, 3]
quantities.append(4)      # modyfikuje listę "w miejscu"
~~~

Operatory in-place: `+=`, `-=`, `*=`, `/=`, `//=`, `%=` itd.  
Plus metody typu `.append()`, `.extend()`, `.update()`.

---

### 1.6. Funkcja `bool()` i „truthiness”

Funkcja `bool()` zamienia wartość na `True` lub `False`.

W Pythonie mamy pojęcie „prawdziwości” (truthiness):

- traktowane jak **False**:
  - `0`, `0.0`,
  - `""` (pusty string),
  - `[]` (pusta lista),
  - `{}` (pusty słownik),
  - `set()` (pusty zbiór),
  - `None`;
- wszystko inne – traktowane jak **True**.

~~~python
bool(0)          # False
bool("")         # False
bool([])         # False
bool(None)       # False
bool("0")        # True (bo niepusty string)
bool([0])        # True (lista nie jest pusta)
~~~

Przykład w kontekście danych:

~~~python
discount_code = ""   # brak kodu
if not discount_code:
    print("Brak kodu rabatowego")  # wypisze się, bo pusty string -> False
~~~

---

## 2. Operatory porównania

### 2.1. Podstawowe operatory porównania

- równe: `==`
- różne: `!=`
- większe: `>`
- mniejsze: `<`
- większe lub równe: `>=`
- mniejsze lub równe: `<=`

Wynik porównania to zawsze typ `bool` (`True` lub `False`).

~~~python
order_value = 450

order_value > 300      # True
order_value == 450     # True
order_value != 100     # True
order_value >= 500     # False
~~~

---

### 2.2. Porównania między różnymi typami

W Pythonie 3 porównanie **niezgodnych typów** zazwyczaj kończy się błędem:

~~~python
10 < "5"   # TypeError – nie porównujemy int z str
~~~

Bezpieczna praktyka:

- przed porównaniem zadbaj o ten sam typ, np. konwersja `str` → `int`:
  
~~~python
min_value_str = "100"
min_value = int(min_value_str)

order_value = 150
order_value > min_value  # True
~~~

---

### 2.3. Porównania a `NaN` (Not a Number)

`NaN` pojawia się głównie przy liczbach zmiennoprzecinkowych i w analizie danych (`pandas`, `numpy`).  
Najważniejsza rzecz:

- `NaN` nie jest równy **niczemu**, nawet samemu sobie:

~~~python
import math

x = float("nan")

x == x         # False
math.isnan(x)  # True
~~~

W praktyce (np. w `pandas`) używamy funkcji typu `isna()` zamiast `==`.

---

### 2.4. Porównania leksykalne (stringi)

Porównania stringów działają „leksykalnie” (jak sortowanie alfabetyczne, z uwzględnieniem kodów znaków):

~~~python
"a" < "b"          # True
"apple" < "banana" # True
"PL" < "DE"        # False, bo porównuje kody znaków
~~~

W praktyce częściej używamy:

- `==` / `!=` do sprawdzenia dokładnej wartości,
- operatora `in` do sprawdzenia **występowania** podciągu.

~~~python
status = "completed"

status == "completed"    # True

# sprawdzenie fragmentu
country = "PL"
"PL" in country          # True
"DE" in country          # False
~~~

---

### 2.5. Porównanie występowania w kolekcjach (`in`, `not in`)

Operator `in` sprawdza, czy element znajduje się w kolekcji:

~~~python
blocked_countries = ["RU", "BY", "KP"]
country = "PL"

country in blocked_countries      # False
country not in blocked_countries  # True
~~~

W słowniku:

- `key in dict` – sprawdza, czy klucz istnieje.

~~~python
customer_scores = {1001: 0.8, 1002: 0.3}
1001 in customer_scores      # True
0.8 in customer_scores       # False, sprawdzamy tylko klucze
0.8 in customer_scores.values()  # True
~~~

---

## 3. Operatory logiczne: `and`, `or`, `not`

Służą do budowania złożonych warunków.

- `and` – oba warunki muszą być True,
- `or` – wystarczy, że jeden jest True,
- `not` – negacja (odwraca True/False).

Przykład:

~~~python
order_value = 600
country = "PL"

# duże zamówienie z Polski
if order_value > 500 and country == "PL":
    print("Duże zamówienie z Polski")
~~~

Warunki można łączyć w nawiasach, żeby były czytelne:

~~~python
is_first_order = True
payment_type = "card"

# ryzykowne zamówienie: pierwsze zamówienie i wysoka wartość, albo kraj z listy
high_risk_payment_types = ["cod"]
blocked_countries = ["RU", "BY"]

is_high_value = order_value > 1000
is_blocked_country = country in blocked_countries
is_high_risk_payment = payment_type in high_risk_payment_types

if (is_first_order and is_high_value) or is_blocked_country or is_high_risk_payment:
    print("Oznacz zamówienie jako ryzykowne")
~~~

---

## 4. Operatory `is` i `is not`

### 4.1. `==` vs `is`

- `==` – porównuje **wartość** (czy dane są równe),
- `is` – porównuje **tożsamość** (czy to dokładnie ten sam obiekt w pamięci).

~~~python
a = [1, 2, 3]
b = [1, 2, 3]

a == b   # True (lista ma te same elementy)
a is b   # False (dwie różne listy w pamięci)

c = a
a is c   # True (c i a to ten sam obiekt)
~~~

### 4.2. Porównanie z `None`

Do sprawdzania `None` używamy **`is None`** i **`is not None`**:

~~~python
discount_code = None

if discount_code is None:
    print("Brak kodu rabatowego")

if discount_code is not None:
    print("Mamy kod rabatowy")
~~~

---

## 5. Operatory bitowe (krótkie wprowadzenie)

Operatory bitowe działają na poziomie bitów liczb całkowitych:

- `&` – AND bitowe,
- `|` – OR bitowe,
- `^` – XOR bitowe,
- `~` – negacja bitowa,
- `<<` – przesunięcie bitów w lewo,
- `>>` – przesunięcie bitów w prawo.

Przykład:

~~~python
flags = 0b0101  # 5 w zapisie binarnym
mask  = 0b0011

flags & mask    # 0b0001 -> 1
flags | mask    # 0b0111 -> 7
~~~

W praktyce dana/analityka rzadko używamy bitów bezpośrednio, ale warto znać ich istnienie (np. przy kodowaniu flag, uprawnień).

---

## 6. Instrukcje warunkowe

### 6.1. Podstawowa struktura `if`, `elif`, `else`

~~~python
order_value = 450

if order_value > 500:
    print("Duże zamówienie")
elif order_value > 200:
    print("Średnie zamówienie")
else:
    print("Małe zamówienie")
~~~

- warunki są sprawdzane po kolei,
- pierwsze spełnione `if`/`elif` jest wykonywane,
- `else` (jeśli jest) łapie „resztę przypadków”.

---

### 6.2. Zagnieżdżanie instrukcji warunkowych

Możesz umieszczać `if` w środku `if`:

~~~python
country = "PL"
order_value = 600

if country == "PL":
    if order_value > 500:
        print("Duże zamówienie z Polski")
    else:
        print("Zamówienie z Polski, ale nie aż tak duże")
else:
    print("Zamówienie spoza Polski")
~~~

W praktyce warto uważać na poziom zagnieżdżeń – łatwo stworzyć nieczytelny kod. Często lepiej wydzielić warunek do zmiennej:

~~~python
is_poland = country == "PL"
is_big_order = order_value > 500

if is_poland and is_big_order:
    print("Duże zamówienie z Polski")
~~~

---

### 6.3. Instrukcja inline `if-else` (operator trójargumentowy)

Skrócona forma przypisania z warunkiem:

~~~python
shipping_type = "free" if order_value > 300 else "paid"
~~~

Czyli „jeśli `order_value > 300` → `"free"`, w przeciwnym razie → `"paid"`”.

Czytelne, gdy jest krótkie. Nie nadużywaj do skomplikowanej logiki.

---

### 6.4. Porównanie występowania w stringach i kolekcjach

#### Występowanie w stringach:

~~~python
discount_code = "BLACKFRIDAY20"

if "BLACK" in discount_code:
    print("Kod promocyjny Black Friday")
~~~

#### Występowanie w kolekcjach:

~~~python
blocked_countries = ["RU", "BY", "KP"]

if country in blocked_countries:
    print("Kraj z listy blokowanych")
~~~

---

### 6.5. Instrukcja `match-case` (Python 3.10+)

Pozwala dopasować wartość do „przypadków”, podobnie do `switch` w innych językach.

~~~python
status = "completed"

match status:
    case "completed":
        message = "Zamówienie zrealizowane"
    case "cancelled":
        message = "Zamówienie anulowane"
    case "returned":
        message = "Zamówienie zwrócone"
    case _:
        message = "Status nieznany"

print(message)
~~~

- `case _:` – „domyślny” przypadek (gdy żaden inny nie pasuje),
- `match-case` działa też z bardziej zaawansowanymi wzorcami (tu skupiamy się na prostych stringach).

---

## 7. Pętla `for`

Pętla `for` służy do iterowania po sekwencjach (listach, krotkach, stringach, słownikach, itp.).

### 7.1. Iteracja po liście

~~~python
order_values = [100, 250, 399, 800]

for value in order_values:
    print("Zamówienie o wartości:", value)
~~~

***

### 7.2. `range()` – zakres liczb

`range()` tworzy sekwencję liczb:

- `range(stop)` – od 0 do `stop-1`,
- `range(start, stop)` – od `start` do `stop-1`,
- `range(start, stop, step)` – co `step`.

~~~python
for i in range(5):  # 0, 1, 2, 3, 4
    print(i)

for i in range(1, 6):  # 1, 2, 3, 4, 5
    print(i)
~~~

Przykład – sumowanie wartości zamówień:

~~~python
order_values = [100, 250, 399, 800]
total = 0

for value in order_values:
    total += value

print(total)
~~~

---

### 7.3. Iteracja po stringu

~~~python
discount_code = "BLACK20"
for char in discount_code:
    print(char)
~~~

Możemy zliczyć np. cyfry w kodzie:

~~~python
digits = 0
for char in discount_code:
    if char.isdigit():
        digits += 1
~~~

---

### 7.4. Iteracja po słowniku

~~~python
customer_orders_count = {
    1001: 3,
    1002: 1,
    1003: 5
}

# po kluczach
for customer_id in customer_orders_count:
    print(customer_id)

# po parach klucz-wartość
for customer_id, count in customer_orders_count.items():
    print("Klient", customer_id, "ma", count, "zamówienia")
~~~

---

### 7.5. Zagnieżdżone pętle – listy zagnieżdżone

~~~python
orders = [
    [50123, 1001, 249.0],
    [50124, 1002, 99.0],
    [50125, 1001, 349.0],
]

for order in orders:
    order_id, customer_id, order_value = order
    print("Order:", order_id, "value:", order_value)
~~~

---

### 7.6. `break`, `continue`, `pass`

- `break` – przerwij pętlę,
- `continue` – przejdź do kolejnej iteracji,
- `pass` – nic nie rób (placeholder).

~~~python
orders = [100, 250, 399, 800]

# znajdź pierwsze zamówienie powyżej 500
for value in orders:
    if value > 500:
        print("Znaleziono duże zamówienie:", value)
        break

# pomiń bardzo małe zamówienia
for value in orders:
    if value < 150:
        continue
    print("Przetwarzam zamówienie:", value)
~~~

---

## 8. Pętla `while`

Pętla `while` wykonuje się dopóki warunek jest True.

~~~python
attempts = 0
max_attempts = 3

while attempts < max_attempts:
    print("Próba logowania nr", attempts + 1)
    attempts += 1
~~~

**Uwaga:** łatwo stworzyć pętlę nieskończoną, jeśli:

- warunek nigdy nie staje się False,
- zmienna w warunku się nie zmienia.

Zawsze pilnuj:

- **warunku stopu**,
- zmiennych aktualizowanych wewnątrz pętli.

---

## 9. Iteratory: `range` i `zip`

### 9.1. `range` jako iterator

`range()` to nie lista, tylko obiekt, po którym można iterować.

~~~python
for i in range(10):
    print(i)
~~~

W razie potrzeby możesz zamienić na listę:

~~~python
list(range(5))  # [0, 1, 2, 3, 4]
~~~

---

### 9.2. `zip` – łączenie sekwencji

`zip` łączy elementy z wielu sekwencji w pary (lub krotki).

~~~python
customer_ids = [1001, 1002, 1003]
scores = [0.8, 0.3, 0.5]

for customer_id, score in zip(customer_ids, scores):
    print("Klient", customer_id, "ma score", score)
~~~

Jeżeli listy są różnej długości, `zip` ucina do najkrótszej.

---

## 10. Funkcja `input()` – interakcja z użytkownikiem

`input()` pobiera tekst wpisany przez użytkownika w konsoli.

~~~python
country = input("Podaj kraj klienta (np. PL): ")
min_value_str = input("Podaj minimalną wartość zamówienia: ")

min_value = float(min_value_str)  # konwersja na float

print("Filtr:", country, "min wartość:", min_value)
~~~

Pamiętaj, że `input()` zawsze zwraca **string** – często trzeba skonwertować na `int` lub `float`.

---

## 11. List comprehension

Skrócona, „pythoniczna” forma tworzenia list.

### 11.1. Podstawowy wzór

Zwykła pętla:

~~~python
order_values = [100, 250, 399, 800]
big_orders = []

for value in order_values:
    if value > 300:
        big_orders.append(value)
~~~

To samo jako list comprehension:

~~~python
order_values = [100, 250, 399, 800]
big_orders = [value for value in order_values if value > 300]
~~~

Wzór ogólny:

- `[expression for element in iterable if condition]`

Przykłady:

~~~python
# kwadraty liczb
numbers = [1, 2, 3, 4]
squares = [n * 2 for n in numbers]

# wartości zamówień powyżej 500
orders = [100, 250, 600, 1200]
big_orders = [o for o in orders if o > 500]
~~~

---

## 12. Mini-podsumowanie – logika w praktyce danych

W pracy z danymi (np. zamówienia e-commerce) te elementy łączą się w typowe zadania:

- **warunki (`if`, `elif`, `else`)**:
  - klasyfikacja: `small/medium/large` order,
  - tagowanie: `HIGH_RISK`, `LOYAL_CUSTOMER`, `NEW_CUSTOMER`;
- **pętle (`for`, `while`)**:
  - przejście po wszystkich rekordach i zliczanie metryk,
  - wstępne czyszczenie/filtracja;
- **operatory logiczne (`and`, `or`, `not`)**:
  - „jeśli kraj jest X, a wartość powyżej Y, a płatność jest Z…”;
- **`in` / `not in`**:
  - sprawdzanie, czy kraj jest na liście blokowanych,
  - czy metoda płatności jest dozwolona;
- **list comprehension**:
  - tworzenie list przefiltrowanych rekordów,
  - wstępne przygotowanie danych do analizy.

To wszystko jest fundamentem, który później pojawi się w:

- funkcjach Pythona,
- `pandas` (operacje na kolumnach),
- feature engineering w machine learning.

Im lepiej rozumiesz logikę z tego pliku, tym łatwiej będzie Ci w kolejnych modułach.

---