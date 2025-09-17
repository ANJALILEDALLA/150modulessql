DROP TABLE IF EXISTS module.viewing_history;
CREATE TABLE module.viewing_history(
  user_id INT,
  title VARCHAR(20),
  device_type VARCHAR(10)
);

INSERT INTO module.viewing_history VALUES
(1,'Stranger Things','Mobile'),
(1,'The Crown','Mobile'),
(1,'Narcos','Smart TV'),
(2,'Stranger Things','Mobile'),
(2,'The Crown','Tablet'),
(2,'Narcos','Mobile'),
(3,'Stranger Things','Mobile'),
(3,'The Crown','Mobile'),
(3,'Narcos','Mobile'),
(4,'Stranger Things','Mobile'),
(4,'The Crown','Smart TV'),
(4,'Narcos','Tablet');

/*89)"In the Netflix viewing history dataset, you are tasked with identifying viewers who have a 
consistent viewing pattern across multiple devices. Specifically, viewers who have watched the same title on 
more than 1 device type. Write an SQL query to find users who have watched more number of titles on multiple 
devices than the number of titles they watched on single device. Output the user id , no of titles watched on 
multiple devices and no of titles watched on single device, display the output in ascending order of user_id.*/

WITH per_title AS (
  SELECT user_id, title, COUNT(DISTINCT device_type) AS dev_cnt
  FROM module.viewing_history
  GROUP BY user_id, title
),
agg AS (
  SELECT user_id,
         SUM(CASE WHEN dev_cnt > 1 THEN 1 ELSE 0 END) AS multi_titles,
         SUM(CASE WHEN dev_cnt = 1 THEN 1 ELSE 0 END) AS single_titles
  FROM per_title
  GROUP BY user_id
)
SELECT user_id, multi_titles, single_titles
FROM agg
WHERE multi_titles > single_titles
ORDER BY user_id;
