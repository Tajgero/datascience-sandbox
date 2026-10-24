# Wstęp do AI (Machine Learning)

Dokument ten jest kompendium do bloku **„Wstęp do AI (Machine Learning)”**.  
Ma służyć jako ściąga i punkt odniesienia przy ćwiczeniach.

---

## 1. AI, Machine Learning, Deep Learning – porządek pojęć

### 1.1. AI (Artificial Intelligence)

**AI** – szerokie pojęcie: każdy system, który zachowuje się „inteligentnie”:

- umie podejmować decyzje,
- rozwiązuje problemy,
- uczy się lub adaptuje.

Przykłady:

- systemy rekomendacji (filmy, muzyka, produkty),
- systemy grające w gry (szachy, Go),
- systemy sterujące (np. autopilot w samolocie).

AI nie musi wykorzystywać danych i statystyki – może to być np. zbiór reguł `if-else`.

---

### 1.2. Machine Learning (ML)

**Machine Learning** to **podejście w ramach AI**, w którym system:

> uczy się wzorców z danych, zamiast mieć wszystko zaprogramowane „ręcznie”.

Czyli:

- dostarczamy dane wejściowe (`X`) i, w wielu przypadkach, poprawne odpowiedzi (`y`),
- algorytm automatycznie dopasowuje parametry modelu,
- celem jest, by model dobrze działał także na **nowych, niewidzianych danych** (generalizacja).

---

### 1.3. Deep Learning (DL)

**Deep Learning** to podzbiór ML:

- wykorzystuje **sztuczne sieci neuronowe** z wieloma warstwami (deep – „głębokie”),
- szczególnie dobre w:
  - przetwarzaniu obrazów (vision),
  - przetwarzaniu języka (NLP),
  - audio, sygnałach itd.

W praktyce:

- ML to np. regresja liniowa, drzewa decyzyjne, lasy losowe, gradient boosting, SVM, KNN,
- DL to np. sieci CNN, RNN, LSTM, Transformers.

W tym bloku skupiamy się na **klasycznym ML**, bez głębokich sieci.

---

## 2. Rodzaje uczenia maszynowego

### 2.1. Uczenie nadzorowane (Supervised Learning)

Mamy:

- dane wejściowe `X` (cechy),
- poprawne odpowiedzi `y` (etykiety).

Model uczy się odwzorowania:

> `X` → `y`

Przykłady:

- przewidywanie, czy klient odejdzie (churn: tak/nie),
- przewidywanie ceny mieszkania,
- klasyfikacja e-maili jako spam / nie-spam.

Typowe zadania:

- **klasyfikacja** (gdy `y` jest kategorią),
- **regresja** (gdy `y` jest wartością liczbową ciągłą).

---

### 2.2. Uczenie nienadzorowane (Unsupervised Learning)

Mamy tylko:

- dane wejściowe `X`,
- **bez** etykiet `y`.

Celem jest znalezienie struktury w danych:

- grupy podobnych obiektów (klastry),
- ważne kierunki zmienności (redukcja wymiarowości),
- reguły asocjacyjne (współwystępowanie).

Przykłady:

- segmentacja klientów na grupy podobnego zachowania,
- sprowadzenie danych z 50 cech do 2–3 wymiarów (np. do wizualizacji).

Typowe zadania:

- **klasteryzacja**,
- **redukcja wymiarowości**.

---

### 2.3. Uczenie ze wzmocnieniem (Reinforcement Learning) – wzmianka

Trzeci typ (tylko dla kontekstu):

- agent uczy się poprzez interakcję ze środowiskiem,
- dostaje **nagrodę** lub **karę** za swoje działania,
- celem jest maksymalizacja sumy nagród w czasie.

Przykłady:

- gry (szachy, Go),
- sterowanie robotem,
- optymalizacja strategii ofert w reklamach.

W tym kursie skupiamy się na **uczeniu nadzorowanym** i elementach **nienadzorowanego**.

---

## 3. Typy zadań Machine Learning

### 3.1. Klasyfikacja (Classification)

**Cel:** przypisać obiekt do jednej z **kategorii**.

- `y` – etykieta kategoryczna: np. 0/1, „tak/nie”, „A/B/C”.
- Przykłady:
  - czy klient kupi produkt? (`purchase` = 0/1),
  - jaki będzie typ transakcji? (kategorie),
  - czy transakcja jest fraudem? (0 – ok, 1 – fraud).

Przykładowy format:

- `X` – cechy klienta: wiek, kraj, źródło ruchu, itd.
- `y` – `purchase` (0/1).

---

### 3.2. Regresja (Regression)

**Cel:** przewidzieć **wartość liczbową ciągłą**.

- `y` – liczba rzeczywista (float).
- Przykłady:
  - cena mieszkania,
  - liczba sprzedanych sztuk,
  - przychód w przyszłym miesiącu.

Przykład:

- `X` – liczba pokoi, metraż, lokalizacja,
- `y` – cena w zł.

---

### 3.3. Klasteryzacja (Clustering)

**Cel:** podzielić obiekty na **grupy podobnych**, bez znanych z góry etykiet.

- brak `y` podczas treningu,
- przykłady:
  - segmentacja klientów (grupy o podobnym profilu),
  - grupowanie produktów.

Typowe algorytmy: `KMeans`, `DBSCAN` (późniejsze bloki).

---

### 3.4. Redukcja wymiarowości (Dimensionality Reduction)

**Cel:** zmniejszyć liczbę cech przy zachowaniu jak największej ilości informacji.

- ułatwia wizualizację i czasem poprawia działanie modeli,
- przykłady:
  - `PCA` (Principal Component Analysis – analiza głównych składowych),
  - `t-SNE`, `UMAP` (bardziej zaawansowane).

---

### 3.5. Uczenie zależności (Association Rules) – wzmianka

**Cel:** wykrywanie reguł typu „kto kupił X, często kupuje Y”.

- przykład: analizy koszykowe w e-commerce,
- typowe algorytmy: `Apriori`, `FP-Growth`.

---

### 3.6. Szeregi czasowe (Time Series) – wzmianka

**Cel:** analiza i prognozowanie wartości w czasie.

- dane: uporządkowane w czasie (np. dzienny przychód),
- przykłady:
  - prognoza sprzedaży,
  - prognoza obciążenia systemów.

Tu ważna jest kolejność w czasie, co odróżnia od typowych modeli klasycznych.

---

## 4. Dane, cechy, etykiety

### 4.1. Cechy (Features) – `X`

**Cechy** – opisują obiekt, są wejściem modelu.

Przykłady:

- klient:
  - wiek, kraj, typ urządzenia, źródło ruchu,
- mieszkanie:
  - powierzchnia, liczba pokoi, dzielnica.

Cechy mogą być:

- numeryczne (ciągłe, dyskretne),
- kategoryczne (np. kraj, typ urządzenia),
- binarne (0/1).

---

### 4.2. Etykieta (Target) – `y`

**Etykieta** – to, co chcemy przewidzieć.

- w klasyfikacji – kategoria,
- w regresji – liczba ciągła.

Przykłady:

- `purchase` (0/1),
- `price` (cena),
- `churn` (czy zrezygnuje: 0/1).

---

### 4.3. Zbiór treningowy i testowy

Dane dzielimy zwykle na:

- **zbiór treningowy** (train) – model uczy się tu swoich parametrów,
- **zbiór testowy** (test) – oceniamy model na danych, których nie widział podczas treningu.

Dlaczego?

- chcemy zobaczyć, czy model **generalizuje** na nowe dane,
- wynik na treningu może być „zbyt optymistyczny”, jeśli model „nauczy się na pamięć”.

W `scikit-learn` używamy funkcji:

- `train_test_split(X, y, test_size=..., random_state=...)`.

---

## 5. Model, trening, generalizacja

### 5.1. Model

**Model** – funkcja matematyczna / statystyczna, która:

> przekształca cechy `X` w przewidywania `ŷ`.

Przykłady modeli:

- regresja liniowa,
- drzewo decyzyjne,
- las losowy,
- KNN,
- sieć neuronowa itd.

Model ma:

- **strukturę** (np. formuła, kształt drzewa),
- **parametry** (np. wagi w regresji, progi podziału w drzewie).

---

### 5.2. Trening (Training)

**Trening** modelu:

1. Bierzemy dane treningowe `X_train` i `y_train`.
2. Model robi przewidywania `ŷ_train`.
3. Mierzymy **błąd** (różnicę między `y_train` a `ŷ_train`).
4. Algorytm aktualizuje parametry modelu, aby błąd był jak najmniejszy.

Ten proces często jest iteracyjny – powtarza się wiele razy.

---

### 5.3. Generalizacja (Generalization)

Model powinien:

- dobrze dopasować się do danych treningowych,
- **i jednocześnie** dobrze działać na nowych danych (testowych).

Zła sytuacja:

- model jest idealny na treningu, ale słaby na testowym → **przeuczenie (overfitting)**,
- model jest słaby wszędzie → **niedouczenie (underfitting)**.

Oceniamy generalizację poprzez błąd / metryki na zbiorze testowym (lub walidacyjnym).

---

## 6. Bias i variance – niedouczenie i przeuczenie

### 6.1. Bias (obciążenie)

**Wysoki bias = model zbyt prosty**

- nie umie uchwycić zależności w danych,
- błędy są duże zarówno na treningu, jak i na testowym,
- przykład: liniowy model do bardzo nieliniowej relacji, bez odpowiedniej transformacji cech.

**Underfitting (niedouczenie):**

- model nie nauczył się nawet najważniejszych wzorców.

---

### 6.2. Variance (wariancja)

**Wysoka variance = model zbyt skomplikowany**

- bardzo dobrze dopasowuje dane treningowe (błąd prawie 0),
- ale na nowych danych radzi sobie słabo,
- model „uczy się na pamięć” szumu (noise).

**Overfitting (przeuczenie):**

- niski błąd na treningu, wysoki na testowym.

---

### 6.3. Kompromis bias–variance

Idealnie chcemy:

- rozsądny poziom bias (model wystarczająco złożony),
- rozsądny poziom variance (nie przeuczony).

W praktyce:

- używamy:
  - regularyzacji,
  - ograniczania złożoności modelu (np. max głębokość drzewa),
  - odpowiedniej liczby cech,
- staramy się znaleźć **„złoty środek”** poprzez eksperymenty i walidację.

---

## 7. Inżynieria cech (Feature Engineering)

**Inżynieria cech** – przekształcanie istniejących cech lub tworzenie nowych tak, aby model mógł lepiej się uczyć.

Typowe operacje:

- kodowanie zmiennych kategorycznych,
- skalowanie cech numerycznych,
- tworzenie cech pochodnych (np. `price_per_m2`),
- wybór cech (feature selection).

W tym bloku skupiamy się na:

- **one-hot encoding**,
- **skalowaniu / standaryzacji cech**.

---

### 7.1. One-hot encoding

Problem:

- modele wymagają zwykle wartości numerycznych,
- zmienna kategoryczna (np. `device` = "mobile"/"desktop") nie jest liczbą.

**One-hot encoding:**

- każda kategoria staje się osobną kolumną,
- w wierszu, do którego kategoria należy, wpisujemy 1, w pozostałych 0.

Przykład:

Kolumna `device`:

| device  |
|---------|
| mobile  |
| desktop |
| mobile  |

Po one-hot:

| device_mobile | device_desktop |
|---------------|----------------|
| 1             | 0              |
| 0             | 1              |
| 1             | 0              |

W `pandas`:

- można użyć `pd.get_dummies(...)`,
- w `scikit-learn`: `OneHotEncoder`.

---

### 7.2. Skalowanie cech (Scaling)

Problem:

- cechy mogą mieć bardzo różne skale:
  - `age` – 18–70,
  - `income` – 2000–30000,
- niektóre modele wrażliwe na skalę:
  - KNN, SVM, regresja liniowa, algorytmy z regularyzacją.

Skalowanie to transformacja wartości cechy do „bardziej standardowej” skali.

---

#### 7.2.1. Min-max scaling (normalizacja do [0, 1])

Dla każdej wartości:

- `x_scaled = (x - x_min) / (x_max - x_min)`

Efekt: najmniejsza wartość cechy → 0, największa → 1.

---

#### 7.2.2. Standaryzacja (z-score)

Dla każdej wartości:

- `x_standard = (x - mean) / std`

Efekt:

- cecha ma średnią ≈ 0,
- odchylenie standardowe ≈ 1.

W `scikit-learn` mamy np.:

- `StandardScaler`,
- `MinMaxScaler`.

---

### 7.3. Feature selection i feature extraction – wzmianka

- **Feature selection** – wybór najbardziej istotnych cech,
- **Feature extraction** – tworzenie nowych cech z istniejących (np. PCA).

W tym bloku – tylko na poziomie pojęcia.

---

## 8. Metryki klasyfikacji

### 8.1. Confusion Matrix (macierz pomyłek)

Dla problemu binarnego (negatyw/pozytyw):

- `TN` – True Negative: model poprawnie przewidział klasę negatywną,
- `TP` – True Positive: model poprawnie przewidział klasę pozytywną,
- `FN` – False Negative: model nie wykrył pozytywnej klasy (błąd),
- `FP` – False Positive: model błędnie oznaczył negatywną klasę jako pozytywną.

Macierz (schemat):

|                | Predicted Negative | Predicted Positive |
|----------------|--------------------|--------------------|
| Actual Negative| TN                 | FP                 |
| Actual Positive| FN                 | TP                 |

Na bazie tych 4 wartości budujemy różne metryki.

---

### 8.2. Accuracy

**Accuracy** – ogólna dokładność:

- ile przewidywań było poprawnych spośród wszystkich.

Wzór:

- `accuracy = (TP + TN) / (TP + TN + FP + FN)`

Problem:

- może być myląca przy **niezbalansowanych danych** (np. 99% klas negatywnych, 1% pozytywnych).

---

### 8.3. Precision (precyzja)

**Precision** – z wszystkich przykładów przewidzianych jako pozytywne, ile było naprawdę pozytywnych?

- `precision = TP / (TP + FP)`

Wysoka precision → mało fałszywych alarmów (FP).

Przykład: wykrywanie fraudu, kiedy błędne oznaczenie normalnej transakcji jako fraud jest kosztowne (np. zły PR).

---

### 8.4. Recall (czułość, sensitivity)

**Recall** – z wszystkich prawdziwych pozytywnych, ile poprawnie wykryliśmy?

- `recall = TP / (TP + FN)`

Wysoki recall → mało przypadków, które „umknęły” (FN).

Przykład: wykrywanie choroby – ważne, żeby nie przeoczyć prawdziwie chorych.

---

### 8.5. F1-score

**F1-score** – średnia harmoniczna precision i recall:

- `F1 = 2 * (precision * recall) / (precision + recall)`

Gdy:

- F1 ≈ 1 → precision i recall są wysokie,
- F1 ≈ 0 → przynajmniej jedna z metryk jest niska.

Użyteczna, gdy zależy nam na **balansie** między precision i recall.

---

### 8.6. ROC i AUC – intuicja

Dla modeli klasyfikacyjnych często mamy **prawdopodobieństwa** (np. `P(y=1)`), a nie tylko 0/1.

- ROC (Receiver Operating Characteristic) – wykres:
  - oś X: False Positive Rate,
  - oś Y: True Positive Rate (czyli recall),
- zmieniając próg decyzyjny (np. 0.5 → 0.3), dostajemy różne punkty na krzywej.

**AUC (Area Under Curve)** – pole pod krzywą ROC:

- 0.5 – model losowy,
- 1.0 – model idealny.

W tym bloku ważne jest **pojęcie**, nie szczegółowe liczenie ROC/AUC.

---

## 9. Metryki regresji

W regresji porównujemy:

- prawdziwą wartość `y`,
- przewidzianą wartość `ŷ`.

---

### 9.1. Mean Squared Error (MSE)

**MSE** – średni błąd kwadratowy.

Dla `n` obserwacji:

- `MSE = (1 / n) * Σ (y_i - ŷ_i)^2`

Cechy:

- mocno karze duże błędy (kwadrat).

---

### 9.2. Root Mean Squared Error (RMSE)

**RMSE** – pierwiastek z MSE:

- `RMSE = sqrt(MSE)`

Cechy:

- ma tę samą jednostkę co `y` (np. zł, metry),
- łatwiejszy do interpretacji niż MSE.

---

### 9.3. Mean Absolute Error (MAE)

**MAE** – średni błąd bezwzględny.

- `MAE = (1 / n) * Σ |y_i - ŷ_i|`

Cechy:

- mniej wrażliwy na extreme outliery niż MSE/RMSE,
- błąd „średni dystans” między `y` a `ŷ`.

---

### 9.4. Kiedy którą metrykę?

- jeśli **duże błędy są bardzo kosztowne** → MSE/RMSE często sensowniejsze,
- jeśli chcemy **robustnej miary**, mniej wrażliwej na pojedyncze outliery → MAE może być lepszy.

---

## 10. Workflow pracy z modelem ML

Typowy pipeline:

1. **Analiza problemu biznesowego**
   - Co chcemy przewidzieć?
   - Po co? Jak będziemy używać wyniku?

2. **Zrozumienie danych**
   - Skąd dane pochodzą?
   - Jakie mamy cechy i etykiety?
   - Czy dane są kompletne?

3. **Analiza i eksploracja danych (EDA)**
   - statystyki opisowe,
   - wykresy (rozkłady, korelacje),
   - szukanie braków, dziwnych wartości.

4. **Inżynieria cech**
   - wybór cech,
   - kodowanie kategorii (one-hot),
   - skalowanie,
   - tworzenie cech pochodnych.

5. **Podział na zbiory**
   - train/test (czasem też walidacyjny),
   - np. 80/20, 70/30 – zależnie od wielkości zbioru.

6. **Wybór modelu**
   - klasyfikacja vs regresja,
   - prosty model bazowy (baseline),
   - bardziej złożone modele, jeśli potrzebne.

7. **Wybór metryk**
   - dopasowanych do problemu biznesowego,
   - np. przy rare-event:
     - accuracy może być mylące,
     - ważniejsze precision/recall/F1, AUC.

8. **Trening modelu**
   - `fit` na danych treningowych.

9. **Testowanie modelu**
   - `predict` na danych testowych,
   - liczenie metryk,
   - porównanie różnych modeli.

10. **Analiza wyników i iteracja**
    - co działa dobrze, co źle?
    - czy potrzebujemy innych cech?
    - czy metryka jest wystarczająca biznesowo?

11. **Przygotowanie do wdrożenia (późniejsze bloki)**
    - stabilność modelu w czasie,
    - monitoring, re-trening.

W tym bloku przejdziemy przez uproszczoną wersję tego workflow na prostym przykładzie.

---

## 11. scikit-learn – podstawy API

`scikit-learn` to popularna biblioteka ML w Pythonie.

### 11.1. Estimator pattern

Większość modeli w `scikit-learn` działa według tego samego schematu:

1. Importujesz klasę modelu:

   ~~~python
   from sklearn.linear_model import LinearRegression
   ~~~

2. Tworzysz obiekt modelu:

   ~~~python
   model = LinearRegression()
   ~~~

3. Trenujesz model na danych treningowych:

   ~~~python
   model.fit(X_train, y_train)
   ~~~

4. Przewidujesz na danych testowych:

   ~~~python
   y_pred = model.predict(X_test)
   ~~~

5. Liczysz metryki:

   ~~~python
   from sklearn.metrics import mean_squared_error

   mse = mean_squared_error(y_test, y_pred)
   ~~~

Ten wzorzec jest spójny dla:

- modeli klasyfikacyjnych (np. `LogisticRegression`, `RandomForestClassifier`),
- modeli regresyjnych (np. `LinearRegression`, `RandomForestRegressor`),
- narzędzi przetwarzających dane (np. `StandardScaler`, `OneHotEncoder` – też mają `fit`, `transform`).

---

### 11.2. train_test_split

Funkcja do dzielenia danych:

- z `sklearn.model_selection`:

  ~~~python
  from sklearn.model_selection import train_test_split

  X_train, X_test, y_train, y_test = train_test_split(
      X, y,
      test_size=0.2,
      random_state=42
  )
  ~~~

Parametry:

- `test_size` – procent danych do testu (np. 0.2 = 20%),
- `random_state` – ustala losowość, aby wyniki były powtarzalne.

---

### 11.3. Prosty przykład modelu klasyfikacyjnego

Załóżmy:

- dane `X` (np. wiek, kraj, typ urządzenia),
- etykieta `y` (np. `purchase` 0/1).

Schemat:

1. Podział danych:

   ~~~python
   X_train, X_test, y_train, y_test = train_test_split(
       X, y, test_size=0.2, random_state=42
   )
   ~~~

2. Wybór modelu:

   ~~~python
   from sklearn.linear_model import LogisticRegression

   model = LogisticRegression()
   ~~~

3. Trening:

   ~~~python
   model.fit(X_train, y_train)
   ~~~

4. Predykcja:

   ~~~python
   y_pred = model.predict(X_test)
   ~~~

5. Metryka:

   ~~~python
   from sklearn.metrics import accuracy_score

   acc = accuracy_score(y_test, y_pred)
   print("Accuracy:", acc)
   ~~~

W kolejnych blokach rozbudujemy to o:

- inżynierię cech z `ColumnTransformer`,
- `Pipeline`,
- więcej modeli i metryk.

---

## 12. Podsumowanie

Najważniejsze rzeczy z tego pliku:

1. **AI** – szerokie pojęcie, **ML** – uczenie się z danych, **DL** – głębokie sieci neuronowe.
2. Główne typy problemów:
   - **klasyfikacja** (kategorie),
   - **regresja** (wartości ciągłe),
   - **klasteryzacja**, **redukcja wymiarowości** (unsupervised).
3. Każdy problem ML ma:
   - cechy (`X`),
   - etykietę (`y`) – w supervised learning.
4. Model:
   - uczy się na zbiorze treningowym,
   - sprawdzamy go na zbiorze testowym,
   - chcemy dobrej **generalizacji**.
5. **Bias–variance**:
   - zbyt prosty model → underfitting,
   - zbyt skomplikowany → overfitting.
6. Inżynieria cech:
   - one-hot encoding, skalowanie/standaryzacja,
   - przygotowanie danych ma ogromny wpływ na model.
7. Metryki:
   - klasyfikacja: confusion matrix, accuracy, precision, recall, F1, ROC/AUC (intuicja),
   - regresja: MSE, RMSE, MAE.
8. Workflow ML:
   - problem → dane → cechy → model → metryki → iteracja.
9. `scikit-learn`:
   - spójny interfejs (`fit`, `predict`),
   - `train_test_split` do podziału danych.

W praktyce najlepiej uczyć się tych pojęć w trakcie **ćwiczeń** – ten dokument ma pomóc, gdy coś Ci się pomiesza lub będziesz potrzebować ściągi przed kolejnymi blokami.