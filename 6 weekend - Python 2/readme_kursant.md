# Blok 6: Python - Instrukcje warunkowe i pętle

Drugi blok w module Pythona (8 godzin, poziom 2/5).  
Cel: domknięcie podstaw Pythona – logika, warunki, pętle – tak, żebyś swobodnie pisał(a) proste skrypty operujące na danych (np. zamówienia, produkty, klienci).

---

## 1. Po tym bloku będziesz umieć…

Po zakończeniu zajęć powinieneś/powinnaś:

- **Pracować ze zmiennymi i przypisaniami**
  - stosować proste i wielokrotne przypisanie (`a = 1`, `a, b = 1, 2`),
  - rozpakowywać sekwencje (np. listy, krotki),
  - rozumieć, jak `bool()` interpretuje różne typy (puste listy, stringi, `None` itd.).

- **Porównywać wartości i używać logiki**
  - korzystać z operatorów porównania (`==`, `!=`, `<`, `>`, `<=`, `>=`),
  - rozumieć różnicę między `==` (porównanie wartości) a `is` (tożsamość obiektu),
  - stosować operatory logiczne `and`, `or`, `not` w warunkach.

- **Budować instrukcje warunkowe**
  - pisać poprawne `if`, `elif`, `else` (także zagnieżdżone),
  - używać skróconej formy warunku (inline `if-else`),
  - znać podstawy `match-case` (dopasowywanie wartości do przypadków).

- **Pisać pętle i korzystać z iteratorów**
  - używać pętli `for` z `range()` i iterować po listach, słownikach i stringach,
  - stosować `break`, `continue`, `pass`,
  - pisać pętle `while` z bezpiecznym warunkiem stopu,
  - używać `range` i `zip` jako prostych iteratorów.

- **Budować bardziej „pythoniczny” kod**
  - pisać proste `list comprehension`,
  - korzystać z funkcji `input()` do pobierania danych od użytkownika,
  - przenieść te umiejętności później do pracy z `pandas` (filtrowanie, tworzenie nowych kolumn).

---

## 2. Dla kogo jest ten blok?

Ten blok jest dla Ciebie, jeśli:

- ukończyłeś(aś) **poprzedni blok Pythona** (typy danych, kolekcje),
- znasz podstawowe pojęcia:
  - zmienna, typ danych (`int`, `float`, `str`, `bool`),
  - proste kolekcje (`list`, `dict`, `tuple`, `set`),
  - potrafisz wykonać prosty kod w Pythonie w Jupyter Notebooku.

Nie musisz znać statystyki, machine learning ani SQL – ten blok buduje fundament pod późniejsze moduły (m.in. `pandas`, funkcje, ML).

---

## 3. Wymagania wstępne – wiedza i umiejętności

Przed tym blokiem dobrze, abyś:

- potrafił(a):
  - uruchomić Jupyter Notebook,
  - napisać i uruchomić prosty kod:
    - przypisanie zmiennej,
- rozumiał(a) pojęcia:
  - indeksowanie (pierwszy element ma indeks 0),
  - podstawowe typy w Pythonie (liczby, tekst, lista, słownik).

Jeżeli czujesz, że musisz to odświeżyć – przejrzyj notatki z poprzedniego bloku lub krótkie wprowadzenie, które przygotuje trener na początku tych zajęć.

---

## 4. Środowisko pracy – co potrzebujesz?

### 4.1. Python i Jupyter

Na potrzeby tego bloku używamy:

- Python **3.10 lub nowszy** (ze względu na `match-case`),
- Jupyter Notebook lub VS Code z rozszerzeniem Python.

Minimalne wymagane elementy:

- działająca komenda:
  - w Anaconda Prompt / terminalu:
    ~~~bash
    python --version
    ~~~
    (powinno pokazać wersję 3.10+),
- możliwość otwarcia notebooka:
  - `cwiczenia_clean.ipynb`.

Jeżeli korzystasz z Anacondy, najprościej:

1. Uruchom Anaconda Navigator.
2. Otwórz Jupyter Notebook albo VS Code.
3. W Jupyter:
   - przejdź do katalogu z materiałami na ten blok,
   - otwórz plik `cwiczenia_clean.ipynb`.

### 4.2. Biblioteki

W tym bloku używamy prawie wyłącznie **standardowej biblioteki Pythona** – nie jest wymagane dodatkowe instalowanie zewnętrznych pakietów.

---

## 5. Jakie dane będziemy wykorzystywać?

W trakcie bloku będziesz pracować na danych symulujących **prawdziwe dane biznesowe**. Przede wszystkim:

### 5.1. Dane `orders` – zamówienia w e-commerce

Lista/słownik opisujący zamówienia w sklepie internetowym, np.:

- `order_id` – numer zamówienia (int),
- `customer_id` – numer klienta (int),
- `country` – kraj klienta (str, np. `"PL"`, `"DE"`),
- `order_value` – wartość zamówienia (float),
- `payment_type` – typ płatności (str: `"card"`, `"blik"`, `"paypal"`, `"cod"`),
- `status` – status zamówienia (str: `"completed"`, `"cancelled"`, `"returned"`, `"pending"`),
- `is_first_order` – czy to pierwsze zamówienie klienta (bool),
- `discount_code` – kod rabatowy lub `None`, gdy brak.

Na tych danych będziemy:

- filtrować zamówienia (np. duże zamówienia, zamówienia z Polski),
- oznaczać zamówienia jako ryzykowne (np. wysoka wartość, pierwszy zakup, specyficzny kraj/płatność),
- tworzyć proste raporty (liczba zamówień, suma wartości itd.).

### 5.2. Dane `products` – listy produktów

Drugi, mniejszy zestaw, np.:

- `product_id` – identyfikator produktu (int),
- `category` – kategoria (str),
- `price` – cena produktu (float),
- `stock` – stan magazynowy (int).

Tutaj poćwiczysz m.in.:

- pętle po listach zagnieżdżonych,
- warunki (np. niskie stany magazynowe, produkty drogie/tanie).

### 5.3. Drobne listy pomocnicze

Typowe listy używane w logice biznesowej, np.:

- `blocked_countries` – lista krajów z podwyższonym ryzykiem,
- `high_risk_payment_types` – lista ryzykownych form płatności.

Na nich będziemy ćwiczyć:

- operator `in` / `not in`,
- warunki typu: „jeśli kraj jest na liście X, a wartość zamówienia > Y, to…”

Nie musisz samodzielnie tworzyć tych danych od zera – będą one przygotowane w notebooku. Twoim zadaniem będzie przede wszystkim **napisać logikę** (warunki, pętle) operującą na tych strukturach.

---

## 6. Jak wygląda praca na zajęciach?

Typowy rytm:

1. Trener pokazuje nowe pojęcie na prostym przykładzie (np. `if`, `for`).
2. Od razu dostajesz małe zadanie, aby to zastosować (np. przefiltruj zamówienia powyżej 500 zł).
3. Po kilku zadaniach łączymy je w mini-projekt (np. prosty raport z zamówień).

Ćwiczenia są ułożone tak, żeby:

- zaczynać od prostych operacji na małych listach,
- stopniowo przechodzić do bardziej „życiowych” przypadków (orders/products),
- zakończyć mini-projektem, który symuluje fragment realnej pracy data scientist.

---

## 7. Typowe wyzwania – na co uważać?

To są rzeczy, na których najczęściej można się „wywrócić” – dobrze, jeśli od razu będziesz na nie wyczulony(a):

1. **Mylisz `=` i `==`**
   - `=` służy do przypisania,
   - `==` służy do porównania.

2. **`==` vs `is`**
   - `==` – sprawdza, czy wartości są równe,
   - `is` – sprawdza, czy to dokładnie ten sam obiekt w pamięci.
   - Do porównania z `None` używamy: `if x is None:`.

3. **Wcięcia w kodzie**
   - Python używa wcięć do określania struktury kodu.
   - Błąd wcięcia = błąd składni, ale też gorsza czytelność.

4. **Pętla `while` bez końca**
   - Pamiętaj o warunku, który kiedyś stanie się `False`,
   - Upewnij się, że wewnątrz pętli coś zmienia się w stronę zakończenia.

5. **Mieszanie typów w porównaniach**
   - Porównujesz np. `str` do `int` – to się kończy błędem.
   - W razie wątpliwości jawnie konwertuj typ: `int(...)`, `float(...)`, `str(...)`.

6. **Zbyt szybkie wejście w list comprehension**
   - Najpierw napisz zwykłą pętlę `for`,
   - dopiero potem zamień ją na `[...]` (comprehension).

Na zajęciach będziemy wracać do tych tematów wiele razy – to normalne, że na początku jest zamieszanie. To jest fundament – warto, żeby był mocny.

---

## 8. Zadanie domowe (dla chętnych)

Zadanie domowe będzie rozwinięciem mini-projektu z końca dnia.

Przykładowa wersja:

1. **Rozbuduj prosty „raport zamówień”**
   - dodaj kolejne wskaźniki, np.:
     - liczba pierwszych zamówień,
     - udział zamówień anulowanych/procent zwrotów,
     - średnia wartość zamówienia w Polsce vs poza Polską.

2. **Dodaj więcej tagów do zamówień**
   - np. `VERY_HIGH_VALUE`, `LOW_MARGIN`, `LOYAL_CUSTOMER` itd.
   - zastosuj zagnieżdżone `if` albo `match-case`.

3. **(Opcjonalnie) Zrób prosty interfejs tekstowy**
   - użyj `input()`:
     - użytkownik wpisuje kraj / minimalną wartość zamówienia,
     - skrypt wypisuje pasujące zamówienia.

Zadanie domowe ma dwa cele:

- utrwalić składnię (`if`, `for`, `while`, `list comprehension`),
- pokazać Ci, że możesz realnie „pobrudzić ręce” danymi, nawet bez zaawansowanych bibliotek.

---

## 9. Jak ten blok pomoże Ci dalej w kursie?

To, czego nauczysz się w tym bloku, będzie później potrzebne:

- **W funkcjach Pythona** (kolejny blok):
  - będziesz pisać funkcje, które wewnątrz używają warunków i pętli,
  - logika biznesowa (np. scoring klientów) często jest kombinacją `if` + pętli.

- **W `pandas` i analizie danych:**
  - wiele operacji na kolumnach `DataFrame` to w gruncie rzeczy warunki i pętle, tylko „opakowane” w bibliotekę,
  - łatwiej jest zrozumieć zaawansowane funkcje, gdy rozumiesz, co się dzieje „pod spodem”.

- **W machine learning:**
  - przygotowanie danych (feature engineering, czyszczenie, filtrowanie) w dużej mierze opiera się na logice, którą dziś poznasz.

Krótko mówiąc: to jest „język”, w którym będziesz rozmawiać z danymi.

---

## 10. Jak się przygotować na zajęcia?

Przed zajęciami warto:

1. Upewnić się, że środowisko działa (Python + Jupyter).
2. Otworzyć choć jeden prosty notebook i uruchomić komórkę z:
   ~~~python
   a = 2
   b = 3
   a + b
   ~~~
3. Przypomnieć sobie:
   - jak tworzyć listę (`[1, 2, 3]`),
   - jak wyświetlić jej długość (`len(lista)`).

Jeżeli tego nie zrobisz – nic strasznego, ale pierwsze 30–40 minut może być dla Ciebie intensywniejsze. Lepiej wejść w blok z rozgrzaną głową :)

---

## 11. FAQ (często zadawane pytania)

**Czy muszę znać matematykę, żeby ogarnąć ten blok?**  
Nie. Skupiamy się na logice programowania, nie na wzorach matematycznych.

**Czy można popełniać błędy?**  
Tak, i będziesz je popełniać. Błędy to norma, ważne jest nauczyć się je czytać i poprawiać.

---

Traktuj ten blok jak „warsztat logicznego myślenia w Pythonie”.  
Im więcej kodu napiszesz samodzielnie, tym pewniej poczujesz się w kolejnych modułach kursu.