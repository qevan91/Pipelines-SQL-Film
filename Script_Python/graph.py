import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Chargement et préparation des données des 4 plateformes
files = {
    'Prime Video': 'amazon_prime_titles.csv',
    'Netflix': 'netflix_titles.csv',
    'Hulu': 'hulu_titles.csv',
    'Disney+': 'disney_plus_titles.csv'
}

dfs = [pd.read_csv(path).assign(platform=plat) for plat, path in files.items()]
df_all = pd.concat(dfs, ignore_index=True)

# Normalisation des titres pour détecter les titres communs entre plateformes
df_all['title_norm'] = df_all['title'].astype(str).str.strip().str.lower()

# Nombre de plateformes distinctes proposant chaque titre
platform_counts = df_all.groupby('title_norm')['platform'].nunique()
df_all['n_platforms'] = df_all['title_norm'].map(platform_counts)
df_all['is_exclusive'] = df_all['n_platforms'] == 1

order = ['Disney+', 'Prime Video', 'Netflix', 'Hulu']
plt.rcParams['font.sans-serif'] = 'DejaVu Sans'
plt.rcParams['axes.edgecolor'] = '#CCCCCC'
plt.rcParams['axes.linewidth'] = 0.8

# Part du catalogue exclusive vs partagée (Barres empilées 100 %)
dist = pd.crosstab(df_all['platform'], df_all['n_platforms']).reindex(order)
dist_pct = dist.div(dist.sum(axis=1), axis=0) * 100

fig, ax = plt.subplots(figsize=(10.5, 5.4))
colors_1 = ['#1B6CA8', '#F39C12', '#E74C3C']
labels_1 = ['Exclusif (1 plateforme)', 'Partagé (2 plateformes)', 'Partagé (3 plateformes)']

left = np.zeros(len(order))
y_pos = np.arange(len(order))

for col, color, label in zip([1, 2, 3], colors_1, labels_1):
    vals = dist_pct[col].values
    counts = dist[col].values
    ax.barh(y_pos, vals, left=left, height=0.56, color=color, label=label, edgecolor='white', linewidth=1.2)
    for idx, (v, c) in enumerate(zip(vals, counts)):
        if v >= 5:
            ax.text(left[idx] + v / 2, y_pos[idx], f"{v:.1f}%\n({c:,})".replace(',', ' '),
                    va='center', ha='center', color='white', fontweight='bold', fontsize=9.5)
    left += vals

for idx, plat in enumerate(order):
    shared_pct = 100 - dist_pct.loc[plat, 1]
    shared_cnt = dist.loc[plat, 2] + dist.loc[plat, 3]
    ax.text(101.2, y_pos[idx], f"Partagé : {shared_pct:.1f}% ({shared_cnt})",
            va='center', ha='left', color='#333333', fontsize=9.2, fontweight='bold')

ax.set_yticks(y_pos)
ax.set_yticklabels(order, fontsize=11, fontweight='bold')
ax.invert_yaxis()
ax.set_xlim(0, 123)
ax.set_xticks([0, 20, 40, 60, 80, 100])
ax.set_xlabel("Part du catalogue (%)", fontsize=10.5, fontweight='bold', color='#333333')
ax.set_title("Graphique 1 : Part du catalogue exclusive vs partagée par plateforme",
             fontsize=13, fontweight='bold', pad=34, loc='left', color='#111111')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.grid(axis='x', linestyle='--', alpha=0.4)
ax.set_axisbelow(True)
ax.legend(loc='upper left', bbox_to_anchor=(0.0, 1.11), ncol=3, frameon=False, fontsize=9.5)

plt.tight_layout()
plt.savefig('chart1_exclusivite_globale.png', dpi=300, bbox_inches='tight')
plt.show()

# Volumes absolus (Titres exclusifs vs partagés par plateforme)
order_vol = ['Prime Video', 'Netflix', 'Hulu', 'Disney+']
vol_df = df_all.groupby(['platform', 'is_exclusive']).size().unstack(fill_value=0).reindex(order_vol)
vol_df.columns = ['Partagé', 'Exclusif']

fig, ax = plt.subplots(figsize=(9.5, 5.2))
x = np.arange(len(order_vol))
width = 0.52

ax.bar(x, vol_df['Exclusif'], width, label='Titres exclusifs', color='#2E86AB', edgecolor='white')
ax.bar(x, vol_df['Partagé'], width, bottom=vol_df['Exclusif'], label='Titres partagés (≥ 2 plateformes)', color='#E07A5F', edgecolor='white')

for idx, plat in enumerate(order_vol):
    excl = vol_df.loc[plat, 'Exclusif']
    part = vol_df.loc[plat, 'Partagé']
    tot = excl + part
    pct_excl = excl / tot * 100
    ax.text(x[idx], excl / 2, f"{excl:,}\n({pct_excl:.1f}%)".replace(',', ' '),
            ha='center', va='center', color='white', fontweight='bold', fontsize=9.5)
    ax.text(x[idx], tot + 180, f"Total : {tot:,}\n(Partagés : {part})".replace(',', ' '),
            ha='center', va='bottom', color='#222222', fontsize=9, fontweight='bold')

ax.set_xticks(x)
ax.set_xticklabels(order_vol, fontsize=11, fontweight='bold')
ax.set_ylim(0, 11300)
ax.set_ylabel("Nombre de titres au catalogue", fontsize=10.5, fontweight='bold', color='#333333')
ax.set_title("Graphique 2 : Volume des titres exclusifs et partagés par plateforme",
             fontsize=13, fontweight='bold', pad=16, loc='left', color='#111111')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.grid(axis='y', linestyle='--', alpha=0.4)
ax.set_axisbelow(True)
ax.legend(loc='upper right', frameon=True, facecolor='white', edgecolor='#DDDDDD', fontsize=9.5)

plt.tight_layout()
plt.savefig('chart2_volume_exclusif_partage.png', dpi=300, bbox_inches='tight')
plt.show()

# Taux d'exclusivité selon le type de contenu (Films vs Séries TV)
type_stats = (
    df_all.groupby(['platform', 'type'])['is_exclusive']
    .agg(total='count', excl='sum')
    .reset_index()
)
type_stats['pct_excl'] = type_stats['excl'] / type_stats['total'] * 100
piv = type_stats.pivot(index='platform', columns='type', values='pct_excl').reindex(order)

fig, ax = plt.subplots(figsize=(9.5, 5.2))
x = np.arange(len(order))
w = 0.36

ax.bar(x - w/2, piv['Movie'], w, label='Films (Movie)', color='#3D5A80', edgecolor='white')
ax.bar(x + w/2, piv['TV Show'], w, label='Séries TV (TV Show)', color='#EE6C4D', edgecolor='white')

for idx, plat in enumerate(order):
    vm = piv.loc[plat, 'Movie']
    ax.text(x[idx] - w/2, vm + 0.5, f"{vm:.1f}%", ha='center', va='bottom', fontsize=9.5, fontweight='bold', color='#3D5A80')
    vt = piv.loc[plat, 'TV Show']
    ax.text(x[idx] + w/2, vt + 0.5, f"{vt:.1f}%", ha='center', va='bottom', fontsize=9.5, fontweight='bold', color='#EE6C4D')

ax.set_xticks(x)
ax.set_xticklabels(order, fontsize=11, fontweight='bold')
ax.set_ylim(75, 100)
ax.set_ylabel("Part de titres exclusifs (%)", fontsize=10.5, fontweight='bold', color='#333333')
ax.set_title("Graphique 3 : Taux d'exclusivité des Films vs Séries TV (zoom 75 % – 100 %)",
             fontsize=13, fontweight='bold', pad=16, loc='left', color='#111111')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.grid(axis='y', linestyle='--', alpha=0.4)
ax.set_axisbelow(True)
ax.legend(loc='upper right', frameon=True, facecolor='white', edgecolor='#DDDDDD', fontsize=9.5)

plt.tight_layout()
plt.savefig('chart3_exclusivite_par_type.png', dpi=300, bbox_inches='tight')
plt.show()