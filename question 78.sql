CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.bookings;
CREATE TABLE module.bookings (
  room_id INT,
  customer_id INT,
  check_in_date DATE,
  check_out_date DATE
);

INSERT INTO module.bookings VALUES
(1,101,'2024-04-01','2024-04-04'),
(2,102,'2024-04-02','2024-04-05'),
(1,103,'2024-04-02','2024-04-06'),
(1,104,'2024-04-03','2024-04-05'),
(2,105,'2024-04-04','2024-04-07'),
(1,106,'2024-04-05','2024-04-08'),
(3,107,'2024-04-05','2024-04-09');

DROP TABLE IF EXISTS module.calendar_dim;
CREATE TABLE module.calendar_dim (
  cal_date DATE
);

INSERT INTO module.calendar_dim VALUES
('2024-04-01'),('2024-04-02'),('2024-04-03'),('2024-04-04'),
('2024-04-05'),('2024-04-06'),('2024-04-07'),('2024-04-08'),
('2024-04-09'),('2024-04-10');

/*78)A hotel has accidentally made overbookings for certain rooms on specific dates. Due to this error, some rooms have been 
assigned to multiple customers for overlapping periods, leading to potential conflicts. The hotel management needs to rectify 
this mistake by contacting the affected customers and providing them with alternative arrangements.
Your task is to write an SQL query to identify the overlapping bookings for each room and determine the list of customers
 affected by these overlaps. For each room and overlapping date, the query should list the customers who have booked the
 room for that date. 
A booking's check-out date is not inclusive, meaning that if a room is booked from April 1st to April 4th, 
it is considered occupied from April 1st to April 3rd , another customer can check-in on April 4th and that will
 not be considered as overlap.
Order the result by room id, booking date. You may use calendar dim table which has all the dates for the year April 2024.
*/
WITH occupied AS (
  SELECT b.room_id, c.cal_date, b.customer_id
  FROM module.bookings b
  JOIN module.calendar_dim c
    ON c.cal_date >= b.check_in_date
   AND c.cal_date < b.check_out_date
)
SELECT
  room_id,
  cal_date AS booking_date,
  GROUP_CONCAT(customer_id ORDER BY customer_id) AS customers
FROM occupied
GROUP BY room_id, cal_date
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY room_id, booking_date;
