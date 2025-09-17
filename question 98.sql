DROP TABLE IF EXISTS module.credit_card_transactions;
CREATE TABLE module.credit_card_transactions(
  transaction_id INT,
  city VARCHAR(10),
  transaction_date DATE,
  card_type VARCHAR(12),
  gender VARCHAR(1),
  amount INT
);

INSERT INTO module.credit_card_transactions VALUES
(1,'Delhi','2024-01-13','Gold','F',500),
(2,'Bengaluru','2024-01-13','Silver','M',1000),
(3,'Mumbai','2024-01-14','Silver','F',1200),
(4,'Bengaluru','2024-01-14','Gold','M',900),
(5,'Bengaluru','2024-01-14','Gold','F',300),
(6,'Delhi','2024-01-15','Gold','F',800),
(7,'Mumbai','2024-01-15','Gold','F',900),
(8,'Delhi','2024-01-15','Gold','F',1500),
(9,'Mumbai','2024-01-15','Silver','F',150),
(10,'Mumbai','2024-01-16','Platinum','F',1900),
(11,'Bengaluru','2024-01-16','Platinum','M',1250);

/*98)"You are given a history of credit card transaction data for the people of India across cities as below. 
Your task is to find out highest
 spend card type and lowest spent card type for each city, display the output in ascending order of city.*/

WITH sum_city AS (
  SELECT city, card_type, SUM(amount) AS total_amt
  FROM module.credit_card_transactions
  GROUP BY city, card_type
),
r AS (
  SELECT
    city,
    card_type,
    total_amt,
    DENSE_RANK() OVER (PARTITION BY city ORDER BY total_amt DESC) AS rnk_desc,
    DENSE_RANK() OVER (PARTITION BY city ORDER BY total_amt ASC)  AS rnk_asc
  FROM sum_city
)
SELECT
  city,
  MAX(CASE WHEN rnk_desc = 1 THEN card_type END) AS highest_spend_card_type,
  MAX(CASE WHEN rnk_asc  = 1 THEN card_type END) AS lowest_spend_card_type
FROM r
GROUP BY city
ORDER BY city;
