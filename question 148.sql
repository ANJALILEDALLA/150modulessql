DROP TABLE IF EXISTS module.employees;

CREATE TABLE module.employees (
  employee_id INT,
  name        VARCHAR(50),
  manager_id  INT
);

INSERT INTO module.employees (employee_id, name, manager_id) VALUES
(1 , 'Alice'  , NULL),
(2 , 'Bob'    , 1),
(3 , 'Charlie', 10),
(4 , 'David'  , 2),
(5 , 'Eva'    , 12),
(6 , 'Frank'  , 3),
(7 , 'Grace'  , 2),
(8 , 'Hank'   , 1),
(9 , 'Ivy'    , 1),
(10, 'Jack'   , 4),
(11, 'Lily'   , 4),
(12, 'Megan'  , 15);

/*148)Each row represents an employee. The manager_id column references the employee_id of their manager.
 The top-level manager(s) (e.g., CEO) will have NULL as their manager_id.

Write a SQL query to find employees who do not manage any other employees, ordered in ascending order of employee id.  
*/
SELECT e.employee_id, e.name
FROM module.employees e
LEFT JOIN module.employees sub
  ON sub.manager_id = e.employee_id
WHERE sub.employee_id IS NULL
ORDER BY e.employee_id;
