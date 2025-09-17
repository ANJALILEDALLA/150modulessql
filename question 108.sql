DROP TABLE IF EXISTS module.sales;
DROP TABLE IF EXISTS module.cities;
DROP TABLE IF EXISTS module.products;

CREATE TABLE module.products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(12)
);

CREATE TABLE module.cities (
  city_id INT PRIMARY KEY,
  city_name VARCHAR(10)
);

CREATE TABLE module.sales (
  sale_id INT PRIMARY KEY,
  product_id INT,
  city_id INT,
  sale_date VARCHAR(12),
  quantity INT,
  FOREIGN KEY (product_id) REFERENCES module.products(product_id),
  FOREIGN KEY (city_id) REFERENCES module.cities(city_id)
);

INSERT INTO module.products (product_id, product_name) VALUES
(1,'Laptop'),
(2,'Smartphone'),
(3,'Tablet'),
(4,'Headphones'),
(5,'Smartwatch');

INSERT INTO module.cities (city_id, city_name) VALUES
(1,'Mumbai'),
(2,'Delhi'),
(3,'Bangalore'),
(4,'Chennai'),
(5,'Hyderabad');

INSERT INTO module.sales (sale_id, product_id, city_id, sale_date, quantity) VALUES
(1, 1, 1, '2024-01-01', 30),
(2, 1, 1, '2024-01-02', 40),
(3, 1, 2, '2024-01-03', 25),
(4, 1, 2, '2024-01-04', 35),
(5, 1, 3, '2024-01-05', 50),
(6, 1, 3, '2024-01-06', 60),
(7, 1, 4, '2024-01-07', 45),
(8, 1, 4, '2024-01-08', 55),
(9, 1, 5, '2024-01-09', 30),
(10,1, 5, '2024-01-10', 40),
(11,2, 1, '2024-01-11', 20);

/*108)A technology company operates in several major cities across India, selling a variety of tech products.
 The company wants to analyze its sales data to understand which products have been successfully sold in all the cities where
 they operate(available in cities table).
Write an SQL query to identify the product names that have been sold at least 2 times in every city where the company operates.
*/

WITH per_city AS (
  SELECT product_id, city_id, COUNT(*) AS cnt
  FROM module.sales
  GROUP BY product_id, city_id
),
qualified AS (
  SELECT product_id
  FROM per_city
  WHERE cnt >= 2
  GROUP BY product_id
  HAVING COUNT(DISTINCT city_id) = (SELECT COUNT(*) FROM module.cities)
)
SELECT p.product_name
FROM module.products p
JOIN qualified q ON q.product_id = p.product_id
ORDER BY p.product_name;
