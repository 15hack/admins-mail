from subprocess import Popen, PIPE
import getpass
import MySQLdb

user = raw_input("Username: ")
passwd = getpass.getpass("Password: ")


def execute(cursor,file):
	_sql=None
	with open(file, 'r') as myfile:
		_sql=myfile.read()
	cursor.execute(_sql)
	return cursor.fetchall()	


db = MySQLdb.connect("localhost", user, passwd)

cursor = db.cursor()

sql="select distinct user_email from ("

results = execute(cursor, 'search-wp.sql')

for row in results:
	sql = sql+"\n\t("
	sql = sql+"select user_email from "+row[0]+"."+row[1]+" where ID in "
	sql = sql+"(select user_id from "+row[0]+"."+row[2]+" where meta_value like '%\"administrator\"%') "
	sql = sql+") "
	sql = sql+"\n\tUNION"

results = execute(cursor, 'search-phpbb.sql')

for row in results:
        sql = sql+"\n\t("
        sql = sql+"select user_email from "+row[0]+"."+row[1]+" where user_id in "
        sql = sql+"(select user_id from "+row[0]+"."+row[2]+" where group_id=5) "
        sql = sql+") "
        sql = sql+"\n\tUNION"

results = execute(cursor, 'search-wiki.sql')

for row in results:
        sql = sql+"\n\t("
        sql = sql+"select user_email from "+row[0]+"."+row[1]+" where user_id in "
        sql = sql+"(select user_id from "+row[0]+"."+row[2]+" where ug_user='sysop') "
        sql = sql+") "
        sql = sql+"\n\tUNION"

results = execute(cursor, 'search-mumble.sql')

for row in results:
	sql = sql+"\n\t("
	sql = sql+"select value user_mail from "+row[0]+"."+row[4]+" where "+row[0]+"."+row[4]+".key=1 and user_id in "
	sql = sql+"(select user_id from "+row[0]+"."+row[3]+" where group_id in (select group_id from "+row[0]+"."+row[2]+" where name='admin')) "
        sql = sql+") "
        sql = sql+"\n\tUNION"

results = execute(cursor, 'search-ocax.sql')

for row in results:
        sql = sql+"\n\t("
        sql = sql+"select email user_mail from "+row[0]+"."+row[1]+" where is_team_member=1 or is_editor=1 or is_manager=1 or is_admin=1 "
        sql = sql+") "
        sql = sql+"\n\tUNION"

results = execute(cursor, 'search-ushahidi.sql')

for row in results:
        sql = sql+"\n\t("
        sql = sql+"select email user_mail from "+row[0]+"."+row[1]+" where id in (select user_id from "+row[0]+"."+row[3]+" where role_id in "
	sql = sql+"(select id from "+row[0]+"."+row[2]+" where (reports_view+reports_edit+reports_evaluation+reports_comments+reports_download+reports_upload)>0))"
        sql = sql+") "
        sql = sql+"\n\tUNION"

sql = sql[:-7]

sql = sql + "\n) T order by user_email"

cursor.execute(sql)

results = cursor.fetchall()
for row in results:
	print row[0]

db.close()
