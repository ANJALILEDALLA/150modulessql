
DROP TABLE IF EXISTS module.youtube_videos;
DROP TABLE IF EXISTS module.creators;


CREATE TABLE module.creators (
  id        INT,
  name      VARCHAR(10),
  platform  VARCHAR(10),
  followers INT
);


CREATE TABLE module.youtube_videos (
  id           INT,
  creator_id   INT,
  publish_date DATE,
  views        INT
);


INSERT INTO module.creators (id, name, platform, followers) VALUES
(100, 'Ankit',   'YouTube',    90000),
(100, 'Ankit',   'LinkedIn',  150000),
(101, 'Warikoo', 'YouTube',   500000),
(101, 'Warikoo', 'LinkedIn',  600000),
(101, 'Warikoo', 'Instagram', 800000),
(102, 'Dhruv',   'LinkedIn',   60000),
(102, 'Dhruv',   'YouTube',   900000),
(102, 'Dhruv',   'Instagram', 800000),
(103, 'Ravi',    'YouTube',   100000),
(103, 'Ravi',    'LinkedIn',  120000),
(103, 'Ravi',    'Instagram',  95000);


INSERT INTO module.youtube_videos (id, creator_id, publish_date, views) VALUES
(1, 100, '2024-01-01', 52000),
(2, 100, '2024-01-06', 62000),
(3, 101, '2024-01-05', 59000),
(4, 101, '2024-01-07', 22000),
(5, 102, '2024-01-05', 70000),
(6, 102, '2024-01-09', 90000),
(7, 103, '2024-01-11', 48000),
(8, 103, '2024-01-12', 53000),
(9, 104, '2024-01-15', 76000),
(10,104, '2024-01-17', 81000),
(11,105, '2024-01-20', 95000);  
/*25)"boAt Lifestyle is focusing on influencer marketing to build and scale their brand.
 They want to partner with power creators for their upcoming campaigns. 
 The creators should satisfy below conditions to qualify:
 1- They should have 100k+ followers on at least 2 social media platforms and
 2- They should have at least 50k+ views on their latest YouTube video. 
Write an SQL to get creator id and name satisfying above conditions.*/


SELECT c.creator_id, c.name
FROM (
   SELECT
    id AS creator_id,
    MIN(name) AS name
  FROM module.creators
  GROUP BY id
  HAVING SUM(followers >= 100000) >= 2
) AS c
JOIN (
  SELECT v1.creator_id
  FROM module.youtube_videos v1
  JOIN (
    SELECT creator_id, MAX(publish_date) AS max_date
    FROM module.youtube_videos
    GROUP BY creator_id
  ) AS mx
    ON mx.creator_id = v1.creator_id
   AND v1.publish_date = mx.max_date
  WHERE v1.views >= 50000
) AS y
  ON y.creator_id = c.creator_id
ORDER BY c.creator_id;


