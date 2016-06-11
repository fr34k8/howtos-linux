# Postfix

Steps to configure postfix as a **Satellite System** with smarthost.
Inspired by [ubuntuusers.de](https://wiki.ubuntuusers.de/Postfix/).

## Smarthost (Satelitesystem) config


	apt-get install postfix
	dpkg-reconfigure postfix

Configure to catch all e-mails to root:

	vi /etc/aliases
	root: me@domain.tld

Generate db:

	newaliases

Configure postfix for smarthost config:

	vi /etc/postfix/main.cf
	# TLS parameters
	smtpd_tls_cert_file=/etc/letsencrypt/live/domain.tld/chain.pem
	smtpd_tls_key_file=/etc/letsencrypt/live/domain.tld/privkey.pem
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

Proper sender names:

	cd /etc/postfix
	vi main.cf
	sender_canonical_maps = hash:/etc/postfix/sender_canonical

	touch sender_canonical
	chgrp postfix sender_canonical
	chmod 640 sender_canonical

	vi sender_canonical
	root me@domain.tld

	postmap hash:/etc/postfix/sender_canonical

	/etc/init.d/postfix restart 	
