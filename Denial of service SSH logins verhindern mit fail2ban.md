---
date: 2014-03-14
title: Denial of Serivce SSH Logins verhindern mit fail2ban
...
# Denial of Serivce SSH Logins verhindern mit fail2ban

Früher verschob ich den standard Port für ssh auf einen nicht Standard
Port. Damit konnte ich viele Attacken (**denial of service**)
unterbinden. Heute sind diese Angriffe auf Systeme viel ausgeklügelter.
Ein sehr wirkungsvolles Tool ist **fail2ban**, welches Du fast in jeder
Linux Distribution findest und es ist ausserdem einfach zu
konfigurieren. Ich nutze es unter anderem, um den **ssh login** zu
schützen.

Die Installation unter Debian ist wie immer ganz einfach.

    apt-get install fail2ban

Mit dem **fail2ban-client** lässt sich der Status und die aktuelle
Konfiuration prüfen:

    fail2ban-client ping
    fail2ban-client status

# Konfiguration

Die Basiskonfiguration findet sich im Ordner **/etc/fail2ban** in der
Datei **jail.conf**. Alle Abweichungen, oder anders formuliert, so wie
Du die Konfiguration haben möchtest, schreibst Du in die Datei
**jail.local.**

    vi /etc/fail2ban/jail.local
    [ssh]                                                                           
    bantime  = 86400  ; 1 day                                                       
    [apache]                                                                        
    enabled  = true                                                                 
    bantime  = 86400  ; 1 day                                                       
    [ssh-ddos]                                                                      
    enabled  = true                                                                 
    bantime  = 86400  ; 1 day                                                       
    [postfix]                                                                       
    enabled  = true                                                                 
    bantime  = 86400  ; 1 day                                                       
    [apache-noscript]                                                               
    enabled  = true                                                                 
    bantime  = 86400  ; 1 day                                                       
    [apache-overflows]                                                              
    enabled  = true                                                                 
    bantime  = 86400  ; 1 day

Damit wir bei jeder **fail2ban** Massnahme mitbekommen was geschieht,
ändern wir noch eine Zeile in der Datei **jail.conf** auf

    vi /etc/fail2ban/jail.conf
    # Choose default action.  To change, just override value
    # of 'action' with the   
    # interpolation to the chosen action shortcut (e.g.
    # action_mw, action_mwl, etc) in jail.local                                                                  
    # globally (section [DEFAULT]) or per specific section
    action = %(action_mwl)s

Damit erhältst Du jedesmal eine E-Mail mit einem whois Report und den
relevanten Logzeilen weshalb fail2ban die IP gesperrt hat.

# Reload Konfiguration

     
    service fail2ban restart
    fail2ban-client status
    Status
    |- Number of jail:      6
    `- Jail list:           apache-overflows, apache-noscript, ssh,
    postfix, apache, ssh-ddos

# Zusammenfassung

**fail2ban** kennt verschiedenste Techniken. In der Basiskonfiguration
wird eine IP mittels iptables gesperrt und nach einer gewissen Zeit
wieder freigegeben. Das Tool überprüft die Logfiles von über 47
verschiedenen Diensten und sperrt fremde IP's wenn eines der
Angriffsmuster auftritt.

