DROP TABLE IF EXISTS module.competition;
CREATE TABLE module.competition(
  group_id INT,
  participant_name VARCHAR(10),
  slice_count INT,
  bet INT
);

INSERT INTO module.competition VALUES
(1,'Alice',10,51),
(1,'Bob',15,42),
(1,'Eve',15,30),
(1,'Tom',8,21),
(2,'Jerry',12,12),
(2,'Charlie',20,60),
(2,'David',20,12),
(2,'Mike',20,54),
(2,'Nancy',18,42),
(2,'Oliver',30,30),
(3,'Frank',12,51);

/*92)"A pizza eating competition is organized. All the participants are organized into different groups. 
In a contest , A participant who eat the most pieces of pizza is the winner and recieves their original bet 
plus 30% of all losing participants bets. In case of a tie all winning participants will get equal share
 (of 30%) divided among them .Return the winning participants' 
names for each group and amount of their payout(round to 2 decimal places) . ordered ascending by group_id , participant_name.*/

WITH g AS (
  SELECT group_id, MAX(slice_count) AS max_slices
  FROM module.competition
  GROUP BY group_id
),
w AS (
  SELECT c.group_id, c.participant_name, c.bet
  FROM module.competition c
  JOIN g ON g.group_id = c.group_id AND c.slice_count = g.max_slices
),
cnt AS (
  SELECT group_id, COUNT(*) AS winners
  FROM w
  GROUP BY group_id
),
lose AS (
  SELECT c.group_id, SUM(c.bet) AS losing_bets
  FROM module.competition c
  JOIN g ON g.group_id = c.group_id
  WHERE c.slice_count <> g.max_slices
  GROUP BY c.group_id
)
SELECT
  w.group_id,
  w.participant_name,
  ROUND(w.bet + COALESCE(0.30 * losing_bets / winners,0),2) AS payout
FROM w
LEFT JOIN cnt  ON cnt.group_id  = w.group_id
LEFT JOIN lose ON lose.group_id = w.group_id
ORDER BY w.group_id, w.participant_name;
