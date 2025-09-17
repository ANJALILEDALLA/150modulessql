DROP TABLE IF EXISTS module.icc_world_cup;
CREATE TABLE module.icc_world_cup (
    team_1 VARCHAR(10),
    team_2 VARCHAR(10),
    winner VARCHAR(10)
);

INSERT INTO module.icc_world_cup VALUES
('India','SL','India'),
('SL','Aus','Draw'),
('SA','Eng','Eng'),
('Eng','NZ','NZ'),
('Aus','India','India'),
('Eng','SA','Draw');
/*42You are given table of cricket match played in a ICC cricket tournament with the details of winner for each match. You need to derive a points table using below rules.

1- For each win a team gets 2 points. 
2- For a loss team gets 0 points.
3- In case of a draw both the team gets 1 point each.
Display team name , matches played, # of wins , # of losses and points.  Sort output in ascending order of team name.
*/

WITH all_matches AS (
  SELECT team_1 AS team, team_2 AS opponent, winner FROM module.icc_world_cup
  UNION ALL
  SELECT team_2 AS team, team_1 AS opponent, winner FROM module.icc_world_cup
)
SELECT
  team AS team_name,
  COUNT(*) AS matches_played,
  SUM(CASE WHEN winner = team THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN winner <> 'Draw' AND winner <> team THEN 1 ELSE 0 END) AS losses,
  SUM(CASE WHEN winner = team THEN 2 WHEN winner = 'Draw' THEN 1 ELSE 0 END) AS points
FROM all_matches
GROUP BY team
ORDER BY team;
