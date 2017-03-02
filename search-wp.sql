select USER.table_schema, wp_user, wp_usermeta from (
  select table_schema, table_name wp_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('ID', 'user_email', 'user_pass', 'user_nicename') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=4
) USER
JOIN
(
  select table_schema, table_name wp_usermeta from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('umeta_id', 'user_id', 'meta_key', 'meta_value') and table_name like '%usermeta%' group by table_schema, table_name) T2 where T2.N=4
) META
ON USER.table_schema = META.table_schema;
