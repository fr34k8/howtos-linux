## Fail2ban

	apt-get install fail2ban
	fail2ban-client ping
	fail2ban-client status

### config

	cat << EOF >>/etc/fail2ban/jail.local
	[DEFAULT]
	action = %(action_mwl)s
	#sender = fail2ban@localhost
	ignoreip = 127.0.0.1/8 # more ip's
	# A host is banned if it has generated "maxretry" during the last "findtime"
	# seconds.
	findtime = 600
	maxretry = 3
	bantime  = 86400  ; 1 day

	#[ssh]
	#enabled  = true
	[apache]
	enabled  = true
	[ssh-ddos]
	enabled  = true
	[postfix]
	enabled  = true
	[apache-noscript]
	enabled  = true
	[apache-overflows]
	enabled  = true
	[asterisk-tcp]
	enabled = true
	[asterisk-udp]
	enabled = true
	[pam-generic]
	enabled = true
	[php-url-fopen]
	enabled = true
	logpath = /var/log/apache*/*access.log
	[mysqld-auth]
	enabled = true
	logpath = /var/log/mysql/error.log
	EOF

	service fail2ban restart

