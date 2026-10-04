# Git - System Kontroli Wersji

---

## 📋 Spis treści

### **Część 1: Podstawy**
1. **[Wprowadzenie do kontroli wersji](#1-wprowadzenie-do-kontroli-wersji)**
   - Problemy bez Git
   - Korzyści z systemu kontroli wersji

2. **[Czym jest Git](#2-czym-jest-git---podstawy-od-zera)**
   - Rozproszony system kontroli wersji
   - Jak działa: migawki, lokalne operacje
   - Struktura `.git/` - co jest w środku

3. **[Podstawowe pojęcia](#3-podstawowe-pojęcia)**
   - Repozytorium, Commit, HEAD
   - 4 stany pliku (Untracked → Staged → Committed)
   - Working Directory vs Staging Area

### **Część 2: Podstawowe operacje**
4. **[Podstawowe komendy](#4-podstawowe-komendy---pierwsze-kroki)**
   - `git init`, `git clone`, `git status`
   - `git add`, `git commit`, `git log`
   - `git diff` - czytanie zmian

5. **[Praca ze zdalnymi repozytoriami](#41-praca-ze-zdalnymi-repozytoriami)**
   - Czym jest remote (GitHub, GitLab)
   - SSH vs HTTPS - konfiguracja kluczy
   - `git fetch` vs `git pull` - różnica!
   - `git push`, `git remote`

### **Część 3: Cofanie i naprawianie**
6. **[Cofanie zmian](#5-cofanie-zmian---jak-naprawić-błędy)**
   - `git restore` - cofnij zmiany w pliku
   - `git revert` - bezpieczne cofanie
   - `git reset` (--soft, --mixed, --hard)

7. **[Git stash](#git-stash---tymczasowe-schowanie-zmian)**
   - Tymczasowe schowanie zmian
   - `git stash`, `git stash pop`

### **Część 4: Praca z branchami**
8. **[Branching](#6-branching-gałęzie---praca-równoległa)**
   - Czym jest branch i po co
   - `git branch`, `git switch`, `git checkout`
   - `git merge` vs `git rebase`
   - Git Flow - metodologia pracy

### **Część 5: Konfiguracja i praktyki**
9. **[Pliki specjalne](#7-pliki-specjalne---konfiguracja-repozytorium)**
   - `.gitignore` - co ignorować i dlaczego
   - `.gitkeep` - puste foldery

10. **[Dobre praktyki](#8-dobre-praktyki---jak-pracować-profesjonalnie)**
    - Komunikaty commitów po angielsku (feat, fix, docs)
    - Conventional Commits - standard branżowy
    - Workflow zespołowy
    - Bezpieczeństwo (NIE commituj haseł!)

11. **[Najczęstsze problemy i rozwiązania](#9-najczęstsze-problemy-początkujących)**
    - Typowe błędy początkujących
    - Jak je naprawić

12. **[Szybkie ściągi](#10-szybkie-ściągi)**
    - Najpopularniejsze komendy
    - Przykładowy `.gitignore` dla Python

[⬆ Powrót do góry](#git---system-kontroli-wersji)



## 📚 Czego się nauczysz?


✅ Tworzyć i zarządzać repozytoriami Git  
✅ Commitować zmiany profesjonalnie (po angielsku!)  
✅ Pracować z branchami (feature branches, Git Flow)  
✅ Konfigurować SSH i pracować z GitHubem  
✅ Cofać zmiany bezpiecznie (revert vs reset)  
✅ Rozwiązywać najczęstsze problemy  
✅ Współpracować w zespole (pull, push, fetch)  
✅ Chronić wrażliwe dane (.gitignore)  
✅ Używać git stash w codziennej pracy  

**Zaczynajmy!** 🚀

---

## 1. Wprowadzenie do kontroli wersji

### Problem, który wszyscy znamy

Czy kiedykolwiek miałeś pliki o takich nazwach?
- `projekt_final.py`
- `projekt_final_v2.py`
- `projekt_final_NAPRAWDE_OSTATECZNY.py`
- `projekt_final_NAPRAWDE_OSTATECZNY_poprawiony.py`
- `projekt_final_TO_JUZ_DZIALA.py`

To znak, że potrzebujesz systemu kontroli wersji! 🎯

### Problemy bez kontroli wersji

**Rzeczywiste sytuacje, które nas spotykają:**

1. **Utrata kodu** 💥
   - Przypadkowo nadpisujesz plik
   - Usuwasz coś ważnego i nie pamiętasz jak było
   - Komputer się psuje i tracisz cały kod

2. **Niemożność powrotu** ⏪
   - Coś działało wczoraj, dziś nie działa
   - Nie pamiętasz co zmieniłeś
   - Chciałbyś wrócić do wersji sprzed tygodnia, ale nie masz jak

3. **Chaos we współpracy** 👥
   - Kto zmienił ten plik?
   - Kiedy to zostało zmienione?
   - Dlaczego to zostało zmienione?
   - Dwie osoby edytują ten sam plik -czyj kod zachować?

4. **Konflikty** ⚔️
   - Ty pracujesz nad funkcją A
   - Kolega pracuje nad funkcją B w tym samym pliku
   - Jak połączyć obie zmiany bez utraty pracy?

5. **Brak struktury** 📂
   - Dziesiątki wersji plików
   - Brak opisów co zostało zmienione
   - Niemożność znalezienia konkretnej wersji

### Korzyści z systemu kontroli wersji

✅ **Pełna historia zmian** - widzisz co, kiedy, kto i dlaczego zmienił

✅ **Bezpieczeństwo** - możesz cofnąć każdą zmianę

✅ **Współpraca** - wiele osób może pracować nad tym samym projektem

✅ **Backup** - kod jest bezpieczny, nawet jeśli komputer się zepsuje

✅ **Eksperymentowanie** - możesz testować nowe funkcje bez ryzyka

✅ **Profesjonalizm** - to standard w branży IT

---

## 2. Czym jest Git - podstawy od zera

### Definicja

**Git to rozproszony system kontroli wersji.**

Co to oznacza prostymi słowami?

- **System kontroli wersji** = program, który śledzi zmiany w plikach i zapisuje ich historię
- **Rozproszony** = każdy programista ma pełną kopię całej historii projektu na swoim komputerze

### Rozprosziona architektura - klucz do zrozumienia Git

```
┌─────────────────────────┐
│   Zdalne repozytorium   │
│      (np. GitHub)       │
└──────────┬──────────────┘
           │
     ┌─────┴─────┐
     │           │
┌────▼────┐ ┌───▼─────┐
│ Komputer│ │ Komputer│
│ Programi│ │ Programi│
│ sty A   │ │ sty B   │
│         │ │         │
│ Pełna   │ │ Pełna   │
│ historia│ │ historia│
└─────────┘ └─────────┘
```

**Każdy ma wszystko!** 🎉
- Ty masz pełną historię projektu
- Twój kolega ma pełną historię projektu
- Serwer (GitHub) ma pełną historię projektu

### Struktura `.git` - gdzie mieszka magia

Gdy inicjalizujesz Git w folderze, powstaje ukryty podfolder `.git`:

```
moj_projekt/
├── .git/              ← Tu mieszka cała historia!
│   ├── objects/       ← Wszystkie migawki plików
│   ├── refs/          ← Gałęzie
│   └── HEAD           ← Gdzie teraz jesteś
├── plik1.py
├── plik2.py
└── README.md
```

> [!CAUTION]
> **NIGDY nie usuwaj folderu `.git`** — stracisz całą historię projektu bezpowrotnie. `.git/` to całe repozytorium; bez niego zostajesz z luźnymi plikami.

#### Co jest w środku `.git/`? (dla ciekawskich)

**Podstawowa struktura:**

```
.git/
├── HEAD              ← Plik wskazujący gdzie jesteś (ref: refs/heads/main)
├── config            ← Konfiguracja tego repozytorium
├── description       ← Opis (używany przez GitWeb)
├── hooks/            ← Skrypty automatyczne (pre-commit, post-commit)
├── info/             ← exclude (jak .gitignore ale lokalny)
├── objects/          ← BAZA DANYCH - wszystkie commity i pliki!
│   ├── 2b/           ← Foldery wg pierwszych 2 znaków hasha
│   │   └── 8c930... ← Skompresowane pliki/commity
│   ├── ab/
│   └── pack/         ← Spakowane obiekty (optymalizacja)
├── refs/             ← Referencje do commitów
│   ├── heads/        ← Lokalne branche (main, feature/xyz)
│   ├── remotes/      ← Zdalne branche (origin/main)
│   └── tags/         ← Tagi (v1.0, v2.0)
└── index             ← Staging area (co jest w "git add")
```

**Najważniejsze elementy:**

1. **`objects/`** - Tu są WSZYSTKIE dane:
   - Każdy commit
   - Każda wersja każdego pliku
   - Struktura folderów
   - Skompresowane i zahashowane

2. **`refs/heads/`** - Twoje lokalne branche:
   ```bash
   cat .git/refs/heads/main
   # Output: a3f5b81d8f9e123...  (hash ostatniego commita)
   ```

3. **`HEAD`** - Gdzie teraz jesteś:
   ```bash
   cat .git/HEAD
   # Output: ref: refs/heads/main  (jesteś na main)
   ```

4. **`index`** - Staging area (binarne, nie czytaj):
   - Lista plików dodanych przez `git add`

5. **`config`** - Konfiguracja (możesz czytać!):
   ```ini
   [remote "origin"]
       url = git@github.com:user/repo.git
   [branch "main"]
       remote = origin
       merge = refs/heads/main
   ```

**Jak Git używa `.git/`:**

```
git add plik.py
  ↓
Tworzy obiekt w objects/ 
  ↓
Dodaje do index (staging)

git commit -m "msg"
  ↓
Tworzy commit object w objects/
  ↓
Aktualizuje refs/heads/main (wskaźnik do nowego commita)
  ↓
Historia zachowana!
```

💡 **Ciekawostka:** Możesz przeglądać `.git/` ale **nigdy nie edytuj ręcznie** - użyj komend Git!

```bash
# Bezpieczne przeglądanie:
ls -la .git/
cat .git/HEAD
cat .git/config
ls .git/refs/heads/
```

---

### Koncepcja migawek (snapshots)

Git nie zapisuje różnic między plikami - robi **"zdjęcia" całego projektu**!

```
Commit 1 (10:00)          Commit 2 (11:00)          Commit 3 (12:00)
┌─────────────┐          ┌─────────────┐          ┌─────────────┐
│ plik1.py    │          │ plik1.py    │          │ plik1.py    │
│ plik2.py    │   →      │ plik2.py *  │   →      │ plik2.py *  │
│ README.md   │          │ README.md   │          │ README.md * │
└─────────────┘          └─────────────┘          └─────────────┘
                         (zmieniony)              (zmieniony)
```

**Inteligentna optymalizacja:**
- Jeśli plik się nie zmienił → Git zapisuje tylko odniesienie do poprzedniej wersji
- Jeśli plik się zmienił → Git zapisuje nową wersję
- To oszczędza miejsce i jest szybkie!

### Prawie wszystko jest lokalne

💡 **To sprawia, że Git jest błyskawiczny!**

**Operacje lokalne (bez internetu):**
- ✅ Tworzenie commitów
- ✅ Przeglądanie historii
- ✅ Przełączanie gałęzi
- ✅ Porównywanie wersji
- ✅ Cofanie zmian

**Operacje wymagające internetu:**
- 🌐 `git push` - wysyłanie do zdalnego repozytorium
- 🌐 `git pull` - pobieranie ze zdalnego repozytorium
- 🌐 `git clone` - klonowanie repozytorium

---

## 3. Podstawowe pojęcia

### Repozytorium (Repository)

**Repozytorium = folder z projektem + cała historia zmian**

Dlaczego "historia zmian"? Bo Git pamięta:
- 📸 Każdą wersję każdego pliku
- 👤 Kto wprowadził zmiany
- 📅 Kiedy zostały wprowadzone
- 💬 Dlaczego (komunikat commita)
- 🔙 Możliwość cofnięcia się do dowolnego momentu

```
Zwykły folder:           Repozytorium Git:
┌──────────────┐        ┌──────────────────────┐
│ plik1.py     │        │ plik1.py             │
│ plik2.py     │        │ plik2.py             │
│ README.md    │        │ README.md            │
└──────────────┘        │                      │
                        │ + .git/ (folder)     │
                        │   Tutaj Git trzyma:  │
                        │   - kto zmienił?     │
                        │   - kiedy?           │
                        │   - dlaczego?        │
                        │   - wszystkie wersje!│
                        └──────────────────────┘
```

**Różnica:**
- Zwykły folder: widzisz tylko obecną wersję plików
- Repozytorium Git: widzisz obecną wersję + masz dostęp do całej historii

### Commit (migawka)

**Commit = zapis gry w Gicie**

Tak jak w grze robisz save point, w Git robisz commit.

Każdy commit zawiera:
- 📸 Migawkę wszystkich plików w projekcie
- 👤 Kto zrobił commit (autor)
- 📅 Kiedy (data i czas)
- 💬 Wiadomość opisującą co zostało zmienione
- 🔗 Link do poprzedniego commita (rodzica)

```
Commit: a3f5b81
Autor: Jan Kowalski
Data: 2025-12-14 10:30
Wiadomość: "Add login function"

Rodzic: 9d2e1c4
```

### Stany pliku w Git

Każdy plik w projekcie może być w jednym z czterech stanów:

```
┌─────────────┐
│  Untracked  │  Git nie wie o tym pliku
└──────┬──────┘  (nowy plik w folderze)
       │ git add
┌──────▼──────┐
│   Staged    │  Plik przygotowany do commita
└──────┬──────┘  (w poczekalni)
       │ git commit
┌──────▼──────┐
│ Unmodified  │  Plik śledzony, bez zmian
└──────┬──────┘  (wszystko ok)
       │ edycja pliku
┌──────▼──────┐
│  Modified   │  Plik zmieniony, ale nie staged
└──────┬──────┘  (trzeba go dodać do staging)
       │ git add
       └────────→ Staged
```

**Inna wizualizacja:**

```mermaid
stateDiagram-v2
    [*] --> Untracked: nowy plik
    Untracked --> Staged: git add
    Staged --> Unmodified: git commit
    Unmodified --> Modified: edycja pliku
    Modified --> Staged: git add
    Staged --> Modified: edycja pliku
    Unmodified --> [*]: git rm
```

**Praktyczny przykład:**

```bash
# 1. Tworzysz nowy plik
echo "print('Hello')" > app.py
# Stan: Untracked

# 2. Dodajesz do staging
git add app.py
# Stan: Staged

# 3. Robisz commit
git commit -m "Add app.py"
# Stan: Unmodified

# 4. Edytujesz plik
echo "print('World')" >> app.py
# Stan: Modified

# 5. Dodajesz do staging
git add app.py
# Stan: Staged (gotowy do kolejnego commita)
```

### HEAD - gdzie teraz jesteś

**HEAD = wskaźnik pokazujący "jesteś tutaj" w historii projektu**

Wyobraź sobie historię commitów jako linię czasu:

```
Commit 1 ← Commit 2 ← Commit 3 ← Commit 4
                                     ↑
                                   HEAD
                               (jesteś tutaj)
```

- HEAD zazwyczaj wskazuje na najnowszy commit w aktualnej gałęzi
- Gdy przełączasz gałęzie, HEAD się przesuwa
- Gdy cofasz historię, HEAD się cofa

### Working Directory (katalog roboczy)

**Working Directory = twój zwykły folder z plikami, nad którym pracujesz**

To jest to, co widzisz w eksploratorze plików. Twoje pliki `.py`, `.txt`, itp.

### Staging Area (poczekalnia)

**Staging Area = poczekalnia dla zmian przed commitem**

Dlaczego potrzebujemy poczekalni?

```
Zmienione pliki:           Staging Area:          Commit:
┌──────────────┐          ┌──────────────┐       ┌──────────────┐
│ app.py       │          │              │       │              │
│ config.py    │  git add │ app.py       │ git   │ app.py       │
│ test.py      │  ──────→ │ config.py    │ commit│ config.py    │
│ debug.log    │          │              │ ────→ │              │
└──────────────┘          └──────────────┘       └──────────────┘
```

**Możesz wybrać które zmiany commitniesz!**

Przykład: Zmieniłeś 3 pliki, ale chcesz commitnąć tylko 2:
```bash
git add app.py config.py    # Tylko te 2 idą do staging
git commit -m "Add app and config modules"   # Commit zawiera tylko app.py i config.py
# test.py i debug.log pozostają zmienione, ale bez commita
```

💡 **Zaleta:** Możesz organizować commity logicznie, nie musisz commitować wszystkiego naraz!

---

**🎯 ĆWICZENIE 3: Staging Area**

Zrób to teraz! (3 minuty)

1. Utwórz 3 pliki: `plik1.txt`, `plik2.txt`, `plik3.txt`
2. Sprawdź status: `git status` (3 untracked files)
3. Dodaj tylko 2 pliki: `git add plik1.txt plik2.txt`
4. Sprawdź status: `git status`
   - plik1, plik2 = staged (zielone)
   - plik3 = untracked (czerwony)
5. Commitnij: `git commit -m "Add plik1 and plik2"`
6. Status: plik3 nadal nie jest w repozytorium!

✅ **Zrozumiałeś staging area!** Możesz wybierać co commitować.

---

### 🧠 Quiz — Część 1: Podstawy

Sprawdź czy zrozumiałeś materiał. Kliknij "Pokaż odpowiedź" po przemyśleniu.

**Pytanie 1.** Co oznacza określenie, że Git jest "rozproszonym" systemem kontroli wersji?

- A) Pliki w repozytorium są rozrzucone po wielu folderach
- B) Każdy programista ma pełną kopię historii projektu lokalnie
- C) Git wymaga połączenia z internetem do każdej operacji
- D) Git rozsyła zmiany do wszystkich członków zespołu automatycznie

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — każdy klon repo zawiera całą historię, dlatego operacje takie jak `log`, `commit`, `diff` działają offline. A) opisuje organizację plików, nie kontrolę wersji. C) jest odwrotnie — większość operacji jest lokalna. D) Git niczego nie rozsyła sam — musisz zrobić `push`.

</details>

---

**Pytanie 2.** Jaka jest poprawna kolejność stanów pliku w Git od momentu jego utworzenia do zacommitowania?

- A) Modified → Staged → Untracked → Committed
- B) Untracked → Modified → Staged → Committed
- C) Untracked → Staged → Committed (Unmodified)
- D) Staged → Untracked → Modified → Committed

<details><summary>💡 Pokaż odpowiedź</summary>

**C** — nowy plik jest `Untracked`, po `git add` trafia do `Staged`, a po `git commit` staje się `Unmodified` (śledzony, bez zmian). `Modified` pojawia się dopiero gdy zmienisz już śledzony plik.

</details>

---

**Pytanie 3.** Folder `.git/` w Twoim projekcie:

- A) Zawiera kopię zapasową plików projektu w formacie tekstowym
- B) Zawiera całą historię commitów, branche i konfigurację — usunięcie go niszczy historię
- C) Jest automatycznie synchronizowany z GitHubem co kilka minut
- D) Możesz bezpiecznie edytować pliki w `.git/` ręcznie, żeby coś naprawić

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `.git/` to "serce" repozytorium. A) zawartość jest zhashowana i skompresowana, nie tekstowa. C) nic nie jest auto-synchronizowane — musisz `push`. D) NIGDY nie edytuj plików w `.git/` ręcznie — używaj komend Git.

</details>

---

**Pytanie 4.** Czym jest HEAD w Git?

- A) Najnowszy commit w repozytorium
- B) Wskaźnik na aktualną pozycję w historii (zazwyczaj na końcu aktywnego brancha)
- C) Pierwszy commit w repozytorium
- D) Nazwa głównej gałęzi

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — HEAD to ruchomy wskaźnik mówiący "tu teraz jestem". Zwykle wskazuje na ostatni commit aktywnego brancha, ale może też wskazywać konkretny commit (stan "detached HEAD") lub zostać przesunięty przez `git reset`.

</details>

---

## 4. Podstawowe komendy - pierwsze kroki

### `git init` - inicjalizacja repozytorium

**Co robi:** Tworzy nowe repozytorium Git w obecnym folderze (tworzy `.git/`)

**Kiedy używać:** Gdy zaczynasz nowy projekt i chcesz go śledzić Gitem

```bash
mkdir moj_projekt
cd moj_projekt
git init
```

**Rezultat:**
```
Initialized empty Git repository in /Users/ja/moj_projekt/.git/
```

### `git clone <url>` - klonowanie repozytorium

**Co robi:** Pobiera istniejące repozytorium z internetu (np. z GitHuba)

**Kiedy używać:** Gdy chcesz pobrać projekt, nad którym będziesz pracować

```bash
git clone https://github.com/username/projekt.git
```

**Rezultat:** Tworzy folder `projekt/` z całą historią

💡 **Różnica:** `git init` = nowe repozytorium, `git clone` = kopiujesz istniejące

---

**🎯 ĆWICZENIE 1: Twoje pierwsze repozytorium**

Zrób to teraz! (2 minuty)

1. Otwórz terminal
2. Utwórz folder testowy: `mkdir git_test`
3. Wejdź do niego: `cd git_test`
4. Zainicjalizuj repozytorium: `git init`
5. Zobacz co się stało: `ls -la` (powinien być folder `.git`)

✅ **Sukces!** Właśnie utworzyłeś swoje pierwsze repozytorium Git!

---

### `git status` - sprawdzanie stanu

**Co robi:** Pokazuje aktualny stan repozytorium

**Kiedy używać:** ZAWSZE! To najczęściej używana komenda 🏆

```bash
git status
```

**Przykładowy output:**
```
On branch main
Changes not staged for commit:
  modified:   app.py

Untracked files:
  test.py
```

> [!TIP]
> **PRO TIP:** Używaj `git status` **przed i po każdej operacji** — to najtańsza komenda i nigdy nie zaszkodzi. 90% błędów początkujących wynika z niesprawdzenia stanu repo.

---

**🎯 ĆWICZENIE 2: Pierwszy commit**

Zrób to teraz! (3 minuty)

1. Utwórz plik: otwórz edytor i stwórz `test.txt` z tekstem "Hello Git!"
2. Sprawdź status: `git status` (plik powinien być "Untracked")
3. Dodaj do staging: `git add test.txt`
4. Sprawdź status ponownie: `git status` (teraz "Changes to be committed")
5. Zrób commit: `git commit -m "Initial commit"`
6. Sprawdź historię: `git log`

✅ **Brawo!** Właśnie zrobiłeś swój pierwszy commit!

---

### `git add <plik>` - dodawanie do staging

**Co robi:** Przygotowuje pliki do commita (dodaje do staging area)

**Kiedy używać:** Gdy masz zmiany i chcesz je commitnąć

```bash
# Dodaj konkretny plik
git add app.py

# Dodaj wszystkie zmienione pliki
git add .

# Dodaj wszystkie pliki .py
git add *.py

# Dodaj pliki interaktywnie (zaawansowane)
git add -p
```

> [!WARNING]
> **PUŁAPKA:** `git add .` dodaje **wszystkie** zmodyfikowane pliki — łącznie z tymi, których nie chciałeś (debug.log, .env, śmieci). Zawsze najpierw `git status`, potem celowo dodaj wybrane pliki.

### `git commit -m "wiadomość"` - tworzenie migawki

**Co robi:** Tworzy commit ze zmian w staging area

**Kiedy używać:** Gdy skończyłeś logiczną część pracy i chcesz zapisać

```bash
git commit -m "Add login function"
```

**Dobre komunikaty commitów:**
- ✅ "Fix login error with empty password"
- ✅ "Add email validation to form"
- ✅ "Remove unused imports from app.py"

**Złe komunikaty:**
- ❌ "fix"
- ❌ "changes"
- ❌ "asdf"
- ❌ "commit"
- ❌ "Fixed login bug" — zły czas (powinno być `Fix login bug`)

💡 **Format:** Angielski + tryb rozkazujący (imperatyw) + konkretny opis. Pełne zasady — patrz rozdz. 8.

### `git log` - przeglądanie historii

**Co robi:** Pokazuje historię commitów

**Kiedy używać:** Gdy chcesz zobaczyć co się działo w projekcie

```bash
# Pełna historia
git log

# Zwięzła wersja (zalecana)
git log --oneline

# Z grafiką gałęzi
git log --oneline --graph

# Ostatnie 5 commitów
git log -5
```

**Output `git log --oneline`:**
```
a3f5b81 Add login function
9d2e1c4 Fix email validation
2b8c930 Create project structure
```

### `git diff` - przeglądanie różnic

**Co robi:** Pokazuje różnice między wersjami plików

**Kiedy używać:** Gdy chcesz zobaczyć dokładnie co zostało zmienione

**Podstawowe użycie:**

```bash
# Pokaż zmiany w working directory (niestagowane)
git diff

# Pokaż zmiany w staging area
git diff --staged
# lub
git diff --cached

# Porównaj z konkretnym commitem
git diff HEAD~1

# Porównaj dwa commity
git diff a3f5b81 9d2e1c4

# Pokaż zmiany tylko w konkretnym pliku
git diff app.py
```

**Jak czytać diff:**

```diff
diff --git a/app.py b/app.py
index abc1234..def5678 100644
--- a/app.py
+++ b/app.py
@@ -10,7 +10,8 @@ def hello():
     return "Hello"
 
 def goodbye():
-    return "Goodbye"
+    return "Goodbye!"
+    # Dodano wykrzyknik
```

**Legenda:**
- `---` = stara wersja pliku
- `+++` = nowa wersja pliku
- `@@ -10,7 +10,8 @@` = zakres zmian (linia 10, 7 linii → linia 10, 8 linii)
- 🔴 Czerwone linie z `-` = usunięte
- 🟢 Zielone linie z `+` = dodane
- Białe linie = bez zmian (kontekst)

**Przydatne opcje:**

```bash
# Zmiany w ostatnim commicie
git diff HEAD~1 HEAD

# Statystyki (ile linii dodano/usunięto)
git diff --stat

# Tylko nazwy zmienionych plików
git diff --name-only

# Ignoruj białe znaki
git diff -w
```

> [!TIP]
> **PRO TIP:** Zawsze `git diff` przed `git add`. Inaczej dodajesz "w ciemno" i prędzej czy później zacommitujesz `console.log`, `print("DEBUG")` albo zakomentowany kod.

### `git push` - wysyłanie do zdalnego repozytorium

**Co robi:** Wysyła lokalne commity do zdalnego repozytorium (np. GitHub)

**Kiedy używać:** Gdy chcesz udostępnić swoją pracę lub zrobić backup

```bash
# Pierwsza wysyłka nowej gałęzi
git push -u origin main

# Kolejne pushowanie
git push
```

⚠️ **Wymaga internetu!** 🌐

---

## 4.1. Praca ze zdalnymi repozytoriami

### Czym jest zdalne repozytorium (remote)?

**Zdalne repozytorium = kopia Twojego projektu na serwerze w internecie**

Najpopularniejsze platformy:
- 🐙 **GitHub** - najpopularniejszy, darmowy dla projektów publicznych
- 🦊 **GitLab** - open source, darmowy
- 🪣 **Bitbucket** - od Atlassian

### `git clone <url>` - kopiowanie repozytorium

**Co robi:** Pobiera całe repozytorium z serwera na Twój komputer

**Kiedy używać:** Gdy chcesz pobrać istniejący projekt

```bash
# Sklonuj repozytorium z GitHuba
git clone https://github.com/username/projekt.git

# Sklonuj do folderu o własnej nazwie
git clone https://github.com/username/projekt.git moj_projekt
```

**Co się dzieje:**
1. Git tworzy folder z nazwą projektu
2. Pobiera całą historię commitów
3. Automatycznie dodaje zdalne repozytorium jako `origin`
4. Ustawia aktualny branch (zazwyczaj `main`)

**Rezultat:**
```
Cloning into 'projekt'...
remote: Enumerating objects: 125, done.
remote: Counting objects: 100% (125/125), done.
remote: Compressing objects: 100% (89/89), done.
Receiving objects: 100% (125/125), 15.23 KiB | 1.52 MiB/s, done.
```

### `git remote` - zarządzanie zdalnymi repozytoriami

**Co robi:** Pokazuje i zarządza połączeniami ze zdalnymi repozytoriami

```bash
# Lista zdalnych repozytoriów
git remote -v

# Dodaj nowe zdalne repozytorium
git remote add origin https://github.com/username/projekt.git

# Zmień URL zdalnego repozytorium
git remote set-url origin https://github.com/username/nowy-projekt.git

# Usuń zdalne repozytorium
git remote remove origin
```

**Output `git remote -v`:**
```
origin  https://github.com/username/projekt.git (fetch)
origin  https://github.com/username/projekt.git (push)
```

**Nazwa `origin`** to standardowa konwencja dla głównego zdalnego repozytorium.

### Autentykacja: HTTPS vs SSH

#### Czym jest SSH?

**SSH (Secure Shell)** = bezpieczny protokół komunikacji przez sieć

Wyobraź sobie to jako:
- 🔑 **HTTPS** = pokazujesz dowód osobisty (login + hasło/token) przy każdym wejściu
- 🔐 **SSH** = masz unikalny klucz do drzwi, raz skonfigurujesz i już zawsze wchodzisz automatycznie

**Jak działa SSH (w uproszczeniu):**

1. **Generujesz parę kluczy:**
   - 🔓 **Klucz publiczny** - dajesz go GitHubowi (jak zamek w drzwiach)
   - 🔒 **Klucz prywatny** - zostaje tylko u Ciebie (jak Twój unikalny klucz)

2. **Gdy łączysz się z GitHubem:**
   - GitHub sprawdza czy Twój klucz prywatny pasuje do klucza publicznego
   - Jeśli tak - wpuszcza Cię automatycznie
   - Wszystko szyfrowane, nikt nie może podsłuchać

**Dlaczego SSH jest bezpieczny?**
- 🔐 Klucze kryptograficzne (trudniejsze do złamania niż hasła)
- 🚫 Klucz prywatny nigdy nie jest wysyłany przez sieć
- ✅ Automatyczna weryfikacja tożsamości

---

Gdy pracujesz ze zdalnymi repozytoriami, musisz się uwierzytelnić. Są dwa sposoby:

#### 1. HTTPS (prostszy na start)

**URL:**
```
https://github.com/username/projekt.git
```

**Zalety:**
- ✅ Łatwy w konfiguracji
- ✅ Działa wszędzie (nawet za firewallem)
- ✅ Wystarczy podać login/hasło lub token

**Wady:**
- ❌ Musisz wpisywać token przy każdym push/pull (albo zapisać w cache)
- ❌ Mniej bezpieczny niż SSH

**Jak używać:**
```bash
# Przy pierwszym push GitHub poprosi o token
git clone https://github.com/username/projekt.git
cd projekt
# ... zmiany ...
git push  # Poprosi o username + token
```

💡 **Token zamiast hasła:** Od 2021 GitHub nie przyjmuje haseł - musisz wygenerować Personal Access Token w ustawieniach GitHub.

#### 2. SSH (zalecany dla regularnej pracy)

**URL:**
```
git@github.com:username/projekt.git
```

**Zalety:**
- ✅ Bezpieczniejszy (klucze kryptograficzne)
- ✅ Wygodniejszy - nie musisz wpisywać hasła
- ✅ Automatyczna autentykacja

**Wady:**
- ❌ Wymaga wstępnej konfiguracji
- ❌ Może nie działać za niektórymi firewall'ami

### Konfiguracja SSH - krok po kroku

**1. Sprawdź czy masz już klucz SSH:**
```bash
ls -la ~/.ssh
# Szukaj: id_rsa.pub, id_ed25519.pub lub podobnych
```

**2. Wygeneruj nowy klucz SSH (jeśli nie masz):**

**Opcja A - ED25519 (nowszy, bezpieczniejszy - Linux, Windows, nowszy macOS):**
```bash
ssh-keygen -t ed25519 -C "twoj.email@example.com"
```

**Opcja B - RSA (starszy, ale działa wszędzie - zalecany dla macOS):**
```bash
ssh-keygen -t rsa -b 4096 -C "twoj.email@example.com"
```

💡 **Który wybrać?**
- **macOS (szczególnie starsze wersje):** Użyj RSA (`-t rsa`)
- **Linux/Windows/nowszy macOS:** Możesz użyć ED25519 lub RSA
- **Jeśli nie wiesz:** Użyj RSA - działa wszędzie

**Proces (przykład dla RSA):**
```
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/ty/.ssh/id_rsa): 
[naciśnij Enter - domyślna lokalizacja]

Enter passphrase (empty for no passphrase): 
[opcjonalnie: wpisz hasło dla klucza lub pozostaw puste]

Your public key has been saved in /Users/ty/.ssh/id_rsa.pub
```

**Dla ED25519 (jeśli działa):**
```
Your public key has been saved in /Users/ty/.ssh/id_ed25519.pub
```

**3. Skopiuj klucz publiczny:**

**Dla RSA:**
```bash
cat ~/.ssh/id_rsa.pub
```

**Dla ED25519:**
```bash
cat ~/.ssh/id_ed25519.pub
```

Skopiuj CAŁĄ zawartość (zaczyna się od `ssh-rsa ...` lub `ssh-ed25519 ...`)

**4. Dodaj klucz do GitHuba:**

a) Idź na GitHub → Settings (ikona profilu)
b) Wybierz "SSH and GPG keys"
c) Kliknij "New SSH key"
d) Wklej skopiowany klucz
e) Nadaj nazwę (np. "Mój laptop")
f) Kliknij "Add SSH key"

**5. Przetestuj połączenie:**
```bash
ssh -T git@github.com
```

**Oczekiwany output:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

✅ **Działa!** Możesz teraz używać SSH.

**6. Użycie SSH do klonowania:**
```bash
# Teraz użyj SSH URL zamiast HTTPS
git clone git@github.com:username/projekt.git
```

**Zmiana z HTTPS na SSH w istniejącym repozytorium:**
```bash
git remote set-url origin git@github.com:username/projekt.git
```

### Różnice HTTPS vs SSH - podsumowanie

| Aspekt | HTTPS | SSH |
|--------|-------|-----|
| **Konfiguracja** | Brak (od razu działa) | Wymaga wygenerowania i dodania klucza |
| **Autentykacja** | Token przy każdym push | Automatyczna po konfiguracji |
| **Bezpieczeństwo** | Dobra (token) | Bardzo dobra (klucze kryptograficzne) |
| **Firewall** | Działa wszędzie (port 443) | Może być blokowany (port 22) |
| **Dla początkujących** | ✅ Łatwiejszy start | ⚠️ Wymaga konfiguracji |
| **Dla zawodowców** | ⚠️ Mniej wygodny | ✅ Zalecany |

💡 **Zalecenie:** Zacznij od HTTPS, gdy się przyzwyczaisz - przejdź na SSH.

---

### `git fetch` vs `git pull` - różnica

**Problem dla początkujących:**

Czym różni się `git fetch` od `git pull`? Kiedy używać którego?

#### `git fetch` - tylko pobierz

**Co robi:** Pobiera zmiany ze zdalnego repozytorium, ale **NIE** scala ich automatycznie

```bash
git fetch origin
```

**Co się dzieje:**
1. Git pobiera wszystkie nowe commity z serwera
2. Aktualizuje informacje o zdalnych branchach (`origin/main`)
3. **Twój lokalny branch pozostaje niezmieniony**
4. Możesz przejrzeć zmiany przed scaleniem

**Kiedy używać:**
- ✅ Chcesz zobaczyć co się zmieniło, ale jeszcze nie scalać
- ✅ Chcesz mieć kontrolę nad procesem
- ✅ Pracujesz nad czymś i nie chcesz przypadkowych konfliktów

**Przykład workflow:**
```bash
git fetch origin
git log origin/main  # Zobacz co jest na serwerze
git diff main origin/main  # Porównaj zmiany
git merge origin/main  # Zdecyduj się scalić
```

#### `git pull` - pobierz i scal

**Co robi:** Pobiera zmiany **i automatycznie scala** je do Twojego brancha

```bash
git pull
# To jest skrót dla:
git fetch origin
git merge origin/main
```

**Co się dzieje:**
1. Git pobiera zmiany z serwera (fetch)
2. Od razu scala je do Twojego brancha (merge)
3. Może wystąpić konflikt do rozwiązania

**Kiedy używać:**
- ✅ Na początku dnia - synchronizacja z zespołem
- ✅ Wiesz że nie będzie konfliktów
- ✅ Chcesz szybko zaktualizować kod

#### Porównanie

| Aspekt | `git fetch` | `git pull` |
|--------|-------------|------------|
| **Pobiera zmiany** | ✅ Tak | ✅ Tak |
| **Scala automatycznie** | ❌ Nie | ✅ Tak |
| **Bezpieczeństwo** | ✅ Bezpieczniejszy | ⚠️ Może nadpisać |
| **Kontrola** | ✅ Pełna kontrola | ⚠️ Automatyczne |
| **Dla początkujących** | ⚠️ Wymaga dodatkowego merge | ✅ Prostszy |
| **Dla zawodowców** | ✅ Zalecany | ⚠️ Gdy wiesz co robisz |

#### Wizualizacja

```
PRZED:
Ty lokalnie:        A ← B ← C
                              ↑
                            main

Na serwerze:        A ← B ← C ← D ← E
                                    ↑
                              origin/main

═══════════════════════════════════════

git fetch:
Ty lokalnie:        A ← B ← C
                              ↑
                            main

Lokalna kopia       A ← B ← C ← D ← E
origin/main:                        ↑
                              origin/main

Twój kod NIE zmieniony! Możesz przejrzeć D i E.

═══════════════════════════════════════

git pull:
Ty lokalnie:        A ← B ← C ← D ← E
                                    ↑
                                  main

Kod od razu zmieniony! (może być konflikt)
```

**Inna wizualizacja:**

```mermaid
sequenceDiagram
    participant WD as Working Dir<br/>(main)
    participant L as Lokalne refs<br/>(origin/main)
    participant R as Remote<br/>(GitHub)

    rect rgb(220, 240, 220)
    Note over WD,R: git fetch — tylko pobiera
    L->>R: Sprawdź nowe commity
    R-->>L: Wyślij D, E
    Note over L: origin/main: A B C D E
    Note over WD: main: A B C (BEZ zmian!)
    end

    rect rgb(255, 230, 220)
    Note over WD,R: git pull — pobiera + scala
    L->>R: Sprawdź nowe commity
    R-->>L: Wyślij D, E
    Note over L: origin/main: A B C D E
    L->>WD: Automatyczny merge
    Note over WD: main: A B C D E (zmienione!)
    end
```

💡 **Złota zasada:**
- 🟢 **Używaj `git pull`** gdy zaczynasz pracę (rano)
- 🟡 **Używaj `git fetch`** gdy chcesz sprawdzić co się zmieniło
- 🔴 **Nigdy nie rób `pull`** gdy masz niezcommitowane zmiany (użyj `stash` najpierw)

#### 🌳 Drzewo decyzyjne — `fetch` czy `pull`?

```mermaid
flowchart TD
    Start([Chcę zsynchronizować się z remote]) --> Q1{Mam niezcommitowane<br/>zmiany lokalne?}
    Q1 -->|Tak| Stash[git stash<br/>schowaj zmiany]
    Stash --> Q2
    Q1 -->|Nie| Q2{Chcę natychmiast<br/>zaktualizować kod?}
    Q2 -->|Tak, ufam zmianom z remote| Pull[git pull<br/>pobierz i scal automatycznie]
    Q2 -->|Nie, chcę najpierw zobaczyć co się zmieniło| Fetch[git fetch<br/>tylko pobierz info]
    Fetch --> Review[git log origin/main<br/>git diff main origin/main]
    Review --> Q3{Zmiany OK<br/>do scalenia?}
    Q3 -->|Tak| Merge[git merge origin/main]
    Q3 -->|Nie| Wait[Zaczekaj / porozmawiaj<br/>z autorem zmian]
    Pull --> Done([✅ Lokalny kod aktualny])
    Merge --> Done

    style Pull fill:#90EE90
    style Fetch fill:#FFE4B5
    style Stash fill:#FFB6C1
    style Done fill:#87CEEB
```

---

**🎯 ĆWICZENIE 11: Klonowanie i remote**

Zrób to teraz! (5 minut)

**Część A - Klonowanie publicznego repozytorium:**
1. Sklonuj przykładowe repozytorium:
   ```bash
   cd ..  # wyjdź z git_test
   git clone https://github.com/octocat/Hello-World.git
   cd Hello-World
   ```
2. Sprawdź remote: `git remote -v`
3. Zobacz historię: `git log --oneline`
4. Sprawdź pliki: `ls`

**Część B - Dodanie remote do własnego repozytorium:**
1. Wróć do swojego repozytorium: `cd ../git_test`
2. Utwórz puste repozytorium na GitHubie (github.com → New repository)
3. Skopiuj URL (HTTPS lub SSH)
4. Dodaj remote: `git remote add origin <URL>`
5. Sprawdź: `git remote -v`
6. Wypchnij kod: `git push -u origin main`
7. Odśwież GitHub - Twój kod jest online! 🎉

**Część C - Konfiguracja SSH (opcjonalne):**
1. Wygeneruj klucz:
   - **macOS:** `ssh-keygen -t rsa -b 4096 -C "twoj@email.com"`
   - **Linux/Windows:** `ssh-keygen -t ed25519 -C "twoj@email.com"`
2. Wyświetl:
   - **RSA:** `cat ~/.ssh/id_rsa.pub`
   - **ED25519:** `cat ~/.ssh/id_ed25519.pub`
3. Dodaj na GitHub: Settings → SSH keys
4. Przetestuj: `ssh -T git@github.com`

✅ **Pracujesz ze zdalnymi repozytoriami!** Możesz współpracować z innymi.

---

### `git pull` - pobieranie zmian

**Co robi:** Pobiera i scala zmiany ze zdalnego repozytorium

**Kiedy używać:** Przed rozpoczęciem pracy, aby mieć najnowszą wersję

```bash
git pull
```

💡 **Dobre praktyki:**
1. `git pull` na początku dnia
2. Pracujesz nad kodem
3. `git push` na końcu dnia

⚠️ **Wymaga internetu!** 🌐

---

**🎯 ĆWICZENIE 4: Historia commitów**

Zrób to teraz! (2 minuty)

1. Zmień `test.txt` - dodaj linię "Druga linia"
2. Commitnij: `git add test.txt` → `git commit -m "Add second line"`
3. Zmień znowu - dodaj "Trzecia linia"
4. Commitnij: `git commit -am "Add third line"`
5. Zobacz historię: `git log --oneline`
6. Zobacz szczegóły: `git show HEAD`

✅ **Masz już 3 commity!** Widzisz historię zmian.

---

### Typowy workflow - krok po kroku

```bash
# 1. Sprawdź stan
git status

# 2. Pobierz najnowsze zmiany
git pull

# 3. Pracuj nad kodem
# (edytujesz pliki w edytorze)

# 4. Sprawdź co zmieniłeś
git status

# 5. Dodaj zmiany do staging
git add .

# 6. Sprawdź staging
git status

# 7. Zrób commit
git commit -m "Describe your changes"

# 8. Wyślij na serwer
git push

# 9. Sprawdź czy wszystko ok
git status
```

---

### 🧠 Quiz — Część 2: Podstawowe operacje

**Pytanie 1.** Wykonałeś `git add plik.py` i `git commit -m "feat: Add plik"`. Sprawdzasz GitHub i nic tam nie widzisz. Dlaczego?

- A) Bo `commit` nie wysyła zmian na serwer — trzeba zrobić `git push`
- B) Bo musisz zaczekać 5 minut na synchronizację
- C) Bo musisz zrobić `git pull` najpierw
- D) Bo `git add` musi być wykonane jeszcze raz po commicie

<details><summary>💡 Pokaż odpowiedź</summary>

**A** — `commit` zapisuje zmianę tylko **lokalnie**. Dopiero `git push` wysyła commity do remote (GitHub/GitLab). To jedna z najczęstszych pomyłek początkujących.

</details>

---

**Pytanie 2.** Jaka jest kluczowa różnica między `git fetch` a `git pull`?

- A) `fetch` jest szybszy, `pull` jest dokładniejszy
- B) `fetch` tylko pobiera zmiany do lokalnej kopii `origin/*`, `pull` od razu scala je z aktywnym branchem
- C) `fetch` pobiera tylko jeden plik, `pull` pobiera całość
- D) Nie ma różnicy, to dwie nazwy tej samej komendy

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `git pull` ≡ `git fetch` + `git merge origin/main`. `fetch` jest bezpieczniejszy, bo daje czas obejrzeć zmiany przed scaleniem (np. `git diff main origin/main`).

</details>

---

**Pytanie 3.** Co pokaże komenda `git diff` (bez argumentów)?

- A) Różnice między aktualnym commitem a poprzednim
- B) Różnice między working directory a staging area (niestagowane zmiany)
- C) Różnice między lokalnym branchem a remote
- D) Wszystkie zmiany od początku repozytorium

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `git diff` (bez argumentów) pokazuje tylko **niestagowane** zmiany. Żeby zobaczyć staged: `git diff --staged` (lub `--cached`). Żeby porównać z innym commitem: `git diff HEAD~1`.

</details>

---

**Pytanie 4.** Główne różnice między HTTPS a SSH dla połączenia z GitHubem to:

- A) HTTPS jest szybszy, SSH wolniejszy
- B) HTTPS wymaga tokena przy każdym push, SSH używa pary kluczy kryptograficznych i nie wymaga hasła po skonfigurowaniu
- C) HTTPS działa tylko dla projektów publicznych, SSH dla prywatnych
- D) SSH jest dostępne tylko na Linuxie

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — SSH wymaga jednorazowej konfiguracji (`ssh-keygen` + dodanie klucza publicznego do GitHuba), ale potem działa automatycznie. HTTPS jest prostszy na start, ale wymaga tokena przy każdym push (od 2021 GitHub nie akceptuje haseł).

</details>

---

## 5. Cofanie zmian - jak naprawić błędy

### Tabela porównawcza komend

| Komenda | Co robi | Kiedy używać | Zmienia historię? | Bezpieczeństwo |
|---------|---------|--------------|-------------------|----------------|
| `git revert <commit>` | Tworzy NOWY commit cofający zmiany | Gdy chcesz cofnąć opublikowane zmiany | ❌ NIE | ✅ Bezpieczne |
| `git reset --soft <commit>` | Cofa HEAD, zmiany zostają w staging | Gdy chcesz przerobić ostatni commit | ✅ TAK | ⚠️ Ostrożnie |
| `git reset --mixed <commit>` | Cofa HEAD i staging, pliki bez zmian | Gdy chcesz cofnąć staging | ✅ TAK | ⚠️ Ostrożnie |
| `git reset --hard <commit>` | Cofa WSZYSTKO, USUWA zmiany | Gdy chcesz wyrzucić wszystkie zmiany | ✅ TAK | ❌ NIEBEZPIECZNE! |

### Kluczowa różnica: `revert` vs `reset`

```
PRZED:
A ← B ← C ← D
            ↑
          HEAD

══════════════════════════════════════

git revert C (tworzy nowy commit E):

A ← B ← C ← D ← E
                ↑
              HEAD
                
E = nowy commit cofający zmiany z C
Historia: A, B, C, D, E wszystkie widoczne!
Efekt: zmiany z C zostały anulowane

══════════════════════════════════════

git reset --hard B (usuwa C i D):

A ← B
    ↑
  HEAD
    
C i D zniknęły z historii!
Historia: tylko A, B
Efekt: C i D nie istnieją
```

**Złota zasada:**
- 🟢 **Użyj `revert`** gdy commit był już pushowany (inni mogli go pobrać)
- 🟡 **Użyj `reset`** tylko dla lokalnych commitów, które nie były pushowane

#### 🌳 Drzewo decyzyjne — który `git reset` (i czy w ogóle)?

```mermaid
flowchart TD
    Start([Chcę cofnąć commit]) --> Q1{Czy commit był<br/>już spushowany?}
    Q1 -->|Tak, inni go widzieli| Revert[git revert &lt;commit&gt;<br/>tworzy NOWY commit cofający]
    Q1 -->|Nie, tylko lokalnie| Q2{Co chcę zachować?}
    Q2 -->|Zmiany w plikach<br/>+ staging area| Soft[git reset --soft HEAD~1<br/>cofa tylko commit]
    Q2 -->|Zmiany w plikach<br/>BEZ staging| Mixed[git reset HEAD~1<br/>= --mixed, domyślne]
    Q2 -->|NIC, wyrzucić wszystko<br/>⚠️ bezpowrotnie| Hard[git reset --hard HEAD~1<br/>❌ NIEBEZPIECZNE!]
    Soft --> Use1[Mogę poprawić commit<br/>i commitnąć ponownie]
    Mixed --> Use2[Mogę wybrać co dodać<br/>z powrotem do staging]
    Hard --> Warn[⚠️ Sprawdź najpierw<br/>git reflog<br/>żeby móc cofnąć]

    style Revert fill:#90EE90
    style Soft fill:#FFE4B5
    style Mixed fill:#FFE4B5
    style Hard fill:#FF6961
    style Warn fill:#FF6961
```

**Mnemotechnika:** `--soft` = miękkie cofnięcie (najwięcej zostaje), `--hard` = twarde (nic nie zostaje).

---

**🎯 ĆWICZENIE 5: Cofanie zmian**

Zrób to teraz! (4 minuty)

1. Dodaj błędną linię do `test.txt`: "BŁĄD DO USUNIĘCIA"
2. Sprawdź: `git diff` (widzisz zmianę)
3. Cofnij: `git restore test.txt`
4. Sprawdź: `cat test.txt` (błąd zniknął!)
5. Teraz dodaj linię "Commit do revert" i commitnij
6. Cofnij ten commit: `git revert HEAD`
7. Zobacz historię: `git log --oneline` (oba commity widoczne!)

✅ **Potrafisz cofać zmiany!** Bezpiecznie i z historią.

---

### `git stash` - tymczasowe schowanie zmian

#### Problem

**Scenariusz z życia:**

Pracujesz nad nową funkcją (plik zmieniony, nie commitnięty). Nagle:
- 🚨 Szef: "Pilny bugfix! Przełącz się na main!"
- ❌ Git: "Nie mogę - masz niezcommitowane zmiany"
- 😰 Co robić?

**Opcja 1 - Commit niedokończonej pracy:**
```bash
git commit -m "WIP - unfinished"  # ❌ Brzydkie, psuje historię
```

**Opcja 2 - Stash (schowaj zmiany):**
```bash
git stash  # ✅ Zmiany bezpiecznie schowane
```

#### Czym jest `git stash`?

**Stash = tymczasowy schowek na zmiany**

Wyobraź sobie że:
- Odkładasz swoją robotę do szuflady
- Sprzątasz biurko (przełączasz branch)
- Robisz coś innego
- Wracasz i wyciągasz robotę z szuflady

```
Masz zmiany → git stash → czyste repozytorium → możesz przełączyć branch
                 ↓
            [szuflada]
                 ↓
git stash pop → zmiany wracają
```

#### Podstawowe komendy

**1. Schowaj zmiany:**
```bash
git stash
# lub z opisem:
git stash save "Work on feature X"
```

**2. Zobacz co jest w stash:**
```bash
git stash list
```
**Output:**
```
stash@{0}: WIP on main: a3f5b81 Ostatni commit
stash@{1}: WIP on feature: 9d2e1c4 Inna praca
```

**3. Przywróć ostatnie zmiany:**
```bash
git stash pop  # Przywraca i usuwa ze stash
```

**4. Przywróć ale zostaw kopię:**
```bash
git stash apply  # Przywraca, ale zostaje w stash
```

**5. Przywróć konkretny stash:**
```bash
git stash apply stash@{1}
```

**6. Usuń stash:**
```bash
git stash drop stash@{0}  # Usuń konkretny
git stash clear  # Usuń wszystkie
```

#### Praktyczny przykład

```bash
# 1. Pracujesz nad funkcją
echo "def nowa_funkcja(): pass" >> app.py
git status  # modified: app.py

# 2. Pilny bugfix - musisz przełączyć branch
git stash save "Unfinished new feature"
# Zapisane! Teraz working directory jest czysty

# 3. Przełącz się i napraw bug
git switch main
# ... naprawa buga ...
git commit -m "fix: Urgent bug fix"

# 4. Wróć do swojej pracy
git switch feature/nowa-funkcja
git stash pop  # Twoje zmiany wracają!
```

#### Co stash zapisuje?

✅ **Zapisuje:**
- Modified files (zmienione pliki)
- Staged files (pliki w staging)

❌ **NIE zapisuje:**
- Untracked files (nowe pliki) - chyba że użyjesz `git stash -u`
- Ignored files (.gitignore)

#### Przydatne opcje

```bash
# Stash z untracked files
git stash -u

# Stash wszystkiego (nawet ignored)
git stash -a

# Zobacz zmiany w stash
git stash show stash@{0}

# Zobacz szczegółowy diff
git stash show -p stash@{0}

# Utwórz branch ze stash
git stash branch nowy-branch stash@{0}
```

#### Stash vs Commit

| Aspekt | `git stash` | `git commit` |
|--------|-------------|--------------|
| **Historia** | Tymczasowy, nie w historii | Permanentny, w historii |
| **Cel** | Odłóż na chwilę | Zapisz na stałe |
| **Widoczność** | Tylko lokalnie | Widoczny dla wszystkich |
| **Komunikat** | Opcjonalny | Wymagany |
| **Kiedy używać** | Niedokończona praca | Gotowa funkcjonalność |

💡 **Kiedy używać stash:**
- 🔄 Musisz szybko przełączyć branch
- 🧪 Chcesz przetestować kod bez Twoich zmian
- 🚫 Nie możesz zrobić pull (masz lokalne zmiany)
- 💾 Praca niedokończona, nie chcesz commitować

---

**🎯 ĆWICZENIE 12: git stash**

Zrób to teraz! (3 minuty)

1. Zmień `test.txt` - dodaj "Praca w toku"
2. Sprawdź status: `git status` (modified)
3. Schowaj: `git stash save "Testing stash"`
4. Sprawdź status: `git status` (clean!)
5. Zobacz stash: `git stash list`
6. Przywróć: `git stash pop`
7. Sprawdź: `cat test.txt` (zmiany wróciły!)

✅ **Umiesz tymczasowo schować pracę!** Przydatne w codziennej pracy.

---

### `git revert <commit>` - bezpieczne cofanie

**Co robi:** Tworzy nowy commit, który cofa zmiany z wybranego commita

**Przykład:**
```bash
# Zobacz historię
git log --oneline
# a3f5b81 Add feature X (błąd!)
# 9d2e1c4 Fix Y
# 2b8c930 Add Z

# Cofnij commit a3f5b81
git revert a3f5b81
```

**Rezultat:** Git tworzy nowy commit, który cofa zmiany z `a3f5b81`

✅ **Zalety:**
- Historia jest zachowana
- Można zobaczyć, że coś było cofnięte
- Bezpieczne dla współpracy

### `git reset --soft <commit>` - cofnięcie commita

**Co robi:** Cofa HEAD do wybranego commita, zmiany zostają w staging

**Przykład:**
```bash
# Zrobiłeś commit, ale chcesz poprawić wiadomość
git reset --soft HEAD~1
# Zmiany z commita są teraz w staging
# Możesz je commitnąć ponownie z lepszą wiadomością
git commit -m "Improve commit message"
```

⚠️ **Używaj tylko dla lokalnych commitów!**

### `git reset --mixed <commit>` - cofnięcie staging

**Co robi:** Cofa HEAD i staging, zmiany w plikach zostają

**Przykład:**
```bash
# Dodałeś pliki do staging przez przypadek
git add .
git status
# Ups, dodałem debug.log!

# Cofnij staging (domyślnie --mixed)
git reset

# Teraz możesz dodać tylko to co chcesz
git add app.py config.py
git commit -m "Add correct changes"
```

💡 **To jest domyślne zachowanie `git reset`**

### `git reset --hard <commit>` - NIEBEZPIECZNE!

**Co robi:** Cofa WSZYSTKO - HEAD, staging i pliki. USUWA zmiany!

```bash
# ⚠️ TO USUNIE TWOJE ZMIANY!
git reset --hard HEAD~1
```

❌ **NIEBEZPIECZEŃSTWO:**
- Tracisz wszystkie niezcommitowane zmiany
- Nie możesz tego łatwo cofnąć
- Zmieniona historia może zepsuć repozytorium kolegów

✅ **Bezpieczne użycie:**
```bash
# Chcesz wyrzucić wszystkie lokalne zmiany i wrócić do stanu z ostatniego commita
git reset --hard HEAD

# Lub
git reset --hard origin/main  # Wróć do stanu ze zdalnego repozytorium
```

### Porównanie działania `reset`

```
Stan przed:
Commit A ← Commit B ← Commit C
                          ↑
                        HEAD
Working Dir: zmieniony plik.py (niezcommitowany)
Staging: plik.py

╔═══════════════════════════════════════════════════════════╗
║  git reset --soft B                                       ║
╠═══════════════════════════════════════════════════════════╣
║  HEAD: B                                                  ║
║  Staging: plik.py + zmiany z commita C                   ║
║  Working Dir: plik.py zmieniony                           ║
╚═══════════════════════════════════════════════════════════╝

╔═══════════════════════════════════════════════════════════╗
║  git reset --mixed B (lub git reset B)                    ║
╠═══════════════════════════════════════════════════════════╣
║  HEAD: B                                                  ║
║  Staging: pusty                                           ║
║  Working Dir: plik.py zmieniony + zmiany z C              ║
╚═══════════════════════════════════════════════════════════╝

╔═══════════════════════════════════════════════════════════╗
║  git reset --hard B                                       ║
╠═══════════════════════════════════════════════════════════╣
║  HEAD: B                                                  ║
║  Staging: pusty                                           ║
║  Working Dir: CZYSTY (wszystkie zmiany USUNIĘTE!)         ║
╚═══════════════════════════════════════════════════════════╝
```

### Inne przydatne komendy do cofania

**Cofnij zmiany w pliku (jeszcze nie staged):**
```bash
git restore app.py
# lub starsza wersja:
git checkout -- app.py
```

**Usuń plik ze staging (ale zostaw zmiany w pliku):**
```bash
git restore --staged app.py
# lub starsza wersja:
git reset HEAD app.py
```

**Popraw ostatni commit (wiadomość lub pliki):**
```bash
# Zapomniałeś dodać plik do commita
git add zapomniany_plik.py
git commit --amend --no-edit

# Popraw wiadomość ostatniego commita
git commit --amend -m "Fix commit message"
```

> [!WARNING]
> **PUŁAPKA:** `--amend` zmienia historię (nadpisuje hash ostatniego commita). Używaj **tylko** dla commitów, których jeszcze nie spushowałeś. Jeśli już spushowane — potrzebny byłby force push, który psuje historię innym.

---

### 🧠 Quiz — Część 3: Cofanie i naprawianie

**Pytanie 1.** Spushowałeś commit, który zawiera błąd. Inni już go pobrali. Czego użyć, żeby go cofnąć?

- A) `git reset --hard HEAD~1` i `git push --force`
- B) `git revert <hash>` i `git push`
- C) `git restore .`
- D) `git stash`

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `git revert` tworzy **nowy commit** cofający zmiany, zachowując historię. To bezpieczne, bo nie nadpisuje commitów, które inni już pobrali. Odpowiedź A (`reset --hard` + `push --force`) zniszczyłaby historię u współpracowników.

</details>

---

**Pytanie 2.** Zrobiłeś commit lokalnie, ale chcesz go cofnąć i zachować wszystkie zmiany w staging (gotowe do ponownego commita z lepszą wiadomością). Co użyć?

- A) `git reset --hard HEAD~1`
- B) `git reset --soft HEAD~1`
- C) `git reset HEAD~1` (czyli `--mixed`)
- D) `git revert HEAD`

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `--soft` cofa tylko commit, zostawiając pliki w staging area. `--mixed` (C) cofnąłby też ze staging do working dir. `--hard` (A) wyrzuciłby wszystko bezpowrotnie.

</details>

---

**Pytanie 3.** Pracujesz nad funkcją (zmiany niezacommitowane). Szef prosi o pilny bugfix na innym branchu. Najlepsza opcja?

- A) `git commit -m "WIP"` i potem przełączyć branch
- B) `git stash`, przełączyć branch, naprawić, wrócić, `git stash pop`
- C) Skopiować pliki ręcznie do innego folderu
- D) `git reset --hard` żeby wyczyścić working directory

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `git stash` to dokładnie do tego stworzone: chowa zmiany tymczasowo bez zaśmiecania historii. Opcja A psuje historię commitami "WIP", D wyrzuca pracę bezpowrotnie.

</details>

---

**Pytanie 4.** Co dokładnie robi `git restore plik.py` (bez `--staged`)?

- A) Przywraca plik z ostatniego commita, kasując niestagowane zmiany w working directory
- B) Usuwa plik ze staging area (ale zachowuje zmiany)
- C) Cofa ostatni commit dotyczący pliku
- D) Tworzy backup pliku

<details><summary>💡 Pokaż odpowiedź</summary>

**A** — `git restore plik.py` wyrzuca niestagowane zmiany i przywraca wersję z HEAD. Żeby usunąć ze staging (zachowując zmiany w pliku), użyj `git restore --staged plik.py`.

</details>

---

## 6. Branching (gałęzie) - praca równoległa

### Czym jest branch - analogia

Wyobraź sobie książkę typu "wybierz swoją przygodę":

```
                     ┌─→ [feature/login]
                     │   "Dodajesz logowanie"
Strona 1 → Strona 2 ─┤
  (main)    (main)   │
                     └─→ [feature/payments]
                         "Dodajesz płatności"
```

**Branch = oddzielna linia rozwoju projektu**

- Możesz eksperymentować bez psucia głównego kodu
- Możesz pracować nad wieloma funkcjami równocześnie
- Możesz bezpiecznie testować

---

**🎯 ĆWICZENIE 6: Pierwsza gałąź**

Zrób to teraz! (4 minuty)

1. Sprawdź gałęzie: `git branch` (tylko main)
2. Utwórz nową: `git switch -c eksperyment`
3. Utwórz plik `eksperyment.txt` z tekstem "Testuję branch"
4. Commitnij: `git add eksperyment.txt` → `git commit -m "Add experiment"`
5. Wróć na main: `git switch main`
6. Sprawdź: `ls` (nie ma `eksperyment.txt`!)
7. Wróć na eksperyment: `git switch eksperyment`
8. Sprawdź: `ls` (plik wrócił!)

✅ **Rozumiesz branching!** Każda gałąź ma swoją wersję plików.

---

### Dlaczego używamy branchy?

**Scenariusz bez branchy:**
```
main: Feature A (działa) → próbujesz dodać Feature B → coś się psuje → 
      → cała aplikacja nie działa → nie możesz wydać Feature A 😢
```

**Scenariusz z branchami:**
```
main: Feature A (działa) → BEZPIECZNY ✅
      ↓
feature/b: eksperymentujesz z Feature B → jeśli się psuje, main nadal działa! 🎉
```

### Podstawowe komendy branch

**Lista gałęzi:**
```bash
git branch
```
Output:
```
* main
  feature/login
  bugfix/email-validation
```
(* oznacza aktualną gałąź)

**Tworzenie nowej gałęzi:**
```bash
git branch feature/nowa-funkcja
```

**Przełączanie między gałęziami:**
```bash
# Starsza metoda (nadal działa)
git checkout feature/nowa-funkcja

# Nowsza metoda (zalecana) ✅
git switch feature/nowa-funkcja
```

**Tworzenie i przełączanie (skrót):**
```bash
# Starsza metoda
git checkout -b feature/nowa-funkcja

# Nowsza metoda (zalecana) ✅
git switch -c feature/nowa-funkcja
```

💡 **Różnica `checkout` vs `switch`:**
- `checkout` - stara, wielofunkcyjna komenda (gałęzie, pliki, commity)
- `switch` - nowa, dedykowana tylko przełączaniu gałęzi
- **Zalecane:** używaj `switch` dla gałęzi, jest bardziej intuicyjna

### Wizualizacja pracy z branchami

```bash
# 1. Jesteś na main
git branch
# * main

# 2. Tworzysz nową gałąź
git switch -c feature/login

# 3. Pracujesz i committujesz
echo "def login(): pass" > login.py
git add login.py
git commit -m "Add login skeleton"

# 4. Stan gałęzi:
#
#         ┌─→ feature/login: [dodano login.py]
#         │                        ↑
#  main ──┘                      HEAD
#
```

```bash
# 5. Wracasz do main
git switch main

# 6. Tworzysz kolejną gałąź
git switch -c feature/payments
echo "def payment(): pass" > payment.py
git add payment.py
git commit -m "Add payment skeleton"

# 7. Stan gałęzi:
#
#         ┌─→ feature/login: [login.py]
#         │
#  main ──┤
#         │
#         └─→ feature/payments: [payment.py]
#                                     ↑
#                                   HEAD
```

**Inna wizualizacja:**

```mermaid
gitGraph
    commit id: "init"
    commit id: "README"
    branch feature/login
    checkout feature/login
    commit id: "login.py"
    checkout main
    branch feature/payments
    checkout feature/payments
    commit id: "payment.py"
```

Każda gałąź ma własną linię commitów — `main` zostaje czysty, a praca nad funkcjami toczy się równolegle.

### Scalanie gałęzi - `git merge`

**Co robi:** Łączy zmiany z jednej gałęzi do drugiej

**Przykład:**
```bash
# Skończyłeś pracę nad feature/login, chcesz dodać do main

# 1. Przełącz się na main
git switch main

# 2. Scal feature/login do main
git merge feature/login
```

**Rezultat:**
```
Przed merge:
         ┌─→ feature/login: [A, B, C]
         │
  main ──┘

Po merge:
         ┌─→ feature/login: [A, B, C]
         │                        ↓
  main ──┴────────────────────→ [A, B, C]
                                    ↑
                                  HEAD
```

**Po udanym merge możesz usunąć gałąź:**
```bash
git branch -d feature/login
```

**Inna wizualizacja:**

```mermaid
gitGraph
    commit id: "A"
    commit id: "B"
    branch feature/login
    checkout feature/login
    commit id: "C"
    commit id: "D"
    checkout main
    commit id: "E"
    merge feature/login id: "M"
```

Zwróć uwagę: historia zostaje **rozgałęziona** — widać że `feature/login` istniał jako osobna linia, a commit `M` to "merge commit" łączący obie gałęzie.

---

**🎯 ĆWICZENIE 7: Scalanie gałęzi**

Zrób to teraz! (3 minuty)

1. Jesteś na `eksperyment`, dodaj linię do `eksperyment.txt`: "Druga wersja"
2. Commitnij: `git commit -am "Update experiment to second version"`
3. Przełącz na main: `git switch main`
4. Scal eksperyment: `git merge eksperyment`
5. Sprawdź: `ls` (plik `eksperyment.txt` jest teraz na main!)
6. Usuń branch: `git branch -d eksperyment`
7. Lista: `git branch` (tylko main pozostał)

✅ **Zrobiłeś merge!** Zmiany z brancha są teraz na main.

---

### Rebase - przepisywanie historii

**Co robi:** Przenosi commity z jednej gałęzi na drugą, przepisując historię

```bash
# Jesteś na feature/login
git rebase main
```

**Wizualizacja:**
```
Przed rebase:
              ┌─→ feature: [A, B]
              │              ↑
  main ── [X, Y, Z]        HEAD

Po rebase:
                           ┌─→ feature: [A', B']
                           │               ↑
  main ── [X, Y, Z] ───────┘             HEAD
```

Commity A i B zostały "przeniesione" na koniec main (A', B' = nowe ID commitów)

**Inna wizualizacja:**

```mermaid
gitGraph
    commit id: "X"
    commit id: "Y"
    commit id: "Z"
    commit id: "A'"
    commit id: "B'"
```

Porównaj z poprzednim diagramem merge — tu **nie ma rozgałęzienia**, wszystko wygląda jakby było pisane na jednej gałęzi po kolei. To właśnie "liniowa historia", którą daje rebase.

### Różnica `merge` vs `rebase`

| Aspekt | `git merge` | `git rebase` |
|--------|-------------|--------------|
| **Historia** | Zachowuje wszystkie commity, tworzy merge commit | Przepisuje historię liniowo |
| **Wizualizacja** | Historia rozgałęziona (merge commit widoczny) | Historia liniowa (wygląda jakby wszystko było na jednej gałęzi) |
| **Bezpieczeństwo** | ✅ Bezpieczne, nie zmienia commitów | ⚠️ Zmienia ID commitów, może być problematyczne |
| **Konflikt** | Rozwiązujesz raz | Możesz rozwiązywać wielokrotnie (dla każdego commita) |
| **Kiedy używać** | Scalanie feature branch do main | Aktualizacja swojej gałęzi przed merge (czyszczenie historii) |
| **Dla początkujących** | ✅ Zalecane | ⚠️ Ostrożnie - zrozum najpierw merge |

**Praktyczne zastosowanie:**

```bash
# MERGE - gdy chcesz scalić feature do main
git switch main
git merge feature/login
# Historia: widać że login był osobną gałęzią

# REBASE - gdy chcesz zaktualizować swój feature branch
git switch feature/login
git rebase main
# Twoje zmiany są teraz "na szczycie" najnowszego main
```

> [!CAUTION]
> **ZAPAMIĘTAJ:** NIE używaj `rebase` dla commitów, które już spushowałeś i inni z nich korzystają! Rebase zmienia hashe — Twoi koledzy dostaną sprzeczną historię i dramatyczne konflikty.

#### 🌳 Drzewo decyzyjne — `merge` czy `rebase`?

```mermaid
flowchart TD
    Start([Mam zmiany na branchu<br/>do zintegrowania]) --> Q1{Czy mój branch<br/>był już spushowany<br/>i inni z niego korzystają?}
    Q1 -->|Tak| Merge1[git merge<br/>rebase nadpisałby commity innych]
    Q1 -->|Nie, tylko lokalnie| Q2{Co chcę osiągnąć?}
    Q2 -->|Połączyć feature do main<br/>zachowując historię gałęzi| MergeFinal[git merge feature]
    Q2 -->|Zaktualizować feature najnowszym main<br/>zachowując liniową historię| Rebase[git rebase main]
    Q2 -->|Sprzątnąć lokalne commity przed PR<br/>squash, reorder| RebaseI[git rebase -i]
    Merge1 --> Done([✅ Zintegrowane])
    MergeFinal --> Done
    Rebase --> Done
    RebaseI --> Done

    style Merge1 fill:#90EE90
    style MergeFinal fill:#90EE90
    style Rebase fill:#FFE4B5
    style RebaseI fill:#FFE4B5
    style Done fill:#87CEEB
```

**Reguła pierwsza:** rebase = lokalna higiena, merge = publiczna integracja.

### Git Flow - metodologia pracy

**Git Flow to popularna strategia organizacji gałęzi:**

```
main/master     [PRODUKCJA - tylko stabilne wersje]
                         ↑
develop         [ROZWÓJ - integracja funkcji]
                ↙   ↓   ↘
feature/login   feature/payment   feature/admin
[funkcja A]     [funkcja B]       [funkcja C]
```

**Inna wizualizacja:**

```mermaid
gitGraph
    commit id: "v1.0" tag: "v1.0"
    branch develop
    checkout develop
    commit id: "setup"
    branch feature/login
    checkout feature/login
    commit id: "login form"
    commit id: "login tests"
    checkout develop
    merge feature/login
    branch feature/payment
    checkout feature/payment
    commit id: "payment API"
    checkout develop
    merge feature/payment
    branch release/v1.1
    checkout release/v1.1
    commit id: "bump version"
    checkout main
    merge release/v1.1 tag: "v1.1"
    checkout develop
    merge release/v1.1
    checkout main
    branch hotfix/security
    commit id: "fix CVE"
    checkout main
    merge hotfix/security tag: "v1.1.1"
    checkout develop
    merge hotfix/security
```

Widać tu jak: feature'y wpadają do `develop` → `release/*` przygotowuje wydanie → idzie do `main` z tagiem wersji → `hotfix/*` wyjątkowo idzie od razu do `main` (pilna poprawka produkcji) i z powrotem do `develop`.

**Rodzaje gałęzi:**

1. **`main`/`master`** - produkcja, tylko stabilny kod
2. **`develop`** - główna gałąź rozwojowa
3. **`feature/*`** - nowe funkcjonalności (np. `feature/login`)
4. **`bugfix/*`** - poprawki błędów (np. `bugfix/email-crash`)
5. **`hotfix/*`** - pilne poprawki produkcji (np. `hotfix/security`)
6. **`release/*`** - przygotowanie do wydania (np. `release/v1.0`)

**Przykładowy workflow:**

```bash
# 1. Tworzysz nową funkcję
git switch develop
git switch -c feature/login

# 2. Pracujesz i committujesz
git add .
git commit -m "Add login"

# 3. Scalasz do develop
git switch develop
git merge feature/login

# 4. Usuwasz feature branch
git branch -d feature/login
```

💡 **Konwencja nazewnictwa:**
- `feature/nazwa-funkcji` - nowe funkcje
- `bugfix/nazwa-bledu` - poprawki błędów
- `hotfix/nazwa-pilnej-poprawki` - pilne poprawki

---

### 🧠 Quiz — Część 4: Branching

**Pytanie 1.** Jesteś na branchu `main` i wykonujesz `git switch -c feature/login`. Co się dzieje?

- A) Tworzy nowy branch `feature/login` ale zostajesz na `main`
- B) Tworzy nowy branch `feature/login` i przełącza Cię na niego
- C) Usuwa branch `main` i tworzy `feature/login`
- D) Tworzy plik o nazwie `feature/login` w repo

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — flaga `-c` (create) tworzy nowy branch **i** od razu na niego przełącza. To skrót dla `git branch feature/login` + `git switch feature/login`. Starsza forma to `git checkout -b feature/login`.

</details>

---

**Pytanie 2.** Kluczowa różnica między `git merge` a `git rebase`:

- A) `merge` jest szybszy, `rebase` wolniejszy
- B) `merge` tworzy commit łączący (zachowuje historię gałęzi), `rebase` przepisuje commity tworząc liniową historię
- C) `merge` działa tylko lokalnie, `rebase` wymaga internetu
- D) To są synonimy

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `merge` zachowuje historię rozgałęzioną (widać że feature istniał). `rebase` "przesadza" commity na koniec docelowego brancha, dając liniową historię, ale **zmienia ID commitów** — dlatego nie rób rebase na spushowanych commitach.

</details>

---

**Pytanie 3.** Podczas merge widzisz w pliku `<<<<<<< HEAD ... ======= ... >>>>>>> feature/login`. Co robisz?

- A) Usuwasz cały plik i tworzysz nowy
- B) `git merge --abort` żeby anulować i nigdy nie robisz merge
- C) Edytujesz plik wybierając/łącząc obie wersje, usuwasz markery, `git add` i `git commit`
- D) Ignorujesz konflikty, Git rozwiąże je automatycznie po chwili

<details><summary>💡 Pokaż odpowiedź</summary>

**C** — markery konfliktu trzeba **ręcznie** rozstrzygnąć: zostawić jedną wersję, połączyć obie lub napisać coś nowego. Po edycji: `git add plik` + `git commit` finalizuje merge. Opcja B to ostateczność, nie standard.

</details>

---

**Pytanie 4.** W Git Flow, do czego służy branch `develop`?

- A) To synonim brancha `main`
- B) Główna gałąź integracji nowych funkcji przed wydaniem na produkcję (`main`)
- C) Branch dla pojedynczego dewelopera
- D) Branch tylko do dokumentacji

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — w Git Flow `main` zawiera tylko stabilne wersje produkcyjne (z tagami `v1.0`, `v1.1`...), a `develop` to "kuchnia" gdzie scalają się wszystkie `feature/*`. Z `develop` powstaje `release/*`, który po przetestowaniu trafia do `main`.

</details>

---

## 7. Pliki specjalne - konfiguracja repozytorium

### `.gitignore` - ignorowanie plików

**Co to jest:**
Plik tekstowy zawierający listę plików i folderów, które Git ma ignorować.

**Po co:**
Nie chcemy commitować:
- 🗑️ Plików tymczasowych (np. `*.pyc`, `__pycache__/`)
- 📝 Logów (np. `*.log`, `logs/`)
- 🔒 Haseł i kluczy (np. `.env`, `secrets.json`)
- 📦 Zależności (np. `node_modules/`, `venv/`)
- 💻 Plików specyficznych dla IDE (np. `.vscode/`, `.idea/`)
- 📊 Dużych plików (np. `*.mp4`, `data/`)

**Jak stworzyć:**

1. Utwórz plik `.gitignore` w głównym folderze projektu
2. Dodaj wzorce plików do ignorowania

**Przykład `.gitignore` dla Python:**
```gitignore
# Pliki skompilowane Python
*.pyc
*.pyo
__pycache__/
*.so

# Środowisko wirtualne
venv/
env/
ENV/

# Pliki IDE
.vscode/
.idea/
*.swp
*.swo

# Pliki środowiskowe (WAŻNE!)
.env
secrets.json
config.local.py

# Logi
*.log
logs/

# Bazy danych
*.db
*.sqlite3

# Testy
.coverage
.pytest_cache/

# macOS
.DS_Store

# Windows
Thumbs.db
```

**Wzorce w `.gitignore`:**

| Wzorzec | Co ignoruje | Przykład |
|---------|-------------|----------|
| `*.log` | Wszystkie pliki `.log` | `app.log`, `error.log` |
| `temp/` | Folder `temp` i jego zawartość | `temp/file.txt` |
| `/TODO` | Plik `TODO` tylko w głównym folderze | `/TODO` (ale nie `/docs/TODO`) |
| `**/logs` | Folder `logs` wszędzie | `logs/`, `app/logs/` |
| `*.py[cod]` | Pliki `.pyc`, `.pyo`, `.pyd` | `app.pyc` |
| `!important.log` | Wyjątek - NIE ignoruj | Śledź mimo `*.log` |

**Praktyczny przykład:**

```bash
# 1. Utwórz .gitignore
echo "__pycache__/" > .gitignore
echo "*.pyc" >> .gitignore
echo ".env" >> .gitignore

# 2. Sprawdź co Git widzi
git status
# .gitignore pojawi się jako nowy plik
# Pliki .pyc nie będą widoczne

# 3. Dodaj .gitignore do repozytorium
git add .gitignore
git commit -m "Add .gitignore"
```

> [!WARNING]
> **PUŁAPKA:** `.gitignore` działa tylko dla **untracked** plików. Jeśli plik został już zacommitowany, dodanie go do `.gitignore` nic nie da — trzeba najpierw `git rm --cached plik`, potem `.gitignore`, potem commit.

---

**🎯 ĆWICZENIE 8: .gitignore**

Zrób to teraz! (3 minuty)

1. Utwórz plik `sekret.txt` z tekstem "Hasło: 123456"
2. Sprawdź: `git status` (plik widoczny)
3. Utwórz `.gitignore` z linią: `sekret.txt`
4. Sprawdź: `git status` (sekret.txt zniknął!)
5. Commitnij .gitignore: `git add .gitignore` → `git commit -m "Add .gitignore"`
6. Zmień sekret.txt - Git go nie widzi!

✅ **Chronisz wrażliwe dane!** `.gitignore` działa.

---

**Jeśli już commitnąłeś plik, który chcesz ignorować:**
```bash
# Usuń z Git, ale zostaw lokalnie
git rm --cached plik_do_usuniecia.log

# Dodaj do .gitignore
echo "*.log" >> .gitignore

# Commitnij
git add .gitignore
git commit -m "Remove .log files from repository"
```

### `.gitkeep` - zachowanie pustych folderów

#### Problem: Git nie śledzi pustych folderów!

**Scenariusz z życia:**

Tworzysz aplikację, która zapisuje logi do folderu `logs/`. W kodzie masz:

```python
# W aplikacji
with open('logs/app.log', 'w') as f:
    f.write('Log wiadomość')
```

**Co się stanie:**
1. Ty tworzysz folder `logs/` lokalnie - aplikacja działa ✅
2. Committujesz kod (ale pusty folder `logs/` NIE jest w Git)
3. Kolega klonuje repozytorium
4. U kolegi nie ma folderu `logs/`
5. Aplikacja próbuje zapisać do `logs/app.log`
6. **BŁĄD!** 💥 `FileNotFoundError: No such file or directory: 'logs/app.log'`

**Dlaczego Git nie śledzi pustych folderów?**

Git śledzi **pliki**, nie foldery. Folder istnieje tylko dlatego, że są w nim pliki. Pusty folder = brak plików = Git go ignoruje.

```bash
mkdir uploads/
git add uploads/
git status
# Nic się nie dzieje - Git nie widzi pustego folderu!
```

#### Po co nam puste foldery w repozytorium?

**Realne sytuacje gdy struktura folderów jest ważna:**

1. **Aplikacja zapisuje pliki do konkretnych folderów:**
   - `logs/` - aplikacja tworzy logi
   - `uploads/` - użytkownicy wgrywają pliki
   - `cache/` - aplikacja cache'uje dane
   - `temp/` - pliki tymczasowe

2. **Framework wymaga struktury:**
   - Django: `media/`, `static/`
   - Flask: `instance/`, `uploads/`

3. **Organizacja projektu:**
   - `docs/images/` - obrazy do dokumentacji
   - `tests/fixtures/` - dane testowe

**Bez `.gitkeep`:**
- Każdy deweloper musi ręcznie tworzyć te foldery ❌
- Aplikacja crashuje przy pierwszym uruchomieniu ❌
- Trzeba dokumentować "utwórz foldery X, Y, Z" ❌

**Z `.gitkeep`:**
- Struktura folderów jest w repozytorium ✅
- Sklonował repo → uruchomił → działa ✅
- Nie trzeba nic tworzyć ręcznie ✅

#### Rozwiązanie: `.gitkeep`

`.gitkeep` to **konwencja** (nie funkcja Git). To pusty plik, który "trzyma" folder w repozytorium.

**Jak to działa:**
- Git śledzi plik `.gitkeep`
- Plik jest w folderze `logs/`
- Więc folder `logs/` musi istnieć
- Folder zostaje w repozytorium! 🎉

```bash
# 1. Utwórz folder
mkdir uploads/

# 2. Dodaj .gitkeep
touch uploads/.gitkeep

# 3. Dodaj do repozytorium
git add uploads/.gitkeep
git commit -m "Add folder structure"
```

**Kiedy używać:**

✅ Gdy struktura folderów jest ważna:
- `logs/` - aplikacja zapisuje tu logi
- `uploads/` - użytkownicy wgrywają pliki
- `cache/` - cache aplikacji
- `data/` - dane tymczasowe

**Przykład z `.gitignore` i `.gitkeep` razem:**

```bash
# Chcesz śledzić folder logs/, ale nie pliki .log w nim

# 1. Utwórz folder z .gitkeep
mkdir logs/
touch logs/.gitkeep

# 2. Ignoruj pliki .log
echo "logs/*.log" >> .gitignore

# 3. Commit
git add logs/.gitkeep .gitignore
git commit -m "Add logs folder structure"
```

**Rezultat:**
- Folder `logs/` będzie w repozytorium (dzięki `.gitkeep`)
- Pliki `logs/*.log` będą ignorowane (dzięki `.gitignore`)

💡 **Alternatywa:** Możesz użyć `.gitkeep` lub `README.md` w folderze - efekt ten sam!

---

**🎯 ĆWICZENIE 9: .gitkeep**

Zrób to teraz! (2 minuty)

1. Utwórz folder: `mkdir uploads`
2. Spróbuj dodać: `git add uploads/` → `git status` (nic się nie stało)
3. Utwórz .gitkeep: `touch uploads/.gitkeep`
4. Dodaj: `git add uploads/.gitkeep`
5. Commitnij: `git commit -m "Add uploads folder"`
6. Sprawdź: `git log --oneline` (folder jest w repozytorium!)

✅ **Zachowujesz strukturę folderów!** Git teraz śledzi pusty folder.

---

## 8. Dobre praktyki - jak pracować profesjonalnie

### Komunikaty commitów

**Format profesjonalnego commita:**

```
Króte podsumowanie (max 50 znaków)

Opcjonalny szczegółowy opis co, dlaczego i jak.
Może być wieloliniowy.

- Można używać list
- Dla lepszej czytelności

Fixes #123
```

**Dobre komunikaty commitów:**

✅ **DOBRE (angielski + tryb rozkazujący — standard Git):**
- `fix: Correct login error with empty password`
- `feat: Add email validation to registration form`
- `refactor: Remove unused imports from app.py`
- `chore: Update Django to version 4.2`
- `perf: Improve SQL query performance in get_users`

❌ **ZŁE:**
- `fix` - co naprawiłeś?
- `changes` - jakie zmiany?
- `asdf` - ...
- `commit` - to wiadomo
- `updates` - konkretnie?
- `wip` (work in progress) - nie commituj niedokończonej pracy
- `Fixed stuff` - co konkretnie? (do tego zły czas — patrz reguła 2)
- `Added login` / `Adds login` - zły czas (powinno być `Add login`)
- `Dodano logowanie` - polski + czas przeszły, łamie konwencję

**Zasady:**

1. **Język angielski (standard w branży):**
   - ✅ "Add user authentication"
   - ✅ "Fix login bug"
   - ✅ "Update dependencies"
   - ❌ "Dodano autoryzację" — polskie commity łamią konwencję i nie współpracują z narzędziami

2. **Tryb rozkazujący (imperative mood) — kluczowa reguła!**

   Commit message ma dokończyć zdanie: *"If applied, this commit will _____"*

   - ✅ "**Add** login" → *"...will add login"* ✓
   - ❌ "**Added** login" (czas przeszły)
   - ❌ "**Adds** login" (czas teraźniejszy)
   - ❌ "**Adding** login" (gerund)

   Używaj: `Add`, `Fix`, `Update`, `Remove`, `Refactor`, `Improve` — czasowniki bazowe bez końcówek.

3. **Konkretny opis:** Co dokładnie zmienia ten commit

4. **Bez kropki na końcu** w pierwszej linii

5. **Max 50 znaków** w pierwszej linii

6. **Pusta linia** między tytułem a opisem (jeśli jest opis)

💡 **Dlaczego angielski + imperatyw?**
- 🌍 Międzynarodowe projekty - wszyscy rozumieją
- 📚 Standardowa konwencja Git (od oficjalnej dokumentacji)
- 🔧 Narzędzia (changelog generators, GitHub) parsują angielski + imperatyw
- 🤖 Sam Git generuje merge commits w tym formacie (np. `Merge branch 'feature/x'`)
- 💼 Profesjonalizm - przygotowanie do pracy w zespołach

**Wzór angielski - Conventional Commits (standard branżowy):**

```
feat: Add user login functionality
fix: Correct email validation bug
docs: Update README with installation steps
style: Format code with Black
refactor: Simplify database query
test: Add tests for login feature
chore: Update dependencies
perf: Improve query performance
```

**Prefiks + dwukropek + opis:**
- `feat:` - nowa funkcjonalność
- `fix:` - naprawa błędu
- `docs:` - dokumentacja
- `style:` - formatowanie (nie zmienia logiki)
- `refactor:` - refaktoryzacja kodu
- `test:` - dodanie/zmiana testów
- `chore:` - zadania pomocnicze (update dependencies)
- `perf:` - poprawa wydajności

### Częstotliwość commitów

**Jak często commitować?**

✅ **DOBRE praktyki:**
- Commit po każdej logicznej zmianie (jedna funkcjonalność)
- Commit działa i nie psuje aplikacji
- Kilka małych commitów > jeden ogromny commit

❌ **ZŁE praktyki:**
- Commitowanie co 5 minut (za często)
- Commit na koniec dnia z 20 zmianami (za rzadko)
- Commit który psuje aplikację

**Przykład podziału pracy:**

```bash
# ❌ ZŁY sposób - jeden ogromny commit
git add .
git commit -m "Add entire login system"
# (100 plików, 5000 linii, wszystko naraz)

# ✅ DOBRY sposób - małe, logiczne commity (angielski)
git add auth/models.py
git commit -m "feat: Add User model"

git add auth/forms.py
git commit -m "feat: Add login form"

git add auth/views.py
git commit -m "feat: Add login view"

git add auth/tests.py
git commit -m "test: Add login tests"
```

💡 **Zasada:** Commit powinien być "atomowy" - jedna logiczna zmiana, która ma sens sama w sobie.

---

**🎯 ĆWICZENIE 10: Dobre komunikaty commitów**

Zrób to teraz! (3 minuty)

Przejrzyj swoją historię i popraw ostatni commit:

1. Zobacz historię: `git log --oneline`
2. Zmień `test.txt` - dodaj "Linia profesjonalna"
3. ❌ ZŁY commit: `git commit -am "fix"`
4. Popraw go: `git commit --amend -m "Add professional description line"`
5. Zobacz: `git log --oneline` (komunikat zmieniony!)

**Ćwicz pisanie dobrych komunikatów:**
- ✅ "Fix bug XYZ in function ABC"
- ❌ "fixup"

✅ **Piszesz profesjonalne commity!** To ważna umiejętność.

---

### Workflow - profesjonalny sposób pracy

**Dzienny workflow:**

```bash
# === POCZĄTEK DNIA ===

# 1. Pobierz najnowsze zmiany
git switch main
git pull

# 2. Utwórz branch dla swojej pracy
git switch -c feature/moja-funkcja

# === PODCZAS PRACY ===

# 3. Pracuj nad kodem, commituj często
git add .
git status  # zawsze sprawdzaj!
git commit -m "Describe your changes"

# 4. Regularnie synchronizuj z main
git switch main
git pull
git switch feature/moja-funkcja
git rebase main  # lub: git merge main

# === KONIEC PRACY ===

# 5. Testuj swój kod!
# Uruchom testy, sprawdź czy działa

# 6. Push swojego brancha
git push -u origin feature/moja-funkcja

# 7. Utwórz Pull Request / Merge Request
# (na GitHubie/GitLabie)
```

**Workflow dla zespołu:**

```
Developer A                    Developer B
     │                              │
     ├─ git pull                    ├─ git pull
     ├─ git switch -c feat/A        ├─ git switch -c feat/B
     ├─ (praca)                     ├─ (praca)
     ├─ git commit                  ├─ git commit
     ├─ git push                    ├─ git push
     ├─ PR/MR                       ├─ PR/MR
     │                              │
     └────────→ Code Review ←───────┘
                    │
               git merge feat/A
               git merge feat/B
                    │
                  main
```

### Bezpieczeństwo

> [!CAUTION]
> **NIGDY nie commituj wrażliwych danych** (hasła, klucze API, tokeny, dane osobowe). Raz zapushowane = w historii na zawsze (i potencjalnie wyciekło, nawet jeśli usuniesz później).

**Czego NIE commituj:**

```python
# ❌ ZŁE - hasła w kodzie
password = "moje_tajne_haslo123"
api_key = "sk-abc123xyz"
database_url = "postgresql://user:pass@localhost/db"
```

✅ **DOBRE - używaj zmiennych środowiskowych:**

```python
import os

password = os.environ.get('PASSWORD')
api_key = os.environ.get('API_KEY')
database_url = os.environ.get('DATABASE_URL')
```

**Plik `.env` (MUSI być w `.gitignore`):**
```env
PASSWORD=moje_tajne_haslo123
API_KEY=sk-abc123xyz
DATABASE_URL=postgresql://user:pass@localhost/db
```

**Plik `.env.example` (commitowany):**
```env
PASSWORD=twoje_haslo_tutaj
API_KEY=twoj_klucz_api_tutaj
DATABASE_URL=postgresql://user:pass@localhost/db
```

**Lista rzeczy do ignorowania (bezpieczeństwo):**
- 🔒 Hasła i klucze API
- 🔑 Tokeny dostępu
- 📧 Dane osobowe
- 💳 Informacje o kartach kredytowych
- 🗝️ Certyfikaty SSL
- 🔐 Pliki `.env`, `.env.local`

**Checklist przed commitem:**
```bash
# 1. Sprawdź co commitujesz
git diff

# 2. Sprawdź status
git status

# 3. Sprawdź czy nie ma wrażliwych danych
git diff | grep -i "password\|api_key\|secret\|token"

# 4. Commituj
git commit -m "Describe your changes"
```

### Współpraca

**Zasady pracy w zespole:**

1. **Komunikacja** 💬
   - Informuj zespół o dużych zmianach
   - Używaj opisowych nazw branchy
   - Piszę jasne komunikaty commitów
   
2. **Synchronizacja** 🔄
   - `git pull` przed rozpoczęciem pracy
   - Regularnie aktualizuj swój branch (rebase lub merge)
   - Nie zostawiaj branchy "wiszące" przez tygodnie

3. **Code Review** 👀
   - Twórz Pull Requesty/Merge Requesty
   - Proś o review przed merge do main
   - Bądź otwarty na feedback

4. **Rozwiązywanie konfliktów** ⚔️
   - Rozwiązuj konflikty od razu
   - Komunikuj się z osobą, której zmiany konfliktują
   - Testuj po rozwiązaniu konfliktu

**Przykład dobrej komunikacji:**

```bash
# ❌ Zła nazwa brancha:
git switch -c test

# ✅ Dobra nazwa brancha (angielski):
git switch -c feature/add-user-authentication

# ❌ Zły commit:
git commit -m "fix"

# ✅ Dobry commit (angielski):
git commit -m "fix: Prevent XSS vulnerability in login form"
```

---

### 🧠 Quiz — Część 5: Konfiguracja i praktyki

**Pytanie 1.** Który komunikat commita jest najlepszy zgodnie z konwencją Git?

- A) `Added user authentication`
- B) `add user authentication`
- C) `feat: Add user authentication`
- D) `Dodano autoryzację użytkownika`

<details><summary>💡 Pokaż odpowiedź</summary>

**C** — `feat: Add user authentication` spełnia: angielski (1), tryb rozkazujący (2), prefiks typu z Conventional Commits (3), konkretny opis (4). A) ma zły czas (`Added`), D) polski + czas przeszły łamią konwencję.

</details>

---

**Pytanie 2.** Po co istnieje plik `.gitignore`?

- A) Żeby ukryć pliki przed innymi programistami w zespole
- B) Żeby Git ignorował określone pliki/foldery i nie traktował ich jako część projektu (np. `.env`, `__pycache__/`, `node_modules/`)
- C) Żeby zaszyfrować wrażliwe dane
- D) Żeby przyspieszyć Git

<details><summary>💡 Pokaż odpowiedź</summary>

**B** — `.gitignore` mówi Gitowi "ignoruj te wzorce". Kluczowe do **bezpieczeństwa** (`.env` z hasłami), porządku (`*.log`, `__pycache__/`) i wydajności (`node_modules/`). A) Wręcz przeciwnie — `.gitignore` sam jest commitowany i widoczny dla wszystkich.

</details>

---

**Pytanie 3.** Pomyłkowo zacommitowałeś plik `.env` z hasłem i zrobiłeś `git push`. Co teraz?

- A) Wystarczy usunąć plik komendą `git rm .env` i commitnąć
- B) Dodać `.env` do `.gitignore` i jest po sprawie
- C) Trzeba przepisać historię (`git filter-branch` / BFG) i **NATYCHMIAST zmienić hasło** — bo ktoś mógł je już pobrać
- D) Wystarczy zmienić nazwę pliku na `.env.local`

<details><summary>💡 Pokaż odpowiedź</summary>

**C** — usunięcie pliku w nowym commicie **nie usuwa go z historii**. Hasło zostaje dostępne w starych commitach. Trzeba użyć `git filter-branch` lub BFG Repo-Cleaner, force push, **i przede wszystkim natychmiast zmienić hasło** — zakładaj że już wyciekło.

</details>

---

**Pytanie 4.** Po co używamy `.gitkeep`?

- A) Żeby Git śledził pusty folder (sam Git nie śledzi pustych folderów, śledzi tylko pliki)
- B) Żeby zablokować innym dostęp do folderu
- C) Żeby Git robił backup folderu
- D) To plik konfiguracyjny Git

<details><summary>💡 Pokaż odpowiedź</summary>

**A** — Git śledzi tylko pliki, więc pusty folder znika w klonie. `.gitkeep` to **konwencja** (nie funkcja Git!) — pusty plik w folderze, dzięki któremu folder zostaje w repo. Przydatne dla `logs/`, `uploads/`, `cache/` których aplikacja oczekuje przy starcie.

</details>

---

## 9. Najczęstsze problemy początkujących

### Problem 1: "Zrobiłem commit, ale nie widzę zmian na GitHubie"

**Objaw:**
```bash
git commit -m "Add my changes"
# Sprawdzasz GitHub - nic tam nie ma
```

**Przyczyna:** Zapomniałeś `git push`!

**Rozwiązanie:**
```bash
git push
```

> [!NOTE]
> **ZAPAMIĘTAJ:** `commit` = zapisane **lokalnie**, `push` = wysłane do GitHub/GitLab. Dwie osobne operacje, dwa osobne kroki.

---

### Problem 2: "Nie mogę zrobić pull"

**Objaw:**
```bash
git pull
# error: Your local changes would be overwritten by merge
```

**Przyczyna:** Masz niezcommitowane zmiany lokalnie.

**Rozwiązanie 1 - commitnij:**
```bash
git add .
git commit -m "Save work in progress"
git pull
```

**Rozwiązanie 2 - schowaj tymczasowo (stash):**
```bash
git stash  # Schowaj zmiany
git pull   # Pobierz
git stash pop  # Przywróć zmiany
```

---

### Problem 3: "Przypadkowo commitnąłem hasło!"

**Objaw:**
```python
# W pliku config.py
password = "moje_super_tajne_haslo"
```
Commitnięte i pushowane na GitHub! 😱

**❌ NIE WYSTARCZY:**
```bash
# To NIE usuwa hasła z historii!
git rm config.py
git commit -m "Remove password file"
```
Hasło nadal jest w historii commitów!

**✅ POPRAWNE rozwiązanie:**

1. **Dla małych repozytoriów - `git filter-branch`:**
```bash
git filter-branch --tree-filter 'rm -f config.py' HEAD
git push --force
```

2. **Dla większych - użyj narzędzia `BFG Repo-Cleaner`:**
```bash
bfg --delete-files config.py
git push --force
```

3. **NATYCHMIAST zmień hasło!** 🔒
   - Samo usunięcie z repozytorium nie wystarczy
   - Ktoś mógł już je pobrać
   - Zmień hasło w systemie

💡 **Prewencja:** Dodaj `config.py` do `.gitignore` PRZED pierwszym commitem!

---

### Problem 4: "Merge conflict - co robić?"

**Objaw:**
```bash
git merge feature/login
# CONFLICT (content): Merge conflict in app.py
```

**Co się stało:** Ty i ktoś inny zmieniliście ten sam fragment kodu.

**Jak wygląda konflikt w pliku:**
```python
def hello():
<<<<<<< HEAD
    return "Hello World"
=======
    return "Witaj Świecie"
>>>>>>> feature/login
```

**Rozwiązanie krok po kroku:**

1. **Otwórz plik z konfliktem**
   
2. **Znajdź markery:**
   - `<<<<<<< HEAD` - twoja wersja (obecna gałąź)
   - `=======` - separator
   - `>>>>>>> feature/login` - wersja z mergowanej gałęzi

3. **Zdecyduj co zachować:**
```python
# Opcja A - zachowaj HEAD
def hello():
    return "Hello World"

# Opcja B - zachowaj feature/login  
def hello():
    return "Witaj Świecie"

# Opcja C - połącz obie
def hello():
    return "Hello World / Witaj Świecie"
```

4. **Usuń markery:**
```python
def hello():
    return "Hello World"  # Wybrana wersja, bez markerów
```

5. **Dodaj do staging i commitnij:**
```bash
git add app.py
git commit -m "Resolve conflict in app.py"
```

💡 **Narzędzia pomocnicze:**
- VS Code ma wbudowany konflikt resolver
- PyCharm ma merge tool
- Komenda: `git mergetool`

---

### Problem 5: "Pomyłkowo zrobiłem commit na main zamiast na branchu"

**Objaw:**
```bash
# Myślałem że jestem na feature/login, ale byłem na main
git commit -m "Add login"
# Ups! To miało być na branchu!
```

**Rozwiązanie:**
```bash
# 1. Utwórz branch z tym commitem
git branch feature/login

# 2. Cofnij main do stanu sprzed commita
git reset --hard HEAD~1

# 3. Przełącz się na nowy branch
git switch feature/login
```

---

### Problem 6: "Zmieniłem 10 plików, ale chcę commitnąć tylko 2"

**Rozwiązanie:**
```bash
# NIE używaj: git add .

# Dodaj tylko wybrane pliki:
git add plik1.py plik2.py
git commit -m "Update plik1 and plik2 only"

# Pozostałe 8 plików pozostaje modified
```

💡 **Interaktywne dodawanie:**
```bash
git add -p  # Pytanie o każdą zmianę osobno
```

---

### Problem 7: "`git status` pokazuje setki zmian, które nie moje"

**Przyczyna:** Prawdopodobnie problem z końcami linii (Windows vs Linux/Mac)

**Rozwiązanie:**
```bash
# Ustaw automatyczną konwersję
git config --global core.autocrlf true  # Windows
git config --global core.autocrlf input  # Mac/Linux
```

---

### Problem 8: "Nie mogę zmienić brancha - uncommitted changes"

**Objaw:**
```bash
git switch main
# error: Your local changes would be overwritten
```

**Rozwiązanie 1 - commitnij:**
```bash
git add .
git commit -m "WIP: Work in progress"
git switch main
```

**Rozwiązanie 2 - stash (schowaj):**
```bash
git stash
git switch main
# (praca na main)
git switch feature/login
git stash pop  # Przywróć zmiany
```

---

### Problem 9: "Usunąłem plik przez `rm`, teraz Git go widzi"

**Złe podejście:**
```bash
rm plik.py
git status
# deleted: plik.py (not staged)
```

**Dobre podejście:**
```bash
# Użyj git rm zamiast rm
git rm plik.py
git commit -m "Remove plik.py"
```

**Lub:**
```bash
# Jeśli już usunąłeś przez rm:
git add -A  # Dodaje usunięcia do staging
git commit -m "Remove plik.py"
```

---

### Problem 10: "Co oznacza 'detached HEAD'?"

**Objaw:**
```bash
git checkout abc123
# You are in 'detached HEAD' state
```

**Co się stało:** Przeszedłeś do konkretnego commita zamiast gałęzi.

**Rozwiązanie - wróć do gałęzi:**
```bash
git switch main  # Wróć do normalnego stanu
```

**Jeśli zrobiłeś zmiany w detached HEAD:**
```bash
git switch -c nowa-nazwa-brancha  # Utwórz branch z tych zmian
```

---

## 10. Szybkie ściągi

### Najpopularniejsze komendy

```bash
# Sprawdzanie stanu (używaj cały czas!)
git status

# Podstawowy workflow
git add .
git commit -m "Describe your changes"
git push

# Pobieranie zmian
git pull

# Praca z branchami
git branch                    # Lista
git switch -c nazwa           # Utwórz i przełącz
git switch nazwa              # Przełącz
git merge nazwa               # Scal

# Historia
git log --oneline
git log --oneline --graph

# Cofanie
git restore plik              # Cofnij zmiany w pliku
git restore --staged plik     # Usuń ze staging
git reset --hard HEAD         # Wyrzuć wszystkie zmiany

# Pomoc
git help
git help add
```

### Struktura .gitignore dla Python

```gitignore
# Byte-compiled / optimized
*.py[cod]
__pycache__/

# Virtual environments
venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp

# Environment variables
.env
.env.local

# Databases
*.db
*.sqlite3

# Logs
*.log

# OS
.DS_Store
Thumbs.db
```

---

## Podsumowanie

✅ **Co już umiesz:**
- Czym jest Git i dlaczego jest używany
- Jak działa `.git/` i czym są migawki
- Podstawowe operacje (init, add, commit, push, pull)
- **Różnicę między fetch a pull**
- **Przeglądanie zmian (`git diff`)**
- Stany plików i jak Git działa "pod maską"
- Praca z branchami i scalanie (merge, rebase)
- **Tymczasowe schowanie zmian (`git stash`)**
- Cofanie zmian bezpiecznie (revert, reset, restore)
- Konfiguracja przez .gitignore i .gitkeep
- **SSH vs HTTPS** i jak skonfigurować klucze
- Dobre praktyki (commity po angielsku, Conventional Commits)
- Rozwiązywanie najczęstszych problemów

---

✅ **Następne kroki:**
- Praktyka! Najlepiej uczyć się przez działanie
- Przejdź do pliku `zadania_git.md` - bardziej zaawansowane zadania
- Rozwiąż zadania krok po kroku
- Eksperymentuj bez strachu - Git pozwala cofnąć każdą zmianę!

💡 **Pamiętaj:** Każdy programista uczył się Git metodą prób i błędów. To normalne!

🎉 **Powodzenia!**

