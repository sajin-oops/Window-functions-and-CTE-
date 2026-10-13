SELECT * FROM penguin_details;


-- How many rows are in the table?
SELECT COUNT(*) AS no_of_rows FROM penguin_details;


-- List the unique species.
SELECT DISTINCT(species) FROM penguin_details;

SELECT DISTINCT(island) FROM penguin_details;

-- Find penguins on Dream island heavier than 4000 g.
SELECT * FROM penguin_details WHERE island = 'Dream' AND body_mass_g > 4000;

-- Show the 5 heaviest penguins.
SELECT * FROM penguin_details ORDER BY body_mass_g DESC LIMIT 5;

SELECT * FROM penguin_details WHERE body_mass_g IS NOT NULL ORDER BY body_mass_g DESC LIMIT 5;

-- Count the missing values in each column.
SELECT COUNT(*) - COUNT(species) AS missing_species 
FROM penguin_details; 

/*

Basic

Aggregation and grouping

Find the average body mass per species.
Find the number of penguins per species and island.
Which species have an average body mass above 4000 g?
Count male and female penguins per species in one row each (pivot).
What percentage of the dataset is each species?
*/
-- Find the average body mass per species.
SELECT species,AVG(body_mass_g) FROM penguin_details
GROUP BY species;
 
SELECT species,ROUND(AVG(body_mass_g),2) FROM penguin_details
GROUP BY species;

-- Find the number of penguins per species and island.
-- working query
SELECT species,island,COUNT(*) AS total
FROM penguin_details
GROUP BY species,island
ORDER BY species;

-- Which species have an average body mass above 4000 g?
SELECT species, AVG(body_mass_g) FROM penguin_details
GROUP BY species
HAVING AVG(body_mass_g)>4000;

-- Count male and female penguins per species in one row each (pivot).
SELECT species,COUNT(*)FILTER(WHERE gender = 'Male') AS no_of_male,
	   COUNT(*)FILTER(WHERE gender = 'Female') AS no_of_female
FROM penguin_details
GROUP BY species;

SELECT species,
       COUNT(*) FILTER (WHERE gender = 'Male')   AS males,
       COUNT(*) FILTER (WHERE gender = 'Female') AS females
FROM penguin_details
GROUP BY species ORDER BY species;

SELECT * FROM penguin_details;

-- What percentage of the dataset is each species?

-- Intermediate
-- Categorise penguins by weight (Light, Medium, Heavy).
SELECT species,body_mass_g,
	CASE WHEN body_mass_g <= 2000 THEN 'Light'
		WHEN body_mass_g <= 4000 THEN 'Medium'
		WHEN body_mass_g > 4000 THEN 'Heavy'
	END AS weight_category
FROM penguin_details where body_mass_g IS NOT NULL;

SELECT * FROM penguin_details;

-- minimum 
SELECT MIN(body_mass_g) FROM penguin_details;

-- Creating a column in the existing table 
ALTER TABLE penguin_details
ADD COLUMN id BIGINT GENERATED ALWAYS AS IDENTITY;


-- Replace missing sex values with 'Unknown'
-- Find penguins heavier than the average of their own species.
 
SELECT species,ROUND(AVG(body_mass_g),2) FROM penguin_details
GROUP BY species;


SELECT species,AVG(body_mass_g) FROM penguin_details
GROUP BY species;

SELECT * FROM penguin_details;

-- Window functions and CTEs
-- Rank penguins by body mass within each species.  	WINDOW FUNCTION
SELECT species,body_mass_g,		
	RANK()OVER(PARTITION BY species ORDER BY body_mass_g DESC)
	FROM penguin_details
	WHERE body_mass_g IS NOT NULL;

-- Get the top 3 heaviest penguins per species.
WITH ranked AS(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY species ORDER BY body_mass_g DESC) AS rn
	FROM penguin_details
	WHERE body_mass_g IS NOT NULL
)
SELECT * FROM ranked  WHERE rn <=3

/*
Find the rows that contain any missing value.

Window functions and CTEs

Rank penguins by body mass within each species.
Get the top 3 heaviest penguins per species.
Show how far each penguin's weight is from its species average.
Find the median body mass per species.
Find the second heaviest penguin overall.
Detect outliers (more than 3 standard deviations from the species mean).

Data quality and ETL

Find duplicate rows.
Delete the duplicates, keeping one copy.
Add a primary key to the table.

Concept questions

What is the difference between WHERE and HAVING?
What is the difference between COUNT(*) and COUNT(column)?
What is the difference between ROW_NUMBER, RANK and DENSE_RANK?
What is the difference between DELETE, TRUNCATE and DROP?
How do you handle NULL values in an ETL pipeline?

*/




