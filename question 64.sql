DROP TABLE IF EXISTS module.orders;

CREATE TABLE module.orders (
  order_id INT,
  order_date DATE,
  customer_name VARCHAR(10),
  product_name VARCHAR(10),
  sales INT
);

INSERT INTO module.orders (order_id, order_date, customer_name, product_name, sales) VALUES
(1,'2023-01-01','Alexa','iphone',100),
(2,'2023-01-02','Alexa','boAt',300),
(3,'2023-01-03','Alexa','Rolex',400),
(4,'2023-01-01','Ramesh','Titan',200),
(5,'2023-01-02','Ramesh','Shirt',300),
(6,'2023-01-03','Neha','Dress',100);


/*64)You are a data analyst working for an e-commerce company, responsible for analysing customer orders to
 gain insights into their purchasing behaviour. Your task is to write a SQL query to retrieve the details of the penultimate
 order for each customer. However, if a customer has placed only one order,
 you need to retrieve the details of that order instead, display the output in ascending order of customer name.*/
WITH r AS (
  SELECT
    order_id, order_date, customer_name, product_name, sales,
    ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date DESC, order_id DESC) AS rn,
    COUNT(*) OVER (PARTITION BY customer_name) AS cnt
  FROM module.orders
)
SELECT order_id, order_date, customer_name, product_name, sales
FROM r
WHERE rn = CASE WHEN cnt >= 2 THEN 2 ELSE 1 END
ORDER BY customer_name;
