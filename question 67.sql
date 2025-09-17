CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.orders;

CREATE TABLE module.orders (
  order_id INT,
  restaurant_id INT,
  order_time TIME,
  expected_delivery_time TIME,
  actual_delivery_time TIME,
  rider_delivery_mins INT
);

INSERT INTO module.orders (order_id, restaurant_id, order_time, expected_delivery_time, actual_delivery_time, rider_delivery_mins) VALUES
(1,101,'12:00:00','12:30:00','12:45:00',20),
(2,102,'12:15:00','12:45:00','12:55:00',12),
(3,103,'12:30:00','13:00:00','13:10:00',15),
(4,101,'12:45:00','13:15:00','13:21:00',8),
(5,102,'13:00:00','13:30:00','13:36:00',14),
(6,103,'13:15:00','13:45:00','13:58:00',11),
(7,101,'13:30:00','14:00:00','14:12:00',10);

/*67)You're analyzing the efficiency of food delivery on Zomato, focusing on the time taken by restaurants to prepare orders.
 Total food delivery time for an order is a combination of food preparation time + time taken by rider to deliver the order. 
Write an SQL to calculate average food preparation time(in minutes) for each restaurant . Round the average to 2 decimal
 points and sort the output in increasing order of average time.
*/
SELECT
  restaurant_id,
  ROUND(AVG(TIMESTAMPDIFF(MINUTE, order_time, actual_delivery_time) - rider_delivery_mins), 2) AS avg_prep_mins
FROM module.orders
GROUP BY restaurant_id
ORDER BY avg_prep_mins ASC;
