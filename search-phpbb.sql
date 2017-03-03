select USER.table_schema, phpbb_user, phpbb_user_group from (
  select table_schema, table_name phpbb_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('user_type', 'group_id', 'username', 'username_clean') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=4
) USER
JOIN
(
  select table_schema, table_name phpbb_user_group from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('group_id', 'user_id', 'group_leader', 'user_pending') and table_name like '%user_group%' group by table_schema, table_name) T2 where T2.N=4
) META
ON USER.table_schema = META.table_schema;

