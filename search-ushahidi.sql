select USER.table_schema, ushahidi_user , ushahidi_roles, ushahidi_roles_users from (
  select table_schema, table_name ushahidi_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('id', 'name', 'email', 'username', 'logins') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=5
) USER
JOIN
(
  select table_schema, table_name ushahidi_roles from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('name', 'reports_edit', 'reports_view', 'reports_evaluation') and table_name like '%roles%' group by table_schema, table_name) T2 where T2.N=4
) ROL
JOIN
(
  select table_schema, table_name ushahidi_roles_users from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('user_id', 'role_id') and table_name like '%roles%' group by table_schema, table_name) T2 where T2.N=2
) ROLUSER
ON USER.table_schema = ROL.table_schema AND ROLUSER.table_schema = ROL.table_schema;
