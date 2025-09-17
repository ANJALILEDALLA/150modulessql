DROP TABLE IF EXISTS module.players;
CREATE TABLE module.players (
  player_id INT,
  group_id INT
);

DROP TABLE IF EXISTS module.matches;
CREATE TABLE module.matches (
  match_id INT,
  first_player INT,
  second_player INT,
  first_score INT,
  second_score INT
);

INSERT INTO module.players VALUES
(1,1),(2,1),(3,1),(4,1),(5,1),
(6,2),(7,2),(8,2),(9,2),
(10,3),(11,3),(12,3);

INSERT INTO module.matches VALUES
(1,1,2,3,5),
(2,1,3,2,1),
(3,1,4,2,2),
(4,1,5,1,3),
(5,2,3,4,2),
(6,2,4,2,1),
(7,2,5,3,3),
(8,3,4,1,1),
(9,3,5,2,4),
(10,4,5,2,2),
(11,6,7,2,2),
(12,6,8,1,3),
(13,6,9,4,2),
(14,7,8,5,1),
(15,7,9,2,2),
(16,8,9,3,3),
(17,10,11,5,5),
(18,10,12,4,2),
(19,11,12,3,6);


/*114)You are given two tables, players and matches, with the following structure.

Each record in the table players represents a single player in the tournament. The column player_id contains the ID of each 
player. The column group_id contains the ID of the group each player belongs to.
Table: players 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| player_id       | int      |    
| group_id        | int      |
+-----------------+----------+
Each record in the table matches represents a single match in the group stage. The column first_player (second_player)
 contains the ID of the first player (second player) in each match. The column first_score (second_score) contains the 
 number of points scored by the first player (second player) in each match. You may assume that, in each match, players 
 belong to the same group.

Table: matches 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| match_id      | int      |    
| first_player  | int      |
| second_player | int      |
| first_score   | int      |
| second_score  | int      |
+---------------+----------+
Write an SQL to compute the winner in each group. The winner in each group is the player who scored the maximum total 
number of points within the group. If there is more than one such player, the winner is the one with the highest ID.
 Write an SQL query that returns a table containing the winner of each group. Each record should contain the ID of the 
 group and the ID of the winner in this group. Records should be sorted by group id.   
*/

WITH totals AS (
  SELECT
    p.group_id,
    p.player_id,
    SUM(
      CASE WHEN m.first_player = p.player_id THEN m.first_score ELSE 0 END +
      CASE WHEN m.second_player = p.player_id THEN m.second_score ELSE 0 END
    ) AS total_points
  FROM module.players p
  LEFT JOIN module.matches m
    ON m.first_player = p.player_id OR m.second_player = p.player_id
  GROUP BY p.group_id, p.player_id
),
rnk AS (
  SELECT
    group_id,
    player_id,
    RANK() OVER (PARTITION BY group_id ORDER BY total_points DESC, player_id DESC) AS r
  FROM totals
)
SELECT group_id, player_id AS winner_player_id
FROM rnk
WHERE r = 1
ORDER BY group_id;
