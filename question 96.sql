DROP TABLE IF EXISTS module.tickets;
CREATE TABLE module.tickets(
  airline_number VARCHAR(10),
  origin VARCHAR(3),
  destination VARCHAR(3),
  oneway_round CHAR(1),
  ticket_count INT
);

INSERT INTO module.tickets VALUES
('DEF456','BOM','DEL','O',150),
('GHI789','DEL','BOM','R',50),
('JKL012','BOM','DEL','R',75),
('MNO345','DEL','NYC','O',200),
('PQR678','NYC','DEL','O',180),
('STU901','NYC','DEL','R',60),
('ABC123','DEL','BOM','O',100),
('VWX234','DEL','NYC','R',90);

/*96)"You are given a table named ""tickets"" containing information about airline tickets sold. 
Write an SQL query to find the busiest route based on the total number of tickets sold. Also display total ticket count for that route.
 oneway_round ='O' -> One Way Trip oneway_round ='R' -> Round Trip Note: DEL -> BOM is different route from BOM -> DEL */
 
 SELECT origin,destination,SUM(ticket_count) as total
 FROM module.tickets
 group by origin,destination
 HAVING total=(SELECT MAX(ticket) FROM (SELECT SUM(ticket_count) as ticket FROM module.tickets GROUP BY origin,destination) as t)
 ORDER BY total desc;
 
