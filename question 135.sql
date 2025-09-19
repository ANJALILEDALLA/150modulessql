DROP TABLE IF EXISTS module.user_sessions;
CREATE TABLE module.user_sessions (
  user_id INT,
  login_timestamp DATETIME
);

INSERT INTO module.user_sessions VALUES
(1,'2025-06-06 00:01:05'),
(1,'2025-06-06 03:01:05'),
(1,'2025-06-07 00:01:05'),
(1,'2025-06-08 00:01:05'),
(1,'2025-06-09 00:01:05'),
(1,'2025-06-10 00:01:05'),
(1,'2025-06-11 00:01:05'),
(1,'2025-06-12 00:01:05'),
(1,'2025-06-13 00:01:05'),
(2,'2025-06-06 00:01:05');

/*135)At Spotify, we track user activity to understand their engagement with the platform. One of the key metrics we focus on 
is how consistently a user listens to music each day. A user is considered "consistent" if they have login session every 
single day since their first login.

Your task is to identify users who have logged in and listened to music every single day since their first login date until today.
Note: Dates are as per UTC time zone.
*/

WITH days AS (
  SELECT user_id, DATE(login_timestamp) AS d
  FROM module.user_sessions
  GROUP BY user_id, DATE(login_timestamp)
),
span AS (
  SELECT user_id, MIN(d) AS first_day, MAX(d) AS last_day, COUNT(*) AS day_cnt
  FROM days
  GROUP BY user_id
)
SELECT user_id
FROM span
WHERE last_day = UTC_DATE()
  AND day_cnt = DATEDIFF(UTC_DATE(), first_day) + 1
ORDER BY user_id;
