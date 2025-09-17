DROP TABLE IF EXISTS module.transactions;

CREATE TABLE module.transactions (
  amount INT,
  transaction_date DATE
);

INSERT INTO module.transactions (transaction_date, amount) VALUES
('2020-01-01', -30),
('2020-01-05', -80),
('2020-01-24', 100),
('2020-03-01', -10),
('2020-03-01', 30),
('2020-04-13', -40),
('2020-07-05', -20),
('2020-10-19', 60),
('2020-12-01', -40),
('2020-12-05', -30);


/*58)"You are given history of your bank account for the year 2020. Each transaction is either a credit card payment or 
incoming transfer. There is a fee of holding a credit card which you have to pay every month, Fee is 5 per month. 
However, you are not charged for a given month if you made at least 2 credit card payments for a total cost of at 
least 100 within that month. Note that this fee is not included in the supplied history of transactions. 
Each row in the table contains information about a single transaction. If the amount value is negative,
 it is a credit card payment otherwise it is an incoming transfer. At the beginning of the year, 
the balance of your account was 0 . Your task is to compute the balance at the end of the year.*/
WITH RECURSIVE months(m_first) AS (
  SELECT DATE('2020-01-01')
  UNION ALL
  SELECT m_first + INTERVAL 1 MONTH FROM months WHERE m_first < DATE('2020-12-01')
),
monthly AS (
  SELECT DATE_FORMAT(transaction_date,'%Y-%m-01') AS m_first,
         SUM(amount) AS month_total,
         SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END) AS neg_cnt,
         SUM(CASE WHEN amount < 0 THEN -amount ELSE 0 END) AS neg_abs
  FROM module.transactions
  GROUP BY DATE_FORMAT(transaction_date,'%Y-%m-01')
),
fees AS (
  SELECT m.m_first,
         COALESCE(month_total,0) AS month_total,
         CASE WHEN COALESCE(neg_cnt,0) >= 2 AND COALESCE(neg_abs,0) >= 100 THEN 0 ELSE 5 END AS fee
  FROM months m
  LEFT JOIN monthly x ON x.m_first = m.m_first
)
SELECT SUM(month_total - fee) AS year_end_balance
FROM fees;
