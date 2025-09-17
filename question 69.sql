DROP TABLE IF EXISTS module.country_data;

CREATE TABLE module.country_data (
  country_name   VARCHAR(15),
  indicator_name VARCHAR(25),
  year_2010 DECIMAL(3,2),
  year_2011 DECIMAL(3,2),
  year_2012 DECIMAL(3,2),
  year_2013 DECIMAL(3,2),
  year_2014 DECIMAL(3,2)
);

INSERT INTO module.country_data
(country_name, indicator_name, year_2010, year_2011, year_2012, year_2013, year_2014) VALUES
('United States','Control of Corruption',      1.26, 1.51, 1.52, 1.55, 1.50),
('United States','Government Effectiveness',   1.27, 1.45, 1.28, 1.40, 1.36),
('United States','Regulatory Quality',         1.62, 1.63, 1.63, 1.59, 1.57),
('United States','Rule of Law',                1.32, 1.61, 1.60, 1.58, 1.55),
('United States','Voice and Accountability',   1.30, 1.11, 1.13, 1.20, 1.25),
('Canada','Control of Corruption',             1.46, 1.61, 1.71, 1.68, 1.66),
('Canada','Government Effectiveness',          1.47, 1.55, 1.38, 1.44, 1.41),
('Canada','Regulatory Quality',                1.38, 1.73, 1.63, 1.60, 1.58),
('Canada','Rule of Law',                       1.42, 1.71, 1.80, 1.76, 1.72),
('Canada','Voice and Accountability',          1.40, 1.19, 1.21, 1.22, 1.24);

/*69)In the realm of global indicators and country-level assessments, it's imperative to identify the years in which certain 
indicators hit their lowest values for each country. Leveraging a dataset provided by government, which contains indicators 
across multiple years for various countries, your task is to formulate an SQL query to find the following information:
For each country and indicator combination, determine the year in which the indicator value was lowest, along with the 
corresponding indicator value. Sort the output by country name and indicator name.
*/
WITH unp AS (
  SELECT country_name, indicator_name, 2010 AS yr, year_2010 AS val FROM module.country_data
  UNION ALL SELECT country_name, indicator_name, 2011, year_2011 FROM module.country_data
  UNION ALL SELECT country_name, indicator_name, 2012, year_2012 FROM module.country_data
  UNION ALL SELECT country_name, indicator_name, 2013, year_2013 FROM module.country_data
  UNION ALL SELECT country_name, indicator_name, 2014, year_2014 FROM module.country_data
),
r AS (
  SELECT
    country_name, indicator_name, yr, val,
    ROW_NUMBER() OVER (PARTITION BY country_name, indicator_name
                       ORDER BY val ASC, yr ASC) AS rn
  FROM unp
  WHERE val IS NOT NULL
)
SELECT
  country_name,
  indicator_name,
  yr  AS min_year,
  val AS min_value
FROM r
WHERE rn = 1
ORDER BY country_name, indicator_name;
