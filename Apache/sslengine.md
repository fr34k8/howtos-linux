# How to setup Apache TLS/SSL

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
