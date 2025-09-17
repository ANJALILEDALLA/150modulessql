DROP TABLE IF EXISTS module.students;
CREATE TABLE module.students (
  id INT,
  name VARCHAR(50)
);

DROP TABLE IF EXISTS module.friends;
CREATE TABLE module.friends (
  id INT,
  friend_id INT
);

DROP TABLE IF EXISTS module.packages;
CREATE TABLE module.packages (
  id INT,
  salary INT
);

INSERT INTO module.students VALUES
(1,'Alice'),(2,'Bob'),(3,'Charlie'),(4,'Diana'),(5,'Eve');

INSERT INTO module.friends VALUES
(1,2),(1,3),
(2,1),(2,3),
(3,1),(3,2),
(4,5),
(5,1);

INSERT INTO module.packages VALUES
(1,50000),(2,60000),(3,70000),(4,40000),(5,30000);

/*127)"You are given three tables: students, friends and packages. Friends table has student id and friend id(only best friend).
 A student can have more than one best friends. Write a query to output the names of those students whose ALL friends got offered
 a higher salary than them.
 Display those students name and difference between their salary and average of their friends salaries.*/

WITH agg AS (
  SELECT
    f.id AS student_id,
    ps.salary AS student_salary,
    AVG(pf.salary) AS avg_friend_salary,
    MIN(pf.salary) AS min_friend_salary
  FROM module.friends f
  JOIN module.packages ps ON ps.id = f.id
  JOIN module.packages pf ON pf.id = f.friend_id
  GROUP BY f.id, ps.salary
)
SELECT s.name,
       (a.avg_friend_salary - a.student_salary) AS diff_from_avg_friends
FROM agg a
JOIN module.students s ON s.id = a.student_id
WHERE a.min_friend_salary > a.student_salary
ORDER BY s.name;
