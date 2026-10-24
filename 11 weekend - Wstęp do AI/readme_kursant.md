# Blok 12: Wstęp do AI (Machine Learning)

## 1. O czym jest ten blok?

To pierwszy blok modułu **Machine Learning**.  
Zakładamy, że umiesz już:

- podstawy Pythona,
- pracę z danymi w `NumPy` i `pandas`,
- podstawową wizualizację (np. `matplotlib` / `seaborn`).

W tym bloku **nie będziemy jeszcze robić „poważnych” modeli na dużych datasetach**.  
Zamiast tego:

- poukładamy pojęcia: **AI, Machine Learning, Deep Learning**,
- poznamy podstawowe rodzaje zadań ML (klasyfikacja, regresja, klasteryzacja itd.),
- zrozumiemy, czym jest **model**, **trening**, **cechy (`features`)**, **etykieta (`target`)**,
- nauczymy się, jak oceniać model (metryki klasyfikacji i regresji),
- uruchomimy **pierwszy prosty model w `scikit-learn`** na małych, syntetycznych danych.

Celem tego bloku jest „oswojenie” z ML – bez ciężkiej matematyki, ale z dużą dawką praktyki i przykładów.

---

## 2. Po tym bloku będziesz umieć…

1. **Rozróżniać podstawowe pojęcia:**
   - wyjaśnić, czym różni się **AI** od **Machine Learning** i **Deep Learning**,
   - powiedzieć, na czym polega **uczenie nadzorowane** i **nienadzorowane**,
   - określić, czy dany problem to **klasyfikacja**, **regresja** czy np. **klasteryzacja**.

2. **Formułować problem ML:**
   - wskazać, co w danych jest **cechą (`X`)**, a co **etykietą (`y`)**,
   - rozróżniać **zbiór treningowy** i **testowy**,
   - zrozumieć, czym jest **generalizacja modelu**.

3. **Znać podstawowe pojęcia związane z jakością modelu:**
   - intuicyjnie wyjaśnić, czym jest **bias** (niedouczenie) i **variance** (przeuczenie),
   - wiedzieć, dlaczego model może być „za prosty” albo „za skomplikowany”.

4. **Stosować proste techniki inżynierii cech:**
   - zamienić zmienną kategoryczną na one-hot encoding,
   - zastosować **skalowanie** / **standaryzację** cech numerycznych,
   - zrozumieć, po co normalizujemy dane dla niektórych modeli.

5. **Korzystać z podstawowych metryk:**
   - dla klasyfikacji: zbudować **confusion matrix**, policzyć **accuracy, precision, recall, F1-score**,
   - wiedzieć, czym jest krzywa **ROC** (na poziomie intuicji),
   - dla regresji: policzyć i zinterpretować **MSE, RMSE, MAE**.

6. **Przejść cały workflow ML na prostym przykładzie:**
   - przeanalizować prosty problem biznesowy,
   - przygotować mały zbiór cech,
   - wybrać prosty model w `scikit-learn`,
   - podzielić dane na train/test, wytrenować model, policzyć metrykę i wyciągnąć pierwsze wnioski.

---

## 3. Wymagania wstępne

Żeby czerpać pełną wartość z tego bloku, przyda Ci się:

- Python:
  - typy danych (`int`, `float`, `str`, `bool`),
  - listy, słowniki, pętle, proste funkcje,
- `NumPy` i `pandas`:
  - tworzenie tablic / DataFrame’ów,
  - filtrowanie, wybieranie kolumn, proste agregacje (`groupby`, `mean`, `count`),
- podstawowa wizualizacja:
  - prosty wykres liniowy / słupkowy w `matplotlib` lub `seaborn`,
- podstawowe pojęcia statystyczne (intuicyjnie):
  - średnia, mediana, wariancja, odchylenie standardowe.

Nie musisz znać żadnych algorytmów ML ani wzorów – tym zajmiemy się krok po kroku.

---

## 4. Środowisko i instalacja

### 4.1. Co będziemy używać?

- **Język:** Python 3.10+  
- **Środowisko:**  
  - Jupyter Notebook 
  lub
  - VS Code z rozszerzeniem Jupyter
- **Biblioteki:**
  - `numpy`
  - `pandas`
  - `scikit-learn`
  - `matplotlib`
  - `seaborn` (opcjonalnie)

### 4.2. Instalacja – szybka instrukcja

Jeśli masz już Pythona i `pip`, możesz zainstalować potrzebne pakiety jedną komendą:

~~~bash
pip install numpy pandas scikit-learn matplotlib seaborn
~~~

Jeśli korzystasz z wirtualnego środowiska (np. `venv`, `conda`):

1. Aktywuj środowisko.
2. Uruchom powyższą komendę.
3. Sprawdź w Pythonie, czy importy działają:

   ~~~python
   import numpy as np
   import pandas as pd
   from sklearn.model_selection import train_test_split
   ~~~

Na zajęciach prowadzący i tak przejdzie przez podstawowe kroki, ale warto mieć środowisko gotowe wcześniej.

---

## 5. Dane używane w ćwiczeniach

W tym bloku **nie pracujemy na dużych, „prawdziwych” datasetach**.  
Używamy prostych, syntetycznych danych, które:

- są tworzone **bezpośrednio w notebooku** (np. listy, słowniki),
- mają kilka–kilkanaście wierszy,
- pozwalają skupić się na **zrozumieniu pojęć**, a nie na czyszczeniu danych.

Przykładowe mini-zbiory:

### 5.1. Klienci sklepu online (klasyfikacja)

Przykładowe kolumny:

- `age` – wiek klienta (np. 18–70),
- `country` – kraj (np. "PL", "DE", "UK"),
- `device` – typ urządzenia (np. "mobile", "desktop"),
- `source` – źródło ruchu (np. "ads", "organic", "email"),
- `purchase` – etykieta: 1 jeśli klient kupił, 0 jeśli nie.

Zadanie: przewidzieć, czy klient kupi, na podstawie jego cech.

### 5.2. Mieszkania (regresja)

Przykładowe kolumny:

- `rooms` – liczba pokoi,
- `area` – metraż mieszkania,
- `district` – dzielnica (np. "center", "suburbs"),
- `price` – cena mieszkania.

Zadanie: przewidzieć cenę mieszkania na podstawie cech.

### 5.3. Mały zbiór do confusion matrix

- `y_true` – prawdziwe etykiety (np. 0/1),
- `y_pred` – przewidywane etykiety modelu.

Zadanie: policzyć TN, FP, FN, TP, a potem metryki.

Te dane są celowo małe i „ładne”, żeby można było liczyć rzeczy także „na kartce” i zrozumieć, co się dzieje.

---

## 6. Jak będzie wyglądać blok – flow i typ ćwiczeń

### 6.1. Część teoretyczna (ok. 40% czasu)

Krótko omówimy:

- czym jest AI, ML, DL – prosto i na przykładach z życia (rekomendacje, reklamy, mapy),
- czym różnią się:
  - klasyfikacja,
  - regresja,
  - klasteryzacja,
  - redukcja wymiarowości,
- concepty:
  - cechy (`features`),
  - etykieta (`target`),
  - zbiór treningowy/testowy,
  - bias vs variance – przeuczenie i niedouczenie,
- metryki:
  - klasyfikacja – confusion matrix, accuracy, precision, recall, F1,
  - regresja – MSE, RMSE, MAE.

Teoria będzie przeplatana krótkimi pytaniami i mini-ćwiczeniami „papierowymi”.

### 6.2. Część praktyczna (ok. 60% czasu)

Przykładowe typy zadań:

- **rozpoznawanie typu problemu** (klasyfikacja vs regresja),
- wskazywanie, co jest `X`, a co `y`,
- ręczne zrobienie **one-hot encodingu** dla prostej zmiennej,
- ręczne policzenie **skalowania** cech (min-max, standaryzacja),
- ręczne policzenie **confusion matrix** i metryk klasyfikacji,
- liczenie **MSE, RMSE, MAE** na kilku przykładach,
- napisanie pierwszego prostego modelu w `scikit-learn`:
  - przygotowanie `X` i `y`,
  - `train_test_split`,
  - `fit`, `predict`,
  - policzenie metryki.

Będą też zadania, w których łączymy wszystko w mały **workflow ML**: od problemu biznesowego do pierwszego modelu.

---

## 7. Praca domowa – skrót

### Zadanie 1 – Mini-pipeline klasyfikacji

- Dostaniesz opis małego zbioru danych (np. klienci z cechami demograficznymi).
- Twoim zadaniem będzie:

  1. Przygotować `X` i `y`.
  2. Zastanowić się, które kolumny trzeba zakodować (one-hot) i/lub przeskalować.
  3. Podzielić dane na train/test.
  4. Zbudować prosty model klasyfikacyjny w `scikit-learn`.
  5. Policzyć metryki (accuracy, precision, recall, F1) i krótko je zinterpretować tekstowo.

- Szacowany czas: 30–45 minut.

### Zadanie 2 (dla chętnych) – Bias vs variance na wykresie

- Na prostym przykładzie z regresją zobaczysz, jak zmienia się błąd na zbiorze treningowym i testowym, gdy zwiększa się „złożoność” modelu.
- Narysujesz wykres, który pokaże efekt:
  - zbyt prosty model → duży błąd wszędzie,
  - zbyt złożony model → bardzo mały błąd na train, duży na test (przeuczenie),
  - „złoty środek” pośrodku.

To zadanie bardzo pomaga „poczuć”, co naprawdę oznaczają słowa **underfitting** i **overfitting**.

---

## 8. Jak ten blok przyda Ci się dalej?

W kolejnych blokach będziemy:

- uczyć się konkretnych algorytmów (np. regresja liniowa, drzewa, lasy losowe, gradient boosting),
- pracować na większych, bardziej realistycznych danych,
- przygotowywać dane bardziej „produkcyjnie”.

Ten blok to fundament, który:

- daje Ci **wspólny język** do rozmowy o ML,
- uczy, jak patrzeć na problem z perspektywy **danych i metryk**,
- pokazuje podstawowy **workflow**, który później będziemy pogłębiać.

W projekcie końcowym:

- będziesz formułować problem jako klasyfikację lub regresję,
- wybierać metryki sukcesu,
- trenować model w `scikit-learn` i oceniać go – to wszystko startuje właśnie tutaj.

---

## 9. Kilka praktycznych wskazówek przed zajęciami

- **Powtórz Pythona i `pandas`:**
  - indeksowanie DataFrame’ów,
  - wybieranie kolumn,
  - zamiana typów danych.

- **Nie stresuj się matematyką:**
  - skupi się na intuicji i przykładach,
  - wzory będziemy omawiać tylko tyle, ile naprawdę trzeba.

- **Zadawaj pytania:**
  - jeśli nie rozumiesz różnicy między np. precision a recall – mów głośno,
  - wiele osób ma podobne wątpliwości, tylko nie zawsze je zgłasza.

- **Notuj własnymi słowami:**
  - zamiast przepisywać definicje, zapisuj „jak byś wytłumaczył/a to koledze z pracy”.

- **Myśl o swojej branży:**
  - spróbuj już teraz wymyślić 1–2 problemy, które u Ciebie w pracy da się ubrać w ramy:
    - klasyfikacji (tak/nie, wybór kategorii),
    - regresji (przewidywanie liczby/ceny/zysku).

To pomoże Ci później wybrać temat projektu końcowego.

---