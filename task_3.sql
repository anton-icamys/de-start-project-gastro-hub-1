/*добавьте сюда запрос для решения задания 3*/

SELECT 
    r.name as "Название заведения",
    COUNT(rmwd.manager_uuid) AS "Сколько раз менялся менеджер"
FROM 
    cafe.restaurant_manager_work_dates rmwd
JOIN 
    cafe.restaurants r ON rmwd.restaurant_uuid = r.restaurant_uuid
GROUP BY 
    r.restaurant_uuid, r.name
ORDER BY 
    2 DESC
LIMIT 3;