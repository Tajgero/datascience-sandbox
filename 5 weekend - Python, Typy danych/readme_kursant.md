# Blok 5: Python - typy danych i operacje na nich

Czas trwania: 8 godzin  
Poziom: 1 (start od zera)  

---

## 1. O czym jest ten blok?

To jest **Twój pierwszy „pełny” dzień z Pythonem**.  
Po tym bloku masz czuć się swobodnie z:

- uruchamianiem Pythona w dystrybucji **Anaconda** (Jupyter Notebook, VS Code),
- podstawowymi typami danych (liczby, tekst, listy, zbiory, słowniki),
- wykonywaniem prostych obliczeń,
- prostą „zabawą danymi” – np. listą klientów, koszykiem zakupowym, cenami produktów.

Świadomie **nie** dotykamy jeszcze instrukcji warunkowych (`if`) ani pętli (`for`, `while`) – to będzie temat kolejnego bloku. Tu budujemy fundament: jak Python przechowuje dane i co możemy z nimi zrobić.

---

## 2. Po tym bloku będziesz umieć…

### 2.1. Środowisko i narzędzia

- Uruchomić Pythona z dystrybucji **Anaconda**:
  - otworzyć i zapisać notatnik **Jupyter Notebook / JupyterLab**,
  - uruchomić plik `.py` w **Visual Studio Code**.
- Rozumieć podstawowe pojęcia:
  - czym jest **interpreter Pythona**,
  - co to jest **maszyna wirtualna Pythona** (na poziomie intuicji),
  - co oznacza **linting** i dlaczego pomaga pisać czytelny kod.
- Stosować kilka prostych zasad **PEP8** (konwencje pisania kodu w Pythonie).

### 2.2. Składnia i komentarze

- Zdefiniować zmienne (np. `price`, `customer_name`).
- Dodawać komentarze do kodu:
  - komentarze jednolinijkowe `#`,
  - komentarze „blokowe” (kilka linii tekstu).
- Rozumieć pojęcia:
  - **obiekt**, **typ**, **indeks**, **znak ucieczki** w stringach.

### 2.3. Typy proste i operatory

- Pracować z typami:
  - `None` – brak wartości / brak danych,
  - `int` – liczby całkowite,
  - `float` – liczby zmiennoprzecinkowe (np. 9.99),
  - `bool` – wartości logiczne `True` / `False`.
- Korzystać z operatorów arytmetycznych:
  - `+`, `-`, `*`, `/` (dzielenie),
  - `//` (dzielenie całkowite),
  - `%` (reszta z dzielenia),
  - `**` (potęgowanie).

### 2.4. Stringi (tekst)

- Tworzyć stringi (napisy) i łączyć je ze sobą.
- Używać podstawowych funkcji i metod:
  - `len()` – długość tekstu,
  - `upper()`, `lower()` – zmiana wielkości liter,
  - `replace()` – podmiana fragmentu tekstu,
  - `split()` – rozbijanie tekstu na listę elementów,
  - `format()` i (opcjonalnie) f-stringi do formatowania tekstu.
- Rozumieć **znaki specjalne** i **znaki ucieczki**: `\n`, `\t`, `\"`, `\\`.

### 2.5. Kolekcje: tuple, list, set, dict

- **Tuple**:
  - rozumieć, czym jest niemodyfikowalna sekwencja,
  - wykonywać proste pakowanie i rozpakowanie:
    - `x, y = (10, 20)`.
- **List**:
  - tworzyć listy (np. listę produktów, listę cen),
  - używać metod: `append()`, `insert()`, `remove()`, `pop()`, `index()`, `count()`, `sort()`, `extend()`,
  - korzystać z `range()` do generowania prostych sekwencji liczb,
  - rozumieć różnicę między:
    - przypisaniem (`lista_b = lista_a`) a
    - kopią (`lista_b = lista_a.copy()`),
  - wiedzieć, co to jest płytka kopia vs głęboka kopia (na prostych przykładach).
- **Set (zbiór)**:
  - tworzyć zbiory, usuwać duplikaty z listy,
  - dodawać i usuwać elementy (`add()`, `remove()`),
  - sprawdzać przynależność elementu (`in`),
  - wykonywać operacje:
    - suma zbiorów,
    - przecięcie,
    - różnica.
- **Dict (słownik)**:
  - tworzyć słownik jako pary klucz–wartość, np. `customer_id -> total_spent`,
  - dodawać nowe elementy,
  - pobierać wartości,
  - aktualizować istniejące wartości,
  - usuwać elementy,
  - używać `get()` i `update()`,
  - iterować po elementach (pokazowo).

---

## 3. Wymagania wstępne

Żeby komfortowo pracować na tym bloku, potrzebujesz:

1. **Zainstalowaną Anacondę**:
   - aktualna wersja (nie musi być najnowsza, ale nie bardzo stara),
   - w trakcie bloku będziemy korzystać głównie z:
     - Anaconda Navigator,
     - Jupyter Notebook / JupyterLab.

2. **Zainstalowany Visual Studio Code**:
   - zainstalowane rozszerzenie **Python** (instrukcja poniżej),
   - podstawowa umiejętność:
     - otwarcia folderu projektu,
     - utworzenia nowego pliku.

3. **Podstawowa obsługa komputera**:
   - praca na plikach i folderach,
   - kopiowanie/klejenie,
   - minimalna orientacja w systemie (Windows/macOS).

**Nie** wymagamy wcześniejszej znajomości Pythona ani żadnego innego języka programowania.

---

## 4. Jak się przygotować przed zajęciami (checklista)

1. Sprawdź, czy **Anaconda** jest zainstalowana:
   - spróbuj uruchomić **Anaconda Navigator**,
   - jeśli się nie uruchamia – zainstaluj ponownie lub daj znać organizatorowi.

2. Sprawdź, czy masz **Visual Studio Code**:
   - uruchom VS Code,
   - jeśli nie masz – zainstaluj ze strony producenta.

3. Zainstaluj rozszerzenie **Python** w VS Code:
   - w VS Code kliknij ikonę rozszerzeń (Extensions),
   - wyszukaj „Python” (Microsoft),
   - kliknij „Install”.

4. Przygotuj sobie **folder na materiały z kursu**, np.:
   - `D:\kurs_data_science\python\blok5`  
     (nazwa i lokalizacja dowolna, byle łatwo znaleźć).

---

## 5. Jak będziemy pracować na zajęciach?

### 5.1. Tryb pracy

- Przez większość czasu będziemy:
  - pisać kod na żywo w **Jupyter Notebook**,
  - wykonywać ćwiczenia krok po kroku według notatnika `cwiczenia_clean.ipynb`.
- Trener będzie:
  - pokazywać rozwiązania na żywo,
  - tłumaczyć błędy i jak je czytać,
  - zatrzymywać się w trudniejszych momentach, żeby odpowiedzieć na pytania.

### 5.2. Dwa typy notatników

- `cwiczenia_clean.ipynb` – notatnik z treścią zadań i szkicami kodu, który wypełniasz na zajęciach.
- `cwiczenia_solved.ipynb` – notatnik z gotowymi rozwiązaniami krok po kroku (do samodzielnego przestudiowania po bloku, nie jako „ściąga na żywo”).

---

## 6. Krótki opis danych, na których będziemy ćwiczyć

Na tym bloku **nie używamy „ciężkich” plików z danymi**. Zamiast tego:

- tworzymy własne małe struktury w Pythonie, które **imitują dane biznesowe**, np.:

1. **Dane e-commerce**:
   - lista produktów: nazwa, kategoria, cena,
   - przykładowe nazwy zmiennych:
     - `products = ["Laptop", "Mouse", "Keyboard", "Mouse"]`,
     - `prices = [3500.0, 80.0, 150.0, 80.0]`,
   - słownik mapujący produkt → cena:
     - `product_to_price = {"Laptop": 3500.0, "Mouse": 80.0, "Keyboard": 150.0}`.

2. **Dane klientów**:
   - lista identyfikatorów klientów:
     - `customer_ids = [1001, 1002, 1003, 1001]`,
   - zbiór unikalnych klientów:
     - `unique_customers = {1001, 1002, 1003}`,
   - słownik: `customer_id -> total_spent`:
     - `customer_spent = {1001: 4300.0, 1002: 80.0, 1003: 150.0}`.

Te struktury pozwolą nam ćwiczyć:

- dodawanie/aktualizację elementów,
- usuwanie duplikatów,
- proste obliczenia (średnia cena, suma koszyka).

---

## 7. Plan dnia

Może się minimalnie różnić w zależności od tempa, ale ogólny plan wygląda tak:

1. **Wprowadzenie i środowisko (ok. 1,5h)**
   - rola Pythona w data science i AI,
   - uruchamianie Anacondy i Jupyter Notebook,
   - Jupyter vs VS Code – kiedy co używać,
   - podstawy PEP8 i lintingu,
   - komentarze, pierwsze zmienne.

2. **Typy proste: None, int, float, bool + operatory (ok. 1,5h)**
   - zmienne jako etykiety na obiektach,
   - typ `None` – brak danych,
   - liczby i obliczenia (na przykładach z biznesu),
   - operatory arytmetyczne.

3. **Stringi i sekwencje (ok. 1,5h)**
   - praca z tekstem: długość, łączenie, zamiana fragmentów,
   - znaki specjalne i ucieczki,
   - tuple i listy: różnice, indeksowanie,
   - operacje na listach, sortowanie, kopiowanie.

4. **Set, dict i podsumowanie (ok. 1,5h)**
   - zbiór: unikalne wartości, operacje zbiorowe,
   - słownik: mapowanie klucz–wartość,
   - ćwiczenia mini-analityczne (np. „baza” klientów i produktów).

Pomiędzy segmentami są przerwy – to dobry moment, żeby odetchnąć, ale też zadać trenerowi pytanie indywidualnie.

---

## 8. Przykłady kodu, które zobaczysz

Kilka typowych mini-fragmentów kodu (podobne zobaczysz na zajęciach):

### 8.1. Prosta zmienna i komentarz

~~~python
# Cena jednego produktu w złotówkach
product_price = 99.99

# Obliczenie ceny po rabacie 10%
discounted_price = product_price * 0.9
print(discounted_price)
~~~

### 8.2. Lista produktów i usunięcie duplikatów

~~~python
# Lista produktów z duplikatami
products = ["Laptop", "Mouse", "Keyboard", "Mouse", "Mouse"]

# Zamiana listy na zbiór usuwa duplikaty
unique_products = set(products)

print("Wszystkie produkty:", products)
print("Unikalne produkty:", unique_products)
~~~

### 8.3. Słownik klient → suma zakupów

~~~python
# Słownik przechowujący sumę zakupów klientów
customer_spent = {
    1001: 4300.0,
    1002:  80.0,
    1003: 150.0
}

# Pobranie wartości z bezpiecznym get()
customer_id = 1004
spent = customer_spent.get(customer_id, 0.0)

print("Klient:", customer_id)
print("Wartość zakupów:", spent)
~~~

---

## 9. Zadanie domowe (dla chętnych)

Zadanie domowe ma pomóc utrwalić materiał. Nie jest sprawdzane „egzaminacyjnie”, ale mocno polecamy je wykonać.

### 9.1. Opis

W notatniku (Jupyter) przygotuj mini-model danych dla prostego sklepu internetowego:

1. Stwórz listę produktów z przypisanymi cenami, np.:
   - `products = ["Laptop", "Mouse", "Keyboard"]`,
   - `prices = [3500.0, 80.0, 150.0]`.

2. Stwórz:
   - zbiór kategorii (np. `electronics`, `accessories`),
   - słownik: `category -> lista produktów`, np.:
     - `"electronics": ["Laptop"]`,
     - `"accessories": ["Mouse", "Keyboard"]`.

3. Dodaj do tej struktury **nowy produkt** (np. „Monitor”) – zaktualizuj:
   - listę produktów,
   - listę cen,
   - słownik kategorii.

4. Na koniec:
   - policz (ręcznie, bez pętli):
     - średnią cenę wszystkich produktów,
     - średnią cenę w każdej kategorii (możesz użyć kilku linii kodu, powtarzając podobne obliczenia).

### 9.2. Co warto przećwiczyć przy okazji?

- korzystanie z `len()`,
- podstawowej arytmetyki,
- operacji na listach (dodawanie elementów),
- operacji na słownikach (dodawanie/aktualizacja wartości).

---

## 10. Praktyczne wskazówki na start

1. **Nie bój się błędów**  
   Błędy są normalne. Nauczysz się czytać komunikaty – trener będzie je tłumaczył.

2. **Używaj `print()` i `type()`**  
   Jeśli coś jest niejasne:
   - wypisz wartość zmiennej za pomocą `print()`,
   - sprawdź jej typ `type(variable)`.

3. **Na początku pisz wolniej, ale czytelnie**  
   Zamiast jednej „magicznej” linii – kilka prostych linii z dobrymi nazwami zmiennych.  
   Łatwiej to potem zrozumieć Tobie (i innym).

4. **Rób własne mini-notatki**  
   Spisuj:
   - typowe pułapki (np. „indeks zaczyna się od 0!”),
   - przykłady, które Ci pomogły coś zrozumieć.

5. **Pytaj, jeśli coś jest niejasne**  
   Serio – nie ma „głupich pytań”. Jeśli Ty masz wątpliwość, prawdopodobnie ktoś inny też.

---

## 11. Jak ten blok przyda Ci się dalej?

W kolejnych blokach będziemy:

- czytać dane z plików (CSV, Excel),
- przetwarzać dane w bibliotece **pandas**,
- budować modele uczenia maszynowego,
- korzystać z modeli AI.

Bez solidnego zrozumienia:

- czym jest **lista**, **słownik**, **zbiór**,
- jak działają podstawowe operacje na liczbach i stringach,

praca z tymi narzędziami będzie dużo trudniejsza. Ten blok jest właśnie po to, żeby:

- nauczyć Cię „myślenia w Pythonie”,
- dać poczucie, że **masz kontrolę** nad tym, jak dane są reprezentowane w kodzie.

---

## 12. Podsumowanie – czego oczekujemy po bloku

Po zakończeniu zajęć zakładamy, że:

- samodzielnie uruchomisz Jupyter z Anacondy,
- napiszesz prosty notatnik z obliczeniami i listami/słownikami,
- rozpoznasz typ wartości (`int`, `float`, `str`, `list`, `dict`, `set`),
- będziesz w stanie:
  - stworzyć listę,
  - dodać/usunąć element,
  - posortować listę,
  - usunąć duplikaty z listy (przez `set`),
  - stworzyć prosty słownik i pobrać z niego wartość.

Reszta – warunki, pętle, funkcje, biblioteki do danych – przyjdzie w kolejnych blokach.  
Tutaj budujemy solidną, spokojną bazę.