# General desktop modifications

## Useful office software

	apt-get install gummi texlive-lang-german network-manager-openvpn-gnome

## Drucker / Scanner MG4100series

      cd /tmp

Download der Treiber von [hier](https://github.com/micressor/firmware/tree/master/printers/PIXMA%20MG%204100%20Series).

      tar xfz cnijfilter*.tar.gz
      tar xfz scangearmp*.tar.gz
      cd cnijfilter-mg4100series-3.60-1-deb
      ./install.sh
      cd ../scangearmp-mg4100series-1.80-1-deb
      ./install.sh

Via Gnome Drucker Menu den Drucker suchen und hinzufügen.

## Gnome

### Extensions

[Drop down
terminal](https://extensions.gnome.org/extension/442/drop-down-terminal/)

[Alternate Tab](https://extensions.gnome.org/extension/15/alternatetab/)

[system-monitor](https://extensions.gnome.org/extension/120/system-monitor/)

[Suspend
Button](https://extensions.gnome.org/extension/826/suspend-button/)

[Hibernate Status
Button](https://extensions.gnome.org/extension/755/hibernate-status-button/)

[Refresh Wifi
Connections](https://extensions.gnome.org/extension/905/refresh-wifi-connections/)

[Sound Output Device
Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)

[Battery Power Statistics
Shortcut](https://extensions.gnome.org/extension/175/battery-power-statistics-shortcut/)

[CPU Power
Manager](https://extensions.gnome.org/extension/945/cpu-power-manager/)

[windowNavigator](https://extensions.gnome.org/extension/10/windownavigator/)

	gnome-shell-extension-prefs

## gpg: WARNING: The GNOME keyring manager hijacked the GnuPG agent

Disable GNOME Keyring:

	sudo dpkg-divert --local --rename --divert /etc/xdg/autostart/gnome-keyring-gpg.desktop-disable --add /etc/xdg/autostart/gnome-keyring-gpg.desktop

If you later decide to reenable it, then you can use:

	sudo dpkg-divert --rename --remove /etc/xdg/autostart/gnome-keyring-gpg.desktop

Frome [wiki.gnupg.org](https://wiki.gnupg.org/GnomeKeyring)

## Firefox / Iceweasel

### Add-Ons

* NoScript
* uBlock Origin
* Better Privacy (LSO's / SuperCookies)
* Self-Destructing Cookies
* SixOrNot

### about:config

	media.peerconnection.enabled = False
	geo.enabled = False
	dom.battery.enabled = False
	dom.gamepad.enabled = False
	media.video_stats.enabled = False
	extensions.blocklist.enabled = False
	extensions.getAddons.cache.enabled = False
	beacon.enabled = False
	browser.cache.disk.enable = False
	browser.cache.memory.enable = False
	network.http.sendRefererHeader = 0
	network.http.referer.XOriginPolicy = 1
	webgl.disabled = True
	webgl.disable-extensions= True

Inspired by [privacy-handbuch.de](https://privacy-handbuch.de/handbuch_21.htm).

### Silverlight

Silverlight erfordert die Installation von [pipelight](http://pipelight.net/cms/install/installation-debian.html).

	sudo dpkg --add-architecture i386
	cd /tmp; wget http://repos.fds-team.de/Release.key
	sudo apt-key add Release.key

	cat << EOF >>/etc/apt/sources.list
	deb http://repos.fds-team.de/stable/debian/ jessie main
EOF

	apt-get update
	apt-get install pipelight-multi
	pipelight-plugin --update
	sudo pipelight-plugin --enable silverlight

Wenn das Plugin beim restart von Firefox zu lange hat, [blockiert es firefox.](http://pipelight.net/cms/faqs/faq-most-common-problems.html)

	sudo pipelight-plugin --create-mozilla-plugins

Neustart des Browsers.

	pipelight-plugin --system-check

### Add-Ons

-   NoScript

-   Certificate Patrol

-   SixorNot

-   Adblock Edge

-   BetterPrivacy

Anschliessend mit <http://ip-check.info> testen.

## Playing DVD's

	vi /etc/apt/sources.list

	  # for http://www.videolan.org/developers/libdvdcss.html
	  deb http://download.videolan.org/pub/debian/stable/ /
	  deb-src http://download.videolan.org/pub/debian/stable/ /

	wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -
	apt-get update
	apt-get install libdvdcss2

For ripping dvd's:

	apt-get install handbrake

## GnuPG Dateien on-the-fly bearbeiten

    apt-get install vim-scripts
    vim-addons install gnupg

### Eine Datei initial vor der Bearbeitung verschüsseln

    vi test.txt
      Text
    gpg --encrypt test.txt

    $ ls -l test.txt.gpg
    -rw-rw---- 1 user user 588 Okt  6 13:33 test.txt.gpg

### On the fly bearbeiten

    $ vi test.txt.gpg

    You need a passphrase to unlock the secret key for
    user: "User Muster <user@muster.ch>"
    4096-bit RSA key, ID FFFFFFFF, created 2013-02-27 (main key ID FFFFFFFF)

    Enter passphrase:

Mit :w oder :wq wird die Bearbeitung beendet und die Datei on-the-fly
verschlüsselt.

Vim mit gnupg http://wiki.debianforum.de/Vim_mit_gnupg

Verschlüsselte E-Mails mit GnuPG als Supergrundrecht
http://www.kuketz-blog.de/verschluesselte-e-mails-mit-gnupg-als-supergrundrecht/

## Photoprint

Zum praktischen ausdrucken von mehreren Fotos auf einre Seite:

	apt-get install photoprint

Siehe [hier](https://wiki.ubuntuusers.de/photoprint).
