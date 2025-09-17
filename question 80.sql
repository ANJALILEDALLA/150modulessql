DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  order_id INT,
  order_date DATE,
  product_id VARCHAR(5),
  amount INT
);

INSERT INTO module.orders (order_id,order_date,product_id,amount) VALUES
(1,'2024-01-01','1',100),
(2,'2024-01-02','6',150),
(3,'2024-01-03','11',120),
(4,'2024-01-04','4',200),
(5,'2024-01-05','7',180),
(6,'2024-01-06','1',110),
(7,'2024-01-07','8',220),
(8,'2024-01-08','12',130),
(9,'2024-01-09','3',190),
(10,'2024-01-10','9',240),
(11,'2024-01-11','2',140);

DROP TABLE IF EXISTS module.calendar_dim;
CREATE TABLE module.calendar_dim (cal_date DATE);

INSERT INTO module.calendar_dim (cal_date)
SELECT DATE('2024-01-01') + INTERVAL n DAY
FROM (
  SELECT a.n + b.n*10 AS n
  FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
  CROSS JOIN
       (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) b
) seq
WHERE n BETWEEN 0 AND 30;

/*80)"You are tasked with analysing the sales data for products during the month of January 2024. 
Your goal is to calculate the rolling sum of sales for each product and each day of Jan 2024, considering the sales for the 
current day and the two previous days. Note that for some days, there might not be any sales for certain products, 
and you need to consider these days as having sales of 0. 
You can make use of the calendar table which has the all the dates for Jan-2024.*/
WITH all_days AS (
  SELECT p.product_id, c.cal_date
  FROM (SELECT DISTINCT product_id FROM module.orders) p
  CROSS JOIN module.calendar_dim c
  WHERE c.cal_date BETWEEN '2024-01-01' AND '2024-01-31'
),
daily AS (
  SELECT ad.product_id,
         ad.cal_date,
         COALESCE(SUM(o.amount),0) AS amount
  FROM all_days ad
  LEFT JOIN module.orders o
    ON o.product_id = ad.product_id
   AND o.order_date = ad.cal_date
  GROUP BY ad.product_id, ad.cal_date
)
SELECT
  product_id,
  cal_date,
  SUM(amount) OVER (
    PARTITION BY product_id
    ORDER BY cal_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_3day_sales
FROM daily
ORDER BY product_id, cal_date;
