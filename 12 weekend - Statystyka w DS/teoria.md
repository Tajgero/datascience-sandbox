# Statystyka w Data Science

Ten plik to skrócone, praktyczne kompendium do bloku o statystyce.  
Nie jest to podręcznik akademicki – ma Ci pomóc **zrozumieć intuicję** i **zobaczyć, jak używać statystyki w Pythonie**.

Kiedy zobaczysz wzór – traktuj go jak skrót myślowy, a nie cel sam w sobie.  
Najważniejsze: co liczymy, po co i jak to odczytać w kontekście biznesowym.

---

## 0. Rzut oka z góry – mapa pojęć

1. **Zbiory i zdarzenia** – opisujemy, co może się wydarzyć (np. kto kliknął, kto kupił).
2. **Prawdopodobieństwo** – mówimy, jak bardzo coś jest prawdopodobne (0–1).
3. **Prawdopodobieństwo warunkowe i Bayes** – „jak zmienia się nasza wiedza, gdy wiemy coś więcej”.
4. **Zmienna losowa i rozkłady** – ile czegoś się dzieje (np. ile kliknięć, jaka wartość koszyka).
5. **Parametry rozkładu** – średnia, mediana, wariancja, kwantyle itd.
6. **Estymacja** – wnioskujemy o populacji z próby.
7. **Testy statystyczne** – sprawdzamy, czy różnice są raczej „z przypadku” czy „realne”.

---

## 1. Zbiory i zdarzenia

### 1.1. Eksperyment losowy

**Eksperyment losowy** – procedura, której wynik jest niepewny, ale znamy możliwe rezultaty.

Przykłady:
- rzut monetą (orzeł / reszka),
- wysłanie mailingu (kliknie / nie kliknie),
- wejście użytkownika do sklepu (kupi / nie kupi / doda do koszyka).

**Przestrzeń zdarzeń elementarnych** (często oznaczana Ω) – zbiór wszystkich możliwych wyników.
- Dla monety: Ω = {orzeł, reszka}
- Dla kampanii: Ω = {kliknął, nie kliknął}

### 1.2. Zbiory i operacje

Zdarzenia traktujemy jak zbiory wyników.

- **Zdarzenie elementarne** – pojedynczy możliwy wynik (np. „wypadł orzeł”).
- **Zdarzenie losowe** – dowolny zbiór wyników z Ω (np. „wypadł orzeł albo reszka” – czyli całe Ω).
- **Zdarzenie pewne** – zajdzie zawsze (to samo co Ω).
- **Zdarzenie niemożliwe** – nigdy nie zajdzie (zbiór pusty ∅).

Operacje:

- **Suma zdarzeń (A ∪ B)** – „A lub B”:
  - przykład: „kliknął maila lub kupił produkt”.
- **Iloczyn zdarzeń (A ∩ B)** – „A i B jednocześnie”:
  - przykład: „kliknął maila i kupił produkt”.
- **Różnica (A \ B)** – „A, ale nie B”:
  - przykład: „kliknął maila, ale nie kupił”.
- **Dopełnienie (Aᶜ)** – „nie A”:
  - przykład: A = „kliknął”, Aᶜ = „nie kliknął”.

Zdarzenia **parami rozłączne** – nie mogą zajść jednocześnie (np. „kliknął” vs „nie kliknął”).

### 1.3. Prosty przykład w Pythonie

Załóżmy eksperyment: wybieramy losowego użytkownika i sprawdzamy, co zrobił.

~~~python
users = [
    {"user_id": 1, "clicked": True,  "bought": False},
    {"user_id": 2, "clicked": True,  "bought": True},
    {"user_id": 3, "clicked": False, "bought": False},
    {"user_id": 4, "clicked": False, "bought": True},
]

# Zdarzenie A: "uzytkownik kliknal"
# Zdarzenie B: "uzytkownik kupil"

A = [u for u in users if u["clicked"]]
B = [u for u in users if u["bought"]]

# Suma zdarzen: kliknal LUB kupil
A_or_B = [u for u in users if u["clicked"] or u["bought"]]

# Iloczyn zdarzen: kliknal I kupil
A_and_B = [u for u in users if u["clicked"] and u["bought"]]
~~~

---

## 2. Prawdopodobieństwo

Prawdopodobieństwo to liczba od 0 do 1:
- 0 – zdarzenie niemożliwe,
- 1 – zdarzenie pewne,
- np. 0.3 – w długim okresie zdarzenie zajdzie w ok. 30% przypadków.

### 2.1. Aksjomaty (intuicyjnie)

Dla zdarzenia A:
1. 0 ≤ P(A) ≤ 1
2. P(Ω) = 1
3. Jeśli A i B nie mogą zajść jednocześnie (są rozłączne), to:
   - P(A ∪ B) = P(A) + P(B)

W praktyce rzadko piszemy „aksjomat 1…”, ale ważne, by pamiętać:
- prawdopodobieństwo nie jest ujemne,
- nie przekracza 1,
- prawdopodobieństwa rozłącznych zdarzeń się sumują.

### 2.2. Klasyczna interpretacja

Jeśli wszystkie wyniki są **równie prawdopodobne**, to:

P(A) = (liczba wyników sprzyjających A) / (liczba wszystkich wyników)

Przykład:
- rzut uczciwą kostką,
- Ω = {1,2,3,4,5,6},
- zdarzenie A = „wypadnie liczba parzysta” = {2,4,6},
- P(A) = 3/6 = 0.5.

### 2.3. Statystyczna interpretacja

Gdy eksperyment powtarzamy wiele razy, często liczymy:
P(A) ≈ liczba razy, gdy A zaszło / liczba wszystkich prób

Przykład:
- wysyłamy newsletter do 10 000 użytkowników,
- 1 230 osób kliknęło,
- „doświadczalne” prawdopodobieństwo kliknięcia ≈ 1230 / 10000 = 0.123.

### 2.4. Prosty przykład w Pythonie

~~~python
import random

# Symulacja: rzut uczciwa moneta 10000 razy
n = 10000
results = [random.choice(["H", "T"]) for _ in range(n)]

count_heads = results.count("H")
p_heads = count_heads / n
print("P(Orzel) ~", p_heads)
~~~

Im więcej powtórzeń, tym wynik będzie bliżej 0.5.

---

## 3. Prawdopodobieństwo warunkowe i Twierdzenie Bayesa

### 3.1. Prawdopodobieństwo warunkowe

**Prawdopodobieństwo warunkowe** P(A|B) – prawdopodobieństwo A, **gdy wiemy, że zaszło B**.

Przykład:
- A = „użytkownik kupił”,
- B = „użytkownik kliknął maila”,
- P(A|B) – szansa na zakup wśród tych, którzy kliknęli.

Wzór (intuicyjnie):
P(A|B) = liczba przypadków, gdzie A i B / liczba przypadków, gdzie B

W Pythonie – np.:

~~~python
# P(A|B): P(kupil | kliknal)
clicked = [u for u in users if u["clicked"]]
clicked_and_bought = [u for u in clicked if u["bought"]]

p_buy_given_click = len(clicked_and_bought) / len(clicked)
print("P(kupil | kliknal) =", p_buy_given_click)
~~~

### 3.2. Prawdopodobieństwo całkowite (pełne)

Gdy przestrzeń dzielimy na rozłączne zdarzenia B1, B2, ..., Bn, to:
- P(A) = Σ P(A|Bi) * P(Bi)

Intuicja:
- liczymy P(A) jako sumę „wkładów” z każdej podgrupy.

Przykład:
- A = „użytkownik kupił”,
- zupełny podział: B1 = „przyszedł z SEO”, B2 = „z ads”, B3 = „direct”,
- P(A) = P(A|SEO)*P(SEO) + P(A|ads)*P(ads) + P(A|direct)*P(direct).

### 3.3. Twierdzenie Bayesa

Bayes „odwraca” warunek:
- chcemy P(A|B),
- znamy P(B|A), P(A) i P(B).

Wzór:
P(A|B) = P(B|A) * P(A) / P(B)

Intuicja:
- P(A) – wcześniejsza wiedza („priory”), np. rzadkość fraudu,
- P(B|A) – jak często widzimy B, gdy A jest prawdziwe,
- P(A|B) – zaktualizowana wiedza po zaobserwowaniu B.

Przykład:
- A = „transakcja jest fraudem”,
- B = „kwota > 1000 zł”,
- P(A|B) – jak bardzo powinniśmy się przejmować transakcją > 1000 zł.

W praktyce w Data Science często liczymy to „ręcznie” z tabelą:

~~~python
import pandas as pd

df = pd.DataFrame([
    {"amount": 50,   "is_fraud": 0},
    {"amount": 5000, "is_fraud": 1},
    {"amount": 2000, "is_fraud": 0},
    # ...
])

df["high_amount"] = df["amount"] > 1000

# P(A): fraud rate w calym zbiorze
p_A = df["is_fraud"].mean()

# P(B): odsetek transakcji z kwota > 1000
p_B = df["high_amount"].mean()

# P(B|A): w jakiej czesci fraudow kwota > 1000
p_B_given_A = df[df["is_fraud"] == 1]["high_amount"].mean()

# P(A|B) wg Bayesa
p_A_given_B = p_B_given_A * p_A / p_B
print("P(fraud | high_amount) =", p_A_given_B)
~~~

---

## 4. Zmienne losowe i dystrybuanta

### 4.1. Zmienna losowa

**Zmienna losowa** – liczba, której wartość zależy od losowego wyniku eksperymentu.

Przykłady:
- liczba kliknięć w mailu,
- liczba zakupów w dniu,
- wartość koszyka (w zł).

Rodzaje:
- **dyskretna** – przyjmuje wartości „skaczące” (0,1,2,3,…),
- **ciągła** – przyjmuje wartości z przedziału (np. dowolna wartość realna w [0, ∞)).

Przykład dyskretnej:
- X = liczba kliknięć w danym dniu,
- wartości: 0, 1, 2, 3, ...

Przykład ciągłej:
- Y = wartość transakcji,
- wartości: np. 0.01, 23.50, 199.99, ...

### 4.2. Rozkład prawdopodobieństwa

**Rozkład** mówi, z jakimi prawdopodobieństwami zmienna przyjmuje różne wartości.

- Zmienna dyskretna: rozkład to lista par:
  - P(X=0), P(X=1), P(X=2), ...
- Zmienna ciągła: opisuje go **gęstość** f(x) (PDF),
  - prawdopodobieństwo, że X wpadnie do małego przedziału [a,b], to mniej więcej pole pod wykresem f(x) na [a,b].

W Pythonie rozkład często widzimy przez:
- histogram,
- funkcje z `scipy.stats` (np. `stats.norm`, `stats.poisson`).


### 4.3. Dystrybuanta (CDF)

**Dystrybuanta** F(x) – funkcja:
- F(x) = P(X ≤ x).

Intuicja:
- dla każdej wartości x pokazuje „jaki procent obserwacji jest mniejszy lub równy x”.

Praktycznie:
- w `pandas` dystrybuantę można aproksymować np. przez sortowanie i liczenie odsetka.

---

## 5. Parametry rozkładu i momenty

Parametry opisują „kształt” rozkładu.

### 5.1. Parametry położenia

- **Średnia (mean)** – „punkt równowagi”:
  - bardzo wrażliwa na wartości odstające (outliers).
- **Mediana (median)** – wartość, która dzieli dane na pół:
  - 50% obserwacji jest ≤ mediany, 50% ≥,
  - odporna na outliers.
- **Moda (mode)** – najczęstsza wartość:
  - sensowna głównie dla kategorii / liczb dyskretnych.

W Pythonie (dla DataFrame `df`):

~~~python
df["value"].mean()
df["value"].median()
df["value"].mode()  # zwraca Series, moze byc kilka mod
~~~

### 5.2. Parametry rozproszenia

- **Wariancja (variance)** – uśredniony kwadrat odchylenia od średniej:
  - im większa wariancja, tym większy „rozrzut” danych.
- **Odchylenie standardowe (standard deviation, std)** – pierwiastek z wariancji:
  - ta sama jednostka co dane (łatwiejsze do interpretacji),
  - ~„typowy rozrzut wokół średniej”.
- **Odchylenie przeciętne** – średnia odległość od średniej/median – używane rzadziej, ale intuicyjne.

W Pythonie:

~~~python
df["value"].var()   # wariancja z próby
df["value"].std()   # odchylenie standardowe
~~~

### 5.3. Parametry kształtu

- **Skośność (skewness)** – czy ogon rozkładu jest bardziej w prawo czy w lewo:
  - skośność dodatnia – długi ogon w prawo (np. zarobki, wartości koszyków),
  - skośność ujemna – długi ogon w lewo.
- **Kurtoza (kurtosis)** – „spiczastość” rozkładu:
  - wysokie piki vs bardziej „płaski” rozkład.

Intuicja:
- w praktyce: bardzo duża skośność/kurtoza może sugerować obecność outliers i problemów dla niektórych modeli.

### 5.4. Kwantyle

**Kwantyl** q – wartość, poniżej której leży q% danych.

- 0.5 – mediana,
- 0.25 – pierwszy kwartyl (Q1),
- 0.75 – trzeci kwartyl (Q3),
- IQR (interquartile range) = Q3 – Q1 – opisuje „środkowy rozrzut”.

W Pythonie:

~~~python
df["value"].quantile(0.25)  # Q1
df["value"].quantile(0.5)   # mediana
df["value"].quantile(0.75)  # Q3
~~~

---

## 6. Najważniejsze rozkłady w Data Science

Poniżej bardzo skrócone, praktyczne opisy.

### 6.1. Rozkłady dyskretne

#### Bernoulli (dwupunktowy: 0/1)

- X ∈ {0,1},
- P(X=1) = p, P(X=0) = 1-p.
- Przykład: kliknięcie (kliknął/nie), fraud (tak/nie).

W Pythonie:
- pojedyncza próba – losowanie z {0,1},
- wiele prób – lista 0/1.

~~~python
import numpy as np
clicks = np.random.binomial(n=1, p=0.2, size=1000)  # 1000 uzytkownikow, prawd. klik = 0.2
~~~

#### Dwumianowy (binomial)

- Liczba sukcesów w n próbach Bernoulliego.
- Przykład: ile osób kliknęło maila spośród 100 wysłanych.

~~~python
# 100 wysylek, prawdopodobienstwo klikniecia p=0.2
np.random.binomial(n=100, p=0.2, size=1)
~~~

#### Geometryczny

- Liczba prób do pierwszego sukcesu.
- Przykład: ile prób logowania, zanim użytkownik poda poprawne hasło (w uproszczeniu).

#### Poissona

- Liczba zdarzeń w stałym przedziale czasu (przestrzeni), gdy zdarzenia są „rzadkie”.
- Przykład: liczba zgłoszeń do helpdesku na godzinę.

~~~python
# srednio 5 zgloszen na godzine
np.random.poisson(lam=5, size=1000)
~~~

### 6.2. Rozkłady ciągłe

#### Ciągły rozkład jednostajny

- Wszystkie wartości w pewnym przedziale są „tak samo prawdopodobne”.
- Przykład: losowy czas w ciągu godziny, w którym pojawia się zdarzenie (przy bardzo silnym uproszczeniu).

~~~python
# losowa liczba z przedzialu [0, 1]
np.random.uniform(0, 1, size=1000)
~~~

#### Rozkład normalny (Gaussa)

- „Dzwon” – symetryczny rozkład wokół średniej.
- Przykład: wzrost ludzi, wiele błędów pomiarowych, przybliżenie sum wielu małych losowych efektów (CLT).

Parametry:
- μ (mu) – średnia,
- σ (sigma) – odchylenie standardowe.

~~~python
# srednia 0, odchylenie 1
np.random.normal(loc=0, scale=1, size=1000)
~~~

#### Rozkład wykładniczy

- Czas oczekiwania na zdarzenie, które zachodzi ze stałą średnią intensywnością.
- Przykład: czas do kolejnego zgłoszenia do helpdesku.

#### Rozkład gamma

- Uogólnienie wykładniczego (czas do k-tego zdarzenia).
- Przykład: czas do wystąpienia kilku zdarzeń (rzadziej używany bezpośrednio, ważny w modelach liczących).

#### Rozkład beta

- Zmienna w [0,1], różne kształty w zależności od parametrów.
- Przykład: rozkład prawdopodobieństwa konwersji dla kampanii (w inferencji Bayesowskiej).

---

## 7. Estymacja parametrów rozkładu

**Estymacja** – wnioskowanie o parametrze populacji na podstawie próby.

Przykład:
- Interesuje nas „prawdziwa” średnia wartość koszyka wszystkich klientów,
- mamy dane tylko z 10 000 losowych transakcji,
- estymujemy średnią populacyjną jako średnią z próby.

Typowe parametry, które estymujemy:
- średnia μ (mean),
- wariancja σ² (variance),
- proporcja p (np. odsetek fraudów).

Najprostsza estymacja:
- po prostu liczymy te parametry na danych, które mamy.

Przykład w Pythonie:

~~~python
import pandas as pd

orders = [
    {"order_id": 1, "value": 100},
    {"order_id": 2, "value": 50},
    {"order_id": 3, "value": 200},
    # ...
]

df_orders = pd.DataFrame(orders)

mean_value = df_orders["value"].mean()   # estymacja sredniej
std_value = df_orders["value"].std()     # estymacja odchylenia standardowego
~~~

W dalszej części pojawi się pojęcie **przedziałów ufności**, ale w tym bloku skupiamy się na:
- zrozumieniu idei estymatora,
- korzystaniu z prostych testów statystycznych.

---

## 8. Testy statystyczne

Testy statystyczne odpowiadają na pytanie:
> Czy zaobserwowane różnice/efekty są na tyle duże, że trudno je wyjaśnić przypadkiem?

### 8.1. Ogólna procedura testu

1. **Formułujemy hipotezy:**
   - H0 (hipoteza zerowa) – „nic się nie zmieniło”, „brak różnicy”.
   - H1 (hipoteza alternatywna) – „coś się zmieniło”, „jest różnica”.

2. **Liczymy statystykę testową** – pewną liczbę, która mierzy „jak bardzo nasz świat różni się od świata H0”.

3. **Obliczamy p-wartość** – prawdopodobieństwo uzyskania wyniku co najmniej tak ekstremalnego, jak zaobserwowany, jeśli H0 jest prawdziwa.

4. **Porównujemy p-wartość z poziomem istotności α** (np. 0.05):
   - jeśli p ≤ α – odrzucamy H0 (mówimy, że wynik jest statystycznie istotny),
   - jeśli p > α – nie mamy podstaw, by odrzucić H0 (ale nie „udowadniamy H0”).

### 8.2. Błąd I i II rodzaju

- **Błąd I rodzaju (fałszywy alarm)** – odrzucamy H0, gdy jest prawdziwa.
- **Błąd II rodzaju (fałszywy spokój)** – nie odrzucamy H0, gdy H1 jest prawdziwa.

Poziom istotności α to tak naprawdę:
- maksymalne dopuszczalne prawdopodobieństwo błędu I rodzaju.

### 8.3. P-wartość – jak o niej myśleć

**P-wartość** to:
- przy założeniu, że H0 jest prawdziwa,
- prawdopodobieństwo zaobserwowania takiej (lub bardziej ekstremalnej) statystyki,
- jaką widzimy w danych.

Nie jest to:
- prawdopodobieństwo, że H0 jest prawdziwa/nieprawdziwa.

W praktyce:
- mała p-wartość → dane są mało „zgodne” z H0.

---

## 9. Konkretnie: najczęstsze testy w tym bloku

Wszystkie z `scipy.stats`.

### 9.1. Test t-Studenta (dwie niezależne próbki)

Cel:
- porównać średnie dwóch grup.

Przykład:
- średnia wartość koszyka w grupie A i B (A/B test).

Hipotezy:
- H0: średnia_A = średnia_B,
- H1: średnia_A ≠ średnia_B (test dwustronny).

W Pythonie (uproszczony przykład):

~~~python
from scipy import stats

# df_ab: DataFrame z kolumnami "group" (A/B) i "value"
group_A = df_ab[df_ab["group"] == "A"]["value"]
group_B = df_ab[df_ab["group"] == "B"]["value"]

t_stat, p_value = stats.ttest_ind(group_A, group_B, equal_var=False)
print("t_stat =", t_stat, "p_value =", p_value)
~~~

Interpretacja:
- mała p-wartość (np. < 0.05) – raczej „jest realna różnica” w średnich,
- duża p-wartość – dane nie dają mocnych dowodów na różnicę.

### 9.2. Test chi-kwadrat (zależność cech jakościowych)

Cel:
- sprawdzić, czy dwie zmienne kategoryczne są niezależne.

Przykład:
- czy kanał pozyskania (SEO, ads, direct) jest powiązany z konwersją (0/1)?

Etapy:
1. Budujemy **tabelę kontyngencji** (np. `pd.crosstab`).
2. Wywołujemy `chi2_contingency`.

~~~python
import pandas as pd
from scipy.stats import chi2_contingency

# df_marketing: kolumny "channel" i "converted" (0/1)
contingency = pd.crosstab(df_marketing["channel"], df_marketing["converted"])
chi2, p_value, dof, expected = chi2_contingency(contingency)

print("chi2 =", chi2, "p_value =", p_value)
~~~

Interpretacja:
- H0: brak zależności między zmiennymi,
- mała p-wartość – kanał pozyskania i konwersja są powiązane,
- duża p-wartość – nie widzimy silnych dowodów na związek.

### 9.3. Test Kolmogorova-Smirnova (KS)

Cel:
- porównać, czy dwa rozkłady są takie same.

Przykład:
- czy rozkład wartości zamówień **przed** kampanią i **po** kampanii jest taki sam?

~~~python
from scipy.stats import ks_2samp

values_before = df[df["period"] == "before"]["value"]
values_after  = df[df["period"] == "after"]["value"]

stat, p_value = ks_2samp(values_before, values_after)
print("KS stat =", stat, "p_value =", p_value)
~~~

Interpretacja:
- H0: oba rozkłady są takie same,
- mała p-wartość – rozkłady różnią się,
- duża p-wartość – brak silnych dowodów na różnicę.

---

## 10. Jak łączyć to z Machine Learning?

Kilka typowych powiązań:

1. **Analiza danych wejściowych do modelu**:
   - sprawdzasz rozkład zmiennych (normalność, outliers),
   - patrzysz na mean, median, std, kwantyle.

2. **Porównanie modeli**:
   - accuracy / AUC / inne metryki można traktować jak zmienne losowe,
   - porównujesz wyniki na różnych próbach (np. w cross-validation),
   - w bardziej zaawansowanych scenariuszach – testy istotności różnic.

3. **A/B testy**:
   - nowy model vs stary model,
   - nowy interfejs vs stary interfejs,
   - używasz testów statystycznych (t, chi-kwadrat) do decyzji biznesowych.

4. **Rozumienie niepewności**:
   - model daje punktową predykcję, ale dane są losowe,
   - statystyka pozwala ocenić, jak bardzo ufamy wynikom (estymacja, rozkłady, testy).

---

## 11. Minimalna ściąga – co warto zapamiętać

1. **Prawdopodobieństwo**:
   - liczba od 0 do 1,
   - P(A|B) ≠ P(B|A),
   - ostrożnie z interpretacją.

2. **Zmienna losowa**:
   - dyskretna (0,1,2,...) vs ciągła (przedziały realne),
   - rozkład – mówi, jak często widzimy poszczególne wartości.

3. **Parametry rozkładu**:
   - mean, median, mode,
   - variance, std,
   - kwantyle.

4. **Estymacja**:
   - próba ≈ „mały kawałek populacji”,
   - estymator ≈ „nasza najlepsza zgadywanka na podstawie próby”.

5. **Test statystyczny**:
   - H0 / H1,
   - statystyka testowa,
   - p-wartość,
   - błąd I / II rodzaju.

6. **Konkrety w Pythonie**:
   - `pandas` – statystyki opisowe (`mean`, `median`, `std`, `quantile`),
   - `numpy.random` – generowanie danych,
   - `scipy.stats` – testy (`ttest_ind`, `chi2_contingency`, `ks_2samp`).

Jeśli na coś patrzysz i nie wiesz, „jaki to rozkład i co to znaczy”:
- narysuj histogram,
- policz podstawowe statystyki opisowe,
- spróbuj opisać to słowami („większość tu, trochę tam, ogon w prawo/ lewo”).

To jest dokładnie to, co robi wielu praktyków Data Science na co dzień 🙂