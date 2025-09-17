DROP TABLE IF EXISTS module.transactions;
CREATE TABLE module.transactions(
  transaction_id INT,
  customer_id INT,
  transaction_date DATE,
  amount INT
);

DROP TABLE IF EXISTS module.interestrates;
CREATE TABLE module.interestrates(
  rate_id INT,
  min_balance INT,
  max_balance INT,
  interest_rate DECIMAL(5,4)
);

INSERT INTO module.transactions VALUES
(1,1,'2024-03-01',1000),
(2,2,'2024-03-02',500),
(3,3,'2024-03-03',1500),
(4,1,'2024-03-15',-300),
(5,2,'2024-03-20',700),
(6,3,'2024-03-25',-200),
(7,1,'2024-03-28',400);

INSERT INTO module.interestrates VALUES
(1,0,499,0.0100),
(2,500,999,0.0200),
(3,1000,1499,0.0300),
(4,1500,99999,0.0400);

/*90)"You are tasked with analyzing the interest earned by customers based on their account balances and transaction history. 
Each customer's account accrues interest based on their balance and prevailing interest rates.
 The interest is calculated for the ending balance on each day. 
 Your goal is to determine the total interest earned by each customer for the month of March-2024. 
 The interest rates (per day) are given in the interest table as per the balance amount range.
 Please assume that the account balance for each customer was 0 at the start of March 2024. 
 Write an SQL to calculate interest earned by each customer from March 1st 2024 to March 31st 2024,
 display the output in ascending order of customer id.*/

WITH RECURSIVE cal(d) AS (
  SELECT DATE('2024-03-01')
  UNION ALL
  SELECT DATE_ADD(d, INTERVAL 1 DAY) FROM cal WHERE d < '2024-03-31'
),
cust AS (
  SELECT DISTINCT customer_id FROM module.transactions
),
daily AS (
  SELECT c.customer_id, cal.d AS day,
         COALESCE((
           SELECT SUM(t.amount)
           FROM module.transactions t
           WHERE t.customer_id = c.customer_id
             AND t.transaction_date <= cal.d
         ),0) AS end_balance
  FROM cust c
  CROSS JOIN cal
),
rated AS (
  SELECT d.customer_id, d.day, d.end_balance,
         ir.interest_rate
  FROM daily d
  LEFT JOIN module.interestrates ir
    ON d.end_balance BETWEEN ir.min_balance AND ir.max_balance
)
SELECT
  customer_id,
  ROUND(SUM(CASE WHEN end_balance > 0 THEN end_balance * COALESCE(interest_rate,0) ELSE 0 END),2) AS total_interest
FROM rated
GROUP BY customer_id
ORDER BY customer_id;
