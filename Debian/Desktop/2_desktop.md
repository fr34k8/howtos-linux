# General desktop modifications

## Useful office software

	apt-get install gummi texlive-lang-german

## Drucker / Scanner MG4100series

      cd /tmp

Download der Treiber:
<https://www.marco-balmer.ch/~maba/linux/hb/lenovo/t510>

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

Gefunden im privacy-handbuch.de

URL: about:config

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

-   Smart Referer

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

## Password Store (Pass)

### Konzept

* Pass ([Password Store](http://www.passwordstore.org)) wird mit git repo genutzt

* Auf *server:/home/user/.password-store.git* befindet sich das --bare Repo

* Redundanz: Jede WS hat eine lokale Kopie (git clone) des Repos.

* Im Disaster Fall:

	* Zugang zu einer aktuellen Kopie des Repos

		* **Wie wird der Zugang** sicher gestellt?

		* usb stick?
		* 3rd party shell server?

	* Zugang zum aktuellen ~/.gnupg für das Pass Repo

		* Wie wird der Zugang **sicher gestellt?**

		* usb stick?
		* 3rd party shell server?

### Requirements

	apt-get install pass git

	vi /etc/bash.bashrc
	  . /usr/share/bash-completion/completions/pass

* logout --> login oder

	$ . /usr/share/bash-completion/completions/pass

### Auf dem Server

Pass initialisieren:

	pass init {gpg-id}
	pass git init

	vi ~/.bashrc
	  . /usr/share/bash-completion/completions/pass


Git **Main** Repo erstellen:

	cd .
	mkdir .password-store.git
	cd .password-store.git
	git init --bare

Verbindung von **Pass** zum **Main** Repo herstellen:

	cd .
	pass git remote add origin $HOME/user/.password-store.git/

Test Eintrag:

	pass insert test/test1
	pass test/test1

Initialer erster Sync zum **Main** Repo:

	pass git push -u --all

### Auf dem Client

Initialer Sync:

	git clone host.domain.tld:/home/user/.password-store.git .password-store
	pass test/test1

Sync:

	pass git pull
	pass git push