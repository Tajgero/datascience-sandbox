# Blok 10: Praktyczna analiza danych z wykorzystaniem Pythona

## Po co ten blok?
W poprzednich blokach nauczyłeś/aś się robić analizę danych w Pandasie. Teraz robimy krok „do pracy”: **wizualizacje + storytelling + raport**, czyli dowozimy wynik analizy w formie, którą da się wysłać do biznesu.

Będziemy pracować na realnych danych i zrobimy mini-projekt: notebook + wykresy + eksport do HTML/Excel (a opcjonalnie też prosty raport HTML/PDF).

---

## Po tym bloku będziesz umieć…
- dobrać typ wykresu do pytania (czas, kategorie, rozkłady, zależności),
- zrobić czytelne wykresy w **Matplotlib** i **Seaborn** (podpisy, skale, kolejność, agregacje),
- zrobić interaktywne wykresy w **Plotly** i zapisać je do pliku HTML,
- ułożyć krótką narrację analityczną (problem → obserwacje → rekomendacje),
- wygenerować raport:
  - **Excel** z tabelami + wykresami przez `xlsxwriter`,
  - (opcjonalnie) prosty raport w **esparto**,
  - (opcjonalnie) mapę w **folium**.

---

## Wymagania wstępne
- podstawowa składnia Pythona,
- praca z bibliotekami (`import`, środowisko, pip/conda),
- pandas: `read_csv`, `groupby`, `agg`, `pivot_table`, `merge`, operacje na data/time (podstawy).

---

## Środowisko i instalacja
Rekomendacja: Python 3.10+ oraz Jupyter / VS Code.

### Instalacja paczek
~~~bash
pip install numpy pandas matplotlib seaborn plotly xlsxwriter openpyxl folium esparto
~~~

Jeśli masz środowisko w conda:
~~~bash
conda install numpy pandas matplotlib seaborn plotly openpyxl
pip install xlsxwriter folium esparto
~~~

### Szybki test importów (uruchom w notebooku)
~~~python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px

print("OK")
~~~

---

## Dane do ćwiczeń (z załączników)
W tym bloku używamy 2–3 zbiorów danych. Nie musisz znać ich „na pamięć” — od tego jest EDA.

### Dataset A (główny): `air_quality.csv`
**Typ danych:** pomiary czasowe + wiele metryk środowiskowych  
**Do czego:** time-series, trendy, sezonowość, porównanie stacji, korelacje

Przykładowe kolumny (biznesowo):
- `date_time` — czas pomiaru (ważne: trzeba sparsować do datetime!)
- `station` — stacja pomiarowa (kategoria)
- `PM2.5`, `PM10`, `SO2`, `NO2`, `CO`, `O3` — zanieczyszczenia (ciągłe)
- `TEMP`, `PRES`, `DEWP`, `RAIN`, `WSPM`, `wd` — pogoda/warunki (ciągłe/kategoryczne)

### Dataset B: `bank.csv`
**Typ danych:** klient + cechy + wynik kampanii (`deposit`)  
**Do czego:** wykresy udziałów, porównania grup, rozkłady cech vs target

Przykładowe kolumny:
- `age`, `job`, `education`, `balance`, `housing`, `loan`, `duration`
- `deposit` — czy klient założył lokatę (tak/nie)

### Dataset C (krótka rozgrzewka): `AI_Poland_Jobs_2022_06_10.csv`
**Typ danych:** ogłoszenia o pracę (tytuł, seniority, widełki)  
**Do czego:** rankingi, wykresy widełek, porównania lokalizacji

Przykładowe kolumny:
- `Title`, `Senior`, `Company`, `Location`
- `Salary_Min`, `Salary_Max`

### Jak wczytywać dane (w notebooku)
Założenie: pliki są w tym samym folderze co notebook (albo w `./data/`).

~~~python
import pandas as pd

df_air = pd.read_csv("air_quality.csv")
df_bank = pd.read_csv("bank.csv")
df_jobs = pd.read_csv("AI_Poland_Jobs_2022_06_10.csv")
~~~

---

## Co będziemy robić na ćwiczeniach (w skrócie)
1) Szybkie EDA pod wykresy (co jest czasem, co kategorią, gdzie braki, jakie skale).  
2) Matplotlib/Seaborn: wykresy rozkładów, porównań, trendów, korelacji.  
3) Plotly: 2–4 interaktywne wykresy + zapis do HTML.  
4) Raport: Excel (obowiązkowo) + opcjonalnie raport HTML/PDF (esparto) i/lub mapa (folium).  

---

## Praktyczne wskazówki (bardzo ważne w tym bloku)
- **Najpierw pytanie → potem wykres.** Np. „Czy PM2.5 rośnie zimą?” to inny wykres niż „Która stacja ma najwyższe wartości?”.
- **Agreguj dane.** W time-series często nie pokazujemy surowych punktów, tylko np. średnią dzienną/tygodniową + rolling mean.
- **Dbaj o czytelność:**
  - tytuł z tezą, nie „Wykres 1”,
  - jednostki/skalę osi,
  - rozsądna liczba serii na jednym wykresie,
  - posortowane kategorie (np. malejąco po wartości).
- **Outliery i skale:** jak wykres wygląda „płasko”, sprawdź outliery, logarytm, clipping albo medianę.
- **Wnioski w 1 zdaniu:** po każdym wykresie dopisz jedno zdanie „co z tego wynika”.

---

## Mini-projekt na koniec bloku (co oddajesz jako deliverable)
Twoim celem jest przygotować mini-raport, który mógłby pójść do interesariusza:
- Notebook z analizą + wykresami (min. 6 sensownych).
- 2 wykresy Plotly zapisane do HTML.
- Plik Excel `report.xlsx`:
  - arkusz `summary` (tabela podsumowań + 1 wykres),
  - arkusz `details` (bardziej szczegółowe zestawienia).

Opcjonalnie:
- raport HTML/PDF w esparto,
- mapa w folium (jeśli mamy sensowną lokalizację do pokazania).

---

## Zadanie domowe (dla chętnych)
1) Zrób alternatywną wersję raportu: „dla zarządu” (maks 1 strona / 4 wykresy).
2) Dodaj sekcję „Ryzyka i ograniczenia” (np. braki danych, outliery, sezonowość).
3) Zrób jeden wykres porównujący 2 podejścia agregacji (np. średnia dzienna vs mediana dzienna) i opisz różnicę w interpretacji.

---

## Najczęstsze problemy (i jak je szybko rozwiązać)
- `date_time` nie jest datetime → użyj `pd.to_datetime(...)` i posortuj po czasie.
- Wykres ma „dziury” → sprawdź `isna().sum()` i rozważ interpolację lub agregację.
- Za dużo linii → ogranicz liczbę kategorii (top N) albo użyj facetów / filtrów.
- Plotly nie zapisuje → `fig.write_html("name.html")` i upewnij się, że plik się tworzy w katalogu roboczym.
- Excel bez formatowania → w `xlsxwriter` ustaw formaty liczb, nagłówków i szerokości kolumn (w solved notebook będzie wzór).

---