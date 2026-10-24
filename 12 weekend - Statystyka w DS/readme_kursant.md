# Blok 13: Statystyka w Data Science

## 1. O czym jest ten blok?

To jest **jedyny blok o statystyce** na kursie „Data Science + AI”.

Cel: pokazać Ci **praktyczną statystykę**, taką jakiej faktycznie używa się:
- w analizie danych,
- w projektach Machine Learning,
- w A/B testach, raportach i prezentacjach dla biznesu.

Nie zakładamy wcześniejszej znajomości:
- statystyki,
- rachunku prawdopodobieństwa,
- „matematyki wyższej”.

Zakładamy tylko, że:
- potrafisz pisać podstawowy kod w Pythonie,
- znasz `numpy`, `pandas`, `matplotlib`, `seaborn` na poziomie z wcześniejszych bloków.

Będziemy:
- tłumaczyć pojęcia prostym językiem,
- od razu sprawdzać wszystko w Pythonie,
- pracować na **syntetycznych, ale biznesowo sensownych danych**.

---

## 2. Co będziesz umieć po tym bloku?

Po tym bloku będziesz w stanie:

### Prawdopodobieństwo i zdarzenia
- wyjaśnić, czym jest **eksperyment losowy** i **zdarzenie** (np. „użytkownik kliknął maila”),
- policzyć proste prawdopodobieństwa (np. szansa na kliknięcie, fraud, rezygnację klienta),
- zrozumieć operacje na zdarzeniach:
  - „A albo B” (suma),
  - „A i B jednocześnie” (iloczyn),
  - „nie A” (dopełnienie).

### Prawdopodobieństwo warunkowe i Bayes
- policzyć **prawdopodobieństwo warunkowe** P(A|B), np.:
  - „jaka jest szansa, że transakcja jest fraudem, jeśli kwota > 1000?”,
- zinterpretować **Twierdzenie Bayesa** na prostych przykładach:
  - testy medyczne,
  - fraud detection,
  - przewidywanie zachowania użytkowników.

### Zmienne losowe i rozkłady
- wytłumaczyć, czym jest **zmienna losowa** (np. „liczba kliknięć”, „wartość koszyka”),
- policzyć podstawowe **parametry** w `pandas`:
  - `mean`, `median`, `mode`, `var`, `std`,
- rozpoznać i intuicyjnie opisać kilka ważnych rozkładów:
  - Bernoulli, dwumianowy, Poissona,
  - rozkład jednostajny,
  - rozkład normalny,
  - rozkład wykładniczy.

### Estymacja i testy statystyczne
- wyjaśnić, czym jest **estymacja parametru** (np. średniej lub proporcji),
- zrozumieć pojęcia:
  - hipoteza zerowa H0 i alternatywna H1,
  - statystyka testowa,
  - **p-wartość**,
  - błąd I i II rodzaju,
- przeprowadzić w Pythonie i zinterpretować:
  - **test t-Studenta** (porównanie dwóch średnich, np. group A vs group B),
  - **test chi-kwadrat** (zależność między kategoriami, np. kanał pozyskania vs konwersja),
  - **test Kolmogorova-Smirnova** (porównanie rozkładów).

### W kontekście Data Science / ML
- wykorzystać te pojęcia w:
  - A/B testach,
  - analizie różnic pomiędzy grupami użytkowników,
  - sanity-check danych wejściowych do modelu ML,
- lepiej rozumieć raporty z testów i analizy danych.

---

## 3. Wymagania wstępne (co warto umieć przed blokiem)

Żeby czuć się komfortowo na zajęciach, potrzebujesz:

### Python
- podstawowe konstrukcje:
  - zmienne, pętle `for`, instrukcje `if`,
  - listy, słowniki, funkcje,
- umiejętność uruchamiania notebooków Jupyter.

### Biblioteki
- `numpy` – tablice, proste operacje na wektorach/macierach,
- `pandas` – DataFrame, podstawowe operacje:
  - `head`, `info`, `describe`,
  - filtrowanie (`df[df["col"] > 10]`),
  - `groupby`, `agg`, `mean`, `count`,
- `matplotlib` / `seaborn` – proste wykresy:
  - histogram (`plt.hist` lub `sns.histplot`),
  - wykres słupkowy (barplot),
  - wykres pudełkowy (boxplot).

Jeśli nie czujesz się pewnie, zajrzyj wcześniej do materiałów z modułu Python.

---

## 4. Środowisko i instalacja

### Co będziemy używać?

- Python 3.10+,
- Jupyter Notebook lub VS Code z rozszerzeniem do notebooków,
- biblioteki:
  - `numpy`,
  - `pandas`,
  - `matplotlib`,
  - `seaborn`,
  - `scipy` (głównie `scipy.stats`).

### Minimalny setup (np. w wirtualnym środowisku)

Jeśli masz zainstalowanego Pythona i `pip`, możesz przygotować środowisko np. tak:

#### 1. Utworzenie wirtualnego środowiska (opcjonalne, ale zalecane)

Na Windows:
~~~bash
python -m venv venv
venv\Scripts\activate
~~~

Na macOS / Linux:
~~~bash
python3 -m venv venv
source venv/bin/activate
~~~

#### 2. Instalacja bibliotek

~~~bash
pip install numpy pandas matplotlib seaborn scipy jupyter
~~~

#### 3. Uruchomienie Jupyter Notebook

~~~bash
jupyter notebook
~~~

Lub jeśli używasz VS Code – wystarczy otworzyć plik `.ipynb` i wybrać kernel z Twojego środowiska.

---

## 5. Jakie dane będziemy wykorzystywać?

W tym bloku:
- **nie ściągamy żadnych zewnętrznych plików**, 
- wszystkie dane generujemy w kodzie (z Pythonowych słowników, list, itp.),
- dane są **syntetyczne** (wymyślone), ale zbudowane tak, aby przypominały prawdziwe przypadki biznesowe.

Przykładowe scenariusze:

### 1. E-commerce – zamówienia
- Każdy rekord to coś w stylu:
  - `{"order_id": 123, "user_id": 45, "value": 199.99, "channel": "ads", "is_returned": False}`
- Co analizujemy:
  - rozkład wartości koszyka,
  - prawdopodobieństwo zwrotu,
  - porównanie kanałów (np. `ads` vs `seo`).

### 2. Marketing – A/B test kampanii
- Dane np.:
  - `{"user_id": 101, "group": "A", "clicked": 1, "converted": 0}`
- Co analizujemy:
  - różnica w CTR / CR pomiędzy grupami A i B,
  - czy ta różnica jest statystycznie istotna (test t, test proporcji / przybliżenia).

### 3. Fraud detection – transakcje
- Dane np.:
  - `{"tx_id": 999, "amount": 1200.50, "is_fraud": 1, "hour": 2}`
- Co analizujemy:
  - prawdopodobieństwo fraudu,
  - związek pomiędzy kwotą a fraudem,
  - przykład Twierdzenia Bayesa.

### 4. HR / People analytics – rotacja pracowników
- Dane np.:
  - `{"employee_id": 17, "team": "Sales", "tenure_months": 14, "left": 0}`
- Co analizujemy:
  - rozkład czasu do odejścia z firmy,
  - porównanie zespołów.

Wszystko jest wbudowane w notebooki – nie musisz przygotowywać dodatkowych plików CSV przed zajęciami.

---

## 6. Struktura materiałów dla Ciebie

W ramach tego bloku dostajesz:

1. **`readme_kursant.md`** – ten plik (opis bloku i wskazówki).
2. **`teoria.md`** – kompendium pojęć:
   - krótkie definicje,
   - proste przykłady,
   - „intuicyjne wyjaśnienia” bez ciężkiej matematyki.
3. **`cwiczenia_clean.ipynb`** – główny notebook ćwiczeniowy:
   - zestaw zadań bez rozwiązań,
   - komentarze `# TODO` z sugestiami, co napisać,
   - miejsce na własne eksperymenty.
4. **`cwiczenia_solved.ipynb`** – notebook z gotowymi rozwiązaniami:
   - krok po kroku,
   - z komentarzami po polsku,
   - możesz do niego zajrzeć po zrobieniu zadania lub gdy się zatniesz.

Rekomendowany sposób pracy:
- podczas zajęć – pracuj głównie w `cwiczenia_clean.ipynb`,
- po zajęciach – przejdź samodzielnie jeszcze raz przez wybrane zadania, porównując z `cwiczenia_solved.ipynb`.

---

## 7. Jak wygląda typowe zadanie?

Każde zadanie ma:
- krótki **opis biznesowy** (np. „analizujemy A/B test landing page’y”),
- **cel techniczny** (np. „policz i porównaj średnią wartość koszyka”),
- poziom trudności, szacowany czas,
- 1–3 **wskazówki** (podpowiedzi),
- miejsce w kodzie zaznaczone jako:
  - `# TODO: ...` albo
  - pusty blok kodu do wypełnienia.

Przykład fragmentu ćwiczenia (styl):

~~~python
# Mamy dane o kliknięciach w kampanii A/B:
# - column "group": "A" albo "B"
# - column "clicked": 0 lub 1 (czy użytkownik kliknął maila)
# 1. Policz CTR (click-through rate) osobno dla grup A i B.
# 2. Sprawdź, która grupa ma wyższy CTR.
# 3. Zrob prosty wykres słupkowy CTR dla obu grup.

# TODO: policz CTR dla A i B
ctr_by_group = (
    df_ab
    .groupby("group")["clicked"]
    .mean()
)

# TODO: wyswietl CTR
print(ctr_by_group)

# TODO: narysuj wykres slupkowy
~~~

---

## 8. Zadanie domowe (dla chętnych)

Zadanie domowe jest **dobrowolne**, ale bardzo pomaga utrwalić materiał.

W skrócie:
1. Wymyśl **własny mini-case** (np. A/B test, dwie grupy użytkowników, dwa okresy w sklepie).
2. Wygeneruj syntetyczne dane w Pythonie (np. listy słowników, potem `DataFrame`).
3. Zrób:
   - podstawowe statystyki opisowe (mean, median, std),
   - przynajmniej **jeden test t**,
   - przynajmniej **jeden test chi-kwadrat**.
4. Napisz krótki raport (3–5 akapitów), w którym:
   - opiszesz dane i pytanie biznesowe,
   - pokażesz wyniki,
   - zinterpretujesz je w zrozumiały sposób („co byś zrobił jako osoba decyzyjna”).

Szczegóły i propozycję układu raportu znajdziesz w opisie zadania domowego w materiałach.

---

## 9. Jak najlepiej przygotować się do zajęć?

Przed blokiem warto:

1. Odświeżyć:
   - podstawy Pythona,
   - `pandas` (głównie `groupby`, `agg`, `mean`, `count`),
   - wykresy w `matplotlib`/`seaborn`.

2. Zainstalować / sprawdzić środowisko:
   - uruchom Jupyter,
   - otwórz dowolny notebook,
   - importuj biblioteki:

   ~~~python
   import numpy as np
   import pandas as pd
   import matplotlib.pyplot as plt
   import seaborn as sns
   from scipy import stats
   ~~~

   Jeśli wszystko działa bez błędów – jesteś gotowy.

---

## 10. Kilka praktycznych wskazówek

- **Nie bój się pytań.**  
  Statystyka bywa źle tłumaczona na studiach – tutaj celem jest zrozumienie, nie „zaliczenie egzaminu”.

- **Patrz na liczby, nie tylko na wzory.**  
  Jeśli coś jest niejasne – popatrz na prosty przykład z małymi liczbami, rozpisany w tabeli.

- **Myśl biznesowo.**  
  Za każdym razem pytaj siebie: „co te wyniki znaczą dla:
  - produktu,
  - marketingu,
  - sprzedaży,
  - fraud teamu?”

- **P-wartość to nie święty graal.**  
  Podczas bloku wiele razy powiemy:
  - p-wartość pomaga w decyzji,
  - ale trzeba też patrzeć na wielkość efektu i kontekst.

- **Zachowaj notebooki na później.**  
  W kolejnych blokach ML te przykłady będą dobrym „ściągaczem”:
  - dla A/B testów,
  - dla sanity-check danych,
  - przy analizie wyników modeli.

---

## 11. Podsumowanie

Ten blok jest pomyślany jako:
- **praktyczne wprowadzenie** do statystyki w Data Science,
- z minimum formalnej matematyki,
- z naciskiem na:
  - zrozumienie pojęć,
  - umiejętność użycia ich w Pythonie,
  - interpretację wyników w kontekście biznesowym.

Naszym celem jest, żebyś po zajęciach:
- nie bał/a się słów „prawdopodobieństwo”, „rozkład”, „p-wartość”, „test t”,
- wiedział/a, jak przełożyć statystykę na realne decyzje w projekcie,
- był/a lepiej przygotowany/a do modułu Machine Learning i projektu końcowego.

Do zobaczenia na zajęciach! 🙂