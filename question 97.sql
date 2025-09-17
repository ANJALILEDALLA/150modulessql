DROP TABLE IF EXISTS module.Customers;
CREATE TABLE module.Customers(
  CustomerID INT,
  Email VARCHAR(25)
);

INSERT INTO module.Customers VALUES
(1,'john@gmail.com'),
(2,'jane.doe@yahoo.org'),
(3,'alice.smith@amazon.net'),
(4,'bob@gmail.com'),
(5,'charlie@microsoft.com');

/*97)Write an SQL query to extract the domain names from email addresses stored in the Customers table.*/
SELECT customerid,email,SUBSTRING_INDEX(email,'@',-1) as domain
FROM module.customers;
