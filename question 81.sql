DROP TABLE IF EXISTS module.revenue;
CREATE TABLE module.revenue (
  company_id INT,
  year INT,
  revenue DECIMAL(10,2)
);

INSERT INTO module.revenue VALUES
(1,2018,100000.00),
(1,2019,125000.00),
(1,2020,156250.00),
(1,2021,200000.00),
(1,2022,260000.00),
(2,2018,80000.00),
(2,2019,100000.00),
(2,2020,130000.00),
(2,2021,156000.00);


/*81)In a financial analysis project, you are tasked with identifying companies that have consistently increased their revenue by at least 25% every year. You have a table named revenue that contains information about the revenue of different companies over several years.
Your goal is to find companies whose revenue has increased by at least 25% every year consecutively. So for example If a company's revenue has increased by 25% or more for three consecutive years but not for the fourth year, it will not be considered.
Write an SQL query to retrieve the names of companies that meet the criteria mentioned above along with total lifetime revenue , display the output in ascending order of company id
*/
WITH cte1 AS (
  SELECT
    company_id,
    year,
    revenue,
    LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) AS prev_rev
  FROM module.revenue
),
cte2 AS (
  SELECT
    company_id,
    SUM(revenue) AS total_lifetime_revenue,
    SUM(prev_rev IS NOT NULL) AS comparisons,
    SUM(CASE WHEN prev_rev IS NOT NULL AND revenue >= prev_rev * 1.25 THEN 1 ELSE 0 END) AS validation
  FROM cte1
  GROUP BY company_id
)
SELECT company_id, total_lifetime_revenue
FROM cte2
WHERE comparisons > 0 AND comparisons = validation
ORDER BY company_id;



