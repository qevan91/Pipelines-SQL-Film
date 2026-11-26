import csv
import os
import random
import shutil
from concurrent.futures import ProcessPoolExecutor, as_completed

from faker import Faker
from tqdm import tqdm

SRC = "Fakedata.csv"
DST = "Fakedata_enrichi.csv"
N = 10_000_000  # nombre de lignes à ajouter
WORKERS = os.cpu_count() or 4
CHUNK = 100_000  # lignes par morceau (= granularité de la barre)

# Variables propres à chaque processus, remplies par init_worker()
modeles = prenoms = noms = mots = descriptions = None


def init_worker():
    global modeles, prenoms, noms, mots, descriptions
    fake = Faker("en_US")
    with open(SRC, newline="", encoding="utf-8") as f:
        modeles = [r for r in csv.reader(f) if len(r) == 11]
    prenoms = list({fake.first_name().replace("'", "") for _ in range(3000)})
    noms = list({fake.last_name().replace("'", "") for _ in range(3000)})
    mots = [fake.word() for _ in range(2000)]
    descriptions = [fake.paragraph(nb_sentences=2) for _ in range(20_000)]


def nom():
    return f"{random.choice(prenoms)} {random.choice(noms)}"


def nouvelle_ligne():
    r = list(random.choice(modeles))
    r[1] = " ".join(random.choice(mots) for _ in range(random.randint(1, 4))).title()  # title
    if r[2]:
        r[2] = nom()  # director
    if r[3]:
        r[3] = ", ".join(nom() for _ in range(random.randint(3, 8)))  # cast
    r[10] = random.choice(descriptions)  # description
    return r


def produire(args):
    idx, n = args
    part = f"{DST}.part{idx:05d}"
    with open(part, "w", newline="", encoding="utf-8") as f:
        csv.writer(f, lineterminator="\n").writerows([nouvelle_ligne() for _ in range(n)])
    return idx, n, part


def main():
    shutil.copyfile(SRC, DST)  # le fichier d'origine reste intact

    # Si le fichier d'origine ne finit pas par un saut de ligne, on en ajoute un
    with open(DST, "rb+") as f:
        f.seek(-1, os.SEEK_END)
        if f.read(1) != b"\n":
            f.write(b"\n")

    taches = []
    restant, idx = N, 0
    while restant > 0:
        n = min(CHUNK, restant)
        taches.append((idx, n))
        restant -= n
        idx += 1

    parts = {}
    with ProcessPoolExecutor(max_workers=WORKERS, initializer=init_worker) as ex:
        futures = [ex.submit(produire, t) for t in taches]
        with tqdm(total=N, desc="Génération", unit=" lignes", unit_scale=True) as barre:
            for fut in as_completed(futures):
                i, n, part = fut.result()
                parts[i] = part
                barre.update(n)

    # Concaténation dans l'ordre, avec sa propre barre
    with open(DST, "ab") as out:
        for i in tqdm(sorted(parts), desc="Assemblage", unit=" fichiers"):
            with open(parts[i], "rb") as src:
                shutil.copyfileobj(src, out)
            os.remove(parts[i])

    print(f"{N} lignes ajoutées dans {DST}")


if __name__ == "__main__":  # obligatoire sous Windows
    main()