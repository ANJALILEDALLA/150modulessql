DROP TABLE IF EXISTS module.promotions;
DROP TABLE IF EXISTS module.employees;

CREATE TABLE module.employees (
  id   INT,
  name VARCHAR(50)
);

INSERT INTO module.employees (id, name) VALUES
(1,'Alice'),
(2,'Bob'),
(3,'Charlie'),
(4,'David'),
(5,'Eva'),
(6,'Frank'),
(7,'Grace'),
(8,'Hank'),
(9,'Ivy'),
(10,'Jack'),
(11,'Lily'),
(12,'Megan');

CREATE TABLE module.promotions (
  emp_id         INT,
  promotion_date DATE
);

INSERT INTO module.promotions (emp_id, promotion_date) VALUES
(1,'2025-04-13'),
(2,'2025-01-13'),
(3,'2024-07-13'),
(4,'2023-12-13'),
(5,'2023-12-13'),
(6,'2023-06-13'),
(6,'2024-12-13'),
(7,'2023-08-13'),
(7,'2022-12-13'),
(8,'2022-12-13'),
(9,'2024-04-13');

/*149)The promotions table records all historical promotions of employees (an employee can appear multiple times).
Write a query to find all employees who were not promoted in the last 1 year from today. Display id , name and latest
 promotion date for those employees order by id.*/


SELECT
  e.id,
  e.name,
  lp.last_promotion_date
FROM module.employees e
LEFT JOIN (
  SELECT emp_id, MAX(promotion_date) AS last_promotion_date
  FROM module.promotions
  GROUP BY emp_id
) lp
  ON lp.emp_id = e.id
WHERE lp.last_promotion_date IS NULL
   OR lp.last_promotion_date < (CURRENT_DATE - INTERVAL 1 YEAR)
ORDER BY e.id;
