DROP TABLE IF EXISTS module.students;

CREATE TABLE module.students (
  student_id INT,
  skill      VARCHAR(50)
);

INSERT INTO module.students (student_id, skill) VALUES
(1,'SQL'),
(2,'Python'),
(2,'SQL'),
(3,'Python'),
(4,'SQL'),
(5,'Excel'),
(5,'SQL'),
(6,'SQL'),
(6,'Python'),
(8,'sql'),   
(9,'Excel');


/*147)Each row represents a skill that a student knows. A student can appear multiple times in the table if they have\
 multiple skills. 
Write a SQL query to return the student_ids of students who only know the skill 'SQL'. Sort the result by student id.*/
SELECT student_id
FROM module.students
GROUP BY student_id
HAVING COUNT(*) = SUM(LOWER(skill) = 'sql')
ORDER BY student_id;
