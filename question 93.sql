DROP TABLE IF EXISTS module.ott_viewership;
CREATE TABLE module.ott_viewership(
  viewer_id INT,
  show_id INT,
  show_name VARCHAR(20),
  genre VARCHAR(10),
  country VARCHAR(15),
  view_date DATE,
  duration_min INT
);

INSERT INTO module.ott_viewership VALUES
(1,101,'Stranger Things','Drama','United States','2023-05-01',120),
(2,102,'The Crown','Drama','United States','2023-05-01',90),
(3,103,'Breaking Bad','Drama','United States','2023-05-02',110),
(4,104,'Game of Thrones','Fantasy','United States','2023-05-02',95),
(5,105,'The Mandalorian','Sci-Fi','United States','2023-05-01',130),
(6,106,'The Witcher','Fantasy','United States','2023-05-03',80),
(7,107,'Friends','Comedy','United States','2023-05-01',85),
(8,108,'Brooklyn Nine-Nine','Comedy','Canada','2023-05-01',75),
(9,109,'The Office','Comedy','United States','2023-05-02',100),
(10,110,'Parks and Recreation','Comedy','United States','2023-05-03',70),
(11,101,'Stranger Things','Drama','United States','2023-05-03',95);

/*94)"You have a table named ott_viewership. Write an SQL query to find the top 2 most-watched shows in each genre 
in the United States. Return the show name, genre, and total duration watched for 
each of the top 2 most-watched shows in each genre. sort the result by genre and total duration.*/

WITH us AS (
  SELECT show_name, genre, SUM(duration_min) AS total_duration
  FROM module.ott_viewership
  WHERE country = 'United States'
  GROUP BY show_name, genre
),
r AS (
  SELECT *,
         DENSE_RANK() OVER (PARTITION BY genre ORDER BY total_duration DESC) AS rk
  FROM us
)
SELECT show_name, genre, total_duration
FROM r
WHERE rk <= 2
ORDER BY genre, total_duration DESC;
