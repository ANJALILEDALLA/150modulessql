DROP TABLE IF EXISTS module.`usage`;
DROP TABLE IF EXISTS module.users;

CREATE TABLE module.users (
  user_id           VARCHAR(10),
  registration_date DATE
);

INSERT INTO module.users (user_id, registration_date) VALUES
('aaa','2019-01-03'),
('bbb','2019-01-02'),
('ccc','2019-01-15'),
('ddd','2019-02-07'),
('eee','2019-02-08');

CREATE TABLE module.`usage` (
  user_id    VARCHAR(10),
  usage_date DATE,
  location   VARCHAR(20),
  time_spent INT
);

INSERT INTO module.`usage` (user_id, usage_date, location, time_spent) VALUES
('aaa','2019-01-03','US',38),
('aaa','2019-02-01','US',12),
('aaa','2019-03-04','US',30),
('bbb','2019-01-03','US',20),
('bbb','2019-02-04','Canada',31),
('ccc','2019-01-16','US',40),
('ddd','2019-02-08','US',45),
('eee','2019-02-10','US',20),
('eee','2019-02-20','CANADA',12),
('eee','2019-03-15','US',21),
('eee','2019-04-25','US',12);

/*146)*/

SELECT
  DATE_FORMAT(u.registration_date, '%Y-%m') AS registration_month,
  COUNT(*) AS total_users,
  ROUND(100 * AVG(
    COALESCE((
      SELECT SUM(x.time_spent)
      FROM module.`usage` x
      WHERE x.user_id = u.user_id
        AND x.usage_date >= u.registration_date
        AND x.usage_date <  DATE_ADD(u.registration_date, INTERVAL 1 MONTH)
    ),0) >= 30), 2) AS m1_retention,
  ROUND(100 * AVG(
    COALESCE((
      SELECT SUM(x.time_spent)
      FROM module.`usage` x
      WHERE x.user_id = u.user_id
        AND x.usage_date >= DATE_ADD(u.registration_date, INTERVAL 1 MONTH)
        AND x.usage_date <  DATE_ADD(u.registration_date, INTERVAL 2 MONTH)
    ),0) >= 30), 2) AS m2_retention,
  ROUND(100 * AVG(
    COALESCE((
      SELECT SUM(x.time_spent)
      FROM module.`usage` x
      WHERE x.user_id = u.user_id
        AND x.usage_date >= DATE_ADD(u.registration_date, INTERVAL 2 MONTH)
        AND x.usage_date <  DATE_ADD(u.registration_date, INTERVAL 3 MONTH)
    ),0) >= 30), 2) AS m3_retention
FROM module.users u
GROUP BY DATE_FORMAT(u.registration_date, '%Y-%m')
ORDER BY registration_month;

