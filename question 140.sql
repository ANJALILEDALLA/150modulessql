DROP TABLE IF EXISTS module.teams;
CREATE TABLE module.teams (
  team_id INT,
  team_name VARCHAR(50)
);

DROP TABLE IF EXISTS module.matches;
CREATE TABLE module.matches (
  match_id INT,
  host_team INT,
  guest_team INT,
  host_goals INT,
  guest_goals INT
);

INSERT INTO module.teams VALUES
(10,'Give'),
(20,'Never'),
(30,'You'),
(40,'Up'),
(50,'Gonna');

INSERT INTO module.matches VALUES
(1,30,20,1,0),
(2,10,20,1,2),
(3,20,50,2,2),
(4,10,30,1,0),
(5,30,50,0,1);

WITH pts AS (
  SELECT host_team AS team_id,
         CASE WHEN host_goals > guest_goals THEN 3
              WHEN host_goals = guest_goals THEN 1 ELSE 0 END AS p
  FROM module.matches
  UNION ALL
  SELECT guest_team,
         CASE WHEN guest_goals > host_goals THEN 3
              WHEN guest_goals = host_goals THEN 1 ELSE 0 END
  FROM module.matches
)
SELECT t.team_id, t.team_name, COALESCE(SUM(p.p),0) AS num_points
FROM module.teams t
LEFT JOIN pts p ON p.team_id = t.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
