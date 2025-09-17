CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.team;
CREATE TABLE module.team (
  id INT,
  name VARCHAR(20),
  coach VARCHAR(20)
);

DROP TABLE IF EXISTS module.game;
CREATE TABLE module.game (
  match_id INT,
  match_date DATE,
  stadium VARCHAR(20),
  team1 INT,
  team2 INT
);

DROP TABLE IF EXISTS module.goal;
CREATE TABLE module.goal (
  match_id INT,
  team_id INT,
  player VARCHAR(20),
  goal_time TIME
);

INSERT INTO module.team VALUES
(1,'Mumbai FC','Sunil Chhetri'),
(2,'Delhi Dynamos','Sandesh Jhingan'),
(3,'Bengaluru FC','Gurpreet Singh'),
(4,'Goa FC','Brandon Fernandes');

INSERT INTO module.game VALUES
(1,'2024-09-01','Wankhede',1,2),
(2,'2024-09-02','Jawaharlal Nehru',3,4),
(3,'2024-09-03','Sree Kanteerava',1,3),
(4,'2024-09-04','Wankhede',1,4);

INSERT INTO module.goal VALUES
(1,1,'Anirudh Thapa','18:23:00'),
(1,1,'Sunil Chhetri','67:12:00'),
(2,3,'Udanta Singh','22:45:00'),
(2,4,'Ferran Corominas','55:21:00'),
(2,3,'Sunil Chhetri','78:34:00'),
(3,1,'Bipin Singh','11:08:00'),
(3,3,'Cleiton Silva','41:20:00'),
(3,1,'Sunil Chhetri','59:45:00'),
(3,3,'Cleiton Silva','62:56:00');


/*116)Please refer to the 3 tables below from a football tournament. Write an SQL which lists every game with the goals 
scored by each team. The result set should show: match id, match date, team1, score1, team2, score2. 
Sort the result by match id.

Please note that score1 and score2 should be number of goals scored by team1 and team2 respectively.
*/
WITH agg AS (
  SELECT match_id, team_id, COUNT(*) AS goals
  FROM module.goal
  GROUP BY match_id, team_id
)
SELECT
  g.match_id,
  g.match_date,
  t1.name AS team1,
  COALESCE(a1.goals,0) AS score1,
  t2.name AS team2,
  COALESCE(a2.goals,0) AS score2
FROM module.game g
JOIN module.team t1 ON t1.id = g.team1
JOIN module.team t2 ON t2.id = g.team2
LEFT JOIN agg a1 ON a1.match_id = g.match_id AND a1.team_id = g.team1
LEFT JOIN agg a2 ON a2.match_id = g.match_id AND a2.team_id = g.team2
ORDER BY g.match_id;
