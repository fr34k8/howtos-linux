# Convert music files for asterisk

	sox -v 0.3 orig.mp3 -e a-law -c 1 -r 8000 dest.alaw.wav
	mv dest.alaw.wav dest.alaw

Tested on SoX v14.4.1
