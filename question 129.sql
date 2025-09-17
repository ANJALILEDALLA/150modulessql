DROP TABLE IF EXISTS module.drivers;
CREATE TABLE module.drivers (
  driver_id INT,
  join_date DATE
);

DROP TABLE IF EXISTS module.rides;
CREATE TABLE module.rides (
  ride_id INT,
  ride_date DATE,
  driver_id INT
);

DROP TABLE IF EXISTS module.calendar_dim;
CREATE TABLE module.calendar_dim (
  cal_date DATE
);

INSERT INTO module.drivers VALUES
(1,'2023-01-05'),
(2,'2023-02-15'),
(3,'2023-03-10'),
(4,'2023-01-03'),
(5,'2023-07-01'),
(6,'2023-08-01'),
(7,'2023-05-20');

INSERT INTO module.rides VALUES
(1,'2023-01-05',1),
(2,'2023-01-20',1),
(3,'2023-02-15',1),
(4,'2023-02-20',2),
(5,'2023-03-01',2),
(6,'2023-03-15',3),
(7,'2023-03-25',3),
(8,'2023-04-10',3),
(9,'2023-07-05',5),
(10,'2023-08-05',5),
(11,'2023-09-15',5),
(12,'2023-06-01',7);

INSERT INTO module.calendar_dim (cal_date)
SELECT DATE('2023-01-01') + INTERVAL n DAY
FROM (
  SELECT a.n + b.n*10 + c.n*100 AS n
  FROM (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
  CROSS JOIN
       (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
  CROSS JOIN
       (SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) c
) seq
WHERE n BETWEEN 0 AND 364;

/*129)We have a driver table which has driver id and join date for each Uber drivers. We have another table rides where we have
 ride id, ride date and driver id.  A driver becomes inactive if he doesn't have any ride for consecutive 28 days after 
 joining the company. Driver can become active again once he takes a new ride. We need to find number of active drivers 
 for uber at the end of each month for year 2023.
For example if a driver joins Uber on Jan 15th and takes his first ride on March 15th. He will be considered active for 
Jan month end , Not active for Feb month end but active for March month end.
*/
WITH events AS (
  SELECT driver_id, join_date AS event_date FROM module.drivers
  UNION ALL
  SELECT driver_id, ride_date FROM module.rides
),
month_ends AS (
  SELECT cal_date AS month_end
  FROM module.calendar_dim
  WHERE YEAR(cal_date)=2023 AND cal_date = LAST_DAY(cal_date)
),
latest AS (
  SELECT d.driver_id, m.month_end, MAX(e.event_date) AS last_event
  FROM module.drivers d
  CROSS JOIN month_ends m
  LEFT JOIN events e
    ON e.driver_id = d.driver_id
   AND e.event_date <= m.month_end
  GROUP BY d.driver_id, m.month_end
)
SELECT
  month_end,
  COUNT(*) AS active_drivers
FROM latest
WHERE DATEDIFF(month_end, last_event) <= 28
GROUP BY month_end
ORDER BY month_end;
