# Rozwiązania zadań - Git dla początkujących

## Spis treści
1. [Zadania podstawowe (1-5)](#zadania-podstawowe)
2. [Zadania z branchingiem (6-9)](#zadania-z-branchingiem)
3. [Zadania z cofaniem zmian (10-12)](#zadania-z-cofaniem-zmian)
4. [Zadania zaawansowane (13-15)](#zadania-zaawansowane)

---

## Zadania podstawowe

### Zadanie 1: Pierwsze repozytorium

**Rozwiązanie krok po kroku:**

1. **Utworzenie folderu i wejście do niego:**
   ```bash
   mkdir kalkulator_projekt
   cd kalkulator_projekt
   ```
   **Wyjaśnienie:** `mkdir` tworzy nowy folder, `cd` zmienia aktualny katalog na ten folder.

2. **Inicjalizacja repozytorium Git:**
   ```bash
   git init
   ```
   **Wyjaśnienie:** Komenda `git init` tworzy ukryty folder `.git/` zawierający wszystkie dane repozytorium (historię, konfigurację, itp.). Od tego momentu Git śledzi ten folder.
   
   **Oczekiwany output:**
   ```
   Initialized empty Git repository in /Users/twoja-sciezka/kalkulator_projekt/.git/
   ```

3. **Konfiguracja nazwy użytkownika:**
   ```bash
   git config --global user.name "Jan Kowalski"
   ```
   **Wyjaśnienie:** Ustawiasz swoją nazwę, która będzie widoczna w commitach. Flaga `--global` oznacza, że ta konfiguracja będzie używana we wszystkich repozytoriach na tym komputerze.

4. **Konfiguracja emaila:**
   ```bash
   git config --global user.email "jan.kowalski@example.com"
   ```
   **Wyjaśnienie:** Podobnie jak nazwa - email będzie zapisany w każdym commicie. To ważne dla współpracy i identyfikacji autora zmian.

5. **Weryfikacja konfiguracji:**
   ```bash
   git config user.name
   git config user.email
   ```
   **Oczekiwany output:**
   ```
   Jan Kowalski
   jan.kowalski@example.com
   ```

6. **Sprawdzenie czy repozytorium działa:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main

   No commits yet

   nothing to commit (create/copy files and use "git add" to track)
   ```

**Dlaczego to działa:**
Git potrzebuje znać twoją tożsamość, żeby zapisać kto wykonał każdy commit. Folder `.git/` zawiera całą bazę danych zmian - bez niego Git nie wie że to jest repozytorium.

**Częste błędy:**
- ❌ Zapomnienie `cd kalkulator_projekt` → komendy wykonywane w złym folderze
- ❌ Brak konfiguracji użytkownika → Git będzie pytał przy pierwszym commicie
- ❌ Dwukrotne `git init` w tym samym folderze → nic się nie stanie, ale niepotrzebne

**Alternatywnie:**
Możesz skonfigurować użytkownika lokalnie (tylko dla tego repo):
```bash
git config user.name "Jan Kowalski"  # bez --global
```

---

### Zadanie 2: Pierwszy commit

**Rozwiązanie krok po kroku:**

1. **Utworzenie pliku `kalkulator.py`:**
   
   Otwórz edytor tekstu (VS Code, PyCharm, Notepad++, etc.) i utwórz plik `kalkulator.py` z zawartością:
   
   ```python
   def dodaj(a, b):
       return a + b

   if __name__ == "__main__":
       print(dodaj(5, 3))
   ```
   
   Zapisz plik w folderze `kalkulator_projekt`.

2. **Utworzenie pliku `README.md`:**
   
   W tym samym folderze utwórz plik `README.md` z zawartością:
   
   ```markdown
   # Kalkulator
   Prosty kalkulator w Pythonie
   ```

3. **Sprawdzenie statusu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main

   No commits yet

   Untracked files:
     (use "git add <file>..." to include in what will be committed)
           README.md
           kalkulator.py

   nothing added to commit but untracked files present (use "git add" to track)
   ```
   **Wyjaśnienie:** "Untracked files" oznacza pliki, które Git widzi, ale jeszcze nie śledzi.

4. **Dodanie plików do staging area:**
   ```bash
   git add kalkulator.py README.md
   ```
   Lub:
   ```bash
   git add .
   ```
   **Wyjaśnienie:** `git add` przenosi pliki z "untracked" do "staged" (gotowe do commita). Kropka `.` oznacza "wszystkie zmienione pliki w tym folderze".

5. **Sprawdzenie statusu po dodaniu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main

   No commits yet

   Changes to be committed:
     (use "git rm --cached <file>..." to unstage)
           new file:   README.md
           new file:   kalkulator.py
   ```
   **Wyjaśnienie:** Teraz pliki są w "staging area" - gotowe do commita. Kolor w terminalu zmienił się na zielony (w większości terminalów).

6. **Wykonanie commita:**
   ```bash
   git commit -m "Utworzono podstawową strukturę projektu"
   ```
   **Oczekiwany output:**
   ```
   [main (root-commit) a3f5b81] Utworzono podstawową strukturę projektu
    2 files changed, 7 insertions(+)
    create mode 100644 README.md
    create mode 100644 kalkulator.py
   ```
   **Wyjaśnienie:** Git utworzył snapshot (migawkę) projektu. Hash `a3f5b81` to unikalny identyfikator tego commita.

7. **Sprawdzenie historii:**
   ```bash
   git log
   ```
   **Oczekiwany output:**
   ```
   commit a3f5b81d8f9e123abc456def789... (pełny hash)
   Author: Jan Kowalski <jan.kowalski@example.com>
   Date:   Sun Dec 14 10:30:00 2025 +0100

       Utworzono podstawową strukturę projektu
   ```

8. **Sprawdzenie czystego stanu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   nothing to commit, working tree clean
   ```

**Dlaczego to działa:**
Git zapisuje migawki plików, nie różnice. Commit zawiera pełny obraz projektu w tym momencie. Staging area pozwala wybrać które zmiany chcesz commitnąć (nie musisz commitować wszystkiego naraz).

**Częste błędy:**
- ❌ `git commit` bez `-m` → otwiera edytor (vim) co może być trudne dla początkujących
- ❌ Pusty komunikat commita → Git nie pozwoli
- ❌ `git commit` przed `git add` → nic nie zostanie commitnięte

**Alternatywnie:**
Commit wszystkich zmienionych plików (bez staging):
```bash
git commit -am "Wiadomość"  # tylko dla już śledzonych plików!
```

---

### Zadanie 3: Modyfikacja i śledzenie zmian

**Rozwiązanie krok po kroku:**

1. **Edycja pliku `kalkulator.py`:**
   
   Otwórz plik `kalkulator.py` i dodaj na końcu pliku następujące funkcje:
   
   ```python
   def odejmij(a, b):
       return a - b

   def pomnoz(a, b):
       return a * b

   def podziel(a, b):
       if b != 0:
           return a / b
       return "Nie można dzielić przez zero"
   ```
   
   Zapisz plik.

2. **Sprawdzenie statusu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   Changes not staged for commit:
     (use "git add <file>..." to update what will be committed)
     (use "git restore <file>..." to discard changes in working directory)
           modified:   kalkulator.py

   no changes added to commit (use "git add" and/or "git commit -a")
   ```
   **Wyjaśnienie:** "modified" (czerwony) oznacza że plik się zmienił, ale zmiany nie są w staging.

3. **Zobaczenie dokładnych zmian (diff):**
   ```bash
   git diff
   ```
   **Oczekiwany output:**
   ```diff
   diff --git a/kalkulator.py b/kalkulator.py
   index abc1234..def5678 100644
   --- a/kalkulator.py
   +++ b/kalkulator.py
   @@ -3,3 +3,13 @@ def dodaj(a, b):
    
    if __name__ == "__main__":
        print(dodaj(5, 3))
   +
   +def odejmij(a, b):
   +    return a - b
   +
   +def pomnoz(a, b):
   +    return a * b
   +
   +def podziel(a, b):
   +    if b != 0:
   +        return a / b
   +    return "Nie można dzielić przez zero"
   ```
   **Wyjaśnienie:** Linie z `+` to dodane linie, linie z `-` to usunięte (tutaj tylko dodawaliśmy).

4. **Dodanie do staging:**
   ```bash
   git add kalkulator.py
   ```

5. **Różnice w staging:**
   ```bash
   git diff --staged
   ```
   Lub:
   ```bash
   git diff --cached
   ```
   **Oczekiwany output:** To samo co wcześniej, ale teraz pokazuje zmiany w staging area.
   
   **Wyjaśnienie:** `git diff` = zmiany niestagowane, `git diff --staged` = zmiany stagowane.

6. **Commit:**
   ```bash
   git commit -m "Dodano funkcje odejmowania, mnożenia i dzielenia"
   ```
   **Oczekiwany output:**
   ```
   [main 9d2e1c4] Dodano funkcje odejmowania, mnożenia i dzielenia
    1 file changed, 10 insertions(+)
   ```

7. **Historia zwięzła:**
   ```bash
   git log --oneline
   ```
   **Oczekiwany output:**
   ```
   9d2e1c4 Dodano funkcje odejmowania, mnożenia i dzielenia
   a3f5b81 Utworzono podstawową strukturę projektu
   ```
   **Wyjaśnienie:** `--oneline` pokazuje tylko hash i wiadomość commita (bez autora, daty).

**Dlaczego to działa:**
`git diff` porównuje working directory z staging area. Po `git add`, porównuje staging area z ostatnim commitem (`git diff --staged`). To pozwala dokładnie kontrolować co committujesz.

**Częste błędy:**
- ❌ Zapomnienie sprawdzenia `git diff` przed commitem → możesz commitnąć coś przez przypadek
- ❌ Mylenie `git diff` z `git diff --staged`

**Alternatywnie:**
Zobacz zmiany dla konkretnego pliku:
```bash
git diff kalkulator.py
```

---

### Zadanie 4: Ignorowanie plików

**Rozwiązanie krok po kroku:**

1. **Symulacja plików Python:**
   ```bash
   mkdir __pycache__
   touch __pycache__/kalkulator.pyc
   ```

2. **Utworzenie pliku konfiguracyjnego:**
   
   Utwórz nowy plik `config.local.py` z zawartością:
   
   ```python
   SECRET_KEY = "super-tajne-haslo-123"
   ```

3. **Sprawdzenie statusu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   Untracked files:
     __pycache__/
     config.local.py
   ```
   **Wyjaśnienie:** Git widzi wszystkie nowe pliki i foldery.

4. **Utworzenie `.gitignore`:**
   
   Utwórz plik `.gitignore` (zauważ kropkę na początku!) z zawartością:
   
   ```gitignore
   # Python compiled files
   __pycache__/
   *.pyc
   *.pyo

   # Local configuration (wrażliwe dane!)
   config.local.py

   # IDE
   .vscode/
   .idea/

   # OS files
   .DS_Store
   Thumbs.db
   ```

5. **Sprawdzenie statusu ponownie:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   Untracked files:
     .gitignore
   ```
   **Wyjaśnienie:** `__pycache__/` i `config.local.py` zniknęły! Git ich teraz ignoruje.

6. **Utworzenie przykładowego pliku config:**
   
   Utwórz plik `config.example.py` z zawartością:
   
   ```python
   # Skopiuj ten plik jako config.local.py i uzupełnij prawdziwe wartości
   SECRET_KEY = "twoje-haslo-tutaj"
   ```

7. **Dodanie do staging:**
   ```bash
   git add .gitignore config.example.py
   ```

8. **Commit:**
   ```bash
   git commit -m "Dodano .gitignore i przykładową konfigurację"
   ```
   **Oczekiwany output:**
   ```
   [main 2b8c930] Dodano .gitignore i przykładową konfigurację
    2 files changed, 15 insertions(+)
    create mode 100644 .gitignore
    create mode 100644 config.example.py
   ```

9. **Weryfikacja historii:**
   ```bash
   git log --oneline
   ```
   **Oczekiwany output:**
   ```
   2b8c930 Dodano .gitignore i przykładową konfigurację
   9d2e1c4 Dodano funkcje odejmowania, mnożenia i dzielenia
   a3f5b81 Utworzono podstawową strukturę projektu
   ```

**Dlaczego to działa:**
Przed każdą operacją Git sprawdza `.gitignore` i pomija pliki/foldery pasujące do wzorców. `.gitignore` sam w sobie JEST śledzony - to ważne, żeby inni programiści też ignorowali te same pliki.

**Częste błędy:**
- ❌ Dodanie pliku do Git PRZED utworzeniem `.gitignore` → trzeba go usunąć z Git: `git rm --cached plik`
- ❌ `.gitignore` w złym miejscu → musi być w głównym folderze repo (lub w podfolderze dla lokalnych reguł)
- ❌ Błędny wzorzec → np. `__pycache__` bez `/` może nie zadziałać jak oczekujesz

**Alternatywnie:**
Sprawdź czy plik jest ignorowany:
```bash
git check-ignore -v config.local.py
```
Output pokaże którą regułą został zignorowany.

---

### Zadanie 5: Podróż w czasie po historii

**Rozwiązanie krok po kroku:**

1. **Pełna historia z detalami:**
   ```bash
   git log
   ```
   **Oczekiwany output:**
   ```
   commit 2b8c930... (pełny hash)
   Author: Jan Kowalski <jan.kowalski@example.com>
   Date:   Sun Dec 14 11:00:00 2025 +0100

       Dodano .gitignore i przykładową konfigurację

   commit 9d2e1c4...
   Author: Jan Kowalski <jan.kowalski@example.com>
   Date:   Sun Dec 14 10:45:00 2025 +0100

       Dodano funkcje odejmowania, mnożenia i dzielenia

   ...
   ```

2. **Historia zwięzła:**
   ```bash
   git log --oneline
   ```
   **Oczekiwany output:**
   ```
   2b8c930 Dodano .gitignore i przykładową konfigurację
   9d2e1c4 Dodano funkcje odejmowania, mnożenia i dzielenia
   a3f5b81 Utworzono podstawową strukturę projektu
   ```

3. **Szczegóły pierwszego commita:**
   ```bash
   git show a3f5b81
   ```
   Lub:
   ```bash
   git show HEAD~2  # 2 commity wstecz
   ```
   **Oczekiwany output:**
   ```diff
   commit a3f5b81...
   Author: Jan Kowalski <jan.kowalski@example.com>
   Date:   Sun Dec 14 10:30:00 2025 +0100

       Utworzono podstawową strukturę projektu

   diff --git a/README.md b/README.md
   new file mode 100644
   index 0000000..abc1234
   --- /dev/null
   +++ b/README.md
   @@ -0,0 +1,2 @@
   +# Kalkulator
   +Prosty kalkulator w Pythonie
   ...
   ```
   **Wyjaśnienie:** `git show` pokazuje szczegóły commita + różnice (diff).

4. **Zmiany w drugim commicie:**
   ```bash
   git show 9d2e1c4
   ```
   **Oczekiwany output:** Commit + diff pokazujący dodane funkcje odejmowania, mnożenia, dzielenia.

5. **Historia tylko dla jednego pliku:**
   ```bash
   git log --oneline kalkulator.py
   ```
   **Oczekiwany output:**
   ```
   9d2e1c4 Dodano funkcje odejmowania, mnożenia i dzielenia
   a3f5b81 Utworzono podstawową strukturę projektu
   ```
   **Wyjaśnienie:** Pokazuje tylko commity, które zmieniały `kalkulator.py`.

6. **Utworzenie podsumowania:**
   
   Utwórz plik `historia.txt` z zawartością:
   
   ```
   Historia projektu Kalkulator:

   Commit 1 (a3f5b81): Utworzono podstawową strukturę
   - Dodano README.md
   - Dodano kalkulator.py z funkcją dodawania

   Commit 2 (9d2e1c4): Rozszerzono funkcjonalność
   - Dodano odejmowanie, mnożenie, dzielenie

   Commit 3 (2b8c930): Konfiguracja repozytorium
   - Dodano .gitignore (Python, IDE, config)
   - Dodano config.example.py
   ```
   
   **Wskazówka:** Hashe commitów mogą być różne u Ciebie - użyj tych z `git log --oneline`.

7. **Commit pliku historia:**
   ```bash
   git add historia.txt
   git commit -m "Dodano podsumowanie historii projektu"
   ```

**Dlaczego to działa:**
Każdy commit ma unikalny hash (SHA-1), który działa jak "adres" commita. Możesz używać pełnego hasha lub pierwszych 7 znaków (git automatycznie rozpozna). `HEAD~N` to skrót oznaczający "N commitów wstecz od HEAD".

**Częste błędy:**
- ❌ Za krótki hash (np. 3 znaki) → może być nieunikalny
- ❌ Mylenie `git show` (konkretny commit) z `git log` (lista commitów)

**Alternatywnie:**
Historia z grafiką:
```bash
git log --oneline --graph --all
```

Zmiany między commitami:
```bash
git diff a3f5b81 9d2e1c4
```

Zobacz plik z konkretnego commita:
```bash
git show a3f5b81:kalkulator.py
```

---

## Zadania z branchingiem

### Zadanie 6: Pierwsza gałąź

**Rozwiązanie krok po kroku:**

1. **Sprawdzenie obecnej gałęzi:**
   ```bash
   git branch
   ```
   **Oczekiwany output:**
   ```
   * main
   ```
   **Wyjaśnienie:** `*` pokazuje aktualną gałąź.

2. **Utworzenie nowej gałęzi:**
   ```bash
   git branch feature/zaawansowane-operacje
   ```
   **Wyjaśnienie:** Tworzy gałąź, ale nie przełącza na nią (pozostajesz na `main`).

3. **Lista gałęzi:**
   ```bash
   git branch
   ```
   **Oczekiwany output:**
   ```
     feature/zaawansowane-operacje
   * main
   ```

4. **Przełączenie na nową gałąź:**
   ```bash
   git switch feature/zaawansowane-operacje
   ```
   Lub starsza metoda:
   ```bash
   git checkout feature/zaawansowane-operacje
   ```
   **Oczekiwany output:**
   ```
   Switched to branch 'feature/zaawansowane-operacje'
   ```

5. **Dodanie nowych funkcji:**
   
   Otwórz `kalkulator.py` i dodaj na końcu:
   
   ```python
   def potega(a, b):
       return a ** b

   def pierwiastek(a):
       return a ** 0.5
   ```

6. **Commit zmian:**
   ```bash
   git add kalkulator.py
   git commit -m "Dodano potęgowanie i pierwiastkowanie"
   ```
   **Oczekiwany output:**
   ```
   [feature/zaawansowane-operacje f7a3c21] Dodano potęgowanie i pierwiastkowanie
    1 file changed, 5 insertions(+)
   ```

7. **Przełączenie na main:**
   ```bash
   git switch main
   ```

8. **Sprawdzenie pliku na main:**
   ```bash
   cat kalkulator.py
   ```
   **Wyjaśnienie:** Nowe funkcje (`potega`, `pierwiastek`) NIE są widoczne! Są tylko na branchu `feature/zaawansowane-operacje`.

**Dlaczego to działa:**
Branch to tylko "wskaźnik" na konkretny commit. Gdy tworzysz branch i committujesz, wskaźnik tego brancha się przesuwa, ale `main` pozostaje tam gdzie był. Przełączanie branchy zmienia pliki w working directory.

```
Stan po zadaniu:

main:           a3f5b81 → 9d2e1c4 → 2b8c930 → ...
                                         ↓
feature/...:                        f7a3c21 (potęga, pierwiastek)
```

**Częste błędy:**
- ❌ Przełączanie brancha z niezcommitowanymi zmianami → Git może nie pozwolić lub przeniesie zmiany
- ❌ Myślenie że branch to "kopia plików" → to tylko wskaźnik w historii

**Alternatywnie:**
Utwórz i przełącz w jednej komendzie:
```bash
git switch -c feature/zaawansowane-operacje
# lub starsza:
git checkout -b feature/zaawansowane-operacje
```

---

### Zadanie 7: Praca równoległa na gałęziach

**Rozwiązanie krok po kroku:**

1. **Upewnienie się że jesteś na main:**
   ```bash
   git switch main
   git branch  # weryfikacja
   ```

2. **Utworzenie bugfix brancha:**
   ```bash
   git branch bugfix/dzielenie-przez-zero
   ```

3. **Przełączenie na bugfix:**
   ```bash
   git switch bugfix/dzielenie-przez-zero
   ```

4. **Poprawa funkcji dzielenia:**
   Otwórz `kalkulator.py` i zmień funkcję `podziel`:
   ```python
   def podziel(a, b):
       if b == 0:
           raise ValueError("Nie można dzielić przez zero")
       return a / b
   ```

5. **Commit poprawki:**
   ```bash
   git add kalkulator.py
   git commit -m "Poprawiono obsługę dzielenia przez zero"
   ```
   **Oczekiwany output:**
   ```
   [bugfix/dzielenie-przez-zero 8e4d2a9] Poprawiono obsługę dzielenia przez zero
    1 file changed, 2 insertions(+), 3 deletions(-)
   ```

6. **Przełączenie na feature branch:**
   ```bash
   git switch feature/zaawansowane-operacje
   ```
   **Wyjaśnienie:** Wrócisz do stanu gdzie są `potega` i `pierwiastek`, ale BEZ poprawki dzielenia (to jest tylko na bugfix).

7. **Dodanie funkcji modulo:**
   
   Otwórz `kalkulator.py` i dodaj na końcu:
   
   ```python
   def modulo(a, b):
       return a % b
   ```

8. **Commit modulo:**
   ```bash
   git add kalkulator.py
   git commit -m "Dodano operację modulo"
   ```

9. **Lista wszystkich branchy:**
   ```bash
   git branch
   ```
   **Oczekiwany output:**
   ```
     bugfix/dzielenie-przez-zero
   * feature/zaawansowane-operacje
     main
   ```

10. **Historia z grafiką:**
    ```bash
    git log --oneline --graph --all
    ```
    **Oczekiwany output:**
    ```
    * b5f9c12 (feature/zaawansowane-operacje) Dodano operację modulo
    * f7a3c21 Dodano potęgowanie i pierwiastkowanie
    | * 8e4d2a9 (bugfix/dzielenie-przez-zero) Poprawiono obsługę dzielenia przez zero
    |/  
    * 2b8c930 (main) Dodano .gitignore i przykładową konfigurację
    * 9d2e1c4 Dodano funkcje odejmowania, mnożenia i dzielenia
    * a3f5b81 Utworzono podstawową strukturę projektu
    ```

**Dlaczego to działa:**
Każdy branch rozwija się niezależnie od punktu rozgałęzienia. Możesz mieć wiele branchy w tym samym czasie, każdy z innymi zmianami. To pozwala pracować nad bugiem i nową funkcją równocześnie.

```
Wizualizacja:

                    ┌→ feature/zaawansowane-operacje: [potęga, pierwiastek, modulo]
                    │
main: [podstawa] ───┤
                    │
                    └→ bugfix/dzielenie-przez-zero: [poprawka błędu]
```

**Częste błędy:**
- ❌ Commitowanie na złym branchu → można to naprawić, ale lepiej uważać
- ❌ Zapomnienie na którym branchu jesteś → używaj `git status` lub `git branch`

---

### Zadanie 8: Scalanie gałęzi (merge)

**Rozwiązanie krok po kroku:**

1. **Przełączenie na main:**
   ```bash
   git switch main
   ```
   **Wyjaśnienie:** Mergeujesz ZAWSZE DO obecnej gałęzi. Chcesz dodać bugfix DO main, więc musisz być NA main.

2. **Merge bugfix do main:**
   ```bash
   git merge bugfix/dzielenie-przez-zero
   ```
   **Oczekiwany output:**
   ```
   Updating 2b8c930..8e4d2a9
   Fast-forward
    kalkulator.py | 5 +++--
    1 file changed, 3 insertions(+), 2 deletions(-)
   ```
   **Wyjaśnienie:** "Fast-forward" oznacza że main po prostu "przeskoczył" do bugfix (nie było nowych commitów na main).

3. **Weryfikacja pliku:**
   ```bash
   grep -A 3 "def podziel" kalkulator.py
   ```
   **Oczekiwany output:**
   ```python
   def podziel(a, b):
       if b == 0:
           raise ValueError("Nie można dzielić przez zero")
       return a / b
   ```

4. **Historia:**
   ```bash
   git log --oneline
   ```
   **Oczekiwany output:**
   ```
   8e4d2a9 (HEAD -> main, bugfix/dzielenie-przez-zero) Poprawiono obsługę dzielenia przez zero
   2b8c930 Dodano .gitignore i przykładową konfigurację
   ...
   ```
   **Wyjaśnienie:** Commit z bugfix jest teraz na main.

5. **Usunięcie bugfix brancha:**
   ```bash
   git branch -d bugfix/dzielenie-przez-zero
   ```
   **Oczekiwany output:**
   ```
   Deleted branch bugfix/dzielenie-przez-zero (was 8e4d2a9).
   ```
   **Wyjaśnienie:** `-d` usuwa branch tylko jeśli został zmergowany. Dla wymuszenia użyj `-D`.

6. **Merge feature brancha:**
   ```bash
   git merge feature/zaawansowane-operacje
   ```
   **Oczekiwany output:**
   ```
   Merge made by the 'recursive' strategy.
    kalkulator.py | 8 ++++++++
    1 file changed, 8 insertions(+)
   ```
   **Wyjaśnienie:** Tym razem NIE było fast-forward, bo oba branche się rozeszły. Git utworzył "merge commit".

7. **Weryfikacja:**
   ```bash
   cat kalkulator.py
   ```
   Powinny być WSZYSTKIE funkcje: `dodaj`, `odejmij`, `pomnoz`, `podziel` (z poprawką), `potega`, `pierwiastek`, `modulo`.

8. **Usunięcie feature brancha:**
   ```bash
   git branch -d feature/zaawansowane-operacje
   ```

9. **Finalna historia:**
   ```bash
   git log --oneline --graph
   ```
   **Oczekiwany output:**
   ```
   *   c9f2e51 (HEAD -> main) Merge branch 'feature/zaawansowane-operacje'
   |\  
   | * b5f9c12 Dodano operację modulo
   | * f7a3c21 Dodano potęgowanie i pierwiastkowanie
   |/  
   * 8e4d2a9 Poprawiono obsługę dzielenia przez zero
   * 2b8c930 Dodano .gitignore i przykładową konfigurację
   ...
   ```

**Dlaczego to działa:**
Git merge łączy historie dwóch branchy. Fast-forward merge (prosta linia) vs merge commit (rozgałęzienie). Git automatycznie scala zmiany jeśli nie ma konfliktów.

**Częste błędy:**
- ❌ Merge w złą stronę → `git switch main; git merge feature` (✅) vs `git switch feature; git merge main` (❌)
- ❌ Próba usunięcia brancha przed merge → Git ostrzeże

**Alternatywnie:**
Wymuś merge commit nawet przy fast-forward:
```bash
git merge --no-ff feature/branch
```

---

### Zadanie 9: Rozwiązywanie konfliktów

**Rozwiązanie krok po kroku:**

1. **Utworzenie feature/wersja-a:**
   ```bash
   git switch main
   git switch -c feature/wersja-a
   ```

2. **Modyfikacja w wersji A:**
   Otwórz `kalkulator.py`, znajdź sekcję `if __name__ == "__main__":` i zmień na:
   ```python
   if __name__ == "__main__":
       print("=== KALKULATOR WERSJA A ===")
       print(dodaj(5, 3))
   ```

3. **Commit wersji A:**
   ```bash
   git add kalkulator.py
   git commit -m "Wersja A interfejsu"
   ```

4. **Powrót na main i utworzenie wersji B:**
   ```bash
   git switch main
   git switch -c feature/wersja-b
   ```

5. **Modyfikacja w wersji B:**
   Zmień TĘ SAMĄ linię na:
   ```python
   if __name__ == "__main__":
       print("*** KALKULATOR WERSJA B ***")
       print(dodaj(10, 20))
   ```

6. **Commit wersji B:**
   ```bash
   git add kalkulator.py
   git commit -m "Wersja B interfejsu"
   ```

7. **Powrót na main:**
   ```bash
   git switch main
   ```

8. **Merge wersji A (bez problemu):**
   ```bash
   git merge feature/wersja-a
   ```
   **Oczekiwany output:**
   ```
   Updating ... Fast-forward
   ```
   **Wyjaśnienie:** Wersja A zmergowana bez problemów.

9. **Próba merge wersji B - KONFLIKT:**
   ```bash
   git merge feature/wersja-b
   ```
   **Oczekiwany output:**
   ```
   Auto-merging kalkulator.py
   CONFLICT (content): Merge conflict in kalkulator.py
   Automatic merge failed; fix conflicts and then commit the result.
   ```
   **Wyjaśnienie:** Git nie wie którą wersję wybrać - obie zmieniły tę samą linię!

10. **Sprawdzenie statusu:**
    ```bash
    git status
    ```
    **Oczekiwany output:**
    ```
    On branch main
    You have unmerged paths.
      (fix conflicts and run "git commit")

    Unmerged paths:
      (use "git add <file>..." to mark resolution)
            both modified:   kalkulator.py
    ```

11. **Otwarcie pliku z konfliktem:**
    ```bash
    cat kalkulator.py
    ```
    Zobaczysz:
    ```python
    if __name__ == "__main__":
    <<<<<<< HEAD
        print("=== KALKULATOR WERSJA A ===")
        print(dodaj(5, 3))
    =======
        print("*** KALKULATOR WERSJA B ***")
        print(dodaj(10, 20))
    >>>>>>> feature/wersja-b
    ```
    **Wyjaśnienie:**
    - `<<<<<<< HEAD` = twoja obecna wersja (main)
    - `=======` = separator
    - `>>>>>>> feature/wersja-b` = wersja mergowanego brancha

12. **Rozwiązanie konfliktu - wybierz wersję:**
    
    **Opcja A - zachowaj wersję A:**
    ```python
    if __name__ == "__main__":
        print("=== KALKULATOR WERSJA A ===")
        print(dodaj(5, 3))
    ```
    
    **Opcja B - zachowaj wersję B:**
    ```python
    if __name__ == "__main__":
        print("*** KALKULATOR WERSJA B ***")
        print(dodaj(10, 20))
    ```
    
    **Opcja C - połącz obie (rekomendowane dla zadania):**
    ```python
    if __name__ == "__main__":
        print("=== KALKULATOR - wersja finalna ===")
        print("Test A:", dodaj(5, 3))
        print("Test B:", dodaj(10, 20))
    ```

13. **Usuń markery konfliktu i zapisz plik:**
    Plik NIE MOŻE zawierać `<<<<<<<`, `=======`, `>>>>>>>`.

14. **Dodaj do staging (oznacza rozwiązanie):**
    ```bash
    git add kalkulator.py
    ```

15. **Dokończ merge (commit):**
    ```bash
    git commit -m "Scalono wersje A i B interfejsu"
    ```
    Lub po prostu:
    ```bash
    git commit
    ```
    Git automatycznie wygeneruje komunikat merge.
    
    **Oczekiwany output:**
    ```
    [main e8a4f92] Scalono wersje A i B interfejsu
    ```

16. **Usunięcie branchy:**
    ```bash
    git branch -d feature/wersja-a
    git branch -d feature/wersja-b
    ```

17. **Weryfikacja:**
    ```bash
    git status
    ```
    **Oczekiwany output:**
    ```
    On branch main
    nothing to commit, working tree clean
    ```

**Dlaczego to działa:**
Konflikty powstają gdy dwa branche zmieniają te same linie kodu. Git nie może automatycznie zdecydować która wersja jest poprawna, więc wymaga ręcznej interwencji. Usunięcie markerów i `git add` informuje Gita że konflikt został rozwiązany.

**Częste błędy:**
- ❌ Zostawienie markerów w pliku (`<<<<<<<`, etc.) → kompilator/interpreter je wykryje jako błąd
- ❌ Commit bez `git add` po rozwiązaniu → Git nie wie że konflikt został rozwiązany
- ❌ Panika 😱 → spokojnie, otwórz plik, zdecyduj co zachować, usuń markery

**Alternatywnie:**
Użyj narzędzia merge:
```bash
git mergetool
```

Przerwij merge jeśli się pogubisz:
```bash
git merge --abort
```

---

## Zadania z cofaniem zmian

### Zadanie 10: Cofanie zmian przed commitem

**Rozwiązanie krok po kroku:**

1. **Dodanie śmieciowego kodu:**
   
   Otwórz `kalkulator.py` i dodaj na końcu:
   
   ```python
   def zepsuta_funkcja():
       asdfasdf to nie zadziała!!!
       @@@ błąd
   ```
   
   **Nie uruchamiaj kodu** - celowo jest błędny!

2. **Sprawdzenie statusu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   Changes not staged for commit:
           modified:   kalkulator.py
   ```

3. **Zobacz co się zmieniło:**
   ```bash
   git diff kalkulator.py
   ```
   **Oczekiwany output:**
   ```diff
   +def zepsuta_funkcja():
   +    asdfasdf to nie zadziała!!!
   +    @@@ błąd
   ```

4. **Cofnij zmiany:**
   ```bash
   git restore kalkulator.py
   ```
   Lub starsza metoda:
   ```bash
   git checkout -- kalkulator.py
   ```
   **Wyjaśnienie:** Przywraca plik do stanu z ostatniego commita. ⚠️ NIEODWRACALNE!

5. **Sprawdzenie statusu:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   nothing to commit, working tree clean
   ```

6. **Weryfikacja pliku:**
   ```bash
   cat kalkulator.py
   ```
   Śmieciowy kod zniknął!

**Dlaczego to działa:**
`git restore` (lub `git checkout --`) kopiuje plik z ostatniego commita do working directory, nadpisując lokalne zmiany. To przydatne gdy eksperyment poszedł źle.

**Częste błędy:**
- ❌ Użycie na nieprawidłowym pliku → stracisz ważne zmiany!
- ❌ Pomylenie `git restore` (cofa zmiany) z `git restore --staged` (cofa staging)

**Alternatywnie:**
Cofnij wszystkie pliki:
```bash
git restore .
```

Cofnij do konkretnego commita:
```bash
git restore --source=HEAD~1 kalkulator.py
```

---

### Zadanie 11: Cofanie commita (revert)

**Rozwiązanie krok po kroku:**

1. **Dodanie złej funkcji:**
   
   Otwórz `kalkulator.py` i dodaj na końcu:
   
   ```python
   def zla_funkcja():
       return "Ta funkcja ma buga!"
   ```

2. **Commit:**
   ```bash
   git add kalkulator.py
   git commit -m "Dodano nową funkcję (bug!)"
   ```
   **Oczekiwany output:**
   ```
   [main d3a7f18] Dodano nową funkcję (bug!)
    1 file changed, 3 insertions(+)
   ```

3. **Historia - znajdź hash:**
   ```bash
   git log --oneline -5
   ```
   **Oczekiwany output:**
   ```
   d3a7f18 (HEAD -> main) Dodano nową funkcję (bug!)
   e8a4f92 Scalono wersje A i B interfejsu
   ...
   ```

4. **Revert tego commita:**
   ```bash
   git revert d3a7f18
   ```
   Lub:
   ```bash
   git revert HEAD
   ```
   **Wyjaśnienie:** Git otworzy edytor z komunikatem (możesz go zaakceptować lub zmienić). Zapisz i zamknij edytor.
   
   **Oczekiwany output:**
   ```
   [main f9b2e84] Revert "Dodano nową funkcję (bug!)"
    1 file changed, 3 deletions(-)
   ```

5. **Historia po revert:**
   ```bash
   git log --oneline -5
   ```
   **Oczekiwany output:**
   ```
   f9b2e84 (HEAD -> main) Revert "Dodano nową funkcję (bug!)"
   d3a7f18 Dodano nową funkcję (bug!)
   e8a4f92 Scalono wersje A i B interfejsu
   ...
   ```
   **Wyjaśnienie:** OBA commity są widoczne! Oryginalny + revert.

6. **Sprawdzenie pliku:**
   ```bash
   grep "zla_funkcja" kalkulator.py
   ```
   **Oczekiwany output:** Nic - funkcja zniknęła!
   
   **Wyjaśnienie:** Revert cofnął zmiany, ale historia jest zachowana.

**Dlaczego to działa:**
`git revert` tworzy NOWY commit, który robi odwrotność starego commita. Jeśli stary commit dodał 3 linie, revert je usunie. Historia pozostaje nietknięta - ważne dla współpracy (inni mogli już pobrać oryginalny commit).

**Częste błędy:**
- ❌ Mylenie `revert` z `reset` → `revert` jest bezpieczny, `reset` zmienia historię
- ❌ Revertowanie merge commita bez flagi → użyj `git revert -m 1 <hash>`

**Alternatywnie:**
Revert bez otwierania edytora:
```bash
git revert --no-edit d3a7f18
```

Revert wielu commitów:
```bash
git revert HEAD~3..HEAD  # cofa ostatnie 3
```

---

### Zadanie 12: Eksperyment z reset

**Rozwiązanie krok po kroku:**

**CZĘŚĆ 1 - git reset --soft**

1. **Utworzenie pliku testowego:**
   
   Utwórz plik `test_reset.txt` z zawartością:
   ```
   Wersja 1
   ```

2. **Commit 1:**
   ```bash
   git add test_reset.txt
   git commit -m "Test reset - commit 1"
   ```

3. **Zmiana i commit 2:**
   
   Zmień zawartość pliku `test_reset.txt` na:
   ```
   Wersja 2
   ```
   
   Commitnij:
   ```bash
   git add test_reset.txt
   git commit -m "Test reset - commit 2"
   ```

4. **Zmiana i commit 3:**
   
   Zmień zawartość pliku `test_reset.txt` na:
   ```
   Wersja 3
   ```
   
   Commitnij:
   ```bash
   git add test_reset.txt
   git commit -m "Test reset - commit 3"
   ```

5. **Historia:**
   ```bash
   git log --oneline -5
   ```
   **Oczekiwany output:**
   ```
   a9f3d21 (HEAD -> main) Test reset - commit 3
   b2e8c45 Test reset - commit 2
   c7f1a89 Test reset - commit 1
   ...
   ```

6. **Git reset --soft (cofa o 1):**
   ```bash
   git reset --soft HEAD~1
   ```
   **Wyjaśnienie:** Cofa HEAD o 1 commit (do commit 2), ale zmiany pozostają w staging.

7. **Status po --soft:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   Changes to be committed:
     (use "git restore --staged <file>..." to unstage)
           modified:   test_reset.txt
   ```
   **Wyjaśnienie:** Zmiany z commita 3 są w staging (zielone)!

8. **Sprawdzenie pliku:**
   ```bash
   cat test_reset.txt
   ```
   **Oczekiwany output:**
   ```
   Wersja 3
   ```
   **Wyjaśnienie:** Plik nadal zawiera "Wersja 3".

9. **Historia po --soft:**
   ```bash
   git log --oneline -5
   ```
   **Oczekiwany output:**
   ```
   b2e8c45 (HEAD -> main) Test reset - commit 2
   c7f1a89 Test reset - commit 1
   ...
   ```
   Commit 3 zniknął z historii!

**CZĘŚĆ 2 - git reset --mixed**

10. **Commit ponownie:**
    ```bash
    git commit -m "Test reset - commit 3 ponownie"
    ```

11. **Nowa zmiana i commit 4:**
    
    Zmień zawartość pliku `test_reset.txt` na:
    ```
    Wersja 4
    ```
    
    Commitnij:
    ```bash
    git add test_reset.txt
    git commit -m "Test reset - commit 4"
    ```

12. **Git reset --mixed:**
    ```bash
    git reset --mixed HEAD~1
    ```
    Lub po prostu:
    ```bash
    git reset HEAD~1
    ```
    **Wyjaśnienie:** `--mixed` to domyślne zachowanie `git reset`.

13. **Status po --mixed:**
    ```bash
    git status
    ```
    **Oczekiwany output:**
    ```
    On branch main
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
            modified:   test_reset.txt
    ```
    **Wyjaśnienie:** Zmiany NIE są w staging (czerwone), ale są w pliku!

14. **Sprawdzenie pliku:**
    ```bash
    cat test_reset.txt
    ```
    **Oczekiwany output:**
    ```
    Wersja 4
    ```

**CZĘŚĆ 3 - git reset --hard ⚠️**

15. **Dodanie niezapisanej zmiany:**
    
    Zmień zawartość pliku `test_reset.txt` na:
    ```
    Wersja 5 - niezapisana
    ```
    
    **Zapisz plik, ale NIE commituj!**

16. **NIE commituj! Status:**
    ```bash
    git status
    ```
    ```
    modified:   test_reset.txt
    ```

17. **Git reset --hard:**
    ```bash
    git reset --hard HEAD
    ```
    **Oczekiwany output:**
    ```
    HEAD is now at b2e8c45 Test reset - commit 3 ponownie
    ```

18. **Sprawdzenie pliku:**
    ```bash
    cat test_reset.txt
    ```
    **Oczekiwany output:**
    ```
    Wersja 3
    ```
    **Wyjaśnienie:** "Wersja 5" ZNIKNĘŁA! `--hard` usunął niezapisane zmiany.

**Porównanie trybów reset:**

| Tryb | HEAD | Staging | Working Directory |
|------|------|---------|-------------------|
| `--soft` | ✅ Cofnięty | ✅ Zmiany z commita | ✅ Zmiany z commita |
| `--mixed` | ✅ Cofnięty | ❌ Pusty | ✅ Zmiany z commita |
| `--hard` | ✅ Cofnięty | ❌ Pusty | ❌ Pusty (USUNIĘTE!) |

**Dlaczego to działa:**
- `--soft`: "Chcę przerobić commit, ale zachować zmiany w staging"
- `--mixed`: "Chcę cofnąć staging, ale zachować zmiany w plikach"
- `--hard`: "Chcę wyrzucić WSZYSTKO i wrócić do konkretnego commita"

**Częste błędy:**
- ❌ Użycie `--hard` bez przemyślenia → stracisz pracę!
- ❌ Reset commitów, które już spushowałeś → inni będą mieć problemy

**Alternatywnie:**
Reset do konkretnego commita:
```bash
git reset --soft abc1234
```

Jeśli przypadkowo użyłeś `--hard`, możesz spróbować odzyskać:
```bash
git reflog  # znajdź hash zgubionego commita
git reset --hard <hash>
```

---

## Zadania zaawansowane

### Zadanie 13: Symulacja pracy ze zdalnym repozytorium

**Rozwiązanie krok po kroku:**

1. **Wyjście z projektu:**
   ```bash
   cd ..
   pwd  # upewnij się że jesteś w folderze nadrzędnym
   ```

2. **Utworzenie "zdalnego" repo (bare):**
   ```bash
   mkdir zdalne_repo
   cd zdalne_repo
   git init --bare
   ```
   **Oczekiwany output:**
   ```
   Initialized empty Git repository in .../zdalne_repo/
   ```
   **Wyjaśnienie:** `--bare` tworzy repozytorium bez working directory - to konwencja dla "centralnych" repozytoriów (jak GitHub).

3. **Powrót do projektu:**
   ```bash
   cd ../kalkulator_projekt
   ```

4. **Dodanie remote:**
   ```bash
   git remote add origin ../zdalne_repo
   ```
   **Wyjaśnienie:** `origin` to standardowa nazwa dla głównego zdalnego repo. Ścieżka `../zdalne_repo` to relatywna ścieżka do folderu.

5. **Lista remotes:**
   ```bash
   git remote -v
   ```
   **Oczekiwany output:**
   ```
   origin  ../zdalne_repo (fetch)
   origin  ../zdalne_repo (push)
   ```

6. **Push do zdalnego repo:**
   ```bash
   git push -u origin main
   ```
   **Oczekiwany output:**
   ```
   Enumerating objects: 25, done.
   ...
   To ../zdalne_repo
    * [new branch]      main -> main
   Branch 'main' set up to track remote branch 'main' from 'origin'.
   ```
   **Wyjaśnienie:** `-u` (upstream) ustawia tracking - teraz `git push` będzie wiedział gdzie pushować.

7. **Wyjście i klonowanie:**
   ```bash
   cd ..
   git clone zdalne_repo klon_projektu
   ```
   **Oczekiwany output:**
   ```
   Cloning into 'klon_projektu'...
   done.
   ```

8. **Weryfikacja klonu:**
   ```bash
   cd klon_projektu
   ls -la
   ```
   Wszystkie pliki powinny być identyczne jak w `kalkulator_projekt`!

9. **Dodanie komentarza w klonie:**
    
    Otwórz `kalkulator.py` i dodaj na samym początku pliku:
    
    ```python
    # Kalkulator - prosty program do obliczeń matematycznych
    # Autor: Zespół programistów

    ```
    
    **Wskazówka:** Dodaj to PRZED pierwszą funkcją `def dodaj()`.

10. **Commit i push z klonu:**
    ```bash
    git add kalkulator.py
    git commit -m "Dodano komentarz nagłówkowy"
    git push
    ```
    **Oczekiwany output:**
    ```
    [main f8c2d91] Dodano komentarz nagłówkowy
     1 file changed, 3 insertions(+)
    To ../zdalne_repo
       e8a4f92..f8c2d91  main -> main
    ```

11. **Powrót do oryginalnego projektu:**
    ```bash
    cd ../kalkulator_projekt
    ```

12. **Sprawdzenie statusu:**
    ```bash
    git status
    ```
    **Oczekiwany output:**
    ```
    On branch main
    Your branch is behind 'origin/main' by 1 commit, and can be fast-forwarded.
    ```
    **Wyjaśnienie:** Git wie że zdalne repo ma nowsze zmiany!

13. **Pobranie zmian (pull):**
    ```bash
    git pull
    ```
    **Oczekiwany output:**
    ```
    Updating e8a4f92..f8c2d91
    Fast-forward
     kalkulator.py | 3 +++
     1 file changed, 3 insertions(+)
    ```

14. **Weryfikacja:**
    ```bash
    head -3 kalkulator.py
    ```
    **Oczekiwany output:**
    ```python
    # Kalkulator - prosty program do obliczeń matematycznych
    # Autor: Zespół programistów

    ```
    Komentarz się pojawił!

**Dlaczego to działa:**
To symuluje prawdziwy workflow z GitHubem:
- `zdalne_repo` = GitHub
- `kalkulator_projekt` = komputer programisty A
- `klon_projektu` = komputer programisty B

Oba programiści synchronizują się przez centralne repo. `git push` wysyła, `git pull` pobiera.

**Częste błędy:**
- ❌ `git push` przed `git pull` gdy są zmiany → Git odrzuci push
- ❌ Zapomnienie `-u` przy pierwszym push → trzeba zawsze podawać `origin main`

**Alternatywnie:**
Zobacz różnice przed pull:
```bash
git fetch origin
git diff main origin/main
git pull
```

---

### Zadanie 14: Struktura folderów z .gitkeep

**Rozwiązanie krok po kroku:**

1. **Utworzenie folderów:**
   ```bash
   mkdir logs
   mkdir cache
   ```

2. **Próba dodania do Git:**
   ```bash
   git add logs/ cache/
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   nothing to commit, working tree clean
   ```
   **Wyjaśnienie:** Git ignoruje puste foldery! Nie ma nic do dodania.

3. **Utworzenie plików .gitkeep:**
   ```bash
   touch logs/.gitkeep
   touch cache/.gitkeep
   ```

4. **Aktualizacja .gitignore:**
   
   Otwórz plik `.gitignore` i dodaj na końcu:
   
   ```gitignore
   # Logi
   logs/*.log
   logs/*.txt

   # Cache
   cache/*
   !cache/.gitkeep
   ```
   
   **Wyjaśnienie:**
   - `logs/*.log` - ignoruj pliki .log w logs/
   - `cache/*` - ignoruj wszystko w cache/
   - `!cache/.gitkeep` - WYJĄTEK: nie ignoruj .gitkeep

5. **Dodanie do staging:**
   ```bash
   git add logs/.gitkeep cache/.gitkeep .gitignore
   ```

6. **Status:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   Changes to be committed:
           modified:   .gitignore
           new file:   cache/.gitkeep
           new file:   logs/.gitkeep
   ```

7. **Commit:**
   ```bash
   git commit -m "Dodano strukturę folderów dla logów i cache"
   ```

8. **Test - utworzenie pliku .log:**
   
   Utwórz testowy plik `logs/test.log` z dowolną zawartością (np. "Test log entry") oraz plik `cache/data.txt` z dowolną zawartością.

9. **Status - pliki ignorowane:**
   ```bash
   git status
   ```
   **Oczekiwany output:**
   ```
   On branch main
   nothing to commit, working tree clean
   ```
   **Wyjaśnienie:** Pliki w `logs/` i `cache/` są ignorowane!

10. **Weryfikacja co jest ignorowane:**
    ```bash
    git status --ignored
    ```
    **Oczekiwany output:**
    ```
    Ignored files:
      cache/data.txt
      logs/test.log
    ```

11. **Test klonowania:**
    ```bash
    cd ..
    rm -rf test_klon
    git clone kalkulator_projekt test_klon
    cd test_klon
    ls -la
    ```
    Foldery `logs/` i `cache/` istnieją (dzięki .gitkeep)!

**Dlaczego to działa:**
Git śledzi pliki, nie foldery. `.gitkeep` to pusty plik, który "trzyma" folder w repozytorium. Gdy ktoś sklonuje repo, dostanie strukturę folderów, ale nie pliki tymczasowe (.log, cache, etc.).

**Częste błędy:**
- ❌ Nazwa `.gitignore` zamiast `.gitkeep` w folderze → to nie zadziała
- ❌ Ignorowanie `*.gitkeep` w .gitignore → wtedy foldery znikną

**Alternatywnie:**
Możesz użyć `README.md` zamiast `.gitkeep`:

Utwórz plik `logs/README.md` z zawartością:
```markdown
Ten folder przechowuje logi
```

---

### Zadanie 15: Eksperyment z rebase

**Rozwiązanie krok po kroku:**

1. **Utworzenie pliku na main:**
   
   Upewnij się że jesteś na main, utwórz plik `historia_rebase.txt` z zawartością:
   ```
   Commit 1 na main
   ```
   
   Commitnij:
   ```bash
   git switch main
   git add historia_rebase.txt
   git commit -m "Historia rebase - commit 1"
   ```

2. **Utworzenie feature brancha:**
   ```bash
   git switch -c feature/rebase-test
   ```

3. **Commit 2 na feature:**
   
   Otwórz `historia_rebase.txt` i dodaj na końcu nową linię:
   ```
   Commit 2 na feature
   ```
   
   Commitnij:
   ```bash
   git add historia_rebase.txt
   git commit -m "Historia rebase - commit 2 (feature)"
   ```

4. **Commit 3 na feature:**
   
   Dodaj kolejną linię do `historia_rebase.txt`:
   ```
   Commit 3 na feature
   ```
   
   Commitnij:
   ```bash
   git add historia_rebase.txt
   git commit -m "Historia rebase - commit 3 (feature)"
   ```

5. **Przełączenie na main:**
   ```bash
   git switch main
   ```

6. **Commit 4 na main:**
   
   Dodaj kolejną linię do `historia_rebase.txt`:
   ```
   Commit 4 na main
   ```
   
   Commitnij:
   ```bash
   git add historia_rebase.txt
   git commit -m "Historia rebase - commit 4 (main)"
   ```

7. **Historia graficzna przed rebase:**
   ```bash
   git log --oneline --graph --all
   ```
   **Oczekiwany output:**
   ```
   * e5f8a23 (HEAD -> main) Historia rebase - commit 4 (main)
   | * d9c3b71 (feature/rebase-test) Historia rebase - commit 3 (feature)
   | * a2f7e14 Historia rebase - commit 2 (feature)
   |/  
   * c8b1d92 Historia rebase - commit 1
   ```
   **Wyjaśnienie:** Historia się rozgałęziła - main i feature poszły w różne strony.

8. **Przełączenie na feature:**
   ```bash
   git switch feature/rebase-test
   ```

9. **Rebase na main:**
   ```bash
   git rebase main
   ```
   **Oczekiwany output:**
   ```
   Successfully rebased and updated refs/heads/feature/rebase-test.
   ```
   **Wyjaśnienie:** Git "przeniósł" commity feature (2, 3) na koniec main (po commit 4).

10. **Historia po rebase:**
    ```bash
    git log --oneline --graph --all
    ```
    **Oczekiwany output:**
    ```
    * f3d9c82 (HEAD -> feature/rebase-test) Historia rebase - commit 3 (feature)
    * b7e2a54 Historia rebase - commit 2 (feature)
    * e5f8a23 (main) Historia rebase - commit 4 (main)
    * c8b1d92 Historia rebase - commit 1
    ```
    **Wyjaśnienie:** Historia jest LINIOWA! Commity feature są teraz "na szczycie" main.

11. **Przełączenie na main:**
    ```bash
    git switch main
    ```

12. **Merge feature (fast-forward):**
    ```bash
    git merge feature/rebase-test
    ```
    **Oczekiwany output:**
    ```
    Updating e5f8a23..f3d9c82
    Fast-forward
     historia_rebase.txt | 2 ++
     1 file changed, 2 insertions(+)
    ```
    **Wyjaśnienie:** Fast-forward! Nie ma merge commita, bo historia jest liniowa.

13. **Finalna historia:**
    ```bash
    git log --oneline --graph
    ```
    **Oczekiwany output:**
    ```
    * f3d9c82 (HEAD -> main, feature/rebase-test) Historia rebase - commit 3 (feature)
    * b7e2a54 Historia rebase - commit 2 (feature)
    * e5f8a23 Historia rebase - commit 4 (main)
    * c8b1d92 Historia rebase - commit 1
    ```
    Prosta linia, bez rozgałęzień!

**Dlaczego to działa:**
Rebase "przepisuje" historię - przenosi commity z jednej gałęzi na koniec drugiej. Commity dostają nowe hashe (ID), ale zmiany są te same. To daje "czystszą" historię bez merge commitów.

**Wizualizacja:**

```
PRZED REBASE:
                    ┌→ feature: [2, 3]
                    │
main: [1] ──────────┴→ [4]

PO REBASE:
main: [1] → [4] → [2'] → [3']
              ↑            ↑
            main      feature
```

**Częste błędy:**
- ❌ Rebase commitów, które już spushowałeś → inni będą mieć problemy
- ❌ Rebase podczas konfliktu bez rozwiązania → użyj `git rebase --continue` po rozwiązaniu
- ❌ Panika podczas rebase → użyj `git rebase --abort` żeby anulować

**Alternatywnie:**
Porównanie merge vs rebase:

**Z merge:**
```bash
git switch main
git merge feature/rebase-test
# Tworzy merge commit
```

**Z rebase:**
```bash
git switch feature/rebase-test
git rebase main
git switch main
git merge feature/rebase-test
# Fast-forward, brak merge commita
```

---

## Podsumowanie

✅ **Gratulacje!** Przeszedłeś wszystkie 15 zadań!

**Czego się nauczyłeś:**
- Inicjalizacji repo i podstawowych operacji
- Śledzenia zmian i przeglądania historii
- Ignorowania plików (bezpieczeństwo!)
- Pracy z branchami i scalania
- Rozwiązywania konfliktów (najważniejsza umiejętność!)
- Cofania zmian (revert vs reset)
- Pracy ze zdalnymi repozytoriami (push/pull)
- Zaawansowanych technik (rebase)

**Następne kroki:**
1. Utwórz konto na GitHubie
2. Spróbuj współpracować z kimś nad projektem
3. Przećwicz Pull Requesty
4. Eksperymentuj - Git pozwala cofnąć prawie wszystko!

🎉 **Jesteś gotowy do pracy z Git w prawdziwych projektach!**

