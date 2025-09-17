DROP TABLE IF EXISTS module.student_courses;
CREATE TABLE module.student_courses (
  student_id INT,
  course_id INT,
  major_flag VARCHAR(1)
);

INSERT INTO module.student_courses VALUES
(1,101,'N'),
(2,101,'Y'),
(2,102,'N'),
(3,103,'Y'),
(4,102,'N'),
(4,103,'Y'),
(4,104,'N'),
(5,104,'N');

/*105)You are provided with information about students enrolled in various courses at a university.
 Each student can be enrolled in multiple courses, and for each course, it is specified whether the course is a major or an elective for the student. 
 Write a SQL query to generate a report that lists the primary (major_flag='Y') course for each student. 
 If a student is enrolled in only one course, that course should be considered their primary course by default irrespective of the flag. 
Sort the output by student_id.*/

WITH ranked AS (
  SELECT
    student_id,
    course_id,
    ROW_NUMBER() OVER (
      PARTITION BY student_id
      ORDER BY CASE WHEN major_flag='Y' THEN 0 ELSE 1 END, course_id
    ) AS rn
  FROM module.student_courses
)
SELECT student_id, course_id
FROM ranked
WHERE rn = 1
ORDER BY student_id;
