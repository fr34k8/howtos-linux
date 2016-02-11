# CyanogenMod on my device

## Backup

*   A full backup with titanium backup to sdcard1

A full backup of sdcard0 to sdcard1:

	adb shell
	cd /storage/sdcard1
	mkdir backups
	tar -vch -f sdcard0.tar /storage/sdcard0

*   TitaniumBackup: Create an update.zip to sdcard1/backups/

*   Remove sdcard1 from device

## Install

* Factory reset/wipe/format all (/system, /data, /cache) partitions via CM-Recovery

Install cm image:

	apt-get android-tools-adb
	sudo adb sideload image.zip

*   reboot into the system

*   date, time and check that the installation is o.k.

*   Einstellungen \> Datenschutz \> aktivieren

*   Einstellungen \> Entwickleroptionen \> Erweiterter Neustart

*   Einstellungen \> Entwickleroptionen \> App beenden (gedrückte zurück
    taste)

*   Shutdown

*   add sdcard1

*   reboot into CM-Recovery

Restore TitaniumBackup.zip which was saved ad sdcard1/backups/

	adb sideload TitaniumBackup.zip

*   reboot into the system

*   Check TitaniumBackup configuration

Install (if necessary [google apps](https://wiki.cyanogenmod.org/w/Google_Apps)):

	adb sideload gapps.zip

*   Restore/Configure firewall (AFWall+)

*   configure google/cm sync accounts

## Restore

*   Google-Einstellungen –\> Apps –\> Prüfung deaktivieren.

*   Restore only necessary APPS via TitaniumBackup

Restore sdcard0 via sdcard1.tar:

	adb shell
	cd /storage/sdcard0
	tar -vx -f /storage/sdcard1/backups/sdcard0.tar

*   Cleanup files at /storage/sdcard0 and /storage/sdcard1

*   Restore only necessary App-DATA via TitaniumBackup

*   reboot into the system

*   Verify restored data from important apps: k-9 mail, calendar,
    contacts, firefox

### Anpassungen

#### Firefox Add-Ons für Android

-   Bluhell Firewall

-   Self-Destructing Cookies

-   Toggle JavaScript Enabled

-   network.http.sendRefererHeader = 0

Anschliessend mit <http://ip-check.info> testen.

## Apps

Good Appls installed from [f-droid.org](http://f-droid.org):

* add to calendar - import .ics files into calendar
* AFWall+ - control network traffic (or NetGuard)
* AntennaPod - listen to audio feeds
* Barcode Scanner
* Battery Dog
* Call recorder for Android
* Conversations
* CPU Stats
* DateStats
* Diktofon
* Document Viewer - Viewer for many document formats
* HydroMemo
* K-9 Mail - full-featured email client
* Lesser Pad - Simple memo pad
* Material Player
* OpenKeychain
* OsmAnd~
* ServeStream
* Vanilla Music - Music player

# FAQ

## Google-Play-Services crashes (cm-12.1)

* Boot into CM-Recovery

	* Wipe dalvik/art cache

	* Format /cache partition

* Reboot into the system (take a long time, because of [dalvik](https://de.wikipedia.org/wiki/Dalvik_Virtual_Machine) / [ART](https://de.wikipedia.org/wiki/Android_Runtime)).

* If necessary repeat this steps again.

## factory reset für bluetooth paring auf android 4.1.2

Nach weiterer langer Recherche habe ich die Lösung nun selber gefunden.
Die für das BT-Pairing verantwortlichen Konfigurationsdateien liegen in:

    /data/misc/bluetoothd/[device address]/

Das Löschen des Verzeichnisses der Device-Adresse hat geholfen. Nach
einem Reboot waren alle Pairings weg und ich konnte die zuvor nicht
funktionierenden Geräte wieder verbinden

* [defekte bluetooth config](http://www.android-hilfe.de/android-allgemein/158745-defekte-bluetooth-konfiguration.html)
* [this is why i love my android phone](http://sandeep.wordpress.com/2011/07/02/this-is-why-i-love-my-android-phone/)
* [issue](https://code.google.com/p/android/issues/detail?id=24522)

# Links

* <http://androidvulnerabilities.org>
