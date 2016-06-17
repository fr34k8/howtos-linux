# How to setup Zarafa-Server on Debian?

## Goal

This howto provide an easy step by step way to setup zarafa-server running
on debian with a pcengines apu board.

Inspired by [bootly](https://github.com/nikslor/bootly).

# Install

## Install debian on pcengines apu board

Follow this [instructions](https://github.com/ssinyagin/pcengines-apu-debian-cd)
to install debian on your apu. Recommended by pcengines list of
[disk images](http://pcengines.ch/howto.htm#images).

	cd /tmp
	wget https://github.com/ssinyagin/pcengines-apu-debian-cd/releases/download/8.3-20160401/debian-8.3-amd64-CD-1.iso
	dd if=images/debian-8.3-amd64-CD-1.iso of=/dev/sdX bs=16M


**WARNING:** this is a fully automated installation. Once you boot from the
USB stick, it will only give you 5 seconds in the initial menu, then in
a couple of minutes it will ask for the hostname, and the rest will be
done automatically, and a new Debian system will be installed on mSATA
SSD drive.

**!!! ALL EXISTING DATA ON THE DRIVE WILL BE LOST !!!**

## Base tools

	apt-get install ca-certificates git uptimed telnet unison postfix logwatch mailutils

## Zarafa

Install instructions (according to [zcp_administrator_manual](https://documentation.zarafa.com/zcp_administrator_manual/installing.html)) to install zarafa on
your apu:

	mkdir src
	wget https://download.zarafa.com/community/final/7.2/7.2.3.657/zcp-7.2.3.657-debian-8.0-x86_64-opensource.tar.gz
	tar xfz zcp-7.2.3.657-debian-8.0-x86_64-opensource.tar.gz
	cd cp-7.2.3.657-debian-8.0-x86_64-opensource
	dpkg -i *.deb
	apt-get install -f
	apt-get install apache2-mpm-prefork libapache2-mod-php5
	apt-get install mysql-server

### Plugins

### Password

Installation with **git clone** method did not work. I used instead this way
and opened a [bug #15](https://github.com/silentsakky/zarafa-webapp-passwd/issues/15) report:

	cd /tmp
	wget [passwd-1.2.zip](https://github.com/silentsakky/zarafa-webapp-passwd/raw/master/builds/passwd-1.2.zip)
	cd /usr/share/zarafa-webapp/plugins
	unzip /tmp/passwd-1.2.zip
	mv config.php /etc/zarafa/webapp/config-passwd.php
	rm config.php
	ln -s /etc/zarafa/webapp/config-passwd.php config.php

	vi /etc/zarafa/webapp/config-passwd.php
	define('PLUGIN_PASSWD_USER_DEFAULT_ENABLE', true);

## Z-Push

Download z-push from [here](http://download.z-push.org/final/) and install it according to [zarafa doc](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#configure-z-push-activesync-for-mobile-devices)

	apt-get install php5-cli php-soap

	wget http://download.z-push.org/final/z-push-x.y.z.tgz
	mkdir -p /usr/share/z-push
	tar zxvf z-push-*.tar.gz -C /usr/share/z-push/ --strip-components=1
	mkdir /var/lib/z-push /var/log/z-push
	chown www-data:www-data /var/lib/z-push /var/log/z-push
	cat /etc/apache2/sites-available/z-push.conf
	Alias /Microsoft-Server-ActiveSync /usr/share/z-push/index.php
	a2ensite z-push
	service apache2 reload

## WebApp

	cd /tmp

Download WebApp (whole directory with a lot of \*.deb files) from
[here](https://download.zarafa.com/community/final/WebApp/2.2.0/) and scp it to
apu.

	tar xf debian-8.0.tar
	cd debian-8.0
	dpkg -i *.deb
	apt-get -f install -f
	service apache2 reload

# Configure

## Postfix

Configure Postfix as a **Satellite System** according to
[this steps](https://github.com/micressor/howtos-linux/blob/master/Server/postfix.md).

## Zarafa

Configuring a zarafa mysql user according to [Configuring the Zarafa Server](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#configure-the-zarafa-server).

	dpkg-reconfigure locales
	[*] de_CH.UTF-8 UTF-8

	vi /etc/default/zarafa
	ZARAFA_USERSCRIPT_LOCALE="de_CH.UTF-8 UTF-8"

**Important [note](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#storing-attachments-outside-the-database)**: For first time installations, the attachment storage method should be selected before starting the server for the first time as it is not easy to switch the attachment storage method later on.

	vi /etc/zarafa/server.cfg
	server_bind = 127.0.0.1
	attachment_storage = database
	# Size in bytes of the 'cell' cache (should be set as high as you can
	# afford to set it)
	cache_cell_size = 1024M

	vi /etc/zarafa/gateway.cfg
	pop3_enable = no
	imap_enable = no

	vi /etc/zarafa/dagent.cfg
	server_bind = 127.0.0.1

	vi /etc/zarafa/presence.cfg
	server_bind = 127.0.0.1

Restart all /etc/init-d/zarafa-\* services.

### zarafa-ical

	vi /etc/zarafa/ical.cfg
	server_bind =
	# wether normal connections can be made to the ical server
	ical_enable = no
	# wether ssl connections can be made to the ical server
	icals_enable = yes
	ssl_private_key_file = /etc/letsencrypt/live/doamin.tld/privkey.pem
	ssl_certificate_file = /etc/letsencrypt/live/doamin.tld/fullchain.pem

### MySQL

	mysql
	mysql> GRANT ALL PRIVILEGES ON zarafa.* TO 'zarafa'@'localhost' IDENTIFIED BY 'password';
	mysql> GRANT ALTER, CREATE, CREATE ROUTINE, DELETE, DROP, INDEX, INSERT, LOCK TABLES, \
      SELECT, UPDATE ON zarafa.* TO 'zarafa'@'localhost' IDENTIFIED BY 'password';

	vi /etc/mysql/my.cnf
	; around 50% of total RAM size
	innodb_buffer_pool_size = 2048M
	; 25% of the innodb_buffer_pool_size
	innodb_log_file_size = 512M
	innodb_log_buffer_size = 32M
	innodb_file_per_table
	max_allowed_packet = 16M
	table_cache = 1000

## Apache TLS/SSL

According to [this instructions](https://github.com/micressor/howtos-linux/blob/master/Apache/sslengine.md).

## Enable services at boot time

	systemctl enable zarafa-server
	systemctl enable zarafa-dagent
	systemctl enable zarafa-gateway
	systemctl enable zarafa-ical
	systemctl enable zarafa-monitor
	systemctl enable zarafa-presence
	systemctl enable zarafa-search
	systemctl enable zarafa-spooler

## Z-Push

### Synchronize additional folders to all mobiles

With this feature, special folders can be synchronized to all mobiles (german
explanation [Z-Push Public Folders](https://www.mars-solutions.de/knowledgebase/z-Push)).

* This is useful for e.g. global company contacts.

* all Z-Push users must have full writing permissions (secretary rights) so the
  configured folders can be synchronized to the mobile.

On Zarafa systems use `backend/zarafa/listfolders.php` script to get a list
of available folder (and folderid) for user1:

	cd /usr/share/z-push/backend/zarafa
	zarafa-admin -u admin -a y
	./listfolders.php -l user1 -u admin -p secret -h http://127.0.0.1:236/zarafa

	Available folders in store 'user1':
	--------------------------------------------------
	Folder name:	Shared Appointments
	Folder ID:	a0000000000000000000000000000000000000000000
	Type:		SYNC_FOLDER_TYPE_USER_APPOINTMENT

Edit `/usr/share/z-push/config.php` and follow [this instructions](https://wiki.zarafa.com/index.php/Z-Push_shared_and_public_folder_sync):

	vi /usr/share/z-push/config.php
	array(
	'store'     => "Shared Appointments",
	'folderid'  => "a0000000000000000000000000000000000000000000",
	'name'      => "Marys Kalendar",
	'type'      => SYNC_FOLDER_TYPE_USER_APPOINTMENT,
	),


# Testing

## Performance tuning

[The performance of Z-push, WebAccess and WebApp is dependent on the tuning of MySQL, ZCP caching and Apache.](http://wiki.zarafa.com/index.php?title=Apache_tuning)


# Usage

## Create user

	zarafa-admin -c user@domain.tld -p xyz1234 -e user@domain.tld -f "first last"
	zarafa-admin --create-store xyz

# Backup / Restore

* [Encrypted gpg backup of /etc and mysql database](https://github.com/micressor/howtos-linux/blob/master/Server/backup.md)

## Iporting ICAL ics files into Zarafa

	curl -u 'user:pass' -T calendar.ics https://localhost:8443/ical/user



# Appendix

## Reinstall, backup and restore mysql

To restore a full database dump including mysql grant tables, use the following
steps:

	systemctl stop zarafa-server
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

Check [this](https://github.com/micressor/howtos-linux/blob/master/Server/mysql.md).

## Links

* [Importing ICAL ics files into Zarafa](https://wiki.zarafa.com/index.php/Importing_ICAL_ics_files_into_Zarafa)


