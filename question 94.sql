
CREATE TABLE module.gap_sales (
    sale_id INT PRIMARY KEY,
    store_id INT,
    sale_date DATE,
    category VARCHAR(10),
    total_sales INT
);

INSERT INTO module.gap_sales (sale_id, store_id, sale_date, category, total_sales) VALUES
(1, 101, '2023-04-05', 'Men', 5000),
(2, 101, '2023-05-12', 'Women', 7000),
(3, 101, '2023-06-20', 'Kids', 3000),
(4, 102, '2023-04-10', 'Men', 4000),
(5, 102, '2023-05-15', 'Women', 8000),
(6, 102, '2023-06-25', 'Kids', 3500),
(7, 103, '2023-04-18', 'Men', 6000),
(8, 103, '2023-05-22', 'Women', 9000),
(9, 103, '2023-06-28', 'Kids', 2000),
(10, 101, '2023-02-15', 'Men', 4500),
(11, 102, '2023-07-05', 'Women', 7500),
(12, 103, '2023-08-10', 'Kids', 5000);

/*94)"You have a table called gap_sales. Write an SQL query to find the total sales for each category in each store for
 the Q2(April-June) of 2023. Return the store ID, category name, and total sales for each category in each store.
 Sort the result by total sales in ascending order.*/
 
 SELECT store_id,category,SUM(total_sales) AS total_sales
 FROM  module.gap_sales
 WHERE YEAR(sale_date)=2023 and MONTH(sale_date) IN (4,5,6)
 GROUP BY store_id,category
 ORDER BY total_sales asc;