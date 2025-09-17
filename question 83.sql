DROP TABLE IF EXISTS module.purchase_history;
CREATE TABLE module.purchase_history (
  userid INT,
  productid INT,
  purchasedate DATE
);

INSERT INTO module.purchase_history VALUES
(1,1,'2012-01-23'),
(1,1,'2012-01-23'),
(1,2,'2012-01-23'),
(1,3,'2012-01-25'),
(2,1,'2012-01-23'),
(2,2,'2012-01-23'),
(2,2,'2012-01-25'),
(2,4,'2012-01-25'),
(3,4,'2012-01-23'),
(3,1,'2012-01-23');

/*83)Suppose you are analyzing the purchase history of customers in an e-commerce platform. Your task is to identify customers
 who have bought different products on different dates.
Write an SQL to find customers who have bought different products on different dates, 
means product purchased on a given day is not repeated on any other day by the customer. 
Also note that for the customer to qualify he should have made purchases on at least 2 distinct dates.
 Please note that customer can purchase same product more than once on the same day and that doesn't disqualify him.
 Output should contain customer id and number of products bought by the customer in ascending order of userid.*/

WITH per_user_prod AS (
  SELECT userid, productid, COUNT(DISTINCT purchasedate) AS date_cnt
  FROM module.purchase_history
  GROUP BY userid, productid
),
valid_users AS (
  SELECT userid
  FROM per_user_prod
  GROUP BY userid
  HAVING SUM(CASE WHEN date_cnt > 1 THEN 1 ELSE 0 END) = 0  
),
user_stats AS (
  SELECT userid,
         COUNT(DISTINCT purchasedate) AS distinct_dates,
         COUNT(DISTINCT productid)    AS product_count
  FROM module.purchase_history
  GROUP BY userid
)
SELECT s.userid, s.product_count
FROM user_stats s
JOIN valid_users v USING (userid)
WHERE s.distinct_dates >= 2
ORDER BY s.userid;
