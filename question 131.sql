DROP TABLE IF EXISTS module.employees;
CREATE TABLE module.employees (
  emp_id INT,
  year INT,
  designation VARCHAR(20)
);

INSERT INTO module.employees VALUES
(1,2020,'Trainee'),
(2,2020,'Developer'),
(3,2020,'Developer'),
(4,2020,'Manager'),
(5,2020,'Trainee'),
(6,2020,'Developer'),
(1,2021,'Developer'),
(2,2021,'Developer'),
(3,2021,'Manager'),
(5,2021,'Trainee'),
(6,2021,'Developer'),
(7,2021,'Manager');

/*131)You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year.
 The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.
The company's HR system has two separate records of employees for the years 2020 and 2021 in the same table, which include each 
employee's unique identifier (emp_id) and their corresponding designation (role) within the organization for each year.
The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify
 the following changes:

Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.
Assume that employees can only be promoted and cannot be demoted.
*/
WITH by_year AS (
  SELECT
    emp_id,
    MAX(CASE WHEN year = 2020 THEN designation END) AS desig_2020,
    MAX(CASE WHEN year = 2021 THEN designation END) AS desig_2021
  FROM module.employees
  GROUP BY emp_id
)
SELECT
  emp_id,
  desig_2020,
  desig_2021,
  CASE
    WHEN desig_2020 IS NOT NULL AND desig_2021 IS NULL THEN 'Resigned'
    WHEN desig_2020 IS NULL     AND desig_2021 IS NOT NULL THEN 'New Hire'
    WHEN desig_2020 <> desig_2021 THEN 'Promoted'
  END AS change_type
FROM by_year
WHERE (desig_2020 IS NOT NULL AND desig_2021 IS NULL)
   OR (desig_2020 IS NULL     AND desig_2021 IS NOT NULL)
   OR (desig_2020 <> desig_2021)
ORDER BY emp_id;
