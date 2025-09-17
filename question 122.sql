DROP TABLE IF EXISTS module.employees;
CREATE TABLE module.employees (
  employee_id INT,
  department_id INT,
  salary INT
);

INSERT INTO module.employees VALUES
(1,1,5000),
(2,1,4000),
(3,1,1000),
(4,2,3500),
(5,3,1500),
(6,3,4000),
(7,3,3000),
(8,3,2000),
(9,4,5000),
(10,4,1600),
(11,5,1000),
(12,5,4200);

/*122)You are working with an employee database where each employee has a department id and a salary.
 Your task is to find the third highest salary in each department. If there is no third highest salary in a department, 
 then the query should return salary as null for that department. Sort the output by department id.

Assume that none of the employees have same salary in a particular department.
*/

WITH r AS (
  SELECT
    department_id,
    salary,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
  FROM module.employees
),
depts AS (
  SELECT DISTINCT department_id FROM module.employees
)
SELECT
  d.department_id,
  MAX(CASE WHEN r.rnk = 3 THEN r.salary END) AS third_highest_salary
FROM depts d
LEFT JOIN r ON r.department_id = d.department_id
GROUP BY d.department_id
ORDER BY d.department_id;
