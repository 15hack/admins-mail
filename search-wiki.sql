select USER.table_schema, wiki_user, wiki_user_group from (
  select table_schema, table_name wiki_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('user_id', 'user_name', 'user_real_name', 'user_email') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=4
) USER
JOIN
(
  select table_schema, table_name wiki_user_group from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('ug_user', 'ug_group') and table_name like '%user_group%' group by table_schema, table_name) T2 where T2.N=2
) META
ON USER.table_schema = META.table_schema;
