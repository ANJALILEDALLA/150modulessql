CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.rating_table;
CREATE TABLE module.rating_table (
  trip_time DATETIME,
  driver_id VARCHAR(10),
  trip_id INT,
  rating INT
);

INSERT INTO module.rating_table VALUES
('2023-04-24 10:15:00','a',0,4),
('2023-04-24 15:20:27','a',1,5),
('2023-04-24 22:32:27','a',2,5),
('2023-04-25 08:00:00','a',3,1),
('2023-04-25 12:00:00','a',4,4),
('2023-04-25 12:30:00','a',5,5),
('2023-04-24 09:15:00','b',6,3),
('2023-04-23 19:20:00','b',7,2),
('2023-04-25 09:45:00','b',8,5),
('2023-04-25 11:30:00','b',9,4),
('2023-04-25 14:00:00','b',10,5),
('2023-04-24 08:30:00','c',11,5);


/*113)A Cab booking company has a dataset of its trip ratings, each row represents a single trip of a driver. 
A trip has a positive rating if it was rated 4 or above, a streak of positive ratings is when a driver has a rating of
 4 and above in consecutive trips. example: If there are 3 consecutive trips with a rating of 4 or above then the streak is 2.
Find out the maximum streak that a driver has had and sort the output in descending order of their maximum streak and 
then by descending order of driver_id.
Note: only users who have at least 1 streak should be included in the output.
*/
WITH ordered AS (
  SELECT
    driver_id,
    trip_time,
    rating,
    SUM(CASE WHEN rating < 4 THEN 1 ELSE 0 END)
      OVER (PARTITION BY driver_id ORDER BY trip_time, trip_id) AS blk
  FROM module.rating_table
),
runs AS (
  SELECT driver_id, blk, COUNT(*) AS run_len
  FROM ordered
  WHERE rating >= 4
  GROUP BY driver_id, blk
),
mx AS (
  SELECT driver_id, MAX(run_len) - 1 AS max_streak
  FROM runs
  GROUP BY driver_id
)
SELECT driver_id, max_streak
FROM mx
WHERE max_streak >= 1
ORDER BY max_streak DESC, driver_id DESC;
