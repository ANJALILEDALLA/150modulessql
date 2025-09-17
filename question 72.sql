DROP TABLE IF EXISTS module.sales;
DROP TABLE IF EXISTS module.products;

CREATE TABLE module.products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(10),
  price INT
);

CREATE TABLE module.sales (
  sale_id INT PRIMARY KEY,
  product_id INT,
  quantity INT,
  sale_date DATE,
  FOREIGN KEY (product_id) REFERENCES module.products(product_id)
);

INSERT INTO module.products (product_id, product_name, price) VALUES
(1,'Laptop',800),
(2,'Smartphone',600),
(3,'Headphones',50),
(4,'Tablet',400);

INSERT INTO module.sales (sale_id, product_id, quantity, sale_date) VALUES
(1,1,3,'2023-05-15'),
(2,2,2,'2023-05-16'),
(3,3,5,'2023-05-17'),
(4,1,2,'2023-05-18'),
(5,4,1,'2023-05-19'),
(6,2,3,'2023-05-20'),
(7,3,4,'2023-05-21'),
(8,1,1,'2023-05-22'),
(9,2,4,'2023-05-23'),
(10,4,2,'2023-05-24');


/*72)You are provided with two tables: Products and Sales. The Products table contains information about various products,
 including their IDs, names, and prices. The Sales table contains data about sales transactions, 
 including the product IDs, quantities sold, and dates of sale. Your task is to write a SQL query to find the total sales
 amount for each product. 
Display product name and total sales . Sort the result by product name.*/
SELECT
  p.product_name,
  SUM(s.quantity * p.price) AS total_sales
FROM module.products p
JOIN module.sales s
  ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY p.product_name;
