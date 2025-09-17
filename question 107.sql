DROP TABLE IF EXISTS module.logs;
CREATE TABLE module.logs (
  log_id INT
);

INSERT INTO module.logs (log_id) VALUES
(1),(2),(3),(7),(8),(10),(12),(13),(14),(15),(16);


/*107)Write an SQL query to find all the contiguous ranges of log_id values.*/
WITH s AS (
  SELECT
    log_id,
    log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
  FROM module.logs
)
SELECT
  MIN(log_id) AS start_id,
  MAX(log_id) AS end_id
FROM s
GROUP BY grp
ORDER BY start_id;
