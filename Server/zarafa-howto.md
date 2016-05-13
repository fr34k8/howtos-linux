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

## Base tools

	apt-get install ca-certificates git uptimed telnet unison ssmtp logwatch mailutils

## Zarafa

According to [zcp_administrator_manual](https://documentation.zarafa.com/zcp_administrator_manual/installing.html).

	mkdir src
	wget https://download.zarafa.com/community/final/7.2/7.2.3.657/zcp-7.2.3.657-debian-8.0-x86_64-opensource.tar.gz
	tar xfz zcp-7.2.3.657-debian-8.0-x86_64-opensource.tar.gz
	cd cp-7.2.3.657-debian-8.0-x86_64-opensource
	dpkg -i *.deb
	apt-get install -f
	apt-get install apache2-mpm-prefork libapache2-mod-php5
	apt-get install mysql-server

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

Download WebApp from [here](https://download.zarafa.com/community/final/WebApp/2.2.0/) and scp it to apu.

	tar xf debian-8.0.tar
	cd debian-8.0
	dpkg -i *.deb
	apt-get -f install -f
	service apache2 reload

# Configure

## Zarafa

Configuring a zarafa mysql user according to [Configuring the Zarafa Server](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#configure-the-zarafa-server).

	dpkg-reconfigure locales
	[*] de_CH.UTF-8 UTF-8

	vi /etc/default/zarafa
	ZARAFA_USERSCRIPT_LOCALE="de_CH.UTF-8 UTF-8"

### Config

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

	vi /etc/zarafa/server.cfg
	server_bind = 127.0.0.1
	attachment_storage = database
	# Size in bytes of the 'cell' cache (should be set as high as you can
	# afford to set it)
	cache_cell_size = 1024M

	vi /etc/zarafa/gateway.cfg
	pop3_enable = no
	imap_enable = no

	vi /etc/zarafa/ical.cfg
	server_bind = 127.0.0.1

	vi /etc/zarafa/dagent.cfg
	server_bind = 127.0.0.1

	vi /etc/zarafa/presence.cfg
	server_bind = 127.0.0.1

Restart all /etc/init-d/zarafa-\* services.

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

# Testing

## Performance tuning

[The performance of Z-push, WebAccess and WebApp is dependent on the tuning of MySQL, ZCP caching and Apache.](http://wiki.zarafa.com/index.php?title=Apache_tuning)


# Usage

## Create user

	zarafa-admin -c user@domain.tld -p xyz1234 -e user@domain.tld -f "first last"
	zarafa-admin --create-store xyz

# Appendix

## Links

* [Importing ICAL ics files into Zarafa](https://wiki.zarafa.com/index.php/Importing_ICAL_ics_files_into_Zarafa)

## Z-Push tricks

To get a folderid according to [this instructions](https://wiki.zarafa.com/index.php/Z-Push_shared_and_public_folder_sync) works only, if the user is an
administrator. So we have to enable `user1` as an admin first. 

	zarafa-admin -u user1 -a y
	cd /usr/share/z-push/backend/zarafa
	./listfolders.php -l user1 -u user1 -p password1  -h http://127.0.0.1:236/zarafa

* More infos in german are here: [Z-Push Public Folders](https://www.mars-solutions.de/knowledgebase/z-Push)