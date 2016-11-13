# Fairphone Open: Install and settings

## Enable Debug-Mode

* Settings -> Storage -> USB-Connections -> [All checkboxes DISABLED]
* Settings -> Development -> USB-Debugging [ENABLED]

## Backup

* Export NetGuard settings as `.xml` file
* Export K-9 Mail settings
* Export AntennaPod settings as `.opml` file
* Export Contacts as `.vcf` files
* Export Calendar as `.ics` via Web-App.
* Export spaRSS as `.opml` file

### via tar

Perform a full backup of sdcard0 to sdcard1:

	apt-get install android-tools-adb
	adb shell
	cd /storage/sdcard1
	mkdir backups
	tar -vch -f sdcard0.tar /storage/sdcard0

*   Remove sdcard1 from device

**Note:** Have also a look at [backup.md](https://github.com/micressor/howtos-linux/blob/master/Android/Fairphone-FP2/backup.md)

### via Amaze app

1. Settings -> Zip Create Folder -> /storage/sdcard1
2. Select all dirs at sdcard0 -> Compress to `.zip`
3. Remove sdcard1 from device

## Install

## Restore

Restore sdcard0 via sdcard1.tar:

	adb shell
	cd /storage/sdcard0
	tar -vx -f /storage/sdcard1/backups/sdcard0.tar

## Settings

### Display

* Adaptive Helligkeit: on
* Ruhezustand: 30 secs

### Ton/Audio

* Unterbrechungen
* Andere Töne: all off

### Speicher

* USB Connection: only charge

### Akku ab 15% im Sparmodus

### Standort

* Standortverbesserung durch Google jeweils ablehnen

### Sicherheit

* Displaysperre: PIN
* Automatisch sperren: Nach 5 Minuten im Ruhezustand
* Geräteadministratoren > Android Geräte-Manager: disabled
* Trust Agents > Smart Lock (Google): disabled
* Apps mit Nutzungsdatenzugriff: all disabled

## Apps

Good Apps installed from [f-droid.org](http://f-droid.org):

* add to calendar - import .ics files into calendar
* Amaze - Manage local files
* AFWall+ - control network traffic (or NetGuard)
* AntennaPod - listen to audio feeds
* Barcode Scanner
* BatteryBot Pro
* Bitcoin Wallet
* Boilr
* Call recorder for Android
* Conversations
* DAVdroid - sync contacts and calendars
* Document Viewer - Viewer for many document formats
* FFUpdater
* HydroMemo
* K-9 Mail - full-featured email client
* Lesser Pad - Simple memo pad
* Material Player
* NetGuard
* Open Camera
* OpenKeychain
* Orbot
* OS Monitor
* OsmAnd~
* spaRSS
* VLC
* Wifi Analyzer

Good Apps installed from [APTOIDE](http://www.aptoide.com/):

* aCalendar+
* MeteoSwiss
