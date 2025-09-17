DROP TABLE IF EXISTS module.credit_card_transactions;
CREATE TABLE module.credit_card_transactions (
  transaction_id INT,
  transaction_date DATE,
  amount INT,
  card_type VARCHAR(12),
  city VARCHAR(20),
  gender VARCHAR(1)
);

INSERT INTO module.credit_card_transactions VALUES
(1,'2024-01-13',500,'Gold','Delhi','F'),
(2,'2024-01-13',1000,'Silver','Bengaluru','M'),
(3,'2024-01-14',600,'Silver','Mumbai','F'),
(4,'2024-01-14',900,'Gold','Bengaluru','M'),
(5,'2024-01-14',300,'Gold','Bengaluru','F'),
(6,'2024-01-15',200,'Silver','Delhi','M'),
(7,'2024-01-15',900,'Gold','Mumbai','F'),
(8,'2024-01-15',800,'Gold','Delhi','F'),
(9,'2024-01-16',1000,'Silver','Mumbai','F'),
(10,'2024-01-16',1900,'Platinum','Mumbai','F'),
(11,'2024-01-16',1250,'Platinum','Bengaluru','M');

/*49)You are given a history of credit card transaction data for the people of India across cities .
 Write an SQL to find how many days each city took to reach cumulative spend of 1500 from its first day of transactions. 

Display city, first transaction date , date of 1500 spend and # of days in the ascending order of city*/

WITH daily AS (
  SELECT city, transaction_date, SUM(amount) AS day_amt
  FROM module.credit_card_transactions
  GROUP BY city, transaction_date
),
cum AS (
  SELECT
    city,
    transaction_date,
    day_amt,
    SUM(day_amt) OVER (PARTITION BY city ORDER BY transaction_date) AS cum_amt,
    MIN(transaction_date) OVER (PARTITION BY city) AS first_txn_date
  FROM daily
),
reached AS (
  SELECT
    city,
    first_txn_date,
    transaction_date AS date_1500,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY transaction_date) AS rn
  FROM cum
  WHERE cum_amt >= 1500
)
SELECT
  city,
  first_txn_date,
  date_1500,
  DATEDIFF(date_1500, first_txn_date) AS days_to_1500
FROM reached
WHERE rn = 1
ORDER BY city;
