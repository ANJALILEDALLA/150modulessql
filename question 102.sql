CREATE TABLE module.user_passwords (
    user_id INT,
    user_name VARCHAR(10),
    password VARCHAR(20)
);


INSERT INTO module.user_passwords (user_id, user_name, password) VALUES
(1, 'Arjun', 'password123@'),
(2, 'Rahul', 'rahul12'),
(3, 'Sneha', 'Sneha@123'),
(4, 'Vikram', 'Vikram$$1234'),
(5, 'Priya', 'Priya12345@'),
(6, 'Amit', 'Amit*password 123'),
(7, 'Neha', 'Neha#123'),
(8, 'Rohit', '@12345678');

/*102)"Write a SQL query to identify the users with valid passwords according to the conditions below. 
The password must be at least 8 characters long. The password must contain at least one letter (lowercase or uppercase). 
The password must contain at least one digit (0-9). 
The password must contain at least one special character from the set @#$%^&*. 
The password must not contain any spaces.*/

SELECT user_id, user_name
FROM module.user_passwords
WHERE LENGTH(password) >= 8
  AND password REGEXP '[A-Za-z]'     
  AND password REGEXP '[0-9]'       
  AND password REGEXP '[@#$%^&*]'    
  AND password NOT LIKE '% %';  
  