# Radicale

Tested with v0.9

    apt-get install radicale python-dulwich

**Note:** Please note that these modules have not been verified by
security experts. If you need a really secure way to handle
authentication, you should put Radicale behind a real HTTP server and
use its authentication and rights management methods.

    vi /etc/radicale/config
      [server]
      base_prefix = /radicale/
      [git]
      committer = Radicale <webmaster@localhost>
      [logging]
      debug = True
      [rights]
      type = owner_only

    mkdir -p /var/log/radicale
    touch /var/log/radicale/radicale.log
    chown -R radicale: /var/log/radicale

    mkdir -p /var/lib/radicale/collections
    cd /var/lib/radicale/collections

**Note:** Before first sync

    mkdir user1
    touch user1/calendar.ics
    touch user1/addressbook.vcf
    chown -R radicale: /var/lib/radicale/collections

## Apache

Tested with \>=2.4.10

    vi /var/www/radicale/radicale.wsgi
      import radicale
      radicale.log.start()
      application = radicale.Application()

### VirtualHost

    <VirtualHost *:443>
      # radicale hook
      WSGIDaemonProcess radicale user=radicale group=radicale threads=1
      WSGIScriptAlias /radicale /var/www/radicale/radicale.wsgi
      <Location /radicale>
            AuthType Basic
            AuthName "Radicale Authentication"
            AuthBasicProvider file
            AuthUserFile /var/www/radicale/.radicale.passwd
            Require valid-user

            AllowOverride None
            Order allow,deny
            allow from all

            RewriteEngine On
            RewriteCond %{REMOTE_USER}%{PATH_INFO} !\^{}([\^{}/]+/)$\backslash$1
            RewriteRule .* - [Forbidden]
      </Location>
      <Directory /var/www/radicale>
            WSGIProcessGroup radicale
            WSGIApplicationGroup %{GLOBAL}

            AllowOverride None
            Order allow,deny
            allow from all
      </Directory>
    </VirtualHost>

    a2enmod wsgi
    a2enmod rewrite
    service apache2 reload

DAVDroid <http://davdroid.bitfire.at/features>

Radicale <http://www.radicale.org/documentation>

known bug with radicale and davdroid
<https://github.com/Kozea/Radicale/issues/196#issuecomment-57793486>

Important hint: <http://a3nm.net/blog/davdroid.html>

Radicale website: <http://radicale.org/>
