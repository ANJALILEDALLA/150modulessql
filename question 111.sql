DROP TABLE IF EXISTS module.hierarchy;
CREATE TABLE module.hierarchy (
  e_id VARCHAR(1),
  m_id VARCHAR(1)
);

INSERT INTO module.hierarchy (e_id,m_id) VALUES
('A','C'),
('B','C'),
('C','F'),
('D','E'),
('E','F'),
('G','E'),
('H','G'),
('I','F'),
('J','I'),
('K','I');

/*111)Write a SQL query to find the number of reportees (both direct and indirect) under each manager. The output should include:

m_id: The manager ID.

num_of_reportees: The total number of unique reportees (both direct and indirect) under that manager.

Order the result by number of reportees in descending order.
*/
WITH RECURSIVE org AS (
  SELECT m_id AS root_manager, e_id
  FROM module.hierarchy
  UNION ALL
  SELECT o.root_manager, h.e_id
  FROM org o
  JOIN module.hierarchy h
    ON h.m_id = o.e_id
)
SELECT root_manager AS m_id,
       COUNT(DISTINCT e_id) AS num_of_reportees
FROM org
GROUP BY root_manager
ORDER BY num_of_reportees DESC, m_id;
