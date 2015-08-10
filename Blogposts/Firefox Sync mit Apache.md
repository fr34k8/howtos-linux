# Firefox Sync Server in bestehende Apache SSL Konfiguration einbauen

Synchronisierung ist ein geniales Tool. Wenn ich dabei an die Zeiten von
POP3 denke, ist das schlechthin beeindruckend. :-)

*Wie genau lässt sich ein Firefox-Sync Server auf einer bestehenden
Apache 2.4 Umgebung einrichten?* - Da es für diese Software bisher kein
Debian Paket gab, nutzen wir das Repository von Mozilla. Wir gehen dabei
davon aus, dass bereits ein **VirtualHost** mit einer funktionierenden
SSL Konfiguration besteht:

# Installation und Zusammenbau

## Als root

    apt-get install python-dev mercurial sqlite3 python-virtualenv libssl-dev
    useradd -d /opt/fsync fsync
    cd /opt
    hg clone https://hg.mozilla.org/services/server-full fsync
    chown -R fsync: /opt/fsync
    chown o-rwx /opt/fsync/*

## Als fsync

    su - fsync
    cp /etc/skel/.profile .
    cp /etc/skel/.bashrc .
    cp /etc/skel/.bash_logout .
    vim .bashrc
      umask 007
    exit
    su - fsync
    make build
    echo $?
    0
    make test
    echo $?
    0

# Konfiguration

    mkdir /var/lib/fsync
    chown -R fsync: /var/lib/fsync
    chmod 700 /var/lib/fsync

vim etc/sync.conf

    [nodes]
    # You must set this to your client-visible server URL.
    fallback_node = https://domain.tld/fsync
    [storage]
    sqluri = sqlite:////var/lib/fsync/fsync.db
    [auth]
    sqluri = sqlite:////var/lib/fsync/fsync.db
    # Nachdem wir unseren User erstellt haben, stellen
    # wir allow_new_users auf false, damit nur wir den 
    # sync server nutzen können.
    allow_new_users = true
    [reset_codes]
    sqluri = sqlite:////var/lib/fsync/fsync.db

# Datenbank erstellen

Dadurch, dass wir den Server erstmals von der Shell starten, erstellt
dieser eine Sqlite3 Datenbank:

    su - fsync
    bin/paster serve development.ini
    Starting server in PID 29951.
    serving on 0.0.0.0:5000 view at http://127.0.0.1:5000

Sind keine Fehlermeldungen vorhanden mit CTRL-C abbrechen und den Zugang
via Shell sperren:

    exit
    usermod -s /bin/false fsync

# Den Apache für den Firefox Sync Server anpassen

    apt-get install libapache2-mod-wsgi
    a2enmod wsgi

Hier der Teil, der in die bestehende Apache 2.4 VirtualHost SSL
Konfiguration eingefügt wird:

      <Directory /opt/fsync>
        Require all granted
      </Directory>    
                                                                    
      WSGIProcessGroup fsync
      WSGIDaemonProcess fsync user=fsync group=fsync processes=2 threads=25
      WSGIPassAuthorization On
      WSGIScriptAlias /adm/fsync /opt/fsync/sync.wsgi

Und jetzt neu starten:

    service apache2 reload

und den ersten Sync gemäss dem HOWTO [wie ich Firefox-Sync
einrichte](https://support.mozilla.org/de/kb/wie-richte-ich-firefox-sync-ein)
durchführen.

# Den Server updaten

Wir sollten den den Server regelmässig auf den aktuellsten Stand
bringen, damit die letzten bugs/fixes integriet sind:

    usermod -s /bin/bash fsync
    su - fsync
    hg pull
    hg update
    make build
    make test
    exit
    usermod -s /bin/false fsync

# Troubleshooting

## Sync mit Firefox auf Android

Hierbei ist mir aufgefallen, dass die Synchronisation nur funktioniert,
wenn das TLS/SSL Zertifikat des Apache von einem Herausgeber signiert
ist, der im Certificate Store von Android vorhanden ist. Ist das
Zertifikat Z.B. selbst signiert oder von [CAcert](http://www.cacert.org)
herausgegeben, ist es notwendig, [diese Root
Zertifikate](http://www.cacert.org/index.php?id=3) entsprechend im
Android Gerät zu installieren.

**Firefox wird sonst nicht einmal eine Verbindung nach draussen
probieren** und sagt schlicht «Bitte geben Sie eine Gültige Server-URL
ein».

Dazu passend gefunden ein
[Bug](https://bugzilla.mozilla.org/show_bug.cgi?id=756763).

## Server-URL ungültig

Je nach Firefox Version läst sich dieser Fehler umgehen, mit oder ohne
Angabe des abschliessenden **slash**:

-   https://domain.tld/adm/fsync/
-   https://domain.tld/adm/fsync

# Links

-   [Das HOWTO von
    Mozilla](http://docs.services.mozilla.com/howtos/run-sync.html)
-   [Übersicht des Firefox Sync
    Services](http://docs.services.mozilla.com/overview.html)
-   [Zusammenfassung der Verschlüsselung von Firefox
    Sync](https://wiki.mozilla.org/Labs/Weave/Developer/Crypto)
