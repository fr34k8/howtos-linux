# Cron: Jeden ersten Sonntag?

Läuft am ersten bis siebten des Monats jeden Tag und im restlichen Monat
zusätzlich auch an Sonntagen. Geht leider so nicht:

	0 0 1,2,3,4,5,6,7 * 7   /bin/false

So geht’s:

	0 0 * * 7 ... [ $(date +%d) -le 7 ] && mein_skript

* cron checkers [cronchecker](http://www.cronchecker.net/) or [schlitt.info](http://cron.schlitt.info/)
* Gefunden bei [linuxforen.de](http://www.linuxforen.de/forums/showthread.php?138612-Cronjob-der-nur-jeden-ersten-Sonntag-im-Monat-l%E4uft-)
