# Blok 9: Python – Praca z danymi (analiza i wizualizacja)

W tym bloku wchodzimy w „codzienność” data scientist: wczytujesz dane, szybko oceniasz ich jakość, robisz EDA (exploratory data analysis), czyścisz/porządkujesz dataset i tworzysz czytelne wykresy oraz wnioski. Pracujemy na realnym zbiorze danych o sprzedaży gier wideo.

## Po tym bloku będziesz umieć
- Wczytać dane z pliku CSV i zrobić szybki przegląd jakości danych (`head/info/describe`).
- Sprawdzić braki, duplikaty i typy danych oraz podjąć decyzje „co z tym zrobić”.
- Wykonać podstawowe EDA: agregacje, segmentacje, tabele przestawne, proste korelacje.
- W pandas: wybierać kolumny/wiersze (`loc/iloc`), filtrować, sortować, tworzyć nowe kolumny, usuwać/zmieniać nazwy kolumn.
- Łączyć dane (`merge`) oraz budować proste podsumowania do raportu.
- Zrobić sensowne wizualizacje w matplotlib (opcjonalnie: seaborn) i opisać wnioski.
- Zobaczyć alternatywę: polars (intro) i zrozumieć, kiedy ma sens.

## Wymagania wstępne
- Podstawowa składnia Pythona (zmienne, listy/dict, pętle, funkcje).
- Umiejętność instalacji bibliotek i pracy w Jupyter/VS Code.
- Podstawy importów (`import ... as ...`).

## Środowisko pracy
Rekomendowane:
- VS Code + rozszerzenie Jupyter
- Python 3.10+

Biblioteki:
- numpy
- pandas
- matplotlib
- seaborn (opcjonalnie)
- polars

Instalacja:
~~~bash
pip install numpy pandas matplotlib seaborn polars
~~~

Jeśli używasz venv:
~~~bash
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate
pip install -r requirements.txt  # jeśli dostaniesz plik
~~~

## Dane do ćwiczeń (główny dataset)
Plik: `vgsales_clean.csv`

**Kontekst biznesowy:** rynek gier wideo – które platformy/gatunki/wydawcy dominują i jak rozkłada się sprzedaż w regionach.

**Kolumny (skrót):**
- `Rank` – ranking sprzedaży globalnej (1 = największa)
- `Name` – nazwa gry
- `Platform` – platforma (np. Wii, PS4)
- `Year` – rok wydania
- `Genre` – gatunek
- `Publisher` – wydawca
- `NA_Sales`, `EU_Sales`, `JP_Sales`, `Other_Sales` – sprzedaż regionalna (mln)
- `Global_Sales` – sprzedaż globalna (mln)

W tym bloku zakładamy nawyk: nawet jeśli plik nazywa się „clean”, **i tak** sprawdzasz braki/typy/duplikaty/spójność.

## Jak pracujemy na zajęciach (workflow)
1) **Import i szybki przegląd**
- `df.head()`, `df.info()`, `df.describe()`

2) **EDA (zanim cokolwiek „naprawiasz”)**
- pytania biznesowe: „co jest top?”, „czy regiony różnią się preferencjami?”, „jak zmienia się sprzedaż w czasie?”

3) **Czyszczenie i porządkowanie**
- braki danych, typy, duplikaty, sanity check (np. czy Global ≈ suma regionów)

4) **Wizualizacja i wnioski**
- wykres ma być czytelny: tytuł, osie, jednostki, jedna myśl na wykres

## Pliki, na których pracujesz
- `teoria.md` – krótkie kompendium (NumPy/pandas/wizualizacje + pułapki)
- `cwiczenia_clean.ipynb` – zadania z TODO i szkieletem
- `cwiczenia_solved.ipynb` – te same zadania, ale z rozwiązaniami krok po kroku

## Zasady pracy (żeby było jak w realnej robocie)
- Zanim liczysz/rysujesz: sprawdź `shape`, typy, braki, duplikaty.
- Zanim wyciągniesz wniosek: upewnij się, że liczby mają sens (sanity checks).
- Unikaj pętli do rzeczy, które da się zrobić wektoryzacyjnie / `groupby`.
- Każdy wykres podpisz: tytuł + oś X/Y + jednostki (tu: mln sztuk).

## Mini-checklista (do odpalania za każdym razem)
- Czy wczytałem dane i wiem, ile jest wierszy/kolumn?
- Czy wiem, które kolumny są numeryczne i czy mają braki?
- Czy sprawdziłem duplikaty (przynajmniej po sensownym kluczu)?
- Czy mam 2–3 agregacje (`groupby`) i 2–3 wykresy, które odpowiadają na pytania biznesowe?
- Czy potrafię opisać wnioski w 3–5 zdaniach?

## Zadanie domowe (dla chętnych, 60–90 min)
Zrób „mini-raport” (notebook lub markdown) na podstawie `vgsales_clean.csv`:
1) Top 10 platform i ich udział w sprzedaży globalnej.
2) Porównanie preferencji regionów: NA vs EU vs JP (np. top 5 gatunków w każdym regionie).
3) Trend sprzedaży w czasie (sprzedaż globalna per rok) + komentarz.
4) 2 sanity checks (np. spójność sum regionów, kontrola typów Year, duplikaty po Name+Platform+Year).

Wynik: 2–4 wykresy + krótkie wnioski.

## Najczęstsze problemy (i co robić)
- **KeyError (brak kolumny):** sprawdź `df.columns` i literówki.
- **SettingWithCopyWarning:** użyj `.loc[...] = ...` albo zrób `df = df.copy()` po filtrowaniu.
- **Dziwne typy (np. liczby jako tekst):** `pd.to_numeric(..., errors="coerce")`, potem kontrola braków.
- **Merge „rozdmuchał” liczbę wierszy:** sprawdź duplikaty w kluczach i typy kluczy.

Powodzenia — po tym bloku zaczynasz myśleć jak osoba pracująca z danymi, a nie „pisząca kod” 🙂