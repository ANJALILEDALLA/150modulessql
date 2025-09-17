 DROP TABLE IF EXISTS module.electronic_items;
 CREATE TABLE module.electronic_items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(20),
    category VARCHAR(15),
    price DECIMAL(5,1),
    quantity INT,
    warranty_months INT
);

INSERT INTO module.electronic_items (item_id, item_name, category, price, quantity, warranty_months)
VALUES
(1, 'Laptop A', 'Laptop', 800.0, 10, 24),
(2, 'Laptop B', 'Laptop', 1200.0, 5, 12),
(3, 'Laptop C', 'Laptop', 900.0, 8, 18),
(4, 'Phone A', 'Phone', 600.0, 15, 12),
(5, 'Phone B', 'Phone', 450.0, 10, 12),
(6, 'Phone C', 'Phone', 550.0, 8, 24),
(7, 'Tablet A', 'Tablet', 300.0, 12, 6),
(8, 'Tablet B', 'Tablet', 400.0, 10, 12),
(9, 'Camera A', 'Camera', 700.0, 8, 12),
(10, 'Camera B', 'Camera', 800.0, 15, 18),
(11, 'Camera C', 'Camera', 650.0, 10, 12),
(12, 'Monitor A', 'Monitor', 500.0, 25, 12),
(13, 'Monitor B', 'Monitor', 550.0, 10, 24),
(14, 'Monitor C', 'Monitor', 600.0, 5, 12),
(15, 'Speaker A', 'Speaker', 200.0, 30, 18),
(16, 'Speaker B', 'Speaker', 250.0, 20, 12);


/*95)"You have a table called electronic_items. Write an SQL query to find the average price of electronic items in each category,
 considering only categories where the average price exceeds 500 
 and at least 20 total quantity of items is available. Additionally, 
 only include items with a warranty period of 12 months or more. Return the category name along with the
 average price of items in that category. 
Order the result by average price (round to 2 decimal places) in descending order.*/

SELECT category,ROUND(AVG(price),2) as average_price
FROM module.electronic_items
WHERE warranty_months>=12 
GROUP BY category
HAVING ROUND(AVG(price),2)>500.00 AND SUM(quantity) >= 20
ORDER BY average_price desc;

