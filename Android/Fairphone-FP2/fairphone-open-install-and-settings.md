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
* Export Bitcoin Wallet as backup file

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

### via SSHelper app

1. Install SSHelper from [here](http://arachnoid.com/android/SSHelper/resources/SSHelper.apk).
2. Check [howto](https://github.com/micressor/howtos-linux/blob/master/Fairphone-FP2/backup.md) setup.

## Install

1. Settings > Security > encrypt phone (if encryption does not work, see Appendix below)
2. Settings > Security > Enable unkown sources
3. Install F-Droid store from [here](https://f-droid.org/FDroid.apk)
4. Install Firefox via FFUpdater app (from F-Droid).
5. Install NetGuard from [here](https://github.com/M66B/NetGuard/releases)
6. Restore all data to internal storage using prefered backup/restore method.
7. Restore NetGuard firewall settings from `.xml` file
8. Install necessary apps. See apps chapter below.

## Restore

### via tar

Restore sdcard0 via sdcard1.tar:

	adb shell
	cd /storage/sdcard0
	tar -vx -f /storage/sdcard1/backups/sdcard0.tar

### via Amaze app


1. Copy `.zip` to target
2. Select extract here

### via SSHelper app

See backup chapter.

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

### Firefox Add-Ons

* Self-Destructing Cookies
* uBlock Origin
* [NSA - NoScript](https://noscript.net/nsa/) Anywhere

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
* LeafPic
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

Apps to deactivate:

* Browser
* Kamera
* Sprachwahl
* Suche

# Appendix

## Encrypt your FP2

I had some problems to encrypt my FP2. Cause was that this FP2 was already
encrypted before. It seems a LUKS header problem. So this was my solution:

1. Boot into TWRP `recovery` and drop a root shell:

	ls -1 /dev/block/platform/*/by-name/userdata
	/dev/block/platform/xyz/by-name/userdata
	dd if=/dev/zero of=/dev/block/platform/xyz/by-name/userdata bs=1M

This overwrite very block of the userdata partition with zero's and  consumes a lot of time (my last try was 10 minutes)! Be careful with this.

2. Boot into bootloader (fastboot) mode and re-create your userdata partition:

	fastboot erase userdata
	fastboot format userdata

3. Boot normal into your FP2 and start encryption again (at Settings -> Security).

Check also this topic: [Encrypt phone with FairPhone OpenSoure OperatingSystem](https://forum.fairphone.com/t/encrypt-phone-with-fairphone-opensoure-operatingsystem/15474/11)

* Faster with resize2fs command: Check [Encrypt phone with FairPhone Open OS](https://forum.fairphone.com/t/encrypt-phone-with-fairphone-open-os/15474/32)
