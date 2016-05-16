# MySQL full restore including mysql grant tables

To restore a full database dump including mysql grant tables, use the following
steps:

	systemctl stop mysql
	rm -rf /var/lib/mysql/*
	mysql_install_db
	mysqld_safe --skip-grant-tables &
	tail /var/log/mysql/*.log

	cd /var/backup/mysql
	cat mysql-all-databases.sql | mysql ; echo $?
	killall mysqld
	tail /var/log/mysql/*.log

	service mysql start

* [MySQL: Reloading SQL-Format Backups](http://dev.mysql.com/doc/refman/5.7/en/reloading-sql-format-dumps.html)

* [mysqld_safe — MySQL Server Startup Script](https://dev.mysql.com/doc/refman/5.5/en/mysqld-safe.html)
