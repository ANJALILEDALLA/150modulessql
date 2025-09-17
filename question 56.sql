DROP TABLE IF EXISTS module.expenditures;

CREATE TABLE module.expenditures (
  user_name VARCHAR(10),
  expenditure INT,
  card_company VARCHAR(15)
);

INSERT INTO module.expenditures (user_name, card_company, expenditure) VALUES
('user1','Mastercard',1000),
('user1','Visa',500),
('user1','RuPay',2000),
('user2','Visa',2000),
('user3','Mastercard',5000),
('user3','Visa',1000),
('user3','Slice',500),
('user3','Amex',1000),
('user4','Mastercard',2000);

/*56)You're working for a financial analytics company that specializes in analyzing credit card expenditures. 
You have a dataset containing information about users' credit card expenditures across different card companies.
Write an SQL query to find the total expenditure from other cards (excluding Mastercard) for users who hold Mastercard.  
Display only the users(along with Mastercard expense and other expense) for which expense from other cards together
 is more than Mastercard expense.
*/

WITH a AS (
  SELECT
    user_name,
    SUM(CASE WHEN card_company = 'Mastercard' THEN expenditure ELSE 0 END) AS mastercard_expense,
    SUM(CASE WHEN card_company <> 'Mastercard' THEN expenditure ELSE 0 END) AS other_expense
  FROM module.expenditures
  GROUP BY user_name
)
SELECT user_name, mastercard_expense, other_expense
FROM a
WHERE mastercard_expense > 0 AND other_expense > mastercard_expense
ORDER BY user_name;
