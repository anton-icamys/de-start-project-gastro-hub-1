/*добавьте сюда запрос для решения задания 1*/

create view cafe.task_1
as
select
	name as "Название заведения"
 , type as "Тип заведения"
 , a_check as "Средний чек"
from
(
	select
		r.name
	 , r.type
	 , a.a_check
	 , row_number() over(partition by r.type
		order by
		a_check desc) as rn
	from
	(
		select
			restaurant_uuid
		 , round(avg(s.avg_check) ::numeric, 2) as a_check
		from
			cafe.sales as s
		group by
			restaurant_uuid
	) as a
	join cafe.restaurants as r
		on a.restaurant_uuid = r.restaurant_uuid
) as b
where b.rn < 4
order by
	3 desc;
