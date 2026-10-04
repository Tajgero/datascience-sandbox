# Zadania praktyczne - Git dla początkujących

## Spis treści
1. [Zadania podstawowe (1-5)](#zadania-podstawowe) - Pierwsze kroki z Git
2. [Zadania z branchingiem (6-9)](#zadania-z-branchingiem) - Praca z gałęziami
3. [Zadania z cofaniem zmian (10-12)](#zadania-z-cofaniem-zmian) - Naprawianie błędów
4. [Zadania zaawansowane (13-15)](#zadania-zaawansowane) - Workflow profesjonalisty

---

## Zadania podstawowe

### Zadanie 1: Pierwsze repozytorium 🟢

**Scenariusz:**
Zaczynasz nowy projekt Python - prostą aplikację kalkulatora. Chcesz od samego początku śledzić zmiany w kodzie za pomocą Git.

**Cel:**
Utworzyć lokalne repozytorium Git i skonfigurować swoją tożsamość.

**Kroki:**
1. Utwórz nowy folder o nazwie `kalkulator_projekt`
2. Wejdź do tego folderu
3. Zainicjalizuj repozytorium Git
4. Skonfiguruj swoją nazwę użytkownika dla Git (globalnie)
5. Skonfiguruj swój email dla Git (globalnie)
6. Sprawdź czy repozytorium zostało utworzone

**Wskazówka:**
💡 Po inicjalizacji repozytorium powinien pojawić się ukryty folder `.git`. Na systemach Unix możesz go zobaczyć używając `ls -la`.

**Jak sprawdzić:**
- Komenda `git status` powinna działać bez błędów
- Komenda `git config user.name` powinna wyświetlić twoją nazwę
- Komenda `git config user.email` powinna wyświetlić twój email

---

### Zadanie 2: Pierwszy commit 🟢

**Scenariusz:**
Napisałeś pierwszą wersję kalkulatora. To prosty plik Python z podstawowymi funkcjami. Chcesz zapisać ten stan w historii Git.

**Cel:**
Utworzyć pliki, dodać je do staging area i wykonać pierwszy commit.

**Kroki:**
1. W folderze `kalkulator_projekt` utwórz plik `kalkulator.py`
2. Dodaj do niego kod prostej funkcji dodawania:
   ```python
   def dodaj(a, b):
       return a + b
   
   if __name__ == "__main__":
       print(dodaj(5, 3))
   ```
3. Utwórz też plik `README.md` z opisem:
   ```markdown
   # Kalkulator
   Prosty kalkulator w Pythonie
   ```
4. Sprawdź status repozytorium
5. Dodaj oba pliki do staging area
6. Sprawdź status ponownie (obserwuj różnicę!)
7. Wykonaj commit z komunikatem "Utworzono podstawową strukturę projektu"
8. Sprawdź historię commitów

**Wskazówka:**
💡 Używaj `git status` po każdej operacji, żeby zobaczyć co się zmieniło!

**Jak sprawdzić:**
- `git log` powinien pokazać jeden commit
- `git status` powinien pokazać "working tree clean"
- Oba pliki powinny być w repozytorium

---

### Zadanie 3: Modyfikacja i śledzenie zmian 🟢

**Scenariusz:**
Postanowiłeś dodać więcej funkcji do kalkulatora. Chcesz zobaczyć dokładnie co zmieniłeś przed zrobieniem commita.

**Cel:**
Nauczyć się śledzić zmiany w plikach i przeglądać różnice.

**Kroki:**
1. Otwórz plik `kalkulator.py`
2. Dodaj nowe funkcje odejmowania, mnożenia i dzielenia:
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
3. Sprawdź status - plik powinien być "modified"
4. Zobacz dokładnie co zmieniłeś (bez dodawania do staging)
5. Dodaj zmiany do staging area
6. Zobacz różnice między staging a ostatnim commitem
7. Wykonaj commit z komunikatem "Dodano funkcje odejmowania, mnożenia i dzielenia"
8. Wyświetl historię commitów w zwięzłej formie (jedna linia na commit)

**Wskazówka:**
💡 Komenda `git diff` pokazuje różnice przed dodaniem do staging, `git diff --staged` pokazuje różnice w staging.

**Jak sprawdzić:**
- Historia powinna zawierać 2 commity
- `git log --oneline` powinien pokazać zwięzłą historię
- Working directory powinien być czysty

---

### Zadanie 4: Ignorowanie plików 🟡

**Scenariusz:**
Uruchomiłeś skrypt Pythona, który utworzył foldery `__pycache__/` i pliki `.pyc`. Nie chcesz ich commitować, bo są generowane automatycznie. Dodatkowo masz plik konfiguracyjny `config.local.py` z hasłami, którego też nie wolno commitować.

**Cel:**
Utworzyć plik `.gitignore` i nauczyć się ignorować niepotrzebne pliki.

**Kroki:**
1. Utwórz folder `__pycache__` i plik `kalkulator.pyc` w środku (symulacja)
2. Utwórz plik `config.local.py` z przykładową zawartością:
   ```python
   SECRET_KEY = "super-tajne-haslo-123"
   ```
3. Sprawdź `git status` - wszystkie te pliki powinny być widoczne
4. Utwórz plik `.gitignore` w głównym folderze
5. Dodaj do niego wzorce ignorowania:
   - Folder `__pycache__/` i wszystko w nim
   - Wszystkie pliki `.pyc`
   - Plik `config.local.py`
6. Sprawdź `git status` ponownie - pliki powinny zniknąć!
7. Utwórz plik `config.example.py` z przykładową strukturą (bez prawdziwych haseł):
   ```python
   SECRET_KEY = "twoje-haslo-tutaj"
   ```
8. Dodaj `.gitignore` i `config.example.py` do staging
9. Commitnij z komunikatem "Dodano .gitignore i przykładową konfigurację"

**Wskazówka:**
💡 `.gitignore` sam w sobie POWINIEN być commitowany! To `.gitignore` chroni wrażliwe pliki przed commitem.

**Jak sprawdzić:**
- `git status` nie powinien pokazywać `__pycache__/`, `*.pyc` ani `config.local.py`
- `.gitignore` i `config.example.py` powinny być w repozytorium
- Sprawdź `git log --oneline` - powinny być 3 commity

---

### Zadanie 5: Podróż w czasie po historii 🟡

**Scenariusz:**
Twój kalkulator ma już kilka wersji. Chcesz zobaczyć jak wyglądał projekt na początku i porównać różne wersje.

**Cel:**
Nauczyć się przeglądać historię commitów i ich szczegóły.

**Kroki:**
1. Wyświetl pełną historię commitów z datami i autorami
2. Wyświetl historię w formie zwięzłej (jedna linia na commit)
3. Zobacz szczegóły pierwszego commita (ten z "podstawową strukturą")
4. Zobacz dokładnie co zostało zmienione w drugim commicie (dodanie funkcji)
5. Wyświetl historię tylko dla pliku `kalkulator.py`
6. Dodaj nowy plik `historia.txt` i napisz w nim podsumowanie commitów
7. Commitnij ten plik

**Wskazówka:**
💡 Każdy commit ma unikalny hash (np. `a3f5b81`). Możesz użyć tego hasha do przeglądania konkretnego commita.

**Jak sprawdzić:**
- Powinieneś widzieć wszystkie 4 commity w historii
- Potrafisz powiedzieć co było zmienione w każdym commicie
- Plik `historia.txt` jest w najnowszym commicie

---

## Zadania z branchingiem

### Zadanie 6: Pierwsza gałąź 🟢

**Scenariusz:**
Chcesz dodać zaawansowane operacje matematyczne (potęgowanie, pierwiastkowanie) do kalkulatora, ale nie jesteś pewien czy będą działać dobrze. Nie chcesz psuć głównej wersji. Użyjesz brancha!

**Cel:**
Nauczyć się tworzyć gałęzie i przełączać się między nimi.

**Kroki:**
1. Sprawdź na jakiej gałęzi aktualnie jesteś
2. Utwórz nową gałąź o nazwie `feature/zaawansowane-operacje`
3. Wyświetl listę wszystkich gałęzi
4. Przełącz się na nową gałąź
5. W pliku `kalkulator.py` dodaj funkcje:
   ```python
   def potega(a, b):
       return a ** b
   
   def pierwiastek(a):
       return a ** 0.5
   ```
6. Commitnij zmiany z komunikatem "Dodano potęgowanie i pierwiastkowanie"
7. Przełącz się z powrotem na gałąź `main`
8. Otwórz `kalkulator.py` i sprawdź czy nowe funkcje są widoczne

**Wskazówka:**
💡 Gdy przełączysz się z powrotem na `main`, nowe funkcje znikną z pliku! To normalne - są tylko na branchu `feature/zaawansowane-operacje`.

**Jak sprawdzić:**
- Na branchu `feature/zaawansowane-operacje`: plik zawiera nowe funkcje
- Na branchu `main`: plik NIE zawiera nowych funkcji
- `git branch` pokazuje obie gałęzie

---

### Zadanie 7: Praca równoległa na gałęziach 🟡

**Scenariusz:**
Podczas gdy na branchu `feature/zaawansowane-operacje` dodajesz nowe funkcje, dostałeś zgłoszenie buga w funkcji głównej. Musisz naprawić błąd na `main`, ale nie chcesz porzucać pracy nad funkcjami zaawansowanymi.

**Cel:**
Nauczyć się pracować równolegle na wielu gałęziach.

**Kroki:**
1. Upewnij się, że jesteś na branchu `main`
2. Utwórz nowy branch `bugfix/dzielenie-przez-zero`
3. Przełącz się na ten branch
4. "Znajdź błąd" w funkcji `dzielenie` i popraw go (np. dodaj lepszą obsługę):
   ```python
   def podziel(a, b):
       if b == 0:
           raise ValueError("Nie można dzielić przez zero")
       return a / b
   ```
5. Commitnij z komunikatem "Poprawiono obsługę dzielenia przez zero"
6. Przełącz się na `feature/zaawansowane-operacje`
7. Dodaj jeszcze jedną funkcję (np. modulo):
   ```python
   def modulo(a, b):
       return a % b
   ```
8. Commitnij z komunikatem "Dodano operację modulo"
9. Wyświetl wszystkie branche
10. Wyświetl historię z grafiką pokazującą gałęzie

**Wskazówka:**
💡 Używaj `git log --oneline --graph --all` aby zobaczyć jak rozgałęziła się historia.

**Jak sprawdzić:**
- Powinieneś mieć 3 branche: `main`, `feature/zaawansowane-operacje`, `bugfix/dzielenie-przez-zero`
- Każdy branch ma różne zmiany
- Historia pokazuje rozgałęzienie

---

### Zadanie 8: Scalanie gałęzi (merge) 🟡

**Scenariusz:**
Poprawka buga jest przetestowana i działa. Czas scalić ją z główną gałęzią `main`. Potem chcesz również dodać zaawansowane operacje do `main`.

**Cel:**
Nauczyć się scalać gałęzie bez konfliktów.

**Kroki:**
1. Przełącz się na gałąź `main`
2. Scal branch `bugfix/dzielenie-przez-zero` do `main`
3. Sprawdź plik `kalkulator.py` - powinieneś zobaczyć poprawkę
4. Wyświetl historię - powinieneś zobaczyć commity z bugfix
5. Usuń branch `bugfix/dzielenie-przez-zero` (już niepotrzebny)
6. Teraz scal `feature/zaawansowane-operacje` do `main`
7. Sprawdź plik - wszystkie funkcje powinny być obecne
8. Usuń branch `feature/zaawansowane-operacje`
9. Wyświetl finalną historię

**Wskazówka:**
💡 Po pomyślnym merge możesz usunąć branch komendą `git branch -d nazwa-brancha`.

**Jak sprawdzić:**
- Gałąź `main` zawiera wszystkie zmiany (bugfix + nowe funkcje)
- Usunięte branche nie są widoczne w `git branch`
- Historia pokazuje merge commits

---

### Zadanie 9: Rozwiązywanie konfliktów 🔴

**Scenariusz:**
Ty i twój kolega pracowaliście nad tym samym plikiem. Oboje zmieniliście tę samą linię kodu. Przy próbie scalenia Git zgłasza konflikt. Musisz go rozwiązać ręcznie.

**Cel:**
Nauczyć się rozwiązywać konflikty podczas merge.

**Kroki:**
1. Będąc na `main`, utwórz branch `feature/wersja-a`
2. W pliku `kalkulator.py` zmień sekcję `if __name__ == "__main__":` na:
   ```python
   if __name__ == "__main__":
       print("=== KALKULATOR WERSJA A ===")
       print(dodaj(5, 3))
   ```
3. Commitnij z komunikatem "Wersja A interfejsu"
4. Wróć na `main`
5. Utwórz branch `feature/wersja-b`
6. W tym samym miejscu zmień na:
   ```python
   if __name__ == "__main__":
       print("*** KALKULATOR WERSJA B ***")
       print(dodaj(10, 20))
   ```
7. Commitnij z komunikatem "Wersja B interfejsu"
8. Wróć na `main`
9. Scal `feature/wersja-a` (to przejdzie bez problemu)
10. Teraz spróbuj scalić `feature/wersja-b` - KONFLIKT!
11. Otwórz `kalkulator.py` i znajdź markery konfliktu (`<<<<<<<`, `=======`, `>>>>>>>`)
12. Zdecyduj która wersja ma zostać (lub połącz obie)
13. Usuń markery konfliktu
14. Dodaj plik do staging
15. Dokończ merge (commit)
16. Usuń niepotrzebne branche

**Wskazówka:**
💡 Konflikt wygląda tak:
```python
<<<<<<< HEAD
print("=== KALKULATOR WERSJA A ===")
=======
print("*** KALKULATOR WERSJA B ***")
>>>>>>> feature/wersja-b
```
Musisz wybrać co zachować i usunąć markery!

**Jak sprawdzić:**
- Plik nie zawiera markerów `<<<<<<<`, `=======`, `>>>>>>>`
- Merge został zakończony (commit merge)
- `git status` pokazuje clean working tree

---

## Zadania z cofaniem zmian

### Zadanie 10: Cofanie zmian przed commitem 🟢

**Scenariusz:**
Zacząłeś modyfikować plik `kalkulator.py`, ale zmiany poszły w złą stronę. Plik jest teraz zepsuty i chcesz wrócić do ostatniego commita.

**Cel:**
Nauczyć się cofać zmiany w working directory.

**Kroki:**
1. Otwórz `kalkulator.py` i dodaj śmieciowy kod:
   ```python
   def zepsuta_funkcja():
       asdfasdf to nie zadziała!!!
       @@@ błąd
   ```
2. Zapisz plik
3. Sprawdź `git status` - plik jest modified
4. Sprawdź różnice (co się zmieniło)
5. Cofnij zmiany w pliku (przywróć wersję z ostatniego commita)
6. Sprawdź `git status` ponownie - powinno być czysto
7. Otwórz plik i zweryfikuj że śmieciowy kod zniknął

**Wskazówka:**
💡 Operacja cofnięcia zmian w pliku jest NIEODWRACALNA! Stracisz niezapisane zmiany.

**Jak sprawdzić:**
- Plik wrócił do wersji z ostatniego commita
- `git status` pokazuje clean working tree
- Śmieciowy kod zniknął

---

### Zadanie 11: Cofanie commita (revert) 🟡

**Scenariusz:**
Zrobiłeś commit, który dodał nową funkcję, ale okazało się że funkcja ma poważny bug. Commit został już spushowany na GitHuba, więc nie możesz go usunąć z historii. Musisz go cofnąć bezpiecznie.

**Cel:**
Nauczyć się używać `git revert` do bezpiecznego cofania commitów.

**Kroki:**
1. Dodaj nową funkcję do `kalkulator.py`:
   ```python
   def zla_funkcja():
       return "Ta funkcja ma buga!"
   ```
2. Commitnij z komunikatem "Dodano nową funkcję (bug!)"
3. Zobacz historię i znajdź hash tego commita
4. Cofnij ten commit używając `git revert` (utworzy to nowy commit)
5. Zobacz historię - oba commity powinny być widoczne (oryginalny + revert)
6. Sprawdź plik `kalkulator.py` - zła funkcja powinna zniknąć

**Wskazówka:**
💡 `git revert` NIE usuwa commita z historii - tworzy nowy commit, który cofa zmiany!

**Jak sprawdzić:**
- Historia zawiera commit "Dodano nową funkcję" + commit "Revert..."
- Plik nie zawiera `zla_funkcja`
- Możesz zobaczyć w historii że coś było cofnięte

---

### Zadanie 12: Eksperyment z reset 🔴

**Scenariusz:**
Chcesz zrozumieć różnicę między `git reset --soft`, `--mixed` i `--hard`. Zrobisz eksperyment z lokalnymi commitami (NIE spushowanymi).

**Cel:**
Nauczyć się różnic między trybami `git reset`.

**Kroki - Część 1 (--soft):**
1. Utwórz nowy plik `test_reset.txt` z zawartością "Wersja 1"
2. Commitnij z komunikatem "Test reset - commit 1"
3. Zmień zawartość na "Wersja 2" i commitnij "Test reset - commit 2"
4. Zmień zawartość na "Wersja 3" i commitnij "Test reset - commit 3"
5. Zobacz historię - 3 nowe commity
6. Wykonaj `git reset --soft HEAD~1` (cofa o 1 commit)
7. Sprawdź `git status` - zmiany są w staging!
8. Sprawdź plik - zawiera "Wersja 3"
9. Zobacz historię - tylko 2 commity

**Kroki - Część 2 (--mixed):**
10. Commitnij ponownie z komunikatem "Test reset - commit 3 ponownie"
11. Zmień plik na "Wersja 4" i commitnij "Test reset - commit 4"
12. Wykonaj `git reset --mixed HEAD~1` (lub samo `git reset HEAD~1`)
13. Sprawdź `git status` - zmiany NIE są w staging (modified)
14. Sprawdź plik - zawiera "Wersja 4"

**Kroki - Część 3 (--hard) ⚠️:**
15. Dodaj do pliku "Wersja 5 - niezapisana"
16. NIE commituj
17. Wykonaj `git reset --hard HEAD`
18. Sprawdź plik - zmiany ZNIKNĘŁY! Plik jest w wersji z ostatniego commita

**Wskazówka:**
💡 To zadanie jest eksperymentalne - pokazuje różnice między trybami reset. W prawdziwym projekcie używaj `--hard` bardzo ostrożnie!

**Jak sprawdzić:**
- Rozumiesz różnicę między `--soft` (zmiany w staging), `--mixed` (zmiany w plikach), `--hard` (zmiany usunięte)
- Plik wrócił do "Wersji 3"
- Widziałeś jak `--hard` usuwa niezapisane zmiany

---

## Zadania zaawansowane

### Zadanie 13: Symulacja pracy ze zdalnym repozytorium 🟡

**Scenariusz:**
Chcesz przećwiczyć workflow z GitHubem, ale bez faktycznego tworzenia konta. Użyjesz drugiego lokalnego folderu jako "symulowanego" GitHuba.

**Cel:**
Zrozumieć koncepcję remote, push i pull.

**Kroki:**
1. Wyjdź z folderu `kalkulator_projekt`
2. Utwórz folder `zdalne_repo` i wejdź do niego
3. Zainicjalizuj puste repozytorium (`git init --bare`)
4. Wróć do `kalkulator_projekt`
5. Dodaj zdalne repozytorium o nazwie `origin` wskazujące na `../zdalne_repo`
6. Wypchnij branch `main` do zdalnego repo
7. Zobacz listę zdalnych repozytoriów
8. Teraz wyjdź z `kalkulator_projekt`
9. Sklonuj `zdalne_repo` do nowego folderu `klon_projektu`
10. Wejdź do `klon_projektu` i zobacz pliki - powinny być identyczne!
11. W `klon_projektu` dodaj komentarz do `kalkulator.py`
12. Commitnij i wypchnij zmiany
13. Wróć do `kalkulator_projekt`
14. Pobierz zmiany (pull)
15. Sprawdź czy komentarz się pojawił

**Wskazówka:**
💡 To symuluje pracę 2 programistów: jeden w `kalkulator_projekt`, drugi w `klon_projektu`. Obaj synchronizują się przez `zdalne_repo`.

**Jak sprawdzić:**
- Zmiany z `klon_projektu` są widoczne w `kalkulator_projekt`
- Oba foldery mają identyczną historię
- Rozumiesz jak działa push i pull

---

### Zadanie 14: Struktura folderów z .gitkeep 🟢

**Scenariusz:**
Twoja aplikacja kalkulatora będzie zapisywać logi do folderu `logs/` i cache do `cache/`. Chcesz żeby te foldery były w repozytorium, ale bez plików w nich (bo pliki .log są ignorowane).

**Cel:**
Nauczyć się używać `.gitkeep` do śledzenia pustych folderów.

**Kroki:**
1. W `kalkulator_projekt` utwórz folder `logs/`
2. Utwórz folder `cache/`
3. Spróbuj dodać te foldery do Git (`git add logs/ cache/`)
4. Sprawdź `git status` - foldery nie są widoczne! (Git ignoruje puste foldery)
5. Utwórz plik `logs/.gitkeep` (pusty)
6. Utwórz plik `cache/.gitkeep` (pusty)
7. Dodaj `.gitignore` regułę ignorującą pliki w tych folderach:
   ```gitignore
   logs/*.log
   cache/*
   !cache/.gitkeep
   ```
8. Dodaj pliki `.gitkeep` do staging
9. Commitnij z komunikatem "Dodano strukturę folderów dla logów i cache"
10. Utwórz testowy plik `logs/test.log`
11. Sprawdź `git status` - plik `.log` nie powinien być widoczny

**Wskazówka:**
💡 `.gitkeep` to tylko konwencja (puste pliki), ale Git go śledzi, więc folder się pojawi w repo!

**Jak sprawdzić:**
- Foldery `logs/` i `cache/` są w repozytorium
- Pliki `.log` w tych folderach są ignorowane
- Sklonowanie repo utworzy te foldery

---

### Zadanie 15: Eksperyment z rebase (opcjonalne) 🔴

**Scenariusz:**
Chcesz nauczyć się `git rebase` - zaawansowanej techniki przepisywania historii, która pozwala na "czystszą" historię commitów.

**Cel:**
Zrozumieć różnicę między `merge` a `rebase` i kiedy używać rebase.

**Kroki:**
1. Na branchu `main` utwórz plik `historia_rebase.txt` z "Commit 1 na main"
2. Commitnij
3. Utwórz branch `feature/rebase-test`
4. Na tym branchu dodaj do pliku "Commit 2 na feature"
5. Commitnij
6. Dodaj "Commit 3 na feature"
7. Commitnij
8. Przełącz się na `main`
9. Dodaj do pliku "Commit 4 na main"
10. Commitnij
11. Zobacz historię graficzną (`git log --oneline --graph --all`)
12. Przełącz się na `feature/rebase-test`
13. Wykonaj `git rebase main`
14. Zobacz historię ponownie - linia powinna być prosta!
15. Commity z `feature/rebase-test` zostały "przeniesione" na koniec main
16. Przełącz się na `main` i scal `feature/rebase-test`
17. Zobacz finalną historię - liniową, bez merge commita

**Wskazówka:**
💡 Rebase "przepisuje" historię - commity dostają nowe ID. NIE używaj rebase dla commitów, które już spushowałeś!

**Jak sprawdzić:**
- Historia jest liniowa (prosta linia, nie rozgałęziona)
- Nie ma merge commita
- Commity feature są "na końcu" main

---

## Podsumowanie zadań

✅ **Co przećwiczyłeś:**
- Inicjalizację repozytorium i podstawowe komendy
- Tworzenie commitów i przeglądanie historii
- Ignorowanie plików przez `.gitignore`
- Tworzenie i scalanie gałęzi
- Rozwiązywanie konfliktów
- Cofanie zmian różnymi metodami
- Pracę ze zdalnymi repozytoriami
- Zachowanie struktury folderów

💡 **Następne kroki:**
- Sprawdź swoje rozwiązania w pliku `rozwiazania_git.md`
- Eksperymentuj dalej - Git pozwala cofnąć prawie każdą operację!
- Utwórz konto na GitHubie i spróbuj prawdziwego push/pull
- Współpracuj z kimś nad wspólnym projektem

🎉 **Świetna robota!** Jesteś teraz gotowy do pracy z Git w prawdziwych projektach!

