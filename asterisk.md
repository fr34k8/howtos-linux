# Asterisk configure to receive incoming sip calls

    apt-get install asterisk

## sip.conf

	vi /etc/asterisk/sip.conf
	[general]
	register => 031XXXXXX1:xyz@sip.netvoip.ch/031XXXXXX1
	register => 031XXXXXX2:xyz@sip.netvoip.ch/031XXXXXX2
	; for security reason
	context=catchall
	allowguest=no
	alwaysauthreject=yes
	[netvoip]
	type=peer
	username=031XXXXXX1
	secret=xyz
	host=sip.netvoip.ch
	insecure=invite
	context=netvoip_in
	nat=no
	disallow=all
	allow=alaw 

<http://www.voip-info.org/wiki/view/Asterisk+codecs>

## skinny.conf

	vi /etc/asterisk/skinny.conf
	bindaddr=127.0.0.1

## musiconhold.conf

	[rabe]
	mode=custom
	application=/usr/bin/mpg123 -q -r 8000 -f 8192 -b 2048 --mono -s http://stream.rabe.ch:8000/livestream/rabe-mid.mp3

## extensions.conf

	vi /etc/asterisk/extensions.conf
	[netvoip_in]

	; Only allow mobile Numbers 076 - 079. Block all other calls
	exten => _X.,1,Set(regx=^[0][3-9])
	exten => _X.,2,GotoIf($[${REGEX("${regx}" ${CALLERID(num)})} = 1]?20:90)

	exten => _X.,20,GotoIf($["${EXTEN}" = "031xyz"]?90:21)
	exten => _X.,21,System(echo "Asterisk"|mail -s "Anruf von ${CALLERID(num)} nach ${EXTEN} umgeleitet" user@domain.tld)
	exten => _X.,22,Answer
	exten => _X.,23,Dial(SIP/031xyz@netvoip,30,trg)
	exten => _X.,24,Hangup

	exten => _X.,90,System(echo "Asterisk"|mail -s "Anruf von ${CALLERID(num)} nach ${EXTEN} blockiert" user@domain.tld)
	exten => _X.,91,Hangup

	; Ohne Hangup() wird via SIP ein 404 not found zurückgesendet

	[catchall]
	; for security reason

	asterisk -R
	localhost*CLI> reload

# Links

* [How to hack the FreePBX blacklist for better call blocking capability ](http://tech.iprock.com/?p=10261)
