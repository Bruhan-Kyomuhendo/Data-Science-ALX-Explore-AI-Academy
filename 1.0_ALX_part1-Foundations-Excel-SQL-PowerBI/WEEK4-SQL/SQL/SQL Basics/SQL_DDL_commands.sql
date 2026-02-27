
TRUNCATE TABLE united_nations.access_to_basic_services;

/*
CREATE TABLE united_nations.access_to_basic_services(
	Region VARCHAR(32),
    Sub_region VARCHAR(25),
    Country_name INTEGER NOT NULL,
    Time_period INTEGER NOT NULL,
    Pct_managed_drinking_water_services NUMERIC(5,2),
    Pct_managed_sanitation_services NUMERIC(5,2),
    Est_population_in_millions NUMERIC(5,2),
    Est_gdp_in_billions NUMERIC(8,2),
    Land_area NUMERIC(10,2),
    Pct_unemployment NUMERIC(5,2)
); 

-- ALTER TABLE
ALTER TABLE access_to_basic_services
MODIFY COLUMN Country_name VARCHAR(37);


-- Add new column
ALTER TABLE access_to_basic_services
ADD Gini_index FLOAT; 

-- Drop column
ALTER TABLE access_to_basic_services
DROP COLUMN Gini_index; 
-- Drop Table
DROP TABLE access_to_basic_services */

/* ---Data Manipulation commands
INSERT INTO united_nations.access_to_basic_services(
	Region,
    Sub_region,
    Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    Pct_managed_sanitation_services,
    Est_population_in_millions,
    Est_gdp_in_billions,
    Land_area,
    Pct_unemployment
)   
VALUES
	('Sub-Saharan Africa', 'Southern Africa', 'Botswana', 2020, 89.67, 74.33, 2.546402, 14.93, 566730, 21.02),
	('Sub-Saharan Africa', 'Southern Africa', 'South Africa', 2020, 92, 78.67, 58.801927, 337.62, 1213090, 24.34),
	('Sub-Saharan Africa', 'Southern Africa', 'Lesotho', 2020, 76.33, 49.67, 2.2541, 2.23, 30360, NULL),
	('Central and Southern Asia', 'Central Asia', 'Kazakhstan', 2020, 95, 98, 18.755666, 171.08, 2699700, 4.89)
;

SET SQL_SAFE_UPDATES = 0; -- Disables safe update mode that prevents deleting by throwing an error message
DELETE FROM united_nations.access_to_basic_services
WHERE     Sub_region = "Central Asia"
*/

/* -- updating a value that is NULL to an integer
UPDATE united_nations.access_to_basic_services
SET  Pct_unemployment = 4.53
WHERE Country_name ="china"
AND Time_period = 2016 ; */

-- Limit the rows to produce
SELECT 
	* 
FROM 
	united_nations.access_to_basic_services
LIMIT 10;

-- create another table of country names without duplicates
CREATE TABLE 
	Country_list(Country VARCHAR(255));
INSERT INTO 
	Country_list(Country)

SELECT DISTINCT
	Country_name
FROM 
	united_nations.access_to_basic_services;
