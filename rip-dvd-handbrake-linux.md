# DVD's rippen

## Requirements

	apt-get install dvdbackup handbrake

## Auf Disk rippen

Der Title mit den grössten Dateien ist im Normalfall der Film, danach rippen:

	dvdbackup -M -i /dev/sr0 -o ~/DVD -p

Nur die Option -M stellt eine komplette Video-DVD Struktur her. Alternativ kann nur der Titel mit dem Film kopiert werden und mit zusätzlicher Software die Video-DVD Struktur nur für diesen Titel erstellt werden. Dies ist notwendig, damit Handbrake, die Daten weiterverarbeiten kann.

# Handbrake settings for dvd

Via Source das Verzeichnis wählen, indem sich der Ordner ./VIDEO\_TS befindet.

## Ziel der Einstellungen

* Encodes fast

* High quality

* Smallest file size possible

### Picture

* Anamorphic: Loose

Anpassen der *Storage Geometry*, sodass die *Display Geometry* auf 1920x. Siehe [Anamorphic DVDs](https://trac.handbrake.fr/wiki/AnamorphicGuide).

* Denoise Filter: HQDN3D

* Denoise Preset: Medium

* Deblock: Off

### Video

* video codec H.264

* Output format: Matroska (avformat)

* Frame rate "Same as Source" 

* Constant Quality: RF 20

* Variable Framerate

* Preset: medium - veryslow

* Tune: Film

* Profile: heigh

* Level: 4.1

* Fast Decode: unchecked

### Audio Defaults

* Selected Languages: Deutsch, English

* Encoder: Auto Passthru

### Audio List

* Click on Reload Defaults

### Chapters

* Uncheck Chapter Markers

# Links

* [High Definition Television](https://de.wikipedia.org/wiki/High_Definition_Television)

* [A “best settings” guide for Handbrake 0.9.9 and 0.10](https://mattgadient.com/2013/06/12/a-best-settings-guide-for-handbrake-0-9-9)


* [Backing up/Ripping and Transcoding DVDs in Linux](http://www.oyvindhauge.com/blog/2010/09/19/backing-upripping-dvds-in-linux/)

* [Easiest Best Optimal settings for Handbrake DVD Video Conversion on Mac, Windows and Linux](http://www.thewebernets.com/2015/02/28/easiest-best-optimal-settings-for-handbrake-dvd-video-conversion-on-mac-windows-and-linux)

* [Easiest Best Optimal settings for Handbrake 1080p Blu Ray Video Conversion on Mac, Windows and Linux](http://www.thewebernets.com/2014/12/31/quickest-easiest-best-optimal-settings-for-handbrake-blu-ray-video-conversion-on-mac-windows-and-linux)
