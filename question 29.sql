DROP TABLE IF EXISTS module.Employees;
CREATE TABLE module.Employees (
    EmployeeID INT,
    Name VARCHAR(20),
    JoinDate DATE,
    JobTitle VARCHAR(20)
);

INSERT INTO module.Employees VALUES
(1, 'John Doe', '2021-02-15', 'Software Engineer'),
(2, 'Jane Smith', '2022-03-20', 'Software Developer'),
(3, 'Alice Johnson', '2021-12-10', 'Software Engineer'),
(4, 'Bob Anderson', '2022-01-05', 'Project Manager'),
(5, 'Ella Williams', '2022-04-25', 'Software Engineer'),
(6, 'Michael Brown', '2022-03-10', 'Data Analyst'),
(7, 'Sophia Garcia', '2022-02-28', 'Software Engineer'),
(8, 'James Martinez', '2022-01-15', 'Project Manager'),
(9, 'Olivia Robinson', '2022-04-05', 'Software Engineer'),
(10, 'Liam Clark', '2022-03-01', 'Software Engineer'),
(11, 'Noah Thompson', '2022-05-10', 'Data Scientist');

/*29)"You are given the details of employees of a new startup.
 Write an SQL query to retrieve number of Software Engineers , Data Professionals and Managers in the team to separate columns.
 Below are the rules to identify them using Job Title.
 1- Software Engineers : The title should starts with “Software”
 2- Data Professionals : The title should starts with “Data” 
3- Managers : The title should contain ""Managers""*/

SELECT 
    SUM(CASE WHEN JobTitle LIKE 'Software%' THEN 1 ELSE 0 END) AS Software_Engineers,
    SUM(CASE WHEN JobTitle LIKE 'Data%' THEN 1 ELSE 0 END) AS Data_Professionals,
    SUM(CASE WHEN JobTitle LIKE '%Manager%' THEN 1 ELSE 0 END) AS Managers
FROM module.Employees;
