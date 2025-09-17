DROP TABLE IF EXISTS module.salary;
DROP TABLE IF EXISTS module.employee;

CREATE TABLE module.employee (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(20),
  job_title VARCHAR(20)
);

CREATE TABLE module.salary (
  emp_id INT,
  base_pay INT,
  other_pay INT,
  overtime_pay INT,
  FOREIGN KEY (emp_id) REFERENCES module.employee(emp_id)
);

INSERT INTO module.employee (emp_id, emp_name, job_title) VALUES
(1,'John Doe','Software Engineer'),
(2,'Jane Smith','Software Engineer'),
(3,'Michael Johnson','Software Engineer'),
(4,'Emily Brown','Software Engineer'),
(5,'David Lee','Software Engineer'),
(6,'Sarah Jones','Software Engineer'),
(7,'Kevin Davis','Software Engineer'),
(8,'Emma Wilson','Software Engineer'),
(9,'Matthew Taylor','Software Engineer'),
(10,'Olivia Martinez','Software Engineer'),
(11,'Liam Miller','Data Scientist');

INSERT INTO module.salary (emp_id, base_pay, other_pay, overtime_pay) VALUES
(1,70000, 5000, 3000),
(2,72000, 4000, 2000),
(3,85000, 7000, 5000),
(4,68000, 3000, 2000),
(5,90000, 6000, 4000),
(6,62000, 2000, 1000),
(7,95000, 5000, 2000),
(8,88000, 4000, 1000),
(9,76000, 3000, 1500),
(10,70000, 2000, 2000),
(11,110000,10000,5000);


/*74)"You are working as a data analyst at a tech company called ""TechGuru Inc."" that specializes in software development 
and data science solutions. The HR department has tasked you with analyzing the salaries of employees. Your goal is 
to identify employees who earn above the average salary for their respective job title but are not among the top 3 
earners within their job title. Consider the sum of base_pay, overtime_pay and other_pay as total salary. In case multiple
 employees have same total salary then ranked them based on higher base pay. Sort the output by total salary in descending order.*/
WITH s AS (
  SELECT
    e.emp_id,
    e.emp_name,
    e.job_title,
    sa.base_pay,
    (sa.base_pay + sa.other_pay + sa.overtime_pay) AS total_salary
  FROM module.employee e
  JOIN module.salary sa ON sa.emp_id = e.emp_id
),
avg_title AS (
  SELECT job_title, AVG(total_salary) AS avg_total
  FROM s
  GROUP BY job_title
),
ranked AS (
  SELECT
    s.*,
    ROW_NUMBER() OVER (
      PARTITION BY s.job_title
      ORDER BY s.total_salary DESC, s.base_pay DESC
    ) AS rn
  FROM s
)
SELECT
  emp_id,
  emp_name,
  job_title,
  total_salary,
  base_pay
FROM ranked r
JOIN avg_title a
  ON a.job_title = r.job_title
WHERE r.total_salary > a.avg_total   
  AND r.rn > 3                      
ORDER BY total_salary DESC, base_pay DESC, emp_name;
