DROP TABLE IF EXISTS module.post_likes;
DROP TABLE IF EXISTS module.user_follows;

CREATE TABLE module.post_likes(
  post_id INT,
  user_id INT
);

CREATE TABLE module.user_follows(
  follows_user_id INT,
  user_id INT
);

INSERT INTO module.post_likes VALUES
(100,1),
(100,2),
(200,3),
(300,4),
(300,5),
(300,1);

INSERT INTO module.user_follows VALUES
(2,1),
(3,1),
(4,1),
(1,2),
(3,2);

/*53)"LinkedIn stores information of post likes in below format.
 Every time a user likes a post there will be an entry made in post likes table.
 The marketing team wants to send one recommendation post to each user .
 Write an SQL to find out that one post id for each user that is liked by the most number of users that they follow. 
 Display user id, post id and no of likes.

Please note that team do not want to recommend a post which is already liked by the user. 
If for any user,  2 or more posts are liked by equal number of users that they follow then select the smallest post id, 
display the output in ascending order of user id.
*/

WITH liked_by_followed AS (
  SELECT
    uf.user_id,
    pl.post_id,
    COUNT(DISTINCT pl.user_id) AS cnt
  FROM module.user_follows uf
  JOIN module.post_likes pl
    ON pl.user_id = uf.follows_user_id
  LEFT JOIN module.post_likes me
    ON me.user_id = uf.user_id AND me.post_id = pl.post_id
  WHERE me.post_id IS NULL
  GROUP BY uf.user_id, pl.post_id
),
pick AS (
  SELECT
    user_id, post_id, cnt,
    RANK() OVER(PARTITION BY user_id ORDER BY cnt DESC, post_id ASC) AS rnk
  FROM liked_by_followed
)
SELECT user_id, post_id, cnt AS likes_count
FROM pick
WHERE rnk = 1
ORDER BY user_id;
