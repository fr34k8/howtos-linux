# Disk ersetzen in einem Software RAID Array

Eine Geschichte die ich während der Zeit als Betreiber von
**[Swissjabber](http://www.swissjabber.ch)** erlebt habe.

Damals lief Swissjabber auf einem dedizierten Root-Server bei
[Nine](http://www.nine.ch) in Zürich. Der Server war mit einem
Software-RAID aufgesetzt. Die Applikations-Daten in einem mit
[Truecrypt](http://www.truecrypt.org) verschlüsseltem Container
gespeichert.

# Disk defect

Dann plötzlich fällt eine Disk aus:

    /dev/sda Defect
    /dev/sdb Active sync

Die Disk in den Zustand **fail** versetzen und das **muss** für jedes
Array gemacht werden bei welchem */dev/sda* im Einsatz war:

    mdadm /dev/mdN -f /dev/sdaN

Und jetzt die Disk komplett aus dem Array entfernen. Auch das für jedes
Array wo die Disk im Einsatz war:

    mdadm /dev/mdN -r /dev/sdaN

# Disk im Betrieb austauschen

Wurde die neue Disk vom Support angeschlossen, weisen wir Linux an, den
ATA/SCSI Bus zu scannen, damit die neue Disk gefunden wird.

    apt-get install scsiadd
    scsiadd -s

Wir prüfen ob die Disk bereits ansprechbar ist:

    fdisk -l /dev/sda

Nun kopieren wir die *Platten Geometrie* der noch aktiven Platte auf die
neue:

    sfdisk -d /dev/sdb | sfdisk /dev/sda
    fdisk -l /dev/sda

Wurde die Plattengeometrie erfolgreich übertragen, fügen wir wir die
Partitionen wieder zum Array hinzufügen (für jedes Array einzeln):

    mdadm -a /dev/mdN /dev/sdaN

# Logfiles

Das Raid Subsystem von Linux beginnt nun sofort mit dem Rebuild aller
Arrays. Dies überprüfen wir in */var/log/kern.log*:

    08:28:34  kernel: I/O error, dev sda, sector 431499907
    08:28:34  kernel: sd 0:0:0:0: SCSI error: return code = 0x00040000
    08:28:34  kernel: end_request: I/O error, dev sda, sector 431500195
    08:28:37  kernel: RAID1 conf printout:
    08:28:37  kernel: --- wd:1 rd:2
    08:28:37  kernel: disk 0, wo:1, o:0, dev:sda6
    08:28:37  kernel: disk 1, wo:0, o:1, dev:sdb6
    08:28:37  kernel: RAID1 conf printout:
    08:28:37  kernel: --- wd:1 rd:2
    08:28:37  kernel: disk 1, wo:0, o:1, dev:sdb6
    08:28:40  mdadm: Fail event detected on md device /dev/md4, component device /dev/sda6
    08:28:40  mdadm: Fail event detected on md device /dev/md3, component device /dev/sda5
    08:28:40  mdadm: SpareActive event detected on md device /dev/md4, component device /dev/sda6
    09:49:45  mdadm: Fail event detected on md device /dev/md0, component device /dev/sda1
    10:09:34  mdadm: Fail event detected on md device /dev/md1, component device /dev/sda2
    10:10:11  mdadm: Fail event detected on md device /dev/md2, component device /dev/sda3
    12:37:35  mdadm: RebuildStarted event detected on md device /dev/md0
    12:37:36  mdadm: RebuildFinished event detected on md device /dev/md0
    12:37:36  mdadm: SpareActive event detected on md device /dev/md0, component device /dev/sda1
    12:42:25  mdadm: RebuildStarted event detected on md device /dev/md1
    12:42:55  mdadm: RebuildFinished event detected on md device /dev/md1
    12:42:55  mdadm: SpareActive event detected on md device /dev/md1, component device /dev/sda2
    12:44:17  mdadm: RebuildStarted event detected on md device /dev/md3
    12:45:17  mdadm: Rebuild80 event detected on md device /dev/md3
    12:45:21  mdadm: RebuildFinished event detected on md device /dev/md3
    12:45:21  mdadm: SpareActive event detected on md device /dev/md3, component device /dev/sda5
    12:48:25  mdadm: RebuildStarted event detected on md device /dev/md2
    12:48:39  mdadm: RebuildFinished event detected on md device /dev/md2
    12:48:39  mdadm: SpareActive event detected on md device /dev/md2, component device /dev/sda3
    12:52:38  mdadm: RebuildStarted event detected on md device /dev/md4
    13:11:38  mdadm: Rebuild20 event detected on md device /dev/md4
    13:29:38  mdadm: Rebuild40 event detected on md device /dev/md4
    13:50:38  mdadm: Rebuild60 event detected on md device /dev/md4
    14:15:38  mdadm: Rebuild80 event detected on md device /dev/md4
    14:46:37  mdadm: RebuildFinished event detected on md device /dev/md4
    14:46:37  mdadm: SpareActive event detected on md device /dev/md4, component device /dev/sda6
    14:46:37  mdadm: RebuildFinished event detected on md device /dev/md4
