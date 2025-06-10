/*Добавьте в этот файл запросы, которые наполняют данными таблицы в схеме cafe данными*/


insert into cafe.restaurants
(
	restaurant_uuid
 , name
 , type
 , menu
)
select
	gen_random_uuid() as id
 , a.cafe_name
 , case
		when a.type = 'Салат'
			then 'restaurant'
		when a.type = 'Кофе'
			then 'coffee_shop'
		when a.type = 'Пицца'
			then 'pizzeria'
		else 'bar'
	end ::cafe.restaurant_type
 , a.menu
from
(
	select
		jsonb_object_keys(menu) as type
	 , row_number() over(partition by cafe_name
	order by
		jsonb_object_keys(menu) desc) as rn
	 , *
	from
		raw_data.menu
) as a
where a.rn = 1;

insert into cafe.managers
(
	manager_uuid
 , name
 , phone
)
select
	gen_random_uuid()
 , a.manager
 , a.manager_phone
from
(
	select distinct
		manager
	 , manager_phone
	from
		raw_data.sales
) as a;

insert into cafe.sales
(
	report_date
 , restaurant_uuid
 , avg_check
)
select
	s.report_date
 , r.restaurant_uuid
 , avg(avg_check)
from
	raw_data.sales as s
	join cafe.restaurants as r
		on s.cafe_name = r.name
group by
	s.report_date
 , r.restaurant_uuid;

insert into cafe.restaurant_manager_work_dates
(
	restaurant_uuid
 , manager_uuid
 , work_start_date
 , work_end_date
)
select
	restaurant_uuid
 , manager_uuid
 , min(report_date)
 , max(report_date)
from
	raw_data.sales as s
	join cafe.restaurants as r
		on s.cafe_name = r.name
	join cafe.managers as m
		on s.manager = m.name
group by
	restaurant_uuid
 , manager_uuid;