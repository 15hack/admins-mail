from subprocess import Popen, PIPE
import getpass
import MySQLdb

user = raw_input("Username: ")
passwd = getpass.getpass("Password: ")


def sqlF(s):
	process = Popen(['mysql', db, '-u', user, '-p', passwd], stdout=PIPE, stdin=PIPE)
	output = process.communicate('source ' + filename)[0]

db = MySQLdb.connect("localhost", user, passwd)

cursor = db.cursor()

sql=None
with open('search-wp.sql', 'r') as myfile:
    sql=myfile.read()

cursor.execute(sql)

results = cursor.fetchall()

sql="select distinct user_email from ("

ln=len(results)

for row in results:
	sql = sql+"\n\t("
	sql = sql+"select user_email from "+row[0]+"."+row[1]+" where ID in "
	sql = sql+"(select user_id from "+row[0]+"."+row[2]+" where meta_value like '%\"administrator\"%') "
	sql = sql+") "
	if ln>1:
		sql = sql+"\n\tUNION"
	ln = ln -1

sql = sql + "\n) T order by user_email"

cursor.execute(sql)

results = cursor.fetchall()
for row in results:
	print row[0]

db.close()
