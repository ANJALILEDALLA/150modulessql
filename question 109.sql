DROP TABLE IF EXISTS module.purchase;
CREATE TABLE module.purchase (
  customer_id INT,
  purchase_date DATE,
  amount INT
);

INSERT INTO module.purchase VALUES
(1,'2024-07-01',1500),
(1,'2024-07-05',3000),
(1,'2024-07-10',1200),
(2,'2024-07-07',5000),
(2,'2024-07-12',2000),
(2,'2024-07-15',3200),
(3,'2024-07-03',1800),
(3,'2024-07-10',2400),
(3,'2024-07-22',3100),
(4,'2024-07-04',2200),
(4,'2024-07-08',4100),
(4,'2024-07-18',3500);

/*109)Write an SQL to retrieve the top 5 customers
 who have spent the most on their single purchase. Sort the result by max single purchase in descending order.*/
WITH m AS (
  SELECT customer_id, MAX(amount) AS max_single_purchase
  FROM module.purchase
  GROUP BY customer_id
)
SELECT customer_id, max_single_purchase
FROM m
ORDER BY max_single_purchase DESC, customer_id
LIMIT 5;
