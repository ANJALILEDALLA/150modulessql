DROP TABLE IF EXISTS module.sales;
DROP TABLE IF EXISTS module.categories;

CREATE TABLE module.categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(12)
);

CREATE TABLE module.sales (
  sale_id INT PRIMARY KEY,
  category_id INT,
  amount INT,
  sale_date DATE,
  FOREIGN KEY (category_id) REFERENCES module.categories(category_id)
);

INSERT INTO module.categories (category_id, category_name) VALUES
(1,'Electronics'),
(2,'Clothing'),
(3,'Books'),
(4,'Home Decor');

INSERT INTO module.sales (sale_id, category_id, amount, sale_date) VALUES
(1,1,500,'2022-01-05'),
(2,1,800,'2022-02-10'),
(4,3,200,'2022-02-20'),
(5,3,150,'2022-03-01'),
(6,4,400,'2022-02-25'),
(7,4,600,'2022-03-05');


/*62)"Write an SQL query to retrieve the total sales amount in each category. Include all categories, 
if no products were sold in a category display as 0. Display the output in ascending order of total_sales.*/
SELECT
  c.category_id,
  c.category_name,
  COALESCE(SUM(s.amount),0) AS total_sales
FROM module.categories c
LEFT JOIN module.sales s
  ON s.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_sales ASC;
