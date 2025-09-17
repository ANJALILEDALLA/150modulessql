DROP TABLE IF EXISTS module.payments;
DROP TABLE IF EXISTS module.loans;

CREATE TABLE module.loans(
  loan_id INT,
  customer_id INT,
  loan_amount INT,
  due_date DATE
);

CREATE TABLE module.payments(
  payment_id INT,
  loan_id INT,
  payment_date DATE,
  amount_paid INT
);

INSERT INTO module.loans VALUES
(1,1,5000,'2023-01-15'),
(2,2,8000,'2023-02-20'),
(3,3,10000,'2023-03-10'),
(4,4,6000,'2023-04-05'),
(5,5,7000,'2023-05-01');

INSERT INTO module.payments VALUES
(1,1,'2023-01-10',2000),
(2,1,'2023-02-10',1500),
(3,2,'2023-02-20',8000);

/*52)"You're working for a large financial institution that provides various types of loans to customers.
 Your task is to analyze loan repayment data to assess credit risk and improve risk management strategies.
 Write an SQL to create 2 flags for each loan as per below rules. Display loan id, loan amount , due date and the 2 flags.
 1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
 2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.*/

WITH cs AS (
  SELECT
    p.loan_id,
    p.payment_date,
    p.amount_paid,
    SUM(p.amount_paid) OVER(PARTITION BY p.loan_id ORDER BY p.payment_date) AS cum_amt
  FROM module.payments p
),
payoff AS (
  SELECT loan_id, MIN(payment_date) AS payoff_date
  FROM cs c
  JOIN module.loans l ON l.loan_id = c.loan_id
  WHERE c.cum_amt >= l.loan_amount
  GROUP BY loan_id
),
tot AS (
  SELECT loan_id, SUM(amount_paid) AS total_paid
  FROM module.payments
  GROUP BY loan_id
)
SELECT
  l.loan_id,
  l.loan_amount,
  l.due_date,
  CASE WHEN COALESCE(t.total_paid,0) >= l.loan_amount THEN 1 ELSE 0 END AS fully_paid_flag,
  CASE
    WHEN COALESCE(t.total_paid,0) >= l.loan_amount AND pf.payoff_date <= l.due_date THEN 1
    ELSE 0
  END AS on_time_flag
FROM module.loans l
LEFT JOIN tot t  ON t.loan_id  = l.loan_id
LEFT JOIN payoff pf ON pf.loan_id = l.loan_id
ORDER BY l.loan_id;
