DROP TABLE IF EXISTS module.events;
DROP TABLE IF EXISTS module.users;

CREATE TABLE module.users (
  user_id   INT,
  name      VARCHAR(50),
  platform  VARCHAR(20)
);

INSERT INTO module.users (user_id, name, platform) VALUES
(1,'Alice','LinkedIn'),
(1,'Alice','Meta'),
(2,'Bob','LinkedIn'),
(2,'Bob','Instagram'),
(3,'Charlie','Meta'),
(3,'Charlie','Instagram'),
(4,'David','Meta'),
(4,'David','LinkedIn'),
(5,'Eve','Instagram'),
(5,'Eve','LinkedIn'),
(6,'Frank','Instagram'),
(6,'Frank','Meta');

CREATE TABLE module.events (
  event_id   INT,
  user_id    INT,
  action     VARCHAR(20),
  platform   VARCHAR(20),
  created_at DATETIME
);

INSERT INTO module.events (event_id, user_id, action, platform, created_at) VALUES
(101,1,'like','LinkedIn','2024-03-20 10:00:00'),
(102,1,'comment','Meta','2024-03-21 11:00:00'),
(103,2,'post','LinkedIn','2024-03-22 12:00:00'),
(104,2,'post','Instagram','2024-03-22 13:00:00'),
(105,3,'like','Meta','2024-03-23 13:00:00'),
(106,3,'comment','Instagram','2024-03-24 14:00:00'),
(107,4,'post','Meta','2024-03-25 15:00:00'),
(108,4,'like','LinkedIn','2024-03-26 16:00:00'),
(109,5,'post','Instagram','2024-03-27 17:00:00'),
(110,5,'like','LinkedIn','2024-03-28 18:00:00'),
(111,6,'comment','Instagram','2024-03-29 19:00:00');

/*145)You’re given two tables: users and events. The users table contains information about users, including the social media
 platform they belong to (platform column with values ‘LinkedIn’, ‘Meta’, or ‘Instagram’). The events table stores user
 interactions in the action column, which can be ‘like’, ‘comment’, or ‘post’. Please note that one user can belong to
 multiple social media platforms.
Write a query to calculate the percentage of users on each social media platform who have never liked or commented, rounded to
 two decimal places. Order the result by platform.
*/

WITH acted AS (
  SELECT DISTINCT user_id, platform
  FROM module.events
  WHERE action IN ('like','comment')
)
SELECT
  u.platform,
  ROUND(
    100.0 * SUM(CASE WHEN a.user_id IS NULL THEN 1 ELSE 0 END) / COUNT(*),
    2
  ) AS pct_never_like_or_comment
FROM module.users u
LEFT JOIN acted a
  ON a.user_id = u.user_id
 AND a.platform = u.platform
GROUP BY u.platform
ORDER BY u.platform;
