# mail / sSMTP

**Manpage:** ssmtp is a send-only sendmail emulator for machines which
normally pick their mail up from a centralized mailhub (via pop, imap,
nfs mounts or other means). It provides the functionality required for
humans and programs to send mail via the standard or /usr/bin/mail user
agents. Konfiguration gemäss:

	apt-get install ssmtp

	vi /etc/ssmtp/ssmtp.conf
	# The person who gets all mail for userids < 1000
	root=myname

	# Where will the mail seem to come from?
	rewriteDomain=domain.tld

	# The full hostname of your workstation
	  hostname=ws.domain.tld

	# The place where the mail goes. The actual machine name is required no
	# MX records are consulted. Commonly mailhosts are named mail.domain.com
	mailhub=mailserver.domain.tld:587


	UseSTARTTLS=YES
	AutHUser=myname@domain.tld
	AuthPass=pass
	#Debug=YES

	vi /etc/ssmtp/revaliases
	# Example: root:your_login@your.domain:mailhub.your.domain[:port]
	# where [:port] is an optional port number that defaults to 25.
	root:myname@domain.tld
