
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



