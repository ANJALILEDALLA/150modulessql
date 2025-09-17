DROP TABLE IF EXISTS module.product_ratings;

CREATE TABLE module.product_ratings (
  rating_id INT PRIMARY KEY,
  product_id INT,
  user_id INT,
  rating DECIMAL(2,1)
);

INSERT INTO module.product_ratings (rating_id, product_id, user_id, rating) VALUES
(1,101,1001,4.5),
(2,101,1002,4.8),
(3,101,1003,4.9),
(4,101,1004,5.0),
(5,101,1005,3.2),
(6,102,1006,4.7),
(7,102,1007,4.0);

/*66)"As an analyst at Amazon, you are responsible for ensuring the integrity of product ratings on the platform. 
Fake ratings can distort the perception of product quality and mislead customers. To maintain trust and reliability,
 you need to identify potential fake ratings that deviate significantly from the average ratings for each product.
 Write an SQL query to identify the single rating that is farthest (in absolute value) 
from the average rating value for each product, display rating details in ascending order of rating id.*/
WITH x AS (
  SELECT
    rating_id, product_id, user_id, rating,
    AVG(rating) OVER (PARTITION BY product_id) AS avg_rating,
    ABS(rating - AVG(rating) OVER (PARTITION BY product_id)) AS deviation
  FROM module.product_ratings
),
r AS (
  SELECT
    rating_id, product_id, user_id, rating,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY deviation DESC, rating_id ASC) AS rn
  FROM x
)
SELECT rating_id, product_id, user_id, rating
FROM r
WHERE rn = 1
ORDER BY rating_id ASC;

