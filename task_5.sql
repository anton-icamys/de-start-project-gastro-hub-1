/*добавьте сюда запрос для решения задания 5*/

select 
  name as "Название заведения"
, 'Пицца' as "Тип блюда"
, p_name as "Название пиццы"
, p_price as "Цена"
from (
SELECT
    r.name,
    pizza_items.key as p_name,
    pizza_items.value_from_second_key p_price,
    row_number() over (partition by r.name order by pizza_items.value_from_second_key desc) as rn
FROM
    cafe.restaurants r,
    jsonb_each(r.menu::jsonb -> 'Пицца') AS pizza_items(key, value_from_second_key)
) as a
where rn = 1;