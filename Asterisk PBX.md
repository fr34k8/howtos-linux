# Asterisk configure to receive incoming sip calls

    apt-get install asterisk asterisk-prompt-de

## asterisk.conf

	vi /etc/asterisk/asterisk.conf
	defaultlanguage = de

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
	[default_bridge]
	type=bridge
	language=de

	[rec_bridge]
	type=bridge
	language=de
	record_conference=yes

	[admin_user]
	type=user
	admin=yes
	marked=yes
	announce_user_count=yes
	announce_user_count_all=no
	dsp_drop_silence=yes
	denoise=yes
	music_on_hold_when_empty=yes
	music_on_hold_class=music1

	[moderated_user]
	type=user
	wait_marked=yes
	announce_user_count=yes
	announce_user_count_all=no
	dsp_drop_silence=yes
	denoise=yes
	music_on_hold_when_empty=yes
	music_on_hold_class=music1
	pin=1234

Documentation about [ConfBridge](https://wiki.asterisk.org/wiki/display/AST/ConfBridge) is here.

## extensions.conf

	vi /etc/asterisk/extensions.conf
	[music1]
	exten => _X.,1,Set(number=${EXTEN})
	exten => _X.,2,Answer
	exten => _X.,3,Wait(1)
	exten => _X.,4,MusicOnHold(music1)
	exten => h,1,Set(subject="${CALLERID(num)} nach ${number} (blockiert), war ${CDR(duration)} Sekundenverbunden")
	exten => h,2,System(echo ${subject} | mail -s ${subject} user@domain.tld)

	[music3]
	exten => _X.,1,Set(number=${EXTEN})
	exten => _X.,2,Answer
	exten => _X.,3,Wait(1)
	exten => _X.,4,SetMusicOnHold(music1)
	exten => _X.,5,Dial(SIP/031xyz@netvoip,30,tgm)
	exten => h,1,Set(subject="${CALLERID(num)} nach ${number} (weiterleitung), war ${CDR(duration)} Sekundenverbunden")
	exten => h,2,System(echo ${subject} | mail -s ${subject} user@domain.tld)

	[conf1]
	exten => _X.,1,Set(number=${EXTEN})
	exten => _X.,2,Answer
	exten => _X.,3,Wait(1)
	exten => _X.,4,GotoIf($["${CALLERID(num)}" = "031xyz"]?conf1,${EXTEN},5:6)
	exten => _X.,5,ConfBridge(1,default_bridge,admin_user,sample_admin_menu)
	exten => _X.,6,ConfBridge(1,default_bridge,moderated_user,sample_user_menu)
	exten => h,1,Set(subject="${CALLERID(num)} nach ${number} (ConfBridge), war ${CDR(duration)} Sekunden verbunden")
	exten => h,2,System(echo ${subject} | mail -s ${subject} user@domain.tld)

	[sip_incoming]

	; Route 031xyz direct to the conference app
	exten => 031xyz,1,Goto(conf1,${EXTEN},1)

	; route callerid|EXTEN based to a context
	exten => _X.,1,GotoIf($["${CALLERID(num)}" = "058xyz"]?conf1,${EXTEN},1)
	exten => _X.,2,GotoIf($["${EXTEN}" = "033xyz"]?music1,${EXTEN},1)
	; Only allow mobile Numbers 076 - 079. Block all other calls
	exten => _X.,3,Set(regx=^[0][6-9])
	exten => _X.,4,GotoIf($[${REGEX("${regx}" ${CALLERID(num)})} = 1]?music1,${EXTEN},1:conf1,${EXTEN},1)
	; Ohne Hangup() wird via SIP ein 404 not found zurückgesendet

	[catchall]
	; for security reason

	asterisk -vvvR
	localhost*CLI> reload

Tested with Asterisk PBX 11.13

# Links

* [How to hack the FreePBX blacklist for better call blocking capability ](http://tech.iprock.com/?p=10261)
