DROP TABLE IF EXISTS module.elections;
CREATE TABLE module.elections(
  district_name VARCHAR(20),
  candidate_id INT,
  party_name VARCHAR(10),
  votes INT
);

INSERT INTO module.elections VALUES
('Delhi North',101,'Congress',1500),
('Delhi North',102,'BJP',1500),
('Delhi North',103,'AAP',1100),
('Mumbai South',106,'Congress',2000),
('Mumbai South',107,'BJP',1800),
('Mumbai South',110,'AAP',1500),
('Kolkata East',111,'Congress',2200),
('Kolkata East',113,'BJP',2300),
('Kolkata East',114,'AAP',2000),
('Chennai Central',116,'Congress',1600),
('Chennai Central',117,'BJP',1700);

/*91)"You are provided with election data from multiple districts in India. 
Each district conducted elections for selecting a representative from various political parties. 
Your task is to analyze the election results to determine the winning party at national levels.
 Here are the steps to identify winner:
 1- Determine the winning party in each district based on the candidate 
 with the highest number of votes.
 2- If multiple candidates from different parties have the same highest number of 
 votes in a district , consider it a tie, and all tied candidates are declared winners for that district.
 3- Calculate the total number of seats won by each party across all districts
 4- A party wins the election if it secures more than 50% of the total seats available nationwide.
 Display the total number of seats won by each party 
and a result column specifying Winner or Loser. Order the output by total seats won in descending order.*/

WITH district_winners AS (
  SELECT e.party_name
  FROM module.elections e
  JOIN (
    SELECT district_name, MAX(votes) AS max_votes
    FROM module.elections
    GROUP BY district_name
  ) m
    ON e.district_name = m.district_name
   AND e.votes = m.max_votes
),
seats AS (
  SELECT party_name, COUNT(*) AS total_seats_won
  FROM district_winners
  GROUP BY party_name
),
tot AS (
  SELECT party_name, total_seats_won, SUM(total_seats_won) OVER() AS all_seats
  FROM seats
)
SELECT
  party_name,
  total_seats_won,
  CASE WHEN total_seats_won > 0.5 * all_seats THEN 'Winner' ELSE 'Loser' END AS result
FROM tot
ORDER BY total_seats_won DESC, party_name;
