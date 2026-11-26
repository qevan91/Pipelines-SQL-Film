-- Index sur les catégories
CREATE INDEX idx_fakedata_listed_in ON fakedata (listed_in text_pattern_ops);

-- Index sur l'année de sortie
CREATE INDEX idx_fakedata_release_year ON fakedata (release_year);