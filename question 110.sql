DROP TABLE IF EXISTS module.transactions;
CREATE TABLE module.transactions (
  transaction_id INT,
  customer_id INT,
  product_name VARCHAR(10),
  transaction_timestamp DATETIME,
  country VARCHAR(5)
);

INSERT INTO module.transactions VALUES
(1,101,'Laptop','2024-01-01 10:00:00','India'),
(2,101,'Laptop Bag','2024-01-01 10:05:00','India'),
(3,101,'Mouse','2024-01-02 11:00:00','India'),
(4,102,'Tablet','2024-01-03 14:00:00','India'),
(5,102,'Laptop','2024-01-04 15:00:00','India'),
(6,102,'Laptop Bag','2024-01-04 15:06:00','India'),
(7,103,'Laptop Bag','2024-01-05 16:00:00','India'),
(8,103,'Smartphone','2024-01-06 16:00:00','India'),
(9,201,'Laptop Bag','2024-01-07 09:00:00','USA'),
(10,201,'Keyboard','2024-01-07 09:05:00','USA'),
(11,201,'Laptop Bag','2024-01-07 09:10:00','USA'),
(12,201,'Laptop','2024-01-07 09:15:00','USA');

/*110)The marketing team at a retail company wants to analyze customer purchasing behavior. 
They are particularly interested in understanding how many customers who bought a laptop later went on to purchase a laptop bag, 
with no intermediate purchases in between. Write an SQL to get number of customer in each country who bought
 laptop and number of customers who bought laptop bag just after buying a laptop. Order the result by country.*/

WITH ord AS (
  SELECT
    t.*,
    LEAD(product_name)  OVER (PARTITION BY customer_id ORDER BY transaction_timestamp) AS next_product,
    LEAD(country)       OVER (PARTITION BY customer_id ORDER BY transaction_timestamp) AS next_country
  FROM module.transactions t
),
lap AS (
  SELECT country, COUNT(DISTINCT customer_id) AS customers_bought_laptop
  FROM module.transactions
  WHERE product_name = 'Laptop'
  GROUP BY country
),
lap_then_bag AS (
  SELECT country, COUNT(DISTINCT customer_id) AS customers_bag_immediately_after_laptop
  FROM ord
  WHERE product_name='Laptop' AND next_product='Laptop Bag' AND country = next_country
  GROUP BY country
)
SELECT
  c.country,
  COALESCE(l.customers_bought_laptop,0) AS customers_bought_laptop,
  COALESCE(b.customers_bag_immediately_after_laptop,0) AS customers_bag_immediately_after_laptop
FROM (SELECT DISTINCT country FROM module.transactions) c
LEFT JOIN lap l ON l.country = c.country
LEFT JOIN lap_then_bag b ON b.country = c.country
ORDER BY c.country;
