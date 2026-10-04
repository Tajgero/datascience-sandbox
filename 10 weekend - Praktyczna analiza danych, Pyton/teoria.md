# Blok 10 — Teoria: wizualizacja, storytelling, raportowanie

Ten plik to „ściąga” z najważniejszej teorii potrzebnej do ćwiczeń. Zakładamy, że Pandas już umiesz — tu skupiamy się na: **doborze wykresu**, **czytelności**, **interaktywności** i **dowiezieniu raportu**.

---

## 1) Zanim zrobisz wykres: pytanie → dane → decyzja
W pracy analityka wykres ma sens tylko, jeśli:
- odpowiada na konkretne pytanie,
- wspiera decyzję,
- da się go wyjaśnić jednym zdaniem.

**Przykłady pytań (air_quality):**
- „Czy PM2.5 rośnie zimą?” → trend w czasie + agregacja (dzień/tydzień) + rolling mean.
- „Która stacja jest najgorsza?” → porównanie kategorii (barplot/boxplot).
- „Czy pogoda wpływa na PM2.5?” → scatter + trendline / korelacje (ale ostrożnie z interpretacją).

---

## 2) Dobór wykresu do typu danych (praktyczna mapa)
### Czas (time series)
- linia: trend (po agregacji)
- rolling mean: wygładzenie krótkich wahań
- heatmapa (godzina × miesiąc): sezonowość

### Kategorie
- barplot: porównanie wartości między kategoriami (sortuj!)
- stacked bar: udziały (np. `deposit=yes/no` w bank)
- dotplot: często czytelniejszy niż słupki przy wielu kategoriach

### Rozkłady
- histogram + KDE: „jak wygląda rozkład”
- boxplot/violin: porównanie rozkładów między grupami

### Zależności (2+ zmienne)
- scatter: relacja 2 ciągłych
- regplot: relacja + prosta linia trendu (ale nie myl z przyczynowością)
- heatmapa korelacji: szybki przegląd (ale zależna od outlierów i braków)

---

## 3) Zasady czytelności (to robi różnicę w pracy)
**Minimum na każdym wykresie:**
- tytuł mówiący „co widać” (nie „Wykres 1”),
- opis osi + jednostki,
- legenda tylko gdy potrzebna,
- rozsądna liczba serii (nie 12 linii naraz),
- sensowny zakres osi (uważaj na obcięcie/wyolbrzymienie).

**Dobre praktyki:**
- sortuj kategorie po wartości,
- pokazuj agregaty (dzień/tydzień) zamiast surowych punktów, jeśli jest ich dużo,
- outliery: sprawdź, czy nie psują skali (rozważ medianę, clipping, log),
- 1 wykres = 1 komunikat.

---

## 4) Matplotlib: kiedy i jak
Matplotlib daje największą kontrolę (format, osie, adnotacje).

**Najczęstszy workflow:**
- `fig, ax = plt.subplots(...)`
- `ax.plot(...) / ax.bar(...)`
- `ax.set_title`, `ax.set_xlabel`, `ax.set_ylabel`
- `ax.grid(...)`, `ax.legend(...)`
- `fig.tight_layout()`
- zapis: `fig.savefig("plot.png", dpi=150)`

Przykład (schemat, bez uruchamiania tu):
~~~python
fig, ax = plt.subplots(figsize=(10, 4))
ax.plot(df_daily["date_time"], df_daily["PM2.5"])
ax.set_title("PM2.5 — średnia dzienna")
ax.set_xlabel("Data")
ax.set_ylabel("PM2.5 [µg/m³]")
ax.grid(True, alpha=0.3)
fig.tight_layout()
fig.savefig("pm25_daily.png", dpi=150)
~~~

**Kiedy Matplotlib jest najlepszy:**
- gdy chcesz pełną kontrolę nad wyglądem,
- gdy robisz wykresy do raportu PDF/slide (statyczne artefakty).

---

## 5) Seaborn: „statystyka + estetyka” szybciej
Seaborn jest zbudowany na Matplotlib i świetny do:
- wykresów rozkładów (`histplot`, `kdeplot`),
- porównań między grupami (`boxplot`, `violinplot`, `barplot`),
- zależności (`scatterplot`, `regplot`),
- heatmap (`heatmap`).

**Zasada praktyczna:**
- Seaborn do szybkiej analizy i wykresów „data science”
- Matplotlib do dopieszczania i produkcyjnych wykresów do raportu

Przykład (schemat):
~~~python
sns.boxplot(data=df_bank, x="deposit", y="balance")
plt.title("Saldo vs wynik kampanii")
plt.xlabel("Założył lokatę (deposit)")
plt.ylabel("Balance")
plt.tight_layout()
~~~

---

## 6) Plotly: interaktywność z głową
Plotly ma sens, gdy:
- chcesz eksplorować dane (hover, zoom),
- pokazujesz wynik „na żywo” na spotkaniu,
- robisz mini-dashboard w HTML.

**Co jest super w Plotly:**
- `plotly.express` robi 80% wykresów w 1–3 linijkach,
- eksport do HTML: `fig.write_html("chart.html")`.

Przykład (schemat):
~~~python
fig = px.line(df_daily, x="date_time", y="PM2.5", color="station",
              title="PM2.5 — trend dzienny (po stacjach)")
fig.write_html("pm25_trend.html")
~~~

**Pułapki:**
- interaktywność nie zastępuje narracji (w raporcie i tak trzeba napisać wniosek),
- zbyt duże dane = ciężkie HTML (agreguj i filtruj).

---

## 7) Storytelling analityczny: prosta struktura, która działa
Najprostsza struktura raportu/sekcji:
1) Kontekst: co analizujemy i po co (1–3 zdania)
2) Metoda: jak policzyliśmy (1–2 zdania, bez lania wody)
3) Insighty: 3–5 punktów, każdy wsparty 1 wykresem/tabelą
4) Rekomendacje: co robić dalej (konkretne działania)
5) Ograniczenia: braki danych, sezonowość, outliery, bias

**Szablon zdania do insightu:**
- „W okresie X obserwujemy Y, co sugeruje Z. Rekomendacja: …”

**Anti-patterny:**
- lista wykresów bez wniosków,
- wnioski bez liczb („wydaje się, że…”),
- „korelacja = przyczyna”.

---

## 8) Raportowanie: Excel (xlsxwriter) — praktyczny standard
Excel jest nadal „językiem biznesu”. Celem jest plik, który:
- ma arkusz `summary` (najważniejsze KPI + 1–2 wykresy),
- ma arkusz `details` (tabele pomocnicze, np. top stacje, miesiące),
- ma formatowanie: nagłówki, format liczb, szerokości kolumn.

**Tipy produkcyjne:**
- zapisuj tabele jako „płaskie” (czytelne), nie 200 pivotów bez opisu,
- zawsze dodaj datę wygenerowania raportu,
- zamrażaj pierwszy wiersz w `summary`.

Przykładowy workflow (schemat):
~~~python
with pd.ExcelWriter("report.xlsx", engine="xlsxwriter") as writer:
    df_summary.to_excel(writer, sheet_name="summary", index=False)
    df_details.to_excel(writer, sheet_name="details", index=False)

    workbook  = writer.book
    ws_sum = writer.sheets["summary"]

    fmt_header = workbook.add_format({"bold": True})
    ws_sum.set_row(0, None, fmt_header)
    ws_sum.freeze_panes(1, 0)
~~~

---

## 9) Raport HTML/PDF: esparto (opcjonalnie)
Cel: szybki raport „jak strona”, który możesz wysłać jako HTML (czasem PDF).
W praktyce: generujesz wykresy (PNG albo HTML z Plotly) + piszesz krótkie sekcje.

W ćwiczeniach potraktujemy to jako „nice to have”: jeśli działa — super, jeśli nie — Excel + HTML z Plotly też jest OK.

---

## 10) Mapy: folium (opcjonalnie, gdy mamy lokalizacje)
Folium jest świetne do mapy:
- punktów (stacje, sklepy, oddziały),
- heatmapy (gęstość zdarzeń).

Jeśli dane nie mają współrzędnych, folium jest trudniejsze (trzeba geokodować albo mieć tabelę lokacji). W tym bloku folium jest dodatkiem „dla chętnych”.

---

## 11) Checklista jakości przed wysłaniem do biznesu
- Czy każdy wykres ma tytuł z tezą?
- Czy w raporcie są rekomendacje, a nie tylko obserwacje?
- Czy dane są opisane (źródło, zakres czasu, braki)?
- Czy widać, jak policzono agregacje (dzień/tydzień/miesiąc)?
- Czy odbiorca bez Pandasa zrozumie tabelę?

---

## 12) Minimalna matematyka (tylko to, co potrzebne)
- Średnia vs mediana: mediana jest bardziej odporna na outliery.
- Korelacja (Pearson): mierzy liniową zależność, ale:
  - nie oznacza przyczynowości,
  - jest wrażliwa na outliery i brakujące.
- Rolling mean: wygładza serię czasową (ułatwia trend), ale może ukryć skoki.

To wszystko — reszta teorii „wyjdzie” w praktyce w notebookach.