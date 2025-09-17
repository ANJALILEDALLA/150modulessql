
DROP TABLE IF EXISTS module.users;
DROP TABLE IF EXISTS module.income_tax_dates;

CREATE TABLE module.income_tax_dates (
  financial_year  VARCHAR(4),
  file_start_date DATE,
  file_due_date   DATE
);

CREATE TABLE module.users (
  user_id          INT,
  financial_year   VARCHAR(4),
  return_file_date DATE
);


INSERT INTO module.income_tax_dates VALUES
('FY20','2020-05-01','2020-08-31'),
('FY21','2021-06-01','2021-09-30'),
('FY22','2022-05-05','2022-08-29'),
('FY23','2023-05-05','2023-08-31');


INSERT INTO module.users VALUES
(1,'FY20','2020-05-10'),
(1,'FY21','2021-10-10'),  
(1,'FY23','2023-08-20'),
(2,'FY20','2020-05-15'),
(2,'FY21','2021-09-10'),
(2,'FY22','2022-08-20'),
(2,'FY23','2023-10-10');  

/*27)"Given two tables: income_tax_dates and users, write a query to identify users who either filed their income tax returns
 late or completely skipped filing for certain financial years. A return is considered late if the return_file_date is after
 the file_due_date. A return is considered missed if there is no entry for the user in the users table for a given 
 financial year (i.e., the user did not file at all). 
 Your task is to generate a list of users along with the financial year for which they either filed late or missed filing, 
 and also include a comment column specifying whether it is a 'late return' or 'missed'.
 The result should be sorted by financial year in ascending order*/
 
 SELECT
  uids.user_id,
  d.financial_year,
  CASE
    WHEN u.return_file_date IS NULL THEN 'missed'
    WHEN u.return_file_date > d.file_due_date THEN 'late return'
  END AS comment
FROM (SELECT DISTINCT user_id FROM module.users) AS uids
CROSS JOIN module.income_tax_dates AS d
LEFT JOIN module.users AS u
  ON u.user_id = uids.user_id
 AND u.financial_year = d.financial_year
WHERE u.return_file_date IS NULL
   OR u.return_file_date > d.file_due_date
ORDER BY d.financial_year, uids.user_id;
