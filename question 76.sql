CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.purchases;
DROP TABLE IF EXISTS module.notifications;

CREATE TABLE module.notifications (
  notification_id INT PRIMARY KEY,
  delivered_at DATETIME,
  product_id VARCHAR(2)
);

CREATE TABLE module.purchases (
  user_id INT,
  product_id VARCHAR(2),
  purchase_timestamp DATETIME
);

INSERT INTO module.notifications (notification_id, product_id, delivered_at) VALUES
(1,'p1','2024-01-01 08:00:00'),
(2,'p2','2024-01-01 10:30:00'),
(3,'p3','2024-01-01 11:30:00');

INSERT INTO module.purchases (user_id, product_id, purchase_timestamp) VALUES
(1,'p1','2024-01-01 09:00:00'),
(2,'p2','2024-01-01 09:00:00'),
(3,'p1','2024-01-01 09:30:00'),
(3,'p1','2024-01-01 10:20:00'),
(4,'p2','2024-01-01 10:40:00'),
(1,'p2','2024-01-01 10:50:00'),
(5,'p2','2024-01-01 11:45:00'),
(2,'p3','2024-01-01 11:45:00'),
(2,'p3','2024-01-01 12:30:00'),
(3,'p3','2024-01-01 14:30:00');


/*76)Your task is to analyze the effectiveness of Amazon's notifications in driving user engagement and conversions, 
considering the user purchase data. A purchase is considered to be associated with a notification if the purchase 
happens within the timeframe of earliest of below 2 events:
1-  2 hours from notification delivered time
2-  Next notification delivered time.
Each notification is sent for a particular product id but a customer may purchase same or another product.
 Considering these rules write an SQL to find number of purchases associated with each notification 
 for same product or a different product in 2 separate columns, display the output in ascending order of notification id.
*/
WITH noti AS (
  SELECT
    n.notification_id,
    n.product_id,
    n.delivered_at,
    LEAST(
      DATE_ADD(n.delivered_at, INTERVAL 2 HOUR),
      COALESCE(LEAD(n.delivered_at) OVER (ORDER BY n.delivered_at),
               DATE_ADD(n.delivered_at, INTERVAL 2 HOUR))
    ) AS window_end
  FROM module.notifications n
)
SELECT
  n.notification_id,
  COALESCE(SUM(CASE WHEN p.product_id = n.product_id THEN 1 ELSE 0 END),0) AS purchases_same_product,
  COALESCE(SUM(CASE WHEN p.product_id <> n.product_id THEN 1 ELSE 0 END),0) AS purchases_other_product
FROM noti n
LEFT JOIN module.purchases p
  ON p.purchase_timestamp >= n.delivered_at
 AND p.purchase_timestamp <  n.window_end
GROUP BY n.notification_id
ORDER BY n.notification_id;
