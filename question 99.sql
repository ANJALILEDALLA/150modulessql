DROP TABLE IF EXISTS module.entries;
CREATE TABLE module.entries(
  emp_name VARCHAR(10),
  address VARCHAR(10),
  floor INT,
  resources VARCHAR(10)
);

INSERT INTO module.entries VALUES
('Ankit','Bangalore',1,'CPU'),
('Ankit','Bangalore',1,'CPU'),
('Ankit','Bangalore',2,'DESKTOP'),
('Bikaas','Bangalore',2,'DESKTOP'),
('Bikaas','Bangalore',2,'DESKTOP'),
('Bikaas','Bangalore',1,'MONITOR');

/*99)"You are a facilities manager at a corporate office building, responsible for tracking employee visits, 
floor preferences, and resource usage within the premises. The office building has multiple floors,
 each equipped with various resources such as desks, computers, monitors, and other office supplies.
 You have a database table “entries” that stores information about employee visits to the office building. 
 Each record in the table represents a visit by an employee and includes details such as their name, 
 the floor they visited, and the resources they used during their visit. Write an SQL query to retrieve the total visits,
 most visited floor, 
and resources used by each employee, display the output in ascending order of employee name.*/

WITH f AS (
  SELECT emp_name, floor, COUNT(*) AS cnt
  FROM module.entries
  GROUP BY emp_name, floor
),
m AS (
  SELECT emp_name, floor AS most_visited_floor
  FROM (
    SELECT emp_name, floor, cnt,
           DENSE_RANK() OVER(PARTITION BY emp_name ORDER BY cnt DESC, floor ASC) AS rk
    FROM f
  ) q
  WHERE rk = 1
),
r AS (
  SELECT emp_name, GROUP_CONCAT(DISTINCT resources ORDER BY resources) AS resources_used
  FROM module.entries
  GROUP BY emp_name
),
t AS (
  SELECT emp_name, COUNT(*) AS total_visits
  FROM module.entries
  GROUP BY emp_name
)
SELECT t.emp_name, t.total_visits, m.most_visited_floor, r.resources_used
FROM t
JOIN m USING(emp_name)
JOIN r USING(emp_name)
ORDER BY t.emp_name;
