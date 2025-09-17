CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.watch_history;
CREATE TABLE module.watch_history (
  user_id INT,
  show_id INT,
  watch_date DATE,
  watch_duration INT
);

INSERT INTO module.watch_history VALUES
(1,101,'2024-11-01',120),
(1,101,'2024-11-02',200),
(3,101,'2024-11-01',130),
(4,102,'2024-11-01',60),
(2,102,'2024-11-02',80),
(5,103,'2024-11-01',90),
(6,103,'2024-11-02',200),
(7,104,'2024-11-01',1000),
(8,105,'2024-11-01',150),
(10,106,'2024-11-02',140);

/*124)Netflix’s analytics team wants to identify the Top 3 most popular shows based on the viewing patterns of its users. 
The definition of "popular" is based on two factors:
Unique Watchers: The total number of distinct users who have watched a show.
Total Watch Duration: The cumulative time users have spent watching the show

In the case of ties in the number of unique watchers, the total watch duration will serve as the tie-breaker.
Write an SQL query to determine the Top 3 shows based on the above criteria. The output should be sorted by show_id and 
should include: show_id , unique_watchers, total_duration.
*/
WITH agg AS (
  SELECT
    show_id,
    COUNT(DISTINCT user_id) AS unique_watchers,
    SUM(watch_duration) AS total_duration
  FROM module.watch_history
  GROUP BY show_id
),
ranked AS (
  SELECT
    show_id,
    unique_watchers,
    total_duration,
    DENSE_RANK() OVER (ORDER BY unique_watchers DESC, total_duration DESC) AS rnk
  FROM agg
)
SELECT show_id, unique_watchers, total_duration
FROM ranked
WHERE rnk <= 3
ORDER BY show_id;
