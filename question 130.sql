DROP TABLE IF EXISTS module.emp_2020;
CREATE TABLE module.emp_2020 (
  emp_id INT,
  designation VARCHAR(20)
);

DROP TABLE IF EXISTS module.emp_2021;
CREATE TABLE module.emp_2021 (
  emp_id INT,
  designation VARCHAR(20)
);

INSERT INTO module.emp_2020 VALUES
(1,'Trainee'),
(2,'Developer'),
(3,'Developer'),
(4,'Manager'),
(5,'Trainee'),
(6,'Developer');

INSERT INTO module.emp_2021 VALUES
(1,'Developer'),
(2,'Developer'),
(3,'Manager'),
(5,'Trainee'),
(6,'Developer'),
(7,'Manager');

/*130)"You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year.
 The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.
 The company's HR system has two separate tables of employees for the years 2020 and 2021, which include each employee's unique
 identifier (emp_id) and their corresponding designation (role) within the organization. The task is to track how the
 designations of employees have changed over the year. Specifically, you are required to identify the following changes:
 Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
 Resigned: If an employee was present in 2020 but has left the company by 2021.
 New Hire: If an employee was hired in 2021 but was not present in 2020.
 Assume that employees can only be promoted and cannot be demoted.*/
WITH joined AS (
  SELECT e20.emp_id        AS emp_2020_id,
         e20.designation   AS desig_2020,
         e21.emp_id        AS emp_2021_id,
         e21.designation   AS desig_2021
  FROM module.emp_2020 e20
  LEFT JOIN module.emp_2021 e21 ON e21.emp_id = e20.emp_id
  UNION ALL
  SELECT NULL, NULL, e21.emp_id, e21.designation
  FROM module.emp_2021 e21
  LEFT JOIN module.emp_2020 e20 ON e20.emp_id = e21.emp_id
  WHERE e20.emp_id IS NULL
)
SELECT
  COALESCE(emp_2020_id, emp_2021_id) AS emp_id,
  desig_2020,
  desig_2021,
  CASE
    WHEN emp_2020_id IS NOT NULL AND emp_2021_id IS NULL THEN 'Resigned'
    WHEN emp_2020_id IS NULL     AND emp_2021_id IS NOT NULL THEN 'New Hire'
    WHEN desig_2020 IS NOT NULL  AND desig_2021 IS NOT NULL AND desig_2020 <> desig_2021 THEN 'Promoted'
  END AS change_type
FROM joined
WHERE
    (emp_2020_id IS NOT NULL AND emp_2021_id IS NULL)     
 OR (emp_2020_id IS NULL AND emp_2021_id IS NOT NULL)  
 OR (desig_2020 <> desig_2021)                           
ORDER BY emp_id;
