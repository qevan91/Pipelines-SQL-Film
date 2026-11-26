
CREATE table visionnage (
	title TEXT NOT NULL,
	platform_netflix bool NULL,
	platform_hulu bool NULL,
	platform_amazon bool NULL,
	platform_disney bool NULL,
	date_added date not NULL ,
	listed_in text not NULL
)

CREATE TABLE netflix (
    show_id TEXT PRIMARY KEY, type TEXT, title TEXT, director TEXT, "cast" TEXT,
    country TEXT, date_added DATE, release_year INTEGER, rating TEXT,
    duration TEXT, listed_in TEXT, description TEXT
);

CREATE TABLE disney_plus  (LIKE netflix INCLUDING ALL);
CREATE TABLE hulu         (LIKE netflix INCLUDING ALL);
CREATE TABLE amazon_prime (LIKE netflix INCLUDING ALL);
CREATE TABLE Fakedata (LIKE netflix INCLUDING ALL);

COPY netflix      FROM 'C:\data\netflix_titles.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY disney_plus  FROM 'C:\data\disney_plus_titles.csv'   WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY hulu         FROM 'C:\data\hulu_titles.csv'          WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
COPY amazon_prime FROM 'C:\data\amazon_prime_titles.csv'  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

Alter TABLE netflix Drop column show_id;
Alter TABLE disney_plus Drop column show_id;
Alter TABLE amazon_prime Drop column show_id;
Alter TABLE hulu Drop column show_id;

DROP TABLE film;

CREATE TABLE film (LIKE netflix INCLUDING ALL);
INSERT INTO film
SELECT * FROM netflix
UNION
SELECT * FROM disney_plus
UNION
SELECT * FROM hulu
UNION
SELECT * FROM amazon_prime;