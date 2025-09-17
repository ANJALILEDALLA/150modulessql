CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  order_id INT,
  order_date DATE,
  product_id INT,
  category VARCHAR(20),
  amount INT
);

INSERT INTO module.orders (order_id,order_date,product_id,category,amount) VALUES
(1,'2024-01-01',1,'Furniture',100),
(2,'2024-01-02',6,'Technology',150),
(3,'2024-01-03',11,'Home Appliances',120),
(4,'2024-01-04',4,'Furniture',200),
(5,'2024-01-05',7,'Technology',180),
(6,'2024-01-06',1,'Furniture',110),
(7,'2024-01-07',8,'Technology',220),
(8,'2024-01-08',12,'Home Appliances',130),
(9,'2024-01-09',3,'Furniture',190),
(10,'2024-01-10',9,'Technology',240),
(11,'2024-01-11',2,'Furniture',140);

/*79)You are analyzing sales data from an e-commerce platform, which includes information about orders placed for various 
products across different categories. Each order contains details such as the order ID, order date, product ID, category, 
and amount.
Write an SQL to identify the top 3 products within the top-selling category based on total sales. The top-selling 
category is determined by the sum of the amounts sold for all products within that category. Sort the output by products
 sales in descending order.
*/

WITH cat_tot AS (
  SELECT category, SUM(amount) AS cat_sales
  FROM module.orders
  GROUP BY category
),
topcat AS (
  SELECT category
  FROM cat_tot
  ORDER BY cat_sales DESC
  LIMIT 1
),
prod_tot AS (
  SELECT o.product_id, SUM(o.amount) AS total_sales
  FROM module.orders o
  JOIN topcat t ON t.category = o.category
  GROUP BY o.product_id
)
SELECT product_id, total_sales
FROM prod_tot
ORDER BY total_sales DESC
LIMIT 3;
