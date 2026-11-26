import csv

SRC = "Fakedata_enrichi.csv"
DST = "Fakedata_propre.csv"
NB_COLONNES = 11  # = nombre de colonnes de ta table fakedata

rejetees = 0
exemples = []

with open(SRC, newline="", encoding="utf-8") as fin, \
     open(DST, "w", newline="", encoding="utf-8") as fout:
    reader = csv.reader(fin)
    writer = csv.writer(fout, lineterminator="\n")
    writer.writerow(next(reader))  # en-tête
    for i, row in enumerate(reader, start=2):
        if len(row) == NB_COLONNES:
            writer.writerow(row)
        else:
            rejetees += 1
            if len(exemples) < 5:
                exemples.append((i, len(row)))

print(f"{rejetees} lignes rejetées")
print("Exemples (n° de ligne, nb de colonnes) :", exemples)