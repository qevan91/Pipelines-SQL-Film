import csv
import re
from datetime import datetime

SRC = "Fakedata_enrichi.csv"
DST = "Fakedata_propre.csv"
NB_COLONNES = 11

DATE_ISO_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
YEAR_RE = re.compile(r"^\d{4}$")


def nettoyer_date(val: str) -> str:
    val = val.strip()
    if not val:
        return ""
    if DATE_ISO_RE.match(val):
        try:
            datetime.strptime(val, "%Y-%m-%d")
            return val
        except ValueError:
            return ""
    # Tente de convertir un format texte type "August 1, 2020" si présent
    for fmt in ("%B %d, %Y", "%b %d, %Y", "%d/%m/%Y", "%m/%d/%Y"):
        try:
            return datetime.strptime(val, fmt).strftime("%Y-%m-%d")
        except ValueError:
            continue
    return ""


def nettoyer_annee(val: str) -> str:
    val = val.strip()
    return val if YEAR_RE.match(val) else ""


valides = 0
rejetees = 0
dates_corrigees = 0
exemples_rejets = []

with open(SRC, newline="", encoding="utf-8") as fin, \
     open(DST, "w", newline="", encoding="utf-8") as fout:
    reader = csv.reader(fin)
    writer = csv.writer(fout, lineterminator="\n")

    for i, row in enumerate(reader, start=1):
        # Ignorer une éventuelle ligne d'en-tête
        if i == 1 and row and row[0].strip().lower() == "type":
            continue

        if len(row) != NB_COLONNES:
            rejetees += 1
            if len(exemples_rejets) < 5:
                exemples_rejets.append((i, len(row)))
            continue

        row = [c.strip() for c in row]

        # Colonne index 5 = date_added, index 6 = release_year
        ancienne_date = row[5]
        row[5] = nettoyer_date(row[5])
        if ancienne_date and not row[5]:
            dates_corrigees += 1

        row[6] = nettoyer_annee(row[6])

        # Remettre les apostrophes simples propres si doublées ('')
        row[1] = row[1].replace("''", "'")
        row[10] = row[10].replace("''", "'")

        writer.writerow(row)
        valides += 1

print(f"Lignes valides écrites : {valides}")
print(f"Dates invalides mises à NULL : {dates_corrigees}")
print(f"Lignes rejetées (mauvais nb colonnes) : {rejetees}")
if exemples_rejets:
    print("Exemples de rejets (ligne, nb_colonnes) :", exemples_rejets)