DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    order_id INT,
    customer_id INT,
    order_amount DECIMAL(10,2),
    order_date DATE
);

INSERT INTO module.orders VALUES
(1,101,100,'2023-01-01'),
(2,101,200,'2023-01-05'),
(3,101, 80,'2023-01-06'),
(4,101,110,'2023-01-07'),
(5,101, 90,'2023-01-08'),
(6,101,130,'2023-01-14'),
(7,101,150,'2023-01-15'),
(8,101,120,'2023-01-21'),
(9,101,120,'2023-01-23'),
(10,101, 90,'2023-01-28'),
(11,102,110,'2023-01-29');

/*41)"Suppose you are a data analyst working for Zomato (a online food delivery company) . 
Zomato is interested in analysing customer food ordering behavior and wants to identify customers
 who have exhibited inconsistent patterns over time. Your task is to write an SQL query to identify customers 
 who have placed orders on both weekdays and weekends, but with a significant difference in the average order
 amount between weekdays and weekends. Specifically, you need to identify customers who have a minimum of 3 orders 
 placed both on weekdays and weekends each, and where the average order amount on weekends is at least 20% higher 
 than the average order amount on weekdays. Your query should return the customer id, the average order amount on weekends, 
 the average order amount on weekdays,
 and the percentage difference in average order amount between weekends and weekdays for each customer meeting the criteria.*/

WITH labeled AS (
  SELECT
    customer_id,
    CASE WHEN WEEKDAY(order_date) IN (5,6) THEN 'weekend' ELSE 'weekday' END AS dow,
    order_amount
  FROM module.orders
),
agg AS (
  SELECT
    customer_id,
    AVG(CASE WHEN dow='weekend' THEN order_amount END) AS avg_weekend,
    AVG(CASE WHEN dow='weekday' THEN order_amount END) AS avg_weekday,
    SUM(CASE WHEN dow='weekend' THEN 1 ELSE 0 END) AS cnt_weekend,
    SUM(CASE WHEN dow='weekday' THEN 1 ELSE 0 END) AS cnt_weekday
  FROM labeled
  GROUP BY customer_id
)
SELECT
  customer_id,
  ROUND(avg_weekend,2) AS avg_weekend,
  ROUND(avg_weekday,2) AS avg_weekday,
  ROUND((avg_weekend - avg_weekday)/avg_weekday*100,2) AS pct_diff
FROM agg
WHERE cnt_weekend >= 3
  AND cnt_weekday >= 3
  AND avg_weekend >= 1.20 * avg_weekday;
