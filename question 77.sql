DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  product_id INT,
  sales INT
);

INSERT INTO module.orders VALUES
(1,101,'2022-01-05',1,50),
(2,102,'2022-03-10',1,60),
(3,103,'2023-01-07',1,80),
(4,104,'2023-03-12',1,70),
(5,105,'2024-01-06',1,120),
(6,106,'2024-03-15',1,100),
(7,201,'2022-01-11',2,100),
(8,202,'2023-01-13',2,90),
(9,203,'2024-01-18',2,130),
(10,204,'2022-03-02',2,40),
(11,205,'2023-03-05',2,60),
(12,206,'2024-03-09',2,95),
(13,301,'2022-02-03',3,30),
(14,302,'2023-02-08',3,50),
(15,303,'2024-02-12',3,80),
(16,401,'2022-02-14',4,20),
(17,402,'2024-02-16',4,70);


/*77)You are tasked with analyzing the sales growth of products over the years 2022, 2023, and 2024.
 Your goal is to identify months where the sales for a product have consistently increased from 2022 to 2023 and from 2023 to 2024.
Your task is to write an SQL query to generate a report that includes the sales for each product at the month level 
for the years 2022, 2023, and 2024. However, you should only include product and months combination where the sales have 
consistently increased from 2022 to 2023 and from 2023 to 2024, display the output in ascending order of product_id.
*/
WITH s AS (
  SELECT
    product_id,
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mon,
    SUM(sales) AS total_sales
  FROM module.orders
  WHERE YEAR(order_date) IN (2022,2023,2024)
  GROUP BY product_id, YEAR(order_date), MONTH(order_date)
),
p AS (
  SELECT
    product_id,
    mon,
    MAX(CASE WHEN yr=2022 THEN total_sales END) AS sales_2022,
    MAX(CASE WHEN yr=2023 THEN total_sales END) AS sales_2023,
    MAX(CASE WHEN yr=2024 THEN total_sales END) AS sales_2024
  FROM s
  GROUP BY product_id, mon
)
SELECT
  product_id,
  LPAD(mon,2,'0') AS month,
  sales_2022,
  sales_2023,
  sales_2024
FROM p
WHERE sales_2022 IS NOT NULL
  AND sales_2023 IS NOT NULL
  AND sales_2024 IS NOT NULL
  AND sales_2022 < sales_2023
  AND sales_2023 < sales_2024
ORDER BY product_id, mon;
