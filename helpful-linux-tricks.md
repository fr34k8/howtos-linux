# Zitate

> "Mutt was developed with the concept of one task per tool, enabling performance through combination with other high quality modular programs. This is an aspect of the unix philosophy" [mutt.org](http://dev.mutt.org/trac/wiki/MailConcept#muttandSMTP)

> A Markdown-formatted document should be publishable as-is, as plain text, without looking like it’s been marked up with tags or formatting instructions. – [John Gruber](http://pandoc.org/README.html#pandocs-markdown)

# Wie konvertiere ich flash videos nach mp3 audio? 

	mplayer -dumpaudio file.flv -dumpfile file.mp3

# Passworte erstellen / qualität prüfen

	apt-get install pwgen passwdqc
	pwgen -B 12 1
	keazii9gaeVu
	echo "keazii9gaeVu" | pwqcheck -1
	OK

* [passwdqc](http://www.openwall.com/passwdqc/)

# Vim

## encoding to utf-8

	:write ++enc=utf-8

## dos2unix tipps

	:set ff=unix  
	:set ff=dos  
	:e ++ff=mac foo.txt  
	:w ++ff=unix  
	vim \*.txt  
	:set hidden  
	:bufdo %s/\\r\$//e  
	:bufdo %s/\\r/ /eg  
	:xa

## ask before serach/replace

	:1,\$s/text/text2/gc

## Another .vimrc

	set ruler  
	syntax on  
	set showcmd  
	set history=50  
	set incsearch  
	if &amp;t\_Co &gt; 1  
	  syntax enable  
	endif  
	colorscheme blue
# snmp

Übersetzung von SNMP OID’s zur Beschreibung.

	$ snmptranslate -Td 1.3.6.1.4.1.2021.11.53.0

	UCD-SNMP-MIB::ssCpuRawIdle.0
	ssCpuRawIdle OBJECT-TYPE
	-- FROM UCD-SNMP-MIB
	SYNTAX  Counter32
	MAX-ACCESS  read-only
	STATUS  current
	DESCRIPTION "The number of 'ticks' (typically 1/100s) spent idle.
	
	On a multi-processor system, the 'ssCpuRaw*'
	counters are cumulative over all CPUs, so their
	sum will typically be N*100 (for N processors)."

# RPM vs DEB on technical merits alone

Interessanter teschnischer Artikel über die Vor- und Nachteilen der Paketmanagern DEB und RPM. [Zum Artikel](http://lwn.net/Articles/223183/)

# create a dvd from a avi file

	apt-get install dvd+rw-tools ffmpeg dvdauthor
	ffmpeg -i film.avi -aspect 16:9 -target pal-dvd dvd.mpg
	ffmpeg -i film.avi -aspect 4:3 -target pal-dvd dvd.mpg
	dvdauthor -t -o dvd/ dvd.mpg
	dvdauthor -o dvd/ -T
	growisofs -Z /dev/dvd -dvd-video dvd/

If you receive an error such as “ERR: no video format specified for VMGM”
you must set the video format variable. An easy way to do this is to add
export VIDEO\_FORMAT=NTSC (for NTSC regions) to your  /.bashrc.

## Und wenn ich nur eine Audiospur will?

	mplayer dvd://1 -dvd-device /dev/sr0 -v -dumpstream -dumpfile film.vob  
	dvdxchap -t \<ID\> /dev/dvd \> chaptes.dump  
	tcextract -i film.vob -t vob -x mpeg2 \> film.m2v  
  
Je nachdem wieviele Audiospuren es im Film gibt.

	tcextract -i film.vob -t vob -x ac3 -a 0 \> tcaudio0.ac3 &  
	tcextract -i film.vob -t vob -x ac3 -a 1 \> tcaudio1.ac3 &  
	tcextract -i film.vob -t vob -x ac3 -a 2 \> tcaudio2.ac3  
  
Und wieder zusammenbauen mit gewünschter Tonspur:

	mkvmerge -o film.mks --title "Mein Film" -A film.m2v tcaudio1.ac3a --chapters chapters.dump


# Cron: Jeden ersten Sonntag?

Läuft am ersten bis siebten des Monats jeden Tag und im restlichen Monat
zusätzlich auch an Sonntagen. Geht leider so nicht:

	0 0 1,2,3,4,5,6,7 * 7   /bin/false

So geht’s:

	0 0 * * 7 ... [ $(date +%d) -le 7 ] && mein_skript

* cron checkers [cronchecker](http://www.cronchecker.net/) or [schlitt.info](http://cron.schlitt.info/)
* Gefunden bei [linuxforen.de](http://www.linuxforen.de/forums/showthread.php?138612-Cronjob-der-nur-jeden-ersten-Sonntag-im-Monat-l%E4uft-)

# Bash

## Einfacher regular expression in bash mit sed

	AUSGABE=$(echo $TEST | sed 's/.://g')

## Increment einer variabel auf zwei arten mit bash

	ERROR_COUNT=$((ERROR_COUNT+1))

## Logfile umleiten

	LOGFILE="/tmp/`basename "$0" .sh`.log"
	exec 1>${LOGFILE}
	exec 2>&1

## Datum

	BACKUP_DATE=$(date +%Y%m%d-%H%M)
	BackupDate=$(date -d "-1 day" +"%Y-%m-%d")

# Wie erstelle ich Images (.bin .toc .cue) von einer Audio-CD?

Mit dem Softwarepaket
[cdrdao](http://packages.qa.debian.org/c/cdrdao.html) lassen sich Images
von Audio-CD's erstellen.

	cdrdao read-cd --read-raw --paranoia-mode 3 --datafile image.bin --device /dev/sr0 image.toc

Note: Es ist nicht möglich ein .iso Image aus einer audio-cd zu
erstellen.

	toc2cue image.toc image.cue

Note: Einige CD Brenner Software mögen eher .toc's andere .cue's
# apache authentifizieren über client zertifikat

	<Location / >
	  DAV On
	  SSLRequireSSL
	  SSLVerifyClient required
	  SSLVerifyDepth  2
	  # Bedinung e-mail adresse ist im client certificate enthalten
	  SSLRequire %{SSL_CLIENT_S_DN_Email}  eq "email@domain.tld"
	</Location>

