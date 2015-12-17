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
	; Enable IPv6 listening
	udpbindaddr=::
	useragent=Asterisk PBX
	[netvoip]
	type=peer
	username=031XXXXXX1
	secret=xyz
	host=sip.netvoip.ch
	insecure=invite
	context=sip_incoming
	nat=no
	; http://www.voip-info.org/wiki/view/ITU+G.711
	allow=!all,g722,alaw

<http://www.voip-info.org/wiki/view/Asterisk+codecs>

## skinny.conf

	vi /etc/asterisk/skinny.conf
	bindaddr=127.0.0.1

## musiconhold.conf

	; apt-get install mpg123
	[music1]
	mode=custom
	application=/usr/bin/mpg123 -q -r 8000 -f 8192 -b 2048 --mono -s http://stream.url

	[music2]
	mode=files
	directory=/var/lib/asterisk/sounds/custom

## confbridge.conf

	vi /etc/asterisk/confbridge.conf
	[general]
	...
	[my_pin_user]
	type=user
	music_on_hold_when_empty=yes
	music_on_hold_class=music1
	userunce_user_count=yes
	announce_user_count_all=no
	announce_only_user=yes
	dsp_drop_silence=yes
	denoise=yes
	pin=1234

Documentation about [ConfBridge](https://wiki.asterisk.org/wiki/display/AST/ConfBridge) is here.

## extensions.conf

	vi /etc/asterisk/extensions.conf
	[music1]
	exten => _X.,1,Answer
	exten => _X.,2,System(echo "Asterisk"|mail -s "${CALLERID(num)} nach ${EXTEN} blockiert" user@domain.tld)
	exten => _X.,3,MusicOnHold(music1)
	exten => _X.,4,Hangup

	[music2]
	exten => _X.,1,Answer
	exten => _X.,2,System(echo "Asterisk"|mail -s "${CALLERID(num)} nach ${EXTEN} blockiert" user@domain.tld)
	exten => _X.,3,MusicOnHold(music1)
	exten => _X.,4,Hangup

	[music3]
	exten => _X.,1,System(echo "Asterisk"|mail -s "${CALLERID(num)} nach ${EXTEN} umgeleitet" user@domain.tld)
	exten => _X.,2,Answer
	exten => _X.,3,SetMusicOnHold(music1)
	exten => _X.,4,Dial(SIP/031xyz@netvoip,30,tgm)
	exten => _X.,5,Hangup

	[conf1]
	exten => _X.,1,System(echo "Asterisk"|mail -s "${CALLERID(num)} nach ${EXTEN} added to ConfBridge" user@domain.tld)
	exten => _X.,1,Answer
	exten => _X.,2,ConfBridge(1,,my_pin_user,sample_admin_menu)
	exten => _X.,3,Hangup

	[sip_incoming]
	exten => _X.,1,GotoIf($["${CALLERID(num)}" = "058xyz"]?conf1,${EXTEN},1)
	exten => _X.,2,GotoIf($["${EXTEN}" = "033xyz"]?music1,${EXTEN},1)
	exten => _X.,3,GotoIf($["${EXTEN}" = "031xyz"]?music2,${EXTEN},1)
	; Only allow mobile Numbers 076 - 079. Block all other calls
	exten => _X.,4,Set(regx=^[0][6-9])
	exten => _X.,5,GotoIf($[${REGEX("${regx}" ${CALLERID(num)})} = 1]?music1,${EXTEN},1:conf1,${EXTEN},1)
	; Ohne Hangup() wird via SIP ein 404 not found zurückgesendet

	[catchall]
	; for security reason

	asterisk -vvvR
	localhost*CLI> reload

Tested with Asterisk PBX 11.13

# Links

* [How to hack the FreePBX blacklist for better call blocking capability ](http://tech.iprock.com/?p=10261)
