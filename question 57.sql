
DROP TABLE IF EXISTS module.dashboard_visit;

CREATE TABLE module.dashboard_visit (
  user_id VARCHAR(10),
  visit_time DATETIME
);

INSERT INTO module.dashboard_visit (user_id, visit_time) VALUES
('Alice','2021-12-04 10:44:56'),
('Alice','2021-12-04 10:55:56'),
('Alice','2021-12-12 12:56:56'),
('Bob','2021-12-05 12:55:50'),
('Bob','2021-12-06 14:55:50'),
('Charlie','2021-12-06 17:56:50'),
('Charlie','2021-12-11 07:56:50'),
('David','2021-12-20 23:19:53'),
('David','2021-12-20 23:53:50'),
('David','2021-12-27 00:20:50');

/*57"You're working as a data analyst for a popular website's dashboard analytics team. 
Your task is to analyze user visits to the dashboard and identify users who are highly engaged with the platform.
 The dashboard records user visits along with timestamps to provide insights into user activity patterns. 
 A user can visit the dashboard multiple times within a day. However, to be counted as separate visits, 
 there should be a minimum gap of 60 minutes between consecutive visits. 
If the next visit occurs within 60 minutes of the previous one, it's considered part of the same visit.

Write an SQL query to find total number of visits by each user along with number of distinct days user has visited the dashboard.
 While calculating the number of distinct days you have to consider a visit even if it is same as previous days visit.
 So for example if there is a visit at 2024-01-12 23:30:00 and next visit at 2024-01-13 00:15:00 , 
 The visit on 13th will not be considered as new visit because it is within 
1 hour window of previous visit but number of days will be counted as 2 only, display the output in ascending order of user id.*/

WITH previous_visits AS
(
SELECT
user_id,
visit_time,
LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time) AS previous_visit_time
FROM
dashboard_visit
)
, visit_flag as
(
select user_id, previous_visit_time,visit_time
, CASE WHEN previous_visit_time IS NULL THEN 1
WHEN TIMESTAMPDIFF(second, previous_visit_time, visit_time) / 3600 > 1 THEN 1
ELSE 0
END AS new_visit_flag
from previous_visits
)
select user_id, sum(new_visit_flag) as no_of_visits, count(distinct CAST(visit_time as DATE)) as visit_days
from visit_flag
group by user_id
ORDER BY user_id ASC;