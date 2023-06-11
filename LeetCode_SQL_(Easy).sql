--#197. Rising Temperature (LeetCode)

with cte_temp as
	(select *,
	lag(temperature) over (order by recored_date) as next_temp
	from weather)
select id
from cte_temp
where temperature > next_temp
and next_temp is not null;

--#196. Delete Duplicate Email (LeetCode)

delete
from person where id in
(select id
from
	(select email,count(*), max(id) as id
	from Person
	group by email
	having count(*) > 1) x);

--#175 Combine Two Tables (LeetCode)

select p.first_name, p.last_name, a.city, a.state
from persons p
left join address a
	on a.person_id = p.person_id;
	
--#181  Employees Earning More Than Their Managers (LeetCode)

select em2.name
from employee_manager em1
join employee_manager em2
	on em2.manager_id = em1.id
where em2.salary > em1.salary;

--#183 Customers Who Never Order (LeetCode)

select c.name as customers
from customers c
left join orders o
	on o.customer_id = c.id
where o.customer_id is null;

--#511 Game Play Analysis I (LeetCode)

select player_id, min(event_date) as first_login
from activity
group by player_id
order by player_id;

--#577 Employee Bonus (LeetCode)

select e.name, b.bonus
from Employee2 e
left join bonus b
	on b.emp_id = e.emp_id
where coalesce(b.bonus,0) < 1000
order by bonus desc;

--# 584. Find Customer Referee (LeetCode)

select name
from customers2
where coalesce(referee_id, 0) <> 2;

--#586 Customer Placing the Largest Number of Orders (LeetCode)

select customer_number
from
	(select customer_number, count(*) as total_order
	from orders2
	group by 1
	order by total_order desc
	limit 1) tot_order;

--#595 Big Countries (LeetCode)

select name, population, area
from world
where area >= 3000000
	or population >= 25000000;

--#596 Classes More Than 5 Students LeetCode)

select class
from courses
group by 1
having count(1) >= 5;

--#607 Sales Person (LeetCode)

with cte as
	(select s.name as salesperson, o.sales_id as sales_id, 
	coalesce(min(c.com_id),0) as com_id
		from salesperson s
		left join orders3 o
			on o.sales_id = s.sales_id
		left join company c
			on c.com_id = o.com_id
	group by 1,2)
select salesperson
from cte
where com_id <> 1

--#610 Triangle Judgement (LeetCode)

select *,
case when x + y > z and x + z > y and y + z > x then 'Yes'
	 else 'No'
end as triangle
from triangle

--#619 Biggest Single Number (LeetCode)

select num
from mynumbers
group by num
having count(*) < 2
order by num desc
limit 1;

--#620 Not Boring Movies (LeetCode)

Select id, movie, description, rating
from cinema
where description <> 'boring'
and case when id % 2 <> 0 then id
	 end is not null

--# 627. Swap Salary (LeetCode)

update salary
set sex =
case when sex = 'm' then 'f'
	 else 'm' end

--#1050 Actors and Directors Who Cooperated At Least Three Times (LeetCode)

select actor_id, director_id
from actordirector
group by 1,2
having count(*) >= 3;

--#1068 Product Sales Analysis I (LeetCode)

select p.product_name, s.year, s.price
from sales s
join products p
	on p.product_id = s.product_id







