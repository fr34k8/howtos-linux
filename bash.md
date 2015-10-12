# Lockfile example

	LOCKFILE="/tmp/`basename $0`.lock"
	trap "echo Aborting!; rm $LOCKFILE; exit 1" SIGHUP SIGINT SIGTERM
	if [ -f $LOCKFILE ];
	then
	  ps -ef | grep "`basename $0`"
	  echo "$LOCKFILE: Lockfile exists."
	  exit 1
	fi
	touch $LOCKFILE
	# code
	rm $LOCKFILE
	exit 0

# Configure Automatic Logout (Linux)

## Bash

Found at [cyberciti.biz](http://www.cyberciti.biz/faq/appleosx-bsd-linux-unix-configure-automatic-logout-for-bash-shell):

	cat << EOF >/etc/profile.d/timeout-settings.sh
	#!/bin/bash
	TMOUT=300
	readonly TMOUT
	export TMOUT
EOF

## Screen

	vi ~/.screenrc
	idle 300 pow_detach
