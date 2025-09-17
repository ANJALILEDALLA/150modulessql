DROP TABLE IF EXISTS module.employees;
CREATE TABLE module.employees (
  id INT,
  name VARCHAR(50),
  salary INT
);

DROP TABLE IF EXISTS module.projects;
CREATE TABLE module.projects (
  id INT,
  title VARCHAR(100),
  start_date DATE,
  end_date DATE,
  budget INT
);

DROP TABLE IF EXISTS module.project_employees;
CREATE TABLE module.project_employees (
  project_id INT,
  employee_id INT
);

INSERT INTO module.employees VALUES
(1,'Alice',100000),
(2,'Bob',120000),
(3,'Charlie',90000),
(4,'David',110000),
(5,'Eva',95000),
(6,'Frank',105000),
(7,'Grace',98000),
(8,'Helen',115000);

INSERT INTO module.projects VALUES
(1,'Website Redesign','2024-01-15','2024-07-15',50000),
(2,'App Development','2024-02-01','2024-05-31',100000),
(3,'Cloud Migration','2024-03-01','2024-04-30',20000),
(4,'Analytics Platform','2024-05-05','2024-08-05',80000);

INSERT INTO module.project_employees VALUES
(1,1),
(2,2),(2,3),(2,4),
(3,5),(3,6),(3,7),(3,8),
(4,6),(4,7);


/*125)You are tasked with managing project budgets at a company. Each project has a fixed budget, and multiple employees work 
on these projects. The company's payroll is based on annual salaries, and each employee works for a specific duration on a project.


Over budget on a project is defined when the salaries (allocated on per day basis as per project duration) exceed the budget of 
the project. For example, if Ankit and Rohit both combined income make 200K and work on a project of a budget of 50K that takes
 half a year, then the project is over budget given 0.5 * 200K = 100K > 50K.
Write a query to forecast the budget for all projects and return a label of "overbudget" if it is over budget and "within budget"
 otherwise. Order the result by project title.

Note: Assume that employees only work on one project at a time.
*/
WITH dur AS (
  SELECT id, title, budget, DATEDIFF(end_date, start_date) + 1 AS days
  FROM module.projects
),
tot AS (
  SELECT pe.project_id, SUM(e.salary) AS total_salary
  FROM module.project_employees pe
  JOIN module.employees e ON e.id = pe.employee_id
  GROUP BY pe.project_id
),
forecast AS (
  SELECT d.id, d.title, d.budget,
         ROUND((d.days / 365.0) * t.total_salary, 2) AS forecast_cost
  FROM dur d
  JOIN tot t ON t.project_id = d.id
)
SELECT
  title,
  budget,
  forecast_cost,
  CASE WHEN forecast_cost > budget THEN 'overbudget' ELSE 'within budget' END AS label
FROM forecast
ORDER BY title;
