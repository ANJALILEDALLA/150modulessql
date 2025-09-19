CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.employees;
CREATE TABLE module.employees (
  id INT,
  name VARCHAR(40),
  department VARCHAR(40),
  salary INT
);

INSERT INTO module.employees VALUES
(1 ,'Alice' , 'Marketing'  , 80000),
(2 ,'Bob'   , 'Marketing'  , 60000),
(3 ,'Charlie','Marketing'  , 80000),
(4 ,'David' , 'Marketing'  , 60000),
(5 ,'Eve'   , 'Engineering', 85000),
(6 ,'Frank' , 'Engineering', 95000),
(7 ,'Grace' , 'Engineering', 85000),
(8 ,'Hank'  , 'Engineering', 70000),
(9 ,'Ivy'   , 'HR'         , 50000),
(10,'Jack'  , 'Finance'    , 95000),
(11,'Kathy' , 'Finance'    , 95000),
(12,'Leo'   , 'Finance'    , 95000);

/*142)You are given an employees table containing information about employees' salaries across different departments. 
Your task is to calculate the difference between the highest and second-highest salaries for each department.
Conditions:
If a department has only one employee, return NULL for that department.
If all employees in a department have the same salary, return NULL for that department.

The final output should include Department Name and Salary Difference. Order by Department Name*/
WITH ranked AS (
  SELECT
    department,
    salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
  FROM module.employees
),
agg AS (
  SELECT
    department,
    MAX(CASE WHEN rnk = 1 THEN salary END) AS max_salary,
    MAX(CASE WHEN rnk = 2 THEN salary END) AS second_salary,
    COUNT(DISTINCT salary)                  AS distinct_salary_cnt
  FROM ranked
  GROUP BY department
)
SELECT
  department AS department_name,
  CASE WHEN distinct_salary_cnt >= 2
       THEN max_salary - second_salary
       ELSE NULL
  END AS salary_difference
FROM agg
ORDER BY department_name;
