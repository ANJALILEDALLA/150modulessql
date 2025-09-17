DROP TABLE IF EXISTS module.employees;
CREATE TABLE module.employees(
  employee_id INT,
  name VARCHAR(20),
  leave_balance_from_2023 INT
);

DROP TABLE IF EXISTS module.leave_requests;
CREATE TABLE module.leave_requests(
  request_id INT,
  employee_id INT,
  leave_start_date DATE,
  leave_end_date DATE
);

INSERT INTO module.employees VALUES
(1,'John Doe',5),
(2,'Jane Smith',6),
(3,'Alice Johnson',4);

INSERT INTO module.leave_requests VALUES
(1,1,'2024-01-05','2024-01-15'),
(2,1,'2024-01-21','2024-01-27'),
(3,1,'2024-02-12','2024-02-17'),
(4,1,'2024-07-03','2024-07-12'),
(5,2,'2024-01-20','2024-01-25'),
(6,2,'2024-03-20','2024-03-30'),
(7,3,'2024-10-05','2024-10-12');

/*87)"You are tasked with writing an SQL query to determine whether a leave request can be approved for each employee based 
on their available leave balance for 2024. Employees receive 1.5 leaves at the start of each month, 
and they may have some balance leaves carried over from the previous year 2023(available in employees table).
 A leave request can only be approved if the employee has a sufficient leave balance at the start date of 
 planned leave period. Write an SQL to derive a new status column stating if leave request is Approved or Rejected
 for each leave request. Sort the output by request id. Consider the following assumptions: 1- If a leave request is
 eligible for approval, then it will always be taken by employee and leave balance will be deducted as per the leave period. 
 If the leave is rejected then the balance will not be deducted. 2- A leave will either be fully approved or cancelled.
 No partial approvals possible. 3- If a weekend is falling between the leave start and 
end date then do consider them when calculating the leave days, Meaning no exclusion of weekends.*/

WITH req AS (
  SELECT
    lr.request_id,
    lr.employee_id,
    lr.leave_start_date,
    lr.leave_end_date,
    DATEDIFF(lr.leave_end_date, lr.leave_start_date) + 1 AS leave_days,
    e.leave_balance_from_2023 + 1.5 * MONTH(lr.leave_start_date) AS start_balance,
    ROW_NUMBER() OVER (PARTITION BY lr.employee_id ORDER BY lr.leave_start_date, lr.request_id) AS rn
  FROM module.leave_requests lr
  JOIN module.employees e ON e.employee_id = lr.employee_id
),
rec AS (
  SELECT employee_id, request_id, rn, start_balance, leave_days, 0 AS used_before
  FROM req
  WHERE rn = 1
  UNION ALL
  SELECT n.employee_id, n.request_id, n.rn, n.start_balance, n.leave_days,
         r.used_before + CASE WHEN (r.start_balance - r.used_before) >= r.leave_days THEN r.leave_days ELSE 0 END
  FROM req n
  JOIN rec r ON n.employee_id = r.employee_id AND n.rn = r.rn + 1
)
SELECT
  request_id,
  employee_id,
  CASE WHEN (start_balance - used_before) >= leave_days THEN 'Approved' ELSE 'Rejected' END AS status
FROM rec
ORDER BY request_id;
