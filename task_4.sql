/*добавьте сюда запрос для решения задания 4*/


with cte
	  as (select
				name
			 , jsonb_object_keys(menu::jsonb -> 'Пицца') as qnt
			from
				cafe.restaurants),
	  cte2
	  as (select
				name
			 , count(qnt) as qnt
			from
				cte
			group by
				name
			order by
				2 desc),
	  cte3
	  as (select
				*
			 , rank() over(
				order by
				qnt desc) as rn
			from
				cte2)
	  select
		  name as "Название заведения"
		, qnt as "Количество пицц в меню"
	  from
		  cte3
	  where rn = 1;