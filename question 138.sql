-- Sample setup
CREATE DATABASE IF NOT EXISTS module;

DROP TABLE IF EXISTS module.customers;
CREATE TABLE module.customers (
  customer_id   INT,
  customer_name VARCHAR(100),
  email         VARCHAR(200),
  phone         VARCHAR(50),
  address       VARCHAR(200)
);

INSERT INTO module.customers VALUES
(1 , 'John Doe'        , 'JOHN.DOE@GMAIL.COM'          , '(123)-456-7890'     , '221B Baker St'),
(2 , '  Jane Smith  '  , 'Jane.Smith@Yahoo.com '       , ' 987 654 3210 '     , '742 Evergreen Ter'),
(3 , ' JOHN DOE  '     , 'JOHN.DOE@GMAIL.COM'          , ' 123-456-7890 '     , NULL),              -- duplicate email of id=1
(4 , 'Alex White'      , 'Alex.White@Outlook.com'      , '111-222-3333'       , NULL),              -- address to be 'Unknown'
(5 , 'Bob Brown'       , 'Bob.Brown@Gmail.Com'         , '+1 (555) 888-9999'  , '   '),             -- blank becomes 'Unknown'
(6 , 'Emily Davis'     , 'EMILY.DAVIS@GMAIL.COM'       , '555 666 7777'       , '5th Ave'),
(7 , 'Michael Johnson' , 'Michael.Johnson@Hotmail.com' , '444-555-6666'       , '10 Downing St'),
(8 , 'David Miller'    , 'DAVID.MILLER@YAHOO.COM'      , '(777) 888-9999'     , '1 Main Rd'),
(9 , 'David M'         , 'david.miller@yahoo.com'      , '999.888.7777'       , ''),                -- blank becomes 'Unknown'
(10, 'William Taylor'  , 'WILLIAM.TAYLOR@OUTLOOK.COM'  , '+1 123-456-7890'    , 'Market St'),
(11, 'Michael Johnson' , 'Michael.Johnson@Hotmail.com' , '444-555-6666'       , 'Duplicate row'),   -- dup email of id=7
(12, 'Olivia Brown'    , 'Olivia.Brown@Yahoo.com'      , '333 222 1111'       , 'High St');

/*138)"You are given a table with customers information that contains inconsistent and messy data.
 Your task is to clean the data by writing an SQL query to:
 1- Trim extra spaces from the customer name and email fields. 
 2- Convert all email addresses to lowercase for consistency. 
 3- Remove duplicate records based on email address (keep the record with lower customer id). 
 4- Standardize the phone number format to only contain digits (remove dashes, spaces, and special characters). 
5- Replace NULL values in address with 'Unknown'. Sort the output by customer id.*/
WITH cleaned AS (
  SELECT
    customer_id,
    TRIM(customer_name)                                            AS customer_name,
    LOWER(TRIM(email))                                             AS email_norm,
    REGEXP_REPLACE(phone, '[^0-9]', '')                           AS phone_digits,
    COALESCE(NULLIF(TRIM(address), ''), 'Unknown')                AS address_clean
  FROM module.customers
),
dedup AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY email_norm ORDER BY customer_id) AS rn
  FROM cleaned
)
SELECT
  customer_id,
  customer_name,
  email_norm AS email,
  phone_digits AS phone,
  address_clean AS address
FROM dedup
WHERE rn = 1
ORDER BY customer_id;
