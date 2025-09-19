CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.sales;
CREATE TABLE module.sales (
  id INT,
  product_id INT,
  sale_date DATE,
  sale_amount INT
);

INSERT INTO module.sales VALUES
(1,101,'2025-03-05',500),
(2,101,'2025-03-15',550),
(3,101,'2025-03-25',600),
(4,101,'2025-04-14',400),
(5,101,'2025-05-04',300),
(6,101,'2025-05-14',900),
(7,101,'2025-06-03',750),
(8,101,'2025-06-29',760),
(9,102,'2025-06-03',1000),
(10,102,'2025-06-08',1100),
(11,102,'2025-03-15',950),
(12,102,'2025-03-15',850);

/*139)Given a sales dataset that records daily transactions for various products, write an SQL query to calculate last quarter's 
total sales and quarter-to-date (QTD) 
sales for each product, helping analyze past performance and current trends.*/
WITH p AS (
  SELECT
    UTC_DATE() AS today,
    DATE_ADD(DATE_FORMAT(UTC_DATE(), '%Y-01-01'),
             INTERVAL (QUARTER(UTC_DATE())-1)*3 MONTH) AS curr_q_start
)
SELECT
  s.product_id,
  SUM(CASE
        WHEN s.sale_date BETWEEN DATE_SUB(p.curr_q_start, INTERVAL 3 MONTH)
                              AND DATE_SUB(p.curr_q_start, INTERVAL 1 DAY)
        THEN s.sale_amount ELSE 0
      END) AS last_quarter_sales,
  SUM(CASE
        WHEN s.sale_date BETWEEN p.curr_q_start AND p.today
        THEN s.sale_amount ELSE 0
      END) AS qtd_sales
FROM module.sales s
CROSS JOIN p
GROUP BY s.product_id
ORDER BY s.product_id;
