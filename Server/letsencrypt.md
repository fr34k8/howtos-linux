# Letsencrypt: generate TLS/SSL certificates

Accordint to [getting started](https://letsencrypt.org/getting-started/) docs.

	cd ~/root
	git clone https://github.com/letsencrypt/letsencrypt
	cd letsencrypt
Test:

	./letsencrypt-auto certonly --dry-run --webroot -w /srv/www/xyz/ -d xyz.domain.tld

Real certifacte generation:

	./letsencrypt-auto certonly --webroot -w /srv/www/xyz/ -d xyz.domain.tld


## Automagic

	cat << EOF >>/tmp/letsencrypt
	#!/bin/bash
	set -x
	/usr/local/letsencrypt/letsencrypt-auto renew
	systemctl reload apache2
	EOF
	install -o root -g root -m 755 /tmp/letsencrypt /etc/cron.weekly/letsencrypt
