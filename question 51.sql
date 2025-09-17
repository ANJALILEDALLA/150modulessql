DROP TABLE IF EXISTS module.candidates;
CREATE TABLE module.candidates(
  emp_id INT,
  experience VARCHAR(6),
  salary INT
);

INSERT INTO module.candidates VALUES
(1,'Junior',10000),
(2,'Junior',15000),
(3,'Junior',40000),
(4,'Senior',16000),
(5,'Senior',20000),
(6,'Senior',50000);

/*51)"Suppose you are a manager of a data analytics company. You are tasked to build a new team consists of senior and 
junior data analysts. The total budget for the salaries is 70000. You need to use the below criterion for hiring: 
1- Keep hiring the seniors with the smallest salaries until you cannot hire anymore seniors.
 2- Use the remaining budget to hire the juniors with the smallest salaries until you cannot hire anymore juniors.
 Display employee id, experience and salary. Sort in decreasing order of salary.*/


with total_sal as
(
select *,
sum(salary) over(partition by experience order by salary rows between unbounded preceding and current row) as running_sal
from candidates
)
,seniors as
(
select *
from total_sal
where experience='Senior' and running_sal<=70000
)
select emp_id,experience,salary from seniors
union all
select emp_id,experience,salary from total_sal
where experience='Junior'
and running_sal<=70000-(select sum(salary) from seniors)
order by salary desc;
