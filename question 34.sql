DROP TABLE IF EXISTS module.employee; 
 CREATE TABLE module.employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(10),
    joining_date DATE,
    salary INT,
    manager_id INT
);

 
 INSERT INTO module.employee (emp_id, emp_name, joining_date, salary, manager_id) VALUES
(1, 'Alice', '2015-01-10', 80000, NULL),   -- Top manager, no manager
(2, 'Bob', '2016-03-15', 60000, 1),        -- Managed by Alice
(3, 'Charlie', '2017-07-20', 70000, 1),    -- Managed by Alice
(4, 'David', '2018-06-01', 75000, 2),      -- Managed by Bob
(5, 'Eve', '2019-05-12', 65000, 2),        -- Managed by Bob
(6, 'Frank', '2020-09-10', 80000, 3),      -- Managed by Charlie
(7, 'Grace', '2021-01-25', 50000, 4);      -- Managed by David

/*34)You are given the table of employee details. Write an SQL to find details of employee with salary more than their manager salary
 but they joined the company after the manager joined. Display employee name, salary and joining date along with their manager's 
 salary and joining date, sort the output in ascending order of employee name. 
Please note that manager id in the employee table referring to emp id of the same table.*/
 
 SELECT e.emp_name,e.salary,e.joining_date,m.salary,m.joining_date
 FROM module.employee e
 JOIN module.employee m
 ON e.manager_id=m.emp_id
 WHERE e.salary> m.salary
 AND e.joining_date > m.joining_date
ORDER BY e.emp_name ASC;
