DROP TABLE IF EXISTS module.viewing_history;
CREATE TABLE module.viewing_history(
  user_id INT,
  title VARCHAR(20),
  device_type VARCHAR(10),
  watch_mins INT
);

INSERT INTO module.viewing_history VALUES
(1,'Stranger Things','Mobile',60),
(1,'The Crown','Mobile',45),
(1,'Narcos','Smart TV',90),
(2,'Stranger Things','Mobile',100),
(2,'The Crown','Tablet',55),
(2,'Narcos','Mobile',95),
(3,'Stranger Things','Mobile',40),
(3,'The Crown','Mobile',60),
(3,'Narcos','Mobile',70),
(4,'Stranger Things','Mobile',70),
(4,'The Crown','Smart TV',65),
(4,'Narcos','Tablet',80);

/*88)"In the Netflix dataset containing information about viewers and their viewing history, devise a query to identify 
viewers who primarily use mobile devices for viewing, but occasionally switch to other devices. Specifically,
 find viewers who have watched at least 75% of their total viewing time on mobile devices but have also used at
 least one other devices such as tablets or smart TVs for viewing.
 Provide the user ID and the percentage of viewing time spent on mobile devices. Round the result to nearest integer.*/

SELECT
  user_id,
  ROUND(100.0 * SUM(CASE WHEN device_type='Mobile' THEN watch_mins ELSE 0 END) /
        SUM(watch_mins)) AS mobile_pct
FROM module.viewing_history
GROUP BY user_id
HAVING ROUND(100.0 * SUM(CASE WHEN device_type='Mobile' THEN watch_mins ELSE 0 END) /
             SUM(watch_mins)) >= 75
   AND COUNT(DISTINCT CASE WHEN device_type <> 'Mobile' THEN device_type END) >= 1
ORDER BY user_id;
