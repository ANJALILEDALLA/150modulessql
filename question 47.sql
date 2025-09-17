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
(3,'in','2019-04-01 19:00:00'),
(3,'out','2019-04-02 05:00:00'),
(4,'in','2019-04-01 10:00:00'),
(4,'out','2019-04-01 20:00:00');

/*47)A company record its employee's movement In and Out of office in a table. Please note below points about the data:

1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write an SQL to measure the time spent by each employee inside the office between “2019-04-01 14:00:00” and “2019-04-02 10:00:00" in minutes, display the output in ascending order of employee id .
*/

WITH paired AS (
  SELECT
    emp_id,
    created_at AS in_time,
    LEAD(created_at) OVER (PARTITION BY emp_id ORDER BY created_at) AS out_time
  FROM module.employee_record
  WHERE action = 'in'
),
clipped AS (
  SELECT
    emp_id,
    GREATEST(in_time,  '2019-04-01 14:00:00') AS start_t,
    LEAST(out_time,    '2019-04-02 10:00:00') AS end_t
  FROM paired
)
SELECT
  emp_id,
  SUM(CASE WHEN end_t > start_t THEN TIMESTAMPDIFF(MINUTE, start_t, end_t) ELSE 0 END) AS minutes_inside
FROM clipped
GROUP BY emp_id
ORDER BY emp_id;
