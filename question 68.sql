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
(1,101,'12:00:00','12:30:00','12:25:00',20),
(2,102,'12:15:00','12:40:00','12:55:00',30),
(3,103,'12:30:00','13:05:00','13:10:00',25),
(4,101,'12:45:00','13:20:00','13:21:00',20),
(5,102,'13:00:00','13:30:00','13:36:00',20),
(6,103,'13:15:00','13:50:00','13:58:00',22),
(7,101,'13:30:00','14:00:00','14:12:00',22),
(8,102,'13:45:00','14:20:00','14:25:00',20),
(9,100,'14:00:00','14:30:00','14:32:00',18),
(10,101,'14:15:00','14:45:00','15:05:00',40);

/*68)You're analyzing the efficiency of food delivery on Zomato, focusing on the late deliveries. 
Total food delivery time for an order is a combination of food preparation time + time taken by rider to deliver the order. 
Suppose that as per order time and expected time of delivery there is equal time allocated to restaurant 
for food preparation and rider to deliver the order. Write an SQL to find orders which got delayed only 
because of more than expected time taken by the rider, display order_id, expected_delivery_mins, rider_delivery_mins, 
food_prep_mins in ascending order of order_id.
*/

WITH calc AS (
  SELECT
    order_id,
    TIMESTAMPDIFF(MINUTE, order_time, expected_delivery_time) AS expected_delivery_mins,
    rider_delivery_mins,
    TIMESTAMPDIFF(MINUTE, order_time, actual_delivery_time) - rider_delivery_mins AS food_prep_mins,
    TIMESTAMPDIFF(MINUTE, order_time, actual_delivery_time) AS actual_total_mins
  FROM module.orders
)
SELECT
  order_id,
  expected_delivery_mins,
  rider_delivery_mins,
  food_prep_mins
FROM calc
WHERE actual_total_mins > expected_delivery_mins
  AND rider_delivery_mins > expected_delivery_mins/2
  AND food_prep_mins <= expected_delivery_mins/2
ORDER BY order_id;
