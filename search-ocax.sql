select table_schema, table_name ocax_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('username', 'email', 'is_team_member', 'is_editor', 'is_manager', 'is_admin') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=6

