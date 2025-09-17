DROP TABLE IF EXISTS module.people;
CREATE TABLE module.people (
  id INT,
  name VARCHAR(20),
  gender CHAR(2)
);

DROP TABLE IF EXISTS module.relations;
CREATE TABLE module.relations (
  c_id INT,
  p_id INT
);

INSERT INTO module.people VALUES
(107,'Days','F'),
(145,'Hawbaker','M'),
(155,'Hansel','F'),
(202,'Blackston','M'),
(227,'Criss','F'),
(278,'Keffer','M'),
(305,'Canty','M'),
(329,'Mozingo','M'),
(425,'Nolf','M'),
(534,'Waugh','M');

INSERT INTO module.relations VALUES
(145,202),
(145,107),
(278,305),
(278,155),
(329,425),
(329,227),
(534,586);


/*82You are tasked to determine the mother and father's name for each child based on the given data. The people
 table provides information about individuals, including their names and genders. 
 The relations table specifies parent-child relationships, linking each child (c_id) to their parent (p_id).
 Each parent is identified by their ID, and their gender is used to distinguish between mothers (F) and fathers (M).

Write an SQL query to retrieve the names of each child along with the names of their respective mother and father, 
if available. If a child has only one parent listed in the relations table, the query should still include that parent's name and
 leave the other parent's name as NULL.
 Order the output by child name in ascending order.*/
 
 
SELECT
  c.name AS child_name,
  MAX(CASE WHEN p.gender = 'F' THEN p.name END) AS mother_name,
  MAX(CASE WHEN p.gender = 'M' THEN p.name END) AS father_name
FROM module.relations r
JOIN module.people c ON c.id = r.c_id
LEFT JOIN module.people p ON p.id = r.p_id
GROUP BY c.id, c.name
ORDER BY child_name;
