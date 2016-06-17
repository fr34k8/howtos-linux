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

### mixed mode with testing (optional)

[Priority](https://wiki.debian.org/AptPreferences) for testing [anpassen](http://www.argon.org/~roderick/apt-pinning.html) (order is important).

	vi /etc/apt/preferences.d/pinning
	Package: *
	Pin: release o=Debian,a=testing
	Pin-Priority: -500

	vi /etc/apt/sources.list
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free

	apt-cache policy| grep testing
	500 http://ftp.ch.debian.org/debian/ testing/main Translation-en
	-500 http://ftp.ch.debian.org/debian/ testing/main amd64 Packages

## Useful base software

	apt-get install \
	tripwire vim mutt screen sudo rsync \
	logwatch postfix mailutils dnsutils locales \
	lynx whois mtr apt-listchanges snort git apt-file

## ntp

	cat /sys/devices/system/clocksource/clocksource0/current_clocksource
	kvm-clock

## Fail2ban

[Moved here!](https://github.com/micressor/howtos-linux/tree/master/Server/fail2ban.md).

## ipv6

	apt-get install aiccu
	dpkg-reconfigure aiccu

## Backup

Moved to [backup.md](https://github.com/micressor/howtos-linux/blob/master/Server/backup.md).
Synchronize /home/user/backup [with unison](https://github.com/micressor/howtos-linux/blob/master/Debian/backup-mit-unison-und-btrfs-snapshots.md) or
rsync.

## Clamav

Official [ClamAV FAQ](https://github.com/vrtadmin/clamav-faq).

	apt-get install clamav-daemon clamav-freshclam

	cat << EOF >/etc/cron.weekly/clamscan
	#!/bin/bash
	nice -n 20 clamscan -o --stdout --quiet \
	--follow-file-symlinks=2 \
	--follow-dir-symlinks=0 \
	--exclude=.gpg \
	--exclude-dir=/home \
	--exclude-dir=cache \
	--exclude-dir=/sys \
	--exclude-dir=/run \
	--exclude-dir=/dev \
	--exclude-dir=/proc -r /
	EOF

	chmod +x /etc/cron.weekly/clamscan
	wget http://www.eicar.org/download/eicar.com.txt

Viren werden mit dieser Konfiguration nur aufgezeigt! Um zu löschen ist
zusätzlich die Option.

      --remove=yes

notwendig. **Vorsicht!**

### On-access Scan Settings

0.99 has a revamped on-access scanning engine.

	apt-get install clamav-daemon
	dpkg-reconfigure clamav-daemon

	cat << EOF >/usr/local/bin/clamav_alert.sh
	#!/bin/bash
	Subject="ClamAV VIRUS ALERT ${HOSTNAME}: $1"
	Msg=`mktemp`
	tail -n80 /var/log/clamav/clamav.log >$Msg
	cat $Msg | mail root -s "$Subject"
	rm $Msg
	EOF
	chmod +x /usr/local/bin/clamav_alert.sh

	vi /etc/clamav/clamd.conf
	User root
	ScanOnAccess yes
	OnAccessMountPath /home
	OnAccessIncludePath /home
	OnAccessExcludePath /home/*/_SNAPSHOTS
	VirusEvent /usr/local/bin/clamav_alert.sh "%v"

	service clamav-daemon restart

	tail -f /var/log/clamav/clamav.log

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

### Letsencrypt: generate TLS/SSL certificates

According to [this instructions](https://github.com/micressor/howtos-linux/blob/master/Server/letsencrypt.md)

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

[Moved here!](https://github.com/micressor/howtos-linux/blob/master/Server/tripwire.md)

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
