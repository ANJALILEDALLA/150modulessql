CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.sales;

CREATE TABLE module.sales (
  id INT,
  product_id INT,
  category VARCHAR(12),
  amount INT,
  order_date DATE
);

INSERT INTO module.sales (id, product_id, category, amount, order_date) VALUES
(1, 101, 'Electronics', 1500, '2022-02-05'),
(2, 102, 'Electronics', 2000, '2022-02-10'),
(3, 103, 'Clothing',    500,  '2022-02-15'),
(4, 104, 'Clothing',    800,  '2022-02-20'),
(5, 105, 'Books',       300,  '2022-02-25'),
(6, 106, 'Electronics', 1800, '2022-03-08'),
(7, 107, 'Clothing',    900,  '2022-03-10'),
(8, 108, 'Books',       400,  '2022-03-20'),
(9, 109, 'Electronics', 2200, '2022-04-05'),
(10,110, 'Clothing',    700,  '2022-04-12'),
(11,111, 'Books',       500,  '2022-04-15'),
(12,112, 'Electronics', 2500, '2022-05-05');


/*61)Write an SQL query to retrieve the total sales amount for each product category in the month of February 2022, 
only including sales made on weekdays (Monday to Friday).
 Display the output in ascending order of total sales.*/
SELECT
  category,
  SUM(amount) AS total_sales
FROM module.sales
WHERE order_date >= '2022-02-01'
  AND order_date <  '2022-03-01'
  AND DAYOFWEEK(order_date) BETWEEN 2 AND 6
GROUP BY category
ORDER BY total_sales ASC;
