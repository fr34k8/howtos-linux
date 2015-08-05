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
