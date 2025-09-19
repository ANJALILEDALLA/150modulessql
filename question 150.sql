DROP TABLE IF EXISTS module.promotions;
DROP TABLE IF EXISTS module.employees;

CREATE TABLE module.employees (
  id             INT,
  name           VARCHAR(50),
  joining_salary INT
);

INSERT INTO module.employees (id, name, joining_salary) VALUES
(1,'Alice' ,50000),
(2,'Bob'   ,60000),
(3,'Charlie',70000),
(4,'David' ,55000),
(5,'Eva'   ,65000),
(6,'Frank' ,48000),
(7,'Grace' ,72000),
(8,'Henry' ,51000);

CREATE TABLE module.promotions (
  emp_id           INT,
  promotion_date   DATE,
  percent_increase INT
);

INSERT INTO module.promotions (emp_id, promotion_date, percent_increase) VALUES
(1,'2021-01-15',10),
(1,'2022-03-20',20),
(2,'2023-01-01',5),
(2,'2024-01-01',10),
(3,'2022-05-10',5),
(3,'2023-07-01',10),
(3,'2024-10-10',5),
(4,'2021-02-21',15),
(4,'2022-01-25',15),
(4,'2023-09-01',25),
(4,'2024-09-30',15);


/*150)"In your organization, each employee has a fixed joining salary recorded at the time they start. 
Over time, employees may receive one or more promotions, each offering a certain percentage increase to their current salary. 
You're given two datasets: employees : contains each employee’s name and joining salary. promotions: lists all promotions that
 have occurred, including the promotion date and the percent increase granted during that promotion. 
 Your task is to write a SQL query to compute the current salary of every employee by applying each of their promotions 
 increase round to 2 decimal places. If an employee has no promotions,
 their current salary remains equal to the joining salary. Order the result by emp id.*/
SELECT
  e.id,
  e.name,
  ROUND(
    e.joining_salary *
    COALESCE(EXP(SUM(LN(1 + p.percent_increase/100.0))), 1),
    2
  ) AS current_salary
FROM module.employees e
LEFT JOIN module.promotions p
  ON p.emp_id = e.id
GROUP BY e.id, e.name, e.joining_salary
ORDER BY e.id;

