DROP TABLE IF EXISTS module.categories;

CREATE TABLE module.categories (
  category VARCHAR(15),
  products VARCHAR(30)
);

INSERT INTO module.categories (category, products) VALUES
('Electronics','TV, Radio, Laptop'),
('Furniture','Chair'),
('Clothing','Shirt, Pants, Jacket, Shoes'),
('Groceries','Rice, Sugar');


/*73)You are provided with a table that lists various product categories, each containing a comma-separated list of products.
 Your task is to write a SQL query to count the number of products in each category. Sort the result by product count.*/
SELECT
  category,
  CASE
    WHEN products IS NULL OR TRIM(products) = '' THEN 0
    ELSE LENGTH(products) - LENGTH(REPLACE(products, ',', '')) + 1
  END AS product_count
FROM module.categories
ORDER BY product_count;
