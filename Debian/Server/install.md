# General server installation

## apt

	cat << EOF >/etc/apt/sources.list.d/piwik.list
	# 3rd party: piwik
	deb http://debian.piwik.org/ piwik main
	deb-src http://debian.piwik.org/ piwik main
EOF

	cat << EOF >/etc/apt/apt.conf.d/defaultrelease
	APT::Default-Release "jessie";
EOF

## Useful base software

	apt-get install \
	tripwire vim mutt screen sudo rsync \
	logwatch postfix mailutils dnsutils locales \
	lynx whois mtr apt-listchanges snort git

## ntp

	cat /sys/devices/system/clocksource/clocksource0/current_clocksource
	kvm-clock

## Fail2ban

	apt-get install fail2ban
	fail2ban-client ping
	fail2ban-client status

### config

	vi /etc/fail2ban/jail.local
	[DEFAULT]
	ignoreip = 127.0.0.1/8
	[ssh]
	bantime = 86400 ; 1 day
	[apache]
	enabled = true
	bantime = 86400 ; 1 day
	[ssh-ddos]
	enabled = true
	bantime = 86400 ; 1 day
	[postfix]
	enabled = true
	bantime = 86400 ; 1 day
	[apache-noscript]
	enabled = true
	bantime = 86400 ; 1 day
	[apache-overflows]
	enabled = true
	bantime = 86400 ; 1 day

	vi /etc/fail2ban/jail.conf
	action = %(action_mwl)s

	service fail2ban restart

## ipv6

	apt-get install aiccu
	dpkg-reconfigure aiccu

## Backup

Import your backup gpg key into root's gnupg keystore.


	cat << EOF >/etc/cron.daily/backup
	#!/bin/bash

	#set -x
	umask 077

	GPG_KEY=<your key>
	TMPDIR=/tmp
	USER=user
	DSTDIR=/home/${USER}/backup/$HOSTNAME
	DBFILE=`hostname`.sql

	# backup piwik mysql database
	mysqldump --all-databases --events >${TMPDIR}/${DBFILE} && \
	  chown ${USER}:${USER} ${TMPDIR}/${DBFILE} && \
	  su -c "cat ${TMPDIR}/${DBFILE} | gpg --encrypt \
	    -r ${GPG_KEY} - >${DSTDIR}/${DBFILE}.gpg" - ${USER} && \
	  rm ${TMPDIR}/$DBFILE || exit 3

	tar cfz ${TMPDIR}/${HOSTNAME}.tgz /etc /var/spool/cron &>/dev/null && \
	  chown ${USER}:${USER} ${TMPDIR}/${HOSTNAME}.tgz && \
	  su -c "cat ${TMPDIR}/${HOSTNAME}.tgz | gpg --encrypt \
	    -r ${GPG_KEY} - >${DSTDIR}/${HOSTNAME}.tgz.gpg" - ${USER} && \
	    rm ${TMPDIR}/${HOSTNAME}.tgz || exit 3

	exit 0
EOF

	chmod +x /etc/cron.daily/backup

Synchronize /home/user/backup with unison or rsync.

### offlineimap

apt-get install [offlineimap](http://offlineimap.org)

	vi ~/.offlineimaprc
	[general]
	accounts = user
	ui = Basic

	[My Account]
	localrepository = Local
	remoterepository = Remote

	[Repository Local]
	type = Maildir
	localfolders = ~/offlineIMAP

	[Repository Remote]
	type = IMAP
	remotehost = imap.domain.tld
	remoteuser = user@domain.tld
	remotepass = secret
	ssl=yes
	readonly=yes
	folderfilter = lambda foldername: foldername not in ['INBOX.Spam', 'INBOX.Trash']

	offlineimap

	crontab -e
	58 * * * * offlineimap -o 1>/dev/null

## Apache Webserver

	install -g root -m 600 domain.conf /etc/apache2/sites-available/
	cd /etc/apache2/sites-enabled
	ln -s /etc/apache2/sites-available/domain.conf
	a2enmod php5 headers ssl access_compat wsgi socache_shmcb rewrite expires proxy proxy_http deflate userdir

	service apache2 start

	update-rc.d apache2 defaults

### tls/ssl zertifikate mit openssl bei startssl.com

Neues Zertifikat erstellen:

	openssl genrsa -out domain.ch.key 2048
	openssl req -new -key domain.ch.key -out domain.ch.csr

Das Passwort aus dem Privat key entfernen, damit es der Apache Webserver lesen kann:

	openssl rsa -in domain.ch.key -out domain.ch.key

Das Zertifikat auf der Website von [StartSSL](https://www.startssl.com) signieren lassen und auf dem Server als **domain.ch.crt** speichern.

Die Dateien \*.key und \*.crt ersetzen und

	service apache2 reload

## Using Git to manage my website

Genereller [Aufbau](http://toroid.org/ams/git-website-howto).

	mkdir ~/www
	mkdir ~/tww
	cd ~/www
	git --bare init
	git clone ~/www tww
	cat << EOF > ~/www/hooks/post-receive
	. /usr/share/doc/git/contrib/hooks/post-receive-email
	GIT_WORK_TREE=/home/user1/www git checkout -f
	GIT_WORK_TREE=/home/user1/www
	/usr/local/jmeter/jmeter.pl -p domain.jmx
	sudo chgrp www-data $GIT_WORK_TREE/key/www.domain.key
	sudo chgrp www-data $GIT_WORK_TREE/key/www.domain.crt
	chmod 440 $GIT_WORK_TREE/key/www.domain.key
	chmod 440 $GIT_WORK_TREE/key/www.domain.crt
EOF

	vi ~/www/config
	[hooks]
	mailinglist = user1@domain.tld,user2@domain.tld

## Nagios JMeter plugin

	apt-get install default-jre
	cd /tmp
	wget http://mirror.switch.ch/mirror/apache/dist/jmeter/binaries/apache-jmeter-2.11.tgz
	cd /usr/local
	tar xfz /tmp/apache-jmeter-2.11.tgz
	ln -s /usr/local/apache-jmeter-2.11 jmeter

Download mit lynx
<http://exchange.nagios.org/directory/Plugins/Java-Applications-and-Servers/jmeter-invocation-plugin/details>

	vi jmeter.pl
	#Paths to java and jmeter environment variables.
	$ENV{JAVA_HOME} = "/usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java";
	$ENV{JMETER_HOME} = "/usr/local/jmeter";

### Cron

	cat << EOF > /etc/cron.d/jmeter
	4 6 * * * user /usr/local/jmeter/jmeter.pl -p domain.jmx
EOF

## Mail: Postfix

	dpkg-reconfigure postfix

	vi /etc/aliases
	postmaster: root
	debarchiver: root
	user1: root
	root: myname@domain.tld

	newaliases

	vi /etc/postfix/main.cf
	mynetworks = my.ip.x.z 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
	inet_interfaces = 127.0.0.1, [::1]

	service postfix reload

## Tripwire

	tripwire init
	tripwire --check
	tripwire --update -r /var/lib/reports/xyz

## sms.php

<https://github.com/nadar/aspsms-php-class>

	apt-get install php5-curl

## Website: Bild optimierung

	apt-get install jpegoptim optipng

## Piwik

Activate Piwik repo according to debian.piwik.org

	apt-get install mysql-server libapache2-mod-geoip piwik

### Generate mysql users

Piwik: Recommended configuration

## PHP

	install -d -g www-data -o www-data -m 700 /var/lib/php5/uploads/
	chmod 700 /var/lib/php5/sessions

	vi /etc/php5/apache/php.ini
	always_populate_raw_post_data=-1
	file_uploads = Off
	upload_tmp_dir = /var/lib/php5/uploads

### Apache VirtualHost

	Alias /piwik /usr/share/piwik

Then run the installer.

### Piwik archive cron

Activate piwik archive cron at

	vi /etc/cron.d/piwik-archive

	vi /etc/piwik/config.ini.php
	[log]
	log_writers[] = file
	; Possible values are ERROR, WARN, INFO, DEBUG
	log_level = INFO
	logger_file_path = /var/log/piwik/piwik.log


## Asterisk

Configure doc is [here](https://github.com/micressor/howtos-linux/blob/master/asterisk-configure-to-receive-incoming-sip-calls.md).
