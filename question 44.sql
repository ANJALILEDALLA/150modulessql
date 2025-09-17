DROP TABLE IF EXISTS module.inventory;
CREATE TABLE module.inventory (
    inventory_level INT,
    inventory_target INT,
    location_id INT,
    product_id INT
);

DROP TABLE IF EXISTS module.products;
CREATE TABLE module.products (
    product_id INT,
    unit_cost DECIMAL(5,2)
);

INSERT INTO module.inventory VALUES
(90, 80, 1, 101),
(100,85, 1, 102),
(90, 80, 2, 102),
(70, 95, 2, 103),
(50, 60, 2, 104),
(120,100,3, 103),
(90, 102,4, 104);

INSERT INTO module.products VALUES
(101, 51.50),
(102, 55.50),
(103, 59.00),
(104, 50.00);

/*44)Suppose you are a data analyst working for Flipkart. 
Your task is to identify excess and insufficient inventory at various Flipkart warehouses in terms of no of units and cost. 
 Excess inventory is when inventory levels are greater than inventory targets else its insufficient inventory.

Write an SQL to derive excess/insufficient Inventory volume and value in cost for each location as well as at overall 
company level, display the results in ascending order of location id.
*/
WITH j AS (
  SELECT
    i.location_id,
    i.product_id,
    i.inventory_level,
    i.inventory_target,
    p.unit_cost,
    (i.inventory_level - i.inventory_target) AS diff
  FROM module.inventory i
  JOIN module.products p ON p.product_id = i.product_id
),
by_loc AS (
  SELECT
    location_id,
    SUM(GREATEST(diff,0))  AS excess_units,
    SUM(GREATEST(-diff,0))  AS insufficient_units,
    ROUND(SUM(GREATEST(diff,0)  * unit_cost),2) AS excess_cost,
    ROUND(SUM(GREATEST(-diff,0) * unit_cost),2) AS insufficient_cost
  FROM j
  GROUP BY location_id
),
overall AS (
  SELECT
    NULL AS location_id,
    SUM(excess_units) AS excess_units,
    SUM(insufficient_units) AS insufficient_units,
    ROUND(SUM(excess_cost),2) AS excess_cost,
    ROUND(SUM(insufficient_cost),2) AS insufficient_cost
  FROM by_loc
)
SELECT location_id, excess_units, insufficient_units, excess_cost, insufficient_cost
FROM by_loc
UNION ALL
SELECT location_id, excess_units, insufficient_units, excess_cost, insufficient_cost
FROM overall
ORDER BY (location_id IS NULL), location_id;
