DROP TABLE IF EXISTS module.service_status;

CREATE TABLE module.service_status (
  service_name VARCHAR(4),
  status VARCHAR(4),
  updated_time DATETIME
);

INSERT INTO module.service_status (service_name, status, updated_time) VALUES
('hdfs','up','2024-03-06 10:01:00'),
('hdfs','down','2024-03-06 10:02:00'),
('hdfs','down','2024-03-06 10:03:00'),
('hdfs','down','2024-03-06 10:04:00'),
('hdfs','down','2024-03-06 10:05:00'),
('hdfs','down','2024-03-06 10:06:00'),
('hdfs','down','2024-03-06 10:07:00');


/*65)You are a DevOps engineer responsible for monitoring the health and status of various services in your organization's
 infrastructure. Your team conducts canary tests on each service every minute to ensure their reliability and performance. 
 As part of your responsibilities, you need to develop a SQL to identify any service that experiences continuous downtime 
 for at least 5 minutes 
so that team can find the root cause and fix the issue. Display the output in descending order of service down minutes.*/
WITH d AS (
  SELECT
    service_name,
    updated_time,
    ROW_NUMBER() OVER (PARTITION BY service_name ORDER BY updated_time) AS rn
  FROM module.service_status
  WHERE status='down'
),
g AS (
  SELECT
    service_name,
    updated_time,
    TIMESTAMPDIFF(MINUTE,'1970-01-01 00:00:00',updated_time) - rn AS grp
  FROM d
),
agg AS (
  SELECT
    service_name,
    MIN(updated_time) AS start_time,
    MAX(updated_time) AS end_time,
    COUNT(*) AS down_minutes
  FROM g
  GROUP BY service_name, grp
)
SELECT service_name, start_time, end_time, down_minutes
FROM agg
WHERE down_minutes >= 5
ORDER BY down_minutes DESC, service_name;
