--поиск
select * from table_name where UPPER(column_name) LIKE UPPER('%Поисковая строка%');

--поиск между дат
select * from table_name
where date_column between TO_TIMESTAMP('01-03-2022', 'dd-MM-yyyy') and TO_TIMESTAMP('01-03-2022', 'dd-MM-yyyy');


--Обновление sequence
SELECT setval('abc_account_id_seq', (SELECT max(id) FROM abc_account));


--Размер БД в postreql
SELECT pg_size_pretty(pg_total_relation_size('user_signature'));

--Размер всех таблиц в postreql
SELECT nspname || '.' || relname AS "relation",
       pg_size_pretty(pg_total_relation_size(C.oid)) AS "total_size"
FROM pg_class C
         LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  AND C.relkind <> 'i'
  AND nspname !~ '^pg_toast'
ORDER BY pg_total_relation_size(C.oid) DESC;


-- Все партиции определённой таблицы
SELECT relname,
       inhparent                      as main_table_id,
       inhparent::pg_catalog.regclass as main_table_name,
        pg_catalog.pg_get_expr(c.relpartbound, c.oid),
       inhdetachpending
FROM pg_catalog.pg_class c
         JOIN pg_catalog.pg_inherits i ON c.oid = inhrelid
--where inhparent = 217173;


-- Посмотреть все UNIQUE или PRIMARY KEY postgresql
select kcu.table_schema,
       kcu.table_name,
       tco.constraint_name,
       kcu.ordinal_position as position,
       kcu.column_name as key_column
from information_schema.table_constraints tco
         join information_schema.key_column_usage kcu
              on kcu.constraint_name = tco.constraint_name
                  and kcu.constraint_schema = tco.constraint_schema
                  and kcu.constraint_name = tco.constraint_name
where tco.constraint_type = 'PRIMARY KEY'
order by kcu.table_schema,
         kcu.table_name,
         position;


-- Сессии oracle
SELECT t.SID, t.SERIAL#, t.osuser as "User", t.MACHINE as "PC", t.PROGRAM as "Program"
FROM v$session t
--WHERE (NLS_LOWER(t.PROGRAM) = 'cash.exe') -- посмотреть сессии от программы cash.exe
--WHERE status='ACTIVE' and osuser!='SYSTEM' -- посмотреть пользовательские сессии
--WHERE username = 'схема' -- посмотреть сессии к схеме (пользователь)
ORDER BY 4 ASC;

--сброс sequence oracle;
drop sequence USER_SUBUNIT_ID_SEQ;
CREATE SEQUENCE USER_SUBUNIT_ID_SEQ START WITH 503254 increment by 1;
alter table USER_SUBUNIT
    modify id default USER_SUBUNIT_ID_SEQ.nextval
