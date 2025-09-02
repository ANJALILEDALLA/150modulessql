CREATE DATABASE MODULE;

/*---------------------------------------------1 QUESTION-----------------------------------*/
DROP TABLE IF EXISTS module.orders;
-- Orders table
CREATE TABLE module.orders (
    customer_name VARCHAR(10),
    order_date DATE,
    order_id INT PRIMARY KEY,
    sales INT
);

-- Returns table
CREATE TABLE module.returns(
    order_id INT PRIMARY KEY,
    return_date DATE
);


INSERT INTO module.orders (customer_name, order_date, order_id, sales) VALUES
('Alice',  '2024-01-10', 101, 250),
('Alice',  '2024-02-15', 102, 300),
('Alice',  '2024-03-20', 103, 150),
('Bob',    '2024-01-05', 104, 400),
('Bob',    '2024-02-18', 105, 350),
('Bob',    '2024-04-22', 106, 500),
('Carol',  '2024-01-25', 107, 200),
('Carol',  '2024-02-14', 108, 220),
('Dave',   '2024-03-05', 109, 180),
('Dave',   '2024-04-10', 110, 210);

-- Insert sample returns
INSERT INTO module.returns (order_id, return_date) VALUES
(101, '2024-01-20'), -- Alice
(103, '2024-03-25'), -- Alice
(104, '2024-01-15'), -- Bob
(105, '2024-02-25'), -- Bob
(108, '2024-02-20'); -- Carol

/*1)"An e-commerce company, has observed a notable surge in return orders recently. 
They suspect that a specific group of customers may be responsible for a significant portion of these returns. To address this issue, 
their initial goal is to identify customers who have returned more than 50% of their orders.
 This way, they can proactively reach out to these customers to gather feedback.
 Write an SQL to find list of customers along with their return percent (Round to 2 decimal places), display the output in ascending order of customer name.*/
 
SELECT o.customer_name,ROUND((cast(COUNT(r.order_id) AS DECIMAL(5,2))/COUNT(o.order_id)*100),2) AS return_percent
FROM module.orders o
LEFT JOIN module.returns r 
ON o.order_id=r.order_id
GROUP BY customer_name
HAVING (COUNT(r.order_id)/COUNT(o.order_id))*100>50
ORDER BY customer_name asc;

/*-------------------------------------------2 QUESTION-------------------------------------------------*/
DROP TABLE IF EXISTS module.products;
CREATE TABLE module.products (
  product_id   INT PRIMARY KEY,
  product_name VARCHAR(20),
  price        INT
);

-- Insert sample values
INSERT INTO module.products (product_id, product_name, price) VALUES
(1,  'Pen',         15),
(2,  'Notebook',    120),
(3,  'Backpack',    450),
(4,  'Laptop',      820),
(5,  'Phone',       620),
(6,  'USB Cable',    99),
(7,  'Headphones',  199),
(8,  'Monitor',     320),
(9,  'Mouse',        50),
(10, 'Camera',      999),
(11, 'Charger',     150),
(12, 'SSD',         480);

/*2)You are provided with a table named Products containing information about various products,
 including their names and prices. Write a SQL query to count number of products in each category based on its price into three 
 categories below. Display the output in descending order of no of products. 
 1- ""Low Price"" for products with a price less than 100 
 2- ""Medium Price"" for products with a price between 100 and 500 (inclusive)
 3- ""High Price"" for products with a price greater than 500*/
 
SELECT category, COUNT(*) AS num_products
FROM (
  SELECT CASE
           WHEN price < 100 THEN 'Low Price'
           WHEN price BETWEEN 100 AND 500 THEN 'Medium Price'
           ELSE 'High Price'
         END AS category
  FROM module.products
) x
GROUP BY category
ORDER BY num_products DESC;

/* ---------------------------------------3 QUESTION---------------------------------------------*/
DROP TABLE IF EXISTS module.creators;
CREATE TABLE module.creators (
    creator_id INT PRIMARY KEY,
    creator_name VARCHAR(20),
    followers INT
);

DROP TABLE IF EXISTS module.posts;
CREATE TABLE module.posts (
    post_id VARCHAR(3) PRIMARY KEY,
    creator_id INT,
    publish_date DATE,
    impressions INT,
    FOREIGN KEY (creator_id) REFERENCES creators(creator_id)
);


INSERT INTO module.creators (creator_id, creator_name, followers) VALUES
(1, 'Alice', 60000),
(2, 'Bob', 45000),
(3, 'Charlie', 80000),
(4, 'Diana', 52000),
(5, 'Ethan', 90000),
(6, 'Fiona', 30000),
(7, 'George', 75000),
(8, 'Hannah', 51000),
(9, 'Ian', 65000),
(10, 'Julia', 55000);

INSERT INTO module.posts (post_id, creator_id, publish_date, impressions) VALUES
('P1', 1, '2023-12-05', 50000),
('P2', 1, '2023-12-12', 30000),
('P3', 1, '2023-12-20', 25000),
('P4', 3, '2023-12-02', 40000),
('P5', 3, '2023-12-10', 35000),
('P6', 3, '2023-12-22', 35000),
('P7', 5, '2023-12-01', 60000),
('P8', 5, '2023-12-15', 50000),
('P9', 5, '2023-12-28', 20000),
('P10', 9, '2023-11-30', 100000); -- Not in Dec, should be excluded


/*3)LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content.
 A creator qualifies for the badge if he/she satisfies following criteria.
 1- Creator should have more than 50k followers.
 2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
 3- Creator should have published atleast 3 posts in Dec-2023.
 Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.*/
 
 SELECT c.creator_name,COUNT(p.post_id),SUM(p.impressions)
 FROM module.creators c
 JOIN module.posts p
 ON c.creator_id=p.creator_id
 WHERE c.followers>50000 AND MONTH(p.publish_date)=12 AND YEAR(p.publish_date)=2023
 GROUP BY creator_name
 HAVING SUM(p.impressions)>100000 AND COUNT(p.post_id)>=3;
 
 
/*--------------------------------4 QUESTION-------------------------------------*/

DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(20),
    sales INT
);

INSERT INTO module.orders (order_id, order_date, customer_name, sales) VALUES
(1, '2025-08-01', 'Alice', 200),
(2, '2025-08-02', 'Bob', 150),
(3, '2025-08-03', 'Alice', 300),
(4, '2025-08-04', 'Charlie', 100),
(5, '2025-08-05', 'Alice', 400),
(6, '2025-08-06', 'Bob', 200),
(7, '2025-08-07', 'David', 350),
(8, '2025-08-08', 'Bob', 100),
(9, '2025-08-09', 'David', 400);

/*4)An e-commerce company want to start special reward program for their premium customers.
 The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers. 
 Write an SQL to find the list of premium customers along with the number of orders placed by each of them,
 display the results in highest to lowest no of orders.*/
 
 SELECT customer_name,COUNT(order_id)
 FROM module.orders
 GROUP BY customer_name
 HAVING COUNT(order_id)>(SELECT AVG(order_count) from (SELECT COUNT(order_id) as order_count FROM module.orders GROUP BY customer_name) as avg_of_orders ) 
 ORDER BY COUNT(order_id) DESC;
 
 
 /*---------------------------------5 question------------------------------*/
 
 -- Drop (dependents first)
DROP TABLE IF EXISTS module.customer_transactions;
DROP TABLE IF EXISTS module.credit_card_bills;
DROP TABLE IF EXISTS module.loans;
DROP TABLE IF EXISTS module.customers;

-- Create
CREATE TABLE module.customers (
  customer_id   INT PRIMARY KEY,
  credit_limit  INT
);

CREATE TABLE module.loans (
  customer_id   INT,
  loan_id       INT PRIMARY KEY,
  loan_due_date DATE,
  FOREIGN KEY (customer_id) REFERENCES module.customers(customer_id)
);

CREATE TABLE module.credit_card_bills (
  bill_amount   INT,
  bill_due_date DATE,
  bill_id       INT PRIMARY KEY,
  customer_id   INT,
  FOREIGN KEY (customer_id) REFERENCES module.customers(customer_id)
);

CREATE TABLE module.customer_transactions (
  loan_bill_id     INT,
  transaction_date DATE,
  transaction_type VARCHAR(10)  -- 'loan' or 'bill'
);

-- Sample data
INSERT INTO module.customers (customer_id, credit_limit) VALUES
(1, 1000),
(2, 2000),
(3, 1500),
(4,  800);

INSERT INTO module.loans (customer_id, loan_id, loan_due_date) VALUES
(1, 101, '2023-03-10'),
(2, 102, '2023-03-15'),
(3, 103, '2023-03-20'),
(1, 104, '2023-03-25');

INSERT INTO module.credit_card_bills (bill_amount, bill_due_date, bill_id, customer_id) VALUES
(300, '2023-03-05', 201, 1),
(200, '2023-03-18', 202, 1),
(800, '2023-03-10', 203, 2),
(500, '2023-03-25', 204, 2),
(200, '2023-03-12', 205, 3),
(100, '2023-03-27', 206, 3),
(300, '2023-03-22', 207, 4);

INSERT INTO module.customer_transactions (loan_bill_id, transaction_date, transaction_type) VALUES
-- loan payments
(101, '2023-03-10', 'loan'),
(102, '2023-03-16', 'loan'),
(103, '2023-03-19', 'loan'),
(104, '2023-03-26', 'loan'),
-- bill payments
(201, '2023-03-05', 'bill'),
(202, '2023-03-22', 'bill'),
(203, '2023-03-09', 'bill'),
(204, '2023-03-25', 'bill'),
(205, '2023-03-13', 'bill'),
(206, '2023-03-27', 'bill'),
(207, '2023-03-23', 'bill');
 
 /*5)"CIBIL score, often referred to as a credit score, is a numerical representation of an individual's credit worthiness.
 While the exact formula used by credit bureaus like CIBIL may not be publicly disclosed and can vary slightly between bureaus,
 the following are some common factors that typically influence the calculation of a credit score:
 1- Payment History: This accounts for the largest portion of your credit score.
 It includes factors such as whether you pay your bills on time, any late payments, defaults, bankruptcies, etc.
 Assume this accounts for 70 percent of your credit score. 2- Credit Utilization Ratio: 
 This is the ratio of your credit card balances to your credit limits.
 Keeping this ratio low (ideally below 30%) indicates responsible credit usage.
 Assume it accounts for 30% of your score and below logic to 
 calculate it: Utilization below 30% = 1 Utilization between 30% and 50% = 0.7 Utilization above 50% = 0.5
 Assume that we have credit card bills data for March 2023 based on that we need to calculate credit utilization ratio.
 round the result to 1 decimal place. 
 Final Credit score formula = (on_time_loan_or_bill_payment)/total_bills_and_loans * 70 + Credit Utilization Ratio * 30
 Display the output in ascending order of customer id.*/
 
 
 
 
 
 
 
 
 
 
 
 /*-------------------------------------6 QUESTION-------------------------*/

 CREATE TABLE module.electricity_bill (
    bill_id INT PRIMARY KEY,
    household_id INT,
    billing_period VARCHAR(7),   -- Format: 'YYYY-MM'
    consumption_kwh DECIMAL(10,2),
    total_cost DECIMAL(10,2)
);


INSERT INTO module.electricity_bill (bill_id, household_id, billing_period, consumption_kwh, total_cost) VALUES
(1, 101, '2023-01', 350.50, 52.58),
(2, 101, '2023-02', 300.00, 45.00),
(3, 101, '2023-03', 320.75, 48.11),
(4, 102, '2023-01', 420.00, 63.00),
(5, 102, '2023-02', 380.50, 57.08),
(6, 102, '2023-03', 400.25, 60.04),
(7, 101, '2024-01', 360.00, 54.00),
(8, 101, '2024-02', 340.50, 51.08),
(9, 103, '2023-01', 500.00, 75.00),
(10, 103, '2023-02', 450.25, 67.54),
(11, 103, '2023-03', 470.50, 70.58),
(12, 102, '2024-01', 410.00, 61.50),
(13, 102, '2024-02', 395.75, 59.36),
(14, 103, '2024-01', 480.00, 72.00),
(15, 103, '2024-02', 460.25, 69.04);

/*6)"You have access to data from an electricity billing system, detailing the electricity usage and 
cost for specific households over billing periods in the years 2023 and 2024. Your objective is to present the total electricity consumption,
 total cost and average monthly consumption for each household per year display the output in ascending order of each household id & year of the bill.*/
 
 SELECT household_id, YEAR(STR_TO_DATE(CONCAT(billing_period, '-01'), '%Y-%m-%d')) AS bill_year, SUM(consumption_kwh),SUM(total_cost),AVG(consumption_kwh)
 FROM module.electricity_bill
 GROUP BY household_id, YEAR(STR_TO_DATE(CONCAT(billing_period, '-01'), '%Y-%m-%d')) 
 ORDER BY household_id asc,bill_year;
 
 
 
 /*----------------------------------7 question-----------------------------------------*/
 
CREATE TABLE module.listings (
    host_id INT,
    listing_id INT PRIMARY KEY,
    minimum_nights INT,
    neighborhood VARCHAR(20),
    price DECIMAL(10,2),
    room_type VARCHAR(20)
);

CREATE TABLE module.reviews (
    review_id INT PRIMARY KEY,
    listing_id INT,
    rating INT,
    review_date DATE,
    FOREIGN KEY (listing_id) REFERENCES module.listings(listing_id)
);

-- Hosts and their listings
INSERT INTO module.listings (host_id, listing_id, minimum_nights, neighborhood, price, room_type) VALUES
(1, 101, 2, 'Downtown', 150.00, 'Entire home/apt'),
(1, 102, 3, 'Downtown', 120.00, 'Private room'),
(2, 201, 1, 'Uptown', 80.00, 'Entire home/apt'),
(2, 202, 2, 'Uptown', 90.00, 'Private room'),
(3, 301, 4, 'Midtown', 200.00, 'Entire home/apt'),
(3, 302, 2, 'Midtown', 180.00, 'Private room'),
(3, 303, 3, 'Midtown', 150.00, 'Shared room'),
(4, 401, 2, 'Downtown', 100.00, 'Entire home/apt'),
(5, 501, 1, 'Uptown', 120.00, 'Private room'),
(5, 502, 2, 'Uptown', 130.00, 'Entire home/apt');

-- Reviews for listings
INSERT INTO module.reviews (review_id, listing_id, rating, review_date) VALUES
(1, 101, 5, '2023-12-01'),
(2, 101, 4, '2023-12-05'),
(3, 102, 5, '2023-12-07'),
(4, 102, 4, '2023-12-09'),
(5, 201, 3, '2023-12-02'),
(6, 201, 4, '2023-12-04'),
(7, 202, 5, '2023-12-06'),
(8, 202, 4, '2023-12-08'),
(9, 301, 5, '2023-12-03'),
(10, 302, 4, '2023-12-05'),
(11, 303, 5, '2023-12-07'),
(12, 401, 3, '2023-12-01'),
(13, 501, 4, '2023-12-02'),
(14, 502, 5, '2023-12-03');

/*7)Suppose you are a data analyst working for a travel company that offers vacation rentals similar to Airbnb. 
Your company wants to identify the top hosts with the highest average ratings for their listings. 
This information will be used to recognize exceptional hosts and potentially offer them incentives to continue providing outstanding service. 
Your task is to write an SQL query to find the top 2 hosts with the highest average ratings for their listings.
 However, you should only consider hosts who have at least 2 listings, as hosts with fewer listings may not be representative.
 Display output in descending order of average ratings and round the average ratings to 2 decimal places.*/


SELECT 
    l.host_id,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(DISTINCT l.listing_id) AS total_listings
FROM module.listings l
JOIN module.reviews r
    ON l.listing_id = r.listing_id
GROUP BY l.host_id
HAVING COUNT(DISTINCT l.listing_id) >= 2
ORDER BY average_rating DESC
LIMIT 2;

/*----------------------------------------------8 question----------------------------------*/
-- Books table
CREATE TABLE module.Books (
    BookID INT PRIMARY KEY,
    BookName VARCHAR(30),
    Genre VARCHAR(20)
);

-- Borrowers table
CREATE TABLE module.Borrowers (
    BorrowerID INT PRIMARY KEY,
    BorrowerName VARCHAR(10),
    BookID INT,
    FOREIGN KEY (BookID) REFERENCES module.Books(BookID)
);


-- Books
INSERT INTO module.Books (BookID, BookName, Genre) VALUES
(1, 'Harry Potter', 'Fantasy'),
(2, 'Pride and Prejudice', 'Romance'),
(3, 'The Hobbit', 'Fantasy'),
(4, '1984', 'Dystopian'),
(5, 'To Kill a Mockingbird', 'Classic');

-- Borrowers
INSERT INTO module.Borrowers (BorrowerID, BorrowerName, BookID) VALUES
(1, 'Alice', 1),
(2, 'Bob', 3),
(3, 'Alice', 3),
(4, 'Charlie', 2),
(5, 'Alice', 5),
(6, 'Bob', 4),
(7, 'Charlie', 5),
(8, 'David', 1),
(9, 'David', 2),
(10, 'Eve', 3);

/*8)"Imagine you're working for a library and you're tasked with generating a report on the borrowing habits of patrons.
 You have two tables in your database: Books and Borrowers.
 Write an SQL to display the name of each borrower along with a comma-separated list of the books they have borrowed in alphabetical order,
 display the output in ascending order of Borrower Name.*/
 
 SELECT bw.borrowername,group_concat(b.bookname ORDER BY b.bookname ASC) 
 FROM module.books b
 RIGHT JOIN module.borrowers bw
 on bw.bookid=b.bookid
 GROUP BY bw.borrowername
 ORDER BY bw.borrowername asc;
 
 
 /*--------------------------------------------9 question------------------------------------*/
 DROP TABLE IF EXISTS module.customer_orders;
 CREATE TABLE module.customer_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount INT
);

INSERT INTO module.customer_orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2025-08-01', 500),
(2, 102, '2025-08-01', 700),
(3, 103, '2025-08-01', 300),
(4, 101, '2025-08-02', 400),
(5, 104, '2025-08-02', 600),
(6, 102, '2025-08-03', 200),
(7, 105, '2025-08-03', 800),
(8, 103, '2025-08-04', 450),
(9, 106, '2025-08-04', 350),
(10, 101, '2025-08-05', 900);

/*9)Flipkart wants to build a very important business metrics where they want to track on daily basis how many new and repeat customers 
are purchasing products from their website. A new customer is defined when he purchased anything for the first time from the website and repeat customer
 is someone who has done at least one purchase in the past.
 Display order date , new customers , repeat customers in ascending order of repeat customers.*/
 
SELECT 
  o.order_date,
  COUNT(DISTINCT CASE WHEN o.order_date = f.first_order_date THEN o.customer_id END) AS new_customers,
  COUNT(DISTINCT CASE WHEN o.order_date > f.first_order_date THEN o.customer_id END) AS repeat_customers
FROM module.customer_orders o
JOIN (
  SELECT customer_id, MIN(order_date) AS first_order_date
  FROM module.customer_orders
  GROUP BY customer_id
) f
  ON f.customer_id = o.customer_id
GROUP BY o.order_date
ORDER BY repeat_customers, o.order_date;


/*---------------------------------------------10 QUESTION--------------------------------------------------*/
DROP TABLE IF EXISTS module.sachin;

CREATE TABLE module.sachin (
  match_no    INT PRIMARY KEY,
  runs_scored INT,
  status      VARCHAR(10)      -- 'out' or 'not out'
);

INSERT INTO module.sachin (match_no, runs_scored, status) VALUES
(1,  34, 'out'),
(2,  55, 'out'),
(3,  78, 'not out'),
(4,  22, 'out'),
(5,  91, 'out'),
(6,   0, 'out'),
(7, 123, 'not out'),
(8,  45, 'out'),
(9,  60, 'out'),
(10, 26, 'out');

/*10)"Sachin Tendulkar - Also known as little master. You are given runs scored by Sachin in his first 10 matches.
 You need to write an SQL to get match number when he completed 500 runs and his batting average at the end of 10 matches.
 Batting Average = (Total runs scored) / (no of times batsman got out)
 Round the result to 2 decimal places.*/

SELECT
  (SELECT MIN(s1.match_no)
   FROM module.sachin s1
   WHERE (SELECT SUM(s2.runs_scored)
          FROM module.sachin s2
          WHERE s2.match_no <= s1.match_no) >= 500) AS 'match no completing 500 runs' ,
  (SELECT ROUND(
            SUM(runs_scored) /
            NULLIF(SUM(CASE WHEN status='out' THEN 1 ELSE 0 END), 0)
         , 2)
   FROM module.sachin) AS batting_avg;

 /*----------------------------------------------------11 QUESTION---------------------------------------*/
DROP TABLE IF EXISTS module.students;
CREATE TABLE module.Students (
    class_id INT,
    student_id INT PRIMARY KEY,
    student_name VARCHAR(20)
);

DROP TABLE IF EXISTS module.grades;
CREATE TABLE module.Grades (
    student_id INT,
    subject VARCHAR(20),
    grade INT,
    FOREIGN KEY (student_id) REFERENCES module.Students(student_id)
);


-- Students
INSERT INTO module.Students (class_id, student_id, student_name) VALUES
(1, 101, 'Alice'),
(1, 102, 'Bob'),
(1, 103, 'Charlie'),
(2, 104, 'David'),
(2, 105, 'Eve');

-- Grades
INSERT INTO module.Grades (student_id, subject, grade) VALUES
(101, 'Math', 85),
(101, 'Science', 90),
(102, 'Math', 75),
(102, 'Science', 80),
(103, 'Math', 95),
(103, 'Science', 88),
(104, 'Math', 65),
(104, 'Science', 70),
(105, 'Math', 90),
(105, 'Science', 95);

/*11)You are provided with two tables: Students and Grades. Write a SQL query to find students who have higher grade in Math than the average grades
 of all the students together in Math. Display student name and grade in Math order by grades.*/
 
SELECT s.student_name,g.grade
from module.students s
JOIN module.grades g
on s.student_id=g.student_id
WHERE g.subject='math'
AND g.grade>(SELECT AVG(grade) FROM module.grades WHERE subject='Math')
ORDER BY g.grade;




/*------------------------------------------------------12 QUESTION------------------------------------------------------*/
DROP TABLE IF EXISTS module.orders;

CREATE TABLE module.orders (
    customer_id    INT,
    delivery_time  INT,
    order_id       INT,
    restaurant_id  INT,
    total_cost     INT
);


INSERT INTO module.orders (customer_id, delivery_time, order_id, restaurant_id, total_cost)
VALUES
(1, 30, 101, 201, 250),   -- Customer 1
(1, 25, 102, 202, 300),   -- Customer 1 again
(2, 40, 103, 203, 150),   -- Customer 2
(2, 35, 104, 202, 200),   -- Customer 2 again
(3, 20, 105, 204, 500),   -- Customer 3
(4, 50, 106, 205, 700),   -- Customer 4
(4, 45, 107, 201, 300),   -- Customer 4 again
(5, 25, 108, 202, 400);   -- Customer 5

/*12)"You are provided with data from a food delivery service called Deliveroo.
 Each order has details about the delivery time, the rating given by the customer,
 and the total cost of the order. Write an SQL to find customer with highest total expenditure.
 Display customer id and total expense by him/her.*/
 
 
SELECT customer_id,SUM(total_cost)
FROM module.orders
GROUP BY customer_id
HAVING SUM(total_cost)=(SELECT MAX(total) as "max of sum" FROM
 (SELECT SUM(total_cost) AS total 
 FROM module.orders 
 GROUP BY customer_id) as t);
 
 
 /*-------------------------------------------13 question-------------------------------------*/
 DROP TABLE IF EXISTS module.projects;

CREATE TABLE module.projects (
  project_id              INT PRIMARY KEY,
  employee_name           VARCHAR(10),
  project_completion_date DATE
);

INSERT INTO module.projects (project_id, employee_name, project_completion_date) VALUES
(100, 'Ankit',  '2022-12-15'),
(101, 'Shilpa', '2023-01-03'),
(102, 'Shilpa', '2023-01-15'),
(103, 'Shilpa', '2023-01-22'),
(104, 'Rahul',  '2023-01-05'),
(105, 'Rahul',  '2023-01-12'),
(106, 'Mukesh', '2023-01-23'),
(108, 'Mukesh', '2023-02-04');

/*13)"TCS wants to award employees based on number of projects completed by each individual each month.
 Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, 
display the output in descending order of number of completed projects*/








/*-------------------------------------------------------14 question-----------------------------------*/
DROP TABLE IF EXISTS module.employees;

CREATE TABLE module.employees (
  emp_id  INT,
  login   DATETIME,
  logout  DATETIME
);

INSERT INTO module.employees (emp_id, login, logout) VALUES
(100, '2024-02-19 09:15:00', '2024-02-19 18:20:00'),
(100, '2024-02-20 09:05:00', '2024-02-20 17:00:00'),
(100, '2024-02-21 09:00:00', '2024-02-21 17:10:00'),
(100, '2024-02-22 10:10:00', '2024-02-22 16:55:00'),
(100, '2024-02-23 10:00:00', '2024-02-23 19:15:00'),
(200, '2024-02-19 08:00:00', '2024-02-19 18:20:00'),
(200, '2024-02-20 09:00:00', '2024-02-20 16:30:00');

/*14)"Write a query to find workaholics employees. Workaholics employees are those who satisfy at least one of the given criterions: 
1- Worked for more than 8 hours a day for at least 3 days in a week. 
2- worked for more than 10 hours a day for at least 2 days in a week. 
You are given the login and logout timings of all the employees for a given week. 
Write a SQL to find all the workaholic employees along with the criterion that they are satisfying (1,2 or both), 
display it in the order of increasing employee id*/

SELECT
  s.emp_id,
  CASE
    WHEN s.days_over_8 >= 3 AND s.days_over_10 >= 2 THEN 'both'
    WHEN s.days_over_8 >= 3 THEN '1'
    WHEN s.days_over_10 >= 2 THEN '2'
  END AS requirement
FROM (
  SELECT
    emp_id,
    SUM(CASE WHEN hours_worked > 8  THEN 1 ELSE 0 END)  AS days_over_8,
    SUM(CASE WHEN hours_worked > 10 THEN 1 ELSE 0 END)  AS days_over_10
  FROM (
    SELECT
      emp_id,
      DATE(login) AS work_date,
      SUM(TIMESTAMPDIFF(MINUTE, login, logout))/60.0 AS hours_worked
    FROM module.employees
    GROUP BY emp_id, DATE(login)
  ) d
  GROUP BY emp_id
) s
WHERE s.days_over_8 >= 3 OR s.days_over_10 >= 2
ORDER BY s.emp_id;

/*----------------------------------------15 question------------------------------------------------*/
DROP TABLE IF EXISTS module.lift_passengers;
DROP TABLE IF EXISTS module.lifts;

CREATE TABLE module.lifts (
  id          INT PRIMARY KEY,
  capacity_kg INT
);

CREATE TABLE module.lift_passengers (
  passenger_name VARCHAR(10),
  weight_kg      INT,
  lift_id        INT
);


INSERT INTO module.lifts (id, capacity_kg) VALUES
(1, 300),
(2, 350);

INSERT INTO module.lift_passengers (passenger_name, weight_kg, lift_id) VALUES
('Rahul',   85, 1),
('Adarsh',  73, 1),
('Riti',    95, 1),
('Dheeraj', 80, 1),
('Vimal',   83, 2);

/*15)"You are given a table of list of lifts , their maximum capacity and people along with their weight who wants to enter into it. 
You need to make sure maximum people enter into the lift without lift getting overloaded. 
For each lift find the comma separated list of people who can be accommodated.
 The comma separated list should have people in the order of their weight in increasing order, 
display the output in increasing order of id.*/









/*-----------------------------------------------16 question----------------------------------------*/
-- ---------- Setup ----------
DROP TABLE IF EXISTS module.lift_passengers;
DROP TABLE IF EXISTS module.lifts;

CREATE TABLE module.lifts (
  id          INT PRIMARY KEY,
  capacity_kg INT
);

CREATE TABLE module.lift_passengers (
  passenger_name VARCHAR(10),
  weight_kg      INT,
  gender         VARCHAR(1),  
  lift_id        INT
);

-- Sample data
INSERT INTO module.lifts (id, capacity_kg) VALUES
(1, 300),
(2, 350);

INSERT INTO module.lift_passengers (passenger_name, weight_kg, gender, lift_id) VALUES
('Rahul',   85, 'M', 1),
('Adarsh',  73, 'M', 1),
('Riti',    65, 'F', 1),
('Dheeraj', 80, 'M', 1),
('Vimal',   83, 'M', 2),
('Sneha',   55, 'F', 2),
('Priya',   60, 'F', 2),
('Aman',    90, 'M', 2),
('Jeet',    70, 'M', 2);

/*16)"You are given a table of list of lifts , their maximum capacity and people along with their weight and gender who wants to enter into it. 
You need to make sure maximum people enter into the lift without lift getting overloaded but you need to give preference to female passengers first. 
For each lift find the comma separated list of people who can be accomodated.
 The comma separated list should have female first and then people in the order of their weight in increasing order, 
display the output in increasing order of id.*/


 
 
 
 
 
 
 
 /*-----------------------------------------------17 QUESTION------------------------------------*/
DROP TABLE IF EXISTS module.business_operations;
CREATE TABLE module.business_operations (
    business_date DATE,
    city_id INT
);


INSERT INTO module.business_operations (business_date, city_id) VALUES
('2020-01-02', 3),
('2020-07-01', 7),
('2021-01-01', 3), 
('2021-02-03', 19), 
('2022-12-01', 3),  
('2022-12-15', 3),  
('2022-02-28', 12);

/*17)"Amazon is expanding their pharmacy business to new cities every year.
 You are given a table of business operations where you have information about cities where Amazon is doing operations
 along with the business date information.
 
 Write a SQL to find year wise number of new cities added to the business,
 display the output in increasing order of year.*/
 
 SELECT YEAR(first_date),COUNT(city_id)
 FROM (SELECT city_id,MIN(business_date) AS first_date FROM module.business_operations GROUP BY city_id) AS T
 GROUP BY YEAR(first_date)
 ORDER BY YEAR(first_date);
 
 /*-----------------------------------------18 question----------------------------------------*/

DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  category    VARCHAR(15),
  order_id    INT,
  product_id  VARCHAR(20),
  quantity    INT,
  unit_price  INT
);

INSERT INTO module.orders (category, order_id, product_id, quantity, unit_price) VALUES
-- Mobiles
('Mobiles',  1, 'M_A52',    3, 25000),
('Mobiles',  2, 'M_A52',    2, 25000),     
('Mobiles',  3, 'M_Redmi',  5, 15000),
('Mobiles',  4, 'M_Redmi',  1, 15000),      
('Mobiles',  5, 'M_Pixel',  5, 60000),      
('Laptops',  6, 'L_HP',     4, 50000),
('Laptops',  7, 'L_Dell',   4, 55000),
('Laptops', 12, 'L_HP',     2, 50000),      
('Laptops', 13, 'L_Dell',   2, 55000),     
('Accessories', 9, 'A_Mouse', 10,  500),  
('Accessories', 10, 'A_Headset',  10, 1500);  

/*18)"Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category. 
In case of a tie when quantities sold are same for more than 1 product, then we need to give preference to the product with higher sales value. 
Display category and product in output with category in ascending order.*/
SELECT category,SUBSTRING_INDEX(
    GROUP_CONCAT(product_id ORDER BY qty DESC, revenue DESC, product_id SEPARATOR ','),
    ',', 1
  ) AS product_id
FROM (
  SELECT category,product_id,
    SUM(quantity) AS qty,
    SUM(quantity * unit_price) AS revenue
  FROM module.orders
  GROUP BY category, product_id
) AS agg
GROUP BY category
ORDER BY category;

/*---------------------------------------19 question-------------------------------------------*/

DROP TABLE IF EXISTS module.orders;
DROP TABLE IF EXISTS module.products;

CREATE TABLE module.products (
  product_id         INT PRIMARY KEY,
  product_name       VARCHAR(10),
  available_quantity INT
);

CREATE TABLE module.orders (
  order_id           INT PRIMARY KEY,
  product_id         INT,
  order_date         DATE,
  quantity_requested INT,
  FOREIGN KEY (product_id) REFERENCES module.products(product_id)
);

INSERT INTO module.products (product_id, product_name, available_quantity) VALUES
(1,'Product A',10),
(2,'Product B',20),
(3,'Product C',15),
(4,'Product D',10);

INSERT INTO module.orders (order_id, product_id, order_date, quantity_requested) VALUES
(1, 1, '2024-01-01', 5),
(2, 1, '2024-01-02', 7),
(3, 2, '2024-01-03',10),
(4, 2, '2024-01-04',10),
(5, 2, '2024-01-05', 5),
(6, 3, '2024-01-06', 4),
(7, 3, '2024-01-07', 5),
(8, 4, '2024-01-08', 4),
(9, 4, '2024-01-09', 5),
(10,4, '2024-01-10', 8);

/*19)"You are given two tables: products and orders. The products table contains information about each product,
 including the product ID and available quantity in the warehouse. The orders table contains details about customer orders,
 including the order ID, product ID, order date, and quantity requested by the customer. 
 Write an SQL query to generate a report listing the orders that can be fulfilled based on the available inventory in the warehouse,
 following a first-come-first-serve approach based on the order date. Each row in the report should include the order ID, product name, 
 quantity requested by the customer, quantity actually fulfilled, and a comments column as below:
 If the order can be completely fulfilled then 'Full Order'.
 If the order can be partially fulfilled then 'Partial Order'. 
 If order can not be fulfilled at all then 'No Order' .
 Display the output in ascending order of order id.






/*-----------------------------------20 question-----------------------------------------*/

DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
  order_month VARCHAR(6),   
  product_id  VARCHAR(5),
  sales       INT
);


INSERT INTO module.orders (order_month, product_id, sales) VALUES
('202301','p1',100), ('202301','p2',500),
('202302','p1',700), ('202302','p2',300),
('202303','p1',900), ('202303','p2',600),
('202304','p1',2000),('202304','p2',1200),
('202305','p1',1500),('202305','p2',1300),
('202306','p1',1700),('202306','p2',1600);

/*20)"Amazon wants to find out the trending products for each month. 
Trending products are those for which any given month sales are more than the sum of previous 2 months sales for that product. 
Please note that for first 2 months of operations this metrics does not make sense. So output should start from 3rd month only.
 Assume that each product has at least 1 sale each month, display order month and product id. Sort by order month.*/
SELECT t.order_month, t.product_id
FROM module.orders AS t
JOIN module.orders AS p1
  ON p1.product_id = t.product_id
 AND p1.order_month = DATE_FORMAT(
       DATE_SUB(STR_TO_DATE(CONCAT(t.order_month,'01'), '%Y%m%d'), INTERVAL 1 MONTH),
       '%Y%m'
     )
JOIN module.orders AS p2
  ON p2.product_id = t.product_id
 AND p2.order_month = DATE_FORMAT(
       DATE_SUB(STR_TO_DATE(CONCAT(t.order_month,'01'), '%Y%m%d'), INTERVAL 2 MONTH),
       '%Y%m'
     )
WHERE t.sales > (p1.sales + p2.sales)
ORDER BY t.order_month, t.product_id;

/*----------------------------------------21 question-----------------------------------------*/

DROP TABLE IF EXISTS module.drivers;
CREATE TABLE module.drivers (
  id         VARCHAR(10),
  start_loc  CHAR(1),
  start_time TIME,
  end_loc    CHAR(1),
  end_time   TIME
);

INSERT INTO module.drivers (id,start_loc,start_time,end_loc,end_time) VALUES
('dri_1','a','09:00:00','b','09:30:00'),
('dri_1','b','09:30:00','c','10:30:00'),
('dri_1','d','11:00:00','e','11:30:00'),
('dri_1','f','12:00:00','g','12:30:00'),
('dri_1','c','13:30:00','e','14:30:00'),
('dri_2','f','12:15:00','g','12:30:00'),
('dri_2','c','12:30:00','h','14:30:00');

/*21)"A profit ride for a Uber driver is considered when the start location and 
start time of a ride exactly match with the previous ride's end location and end time.
 Write an SQL to calculate total number of rides and total profit rides by each driver, 
display the output in ascending order of id*/
SELECT d.id,COUNT(*) AS total_rides,SUM(CASE WHEN p.id IS NOT NULL THEN 1 ELSE 0 END) AS profit_rides
FROM module.drivers d
LEFT JOIN module.drivers p
  ON p.id = d.id
 AND p.end_time = d.start_time
 AND p.end_loc  = d.start_loc
GROUP BY d.id
ORDER BY d.id;

/*----------------------------------------22 question--------------------------------------*/

DROP TABLE IF EXISTS module.survey;
CREATE TABLE module.survey (
  country          VARCHAR(20),
  job_satisfaction INT,
  name             VARCHAR(10)
);

INSERT INTO module.survey (name, job_satisfaction, country) VALUES
('Alex',   4, 'USA'),
('Saurabh',5, 'US'),
('Mark',   3, 'United States'),
('Shane',  4, 'USA'),
('Kim',    5, 'United States'),
('Joe',    5, 'US'),
('Mira',   5, 'United States'),
('John',   3, 'USA'),
('Jane',   5, 'United States'),
('Sam',    3, 'US'),
('Sara',   4, 'USA');

/*22)"In some poorly designed UI applications, there's often a lack of data input restrictions.
 For instance, in a free text field for the country, users might input variations such as 'USA,' 'United States of America,' or 'US.' 
 Suppose we have survey data from individuals in the USA about their job satisfaction, rated on a scale of 1 to 5.
 Write a SQL query to count the number of respondents for each rating on the scale.
 Additionally, include the country name in the format that occurs most frequently in that scale, 
display the output in ascending order of job satisfaction.*/
SELECT
  job_satisfaction,
  SUM(cnt) AS respondents,
  SUBSTRING_INDEX(
    GROUP_CONCAT(country ORDER BY cnt DESC, country SEPARATOR ','),
    ',', 1
  ) AS country_format
FROM (
  SELECT job_satisfaction, country, COUNT(*) AS cnt
  FROM module.survey
  GROUP BY job_satisfaction, country
) AS c
GROUP BY job_satisfaction
ORDER BY job_satisfaction;



/*---------------------------------------------23 question---------------------------------*/
DROP TABLE IF EXISTS module.orders;
CREATE TABLE module.orders (
    order_id INT,
    customer_id INT,
    product_id VARCHAR(2)
);


INSERT INTO module.orders (order_id, customer_id, product_id) VALUES
(1, 101, 'A'),
(1, 101, 'B'),
(1, 101, 'C'),
(2, 102, 'A'),
(2, 102, 'B'),
(3, 103, 'B'),
(3, 103, 'C'),
(4, 104, 'A'),
(4, 104, 'C'),
(5, 105, 'A'),
(5, 105, 'B'),
(6, 106, 'B'),
(6, 106, 'C'),
(7, 107, 'A'),
(7, 107, 'B');

/*23)Product recommendation. Just the basic type (“customers who bought this also bought…”). 
That, in its simplest form, is an outcome of basket analysis. 
Write a SQL to find the product pairs which have been purchased together in same order
 along with the purchase frequency (count of times they have been purchased together). 
 Based on this data Amazon can recommend frequently bought together products to other users. 
 Order the output by purchase frequency in descending order. 
Please make in the output first product column has id greater than second product column.*/




/*---------------------------------24 question---------------------------------------*/

DROP TABLE IF EXISTS module.transactions;
DROP TABLE IF EXISTS module.users;

CREATE TABLE module.users (
  user_id         INT PRIMARY KEY,
  username        VARCHAR(10),
  opening_balance INT
);

CREATE TABLE module.transactions (
  id          INT PRIMARY KEY,
  from_userid INT,
  to_userid   INT,
  amount      INT
);

INSERT INTO module.users VALUES
(100,'Ankit',1000),
(101,'Rahul',9000),
(102,'Amit', 5000),
(103,'Agam', 7500);

INSERT INTO module.transactions VALUES
(1,100,102, 500),
(2,102,101, 700),
(3,101,102, 600),
(4,102,100,1500),
(5,102,101, 800),
(6,102,101, 300);

/*24)"You are given a list of users and their opening account balance along with the transactions done by them. 
Write a SQL to calculate their account balance at the end of all the transactions.
 Please note that users can do transactions among themselves as well, display the output in ascending order of the final balance.*/
 
 SELECT
  u.user_id,
  u.username,
  u.opening_balance
    + COALESCE(SUM(CASE WHEN t.to_userid   = u.user_id THEN t.amount END), 0)
    - COALESCE(SUM(CASE WHEN t.from_userid = u.user_id THEN t.amount END), 0)
    AS final_balance
FROM module.users u
LEFT JOIN module.transactions t
  ON t.from_userid = u.user_id OR t.to_userid = u.user_id
GROUP BY u.user_id, u.username, u.opening_balance
ORDER BY final_balance ASC, u.user_id;



/*-----------------------------------------31 question---------------------------------------*/

CREATE TABLE module.employee (
    emp_id INT PRIMARY KEY,
    salary INT,
    department VARCHAR(15)
);


INSERT INTO module.employee (emp_id, salary, department) VALUES
(100, 40000, 'Analytics'),
(101, 30000, 'Analytics'),
(102, 50000, 'Analytics'),
(103, 45000, 'Engineering'),
(104, 48000, 'Engineering'),
(105, 51000, 'Engineering'),
(106, 46000, 'Science'),
(107, 38000, 'Science'),
(108, 37000, 'Science'),
(109, 42000, 'Analytics'),
(110, 55000, 'Engineering');

/*31)You are given the data of employees along with their salary and department. Write an SQL to find list of employees who have salary
 greater than average employee salary of the company. However, while calculating the company average salary to compare 
with an employee salary do not consider salaries of that employee's department, 
display the output in ascending order of employee ids.*/


SELECT e1.emp_id, e1.salary, e1.department
FROM module.employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM module.employee e2
    WHERE e2.department <> e1.department
)
ORDER BY e1.emp_id ASC;


/*-----------------------------------32 question---------------------------------*/
CREATE TABLE module.users (
    user_name VARCHAR(10),
    monthly_salary INT,
    savings INT
);


CREATE TABLE module.phones (
    cost INT,
    phone_name VARCHAR(15)
);

-- Insert sample users
INSERT INTO module.users (user_name, monthly_salary, savings) VALUES
('Anjali', 50000, 15000),
('Ravi', 30000, 5000),
('Priya', 60000, 25000),
('Karan', 40000, 10000);

-- Insert sample phones
INSERT INTO module.phones (cost, phone_name) VALUES
(40000, 'iPhone 13'),
(30000, 'Samsung S21'),
(20000, 'Redmi Note 12'),
(50000, 'OnePlus 11'),
(15000, 'Realme 9');

/*32)an influential figure in Indian social media, shares a guideline in one of his videos called the 20-6-20 rule for 
determining whether one can afford to buy a phone or not. The rule for affordability entails three conditions: 
1. Having enough savings to cover a 20 percent down payment. 
2. Utilizing a maximum 6-month EMI plan (no-cost) for the remaining cost. 
3. Monthly EMI should not exceed 20 percent of one's monthly salary. 
Given the salary and savings of various users, along with data on phone costs, 
the task is to write an SQL to generate a list of phones (comma-separated) that each user can afford based on these criteria,
 display the output in ascending order of the user name.*/
 
 SELECT u.user_name,group_concat(p.phone_name order by p.phone_name) as affordable_phones
 FROM module.users u
 JOIN module.phones p
 on u.savings>=0.2*p.cost
 and (0.8*p.cost)/6<=0.2*u.monthly_salary
 GROUP BY u.user_name
 ORDER BY u.user_name;
 
 
  /*-------------------------------------34 question----------------------*/
 DROP TABLE IF EXISTS module.employee; 
 CREATE TABLE module.employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(10),
    joining_date DATE,
    salary INT,
    manager_id INT
);

 
 INSERT INTO module.employee (emp_id, emp_name, joining_date, salary, manager_id) VALUES
(1, 'Alice', '2015-01-10', 80000, NULL),   -- Top manager, no manager
(2, 'Bob', '2016-03-15', 60000, 1),        -- Managed by Alice
(3, 'Charlie', '2017-07-20', 70000, 1),    -- Managed by Alice
(4, 'David', '2018-06-01', 75000, 2),      -- Managed by Bob
(5, 'Eve', '2019-05-12', 65000, 2),        -- Managed by Bob
(6, 'Frank', '2020-09-10', 80000, 3),      -- Managed by Charlie
(7, 'Grace', '2021-01-25', 50000, 4);      -- Managed by David

/*34)You are given the table of employee details. Write an SQL to find details of employee with salary more than their manager salary
 but they joined the company after the manager joined. Display employee name, salary and joining date along with their manager's 
 salary and joining date, sort the output in ascending order of employee name. 
Please note that manager id in the employee table referring to emp id of the same table.*/
 
 SELECT e.emp_name,e.salary,e.joining_date,m.salary,m.joining_date
 FROM module.employee e
 JOIN module.employee m
 ON e.manager_id=m.emp_id
 WHERE e.salary> m.salary
 AND e.joining_date > m.joining_date
ORDER BY e.emp_name ASC;

/*-------------------------------------------------37 question-------------------------------------*/

CREATE TABLE module.playlists (
    playlist_id INT PRIMARY KEY,
    playlist_name VARCHAR(15)
);

-- Create playlist_tracks table
CREATE TABLE module.playlist_tracks (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES module.playlists(playlist_id)
);

-- Create playlist_plays table
CREATE TABLE module.playlist_plays (
    playlist_id INT,
    user_id VARCHAR(2),
    PRIMARY KEY (playlist_id, user_id),
    FOREIGN KEY (playlist_id) REFERENCES module.playlists(playlist_id)
);


-- Insert sample data into playlists
INSERT INTO module.playlists (playlist_id, playlist_name) VALUES
(1, 'Rock Classics'),
(2, 'Pop Hits'),
(3, 'Jazz Vibes'),
(4, 'Indie Mix');

-- Insert sample data into playlist_tracks
INSERT INTO module.playlist_tracks (playlist_id, track_id) VALUES
(1, 101),
(1, 102),
(1, 103),
(2, 101),
(2, 104),
(2, 105),
(3, 106),
(3, 107),
(4, 101),
(4, 108);


INSERT INTO module.playlist_plays (playlist_id, user_id) VALUES
(1, 'U1'),
(1, 'U2'),
(2, 'U2'),
(2, 'U3'),
(3, 'U1'),
(3, 'U4'),
(4, 'U1');  



/*37)Suppose you are a data analyst working for Spotify (a music streaming service company) . 
Your company is interested in analyzing user engagement with playlists and wants to identify the most popular tracks 
among all the playlists. Write an SQL query to find the top 2 most popular tracks based on number of playlists they are part of. 
Your query should return the top 2 track ID along with total number of playlist they are part of , sorted by the same and track id in 
descending order , 
Please consider only those playlists which were played by at least 2 distinct users.*/

SELECT 
    pt.track_id,
    COUNT(DISTINCT pt.playlist_id) AS total_playlists
FROM module.playlist_tracks pt
JOIN (
    SELECT playlist_id
    FROM module.playlist_plays
    GROUP BY playlist_id
    HAVING COUNT(DISTINCT user_id) >= 2
) valid_playlists
    ON pt.playlist_id = valid_playlists.playlist_id
GROUP BY pt.track_id
ORDER BY total_playlists DESC, pt.track_id DESC
LIMIT 2;


/*-------------------------------------- 38 QUESTION -----------------------------------------*/
CREATE TABLE module.product_reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    review_text VARCHAR(40)
);


INSERT INTO module.product_reviews (review_id, product_id, review_text) VALUES
(1, 101, 'This product is excellent'),
(2, 102, 'Absolutely AMAZING quality'),
(3, 103, 'Not excellent at all'),
(4, 104, 'The design is amazing'),
(5, 105, 'NOT AMAZING at all'),
(6, 106, 'Excellent value for money'),
(7, 107, 'Not bad, but not excellent either'),
(8, 108, 'The features are simply amazing'),
(9, 109, 'It is not amazing'),
(10, 110, 'Really excellent and durable');

 /*38)Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to
 identify trends and patterns in product reviews. Your task is to write an SQL query to find all product reviews containing the
 word ""excellent"" or ""amazing"" in the review text. However, you want to exclude reviews that contain the
 word ""not"" immediately before ""excellent"" or ""amazing"". Please note that the words can be in upper or lower case or combination of both.
 Your query should return the review_id,product_id, and review_text for each review meeting the criteria,
 display the output in ascending order of review_id.*/
 
 SELECT review_id, product_id, review_text
FROM module.product_reviews
WHERE 
    (review_text LIKE '%excellent%' OR review_text LIKE '%amazing%')
    AND review_text NOT LIKE '%not excellent%'
    AND review_text NOT LIKE '%not amazing%'
ORDER BY review_id;

 
 
 
 
 
 
 
 
 
 
 