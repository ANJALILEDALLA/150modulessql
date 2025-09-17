DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  customer_id INT,
  order_id INT,
  product_name VARCHAR(50)
);

INSERT INTO module.orders VALUES
(1,101,'Laptop'),
(1,102,'Mouse'),
(1,103,'Phone Case'),
(1,104,'Headphones'),
(1,105,'Laptop'),
(2,106,'Mouse'),
(2,107,'Laptop'),
(3,108,'Laptop'),
(3,109,'Laptop'),
(3,110,'Phone Case'),
(4,111,'Laptop'),
(4,112,'Mouse'),
(5,113,'Mouse'),
(5,114,'Keyboard'),
(6,115,'Laptop'),
(6,116,'Mouse'),
(6,117,'Charger');


/*126)You are given an orders table that contains information about customer purchases, including the products they bought.
 Write a query to find all customers who have purchased both "Laptop" and "Mouse", but have never purchased "Phone Case".
 Additionally, include the total number of distinct products purchased by these customers. Sort the result by customer id.*/
SELECT
  customer_id,
  COUNT(DISTINCT product_name) AS total_distinct_products
FROM module.orders
GROUP BY customer_id
HAVING SUM(product_name = 'Laptop') > 0
   AND SUM(product_name = 'Mouse') > 0
   AND SUM(product_name = 'Phone Case') = 0
ORDER BY customer_id;
