# Convert music files for asterisk

	sox -v 0.6 -r 8000 -e signed -b 16 -c 1 src.mp3 dst.sln

Tested on SoX v14.4.1
