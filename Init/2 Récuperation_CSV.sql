
COPY netflix      FROM 'C:\data\netflix_titles.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY disney_plus  FROM 'C:\data\disney_plus_titles.csv'   WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY hulu         FROM 'C:\data\hulu_titles.csv'          WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY amazon_prime FROM 'C:\data\amazon_prime_titles.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
-- code a lancer seulement apres la création du fakedata COPY Fakedata FROM 'C:\data\Fakedata_enrichi.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8'); 