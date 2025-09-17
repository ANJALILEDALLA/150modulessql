DROP TABLE IF EXISTS module.sales_amount;
CREATE TABLE module.sales_amount (
  sale_date DATE,
  sales_amount INT,
  currency VARCHAR(20)
);

INSERT INTO module.sales_amount VALUES
('2020-01-01',500,'INR'),
('2020-01-01',100,'GBP'),
('2020-01-02',1000,'INR'),
('2020-01-02',500,'GBP'),
('2020-01-03',500,'INR'),
('2020-01-17',200,'GBP'),
('2020-01-18',200,'Ringgit'),
('2020-01-05',800,'INR'),
('2020-01-06',150,'GBP'),
('2020-01-10',100,'INR'),
('2020-01-15',100,'INR');

DROP TABLE IF EXISTS module.exchange_rate;
CREATE TABLE module.exchange_rate (
  from_currency VARCHAR(20),
  to_currency VARCHAR(20),
  exchange_rate DECIMAL(10,2),
  effective_date DATE
);

INSERT INTO module.exchange_rate VALUES
('INR','USD',0.14,'2019-12-31'),
('INR','USD',0.15,'2020-01-02'),
('GBP','USD',1.32,'2019-12-20'),
('GBP','USD',1.30,'2020-01-01'),
('GBP','USD',1.35,'2020-01-16'),
('GBP','USD',1.35,'2020-01-25'),
('Ringgit','USD',0.30,'2020-01-10'),
('INR','USD',0.16,'2020-01-10'),
('GBP','USD',1.33,'2020-01-05');


/*117)You are given two tables, sales_amount and exchange_rate. The sales_amount table contains sales transactions in various
 currencies, and the exchange_rate table provides the exchange rates for converting different currencies into USD, along with 
 the dates when these rates became effective.
Your task is to write an SQL query that converts all sales amounts into USD using the most recent applicable exchange 
rate that was effective on or before the sale date. Then, calculate the total sales in USD for each sale date.
*/
WITH r AS (
  SELECT
    s.sale_date,
    s.sales_amount,
    s.currency,
    e.exchange_rate,
    ROW_NUMBER() OVER (
      PARTITION BY s.sale_date, s.currency
      ORDER BY e.effective_date DESC
    ) AS rn
  FROM module.sales_amount s
  JOIN module.exchange_rate e
    ON e.from_currency = s.currency
   AND e.to_currency = 'USD'
   AND e.effective_date <= s.sale_date
)
SELECT
  sale_date,
  ROUND(SUM(sales_amount * exchange_rate),2) AS total_usd
FROM r
WHERE rn = 1
GROUP BY sale_date
ORDER BY sale_date;
