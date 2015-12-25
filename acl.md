# Setzen und Löschen von Default-ACLs

Remove recursive all acls:

	setfacl -R -b folder/

Initiales Setzen rekursiv: 

	setfacl -R -m u:user1:rwX,u:user2:rwX folder/

**default-acl** für den Ordner und alle zukünftigen Dateien und Ordner:

	setfacl -R -d -m u:user1:rwX,u:user2:rwX folder/

# Links

<https://wiki.ubuntuusers.de/ACL>
