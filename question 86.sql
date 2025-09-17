DROP TABLE IF EXISTS module.Matches;
CREATE TABLE module.Matches (
  match_id INT,
  home_team VARCHAR(10),
  away_team VARCHAR(10),
  winner_team VARCHAR(10)
);

INSERT INTO module.Matches VALUES
(1,'CSK','MI','MI'),
(2,'GL','RR','GL'),
(3,'SRH','Kings11','SRH'),
(4,'DD','KKR','KKR'),
(5,'MI','CSK','MI'),
(6,'RR','GL','GL'),
(7,'Kings11','SRH','Kings11'),
(8,'KKR','DD','DD');


/*86)"In the Indian Premier League (IPL), each team plays two matches against every other team: one at their home venue and
 one at their opponent's venue. We want to identify team combinations where each team wins the away match but loses
 the home match against the same opponent.
 Write an SQL query to find such team combinations, where each team wins 
 at the opponent's venue but loses at their own home venue.*/
SELECT
  m1.home_team AS team_a,
  m1.away_team AS team_b,
  m1.match_id  AS match_id_at_team_a_home,
  m2.match_id  AS match_id_at_team_b_home
FROM module.Matches m1
JOIN module.Matches m2
  ON m1.home_team = m2.away_team   
 AND m1.away_team = m2.home_team
WHERE m1.winner_team = m1.away_team   
  AND m2.winner_team = m2.away_team  
  AND m1.home_team < m1.away_team     
ORDER BY team_a, team_b;
