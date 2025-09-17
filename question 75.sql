DROP TABLE IF EXISTS module.orders;

CREATE TABLE module.orders (
  rider_id INT,
  order_id INT,
  pickup_time DATETIME,
  delivery_time DATETIME
);

INSERT INTO module.orders (order_id, rider_id, pickup_time, delivery_time) VALUES
(1, 101, '2024-01-01 10:00:00', '2024-01-01 10:30:00'),
(2, 102, '2024-01-01 23:50:00', '2024-01-02 00:10:00'),
(3, 103, '2024-01-01 13:45:00', '2024-01-01 14:15:00'),
(4, 101, '2024-01-01 23:45:00', '2024-01-02 00:15:00'),
(5, 102, '2024-01-02 01:30:00', '2024-01-02 02:00:00'),
(6, 103, '2024-01-02 23:59:00', '2024-01-03 00:31:00'),
(7, 101, '2024-01-03 09:00:00', '2024-01-03 09:30:00');

/*75)You are working with Zomato, a food delivery platform, and you need to analyze the performance of Zomato 
riders in terms of the time they spend delivering orders each day. Given the pickup and delivery times for
 each order, your task is to calculate the duration of time spent by each rider on deliveries each day. 
 Order the output by rider id and ride date.*/

SELECT
  rider_id,
  DATE(pickup_time) AS ride_date,
  SUM(TIMESTAMPDIFF(MINUTE, pickup_time, delivery_time)) AS minutes_spent
FROM module.orders
GROUP BY rider_id, DATE(pickup_time)
ORDER BY rider_id, ride_date;
