DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    customer_name VARCHAR(20),
    order_date DATETIME,
    order_id INT PRIMARY KEY,
    order_value INT
);

INSERT INTO module.orders VALUES
('Rahul','2023-01-13 12:30:00',1,250),
('Rahul','2023-01-13 08:30:00',2,350),
('Mudit','2023-01-13 09:00:00',3,230),
('Rahul','2023-01-14 08:30:00',4,150),
('Suresh','2023-01-14 12:03:00',5,130),
('Mudit','2023-01-15 09:34:00',6,250),
('Mudit','2023-01-15 12:30:00',7,300),
('Rahul','2023-01-15 09:00:00',8,250),
('Rahul','2023-01-15 12:35:00',9,300),
('Suresh','2023-01-15 12:03:00',10,130);

/*45)Zomato is planning to offer a premium membership to customers who have placed multiple orders in a single day.

Your task is to write a SQL to find those customers who have placed multiple orders in a single day at least once ,
 total order value generate by those customers and order value generated only by those orders,
 display the results in ascending order of total order value.
*/

WITH per_day AS (
  SELECT customer_name,
         DATE(order_date) AS od,
         COUNT(*) AS cnt,
         SUM(order_value) AS day_value
  FROM module.orders
  GROUP BY customer_name, DATE(order_date)
),
qualified AS (
  SELECT DISTINCT customer_name
  FROM per_day
  WHERE cnt > 1
),
total_by_customer AS (
  SELECT customer_name, SUM(order_value) AS total_value
  FROM module.orders
  GROUP BY customer_name
),
multi_order_value AS (
  SELECT customer_name, SUM(day_value) AS multi_day_value
  FROM per_day
  WHERE cnt > 1
  GROUP BY customer_name
)
SELECT q.customer_name,
       t.total_value,
       m.multi_day_value
FROM qualified q
JOIN total_by_customer t USING (customer_name)
JOIN multi_order_value m USING (customer_name)
ORDER BY t.total_value ASC;
