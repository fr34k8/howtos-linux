# How to configure an asterisk pbx

## Install

    apt-get install asterisk asterisk-prompt-de

## General settings

	vi /etc/asterisk/asterisk.conf
	defaultlanguage = de

	vi /etc/asterisk/skinny.conf
	bindaddr=127.0.0.1

## Security settings

	vi /etc/asterisk/sip.conf
	context=catchall
	allowguest=no
	alwaysauthreject=yes
	; Enable IPv6 listening
	udpbindaddr=::
	useragent=Asterisk PBX

	vi /etc/asterisk/extensions.conf
	[sip_incoming]
	[catchall]
	; for security reason

## Receive SIP calls

	vi /etc/asterisk/sip.conf
	[general]
	register => 031XXXXXX1:xyz@sip.netvoip.ch/031XXXXXX1
	[netvoip]
	type=peer
	username=031XXXXXX1
	secret=xyz
	host=sip.netvoip.ch
	insecure=invite
	context=sip_incoming
	nat=no
	; http://www.voip-info.org/wiki/view/ITU+G.711
	allow=!all,g722,alaw,ulaw

More info [about codecs in europe](http://www.voip-info.org/wiki/view/ITU+G.711).

	vi /etc/asterisk/extensions.conf

	[forward_to_mobile]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,SetMusicOnHold(music1)
	exten => _X.,4,Dial(SIP/079xyz@netvoip,120,tgm)
	exten => h,1,Hangup

## Hear some music on hold

	vi /etc/asterisk/musiconhold.conf
	; apt-get install mpg123
	[music1]
	mode=custom
	application=/usr/bin/mpg123 -q -r 8000 -f 8192 -b 2048 --mono -s http://stream.url

	[music2]
	mode=files
	directory=/var/lib/asterisk/sounds/custom

	vi /etc/asterisk/extensions.conf
	[music1]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,MusicOnHold(music1)
	exten => h,1,Hangup

	[sip_incomming]
	exten => 031xyz,1,Goto(music1,${EXTEN},1)

## Create a Conference call

Documentation about [ConfBridge](https://wiki.asterisk.org/wiki/display/AST/ConfBridge) is here:

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
	pin=1234

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

	vi /etc/asterisk/extensions.conf

	[conf1]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,GotoIf($["${CALLERID(num)}" = "079xyz"]?conf1,${EXTEN},4:5)
	exten => _X.,4,ConfBridge(1,default_bridge,admin_user,sample_admin_menu)
	exten => _X.,5,ConfBridge(1,default_bridge,moderated_user,sample_user_menu)
	exten => h,1,Hangup

	[sip_incomming]
	exten => 031xyz,1,Goto(conf1,${EXTEN},1)

## Voicemail system

	vi /etc/asterisk/voicemail.conf
	[general]
	serveremail = asterisk@domain.tld
	emailsubject=[Asterisk PBX]: Neue Sprachnachricht ${VM_MSGNUM} (${VM_DUR} Minuten) von ${VM_CALLERID} in mailbox ${VM_MAILBOX} 
	emailbody=Dein --Asterisk\n
	[default]
	031xyz1 => 1234, firstname, user@domain.tld
	031xyz2 => 1234, firstname, user@domain.tld
	031xyz3 => 1234, firstname, user@domain.tld

	vi /etc/asterisk/extensions.conf
	[voicemail]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,Voicemail(${EXTEN},u)
	exten => h,4,Hangup

	[voicemailmain]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,VoicemailMain(${CALLERID(num)})
	exten => h,4,Hangup

	[sip_incomming]
	exten => 031xyz1,1,Goto(voicemail,${EXTEN},1)
	exten => 031xyz2,1,Goto(voicemailmain,${EXTEN},1)

## Create a menu system for testing

	vi /etc/asterisk/extensions.conf
	[menu]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,Read(Digits,demo-congrats)
	exten => _X.,4,SayDigits(${Digits})
	exten => _X.,5,GotoIf($["${Digits}" = "1"]?context1,${EXTEN},1)
	exten => _X.,6,GotoIf($["${Digits}" = "2"]?context2,${EXTEN},1)
	exten => _X.,7,GotoIf($["${Digits}" = "3"]?context3,${EXTEN},1)
	exten => _X.,8,GotoIf($["${Digits}" = "0"]?menu,h,1)
	exten => _X.,9,Goto(outgoing_sipcall,${EXTEN},1)
	exten => h,1,Hangup

	[context1]
	exten => _X.,1,Answer
	exten => _X.,2,Hangup
	[context2]
	exten => _X.,1,Answer
	exten => _X.,2,Hangup
	[context3]
	exten => _X.,1,Answer
	exten => _X.,2,Hangup

	[sip_incomming]
	exten => 031xyz1,1,Goto(menu,${EXTEN},1)

## Create a dialout app

	vi /etc/asterisk/extensions.conf
	[outgoing_sipcall]
	exten => _X.,1,Answer
	exten => _X.,2,Wait(1)
	exten => _X.,3,Read(Digits,pbx-transfer)
	exten => _X.,4,SayDigits(${Digits})
	exten => _X.,5,Dial(SIP/${Digits}@netvoip,120,tg)
	exten => _X.,6,Goto(menu,${EXTEN},3)

	[sip_incomming]
	exten => 031xyz1,1,Goto(outgoing_sipcall,${EXTEN},1)

## Tipps with extensions.conf

	vi /etc/asterisk/extensions.conf
	; Send an e-mail for information.
	exten => h,1,Set(subject="${CALLERID(num)} nach ${CDR(dst)} (Maba-Call), war ${CDR(duration)} Sekunden verbunden")
	exten => h,2,System(echo ${subject} | mail -s ${subject} user@domain.tld)

	; Goto without if
	exten => 031xyz,1,Goto(conf1,${EXTEN},1)

	; Goto with if
	exten => _X.,1,GotoIf($["${CALLERID(num)}" = "058xyz"]?conf1,${EXTEN},1)

	; Goto with if and else
	exten => _X.,4,GotoIf($[${REGEX("${regx}" ${CALLERID(num)})} = 1]?music1,${EXTEN},1:conf1,${EXTEN},1)

	; Regex: only allow mobile Numbers 076 - 079. Block all other calls
	exten => _X.,3,Set(regx=[7][6-9])
	exten => _X.,4,GotoIf($[${REGEX("${regx}" ${CALLERID(num)})} = 1]?music1,${EXTEN},1:conf1,${EXTEN},1)

	; If we do not execute a Hangup(), asterisk will response a 404 (not found) to the sip server

## Asterisk console

	asterisk -vvvR
	localhost*CLI> reload

Tested with Asterisk PBX 11.13

# Links

* [How to hack the FreePBX blacklist for better call blocking capability ](http://tech.iprock.com/?p=10261)
