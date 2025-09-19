DROP TABLE IF EXISTS module.users;
CREATE TABLE module.users (
  user_id INT,
  name VARCHAR(50),
  email VARCHAR(100),
  signup_date DATE
);

DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  order_id INT,
  order_date DATE,
  user_id INT,
  order_amount INT
);

INSERT INTO module.users VALUES
(1,'John Doe','john@example.com','2025-05-10'),
(2,'Jane Smith','jane@example.com','2024-11-25'),
(3,'Alice Johnson','alice@example.com','2024-10-16'),
(4,'Bob Brown','bob@example.com','2024-08-17'),
(5,'Sania','sania@example.com','2024-11-05'),
(6,'Rohit','rohit@example.com','2025-05-14');

INSERT INTO module.orders VALUES
(1,'2025-05-14',1,150),
(2,'2025-05-24',2,130),
(3,'2025-03-05',2,145),
(4,'2025-02-28',3,160),
(5,'2025-02-23',4,125),
(6,'2025-02-21',4,105);

/*134)Imagine you are working for Swiggy (a food delivery service platform). As part of your role in the data analytics team,
 you're tasked with identifying dormant customers - those who have registered on the platform but have not placed any orders 
 recently. Identifying dormant customers is crucial for targeted marketing efforts and customer re-engagement strategies.
A dormant customer is defined as a user who registered more than 6 months ago from today but has not placed any orders in the
 last 3 months. Your query should return the list of dormant customers and order amount of last order placed by them. 
 If no order was placed by a customer then order amount should be 0. order the output by user id.
Note: All the dates are in UTC time zone.
*/

WITH last_order AS (
  SELECT
    user_id,
    order_amount,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date DESC, order_id DESC) AS rn
  FROM module.orders
)
SELECT
  u.user_id,
  u.name,
  u.email,
  COALESCE(lo.order_amount,0) AS last_order_amount
FROM module.users u
LEFT JOIN last_order lo
  ON lo.user_id = u.user_id AND lo.rn = 1
WHERE u.signup_date < UTC_DATE() - INTERVAL 6 MONTH
  AND NOT EXISTS (
    SELECT 1
    FROM module.orders o
    WHERE o.user_id = u.user_id
      AND o.order_date >= UTC_DATE() - INTERVAL 3 MONTH
  )
ORDER BY u.user_id;
