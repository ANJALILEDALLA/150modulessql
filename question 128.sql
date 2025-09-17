DROP TABLE IF EXISTS module.train_schedule;
CREATE TABLE module.train_schedule (
  station_id INT,
  train_id INT,
  arrival_time TIME,
  departure_time TIME
);

INSERT INTO module.train_schedule VALUES
(100,1,'08:00:00','08:15:00'),
(100,2,'08:05:00','08:10:00'),
(100,3,'08:05:00','08:20:00'),
(100,4,'08:10:00','08:20:00'),
(100,5,'08:10:00','08:25:00'),
(100,6,'12:15:00','12:20:00'),
(100,7,'12:25:00','12:30:00'),
(100,8,'12:25:00','12:30:00'),
(100,9,'11:50:00','15:10:00'),
(100,10,'15:00:00','15:10:00'),
(100,11,'15:06:00','15:15:00'),
(100,12,'15:06:00','15:15:00');


/*128)"You are given a table of train schedule which contains the arrival and departure times of trains at each station on
 a given day. At each station one platform can accommodate only one train at a time, from the beginning of the minute the 
 train arrives until the end of the minute it departs. Write a query to find the minimum number of platforms 
required at each station to handle all train traffic to ensure that no two trains overlap at any station.*/
WITH events AS (
  SELECT station_id, arrival_time AS t, 1  AS delta
  FROM module.train_schedule
  UNION ALL
  SELECT station_id, ADDTIME(departure_time,'00:01:00') AS t, -1 AS delta
  FROM module.train_schedule
),
running AS (
  SELECT
    station_id,
    t,
    SUM(delta) OVER (PARTITION BY station_id ORDER BY t
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS in_use
  FROM events
)
SELECT station_id,
       MAX(in_use) AS min_platforms_required
FROM running
GROUP BY station_id
ORDER BY station_id;
