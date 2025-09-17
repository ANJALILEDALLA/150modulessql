DROP TABLE IF EXISTS module.employees;
DROP TABLE IF EXISTS module.departments;

CREATE TABLE module.departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(10)
);

CREATE TABLE module.employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(20),
  salary INT,
  department_id INT,
  FOREIGN KEY (department_id) REFERENCES module.departments(department_id)
);

INSERT INTO module.departments (department_id, department_name) VALUES
(1,'HR'),
(2,'Engineering'),
(3,'Marketing');

INSERT INTO module.employees (employee_id, employee_name, salary, department_id) VALUES
(1,'John Doe',50000,1),
(2,'Jane Smith',60000,1),
(3,'Alice Johnson',70000,2),
(4,'Bob Brown',55000,2),
(5,'Emily Clark',48000,1),
(6,'Michael Lee',62000,1),
(7,'Sarah Taylor',53000,3),
(8,'David Martinez',58000,1),
(9,'Laura White',65000,1),
(10,'Chris Wilson',56000,3);


/*71)You are provided with two tables: Employees and Departments. The Employees table contains information about employees, 
including their IDs, names, salaries, and department IDs. The Departments table contains information about departments,
 including their IDs and names. Your task is to write a SQL query to find the average salary of employees in each department,
 but only include departments that have more than 2 employees .
 Display department name and average salary round to 2 decimal places. Sort the result by average salary in descending order.*/
SELECT
  d.department_name,
  ROUND(AVG(e.salary), 2) AS average_salary
FROM module.employees e
JOIN module.departments d
  ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) > 2
ORDER BY average_salary DESC;
