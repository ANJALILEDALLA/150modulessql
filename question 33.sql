DROP TABLE IF EXISTS module.transactions;
CREATE TABLE module.transactions (
    order_id INT,
    user_id INT,
    transaction_amount DECIMAL(5,2),
    transaction_date DATE
);

INSERT INTO module.transactions VALUES
(1, 101, 50.00, '2024-02-24'),
(2, 102, 75.00, '2024-02-24'),
(3, 103, 100.00, '2024-02-25'),
(4, 104, 30.00, '2024-02-26'),
(5, 105, 200.00, '2024-02-26'),
(6, 106, 50.00, '2024-02-27'),
(7, 107, 150.00, '2024-02-27'),
(8, 108, 80.00, '2024-02-29');

/*33)"Write an SQL query to determine the transaction date with the lowest average order value (AOV)
 among all dates recorded in the transaction table. Display the transaction date, 
 its corresponding AOV, and the difference between the AOV for that date and the highest AOV for any day in the dataset.
 Round the result to 2 decimal places*/

WITH avg_per_date AS (
    SELECT transaction_date,
           ROUND(AVG(transaction_amount),2) AS AOV
    FROM module.transactions
    GROUP BY transaction_date
),
stats AS (
    SELECT MIN(AOV) AS minAOV,
           MAX(AOV) AS maxAOV
    FROM avg_per_date
)
SELECT a.transaction_date,
       a.AOV,
       ROUND(s.maxAOV - a.AOV, 2) AS diff_from_highest
FROM avg_per_date a
JOIN stats s
ON a.AOV = s.minAOV;
