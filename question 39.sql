DROP TABLE IF EXISTS module.listings;
CREATE TABLE module.listings (
    listing_id INT,
    host_id INT,
    location VARCHAR(20),
    room_type VARCHAR(20),
    price DECIMAL(10,2),
    minimum_nights INT
);

INSERT INTO module.listings VALUES
(1,101,'Downtown','Entire home/apt',150.00,2),
(2,101,'Downtown','Private room',80.00,1),
(3,101,'Downtown','Entire home/apt',200.00,3),
(4,102,'Downtown','Entire home/apt',120.00,2),
(5,102,'Downtown','Private room',100.00,1),
(6,102,'Midtown','Entire home/apt',250.00,2),
(7,103,'Midtown','Entire home/apt',70.00,1),
(8,103,'Midtown','Private room',90.00,1),
(9,104,'Midtown','Private room',170.00,1);

DROP TABLE IF EXISTS module.bookings;
CREATE TABLE module.bookings (
    booking_id INT,
    listing_id INT,
    checkin_date DATE,
    checkout_date DATE
);

INSERT INTO module.bookings VALUES
(1,1,'2023-01-05','2023-01-10'),
(2,1,'2023-01-11','2023-01-13'),
(3,2,'2023-01-15','2023-01-25'),
(4,3,'2023-01-10','2023-01-17'),
(5,3,'2023-01-19','2023-01-21'),
(6,3,'2023-01-22','2023-01-23'),
(7,4,'2023-01-03','2023-01-05'),
(8,5,'2023-01-10','2023-01-12'),
(9,6,'2023-01-15','2023-01-19'),
(10,6,'2023-01-20','2023-01-22'),
(11,7,'2023-01-25','2023-01-29');


/*39)"You are planning to list a property on Airbnb.
 To maximize profits, you need to analyze the Airbnb data for the month of January 2023 to 
 determine the best room type for each location. 
 The best room type is based on the maximum average occupancy during the given month. 
 Write an SQL query to find the best room type for each location based on the average occupancy days. 
Order the results in descending order of average occupancy days, rounded to 2 decimal places.*/
WITH occ AS (
  SELECT l.listing_id,
         l.location,
         l.room_type,
         COALESCE(SUM(DATEDIFF(b.checkout_date,b.checkin_date)),0) AS occ_days
  FROM module.listings l
  LEFT JOIN module.bookings b
    ON b.listing_id = l.listing_id
   AND b.checkin_date >= '2023-01-01'
   AND b.checkout_date <= '2023-01-31'
  GROUP BY l.listing_id,l.location,l.room_type
),
avg_occ AS (
  SELECT location,
         room_type,
         ROUND(AVG(occ_days),2) AS avg_occ_days,
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY AVG(occ_days) DESC) AS rn
  FROM occ
  GROUP BY location,room_type
)
SELECT location, room_type AS best_room_type, avg_occ_days
FROM avg_occ
WHERE rn = 1
ORDER BY avg_occ_days DESC;
