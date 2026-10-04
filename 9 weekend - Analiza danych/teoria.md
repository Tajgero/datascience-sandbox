# Blok 9: Python – Praca z danymi (analiza i wizualizacja)

## 1) Flow pracy z danymi (workflow analityczny)
W realnej pracy prawie zawsze idziesz tym schematem (iteracyjnie):
1. **Pozyskanie / wczytanie danych** (CSV, SQL, API, pliki parquet, itp.)
2. **Szybki przegląd**: ile danych, jakie kolumny, typy, braki, duplikaty
3. **EDA (Exploratory Data Analysis)**: rozkłady, agregacje, segmentacje, relacje
4. **Czyszczenie**: braki, typy, outliery, spójność biznesowa
5. **Feature engineering (proste)**: nowe kolumny (udziały, kategorie, log, bucket)
6. **Wizualizacja + wnioski**: wykresy, interpretacja, rekomendacje
7. **Pakowanie wyników**: notebook/raport, tabela wynikowa, zapis do pliku

Najważniejsze nawyki:
- najpierw *sprawdź dane*, dopiero potem *licz i rysuj*,
- miej „sanity checks” (kontrole sensowności),
- wnioski zapisuj krótko i konkretnie (3–5 zdań).

## 2) NumPy – po co i kiedy?
NumPy to szybkie tablice numeryczne (`ndarray`) i fundament pod pandas/scikit-learn.

**Kiedy NumPy jest mega sensowne:**
- obliczenia numeryczne, macierze, wektoryzacja,
- praca na samych liczbach (bez „mieszanych” typów),
- gdy zależy Ci na wydajności vs pętle w Pythonie.

### 2.1 Tablice 1D i 2D – podstawy
- `shape` – kształt tablicy (np. `(5,)`, `(100, 3)`)
- `dtype` – typ danych (np. `int64`, `float64`)
- `ndim` – liczba wymiarów

Przykłady (bez uruchamiania, do notatnika):
~~~python
import numpy as np

a = np.array([1, 2, 3])        # 1D
b = np.array([[1, 2], [3, 4]]) # 2D

a.shape, a.dtype
b.shape, b.dtype
~~~

### 2.2 Tworzenie tablic
- `np.array(...)`
- `np.arange(start, stop, step)`
- `np.zeros((rows, cols))`, `np.ones(...)`
- `np.random.default_rng(seed)` – losowania (lepiej niż stare `np.random.*`)

~~~python
rng = np.random.default_rng(42)
x = np.arange(0, 10, 2)
z = rng.normal(loc=0, scale=1, size=1000)
~~~

### 2.3 Indeksowanie i slicing
- 1D: `a[0]`, `a[-1]`, `a[2:5]`
- 2D: `b[0, 1]`, `b[:, 0]`, `b[1, :]`

### 2.4 Maska boolowska (filtrowanie)
~~~python
z = np.array([1.2, -0.3, 0.0, 2.1])
mask = z > 0
z_pos = z[mask]        # tylko dodatnie
count_pos = mask.sum() # ile dodatnich
~~~

### 2.5 Funkcje numeryczne: sum/mean/std + axis
- `np.sum(a)` sumuje wszystko
- `np.sum(a, axis=0)` sumuje kolumny (w 2D)
- `np.sum(a, axis=1)` sumuje wiersze

~~~python
m = np.array([[1, 2, 3],
              [4, 5, 6]])

m.sum()        # 21
m.sum(axis=0)  # [5, 7, 9]
m.sum(axis=1)  # [6, 15]
~~~

### 2.6 Broadcasting (ważne, bo „magiczne”)
Broadcasting to zasada dopasowywania kształtów przy działaniach:
- `(n, m) + (m,)` działa (wektor dodany do każdego wiersza),
- jeśli kształty „nie dają się” dopasować → błąd.

Nawyk: sprawdź `shape` przed operacją.

## 3) pandas – po co i kiedy?
pandas to praca na danych tabelarycznych (jak Excel/SQL), tylko programistycznie:
- **Series** – jedna kolumna (wektor) z indeksem,
- **DataFrame** – tabela (kolumny o nazwach, wiersze z indeksem).

### 3.1 Wczytywanie danych (najczęściej CSV)
~~~python
import pandas as pd

df = pd.read_csv("vgsales_clean.csv")
~~~

Dobre nawyki po wczytaniu:
- `df.head()`
- `df.shape`
- `df.info()`
- `df.describe(include="all")` (uważaj: dłuższe)

### 3.2 Typy danych (dtypes) i konwersje
- `object` zwykle oznacza tekst (albo „mieszankę”),
- liczby powinny być `int`/`float`,
- kategorie (np. Platform/Genre) często opłaca się zrobić `category` (mniej pamięci, szybsze grupowania).

Konwersje:
~~~python
df["Year"] = pd.to_numeric(df["Year"], errors="coerce")
df["Platform"] = df["Platform"].astype("category")
~~~

`errors="coerce"`: błędne wartości zamienia na `NaN` → potem musisz podjąć decyzję co z brakami.

### 3.3 Brakujące wartości (NaN)
Szybki audyt:
~~~python
missing = df.isna().sum().sort_values(ascending=False)
missing_pct = (df.isna().mean() * 100).sort_values(ascending=False)
~~~

Co możesz zrobić:
- **zostawić** (czasem OK),
- **usunąć wiersze**: `df.dropna(subset=[...])`,
- **usunąć kolumnę** (gdy jest bezużyteczna),
- **imputować** (uzupełniać): średnia/mediana/moda albo stała wartość.

~~~python
df["Year"] = df["Year"].fillna(df["Year"].median())
df["Publisher"] = df["Publisher"].fillna("Unknown")
~~~

Uwaga: decyzja o brakach to decyzja *biznesowa* + *statystyczna*.

### 3.4 Selekcja kolumn i wierszy
Kolumny:
- `df["Global_Sales"]` → Series
- `df[["Name", "Platform", "Global_Sales"]]` → DataFrame

Wiersze:
- `.loc` – po etykietach/warunkach (zalecane do filtrowania)
- `.iloc` – po indeksach liczbowych (pozycjach)

~~~python
df.loc[df["Global_Sales"] > 10, ["Name", "Platform", "Global_Sales"]]
df.iloc[0:5, 0:3]
~~~

### 3.5 Filtrowanie i sortowanie
~~~python
top = df[df["Global_Sales"] >= 5].sort_values("Global_Sales", ascending=False)
top10 = df.nlargest(10, "Global_Sales")
~~~

### 3.6 Operacje na kolumnach (feature engineering)
Dodawanie kolumn:
~~~python
df["NA_share"] = df["NA_Sales"] / df["Global_Sales"]
~~~

Usuwanie:
~~~python
df = df.drop(columns=["Rank"])
~~~

Zmiana nazwy:
~~~python
df = df.rename(columns={"Global_Sales": "global_sales_mln"})
~~~

Uwaga praktyczna: dzielenie przez 0 daje `inf`/`NaN` → sprawdzaj:
~~~python
df["NA_share"] = df["NA_Sales"] / df["Global_Sales"].replace(0, pd.NA)
~~~

### 3.7 Duplikaty
~~~python
df.duplicated().sum()
df.duplicated(subset=["Name", "Platform", "Year"]).sum()
df = df.drop_duplicates(subset=["Name", "Platform", "Year"])
~~~

### 3.8 Groupby i agregacje (serce EDA)
Najczęstszy wzorzec:
~~~python
by_platform = (
    df.groupby("Platform", as_index=False)
      .agg(global_sales=("Global_Sales", "sum"),
           games=("Name", "count"),
           avg_sales=("Global_Sales", "mean"))
      .sort_values("global_sales", ascending=False)
)
~~~

`as_index=False` daje normalną kolumnę zamiast indeksu (często wygodniej).

### 3.9 Pivot table (tabela przestawna)
~~~python
pivot = pd.pivot_table(
    df,
    values="Global_Sales",
    index="Genre",
    columns="Platform",
    aggfunc="sum",
    fill_value=0
)
~~~

### 3.10 Merge / join (łączenie tabel)
Kluczowa rzecz: łączenie po wspólnym kluczu.
~~~python
df_merged = df.merge(mapping_df, on="Platform", how="left")
~~~

Najczęstsze pułapki:
- różne typy klucza (np. str vs int),
- duplikaty w tabeli mapującej → „rozdmuchanie” wierszy.

### 3.11 SettingWithCopyWarning (klasyk)
Problem: modyfikujesz „wycinek” DataFrame.
Dobre nawyki:
- używaj `.loc` do przypisań:
~~~python
mask = df["Global_Sales"] > 5
df.loc[mask, "segment"] = "hit"
~~~
- jeśli tworzysz nową tabelę filtrem i potem ją edytujesz:
~~~python
df_hits = df[df["Global_Sales"] > 5].copy()
df_hits["segment"] = "hit"
~~~

## 4) EDA – o co pytać (na przykładzie vgsales)
Przykładowe pytania biznesowe:
- Jakie **platformy** generują największą sprzedaż globalnie?
- Jak zmienia się sprzedaż **w czasie** (per rok)?
- Czy **regiony** różnią się preferencjami (JP vs NA vs EU)?
- Którzy **wydawcy** dominują (top10 i udział w rynku)?
- Czy rozkład sprzedaży jest „długi ogon” (kilka hitów, reszta mało)?

Przykładowe sanity checks:
- `Global_Sales` ≈ `NA+EU+JP+Other` (różnice tylko przez zaokrąglenia),
- `Year` w sensownym zakresie (np. 1980–2020),
- brak ujemnych sprzedaży,
- zbyt wiele identycznych rekordów `Name+Platform+Year` = alarm.

## 5) Podstawy statystyk opisowych (w praktyce)
- **Średnia (mean)**: wrażliwa na outliery (hity sprzedażowe zawyżają).
- **Mediana (median)**: bardziej odporna, często lepsza dla rozkładów „długi ogon”.
- **Moda (mode)**: najczęstsza wartość (częściej dla kategorii).
- **Odchylenie standardowe (std)**: „rozrzut” wokół średniej.

W pandas:
~~~python
df["Global_Sales"].mean()
df["Global_Sales"].median()
df["Genre"].mode()
df["Global_Sales"].std()
~~~

## 6) Wizualizacja – zasady i minimum narzędzi
W pracy wykres ma odpowiadać na pytanie i być czytelny.

### 6.1 Minimum w matplotlib
Wzorzec:
~~~python
import matplotlib.pyplot as plt

plt.figure(figsize=(10, 5))
plt.plot(series.index, series.values)
plt.title("Tytuł")
plt.xlabel("Oś X")
plt.ylabel("Oś Y (jednostki)")
plt.tight_layout()
plt.show()
~~~

### 6.2 Jakie wykresy do czego?
- **bar chart**: top N kategorii (platformy, gatunki, wydawcy)
- **line chart**: trend w czasie (sprzedaż per rok)
- **histogram**: rozkład (np. Global_Sales)
- **boxplot**: outliery i porównanie rozkładów między kategoriami

Zasady „czytelnego wykresu”:
- tytuł + osie + jednostki,
- sortuj kategorie (żeby top było na górze),
- nie wrzucaj 20 serii na jeden wykres,
- jedna myśl na wykres.

## 7) Polars – po co (krótko) i co warto zapamiętać
Polars jest nastawiony na wydajność i ergonomię przy większych danych (często szybciej i mniej RAM). Składnia jest inna niż pandas, ale wiele koncepcji podobnych.

Mini-przykład:
~~~python
import polars as pl

pl_df = pl.read_csv("vgsales_clean.csv")

res = (
    pl_df.group_by("Platform")
         .agg(pl.col("Global_Sales").sum().alias("global_sales"))
         .sort("global_sales", descending=True)
         .head(10)
)
~~~

Kiedy rozważyć polars:
- dataset zaczyna „puchnąć” (RAM/czas),
- chcesz pipeline’y i lazy evaluation (`.lazy()`),
- dużo transformacji kolumnowych.

## 8) Najczęstsze błędy (i szybkie fixy)
- **KeyError**: sprawdź `df.columns`, literówki, spacje w nazwach.
- **Dziwne typy**: `pd.to_numeric(..., errors="coerce")`, potem audyt braków.
- **SettingWithCopyWarning**: `.loc` do przypisań lub `.copy()` po filtrowaniu.
- **Merge zwielokrotnił wiersze**: duplikaty w kluczu; sprawdź `mapping_df["key"].duplicated().sum()`.
- **Wykres nieczytelny**: top N, sortowanie, większy `figsize`, krótsze etykiety.

## 9) Szybki „cheat sheet” (do praktyki)
- start: `df.head()`, `df.info()`, `df.describe()`, `df.shape`
- braki: `df.isna().sum()`, `df.dropna(...)`, `df.fillna(...)`
- selekcja: `df[cols]`, `.loc`, `.iloc`
- porządek: `rename`, `drop`, `astype`, `to_numeric`
- EDA: `value_counts`, `groupby().agg()`, `pivot_table`, `corr`
- wiz: `plt.figure`, `plt.bar`, `plt.plot`, `plt.hist`, `plt.title`, `plt.tight_layout`
- join: `merge(on=..., how=...)`