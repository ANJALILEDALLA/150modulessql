DROP TABLE IF EXISTS module.students;
CREATE TABLE module.students (
  student_id INT,
  course_name VARCHAR(10),
  score INT
);

INSERT INTO module.students VALUES
(1,'Math',85),
(1,'Science',65),
(2,'Math',90),
(2,'Science',75),
(3,'Math',60),
(3,'Science',70),
(4,'Math',95),
(4,'Science',85),
(5,'Math',50),
(5,'Science',80),
(6,'English',80);

/*106)Write an SQL query to find the course names where the average score (calculated only for students who have 
scored less than 70 in at least one course) is greater than 70. Sort the result by the average score in descending order.*/

WITH eligible AS (
  SELECT student_id
  FROM module.students
  GROUP BY student_id
  HAVING MIN(score) < 70
),
f AS (
  SELECT s.course_name, s.score
  FROM module.students s
  JOIN eligible e USING (student_id)
)
SELECT course_name, ROUND(AVG(score),2) AS avg_score
FROM f
GROUP BY course_name
HAVING AVG(score) > 70
ORDER BY avg_score DESC;
