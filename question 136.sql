DROP TABLE IF EXISTS module.companies;
CREATE TABLE module.companies (
  id INT,
  name VARCHAR(100),
  phone VARCHAR(30),
  is_promoted INT
);

DROP TABLE IF EXISTS module.categories;
CREATE TABLE module.categories (
  company_id INT,
  name VARCHAR(100),
  rating DECIMAL(3,1)
);

INSERT INTO module.companies VALUES
(1,'Wehner and Sons','+86 (302) 414-2559',0),
(2,'Schaefer-Rogahn','+33 (982) 752-6689',0),
(3,'King and Sons','+51 (578) 555-1781',1),
(4,'Considine LLC','+33 (487) 383-2644',0),
(5,'Parisian-Zieme','+1 (399) 688-1824',0),
(6,'Renner and Parisian','+7 (720) 699-2313',0),
(7,'Fadel and Fahey','+86 (307) 777-1731',1);

INSERT INTO module.categories VALUES
(1,'Drilled Shafts',5.0),
(1,'Granite Surfaces',3.0),
(1,'Structural and Misc Steel',0.0),
(2,'Waterproofing & Caulking',0.0),
(3,'Drywall & Acoustical',1.0),
(3,'Electrical and Fire Alarm',2.0),
(3,'Drywall & Acoustical A',3.0),
(3,'Ornament Railing',3.0),
(4,'Exterior Signage',0.0),
(4,'Termite Control1',3.0),
(4,'Termite Control2',1.0);

/*136)To enhance the functionality of "The Yellow Pages" website, create a SQL query to generate a report of companies, 
including their phone numbers and ratings. The query must account for the following:
Columns in the output:
name: The company name as per below rules:
    For promoted companies:
        Format: [PROMOTED] <company_name>.
    For non-promoted companies:
        Format: <company_name>.
phone: The company phone number.

rating: The overall star rating of the company as per rules below:
    Promoted companies : should always have NULL as their rating.
    For non-promoted companies:
        Format: <#_stars> (<average_rating>, based on <total_reviews> reviews), where:
        <#_stars>: Rounded down average rating to the nearest whole number.
        <average_rating>: Exact average rating rounded to 1 decimal place.
        <total_reviews>: Total number of reviews across all categories for the company.
Rules: Non-promoted companies should only be included if their average rating is 1 star or higher.

Results should be sorted:
By promotion status (promoted first).
In descending order of the average rating (before rounding).
By the total number of reviews (descending).
*/
WITH agg AS (
  SELECT
    c.id AS company_id,
    AVG(cat.rating) AS avg_rating,
    COUNT(cat.rating) AS total_reviews
  FROM module.companies c
  LEFT JOIN module.categories cat ON cat.company_id = c.id
  GROUP BY c.id
)
SELECT
  CASE WHEN c.is_promoted = 1 THEN CONCAT('[PROMOTED] ', c.name) ELSE c.name END AS name,
  c.phone,
  CASE
    WHEN c.is_promoted = 1 THEN NULL
    ELSE CONCAT(FLOOR(a.avg_rating),' (',ROUND(a.avg_rating,1),', based on ',a.total_reviews,' reviews)')
  END AS rating
FROM module.companies c
LEFT JOIN agg a ON a.company_id = c.id
WHERE c.is_promoted = 1 OR a.avg_rating >= 1
ORDER BY c.is_promoted DESC, a.avg_rating DESC, a.total_reviews DESC;
