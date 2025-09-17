CREATE TABLE module.employee (
    emp_id INT PRIMARY KEY,
    salary INT,
    department VARCHAR(15)
);


INSERT INTO module.employee (emp_id, salary, department) VALUES
(100, 40000, 'Analytics'),
(101, 30000, 'Analytics'),
(102, 50000, 'Analytics'),
(103, 45000, 'Engineering'),
(104, 48000, 'Engineering'),
(105, 51000, 'Engineering'),
(106, 46000, 'Science'),
(107, 38000, 'Science'),
(108, 37000, 'Science'),
(109, 42000, 'Analytics'),
(110, 55000, 'Engineering');

/*31)You are given the data of employees along with their salary and department. Write an SQL to find list of employees who have salary
 greater than average employee salary of the company. However, while calculating the company average salary to compare 
with an employee salary do not consider salaries of that employee's department, 
display the output in ascending order of employee ids.*/


SELECT e1.emp_id, e1.salary, e1.department
FROM module.employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM module.employee e2
    WHERE e2.department <> e1.department
)
ORDER BY e1.emp_id ASC;