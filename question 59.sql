DROP TABLE IF EXISTS module.holidays;
DROP TABLE IF EXISTS module.orders;

CREATE TABLE module.orders (
  order_id INT PRIMARY KEY,
  order_date DATE,
  ship_date DATE
);

CREATE TABLE module.holidays (
  holiday_id INT PRIMARY KEY,
  holiday_date DATE
);

INSERT INTO module.orders (order_id, order_date, ship_date) VALUES
(1,'2024-03-14','2024-03-20'),
(2,'2024-03-10','2024-03-16'),
(3,'2024-03-04','2024-03-12'),
(4,'2024-03-05','2024-03-07'),
(5,'2024-03-03','2024-03-08'),
(6,'2024-03-07','2024-03-24');

INSERT INTO module.holidays (holiday_id, holiday_date) VALUES
(1,'2024-03-10'),
(2,'2024-03-18'),
(3,'2024-03-21');

/*59You are given orders data of an online ecommerce company. Dataset contains order_id , order_date and ship_date. 
Your task is to find lead time in days between order date and ship date using below rules:
1- Exclude holidays. List of holidays present in holiday table. 
2- If the order date is on weekends, then consider it as order placed on immediate next Monday 
and if the ship date is on weekends, then consider it as immediate previous Friday to do calculations.
For example, if order date is March 14th 2024 and ship date is March 20th 2024. Consider March 18th is a holiday then 
lead time will be (20-14) -1 holiday = 5 days.
*/

WITH adjusted AS (
  SELECT
    o.order_id,
    CASE DAYOFWEEK(o.order_date)
      WHEN 7 THEN DATE_ADD(o.order_date, INTERVAL 2 DAY)
      WHEN 1 THEN DATE_ADD(o.order_date, INTERVAL 1 DAY)
      ELSE o.order_date
    END AS adj_order_date,
    CASE DAYOFWEEK(o.ship_date)
      WHEN 7 THEN DATE_ADD(o.ship_date, INTERVAL -1 DAY)
      WHEN 1 THEN DATE_ADD(o.ship_date, INTERVAL -2 DAY)
      ELSE o.ship_date
    END AS adj_ship_date
  FROM module.orders o
),
hol_ct AS (
  SELECT a.order_id,
         a.adj_order_date,
         a.adj_ship_date,
         COUNT(h.holiday_date) AS hol_between
  FROM adjusted a
  LEFT JOIN module.holidays h
    ON h.holiday_date BETWEEN a.adj_order_date AND a.adj_ship_date
  GROUP BY a.order_id, a.adj_order_date, a.adj_ship_date
)
SELECT
  order_id,
  DATEDIFF(adj_ship_date, adj_order_date) - hol_between AS lead_time_days
FROM hol_ct
ORDER BY order_id;
