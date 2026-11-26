ALTER TABLE netflix
ADD platform_netflix Bool ;
ALTER TABLE disney_plus
ADD platform_disney Bool ;
ALTER TABLE hulu
ADD platform_hulu Bool ;
ALTER TABLE amazon_prime
ADD platform_amazon Bool ;
UPDATE netflix SET platform_netflix = TRUE Where platform_netflix IS NULL;
UPDATE disney_plus SET platform_disney = TRUE Where platform_disney IS NULL;
UPDATE hulu SET platform_hulu = TRUE Where platform_hulu IS NULL;
UPDATE amazon_prime SET platform_amazon = TRUE Where platform_amazon IS NULL;
	
