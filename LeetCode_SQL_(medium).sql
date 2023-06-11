--#176. Second Highest Salary

select salary
from
	(select *,
	 nth_value(salary, 2) over(order by salary desc
	 range between unbounded preceding and unbounded following) as second_highest_salary
	 from employee) emp_salary
where salary = second_highest_salary

Select salary
from employee
order by salary desc
limit 1 offset 1;

--#178. Rank Scores

select *,
dense_rank () over (order by score desc) as rank
from scores

--#180. Consecutive Numbers

with cte_logs as
	(select *,
	lag (num, 1) over(order by id) as prev_val,
	lag (num, 2) over (order by id) as prev_prev_val
	from logs)
select num as consecutive_numb
from cte_logs
where num = prev_val and num = prev_prev_val

--#184. Department Highest Salary

with SalByDept as
	(select e.name as emp_name, e.salary, d.name as dept_name,
	first_value (salary) over (partition by d.name order by salary desc
							  range between unbounded preceding and unbounded following)
							  as highest_salary
	from employees e
	join department d
		on d.id = e.department_id
	order by d.name)
select dept_name, emp_name, salary
from salbydept
where salary = highest_salary

--#550. Game Play Analysis IV
with
table1 as
	(select count (distinct player_id) as total_player
	from activities),
table2 as
	(select player_id, event_date,
	lag (player_id) over (order by event_date) as next_day
	from activities),
table3 as
	(select count(*) as TotPlayerLoginNextDay
	from table2
	where player_id = next_day)
select round(TotPlayerLoginNextDay/total_player::decimal,2) as fraction
from table3, table1

--#570. Managers with at Least 5 Direct Reports

select e1.name
from employees2 e1
join employees2 e2
	on e1.id = e2.managerid
group by e1.name
having count(*) >= 5;

--#585. Investments in 2016

with tot_investment as
	(select *,
	count(tiv_2015) over (partition by tiv_2015) as tiv15_similar_value,
	count(lat) over (partition by lat) as lat_similar_value
	from insurance)
select round(sum(tiv_2016::decimal),2) as tiv_2016
from tot_investment
where tiv15_similar_value > 1
	  and lat_similar_value = 1

--#602. Friend Requests II: Who Has the Most Friends

with the_most_friends as
	(select requester_id, count(1) as cnt
	from companies
	group by requester_id
	union all
	select accepter_id, count(1) as cnt
	from companies
	group by accepter_id)
select requester_id as id, sum(cnt) as num
from the_most_friends
group by requester_id
order by num desc
limit 1;

--#608. Tree Node

select ID,
case when p_id is null then 'Root'
	 when id <> p_id and id in (select p_id from tree) then 'Inner'
	 else 'Leaf'
	 end as type
from tree

--#626. Exchange Seats

select id,
case when id = (select max(id) from seat) then student
	 when id % 2 <> 0 then lead(student) over ()
	 when id % 2 = 0 then lag(student) over ()
end as student
from seat

--#1045. Customers Who Bought All Products

with 
total_product as
	(select count(*) as tot_product
	from product2),
total_product_bought as
	(select customer_id, 
	count(distinct product_key) as tot_product_bought
	from customer
	group by customer_id)
select customer_id
from total_product_bought tpb
join total_product tp
	on tp.tot_product = tpb.tot_product_bought
