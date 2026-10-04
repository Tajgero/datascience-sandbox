# Python – Funkcje

Ten plik jest „kompendium w pigułce” do funkcji w Pythonie.  
Skupiamy się na intuicji i przykładach bliskich pracy data scientist (operacje na słownikach, listach, prostych „danych”).

---

## 1. Po co nam funkcje?

Funkcja to **fragment kodu z nazwą**, który:

- przyjmuje dane na wejściu (argumenty),
- wykonuje na nich jakąś logikę,
- **zwraca wynik** (`return`).

Dzięki funkcjom:

- nie powtarzamy tego samego kodu w wielu miejscach,
- kod jest krótszy, czytelniejszy i łatwiejszy do testowania,
- możemy budować „klocki” (małe funkcje), z których składamy większą analizę.

W analizie danych typowe funkcje to np.:

- `calculate_average_order_value(orders)`,
- `filter_active_customers(customers)`,
- `get_country_sales(orders, country="PL")`.

---

## 2. Definiowanie funkcji – podstawy

### 2.1. Składnia `def`

Najprostsza funkcja:

~~~python
def say_hello():
    print("Hello!")
~~~

Elementy definicji:

- `def` – słowo kluczowe,
- `say_hello` – nazwa funkcji,
- `()` – lista parametrów (tu pusta),
- `:` – dwukropek,
- **wcięty blok** – ciało funkcji.

Wywołanie funkcji:

~~~python
say_hello()  # wywołanie, nastąpi print
~~~

Bez nawiasów (`say_hello`) dostajemy **obiekt funkcji**, ale jej nie uruchamiamy.

### 2.2. Parametry i argumenty

**Parametry** – nazwy w definicji funkcji:

~~~python
def greet(name):
    print("Hello,", name)
~~~

**Argumenty** – wartości, które przekazujemy przy wywołaniu:

~~~python
greet("Anna")     # "Anna" to argument
greet(name="Jan") # argument nazwany
~~~

---

## 3. `return` vs `print`

Kluczowa różnica:

- `print` – wypisuje coś na ekran; przydatne do debugowania,
- `return` – **zwraca wartość** z funkcji, dzięki czemu możemy z niej dalej korzystać.

### 3.1. Przykład błędnego użycia `print` zamiast `return`

~~~python
def calculate_total_net(prices):
    total = sum(prices)
    print(total)  # tylko wypisuje, nie zwraca

result = calculate_total_net([10, 20, 30])
print("Result:", result)
~~~

`result` będzie mieć wartość `None`, bo funkcja nic nie zwraca (`return`).

### 3.2. Poprawna wersja z `return`

~~~python
def calculate_total_net(prices):
    total = sum(prices)
    return total  # zwraca wartość

result = calculate_total_net([10, 20, 30])
print("Result:", result)      # możemy użyć result
discounted = result * 0.9     # i dalej przetwarzać
~~~

Zasada: **w analizie danych większość funkcji powinna zwracać dane**, a nie tylko je wypisywać.

---

## 4. Rodzaje parametrów

Python pozwala definiować funkcje z różnymi typami parametrów. W praktyce w DS ważne są:

- parametry pozycyjne,
- parametry nazwane,
- parametry z wartościami domyślnymi,
- `*args`,
- `**kwargs`.

### 4.1. Parametry pozycyjne

Kolejność ma znaczenie:

~~~python
def apply_vat(net_amount, vat_rate):
    return net_amount * (1 + vat_rate)

apply_vat(100, 0.23)  # net_amount=100, vat_rate=0.23
~~~

### 4.2. Parametry nazwane (keyword arguments)

Podajemy nazwę parametru przy wywołaniu:

~~~python
apply_vat(net_amount=100, vat_rate=0.23)
apply_vat(vat_rate=0.23, net_amount=100)  # kolejność już nieważna
~~~

W bibliotekach (np. pandas, sklearn) parametry nazwane są standardem.

### 4.3. Wartości domyślne

Definiujemy wartość parametru, jeśli użytkownik jej nie poda:

~~~python
def convert_to_pln(amount, currency="PLN", rate=1.0):
    # na razie zakładamy, że rate jest poprawny
    if currency == "PLN":
        return amount
    return amount * rate

convert_to_pln(100)                     # currency="PLN"
convert_to_pln(100, currency="EUR", rate=4.3)
~~~

**Uwaga:** parametry z wartościami domyślnymi **muszą być na końcu listy parametrów**.

### 4.4. `*args` – dowolna liczba argumentów pozycyjnych

Zbiera wszystkie dodatkowe argumenty pozycyjne do krotki:

~~~python
def apply_discounts(base_price, *discounts):
    price = base_price
    for discount in discounts:
        price = price * (1 - discount)
    return price

apply_discounts(100)             # brak rabatów → 100
apply_discounts(100, 0.1)        # jeden rabat 10%
apply_discounts(100, 0.1, 0.05)  # dwa rabaty
~~~

Wewnątrz funkcji `discounts` to krotka, np. `(0.1, 0.05)`.

### 4.5. `**kwargs` – dowolna liczba argumentów nazwanych

Zbiera dodatkowe **argumenty nazwane** do słownika:

~~~python
def build_metric_config(name, **options):
    config = {"name": name}
    config.update(options)
    return config

cfg = build_metric_config(
    "avg_order_value",
    min_orders=3,
    only_active=True,
    country="PL",
)
# cfg to słownik z wszystkimi opcjami
~~~

Częste w bibliotekach, gdy chcemy przekazywać dodatkowe parametry konfiguracyjne.

---

## 5. Rozpakowywanie `*seq` i `**dict`

Rozpakowywanie działa także **przy wywołaniu funkcji**.

### 5.1. Rozpakowywanie sekwencji (`*seq`)

Załóżmy, że mamy funkcję:

~~~python
def calculate_margin(revenue, cost, tax_rate):
    profit = revenue - cost
    return profit * (1 - tax_rate)
~~~

I listę wartości:

~~~python
params = [10000, 7000, 0.19]
margin = calculate_margin(*params)  # równoważne calculate_margin(10000, 7000, 0.19)
~~~

`*params` rozpakowuje listę do argumentów pozycyjnych.

### 5.2. Rozpakowywanie słownika (`**dict`)

~~~python
def create_order_summary(order_id, customer_id, total_net, currency):
    return {
        "order_id": order_id,
        "customer_id": customer_id,
        "total_net": total_net,
        "currency": currency,
    }

data = {
    "order_id": "O123",
    "customer_id": "C001",
    "total_net": 100.0,
    "currency": "PLN",
}

summary = create_order_summary(**data)
~~~

Nazwy kluczy w słowniku **muszą odpowiadać** nazwom parametrów funkcji.

---

## 6. Przestrzeń nazw i zasięg (LEGB)

**Przestrzeń nazw** = miejsce, gdzie Python szuka nazw (zmiennych, funkcji).

Reguła **LEGB** (kolejność szukania):

1. **Local** – wewnątrz bieżącej funkcji,
2. **Enclosing** – przestrzenie funkcji „otaczających” (dla funkcji zagnieżdżonych),
3. **Global** – na poziomie modułu (pliku),
4. **Built-in** – nazwy wbudowane w Pythona (np. `len`, `sum`).

### 6.1. Przykład LEGB

~~~python
x = "global"

def outer():
    x = "enclosing"

    def inner():
        x = "local"
        print("inner:", x)  # użyje lokalnego x
    inner()
    print("outer:", x)      # użyje x z outer

outer()
print("global:", x)         # użyje globalnego x
~~~

Wynik:

- `inner: local`
- `outer: enclosing`
- `global: global`

**Zasada praktyczna:**  
w analizie danych rzadko potrzebujemy `global`.  
Bezpieczniej jest **zwracać wartości** z funkcji (`return`) i przypisywać je na zewnątrz.

---

## 7. Rekurencja vs iteracja

**Rekurencja** – funkcja wywołuje samą siebie.  
**Iteracja** – używamy pętli (`for`, `while`).

Rekurencja przydaje się, gdy problem ma naturalną strukturę „w siebie” (np. drzewo, lista zagnieżdżona).  
W praktyce DS **częściej** korzystamy z iteracji (pętle, funkcje z bibliotek).

### 7.1. Rekurencyjna suma elementów listy

~~~python
def recursive_sum(numbers):
    if not numbers:           # base case: pusta lista
        return 0
    first = numbers[0]
    rest = numbers[1:]
    return first + recursive_sum(rest)
~~~

### 7.2. Iteracyjna suma elementów listy

~~~python
def iterative_sum(numbers):
    total = 0
    for n in numbers:
        total += n
    return total
~~~

**Wnioski:**

- rekurencja bywa bardziej „matematyczna” i elegancka,
- iteracja jest zazwyczaj prostsza i bezpieczniejsza (brak ryzyka przekroczenia limitu rekurencji).

---

## 8. Type hints i adnotacje

**Type hints** to sposób na opisanie **oczekiwanych typów** parametrów i wartości zwracanej:

~~~python
def total_net_amount(amounts: list[float]) -> float:
    return sum(amounts)
~~~

- `amounts: list[float]` – informacja, że oczekujemy listy liczb zmiennoprzecinkowych,
- `-> float` – funkcja zwraca `float`.

Python tych typów **nie wymusza** w runtime, ale:

- pomagają ludziom (czytelność),
- pomagają narzędziom (autouzupełnianie, lintery, mypy itp.).

Adnotacje są dostępne w atrybucie `__annotations__`:

~~~python
print(total_net_amount.__annotations__)
# np. {'amounts': list[float], 'return': float}
~~~

W większych projektach (np. systemy rekomendacji, pipeline’y danych) type hints bardzo ułatwiają współpracę.

---

## 9. Funkcje anonimowe `lambda`

**`lambda`** pozwala tworzyć krótkie, anonimowe funkcje „w locie”.

### 9.1. Przykład

Zamiast:

~~~python
def by_total(order):
    return order["total_net"]
~~~

możemy napisać:

~~~python
by_total = lambda order: order["total_net"]
~~~

Często używane w:

- `sorted`,
- `map`,
- `filter`.

### 9.2. Sortowanie klientów po średniej wartości zamówień

Załóżmy, że mamy listę rekordów:

~~~python
customers = [
    {"id": "C001", "avg_order_value": 120.0},
    {"id": "C002", "avg_order_value": 75.0},
]
~~~

Sortowanie:

~~~python
sorted_customers = sorted(
    customers,
    key=lambda c: c["avg_order_value"],
    reverse=True,
)
~~~

**Zasada:** jeśli funkcja robi się zbyt skomplikowana, **nie używamy `lambda`**, tylko normalnego `def`.

---

## 10. Wybrane funkcje wbudowane i metody stringów

### 10.1. Funkcje wbudowane (built-ins)

- `print(obj)` – wypisuje reprezentację obiektu,
- `input(prompt)` – pobiera tekst od użytkownika (użyteczne w prostych symulacjach),
- `range(start, stop, step)` – generator liczb (często w pętlach),
- `type(obj)` – zwraca typ obiektu,
- `sum(iterable)` – suma elementów,
- `max(iterable)` – największy element,
- `min(iterable)` – najmniejszy element.

Przykład:

~~~python
values = [10, 20, 5]
print("Sum:", sum(values))
print("Max:", max(values))
print("Min:", min(values))
~~~

### 10.2. Metody stringów

Dla obiektów typu `str` mamy szereg przydatnych metod:

- `s.startswith(prefix)` – czy tekst zaczyna się od `prefix`,
- `s.endswith(suffix)` – czy tekst kończy się na `suffix`,
- `s.strip()` – usuwa białe znaki z obu stron,
- `s.lstrip()` / `s.rstrip()` – z lewej / prawej strony,
- `s.index(sub)` – indeks pierwszego wystąpienia `sub` (błąd, jeśli brak),
- `s.count(sub)` – liczba wystąpień `sub` w tekście.

Przykłady:

~~~python
name = "  Product A  "
clean_name = name.strip()  # "Product A"

event = "purchase:product_id=123"
print(event.startswith("purchase"))  # True
print(event.count("product_id"))     # 1
~~~

W czyszczeniu danych tekstowych (np. nazwy produktów, logi zdarzeń) to podstawowe narzędzia.

---

## 11. Listy zagnieżdżone i zagnieżdżone struktury

W analizie danych często mamy dane w strukturach typu:

- lista list,
- lista słowników,
- słownik, którego wartościami są listy/słowniki.

### 11.1. Prosta lista zagnieżdżona

Załóżmy, że mamy tygodniowe dane o zamówieniach:

~~~python
weekly_orders = [
    [10, 12, 8, 15, 11, 9, 13],   # tydzień 1
    [9, 14, 7, 10, 12, 8, 16],    # tydzień 2
]
~~~

Funkcja licząca sumę i średnią:

~~~python
def weekly_stats(weekly_orders):
    totals = []
    for week in weekly_orders:
        week_total = sum(week)
        totals.append(week_total)
    overall_total = sum(totals)
    overall_avg = overall_total / len(weekly_orders)
    return totals, overall_total, overall_avg
~~~

### 11.2. Słownik + lista słowników

Typowy wzorzec:

~~~python
orders_data = {
    "O001": {
        "customer_id": "C001",
        "items": [
            {"product_id": "P1", "quantity": 2, "price": 30.0},
            {"product_id": "P2", "quantity": 1, "price": 50.0},
        ],
    },
    # ...
}
~~~

Funkcja licząca wartość zamówienia:

~~~python
def calculate_order_value(order):
    total = 0.0
    for item in order["items"]:
        total += item["quantity"] * item["price"]
    return total
~~~

Funkcja do dodania pola `total_net` do wszystkich zamówień:

~~~python
def enrich_orders_with_total(orders_data):
    for order_id, order in orders_data.items():
        order["total_net"] = calculate_order_value(order)
    return orders_data
~~~

Takie funkcje to „klocki”, które później wykorzystamy w większych pipeline’ach.

---

## 12. Funkcje jako klocki w analizie danych

Dobrą praktyką jest budowanie analizy jako **ciągu funkcji**:

1. `load_data()` – wczytanie (w tym bloku symulujemy gotowymi strukturami),
2. `clean_data(data)` – czyszczenie,
3. `aggregate_data(data)` – agregacje,
4. `calculate_kpis(aggregates)` – KPI, metryki,
5. `generate_report(kpis)` – wynik w postaci tekstu / słownika.

Przykładowy mini-pipeline:

~~~python
def clean_orders(orders_data):
    # np. wyfiltrowanie anulowanych zamówień
    return {
        oid: order
        for oid, order in orders_data.items()
        if order["status"] == "completed"
    }

def aggregate_sales_by_country(orders_data, customers_data):
    result = {}
    for order_id, order in orders_data.items():
        customer_id = order["customer_id"]
        country = customers_data[customer_id]["country"]
        result[country] = result.get(country, 0) + order["total_net"]
    return result

def generate_text_report(country_sales):
    lines = []
    for country, total in country_sales.items():
        lines.append(f"{country}: {total:.2f}")
    return "\n".join(lines)
~~~

Klarowne, małe funkcje ułatwiają:

- testowanie logiki,
- ponowne wykorzystanie kodu w projekcie końcowym,
- współpracę w zespole.

---

## 13. Podsumowanie – najważniejsze idee

1. Funkcje to **podstawowy sposób organizacji kodu** – zwłaszcza w analizie danych.
2. **Zwracaj (`return`) dane**, a nie tylko je wypisuj.
3. Korzystaj z różnych rodzajów parametrów (`*args`, `**kwargs`), ale dbaj o czytelność.
4. Rozumienie LEGB pomaga unikać dziwnych bugów ze zmiennymi.
5. Rekurencja jest ciekawa, ale w praktyce DS częściej wygrywa iteracja.
6. Type hints poprawiają czytelność i współpracę – warto się ich trzymać w większych projektach.
7. `lambda` jest narzędziem, nie religią – używaj tam, gdzie serio upraszcza kod.
8. Praca z zagnieżdżonymi listami i słownikami to codzienność w danych – funkcje pomagają tę pracę uporządkować.

W dalszej części bloku będziesz ćwiczyć wszystkie te elementy na praktycznych zadaniach z użyciem „pseudo-danych” biznesowych (słowników z klientami, zamówieniami, produktami i zdarzeniami).