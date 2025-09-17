DROP TABLE IF EXISTS module.products;
CREATE TABLE module.products (
  product_id INT,
  product_name VARCHAR(10)
);

DROP TABLE IF EXISTS module.sales;
CREATE TABLE module.sales (
  sale_id INT,
  product_id INT,
  region_name VARCHAR(20),
  sale_date DATE,
  quantity_sold INT
);

DROP TABLE IF EXISTS module.seasons;
CREATE TABLE module.seasons (
  start_date DATE,
  end_date DATE,
  season_name VARCHAR(10)
);

INSERT INTO module.products VALUES
(1,'Apples'),
(2,'Bananas'),
(3,'Oranges');

INSERT INTO module.sales VALUES
(1,1,'North America','2023-03-15',200),
(2,1,'North America','2023-06-20',300),
(3,1,'North America','2023-09-10',250),
(4,1,'North America','2023-12-05',400),
(5,2,'Europe','2023-04-25',150),
(6,2,'Europe','2023-07-30',200),
(7,2,'Europe','2023-10-15',180),
(8,2,'Europe','2023-01-20',220),
(9,3,'Asia','2023-05-05',300),
(10,3,'Asia','2023-08-10',350),
(11,3,'Asia','2023-11-20',400);

INSERT INTO module.seasons VALUES
('2023-09-01','2023-12-31','Autumn'),
('2023-03-01','2023-05-31','Spring'),
('2023-06-01','2023-08-31','Summer'),
('2023-01-01','2023-02-28','Winter');

WITH top_prod AS (
  SELECT
    region_name,
    product_id,
    SUM(quantity_sold) AS total_qty,
    RANK() OVER (PARTITION BY region_name ORDER BY SUM(quantity_sold) DESC) AS rnk
  FROM module.sales
  WHERE YEAR(sale_date)=2023
  GROUP BY region_name, product_id
),
season_tot AS (
  SELECT
    s.region_name,
    p.product_name,
    se.season_name,
    SUM(s.quantity_sold) AS total_quantity
  FROM module.sales s
  JOIN module.products p ON p.product_id = s.product_id
  JOIN module.seasons se ON s.sale_date BETWEEN se.start_date AND se.end_date
  JOIN top_prod tp ON tp.region_name = s.region_name AND tp.product_id = s.product_id AND tp.rnk = 1
  WHERE YEAR(s.sale_date)=2023
  GROUP BY s.region_name, p.product_name, se.season_name
)
SELECT region_name, product_name, season_name, total_quantity
FROM season_tot
ORDER BY region_name, product_name, season_name;
