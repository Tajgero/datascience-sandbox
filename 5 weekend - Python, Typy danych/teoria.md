# Blok 5: Python - typy danych i operacje na nich

## 1. Wprowadzenie: po co nam Python w Data Science?

Python jest głównym językiem pracy data scientist, bo:

- ma bogaty ekosystem bibliotek (NumPy, pandas, scikit-learn, matplotlib),
- jest prosty w zapisie – kod często przypomina pseudokod,
- dobrze nadaje się do prototypowania i eksperymentowania w notatnikach (Jupyter).

Żeby móc używać zaawansowanych narzędzi (pandas, modele ML), musimy najpierw naprawdę dobrze rozumieć:

- jak Python **przechowuje dane** (typy danych),
- jak **operuje** na liczbach, tekstach i kolekcjach,
- co się dzieje, kiedy modyfikujemy listę, zbiór, słownik.

Ten blok to fundament – późniejsze biblioteki bazują na tych samych zasadach.

---

## 2. Środowisko: interpreter, maszyna wirtualna, Anaconda, Jupyter, VS Code

### 2.1. Interpreter i maszyna wirtualna Pythona

- **Interpreter Pythona** – program, który „czyta” Twój kod linijka po linijce i go wykonuje.
- **Maszyna wirtualna Pythona (Python Virtual Machine)** – część interpretera, która wykonuje tzw. bytecode (wewnętrzną, uproszczoną reprezentację kodu).

Możesz myśleć o tym tak:
1. Piszesz kod w pliku `.py` lub komórce notatnika.
2. Interpreter zamienia go na prostsze instrukcje.
3. Maszyna wirtualna wykonuje te instrukcje.

Jako użytkownik zwykle nie musisz się tym przejmować – ważne jest, że:
- kod uruchamiasz w środowisku (notatnik, VS Code),
- interpreter „pod spodem” robi całą magię.

### 2.2. Anaconda

**Anaconda** to dystrybucja Pythona:

- zawiera Pythona + zestaw bibliotek (m.in. NumPy, pandas),
- pozwala tworzyć **wirtualne środowiska** (różne wersje bibliotek dla różnych projektów),
- udostępnia **Anaconda Navigator** – graficzny panel do uruchamiania Jupyter Notebook, JupyterLab, Spydera itp.

W kursie:

- używamy Pythona z Anacondy,
- notatniki uruchamiamy z Anacondy (Notebook / JupyterLab),
- w VS Code wybieramy interpreter z Anacondy.

### 2.3. Jupyter Notebook

Jupyter Notebook to narzędzie, w którym:

- kod dzielimy na **komórki**,
- możemy uruchamiać komórki niezależnie (np. najpierw definicje zmiennych, potem obliczenia),
- obok kodu można mieć opis (Markdown), wykresy, tabele.

To idealne narzędzie do:

- uczenia się Pythona,
- analiz eksploracyjnych,
- prototypowania modeli ML.

### 2.4. Visual Studio Code (VS Code)

VS Code to edytor kodu, w którym:

- pracujemy na plikach `.py`,
- mamy podgląd struktury projektu,
- używamy rozszerzenia Python (formatowanie, linting, debugowanie).

W kursie:

- notatniki – do nauki, eksperymentów, ćwiczeń,
- pliki `.py` – do „bardziej produkcyjnego” kodu (później).

---

## 3. PEP8 i linting

### 3.1. Czym jest PEP8?

**PEP8** to dokument opisujący konwencje pisania kodu w Pythonie:

- styl nazewnictwa (np. `snake_case` dla zmiennych),
- liczba spacji wokół operatorów,
- maksymalna długość linii,
- sposób wcięć (4 spacje na poziom wcięcia).

Nie jest to „prawo”, ale dobry zwyczaj. Kod zgodny z PEP8:

- łatwiej czytać i utrzymywać,
- jest bliższy standardowi, który znają inni programiści.

Przykład:

- lepiej: `total_price = price * quantity`
- gorzej: `totalPrice=price*quantity`

### 3.2. Linting

**Linting** – automatyczna analiza kodu pod kątem:

- błędów (np. `variable is not defined`),
- ostrzeżeń (np. nieużywana zmienna),
- stylu (np. brak spacji po przecinku).

Linting w VS Code:

- podkreśla fragmenty kodu,
- pokazuje komunikaty w panelu „Problems”.

Linting pomaga:

- znajdować błędy wcześniej,
- uczyć się dobrych praktyk Pythona.

---

## 4. Zmienne, obiekty, typy, komentarze

### 4.1. Zmienna jako etykieta

W Pythonie:

- **zmienna** to **etykieta (nazwa)** przyczepiona do **obiektu w pamięci**.
- obiekt ma **typ** (np. `int`, `float`, `str`, `list`).

Przykład:

~~~python
price = 99.99
~~~

- `price` – nazwa zmiennej,
- `99.99` – obiekt typu `float`,
- zmienna „wskazuje” na obiekt.

Ta sama nazwa może w czasie życia programu wskazywać na różne typy:

~~~python
x = 10       # x wskazuje na int
x = "Hello"  # x wskazuje na str
~~~

Python jest **dynamicznie typowany** – typ jest związany z obiektem, nie z nazwą zmiennej.

### 4.2. Sprawdzanie typu

Do sprawdzania typu służy funkcja `type()`:

~~~python
x = 10
print(type(x))  # <class 'int'>

y = "abc"
print(type(y))  # <class 'str'>
~~~

### 4.3. Komentarze

Komentarze służą do wyjaśniania kodu:

- jednowierszowe – poprzedzone `#`:

    ~~~python
    # Cena jednego produktu
    price = 99.99
    ~~~

- „blokowe” – kilka linii stringa (np. potrójne cudzysłowy) używanych jako opis:

    ~~~python
    """
    Ten fragment kodu:
    - liczy łączną wartość koszyka,
    - wypisuje wynik.
    """
    total = 0
    ~~~

---

## 5. Typy proste: None, int, float, bool

### 5.1. None

`None` to specjalna wartość:

- oznacza **brak wartości**, „puste miejsce”,
- często używana jako:
  - brak danych,
  - wartość domyślna.

Przykład:

~~~python
discount = None  # brak informacji o rabacie
~~~

### 5.2. int – liczby całkowite

`int` to liczby całkowite (np. -3, 0, 42):

~~~python
quantity = 5
customer_id = 1001
~~~

Typowe zastosowania:

- liczniki,
- identyfikatory,
- indeksy w listach.

### 5.3. float – liczby zmiennoprzecinkowe

`float` to liczby z częścią ułamkową:

~~~python
price = 99.99
tax_rate = 0.23
~~~

Ważne:

- reprezentacja binarna powoduje, że niektóre liczby nie są przedstawione „idealnie”,
- dlatego 0.1 + 0.2 może nie dać dokładnie 0.3 – to normalne w komputerach.

### 5.4. bool – wartości logiczne

`bool` ma dwie wartości: `True` i `False`.

Przykłady:

~~~python
is_new_customer = True
has_discount = False
~~~

Boolean jest wynikiem porównań i wyrażeń logicznych (później użyjemy w `if`):

~~~python
price = 100
is_expensive = price > 50  # True
~~~

---

## 6. Operatory arytmetyczne

Python obsługuje typowe operatory:

- `+` – dodawanie,
- `-` – odejmowanie,
- `*` – mnożenie,
- `/` – dzielenie (wynik zawsze `float`),
- `//` – dzielenie całkowite (część całkowita),
- `%` – reszta z dzielenia,
- `**` – potęgowanie.

Przykłady:

~~~python
a = 10
b = 3

print(a + b)   # 13
print(a - b)   # 7
print(a * b)   # 30
print(a / b)   # 3.333...
print(a // b)  # 3
print(a % b)   # 1
print(a ** b)  # 1000
~~~

Kolejność działań jak w matematyce – można (i warto) używać nawiasów.

---

## 7. String (str): tekst, znaki specjalne, operacje

### 7.1. Tworzenie stringów

String to tekst w pojedynczych lub podwójnych cudzysłowach:

~~~python
name = "Anna"
city = 'Warszawa'
~~~

Wielolinijkowy string:

~~~python
address = """
ul. Długa 10
00-001 Warszawa
"""
~~~

### 7.2. Znaki specjalne i znak ucieczki

**Znak ucieczki** to `\` – zmienia znaczenie kolejnego znaku.

Najważniejsze:

- `\n` – nowa linia,
- `\t` – tabulator,
- `\"` – cudzysłów w stringu w cudzysłowie,
- `\\` – dosłowny backslash.

Przykład:

~~~python
text = "Linia 1\nLinia 2"
print(text)
# Linia 1
# Linia 2
~~~

### 7.3. Podstawowe operacje na stringach

- `len(s)` – długość tekstu:

    ~~~python
    s = "Laptop"
    print(len(s))  # 6
    ~~~

- konkatenacja (`+`):

    ~~~python
    first_name = "Anna"
    last_name = "Kowalska"
    full_name = first_name + " " + last_name
    ~~~

- powielanie (`*`):

    ~~~python
    line = "-" * 10  # "----------"
    ~~~

### 7.4. Metody stringów

Najczęściej używane:

- `upper()` – na wielkie litery,
- `lower()` – na małe litery,
- `replace(stary, nowy)` – zamiana fragmentu,
- `split(separator)` – podział tekstu na listę.

Przykład:

~~~python
product_name = "laptop gamingowy"

print(product_name.upper())          # "LAPTOP GAMINGOWY"
print(product_name.replace("owy", ""))  # "laptop gaming"
print(product_name.split(" "))       # ["laptop", "gamingowy"]
~~~

### 7.5. format() i f-stringi (opcjonalnie)

`format()`:

~~~python
product = "Laptop"
price = 3500.0

message = "Produkt: {}, cena: {} PLN".format(product, price)
~~~

f-string (skrótowy zapis, Python 3.6+):

~~~python
product = "Laptop"
price = 3500.0

message = f"Produkt: {product}, cena: {price} PLN"
~~~

---

## 8. Sekwencje: tuple i list

### 8.1. Indeksowanie i sekwencje

Sekwencje (np. listy, tuple, stringi):

- przechowują wiele elementów w ustalonej kolejności,
- elementy mają indeksy od 0 do n-1.

Przykład indeksowania:

~~~python
numbers = [10, 20, 30]
print(numbers[0])  # 10
print(numbers[1])  # 20
~~~

### 8.2. tuple – niemodyfikowalna sekwencja

Tworzenie:

~~~python
point = (10, 20)
~~~

Cechy:

- elementów nie można zmieniać (niemutowalna),
- dobra, gdy dane są „konfiguracją”, np. współrzędne, parametry.

Pakowanie i rozpakowanie:

~~~python
point = (10, 20)
x, y = point
print(x)  # 10
print(y)  # 20
~~~

### 8.3. list – modyfikowalna sekwencja

Tworzenie:

~~~python
products = ["Laptop", "Mouse", "Keyboard"]
~~~

Najważniejsze metody:

- `append(x)` – dodaje na koniec,
- `insert(i, x)` – wstawia na pozycji `i`,
- `remove(x)` – usuwa pierwsze wystąpienie wartości,
- `pop(i)` – usuwa i zwraca element na pozycji `i` (domyślnie ostatni),
- `index(x)` – zwraca indeks pierwszego wystąpienia wartości,
- `count(x)` – liczba wystąpień,
- `sort()` – sortuje listę,
- `extend(iterable)` – rozszerza listę o elementy innej sekwencji.

Przykład:

~~~python
products = ["Laptop", "Mouse", "Keyboard"]

products.append("Monitor")     # ["Laptop", "Mouse", "Keyboard", "Monitor"]
products.remove("Mouse")       # ["Laptop", "Keyboard", "Monitor"]
products.sort()                # ["Keyboard", "Laptop", "Monitor"]
~~~

### 8.4. range()

`range()` generuje sekwencję liczb (najczęściej do pracy z pętlami, ale można używać samodzielnie):

~~~python
numbers = list(range(5))          # [0, 1, 2, 3, 4]
even_numbers = list(range(0, 10, 2))  # [0, 2, 4, 6, 8]
~~~

---

## 9. Mutowalność, aliasy, kopiowanie (shallow vs deep)

### 9.1. Mutowalność

- Typy niemutowalne – nie można zmienić istniejącego obiektu:
  - `int`, `float`, `bool`, `str`, `tuple`.
- Typy mutowalne – można zmieniać zawartość obiektu:
  - `list`, `set`, `dict`.

### 9.2. Alias zamiast kopii

Przykład:

~~~python
a = [1, 2, 3]
b = a

b.append(4)
print(a)  # [1, 2, 3, 4]
print(b)  # [1, 2, 3, 4]
~~~

- `b = a` nie tworzy nowej listy,
- `a` i `b` to dwie etykiety do tej samej listy.

### 9.3. Płytka kopia

Płytką kopię listy tworzymy np.:

~~~python
a = [1, 2, 3]
b = a.copy()

b.append(4)
print(a)  # [1, 2, 3]
print(b)  # [1, 2, 3, 4]
~~~

Działa dobrze, gdy lista zawiera proste typy (int, float, str).

### 9.4. Głęboka kopia

Głęboka kopia – nowy obiekt + kopiowane są zagnieżdżone obiekty:

~~~python
import copy

a = [[1, 2], [3, 4]]
b = copy.deepcopy(a)

b[0].append(99)
print(a)  # [[1, 2], [3, 4]]
print(b)  # [[1, 2, 99], [3, 4]]
~~~

W praktyce:

- na tym etapie wystarczy intuicja, że przy zagnieżdżonych strukturach aliasy mogą robić „dziwne rzeczy”,
- głęboka kopia rozwiązuje ten problem.

---

## 10. Set – zbiór

### 10.1. Czym jest set?

`set` to zbiór unikalnych elementów:

- nie przechowuje duplikatów,
- nie gwarantuje kolejności,
- pozwala szybko sprawdzić, czy element jest w zbiorze.

Tworzenie:

~~~python
customers = {1001, 1002, 1003}
~~~

Z listy:

~~~python
customer_ids = [1001, 1002, 1003, 1001]
unique_customers = set(customer_ids)  # {1001, 1002, 1003}
~~~

### 10.2. Operacje na set

- `add(x)` – dodaje element,
- `remove(x)` – usuwa (błąd, jeśli nie ma elementu),
- `in` – sprawdzenie przynależności.

Przykład:

~~~python
products = {"Laptop", "Mouse"}

products.add("Keyboard")
products.remove("Mouse")

print("Laptop" in products)  # True
~~~

### 10.3. Operacje zbiorowe

Załóżmy:

~~~python
a = {1, 2, 3}
b = {3, 4, 5}
~~~

- suma (union): `a | b` → {1, 2, 3, 4, 5},
- przecięcie (intersection): `a & b` → {3},
- różnica (difference): `a - b` → {1, 2}.

W kontekście biznesowym:

- zbiór klientów, którzy kupili produkt A,
- zbiór klientów, którzy kupili produkt B,
- przecięcie – klienci, którzy kupili oba produkty.

---

## 11. dict – słownik (klucz → wartość)

### 11.1. Czym jest dict?

`dict` to kolekcja par klucz–wartość:

- klucz musi być hashowalny (np. `int`, `str`, `tuple`),
- wartość może być dowolnym obiektem.

Przykład:

~~~python
customer_spent = {
    1001: 4300.0,
    1002:   80.0,
    1003:  150.0
}
~~~

### 11.2. Dodawanie i aktualizacja

Dodanie nowej pary lub aktualizacja:

~~~python
customer_spent[1004] = 500.0    # nowy klient
customer_spent[1001] = 4400.0   # aktualizacja wartości
~~~

### 11.3. Pobieranie wartości

- klasycznie:

    ~~~python
    total = customer_spent[1001]
    ~~~

    jeśli klucz nie istnieje – `KeyError`.

- bezpiecznie – `get()`:

    ~~~python
    total = customer_spent.get(1005, 0.0)  # jeśli nie ma klienta, zwróci 0.0
    ~~~

### 11.4. Usuwanie i sprawdzanie

- usuwanie: `del dict[key]`:

    ~~~python
    del customer_spent[1002]
    ~~~

- sprawdzanie czy klucz istnieje:

    ~~~python
    if 1001 in customer_spent:
        print("Znamy tego klienta")
    ~~~

### 11.5. update() i iteracja

`update()` – dodaje/aktualizuje wiele wpisów naraz:

~~~python
new_data = {1003: 200.0, 1005: 120.0}
customer_spent.update(new_data)
~~~

Iteracje (na razie bardziej „pokazowo”):

- po kluczach (domyślnie):

    ~~~python
    for customer_id in customer_spent:
        ...
    ~~~

- po parach (klucz, wartość):

    ~~~python
    for customer_id, total in customer_spent.items():
        ...
    ~~~

Pętle omówimy dokładniej w kolejnym bloku – tu istotne jest, że słownik ma metody `.keys()`, `.values()`, `.items()`.

---

## 12. Inne typy danych – sygnał, że istnieją

Na tym etapie wystarczy świadomość, że Python ma więcej typów:

- `complex` – liczby zespolone,
- `bytes`, `bytearray` – dane bajtowe,
- różne typy z bibliotek zewnętrznych (np. `DataFrame` w pandas, `ndarray` w NumPy).

Na razie skupiamy się na typach wbudowanych, bo:

- są podstawą działania tych bardziej zaawansowanych typów,
- większość operacji biznesowych da się opisać przy ich użyciu.

---

## 13. Podsumowanie – mapa pojęć

Po tym bloku powinieneś/powinnaś:

1. Rozumieć różnicę między:
   - typami prostymi (`None`, `int`, `float`, `bool`, `str`),
   - kolekcjami (`list`, `tuple`, `set`, `dict`).

2. Wiedzieć:
   - czym jest zmienna i obiekt,
   - że typ jest cechą obiektu, nie nazwy zmiennej,
   - co oznacza mutowalność (list/set/dict) vs niemutowalność (int/float/str/tuple).

3. Umieć:
   - wykonać podstawowe operacje arytmetyczne,
   - pracować na stringach (len, konkatenacja, proste metody),
   - tworzyć i modyfikować listy,
   - usuwać duplikaty przy użyciu set,
   - zbudować prosty słownik, zaktualizować jego wartości, bezpiecznie pobrać dane.

Ta teoria ma być „mapą terenu”. Resztę zbudujesz w praktyce: w ćwiczeniach i mini-projektach podczas bloku.