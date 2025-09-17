DROP TABLE IF EXISTS module.employee_record;
CREATE TABLE module.employee_record (
  emp_id INT,
  action VARCHAR(3),
  created_at DATETIME
);

INSERT INTO module.employee_record VALUES
(1,'in','2019-04-01 12:00:00'),
(1,'out','2019-04-01 15:00:00'),
(1,'in','2019-04-01 17:00:00'),
(1,'out','2019-04-01 21:00:00'),
(2,'in','2019-04-01 10:00:00'),
(2,'out','2019-04-01 16:00:00'),
(2,'in','2019-04-01 19:00:00'),
(2,'out','2019-04-02 05:00:00'),
(3,'in','2019-04-01 10:00:00'),
(3,'out','2019-04-01 20:00:00');

/*46)A company record its employee's movement In and Out of office in a table. Please note below points about the data:

1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at “2019-04-01 19:05:00".
*/

SELECT COUNT(*) AS employees_inside
FROM (
  SELECT emp_id, MAX(created_at) AS last_time
  FROM module.employee_record
  WHERE created_at <= '2019-04-01 19:05:00'
  GROUP BY emp_id
) t
JOIN module.employee_record e
  ON e.emp_id = t.emp_id
 AND e.created_at = t.last_time
WHERE e.action = 'in';
