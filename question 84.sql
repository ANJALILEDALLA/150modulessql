DROP TABLE IF EXISTS module.trips;
CREATE TABLE module.trips (
  trip_id INT,
  driver_id INT,
  fare INT,
  rating DECIMAL(3,2)
);

INSERT INTO module.trips VALUES
(1,101,1500,4.50),
(2,101,2000,4.20),
(3,101,2500,5.00),
(4,101,3000,4.70),
(5,101,3500,4.40),
(6,101,4000,4.70),
(7,101,4500,4.60),
(8,101,5000,4.30),
(9,101,5000,4.10),
(10,101,6000,4.70);

/*84)"In a bustling city, Uber operates a fleet of drivers who provide transportation services to passengers. 
As part of Uber's policy, drivers are subject to a commission deduction from their total earnings. 
The commission rate is determined based on the average rating received by the driver over their recent trips. 
This ensures that drivers delivering exceptional service are rewarded with lower commission rates, while those
 with lower ratings are subject to higher commission rates. Commission Calculation: For the first 3 trips of each driver,
 a standard commission rate of 24% is applied. After the first 3 trips, the commission rate is determined based on the 
 average rating of the driver's last 3 trips before the current trip: If the average rating is between 4.7 and 5 (inclusive), 
 the commission rate is 20%. If the average rating is between 4.5 and 4.7 (inclusive), the commission rate is 23%.
 For any other average rating, the default commission rate remains at 24%. Write an SQL query to calculate the total 
 earnings for each driver after deducting Uber's commission, 
considering the commission rates as per the given criteria, display the output in ascending order of driver id.*/

WITH ranked AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_id) AS rn,
    AVG(rating) OVER (
      PARTITION BY driver_id
      ORDER BY trip_id
      ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
    ) AS avg_prev3
  FROM module.trips t
),
earn AS (
  SELECT
    driver_id,
    trip_id,
    fare,
    CASE
      WHEN rn <= 3 THEN 0.24
      WHEN avg_prev3 >= 4.70 THEN 0.20
      WHEN avg_prev3 >= 4.50 THEN 0.23
      ELSE 0.24
    END AS comm_rate
  FROM ranked
)
SELECT
  driver_id,
  ROUND(SUM(fare * (1 - comm_rate)),2) AS total_earnings
FROM earn
GROUP BY driver_id
ORDER BY driver_id;
