DROP TABLE IF EXISTS module.DETAILED_OOS_EVENTS;
CREATE TABLE module.DETAILED_OOS_EVENTS (
  MASTER_ID       VARCHAR(20) NOT NULL,
  MARKETPLACE_ID  INT         NOT NULL,
  OOS_DATE        DATE        NOT NULL,
  PRIMARY KEY (MASTER_ID, MARKETPLACE_ID, OOS_DATE)
);

INSERT INTO module.DETAILED_OOS_EVENTS (MASTER_ID, MARKETPLACE_ID, OOS_DATE) VALUES
('P04G', 13, '2023-07-03'),
('P04G', 13, '2023-07-04'),
('P04G', 13, '2024-06-30'),
('P04G', 13, '2024-07-01'),
('P04G', 13, '2024-07-02'),
('P04G', 13, '2024-07-03'),
('P04G', 13, '2024-07-04'),
('P04G', 13, '2024-07-05'),
('P04G', 13, '2024-07-06'),
('P04G', 13, '2024-07-07'),
('P04G', 13, '2024-07-08'),
('P04G', 13, '2024-07-09');

/*144)You are working with a large dataset of out-of-stock (OOS) events for products across multiple marketplaces.
Each record in the dataset represents an OOS event for a specific product (MASTER_ID) in a specific marketplace (MARKETPLACE_ID)
 on a specific date (OOS_DATE). The combination of (MASTER_ID, MARKETPLACE_ID, OOS_DATE) is always unique. Your task is to
 identify key OOS event dates for each product and marketplace combination.

Steps to identify key OOS events :
Identify the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID).
Recursively find the next OOS event that occurs at least 7 days after the previous event.
Continue this process until no more OOS events meet the condition.
*/
WITH RECURSIVE seed AS (
  SELECT MASTER_ID, MARKETPLACE_ID, MIN(OOS_DATE) AS OOS_DATE
  FROM module.DETAILED_OOS_EVENTS
  GROUP BY MASTER_ID, MARKETPLACE_ID
),
chain AS (
  SELECT MASTER_ID, MARKETPLACE_ID, OOS_DATE
  FROM seed
  UNION ALL
  SELECT
      c.MASTER_ID,
      c.MARKETPLACE_ID,
      (
        SELECT MIN(e.OOS_DATE)
        FROM module.DETAILED_OOS_EVENTS e
        WHERE e.MASTER_ID = c.MASTER_ID
          AND e.MARKETPLACE_ID = c.MARKETPLACE_ID
          AND e.OOS_DATE >= DATE_ADD(c.OOS_DATE, INTERVAL 7 DAY)
      ) AS OOS_DATE
  FROM chain c
  WHERE (
        SELECT MIN(e.OOS_DATE)
        FROM module.DETAILED_OOS_EVENTS e
        WHERE e.MASTER_ID = c.MASTER_ID
          AND e.MARKETPLACE_ID = c.MARKETPLACE_ID
          AND e.OOS_DATE >= DATE_ADD(c.OOS_DATE, INTERVAL 7 DAY)
      ) IS NOT NULL
)
SELECT MASTER_ID, MARKETPLACE_ID, OOS_DATE
FROM chain
ORDER BY MASTER_ID, MARKETPLACE_ID, OOS_DATE;
