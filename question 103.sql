 CREATE TABLE module.employees (
    id INT PRIMARY KEY,
    name VARCHAR(10),
    mentor_id INT
);

INSERT INTO module.employees (id, name, mentor_id) VALUES
(1, 'Arjun', NULL),
(2, 'Sneha', 1),
(3, 'Vikram', NULL),
(4, 'Rahul', 3),
(5, 'Priya', 2),
(6, 'Neha', 3),
(7, 'Rohan', 1),
(8, 'Amit', 4);

/*103)"You are given a table Employees that contains information about employees in a company.
 Each employee might have been mentored by another employee.
 Your task is to find the names of all employees who were not mentored by the employee with id = 3.*/
 
 SELECT id,name 
 FROM module.employees
 WHERE mentor_id != 3 OR  mentor_id IS null;
 