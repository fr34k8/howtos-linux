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
