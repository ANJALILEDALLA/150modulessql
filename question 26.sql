
DROP TABLE IF EXISTS module.orders;
DROP TABLE IF EXISTS module.products;

CREATE TABLE module.products (
  product_id  INT,
  price       INT,
  price_date  DATE
);

CREATE TABLE module.orders (
  order_id    INT,
  order_date  DATE,
  product_id  INT
);


INSERT INTO module.products (product_id, price_date, price) VALUES
(100, '2024-01-01', 150),
(100, '2024-01-21', 170),
(100, '2024-02-01', 190),
(101, '2024-01-01', 1000),
(101, '2024-01-27', 1200),
(101, '2024-02-05', 1250);


INSERT INTO module.orders (order_id, order_date, product_id) VALUES
(1, '2024-01-05', 100),
(2, '2024-01-21', 100),
(3, '2024-02-20', 100),
(4, '2024-01-07', 101),
(5, '2024-02-04', 101),
(6, '2024-02-05', 101),
(7, '2024-02-10', 101);

/*26)"Write an SQL query to calculate the total sales value for each product, 
considering the cost of the product at the time of the order date, 
display the output in ascending order of the product_id*/

SELECT
  o.product_id,
  SUM(p.price) AS total_sales_value
FROM module.orders o
JOIN module.products p
  ON p.product_id = o.product_id
 AND p.price_date = (
       SELECT MAX(p2.price_date)
       FROM module.products p2
       WHERE p2.product_id = o.product_id
         AND p2.price_date <= o.order_date
     )
GROUP BY o.product_id
ORDER BY o.product_id;

