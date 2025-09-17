CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.covid_tests;
CREATE TABLE module.covid_tests (
  name VARCHAR(10),
  id INT,
  age INT,
  corad_score INT
);

INSERT INTO module.covid_tests VALUES
('Aarav',1,25,-1),
('Vivaan',2,30,3),
('Aditya',3,42,6),
('Vihaan',4,21,-1),
('Arjun',5,38,5),
('Kabir',6,48,7),
('Rohan',7,29,-1),
('Sai',8,56,9),
('Krishna',9,33,4),
('Siddharth',10,44,2),
('Isha',11,24,-1),
('Nisha',12,37,5);


/*119)"You have a table named covid_tests with the following columns: name, id, age, and corad score. 
The corad score values are categorized as follows: -1 indicates a negative result. Scores from 2 to 5 indicate a mild condition. 
Scores from 6 to 10 indicate a serious condition. Write a query to produce an output with the following columns: 
age_group: Groups of ages (18-30, 31-45, 46-60). count_negative: The number of people with a negative result in each age group.
 count_mild: The number of people with a mild condition in each age group.
 count_serious: The number of people with a serious condition in each age group.*/
SELECT
  CASE
    WHEN age BETWEEN 18 AND 30 THEN '18-30'
    WHEN age BETWEEN 31 AND 45 THEN '31-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
  END AS age_group,
  SUM(CASE WHEN corad_score = -1 THEN 1 ELSE 0 END) AS count_negative,
  SUM(CASE WHEN corad_score BETWEEN 2 AND 5 THEN 1 ELSE 0 END) AS count_mild,
  SUM(CASE WHEN corad_score BETWEEN 6 AND 10 THEN 1 ELSE 0 END) AS count_serious
FROM module.covid_tests
GROUP BY age_group
ORDER BY CASE age_group WHEN '18-30' THEN 1 WHEN '31-45' THEN 2 WHEN '46-60' THEN 3 END;
