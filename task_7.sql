/*добавьте сюда запросы для решения задания 6*/

BEGIN;

LOCK TABLE cafe.managers IN SHARE UPDATE EXCLUSIVE MODE;

ALTER TABLE cafe.managers
ADD COLUMN new_phone_array TEXT[];

WITH ManagerCalculations AS (
    SELECT
        m.manager_uuid,
        m.phone AS old_phone_string,
        concat('8-800-2500-', (row_number() OVER (ORDER BY m.name) + 99)::text) AS new_phone_calculated
    FROM
        cafe.managers m
)
UPDATE cafe.managers cm
SET
    new_phone_array = ARRAY[mc.new_phone_calculated, mc.old_phone_string]
FROM
    ManagerCalculations mc
WHERE
    cm.manager_uuid = mc.manager_uuid;

ALTER TABLE cafe.managers
DROP COLUMN phone;

ALTER TABLE cafe.managers
RENAME COLUMN new_phone_array TO phone;

COMMIT;

--LOCK TABLE IN SHARE UPDATE EXCLUSIVE MODE обеспечивает чтение, но запрещает все операции DML.
--а дальше вариация на тему, добавлене нового столбца и удаление текущего после обновления.