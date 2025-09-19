CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.transactions;
CREATE TABLE module.transactions (
  transaction_id INT,
  customer_id INT,
  transaction_date DATE,
  amount INT
);

INSERT INTO module.transactions VALUES
(1,1,'2025-01-13',100),
(2,5,'2025-02-12',200),
(3,2,'2025-03-20',200),
(4,1,'2025-03-13',150),
(5,3,'2025-01-13',210),
(6,4,'2025-03-10',140),
(7,4,'2025-02-21',230),
(8,1,'2025-01-22',130),
(9,2,'2024-12-29',180),
(10,2,'2025-01-10',100),
(11,7,'2025-03-13',110),
(12,7,'2025-03-13',180);


/*137)Myntra marketing team wants to measure the effectiveness of recent campaigns aimed at acquiring new customers.
 A new customer is defined as someone who made their first-ever purchase during a specific period, with no prior purchase history.
They have asked you to identify the new customers acquired in the last 3 months, excluding the current month. Output should 
display customer id and their first purchase date. Order the result by customer id.

For example:
If today is March 15, 2025, the SQL should give customers whose first purchase falls in the range from December 1, 2024, to
 February 28, 2025, and should not include any new customers made in March 2025.
*/
WITH params AS (
  SELECT DATE('2025-03-15') AS today
),
first_purchase AS (
  SELECT customer_id, MIN(transaction_date) AS first_purchase_date
  FROM module.transactions
  GROUP BY customer_id
)
SELECT customer_id, first_purchase_date
FROM first_purchase, params
WHERE first_purchase_date BETWEEN DATE_FORMAT(DATE_SUB(today, INTERVAL 3 MONTH), '%Y-%m-01')
                              AND LAST_DAY(DATE_SUB(today, INTERVAL 1 MONTH))
ORDER BY customer_id;
