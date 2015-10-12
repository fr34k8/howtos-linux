# Setzen und Löschen von Default-ACLs

Remove recursive all acls:

	setfacl -R -b folder/

Initiales Setzen rekursiv: 

	setfacl -R -m u:user1:rwx,u:user2:rwx folder/

**default-acl** für den Ordner und alle zukünftigen Dateien und Ordner:

	setfacl -d -m u:user1:rwx,u:user2:rwx folder/

# Links

<https://wiki.ubuntuusers.de/ACL>
