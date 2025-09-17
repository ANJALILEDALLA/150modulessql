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
 