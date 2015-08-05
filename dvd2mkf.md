# Wie mache ich aus einem DVD (.vob) ein schönes Matroska (.mkv)?

  
 apt-get install mplayer transcode transcode-utils ogmtools mkvtoolnix  
  
## Eine Kopie der DVD auf dem Rechner erstellen

	mplayer dvd://1 -dvd-device /dev/sr0 -v -dumpstream -dumpfile film.vob  
	dvdxchap -t \<ID\> /dev/dvd \> chaptes.dump  
	mkvmerge -o film.mks --title "Mein Film" film.vob --chapters chapters.dump  

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
