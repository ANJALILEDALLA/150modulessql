CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.purchases;
DROP TABLE IF EXISTS module.products;

CREATE TABLE module.products (
  category VARCHAR(10),
  id INT PRIMARY KEY,
  name VARCHAR(20),
  price INT
);

CREATE TABLE module.purchases (
  id INT PRIMARY KEY,
  product_id INT,
  stars INT,
  FOREIGN KEY (product_id) REFERENCES module.products(id)
);

INSERT INTO module.products (id, name, category, price) VALUES
  (1, 'Cripps Pink', 'apple', 10),
  (2, 'Navel Orange', 'orange', 12),
  (3, 'Golden Delicious', 'apple', 6),
  (4, 'Clementine', 'orange', 14),
  (5, 'Pinot Noir', 'grape', 20),
  (6, 'Bing Cherries', 'cherry', 36),
  (7, 'Sweet Cherries', 'cherry', 40);

INSERT INTO module.purchases (id, product_id, stars) VALUES
  (1, 1, 2),
  (2, 3, 3),
  (3, 2, 2),
  (4, 4, 4),
  (5, 6, 5),
  (6, 6, 4),
  (7, 7, 5);

/*55)You own a small online store, and want to analyze customer ratings for the products that you're selling.
 After doing a data pull, you have a list of products and a log of purchases. Within the purchase log, each record includes 
 the number of stars (from 1 to 5) as a customer rating for the product.
For each category, find the lowest price among all products that received at least one 4-star or above rating from customers.
If a product category did not have any products that received at least one 4-star or above rating, the lowest price is considered 
to be 0. The final output should be sorted by product category in alphabetical order.
*/
SELECT
  p.category,
  COALESCE(MIN(CASE WHEN q.product_id IS NOT NULL THEN p.price END), 0) AS lowest_price
FROM module.products AS p
LEFT JOIN (
  SELECT DISTINCT product_id
  FROM module.purchases
  WHERE stars >= 4
) AS q
ON q.product_id = p.id
GROUP BY p.category
ORDER BY p.category;
