# CyanogenMod on my device

## Backup

-   A full backup with titanium backup to sdcard1

-   A full backup of sdcard0 to sdcard1: adb shell; cd
    /storage/sdcard1/backups && tar -vch -f sdcard0.tar /storage/sdcard0

-   TitaniumBackup: Create an update.zip to sdcard1/backups/

-   Remove sdcard1 from device

## Install

Files from my repo

-   Factory reset/wipe/format all partitions via ClockworkMod

-   adb sideload cm image

-   reboot into the system

-   date, time and check that the installation is o.k.

-   Einstellungen \> Datenschutz \> aktivieren

-   Einstellungen \> Entwickleroptionen \> Erweiterter Neustart

-   Einstellungen \> Entwickleroptionen \> App beenden (gedrückte zurück
    taste)

-   Shutdown

-   add sdcard1

-   reboot into the recovery

-   adb sideload/Install TitaniumBackup.zip from sdcard1/backups/

-   reboot into the system

-   Check TitaniumBackup configuration

-   adb sideload google apps image

-   Prevent connection to internet

-   configure google/cm sync accounts

## Restore

-   Google-Einstellungen –\> Apps –\> Prüfung deaktivieren.

-   Restore only necessary APPS via titaniumbackup

-   Restore sdcard0 via sdcard1.tar: adb shell; cd /storage/sdcard0 &&
    tar -vx -f /storage/sdcard1/backups/sdcard0.tar

-   Cleanup files at /storage/sdcard0 and /storage/sdcard1

-   Restore only necessary App-DATA via titaniumbackup

-   reboot into the system

-   Verify restored data from important apps: k-9 mail, calendar,
    contacts, firefox

### Anpassungen {#anpassungen .unnumbered}

#### Firefox Add-Ons für Android {#firefox-add-ons-für-android .unnumbered}

-   Bluhell Firewall

-   Self-Destructing Cookies

-   Smart Referer

-   Toggle JavaScript Enabled

Anschliessend mit <http://ip-check.info> testen.

## Apps

From [f-droid.org](http://f-droid.org):

* add to calendar - import .ics files into calendar
* AFWall+ - control network traffic
* AntennaPod - listen to audio feeds
* APG - Encrypt email and files
* K-9 Mail - full-featured email client
* Barcode Scanner - Scan and create 2D and QR codes
* BetterBatterystats - Monitor battery behaviour
* DAVDroid - contacts and calendar sync
* Document Viewer - Viewer for many document formats
* Lesser Pad - Simple memo pad
* OsmAnd~ - Offline/online maps and navigation
* Vanilla Music - Music player


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