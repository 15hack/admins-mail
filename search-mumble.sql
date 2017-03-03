select USER.table_schema, mumble_user, mumble_groups, mumble_group_members, mumble_user_info from (
  select table_schema, table_name mumble_user from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('server_id', 'user_id', 'name', 'lastchannel') and table_name like '%user%' group by table_schema, table_name) T1 where T1.N=4
) USER
JOIN
(
  select table_schema, table_name mumble_groups from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('group_id', 'server_id', 'name', 'channel_id') and table_name like '%groups%' group by table_schema, table_name) T2 where T2.N=4
) GRP
JOIN
(
  select table_schema, table_name mumble_group_members from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('group_id', 'server_id', 'user_id', 'addit') and table_name like '%group_members%' group by table_schema, table_name) T3 where T3.N=4
) MBR
JOIN
(
  select table_schema, table_name mumble_user_info from (select table_schema, table_name, count(*) N from information_schema.COLUMNS where column_name in ('server_id', 'user_id', 'key', 'value') and table_name like '%user_info%' group by table_schema, table_name) T4 where T4.N=4
) INFO
ON USER.table_schema = GRP.table_schema AND GRP.table_schema = MBR.table_schema AND GRP.table_schema = INFO.table_schema;
