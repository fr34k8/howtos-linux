# Postfix

Inspired by [ubuntuusers.de](https://wiki.ubuntuusers.de/Postfix/).

## Smarthost (Satelitesystem) config

Steps to configure postfix as a **Satellite System** with smarthost:

	apt-get install postfix

	dpkg-reconfigure postfix

	vi /etc/postfix/main.cf
	relayhost = smtp.domain.tld
	smtp_sasl_auth_enable = yes
	smtp_sasl_security_options = noanonymous
	smtp_sasl_password_maps = hash:/etc/postfix/sasl_password
	smtp_tls_security_level = encrypt

	touch /etc/postfix/sasl_password
	chgrp postfix /etc/postfix/sasl_password
	chmod 640 /etc/postfix/sasl_password
	echo "smtp.doamin.tld username:secret" >/etc/postfix/sasl_password
	postmap hash:/etc/postfix/sasl_password

	/etc/init.d/postfix restart 	
