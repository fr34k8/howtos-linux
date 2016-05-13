# Password Store (Pass)

## Konzept

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

## Requirements

	apt-get install pass git

	vi /etc/bash.bashrc
	  . /usr/share/bash-completion/completions/pass

* logout --> login oder

	$ . /usr/share/bash-completion/completions/pass

## Auf dem Server

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

## Auf dem Client

Initialer Sync:

	git clone host.domain.tld:/home/user/.password-store.git .password-store
	pass test/test1

Sync:

	pass git pull
	pass git push
