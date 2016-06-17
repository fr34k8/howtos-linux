# Letsencrypt: generate TLS/SSL certificates

Accordint to [getting started](https://letsencrypt.org/getting-started/) docs.

	cd ~/root
	git clone https://github.com/letsencrypt/letsencrypt
	cd letsencrypt
Test:

	./letsencrypt-auto certonly --dry-run --webroot -w /srv/www/xyz/ -d xyz.domain.tld

Real certifacte generation:

	./letsencrypt-auto certonly --webroot -w /srv/www/xyz/ -d xyz.domain.tld

