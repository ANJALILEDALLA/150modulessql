DROP TABLE IF EXISTS module.items;
CREATE TABLE module.items (
  id INT,
  weight INT
);

INSERT INTO module.items VALUES
(1,1),
(2,3),
(3,5),
(4,3),
(5,2),
(6,1),
(7,4),
(8,1),
(9,2),
(10,5),
(11,1),
(12,3);

/*121)During a warehouse packaging process, items of various weights (1 kg to 5 kg) need to be packed sequentially into boxes.
 Each box can hold a maximum of 5 kg in total. The items are presented in a table according to their arrival order, and 
 the goal is to pack them into boxes, keeping the order (based on id) while ensuring each box’s total weight does not 
 exceed 5 kg.
**Requirements**:
1. Pack items into boxes in their given order based on id.
2. Each box should not exceed 5 kg in total weight.
3. Once a box reaches the 5 kg limit or would exceed it by adding the next item, start packing into a new box.
4. Assign a box number to each item based on its position in the sequence, so that items within each box do not exceed the 
5 kg limit.

**Example**:
Given the items with weights `[1, 3, 5, 3, 2]`, we need to pack them into boxes as follows:

- **Box 1**: Items with weights `[1, 3]` — Total weight = 4 kg
- **Box 2**: Item with weight `[5]` — Total weight = 5 kg
- **Box 3**: Items with weights `[3, 2]` — Total weight = 5 kg

The result should display each item , weight and its assigned box number starting from 1.
*/
WITH RECURSIVE
seq AS (
  SELECT id, weight, ROW_NUMBER() OVER (ORDER BY id) AS rn
  FROM module.items
),
pack AS (
  SELECT rn, id, weight, 1 AS box_no, weight AS box_sum
  FROM seq
  WHERE rn = 1
  UNION ALL
  SELECT s.rn, s.id, s.weight,
         CASE WHEN p.box_sum + s.weight > 5 THEN p.box_no + 1 ELSE p.box_no END,
         CASE WHEN p.box_sum + s.weight > 5 THEN s.weight ELSE p.box_sum + s.weight END
  FROM pack p
  JOIN seq s ON s.rn = p.rn + 1
)
SELECT id, weight, box_no
FROM pack
ORDER BY id;

