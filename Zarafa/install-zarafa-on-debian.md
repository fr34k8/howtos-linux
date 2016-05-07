# Setup zarafa on debian with pcengines apu board

Inspired by [bootly](https://github.com/nikslor/bootly).

## Base

	apt-get install ca-certificates git uptimed

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

Configuring a zarafa mysql user according to [Configuring the Zarafa Server](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#configure-the-zarafa-server).

	dpkg-reconfigure locales
	[*] de_CH.UTF-8 UTF-8

	vi /etc/default/zarafa
	ZARAFA_USERSCRIPT_LOCALE="de_CH.UTF-8 UTF-8"

### WebApp

Download WebApp from [here](https://download.zarafa.com/community/final/WebApp/2.2.0/) and scp it to apu.

	tar xf debian-8.0.tar
	cd debian-8.0
	dpkg -i *.deb
	apt-get -f install -f
	service apache2 reload

### Config

	vi /etc/zarafa/gateway.cfg
	pop3_enable = no
	imap_enable = no

	vi /etc/zarafa/ical.cfg
	server_bind = 127.0.0.1

	vi /etc/zarafa/dagent.cfg
	server_bind = 127.0.0.1

Restart all /etc/init-d/zarafa-\* services.

## Z-Push

Download z-push from [here](http://download.z-push.org/final/) and install it according to [zarafa doc](https://documentation.zarafa.com/zcp_administrator_manual/configure_zcp_components.html#configure-z-push-activesync-for-mobile-devices)

	wget http://download.z-push.org/final/z-push-x.y.z.tgz
	mkdir -p /usr/share/z-push
	tar zxvf z-push-*.tar.gz -C /usr/share/z-push/ --strip-components=1
	mkdir /var/lib/z-push /var/log/z-push
	chown www-data:www-data /var/lib/z-push /var/log/z-push
	cat /etc/apache2/sites-available/z-push.conf 
	Alias /Microsoft-Server-ActiveSync /usr/share/z-push/index.php
	a2ensite z-push
	service apache2 reload

## Apache

	vi /etc/apache2/vhosts.d/sslengine.include
	# ssl hook
	SSLEngine on
	SSLProxyEngine on
	SSLProtocol all -SSLv2 -SSLv3
	SSLHonorCipherOrder On
	SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH EDH+aRSA !aNULL !eNULL !LOW !3DES !EXP !PSK !SRP !DSS !ADH !EXP !MD5 !RC4"
	# Use HTTP Strict Transport Security to force client to use secure
	# connections only
	Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"

	a2ensite default-ssl
	a2enmod ssl headers
	vi /etc/apache2/sites-enabled/default-ssl
	Include /etc/apache2/vhosts.d/sslengine.include
	SSLCertificateFile /etc/letsencrypt/live/domain.tld/fullchain.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/domain.tld/privkey.pem

	service apache2 reload

## Create user

	zarafa-admin -c xyz -p xyz1234 -e user@domain.tld -f "first last"
	zarafa-admin --create-store xyz

# Links

* [Importing ICAL ics files into Zarafa](https://wiki.zarafa.com/index.php/Importing_ICAL_ics_files_into_Zarafa)
* [Z-Push shared and public folder sync](https://wiki.zarafa.com/index.php/Z-Push_shared_and_public_folder_sync)
