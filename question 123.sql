DROP TABLE IF EXISTS module.assessments;
CREATE TABLE module.assessments (
  candidate_id INT,
  experience INT,
  sql_score INT,
  algo INT,
  bug_fixing INT
);

INSERT INTO module.assessments VALUES
(1,3,100,NULL,50),
(2,5,100,100,100),
(3,1,100,100,100),
(4,5,100,50,NULL),
(5,6,100,NULL,NULL),
(6,5,100,50,NULL),
(7,8,100,40,NULL),
(8,10,100,NULL,NULL),
(9,10,100,100,NULL),
(10,1,100,100,100);


/*123)"You are given a table named assessments that contains information about candidate evaluations for various technical tasks.
 Each row in the table represents a candidate and includes their years of experience, along with scores for three
 different tasks: SQL, Algorithms, and Bug Fixing. A NULL value in any of the task columns indicates that the candidate was 
 not required to solve that specific task. Your task is to analyze this data and determine, for each experience level, 
 the total number of candidates and how many of them achieved a ""perfect score."" A candidate is considered to have achieved 
 a ""perfect score"" if they score 100 in every task they were requested to solve. The output should include the experience level, 
 the total number of candidates for each level, 
and the count of candidates who achieved a ""perfect score."" The result should be ordered by experience level.*/
SELECT
  experience,
  COUNT(*) AS total_candidates,
  SUM(CASE
        WHEN COALESCE(sql_score,100)=100
         AND COALESCE(algo,100)=100
         AND COALESCE(bug_fixing,100)=100
        THEN 1 ELSE 0
      END) AS perfect_count
FROM module.assessments
GROUP BY experience
ORDER BY experience;
