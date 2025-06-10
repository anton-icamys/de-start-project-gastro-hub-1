/*добавьте сюда запросы для решения задания 6*/

BEGIN;

WITH UpdatedPrices AS (
    SELECT
        r.id,
        r.menu,
        jsonb_set(
            r.menu,
            '{Кофе, Капучино}',
            ((r.menu->'Кофе'->>'Капучино')::numeric * 1.20)::text::jsonb,
            TRUE
        ) AS new_menu_value
    FROM
        cafe.restaurants r
    WHERE
        r.menu ? 'Кофе' AND (r.menu->'Кофе') ? 'Капучино'
    FOR UPDATE 
)

UPDATE cafe.restaurants cr
SET
    menu = up.new_menu_value
FROM
    UpdatedPrices up
WHERE
    cr.id = up.id;

COMMIT;

--будет обычный рид комитет с запретом на грязное чтение.
--FOR UPDATE блокирует строки, которые будут обновлены, чтобы другие транзакции не могли их изменить до завершения текущей транзакции.