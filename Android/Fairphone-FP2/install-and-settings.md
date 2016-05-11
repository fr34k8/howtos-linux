# Backup & Restore / Migrate procedure

1. Backup important settings
2. Settings > Security > Enable unkown sources
3. Install f-droid.org store
4. Install Firefox from f-droid.org
5. Install [NetGuard from github.com](https://github.com/M66B/NetGuard/releases)
6. Install [SSHelper](http://arachnoid.com/android/SSHelper/resources/SSHelper.apk) from arachnoid.com. See detailed [backup howto](https://github.com/micressor/howtos-linux/blob/master/Fairphone-FP2/backup.md).
7. Settings > Security > encrypt phone
8. Restore all data to internal storage using SSHelper.
9. Restore NetGuard firewall settings
10. Add google account

Follow detailed instructions below.

# Backup

* Export NetGuard settings
* Export K-9 Mail settings
* Export AntennaPod settings
* Export Contacts as vcard files

# Wipe & Install

Download `fp2-sibon-16.04.0-ota-userdebug.zip` from http://code.fairphone.com.

Boot your FP2 into fastboot mode.

	fastboot -w update fp2-sibon-16.04.0-ota-userdebug.zip

Download `open_gapps-arm-X.X-pico-2016XXXX.zip` from http://opengapps.org.

Boot your FP2 into TWRP `recovery` mode and disable md5 on .zip files. Activate
TWRP's sideload and start upload from your linux desktop:

	adb sideload open_gapps-arm-X.X-pico-2016XXXX.zip

Reboot your FP2.

# Encrypt your FP2

I had some problems to encrypt my FP2. So this was my solution: Boot into TWRP
`recovery` and drop a root shell:

	ls -1 /dev/block/platform/*/userdata
	/dev/block/platform/xyz/userdata
	dd if=/dev/zero of=/dev/block/platform/xyz/userdata

Download `fp2-sibon-16.04.0-ota-userdebug.zip` from http://code.fairphone.com.

	unzip -d fp2-sibon-16.04.0-ota-userdebug fp2-sibon-16.04.0-ota-userdebug.zip
	cd fp2-sibon-16.04.0-ota-userdebug

Boot your FP2 into fastboot mode:

	fastboot -w flash userdata fp2-sibon-16.04.0-ota-userdebug/userdata.img

Reboot your FP2 and start encryption at Settings > Security after set your PIN.

See this topic: [Encrypt phone with FairPhone OpenSoure OperatingSystem](https://forum.fairphone.com/t/encrypt-phone-with-fairphone-opensoure-operatingsystem/15474/11)

# Install f-droid apps

Do never accept a google license question, during an f-droid app installation.

Cool apps installed from [f-droid.org](http://f-droid.org) store:

* [Add to calendar](https://f-droid.org/repository/browse/?fdfilter=calendar&fdid=org.dgtale.icsimport) - Import .ics files into calendar

* [Amaze](https://f-droid.org/repository/browse/?fdfilter=amaze&fdid=com.amaze.filemanager) - Light and smooth file manager following the Material Design guidelines.

* [AntennaPod](https://f-droid.org/repository/browse/?fdfilter=antennapod&fdid=de.danoeh.antennapod) - Advanced podcast manager and player

* Barcode Scanner

* Call recorder for Android

* Conversations

* DateStats

* Diktofon

* Document Viewer - Viewer for many document formats

* [JAWS](https://f-droid.org/repository/browse/?fdfilter=jaws&fdid=is.pinterjann.jaws) - A simple wifi scanner that supports real time scans of nearby networks. It displays a list of nearby wifi networks ordered by signal strength and periodically rescans for new neworks.

* K-9 Mail - full-featured email client

* Lesser Pad - Simple memo pad

* Material Player

* [NetGuard](https://f-droid.org/repository/browse/?fdfilter=netguard&fdid=eu.faircode.netguard) - Block network access

* OpenKeychain

* OsmAnd~

* [OS Monitor](https://f-droid.org/repository/browse/?fdfilter=os+monitor&fdid=com.eolwral.osmonitor) - Monitor the Operating System

* VLC

* Apollo

# Settings

## Display

* Adaptive Helligkeit: on
* Ruhezustand: 30 secs

## Ton/Audio

* Unterbrechungen
* Andere Töne: all off

## Speicher

* USB Connection: only charge

## Akku ab 15% im Sparmodus

## Standort

* Standortverbesserung durch Google jeweils ablehnen

## Sicherheit

* Displaysperre: PIN
* Automatisch sperren: Nach 5 Minuten im Ruhezustand
* Geräteadministratoren > Android Geräte-Manager: disabled
* Trust Agents > Smart Lock (Google): disabled
* Apps mit Nutzungsdatenzugriff: all disabled

## Konto Synchronisation

Only enable Calendar/Contact sync. All other should be off.

## Apps

Disabled Apps:

* Chrome
* Fotos
* Gmail
* Google Apps
* Google Drive
* Google Play Filme
* Google Play Musik
* Google Text-in-Sprache
* Hangouts
* iFixit
* Maps
* Talkback
* Youtube

## Sparche & Eingabe

* Rechtschreibeprüfung: off

* Android-Tastatur (AOSP)

** Einstellungen: All off
** Textkorrektur: All off

## Datum & Uhrzeit

* Datumsformat auswählen
