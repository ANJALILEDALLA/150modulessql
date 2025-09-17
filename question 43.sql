DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    order_id INT,
    customer_id INT,
    order_date DATE
);

INSERT INTO module.orders VALUES
(1,101,'2023-12-01'),
(2,102,'2023-12-02'),
(3,103,'2023-12-13'),
(4,104,'2024-01-05'),
(5,101,'2024-01-06'),
(6,102,'2024-01-08'),
(7,101,'2024-01-10'),
(8,104,'2024-02-15'),
(9,105,'2024-02-20'),
(10,102,'2024-02-25');

/*43)Customer retention can be defined as number of customers who continue to make purchases over a certain period compared to the total number of customers. Here's a step-by-step approach to calculate customer retention rate:

1- Determine the number of customers who made purchases 
in the current period (e.g., month: m )
2- Identify the number of customers from month m who made purchases 
in month m+1 , m+2 as well.
Suppose you are a data analyst working for Amazon. The company is interested in measuring customer retention over the months to understand how many customers continue to make purchases over time. Your task is to write an SQL to derive customer retention month over month, display the output in ascending order of current year, month & future year, month.
*/

WITH monthly_customers AS (
  SELECT YEAR(order_date) AS yr,
         MONTH(order_date) AS mn,
         customer_id
  FROM module.orders
  GROUP BY YEAR(order_date), MONTH(order_date), customer_id
),
pairs AS (
  SELECT c1.yr AS curr_year,
         c1.mn AS curr_month,
         c2.yr AS future_year,
         c2.mn AS future_month,
         c1.customer_id
  FROM monthly_customers c1
  JOIN monthly_customers c2
    ON c2.customer_id = c1.customer_id
   AND (c2.yr*12 + c2.mn) - (c1.yr*12 + c1.mn) IN (1,2)
),
curr_counts AS (
  SELECT yr, mn, COUNT(DISTINCT customer_id) AS current_customers
  FROM monthly_customers
  GROUP BY yr, mn
)
SELECT
  p.curr_year,
  p.curr_month,
  p.future_year,
  p.future_month,
  COUNT(DISTINCT p.customer_id) AS retained_customers,
  c.current_customers,
  ROUND(COUNT(DISTINCT p.customer_id) / c.current_customers * 100, 2) AS retention_rate_pct
FROM pairs p
JOIN curr_counts c
  ON c.yr = p.curr_year AND c.mn = p.curr_month
GROUP BY p.curr_year, p.curr_month, p.future_year, p.future_month, c.current_customers
ORDER BY p.curr_year, p.curr_month, p.future_year, p.future_month;
