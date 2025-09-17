DROP TABLE IF EXISTS module.malware;
CREATE TABLE module.malware (
    software_id INT,
    run_date DATETIME,
    malware_detected INT
);

INSERT INTO module.malware VALUES
(100, '2024-01-01 02:00:01', 12),
(100, '2024-01-01 03:12:01', 15),
(100, '2024-01-01 16:00:01', 9),
(101, '2024-01-01 12:00:00', 7),
(101, '2024-01-01 16:00:00', 19),
(102, '2024-01-01 12:00:00', 20),
(102, '2024-01-01 14:00:00', 13),
(103, '2024-01-01 17:00:00', 11),
(103, '2024-01-01 18:30:00', 16),
(104, '2024-01-01 18:30:00', 8);

/*28)"There are multiple antivirus software which are running on the system and you have 
the data of how many malware they have detected in each run.
 You need to find out how many malwares each software has detected in their latest run and 
 what is the difference between the number of malwares detected in latest run and the second last run for each software. 
Please note that list only the software which have run for at least 2 times and
 have detected at least 10 malware in the latest run.*/
SELECT software_id,
       MAX(CASE WHEN rn = 1 THEN malware_detected END) AS latest_malware,
       MAX(CASE WHEN rn = 2 THEN malware_detected END) AS second_latest_malware,
       MAX(CASE WHEN rn = 1 THEN malware_detected END) - MAX(CASE WHEN rn = 2 THEN malware_detected END) AS difference
FROM (
    SELECT software_id,
           run_date,
           malware_detected,
           ROW_NUMBER() OVER (PARTITION BY software_id ORDER BY run_date DESC) AS rn,
           COUNT(*) OVER (PARTITION BY software_id) AS total_runs
    FROM module.malware
) t
WHERE total_runs >= 2
GROUP BY software_id
HAVING MAX(CASE WHEN rn = 1 THEN malware_detected END) >= 10;
