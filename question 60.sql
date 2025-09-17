DROP TABLE IF EXISTS module.posts;
DROP TABLE IF EXISTS module.influencers;

CREATE TABLE module.influencers (
  influencer_id INT PRIMARY KEY,
  username VARCHAR(10),
  join_date DATE
);

CREATE TABLE module.posts (
  post_id INT PRIMARY KEY,
  influencer_id INT,
  post_date DATE,
  likes INT,
  comments INT,
  FOREIGN KEY (influencer_id) REFERENCES module.influencers(influencer_id)
);

INSERT INTO module.influencers (influencer_id, username, join_date) VALUES
(1,'Ankit','2023-02-01'),
(2,'Rahul','2023-03-05'),
(3,'Suresh','2023-05-20');

INSERT INTO module.posts (post_id, influencer_id, post_date, likes, comments) VALUES
(1,1,'2023-01-05',100,20),
(2,1,'2023-01-10',150,30),
(3,1,'2023-02-05',200,45),
(4,1,'2023-02-10',120,25),
(5,2,'2023-02-15',150,30),
(6,2,'2023-02-20',200,25),
(7,2,'2023-03-10',250,15),
(8,2,'2023-03-15',200,35);

/*60)You are working for a marketing agency that manages multiple Instagram influencer accounts. Your task is to analyze the 
engagement performance of these influencers before and after they join your company.
Write an SQL query to calculate average engagement growth rate percent for each influencer after they joined your company 
compare to before. Round the growth rate to 2 decimal places and sort the output in decreasing order of growth rate.

Engagement = (# of likes + # of comments on each post)
*/

SELECT
  i.influencer_id,
  i.username,
  ROUND(
    (
      AVG(CASE WHEN p.post_date >= i.join_date THEN (p.likes + p.comments) END)
      - AVG(CASE WHEN p.post_date <  i.join_date THEN (p.likes + p.comments) END)
    )
    / AVG(CASE WHEN p.post_date < i.join_date THEN (p.likes + p.comments) END) * 100
  , 2) AS growth_rate_pct
FROM module.influencers i
JOIN module.posts p
  ON p.influencer_id = i.influencer_id
GROUP BY i.influencer_id, i.username
HAVING AVG(CASE WHEN p.post_date < i.join_date THEN (p.likes + p.comments) END) IS NOT NULL
   AND AVG(CASE WHEN p.post_date >= i.join_date THEN (p.likes + p.comments) END) IS NOT NULL
ORDER BY growth_rate_pct DESC;
