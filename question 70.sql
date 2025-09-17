CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.employee;

CREATE TABLE module.employee (
  employeeid INT,
  fullname VARCHAR(20)
);

INSERT INTO module.employee (employeeid, fullname) VALUES
(1,'Doe,John Michael'),
(2,'Smith,Alice'),
(3,'Johnson,Robert Lee'),
(4,'Alex'),
(5,'White,Sarah');

/*70)The HR department needs to extract the first name, middle name and last name of each employee from the full name column. However, the full name column contains names in the format "Lastname,Firstname Middlename". 
Please consider that an employee name can be in one of the 3 following formats.
1- "Lastname,Firstname Middlename"
2- "Lastname,Firstname"
3- "Firstname"
*/

SELECT
  employeeid,
  CASE
    WHEN INSTR(fullname, ',') > 0
      THEN SUBSTRING_INDEX(TRIM(SUBSTRING_INDEX(fullname, ',', -1)), ' ', 1)
    ELSE SUBSTRING_INDEX(fullname, ' ', 1)
  END AS first_name,
  CASE
    WHEN INSTR(fullname, ',') > 0
         AND TRIM(SUBSTRING_INDEX(fullname, ',', -1)) LIKE '% %'
      THEN SUBSTRING_INDEX(TRIM(SUBSTRING_INDEX(fullname, ',', -1)), ' ', -1)
    ELSE NULL
  END AS middle_name,
  CASE
    WHEN INSTR(fullname, ',') > 0
      THEN TRIM(SUBSTRING_INDEX(fullname, ',', 1))
    ELSE NULL
  END AS last_name
FROM module.employee
ORDER BY employeeid;
