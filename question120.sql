DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  customer_id INT,
  order_id INT,
  order_date DATE
);

INSERT INTO module.orders VALUES
(1,101,'2023-01-15'),
(1,102,'2023-02-10'),
(2,201,'2023-02-10'),
(2,202,'2023-02-25'),
(2,203,'2023-03-30'),
(2,204,'2023-01-01'),
(3,301,'2023-03-01'),
(3,302,'2023-03-01'),
(3,303,'2023-01-01'),
(3,304,'2023-02-01'),
(4,401,'2023-02-01'),
(4,402,'2023-03-01'),
(4,403,'2023-01-15');

/*120)"In a quick commerce business, Analyzing the frequency and timing of purchases can help the company identify engaged 
customers and tailor promotions accordingly. You are tasked to identify customers who have made a minimum of three purchases,
 ensuring that each purchase occurred in a different month. This information will assist in targeting marketing efforts towards 
 customers who show consistent buying behavior over time.
 Write an SQL to display customer id and no of orders placed by them.*/
SELECT
  customer_id,
  COUNT(*) AS orders_count
FROM module.orders
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_FORMAT(order_date,'%Y-%m')) >= 3
ORDER BY customer_id;
