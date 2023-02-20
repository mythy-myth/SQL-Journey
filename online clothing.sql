-- Data source: £apczyñski M., Bia³ow¹s S. (2013) Discovering Patterns of Users' Behaviour in an E-shop - Comparison of Consumer Buying Behaviours in Poland and Other European Countries, “Studia Ekonomiczne”, nr 151, “La société de l'information : perspective européenne et globale : les usages et les risques d'Internet pour les citoyens et les consommateurs”, p. 144-153.
SELECT * FROM ehsopclothing.`e-shop clothing 2008`;

-- data cleaning data 

SELECT * FROM ehsopclothing.`e-shop clothing 2008`;
-- 1 mising values
SELECT  COUNT(*) as num_missing
FROM ehsopclothing.`e-shop clothing 2008`
WHERE `year` IS NULL OR `month` IS NULL OR `day` IS NULL OR `order` IS NULL OR `country` IS NULL OR `session ID` IS NULL OR `page 1 (main category)` IS NULL OR `page 2 (clothing model)` IS NULL OR `colour` IS NULL OR `location` IS NULL OR `model photography` IS NULL OR `price` IS NULL OR `price 2` IS NULL OR `page` IS NULL;

-- 2 identifyng Handling outliers and extreme values
SELECT * FROM ehsopclothing.`e-shop clothing 2008`;

SELECT `price 2` FROM ehsopclothing.`e-shop clothing 2008` 
WHERE `price 2` < (SELECT AVG(`price 2`) - 3*STDDEV_POP(`price 2`) FROM ehsopclothing.`e-shop clothing 2008`)
	OR `price 2` > (SELECT AVG(`price 2`) + 3*STDDEV_POP(`price 2`) FROM ehsopclothing.`e-shop clothing 2008`);

SELECT `order` FROM ehsopclothing.`e-shop clothing 2008` 
WHERE `order` < (SELECT AVG(`order`) - 16*STDDEV_POP(`order`) FROM ehsopclothing.`e-shop clothing 2008`)
	or `order` > (SELECT AVG(`order`) + 13*STDDEV_POP(`order`) FROM ehsopclothing.`e-shop clothing 2008`);
    
-- 3 i decide to keep the duplicate rows, in the context of an online store it is common to have multiple orders on a single day. So, in such cases, having duplicate rows with the same date and order number might be valid and expected.
-- 4 change the data type
ALTER TABLE ehsopclothing.`e-shop clothing 2008`
MODIFY COLUMN year YEAR;

ALTER TABLE ehsopclothing.`e-shop clothing 2008`
MODIFY COLUMN country VARCHAR(20);

SELECT * FROM ehsopclothing.`e-shop clothing 2008`;

UPDATE ehsopclothing.`e-shop clothing 2008`
SET country =
	CASE country
	WHEN 1 THEN 'Australia'
    WHEN 2 THEN 'Austria'
    WHEN 3 THEN 'Belgium'
    WHEN 4 THEN 'B Virgin Inds'
    WHEN 5 THEN 'Cayman Inds'
    WHEN 6 THEN 'Christmas Ind'
    WHEN 7 THEN 'Croatia'
    WHEN 8 THEN 'Cyprus'
    WHEN 9 THEN 'Czech Republic'
    WHEN 10 THEN 'Denmark'
    WHEN 11 THEN 'Estonia'
    WHEN 12 THEN 'unidentified'
    WHEN 13 THEN 'Faroe Islands'
    WHEN 14 THEN 'Finland'
    WHEN 15 THEN 'France'
    WHEN 16 THEN 'Germany'
    WHEN 17 THEN 'Greece'
    WHEN 18 THEN 'Hungary'
    WHEN 19 THEN 'Iceland'
    WHEN 20 THEN 'India'
    WHEN 21 THEN 'Ireland'
    WHEN 22 THEN 'Italy'
    WHEN 23 THEN 'Latvia'
    WHEN 24 THEN 'Lithuania'
    WHEN 25 THEN 'Luxembourg'
    WHEN 26 THEN 'Mexico'
    WHEN 27 THEN 'Netherlands'
    WHEN 28 THEN 'Norway'
    WHEN 29 THEN 'Poland'
    WHEN 30 THEN 'Portugal'
    WHEN 31 THEN 'Romania'
    WHEN 32 THEN 'Russia'
    WHEN 33 THEN 'San Marino'
    WHEN 34 THEN 'Slovakia'
    WHEN 35 THEN 'Slovenia'
    WHEN 36 THEN 'Spain'
    WHEN 37 THEN 'Sweden'
    WHEN 38 THEN 'Switzerland'
    WHEN 39 THEN 'Ukraine'
    WHEN 40 THEN 'UA E'
    WHEN 41 THEN 'UK'
    WHEN 42 THEN 'USA'
    WHEN 43 THEN 'biz'
    WHEN 44 THEN 'com'
    WHEN 45 THEN 'int'
    WHEN 46 THEN 'net'
    WHEN 47 THEN 'org'
    ELSE 'unknown'
  END;

ALTER TABLE ehsopclothing.`e-shop clothing 2008`
MODIFY COLUMN colour VARCHAR(16); 

UPDATE ehsopclothing.`e-shop clothing 2008`
SET colour = 
	CASE colour
    WHEN 1 THEN 'beige'
    WHEN 2 THEN 'black'
    WHEN 3 THEN 'blue'
    WHEN 4 THEN 'brown'
    WHEN 5 THEN 'burgundy'
    WHEN 6 THEN 'gray'
    WHEN 7 THEN 'green'
    WHEN 8 THEN 'navy blue'
    WHEN 9 THEN 'of many colors'
    WHEN 10 THEN 'olive'
    WHEN 11 THEN 'pink'
    WHEN 12 THEN 'red'
    WHEN 13 THEN 'violet'
    WHEN 14 THEN 'white'
	ELSE 'uknown'
END;


ALTER TABLE ehsopclothing.`e-shop clothing 2008`
MODIFY COLUMN `page 1 (main category)` VARCHAR(10); 

UPDATE ehsopclothing.`e-shop clothing 2008`
SET `page 1 (main category)` =
	CASE `page 1 (main category)`
    WHEN 1 THEN 'trousers'
	WHEN 2 THEN 'skirts'
	WHEN 3 THEN 'blouses'
	WHEN 4 THEN 'sale'
    ELSE 'UKNOWN'
END;


SELECT * FROM ehsopclothing.`e-shop clothing 2008`;

-- data ANALYZE

-- my analysist is to answe question that "HOW ORDERS IN APRIL TO  AUGUST, AND WHATS THE POINT THAT EFFECT TO ORDER"



-- my question is there a relationship between clothing color and order quantity?

SELECT
colour, sum(`order`) as total_orders
FROM ehsopclothing.`e-shop clothing 2008`
GROUP BY 
`colour`
ORDER BY
total_orders DESC;

-- my question is how does the page layout (page 1 and page 2) impact customer behavior and conversion rates?

SELECT 
`page 1 (main category)`,
`page 2 (clothing model)`,
count(*) as num_maincategory,
sum(`order`) as total_order,
sum(`order`) / count(*) as conversion_rate
FROM ehsopclothing.`e-shop clothing 2008`
GROUP BY 
`page 1 (main category)`,
`page 2 (clothing model)`
ORDER BY
conversion_rate DESC;


SELECT * FROM ehsopclothing.`e-shop clothing 2008`;