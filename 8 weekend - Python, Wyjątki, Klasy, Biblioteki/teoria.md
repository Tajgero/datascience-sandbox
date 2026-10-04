# Blok 8: Python - wyjątki, klasy, biblioteki i moduły

## 1. Błędy i wyjątki w Pythonie

### 1.1. Rodzaje błędów

W Pythonie typowo spotkasz dwa główne „rodzaje problemów”:

1. **Błędy składni (SyntaxError)**  
   - Python nawet nie zaczyna wykonywać programu, bo kod jest niepoprawny składniowo.  
   - Przykłady:
     - brak dwukropka po `if`,
     - źle zamknięte nawiasy,
     - literówka w słowie kluczowym.

   ~~~python
   # SyntaxError – brak dwukropka
   if x > 10
       print("duża liczba")
   ~~~

2. **Wyjątki w czasie wykonania (exceptions)**  
   - Kod jest składniowo poprawny, ale w trakcie działania pojawia się sytuacja, z którą Python nie umie sobie poradzić.
   - Przykłady:
     - dzielenie przez 0 – `ZeroDivisionError`,
     - zły indeks listy – `IndexError`,
     - brak klucza w słowniku – `KeyError`,
     - konwersja tekstu na liczbę się nie udaje – `ValueError`.

   ~~~python
   # KeyError – brak klucza "price"
   product = {"name": "Laptop"}
   print(product["price"])
   ~~~

**Intuicja:**  
- `SyntaxError` – problem w „gramatyce” kodu.  
- wyjątek (np. `KeyError`) – problem z danymi lub logiką podczas działania.

---

### 1.2. Traceback – czytanie komunikatu błędu

Kiedy wydarzy się wyjątek, Python drukuje tzw. **traceback** – ślad stosu wywołań. Najważniejsze elementy:

- plik (`File`),
- numer linii,
- przykład fragmentu kodu,
- typ wyjątku (`KeyError`, `ValueError`, …),
- opis (czasem bardzo pomocny).

Najczęściej zaczynamy czytać **od dołu**:

- ostatnia linia – typ wyjątku i opis,
- linie wyżej – gdzie dokładnie w kodzie to się stało.

---

### 1.3. Obsługa wyjątków: try / except / else / finally

Podstawowy wzorzec:

- `try` – tu piszemy „ryzykowny” kod,
- `except` – co robimy, gdy wybuchnie konkretny wyjątek,
- `else` – co robimy, gdy **nie** było błędu,
- `finally` – co robimy **zawsze** (np. zamykamy pliki).

Najprostszy przykład:

~~~python
orders = [
    {"order_id": 1, "amount": 120.5},
    {"order_id": 2},  # brak amount
]

for order in orders:
    try:
        print("Kwota:", order["amount"])
    except KeyError:
        print("Brakuje pola 'amount' w zamówieniu:", order["order_id"])
~~~

Przykład z `else` i `finally`:

~~~python
try:
    f = open("data/orders_january.csv", "r", encoding="utf-8")
    content = f.read()
except FileNotFoundError:
    print("Nie znaleziono pliku z zamówieniami.")
else:
    print("Plik wczytany, długość:", len(content))
finally:
    # ten blok wykona się zawsze (jeśli f istnieje)
    try:
        f.close()
    except NameError:
        pass
~~~

---

### 1.4. Zgłaszanie wyjątków: raise

Czasem dane są **formalnie poprawne**, ale biznesowo nie mają sensu (np. ujemna kwota zamówienia). Wtedy my możemy zgłosić wyjątek:

~~~python
def validate_order(order):
    amount = order.get("amount")
    if amount is None:
        raise ValueError("Brak kwoty 'amount'")
    if amount < 0:
        raise ValueError("Kwota nie może być ujemna")

order = {"order_id": 1, "amount": -10}
validate_order(order)  # ValueError
~~~

**Kluczowa myśl:**  
Wyjątki służą nie tylko do „łapania błędów Pythona”, ale także do **komunikowania problemów biznesowych**.

---

### 1.5. Własne klasy wyjątków

Dla czytelności możesz definiować własne typy wyjątków (dziedziczą z `Exception`):

~~~python
class OrderNotFoundError(Exception):
    """Wyjątek, gdy zamówienie o danym ID nie istnieje."""
    pass


def find_order(orders, order_id):
    for order in orders:
        if order["order_id"] == order_id:
            return order
    raise OrderNotFoundError(f"Nie znaleziono zamówienia {order_id}")


orders = [
    {"order_id": 1, "amount": 100},
    {"order_id": 2, "amount": 200},
]

try:
    order = find_order(orders, 3)
except OrderNotFoundError as e:
    print("Błąd biznesowy:", e)
~~~

To podejście jest bardzo przydatne w większych projektach.

---

## 2. Podstawy programowania obiektowego (OOP)

### 2.1. Klasa i obiekt – intuicja

- **Klasa** – przepis / szablon (np. formularz zamówienia),
- **Obiekt** (instancja) – konkretny egzemplarz (konkretne zamówienie).

W Pythonie klasę definiujemy słowem kluczowym `class`:

~~~python
class Customer:
    def __init__(self, customer_id, name, country):
        # atrybuty obiektu
        self.customer_id = customer_id
        self.name = name
        self.country = country
~~~

- `__init__` – metoda inicjalizująca (konstruktor),
- `self` – odniesienie do konkretnego obiektu (instancji).

Tworzenie obiektu:

~~~python
customer = Customer(customer_id=101, name="Acme Corp", country="PL")
print(customer.name)  # "Acme Corp"
~~~

---

### 2.2. Atrybuty instancji vs atrybuty klasy

**Atrybuty instancji** – unikalne dla konkretnego obiektu:

~~~python
class Order:
    def __init__(self, order_id, amount):
        self.order_id = order_id  # atrybut instancji
        self.amount = amount      # atrybut instancji
~~~

**Atrybuty klasy** – wspólne dla wszystkich obiektów:

~~~python
class Order:
    currency = "PLN"  # atrybut klasy (wspólny)

    def __init__(self, order_id, amount):
        self.order_id = order_id
        self.amount = amount

o1 = Order(1, 100)
o2 = Order(2, 200)

print(o1.currency)   # PLN
print(o2.currency)   # PLN
Order.currency = "EUR"
print(o1.currency)   # EUR
~~~

Dobrze jest **świadomie** decydować, czy coś jest własnością konkretnego zamówienia, czy wszystkich.

---

### 2.3. Metody instancji i `self`

Metoda instancji to funkcja „przyklejona” do klasy, która operuje na `self`:

~~~python
class Order:
    def __init__(self, order_id, amount):
        self.order_id = order_id
        self.amount = amount

    def apply_discount(self, percent):
        # np. percent = 10 -> 10% zniżki
        self.amount = self.amount * (1 - percent / 100)


order = Order(1, 100)
order.apply_discount(10)
print(order.amount)  # 90.0
~~~

Bez `self` w definicji metoda nie zadziała.

---

### 2.4. Elementy „prywatne”

W Pythonie nie ma **twardo egzekwowanej prywatności** jak w niektórych innych językach. Stosujemy **konwencje**:

- `_name` – atrybut/metoda „chroniona” (nie dotykaj, jeśli nie musisz),
- `__name` – „mocniej prywatna” (name mangling).

~~~python
class Customer:
    def __init__(self, customer_id, name):
        self.customer_id = customer_id
        self._segment = "B2B"   # umownie prywatne
        self.__secret_note = "VIP"  # jeszcze bardziej ukryte

    def get_segment(self):
        return self._segment
~~~

W praktyce: najczęściej używa się pojedynczego podkreślenia `_`.

---

### 2.5. Dziedziczenie

**Dziedziczenie** pozwala tworzyć klasy potomne, które bazują na klasie bazowej.

~~~python
class Order:
    def __init__(self, order_id, amount):
        self.order_id = order_id
        self.amount = amount

    def calculate_total(self):
        return self.amount


class OnlineOrder(Order):
    def __init__(self, order_id, amount, shipping_cost):
        super().__init__(order_id, amount)
        self.shipping_cost = shipping_cost

    def calculate_total(self):
        # nadpisanie (override) metody z klasy bazowej
        return self.amount + self.shipping_cost
~~~

- `super().__init__` – wywołanie konstruktora klasy bazowej,
- nadpisywanie metod (override) – typowe w OOP.

---

### 2.6. Polimorfizm

**Polimorfizm** – różne obiekty udostępniają tę samą metodę, ale każdy „w środku” robi coś trochę innego.

~~~python
class Order:
    def calculate_total(self):
        raise NotImplementedError


class OnlineOrder(Order):
    def __init__(self, amount, shipping_cost):
        self.amount = amount
        self.shipping_cost = shipping_cost

    def calculate_total(self):
        return self.amount + self.shipping_cost


class OfflineOrder(Order):
    def __init__(self, amount, discount):
        self.amount = amount
        self.discount = discount

    def calculate_total(self):
        return self.amount * (1 - self.discount)


orders = [
    OnlineOrder(100, 10),
    OfflineOrder(200, 0.1),
]

for o in orders:
    print(o.calculate_total())
~~~

To bardzo przydatne, gdy mamy zbiór obiektów różnych typów, ale chcemy wywoływać na nich te same metody.

---

## 3. Metody magiczne w Pythonie

Metody magiczne (ang. „dunder methods” – od „double underscore”) to metody specjalne, które pozwalają kontrolować zachowanie obiektów Pythona w różnych sytuacjach.

Najczęściej używane w tym bloku:

- `__init__` – konstruktor,
- `__str__` – przyjazna reprezentacja tekstowa,
- `__len__` – długość obiektu (`len(obj)`),
- `__contains__` – operator `in` (`x in obj`),
- `__getitem__` – indeksowanie (`obj[0]`),
- `__iter__` – iteracja po obiekcie (`for x in obj`).

---

### 3.1. __str__

Służy do tworzenia „ładnej” reprezentacji obiektu:

~~~python
class Order:
    def __init__(self, order_id, amount):
        self.order_id = order_id
        self.amount = amount

    def __str__(self):
        return f"Order(id={self.order_id}, amount={self.amount})"


o = Order(1, 100)
print(o)  # Order(id=1, amount=100)
~~~

Bez `__str__` zobaczysz coś w stylu `<__main__.Order object at 0x...>`.

---

### 3.2. Kolekcja zamówień – __len__, __contains__, __getitem__, __iter__

Załóżmy, że mamy klasę trzymającą listę słowników z zamówieniami:

~~~python
class OrdersCollection:
    def __init__(self, orders):
        self._orders = orders

    def __len__(self):
        # ile jest zamówień
        return len(self._orders)

    def __contains__(self, order_id):
        # czy istnieje zamówienie o danym ID
        return any(order["order_id"] == order_id for order in self._orders)

    def __getitem__(self, index):
        # dostęp do zamówienia po indeksie
        return self._orders[index]

    def __iter__(self):
        # iteracja po zamówieniach
        return iter(self._orders)
~~~

Dzięki temu:

~~~python
orders = [
    {"order_id": 1, "amount": 100},
    {"order_id": 2, "amount": 200},
]

collection = OrdersCollection(orders)

print(len(collection))     # __len__
print(1 in collection)     # __contains__
print(collection[0])       # __getitem__
for order in collection:   # __iter__
    print(order["amount"])
~~~

Intuicja: zamiast używać „gołej” listy słowników, tworzymy klasę, która „wie”, że przechowuje zamówienia i może dodać dodatkowe zachowania (walidacja, logowanie itd.).

---

## 4. Zasady SOLID – bardzo krótko i praktycznie

SOLID to zbiór **pięciu** zasad projektowania obiektowego. W tym bloku skupiamy się na intuicji, szczególnie:

1. **Single Responsibility Principle (SRP)**  
   - jedna klasa = jedna główna odpowiedzialność.
   - jeśli klasa robi „wszystko” – od wczytywania plików, przez logikę biznesową, po logowanie – jest trudna w utrzymaniu.

2. (wspomnimy z grubsza) **Open/Closed Principle, Liskov Substitution, Interface Segregation, Dependency Inversion**, ale bez wchodzenia w akademickie szczegóły.

Przykład złamania SRP:

~~~python
class OrderManager:
    def __init__(self, path):
        self.path = path
        self.orders = []

    def load_orders(self):
        # wczytywanie pliku CSV
        ...

    def calculate_statistics(self):
        # logika biznesowa
        ...

    def export_report_to_pdf(self):
        # logika generowania PDF
        ...
~~~

Lepsze podejście:

- osobna klasa do wczytywania,
- osobna do logiki biznesowej,
- osobna do generowania raportu.

Przy małych skryptach nie musisz być super „dogmatyczny”, ale warto wyrobić sobie odruch: **czy ta klasa nie jest za bardzo przeładowana odpowiedzialnościami?**

---

## 5. Moduły, pakiety i import

### 5.1. Moduł

**Moduł** to po prostu plik `.py`. Główne powody dzielenia kodu na moduły:

- lepsza organizacja,
- możliwość wielokrotnego użycia (re–use),
- łatwiejsze testowanie.

Przykład:

- plik `utils.py`:

  ~~~python
  def calculate_total(orders):
      return sum(order["amount"] for order in orders)
  ~~~

- plik `main.py`:

  ~~~python
  import utils

  orders = [
      {"order_id": 1, "amount": 100},
      {"order_id": 2, "amount": 200},
  ]

  total = utils.calculate_total(orders)
  print("Suma:", total)
  ~~~

Import selektywny i aliasy:

~~~python
from utils import calculate_total as calc_total

total = calc_total(orders)
~~~

---

### 5.2. Pakiet

**Pakiet** to katalog z modułami. W nowszych wersjach Pythona nie jest konieczne tworzenie `__init__.py`, ale w wielu projektach nadal się go używa.

Przykład struktury:

- `ecommerce/`
  - `__init__.py` (opcjonalnie)
  - `orders.py`
  - `customers.py`

W `orders.py`:

~~~python
def find_order(orders, order_id):
    ...
~~~

W `main.py`:

~~~python
from ecommerce.orders import find_order
~~~

---

### 5.3. Biblioteki i pip

**Biblioteka** to po prostu pakiet, którego ktoś już napisał (np. `pandas`, `requests`).

Instalacja (w terminalu):

- `pip install requests`

Użycie:

~~~python
import requests

response = requests.get("https://example.com")
print(response.status_code)
~~~

W tym bloku pip pojawi się tylko jako **demo**, ale w dalszej części kursu (pandas, scikit-learn) będziesz używać go regularnie.

---

## 6. pathlib – praca ze ścieżkami i plikami

### 6.1. Dlaczego pathlib?

`pathlib` to nowoczesny sposób pracy ze ścieżkami w Pythonie:

- jest wygodniejszy i czytelniejszy niż łączenie stringów,
- działa dobrze na różnych systemach (Windows / Linux / macOS).

Podstawowa klasa: `Path`.

~~~python
from pathlib import Path

data_dir = Path("data")
print(data_dir.exists())      # czy folder istnieje?
print(data_dir.is_dir())      # czy to katalog?
~~~

---

### 6.2. Łączenie ścieżek

Zamiast:

- `"data/" + "orders_january.csv"`

używamy operatora `/`:

~~~python
from pathlib import Path

data_dir = Path("data")
orders_path = data_dir / "orders_january.csv"
print(orders_path)  # data/orders_january.csv
~~~

---

### 6.3. Wyszukiwanie plików

Możemy znaleźć wszystkie pliki `.csv` w katalogu `data`:

~~~python
from pathlib import Path

data_dir = Path("data")

for path in data_dir.glob("*.csv"):
    print(path.name)
~~~

---

### 6.4. Czytanie plików CSV (prosto)

Na potrzeby bloku korzystamy z podstawowego `open` i rozbijania po przecinkach:

~~~python
from pathlib import Path

data_dir = Path("data")
orders_path = data_dir / "orders_january.csv"

orders = []

with orders_path.open(encoding="utf-8") as f:
    header = f.readline().strip().split(",")
    for line in f:
        values = line.strip().split(",")
        row = dict(zip(header, values))
        # np. konwersja amount na liczby
        row["amount"] = float(row["amount"])
        orders.append(row)

print("Wczytano zamówień:", len(orders))
~~~

Potem będziemy te `orders` traktować jako **listę słowników** i używać w klasach i funkcjach.

---

## 7. Połączenie wszystkiego w spójną całość

Na koniec bloku naszym celem jest mieć coś w stylu:

- klasy:

  - `Customer`,
  - `Order`,
  - `OrdersCollection`,

- moduły:

  - `orders_loader.py` – wczytywanie CSV (`pathlib`),
  - `orders_domain.py` – definicje klas / logiki biznesowej,

- wyjątki:

  - `OrderNotFoundError`,
  - obsługa błędów plików (np. brak pliku),

- metody magiczne:

  - `__str__` dla czytelnego logowania,
  - `__len__`, `__contains__`, `__iter__` dla kolekcji zamówień.

Prosty przepływ może wyglądać tak:

1. `OrdersLoader` korzysta z `pathlib` i wczytuje pliki CSV,
2. dane z CSV zamieniamy na listę słowników,
3. `OrdersCollection` opakowuje tę listę i dodaje wygodne metody
   (wyszukiwanie po ID, liczenie zamówień, sprawdzenie czy dane ID istnieje),
4. przy błędach (brak pliku, brak zamówienia) zgłaszamy czytelne wyjątki.

To jest wzorzec, który często powtarza się w pracy data scientist:

- trzeba coś wczytać,
- obsłużyć błędy,
- zapakować dane w sensowną strukturę,
- zapewnić czytelne API (funkcje / klasy),
- podzielić kod na moduły, żeby dało się w tym pracować i rozwijać projekt.

---