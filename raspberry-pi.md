# Volumio audiophile music player (mit Raspberry Pi)

Download Volumio for Raspberry Pi ([Version 1.55](https://volumio.org/get-started))

	dd bs=1M if=volumio155.img of=/dev/sdX

After boot of Pi:

	rpi-update
	reboot
	apt-get update
	apt-get upgrade

There is a problem to add web radios with this version. Login via ssh:

	cd /var/lib/mpd/music/WEBRADIO
	cat << EOF >radioStation.pls
	[playlist]
	numberofentries=1
	File1=http://stream.url
	Length1=-1
	EOF

On the Volmio UI click on Menu > Library and then click *update library*.

# Mit dem Raspberry Pi die Wohnung überwachen

* <http://www.pcwelt.de/ratgeber/Mit_dem_Raspberry_Pi_die_Wohnung_ueberwachen-Sicherheit-8638548.html>
