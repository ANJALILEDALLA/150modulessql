DROP TABLE IF EXISTS module.events;
DROP TABLE IF EXISTS module.users;

CREATE TABLE module.users (
  user_id INT PRIMARY KEY,
  name VARCHAR(15)
);

CREATE TABLE module.events (
  user_id INT,
  type VARCHAR(15),
  access_date DATE
);

INSERT INTO module.users (user_id, name) VALUES
(1,'Saurabh'),
(2,'Amit'),
(3,'Ankit');

INSERT INTO module.events (user_id, type, access_date) VALUES
(1,'Amazon Music','2024-01-05'),
(1,'Amazon Video','2024-01-07'),
(1,'Prime','2024-01-08'),
(2,'Amazon Video','2024-01-09'),
(2,'Amazon Pay','2024-01-08'),
(2,'Prime','2024-01-09'),
(2,'Amazon Pay','2024-01-07'),
(3,'Amazon Music','2024-01-09');


/*63)Amazon, the world's largest online retailer, offers various services to its customers, including Amazon 
Prime membership, Video streaming, Amazon Music, Amazon Pay, and more. The company is interested in analyzing which of 
its services are most effective at converting regular customers into Amazon Prime members.
You are given a table of events which consists services accessed by each users along with service access date.
 This table also contains the event when customer bought the prime membership (type='prime').
Write an SQL to get date when each customer became prime member, last service used and last service access date
 (just before becoming prime member). If a customer never became prime member, then populate only the last service 
 used and last service access date by the customer, display the output in ascending order of last service access date.
*/
WITH prime AS (
  SELECT user_id, MIN(access_date) AS prime_date
  FROM module.events
  WHERE LOWER(type)='prime'
  GROUP BY user_id
),
last_before_prime AS (
  SELECT user_id, type, access_date, 
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY access_date DESC) AS rn
  FROM (
    SELECT e.*
    FROM module.events e
    JOIN prime p ON p.user_id = e.user_id
    WHERE e.access_date < p.prime_date
  ) x
),
last_any AS (
  SELECT user_id, type, access_date,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY access_date DESC) AS rn
  FROM module.events
)
SELECT
  u.user_id,
  u.name,
  p.prime_date,
  COALESCE(lb.type, la.type) AS last_service_used,
  COALESCE(lb.access_date, la.access_date) AS last_service_access_date
FROM module.users u
LEFT JOIN prime p ON p.user_id = u.user_id
LEFT JOIN last_before_prime lb ON lb.user_id = u.user_id AND lb.rn = 1
LEFT JOIN last_any la ON la.user_id = u.user_id AND la.rn = 1
ORDER BY last_service_access_date ASC;
