DROP TABLE IF EXISTS module.credit_card_transactions;
CREATE TABLE module.credit_card_transactions (
  transaction_id INT,
  city VARCHAR(10),
  transaction_date DATE,
  card_type VARCHAR(10),
  gender VARCHAR(1),
  amount INT
);

INSERT INTO module.credit_card_transactions VALUES
(1,'Delhi','2024-01-13','Gold','F',500),
(2,'Bengaluru','2024-01-13','Silver','M',1000),
(3,'Mumbai','2024-01-14','Silver','F',600),
(4,'Bengaluru','2024-01-14','Gold','M',900),
(5,'Bengaluru','2024-01-14','Gold','F',300),
(6,'Delhi','2024-01-15','Silver','M',200),
(7,'Mumbai','2024-01-15','Gold','F',900),
(8,'Delhi','2024-01-15','Gold','F',800),
(9,'Mumbai','2024-01-16','Silver','F',1000),
(10,'Mumbai','2024-01-16','Platinum','F',1900),
(11,'Bengaluru','2024-01-16','Platinum','M',1250);

/*48)You are given a history of credit card transaction data for the people of India across cities.
 Write an SQL to find percentage contribution of spends by females in each city.  Round the percentage to 2 decimal places.
 Display city, total spend , female spend and female contribution in ascending order of city.*/
WITH a AS (
  SELECT
    city,
    SUM(amount) AS total_spend,
    SUM(CASE WHEN gender='F' THEN amount ELSE 0 END) AS female_spend
  FROM module.credit_card_transactions
  GROUP BY city
)
SELECT
  city,
  total_spend,
  female_spend,
  ROUND(female_spend * 100.0 / total_spend, 2) AS female_contribution
FROM a
ORDER BY city;
