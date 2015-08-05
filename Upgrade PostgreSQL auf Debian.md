# Upgrade postgresql auf debian

Diesen Beitrag habe ich bei
[ariejan.net](http://ariejan.net/2011/11/22/upgrade-postgresql-8-4-to-postgresql-9-1-on-debian/)
gefunden. Er hat mich dabei unterstützt meine sql-ledger Installation zu
aktualisieren:

    su - postgres
    pg_dumpall > dump.sql
    exit
    cp ~postgres/dump.sql /root/

Jetzt die Installation ersetzen:

    aptitude purge postgresql-8.4
    aptitude install postgresql-9.1

Und nun den Dump wieder importieren:

    su - postgres
    psql < dump.sql

## Parallel Betrieb

Von Postgres lassen sich mehrere Versionen/Instanzen auf dem selben
Server betreiben. Bei einer einfachen Instanz ist es sinnvoll nach dem
Dump die alte version zuerst aus Debian zu entfernen, da die
Zweitinstanz sonst einen anderen Port verwendet und die Applikationen
auf den neuen Port oder Postgres auf den alten Port umgebogen werden
müsste.
