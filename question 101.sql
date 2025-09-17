DROP TABLE IF EXISTS module.gmail_data;
CREATE TABLE module.gmail_data (
  from_user VARCHAR(20),
  to_user   VARCHAR(20),
  email_day DATE
);

INSERT INTO module.gmail_data VALUES
('a84065b7933ad01019','75d29537746af88326','2023-11-28'),
('6b503743a13d778200','32ded68d8943ae808','2023-12-29'),
('32ded68d8943ae808','55ee06cfdcc9d4c17e','2023-01-23'),
('157e3e9278e32aba3e','e0e0defbb9ec47fc67','2023-08-04'),
('114bafadff2d882864','47be283778691867e','2023-07-04'),
('4065f39987ddb9679c0','2b312e59cf6c1ff698e','2023-06-05'),
('6edf0be4b2267df1f1a','a84065b7933ad01019','2023-02-10'),
('a84065b7933ad01019','b508badf89aedf60854','2023-11-27'),
('d63386c884aeb9f71d','6b503743a13d778200','2023-01-08'),
('32ded68d8943ae808','d63386c884aeb9f71d','2023-01-28'),
('6edf0be4b2267df1f1a','5b8754928306a18b68','2023-05-20');


/*101)Given a sample table with emails sent vs. received by the users, calculate the response rate (%) which is given as emails 
sent/ emails received. For simplicity consider sent emails are delivered. List all the users that fall under the
 top 25 percent based on the highest response rate.
Please consider users who have sent at least one email and have received at least one email.
*/
WITH sent AS (
  SELECT from_user AS user_id, COUNT(*) AS sent_cnt
  FROM module.gmail_data
  GROUP BY from_user
),
received AS (
  SELECT to_user AS user_id, COUNT(*) AS recv_cnt
  FROM module.gmail_data
  GROUP BY to_user
),
users AS (
  SELECT user_id FROM sent
  UNION
  SELECT user_id FROM received
),
agg AS (
  SELECT u.user_id,
         COALESCE(s.sent_cnt,0) AS sent_cnt,
         COALESCE(r.recv_cnt,0) AS recv_cnt
  FROM users u
  LEFT JOIN sent s ON s.user_id = u.user_id
  LEFT JOIN received r ON r.user_id = u.user_id
),
scored AS (
  SELECT user_id,
         sent_cnt,
         recv_cnt,
         100.0 * sent_cnt / recv_cnt AS response_rate
  FROM agg
  WHERE sent_cnt > 0 AND recv_cnt > 0
)
SELECT user_id, sent_cnt, recv_cnt, ROUND(response_rate,2) AS response_rate_pct
FROM (
  SELECT s.*,
         NTILE(4) OVER (ORDER BY response_rate DESC) AS quartile
  FROM scored s
) q
WHERE quartile = 1
ORDER BY response_rate DESC, user_id;
