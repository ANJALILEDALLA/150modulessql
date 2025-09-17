DROP TABLE IF EXISTS module.daily_time;
DROP TABLE IF EXISTS module.employees;
DROP TABLE IF EXISTS module.dept;

CREATE TABLE module.employees(
  emp_id   INT,
  emp_name VARCHAR(20),
  dept_id  INT
);

CREATE TABLE module.dept(
  dept_id     INT,
  hourly_rate INT
);

CREATE TABLE module.daily_time(
  emp_id     INT,
  entry_time DATETIME,
  exit_time  DATETIME
);

INSERT INTO module.employees VALUES
(1,'John',1),
(2,'Jane',2),
(3,'Max',1),
(4,'Sara',2),
(5,'Paul',3);

INSERT INTO module.dept VALUES
(1,10),
(2,12),
(3,15);

INSERT INTO module.daily_time VALUES
(1,'2023-01-01 09:00:00','2023-01-01 17:00:00'),
(2,'2023-01-01 08:00:00','2023-01-01 15:00:00'),
(3,'2023-01-01 08:30:00','2023-01-01 18:30:00'),
(4,'2023-01-01 09:00:00','2023-01-01 16:00:00'),
(5,'2023-01-01 08:00:00','2023-01-01 18:00:00');

/*54)"An IT company pays its employees on hourly basis. You are given the database of employees along with their department id.
  Department table which consist of hourly rate for each department. 
  Given the daily entry_time and exit_time of each employee, calculate the total amount payable to each employee.
  Please note that company also pays overtime to employees who work for more than 8 hours a day which is 1.5 times of hourly rate.
  So for example if hourly rate is 10 and a employee works for 9 hours then total payable will be 10*8+15*1 = 95 for that day.
  In this example 95 is total payout and 15 is overtime payout. 
Round the result to 2 decimal places and sort the output by decreasing order of total payout.*/

WITH work AS (
  SELECT
      e.emp_id,
      e.emp_name,
      d.hourly_rate,
      TIMESTAMPDIFF(MINUTE, dt.entry_time, dt.exit_time)/60.0 AS hours_worked
  FROM module.daily_time dt
  JOIN module.employees e ON e.emp_id = dt.emp_id
  JOIN module.dept d ON d.dept_id = e.dept_id
),
calc AS (
  SELECT
      emp_id,
      emp_name,
      hourly_rate,
      CASE WHEN hours_worked > 8 THEN 8 ELSE hours_worked END AS reg_hours,
      CASE WHEN hours_worked > 8 THEN (hours_worked - 8) ELSE 0 END AS ot_hours
  FROM work
)
SELECT
    emp_id,
    emp_name,
    ROUND(hourly_rate * (reg_hours + 1.5*ot_hours), 2) AS total_payout,
    ROUND(hourly_rate * 1.5 * ot_hours, 2)          AS overtime_payout
FROM calc
ORDER BY total_payout DESC;
