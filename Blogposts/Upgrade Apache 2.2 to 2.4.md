# Tücken beim Upgrade auf Apache 2.4 von 2.2

Ich durfte vor kurzem mit eher suboptimaler Planung auf Apache 2.4
migrieren. In dieser Version des Webservers, [haben sich einige
Einstellungen
geändert](https://httpd.apache.org/docs/2.4/upgrading.html). Die
Markanteste und wichtigste in meinen Augen:

### 2.2 configuration:

    Order deny,allow
    Deny from all

### 2.4 configuration:

    Require all denied

### Wieso erhalte ich 403 permission denied?

Der Webserver sperrt seit 2.4 den Zugriff auf einen VirtualHost, wenn
nicht angegeben wird, wo der Zugriff erlaubt ist. Im folgenden Beispiel
ist der Zugriff auf die gesamte Seite erlaubt.

    <VirtualHost :80>
      <Directory "/path/to/documentroot">
        AllowOverride All
        Options -Indexes
      </Directory>
      <Location />
        Require all granted
      </Location>
    </VirtualHost>

### Wieso funktioniert libapache2-mod-perl2 nicht?

Das Modul **libapache2-mod-perl2** unterstützt Apache 2.4 ab Version
2.0.8. Und das laden von

    a2enmod perl

**reicht nicht aus!** Unbedingt noch

    a2enmod cgi

nachladen.

#### Damit ein Perl Script laufen kann

fordert er Apache Webserver zwei Anweisungen:

    <Directory "/path/to/dir">
      AddHandler cgi-script .pl
      Options +ExecCGI
    </Directory>
