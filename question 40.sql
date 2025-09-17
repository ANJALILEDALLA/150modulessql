DROP TABLE IF EXISTS module.driver_ratings;
CREATE TABLE module.driver_ratings (
    driver_id INT,
    avg_rating DECIMAL(3,2)
);

INSERT INTO module.driver_ratings VALUES
(1,4.80),
(2,4.50),
(3,3.90),
(4,4.20),
(5,4.70),
(6,3.60),
(7,4.90),
(8,3.80),
(9,4.40),
(10,3.50),
(11,4.10);


/*40)"Suppose you are a data analyst working for ride-sharing platform Uber. 
Uber is interested in analyzing the performance of drivers based on their
 ratings and wants to categorize them into different performance tiers. 
 Write an SQL query to categorize drivers equally into three performance tiers 
 (Top, Middle, and Bottom) based on their average ratings.
 Drivers with the highest average ratings should be placed in the top tier,
 drivers with ratings below the top tier but above the bottom tier should be placed in the middle tier, and drivers with the
 lowest average ratings should be placed in the bottom tier. Sort the output in decreasing order of average rating*/
 
 
WITH ranked AS (
    SELECT driver_id,
           avg_rating,
           NTILE(3) OVER (ORDER BY avg_rating DESC) AS tier_group
    FROM module.driver_ratings
)
SELECT driver_id,
       avg_rating,
       CASE tier_group
            WHEN 1 THEN 'Top'
            WHEN 2 THEN 'Middle'
            WHEN 3 THEN 'Bottom'
       END AS performance_tier
FROM ranked
ORDER BY avg_rating DESC;
