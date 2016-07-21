# Fortunes

	apt-get install fortune-mod cowsay xcowsay

	vi ~/.bashrc
	if [ -f /usr/games/fortune -a -d /usr/share/cowsay ]; then
	  dir='/usr/share/cowsay/cows/'
	  file=`/bin/ls -1 "$dir" | sort --random-sort | head -1`
	  cow=$(echo "$file" | sed -e "s/\.cow//")
	  /usr/games/fortune ~/dir/to/my/fortunes | /usr/games/cowsay -f $cow
	fi

and via X11:

	crontab -e
	*/16 * * * * /usr/games/fortune ~/dir/to/my/fortunes/ | DISPLAY=:0 /usr/games/xcowsay --reading-speed=800

# Links

* [fortune - Glückskekse via command line](https://wiki.ubuntuusers.de/fortune/)
* [Terminal mit flotten Sprüchen wie bei Linux Mint](https://linuxundich.de/gnu-linux/terminal-mit-flotten-spruchen-wie-bei-linux-mint/)
