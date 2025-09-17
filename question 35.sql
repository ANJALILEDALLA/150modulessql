DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    delivery_date DATE,
    cancel_date DATE
);

INSERT INTO module.orders VALUES
(1,'2023-01-05',101,'2023-01-10',NULL),
(2,'2023-01-10',102,'2023-01-15','2023-01-16'),
(3,'2023-01-15',103,NULL,'2023-01-20'),
(4,'2023-01-07',104,'2023-01-10',NULL),
(5,'2023-01-13',105,'2023-01-17','2023-01-19'),
(6,'2023-02-15',106,'2023-02-20',NULL),
(7,'2023-02-05',107,'2023-02-05','2023-02-08'),
(8,'2023-02-10',108,NULL,'2023-02-15');

/*35)"You are given an orders table containing data about orders placed on an e-commerce website, 
with information on order date, delivery date, and cancel date. 
The task is to calculate both the cancellation rate and the return rate for each month based on the order date.
 Definitions: An order is considered cancelled if it is cancelled before delivery (i.e., cancel_date is not null, and 
 delivery_date is null). If an order is cancelled, no delivery will take place. An order is considered a return 
 if it is cancelled after it has already been delivered (i.e., cancel_date is not null, and cancel_date > delivery_date).
 Metrics to Calculate: 
 Cancel Rate = (Number of orders cancelled / Number of orders placed but not returned) * 100 Return Rate =
 (Number of orders returned / Number of orders placed but not cancelled) * 100 
 Write an SQL query to calculate the cancellation rate and return rate for each month
 (based on the order_date).Round the rates to 2 decimal places. 
Sort the output by year and month in increasing order.*/

WITH monthly AS (
  SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NULL THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NOT NULL AND cancel_date > delivery_date THEN 1 ELSE 0 END) AS returned
  FROM module.orders
  GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
  yr AS year,
  mn AS month,
  ROUND( (cancelled * 100.0) / NULLIF(total_orders - returned, 0), 2 ) AS cancel_rate,
  ROUND( (returned  * 100.0) / NULLIF(total_orders - cancelled, 0), 2 ) AS return_rate
FROM monthly
ORDER BY yr, mn;
