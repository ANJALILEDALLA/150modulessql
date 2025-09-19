DROP TABLE IF EXISTS module.projects;
CREATE TABLE module.projects (
  id INT,
  project_number INT,
  Source_System VARCHAR(20)
);

INSERT INTO module.projects VALUES
(1,1001,'EagleEye'),
(2,1001,'SwiftLink'),
(3,1001,'DataVault'),
(4,1002,'SwiftLink'),
(5,1003,'DataVault'),
(6,1004,'EagleEye'),
(7,1004,'SwiftLink'),
(8,1005,'DataVault'),
(9,1005,'EagleEye'),
(10,1006,'EagleEye'),
(11,1007,'DataVault');


/*133)"A company manages project data from three source systems with varying reliability:
 EagleEye: The most reliable and prioritized internal system. SwiftLink: A trusted partner system with moderate reliability. 
 DataVault: A third-party system used as a fallback. Data for a project can come from multiple systems. 
 For each project, you need to select the most reliable data by prioritizing the source systems:
 EagleEye > SwiftLink > DataVault Write an SQL to display id , project number and selected source system*/
 
 
WITH ranked AS (
  SELECT
    id,
    project_number,
    Source_System,
    ROW_NUMBER() OVER (
      PARTITION BY project_number
      ORDER BY CASE Source_System
                 WHEN 'EagleEye' THEN 1
                 WHEN 'SwiftLink' THEN 2
                 WHEN 'DataVault' THEN 3
                 ELSE 4
               END, id
    ) AS rn
  FROM module.projects
)
SELECT id, project_number, Source_System AS selected_source_system
FROM ranked
WHERE rn = 1
ORDER BY project_number;
