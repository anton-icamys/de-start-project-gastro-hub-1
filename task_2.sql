/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW task_2 AS
with cte as 
(
select restaurant_uuid
, EXTRACT(YEAR FROM report_date) as year
, round(avg(s.avg_check)::numeric, 2) as a_check  
from cafe.sales as s
WHERE EXTRACT(YEAR FROM report_date) != 2023
group by restaurant_uuid,  EXTRACT(YEAR FROM report_date)
)
select c.year as "Год"
, r.name as "Название заведения"
, r.type as "Тип заведения" 
, c.a_check as "Средний чек в текущем году" 
, LAG(c.a_check) OVER (PARTITION BY c.restaurant_uuid ORDER BY c.year) AS "Средний чек в предыдущем году"
,round((c.a_check/LAG(c.a_check) OVER (PARTITION BY c.restaurant_uuid ORDER BY c.year) * 100) - 100::numeric, 2) as "Изменение среднего чека в %"
from cte as c
join cafe.restaurants as r using (restaurant_uuid)
order by 2, 1;