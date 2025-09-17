CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.reel;
CREATE TABLE module.reel (
  reel_id INT,
  record_date DATE,
  state VARCHAR(20),
  cumulative_views INT
);

INSERT INTO module.reel VALUES
(1,'2024-08-01','california',1000),
(1,'2024-08-02','california',1500),
(1,'2024-08-03','california',2000),
(1,'2024-08-04','california',2500),
(1,'2024-08-05','california',3000),
(1,'2024-08-06','california',3200),
(1,'2024-08-01','nevada',1000),
(1,'2024-08-02','nevada',1600),
(1,'2024-08-03','nevada',1900),
(1,'2024-08-04','nevada',2100),
(1,'2024-08-05','nevada',2200),
(1,'2024-08-06','nevada',2400),
(1,'2024-08-07','nevada',2800),
(1,'2024-08-08','nevada',3200);

/*112)Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states in the USA. 
You have access to a table named REEL that tracks the cumulative views of each reel over time. Write an SQL to get 
average daily views for each Instagram Reel in each state.
 Round the average to 2 decimal places and sort the result by average is descending order. */
WITH daily AS (
  SELECT
    reel_id,
    state,
    record_date,
    cumulative_views
      - COALESCE(LAG(cumulative_views) OVER (PARTITION BY reel_id, state ORDER BY record_date), 0) AS daily_views
  FROM module.reel
)
SELECT
  reel_id,
  state,
  ROUND(AVG(daily_views),2) AS avg_daily_views
FROM daily
GROUP BY reel_id, state
ORDER BY avg_daily_views DESC, reel_id, state;
